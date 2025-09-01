package com.skilllink.controller.client;

import com.skilllink.dao.jdbc.DB;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;


@MultipartConfig(maxFileSize = 32 * 1024 * 1024) // allow up to 10MB just in case
public class ClientIdUploadServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        Part file = req.getPart("id_photo");
        if (file == null || file.getSize() == 0) {
            resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=Please%20choose%20an%20image");
            return;
        }

        // Optional sanity check: ensure it looks like an image
        String ctype = file.getContentType();
        if (ctype == null || !ctype.toLowerCase().startsWith("image/")) {
            resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=Please%20upload%20an%20image%20file");
            return;
        }

        try (Connection c = DB.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement ps = c.prepareStatement(
                     "INSERT INTO verification_submissions(user_id, id_photo, status) VALUES (?,?, 'pending')")) {
                ps.setLong(1, me.getUserId());
                try (InputStream in = file.getInputStream()) {
                    // Use binary stream to avoid setBlob edge cases
                    ps.setBinaryStream(2, in, file.getSize());
                    ps.executeUpdate();
                }
            }

            try (PreparedStatement ps2 = c.prepareStatement(
                     "UPDATE users SET verification_status='pending' WHERE user_id=?")) {
                ps2.setLong(1, me.getUserId());
                ps2.executeUpdate();
            }

            c.commit();
            // Keep status in session for guards
            req.getSession().setAttribute("verificationStatus", "pending");
            resp.sendRedirect(req.getContextPath()+"/client/dashboard?success=ID%20uploaded.%20Status%20is%20now%20Pending");
        } catch (SQLException e) {
            // Helpful logging
            getServletContext().log("[ID Upload] SQLState=" + e.getSQLState() +
                    " Code=" + e.getErrorCode() + " Msg=" + e.getMessage(), e);

            String msg = "Upload%20failed";
            // FK violation
            if (e.getErrorCode() == 1452) {
                msg = "Upload%20failed:%20account%20not%20found%20in%20DB%20schema%20(check%20schema%20and%20FK)";
            }
            // Packet too large (ER_NET_PACKET_TOO_LARGE) often shows as Communications link failure before SQLState; we can’t always detect here.

            resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=" + msg);
        } catch (IllegalStateException ex) {
            // Thrown when file exceeds @MultipartConfig limits
            getServletContext().log("[ID Upload] File too large", ex);
            resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=File%20too%20large");
        }
    }
}
