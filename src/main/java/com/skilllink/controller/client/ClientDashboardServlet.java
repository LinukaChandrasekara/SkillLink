package com.skilllink.controller.client;

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
import java.util.*;

@WebServlet(name="ClientDashboardServlet", urlPatterns={"/client/dashboard"})
public class ClientDashboardServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public static class Stats {
        public long getJobsPosted() {
			return jobsPosted;
		}
		public void setJobsPosted(long jobsPosted) {
			this.jobsPosted = jobsPosted;
		}
		public long getHired() {
			return hired;
		}
		public void setHired(long hired) {
			this.hired = hired;
		}
		public long getPendingPosts() {
			return pendingPosts;
		}
		public void setPendingPosts(long pendingPosts) {
			this.pendingPosts = pendingPosts;
		}
		public long jobsPosted;
        public long hired;
        public long pendingPosts;
    }

    public static class CompletedRow {
        public long getJobId() {
			return jobId;
		}
		public void setJobId(long jobId) {
			this.jobId = jobId;
		}
		public String getTitle() {
			return title;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public long getWorkerId() {
			return workerId;
		}
		public void setWorkerId(long workerId) {
			this.workerId = workerId;
		}
		public String getWorkerName() {
			return workerName;
		}
		public void setWorkerName(String workerName) {
			this.workerName = workerName;
		}
		public long jobId;
        public String title;
        public long workerId;
        public String workerName;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        long clientId = me.getUserId();

        try (Connection c = DB.getConnection()) {
            // 1) profile light
            req.setAttribute("profile", fetchProfile(c, clientId));

            // 2) verification status
            String verif = fetchVerificationStatus(c, clientId);
            req.setAttribute("verificationStatus", verif);

            // 3) stats
            Stats stats = new Stats();
            stats.jobsPosted   = scalar(c, "SELECT COUNT(*) FROM job_posts WHERE client_id=?", clientId);
            // Treat Hired as jobs that went past approval: approved/closed/completed
            stats.hired        = scalar(c, "SELECT COUNT(*) FROM job_posts WHERE client_id=? AND status IN ('approved','closed','completed')", clientId);
            stats.pendingPosts = scalar(c, "SELECT COUNT(*) FROM job_posts WHERE client_id=? AND status='pending'", clientId);
            req.setAttribute("stats", stats);

            // 4) completed jobs needing review (worker may be unknown; join reviews to exclude already reviewed)
            req.setAttribute("completed", completedNeedingReview(c, clientId));
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher("/views/client/client-dashboard.jsp").forward(req, resp);
    }

    private Map<String,Object> fetchProfile(Connection c, long userId) throws SQLException {
        final String sql = "SELECT full_name, address_line, bio FROM users WHERE user_id=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                Map<String,Object> m = new HashMap<>();
                if (rs.next()) {
                    m.put("fullName", rs.getString("full_name"));
                    m.put("addressLine", rs.getString("address_line"));
                    m.put("bio", rs.getString("bio"));
                }
                return m;
            }
        }
    }

    private String fetchVerificationStatus(Connection c, long userId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement("SELECT verification_status FROM users WHERE user_id=?")) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
                return "unverified";
            }
        }
    }

    private long scalar(Connection c, String sql, long id) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        }
    }

    private List<CompletedRow> completedNeedingReview(Connection c, long clientId) throws SQLException {
        final String sql =
            "SELECT j.job_id, j.title, " +
            // Best-effort: worker might be unknown until review; show last worker who messaged on job conv if present, else 0
            "COALESCE(v.worker_id, 0) AS worker_id, u.full_name AS worker_name " +
            "FROM job_posts j " +
            "LEFT JOIN reviews r ON r.job_id=j.job_id AND r.client_id=? " +
            "LEFT JOIN (" +
            "   SELECT r2.job_id, r2.worker_id FROM reviews r2 WHERE r2.client_id=? " +
            ") v ON v.job_id=j.job_id " +
            "LEFT JOIN users u ON u.user_id = v.worker_id " +
            "WHERE j.client_id=? AND j.status='completed' AND r.review_id IS NULL " +
            "ORDER BY j.updated_at DESC LIMIT 20";
        List<CompletedRow> out = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, clientId);
            ps.setLong(2, clientId);
            ps.setLong(3, clientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CompletedRow cr = new CompletedRow();
                    cr.jobId = rs.getLong("job_id");
                    cr.title = rs.getString("title");
                    cr.workerId = rs.getLong("worker_id");
                    cr.workerName = rs.getString("worker_name");
                    if (cr.workerName == null || cr.workerName.isBlank()) cr.workerName = "—";
                    out.add(cr);
                }
            }
        }
        return out;
    }
}
