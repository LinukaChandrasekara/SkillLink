package com.skilllink.controller.media;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.VerificationSubmissionDAO;
import com.skilllink.dao.jdbc.DB;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.dao.jdbc.JdbcVerificationSubmissionDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URLConnection;
import java.sql.*;

import java.util.Base64;

@WebServlet(name="MediaServlet", urlPatterns={"/media/*"})
public class MediaServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();
    private final VerificationSubmissionDAO verDAO = new JdbcVerificationSubmissionDAO();

    // 1×1 transparent PNG (placeholder when no image available)
    private static final byte[] PLACEHOLDER_PNG = Base64.getDecoder().decode(
            "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg==");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("X-Content-Type-Options", "nosniff");

        String p = req.getPathInfo();
        if (p == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try {
            if (p.equals("/user/profile") || p.equals("/user/profile/")) {
                // Public-ish; typically used in admin/users list etc.
                handleUserProfile(req, resp);
            } else if (p.equals("/verification/photo") || p.equals("/verification/photo/")) {
                // Sensitive; admin only
                handleVerificationPhoto(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (IllegalArgumentException ex) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, ex.getMessage());
        } catch (Exception ex) {
            // Avoid leaking internals
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /** /media/user/profile?userId=N */
    private void handleUserProfile(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String id = req.getParameter("userId");
        if (id == null || id.isBlank()) throw new IllegalArgumentException("userId required");
        long userId = Long.parseLong(id);

        byte[] img = userDAO.getProfilePicture(userId);

        // Cache profile pictures for a day (change URL param when users update to bust cache)
        resp.setHeader("Cache-Control", "public, max-age=86400, immutable");
        streamImage(resp, img, "image/png", /*sendPlaceholder*/ true);
    }

    /** /media/verification/photo?submissionId=N  OR  ?userId=N (latest) */
    private void handleVerificationPhoto(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // Require admin
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.ADMIN) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        byte[] img = null;
        String sid = req.getParameter("submissionId");
        String uid = req.getParameter("userId");

        if (sid != null && !sid.isBlank()) {
            long submissionId = Long.parseLong(sid);
            img = verDAO.getPhoto(submissionId);
        } else if (uid != null && !uid.isBlank()) {
            long userId = Long.parseLong(uid);
            img = getLatestVerificationPhotoForUser(userId);
        } else {
            throw new IllegalArgumentException("submissionId or userId required");
        }

        // ID photos are sensitive → no-store
        resp.setHeader("Cache-Control", "no-store, max-age=0");
        // If missing, do NOT leak placeholder; return 404 for ID photos
        if (img == null || img.length == 0) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        streamImage(resp, img, "application/octet-stream", /*sendPlaceholder*/ false);
    }

    /** Query latest verification photo for a user (fallback path). */
    private byte[] getLatestVerificationPhotoForUser(long userId) {
        final String sql = "SELECT id_photo FROM verification_submissions " +
                           "WHERE user_id=? ORDER BY created_at DESC LIMIT 1";
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getBytes(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    /** Detect content type and stream bytes; optionally fall back to a tiny PNG placeholder. */
    private void streamImage(HttpServletResponse resp, byte[] data, String defaultType, boolean sendPlaceholderIfNull)
            throws IOException {

        byte[] out = data;
        if ((out == null || out.length == 0) && sendPlaceholderIfNull) {
            out = PLACEHOLDER_PNG;
            defaultType = "image/png";
        }

        if (out == null || out.length == 0) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String ct = guessContentType(out);
        resp.setContentType(ct != null ? ct : defaultType);
        resp.setContentLength(out.length);

        try (ServletOutputStream os = resp.getOutputStream()) {
            os.write(out);
            os.flush();
        }
    }

    /** Best-effort MIME sniffing for common image formats. */
    private static String guessContentType(byte[] bytes) {
        try {
            String byStream = URLConnection.guessContentTypeFromStream(new ByteArrayInputStream(bytes));
            if (byStream != null) return byStream;
        } catch (IOException ignored) {}

        // Magic numbers
        if (startsWith(bytes, new byte[]{(byte)0xFF,(byte)0xD8,(byte)0xFF})) return "image/jpeg";
        if (startsWith(bytes, new byte[]{(byte)0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A})) return "image/png";
        if (startsWith(bytes, "GIF87a".getBytes()) || startsWith(bytes, "GIF89a".getBytes())) return "image/gif";
        if (startsWith(bytes, "RIFF".getBytes()) && bytes.length>8 &&
            bytes[8]=='W' && bytes[9]=='E' && bytes[10]=='B' && bytes[11]=='P') return "image/webp";
        return null;
    }
    private static boolean startsWith(byte[] a, byte[] p) {
        if (a == null || p == null || a.length < p.length) return false;
        for (int i=0;i<p.length;i++) if (a[i]!=p[i]) return false;
        return true;
    }
}
