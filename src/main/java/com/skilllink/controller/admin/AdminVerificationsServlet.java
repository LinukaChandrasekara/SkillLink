package com.skilllink.controller.admin;

import com.skilllink.dao.jdbc.DB;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name="AdminVerificationsServlet", urlPatterns={"/admin/verifications"})
public class AdminVerificationsServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	// --- simple DTOs for the JSP ---
    public static class PendingRow {
        private long submissionId, userId;
        private String fullName, username, roleName, jobCategoryName, createdAt;
        public long getSubmissionId(){return submissionId;} public long getUserId(){return userId;}
        public String getFullName(){return fullName;} public String getUsername(){return username;}
        public String getRoleName(){return roleName;} public String getJobCategoryName(){return jobCategoryName;}
        public String getCreatedAt(){return createdAt;}
    }
    public static class VerifiedRow {
        private long userId; private String fullName, roleName, verifiedOn;
        public long getUserId(){return userId;} public String getFullName(){return fullName;}
        public String getRoleName(){return roleName;} public String getVerifiedOn(){return verifiedOn;}
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Guard
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        req.setAttribute("pending", fetchPending());
        req.setAttribute("verified", fetchVerified());
        req.setAttribute("pendingCount", countPending());
        req.setAttribute("verifiedCount", countVerified());

        req.getRequestDispatcher("/views/admin/admin-verifications.jsp").forward(req, resp);
    }

    private List<PendingRow> fetchPending() {
        final String sql =
            "SELECT vs.submission_id, vs.user_id, vs.created_at, " +
            "       u.full_name, u.username, r.role_name, " +
            "       jc.name AS job_category_name " +
            "FROM verification_submissions vs " +
            "JOIN users u ON u.user_id = vs.user_id " +
            "JOIN roles r ON r.role_id = u.role_id " +
            "LEFT JOIN workers w ON w.user_id = u.user_id " +
            "LEFT JOIN job_categories jc ON jc.job_category_id = w.job_category_id " +
            "WHERE vs.status='pending' " +
            "ORDER BY vs.created_at ASC";
        List<PendingRow> out = new ArrayList<>();
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PendingRow pr = new PendingRow();
                pr.submissionId = rs.getLong("submission_id");
                pr.userId = rs.getLong("user_id");
                pr.fullName = rs.getString("full_name");
                pr.username = rs.getString("username");
                pr.roleName = rs.getString("role_name");
                pr.jobCategoryName = rs.getString("job_category_name");
                pr.createdAt = rs.getTimestamp("created_at").toString();
                out.add(pr);
            }
        } catch (SQLException e) { throw new RuntimeException(e); }
        return out;
    }

    private List<VerifiedRow> fetchVerified() {
        final String sql =
            "SELECT u.user_id, u.full_name, r.role_name, v.verified_on " +
            "FROM users u " +
            "JOIN roles r ON r.role_id = u.role_id " +
            "LEFT JOIN ( " +
            "  SELECT user_id, MAX(decided_at) AS verified_on " +
            "  FROM verification_submissions " +
            "  WHERE status = 'approved' " +
            "  GROUP BY user_id " +
            ") v ON v.user_id = u.user_id " +
            "WHERE u.verification_status = 'verified' " +
            "ORDER BY (v.verified_on IS NULL), v.verified_on DESC";

        List<VerifiedRow> out = new ArrayList<>();
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                VerifiedRow vr = new VerifiedRow();
                vr.userId = rs.getLong("user_id");
                vr.fullName = rs.getString("full_name");
                vr.roleName = rs.getString("role_name");
                Timestamp t = rs.getTimestamp("verified_on");
                vr.verifiedOn = (t == null ? "-" : t.toString());
                out.add(vr);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return out;
    }


    private long countPending() {
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM verification_submissions WHERE status='pending'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0L;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }

    private long countVerified() {
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM users WHERE verification_status='verified'");
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getLong(1) : 0L;
        } catch (SQLException e) { throw new RuntimeException(e); }
    }
}
