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

/**
 * Client dashboard:
 *  - Profile summary + verification chip
 *  - Stats (posted / hired / pending)
 *  - Completed jobs list (for reviews)
 */
@WebServlet(name = "ClientDashboardServlet", urlPatterns = {"/client/dashboard"})
public class ClientDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /* ---- DTOs kept as inner classes to match your current JSP ---- */

    public static class Stats {
        private long jobsPosted;
        private long hired;
        private long pendingPosts;
        public long getJobsPosted() { return jobsPosted; }
        public void setJobsPosted(long jobsPosted) { this.jobsPosted = jobsPosted; }
        public long getHired() { return hired; }
        public void setHired(long hired) { this.hired = hired; }
        public long getPendingPosts() { return pendingPosts; }
        public void setPendingPosts(long pendingPosts) { this.pendingPosts = pendingPosts; }
    }

    public static class CompletedRow {
        private long jobId;
        private String title;
        private long workerId;
        private String workerName;
        private boolean reviewed; // <- used by the JSP to show "Review" button or "Reviewed" badge

        public long getJobId() { return jobId; }
        public void setJobId(long jobId) { this.jobId = jobId; }
        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }
        public long getWorkerId() { return workerId; }
        public void setWorkerId(long workerId) { this.workerId = workerId; }
        public String getWorkerName() { return workerName; }
        public void setWorkerName(String workerName) { this.workerName = workerName; }
        public boolean isReviewed() { return reviewed; }
        public void setReviewed(boolean reviewed) { this.reviewed = reviewed; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }
        long clientId = me.getUserId();

        try (Connection c = DB.getConnection()) {
            // 1) lightweight profile for left card
            req.setAttribute("profile", fetchProfile(c, clientId));

            // 2) verification chip
            req.setAttribute("verificationStatus", fetchVerificationStatus(c, clientId));

            // 3) stats
            Stats stats = new Stats();
            stats.setJobsPosted(scalar(c,
                    "SELECT COUNT(*) FROM job_posts WHERE client_id=?",
                    clientId));
            // Hired = jobs that have a worker assigned (ja exists) in these states
            stats.setHired(scalar(c,
                    "SELECT COUNT(*) " +
                    "FROM job_assignments ja " +
                    "JOIN job_posts jp ON jp.job_id = ja.job_id " +
                    "WHERE jp.client_id=? AND ja.status IN ('accepted','in_progress','completed')",
                    clientId));
            stats.setPendingPosts(scalar(c,
                    "SELECT COUNT(*) FROM job_posts WHERE client_id=? AND status='pending'",
                    clientId));
            req.setAttribute("stats", stats);

            // 4) completed jobs (assignment-based) + whether reviewed
            req.setAttribute("completed", listCompleted(c, clientId, 50));

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher("/views/client/client-dashboard.jsp").forward(req, resp);
    }

    /* ------------------------- helpers ------------------------- */

    private Map<String, Object> fetchProfile(Connection c, long userId) throws SQLException {
        final String sql = "SELECT full_name, address_line, bio FROM users WHERE user_id=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                Map<String, Object> m = new HashMap<>();
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
        final String sql = "SELECT verification_status FROM users WHERE user_id=?";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getString(1) : "unverified";
            }
        }
    }

    private long scalar(Connection c, String sql, long p1) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, p1);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        }
    }

    /**
     * Completed jobs for this client (source of truth: job_assignments.status = 'completed').
     * We join reviews to know if the client has already reviewed that job.
     */
    private List<CompletedRow> listCompleted(Connection c, long clientId, int limit) throws SQLException {
        final String sql =
                "SELECT jp.job_id, jp.title, " +
                "       ja.worker_id, u.full_name AS worker_name, " +
                "       (r.review_id IS NOT NULL) AS reviewed " +
                "FROM job_assignments ja " +
                "JOIN job_posts jp ON jp.job_id = ja.job_id " +
                "JOIN users u ON u.user_id = ja.worker_id " +
                "LEFT JOIN reviews r ON r.job_id = jp.job_id AND r.client_id = jp.client_id " +
                "WHERE jp.client_id = ? AND ja.status = 'completed' " +
                "ORDER BY COALESCE(jp.updated_at, ja.assigned_at) DESC " +
                "LIMIT ?";
        List<CompletedRow> out = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setLong(1, clientId);
            ps.setInt(2, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CompletedRow row = new CompletedRow();
                    row.setJobId(rs.getLong("job_id"));
                    row.setTitle(rs.getString("title"));
                    row.setWorkerId(rs.getLong("worker_id"));
                    String name = rs.getString("worker_name");
                    row.setWorkerName((name == null || name.isBlank()) ? "—" : name);
                    row.setReviewed(rs.getBoolean("reviewed"));
                    out.add(row);
                }
            }
        }
        return out;
    }
}
