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

@WebServlet(name="AdminJobsServlet", urlPatterns={"/admin/jobs"})
public class AdminJobsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // --- DTOs for the view (must have getters for EL/JSTL) ---
    public static class PendingCard {
        private long jobId;
        private long clientId;
        private String title;
        private String description;
        private String categoryName;
        private String clientName;
        private String locationText;
        private String budgetAmount; // kept as String for easy print

        public long getJobId() { return jobId; }
        public void setJobId(long jobId) { this.jobId = jobId; }

        public long getClientId() { return clientId; }
        public void setClientId(long clientId) { this.clientId = clientId; }

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

        public String getClientName() { return clientName; }
        public void setClientName(String clientName) { this.clientName = clientName; }

        public String getLocationText() { return locationText; }
        public void setLocationText(String locationText) { this.locationText = locationText; }

        public String getBudgetAmount() { return budgetAmount; }
        public void setBudgetAmount(String budgetAmount) { this.budgetAmount = budgetAmount; }
    }

    public static class ApprovedRow {
        private String title;
        private String clientName;
        private String categoryName;
        private String budgetAmount;
        private String approvedOn;

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getClientName() { return clientName; }
        public void setClientName(String clientName) { this.clientName = clientName; }

        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

        public String getBudgetAmount() { return budgetAmount; }
        public void setBudgetAmount(String budgetAmount) { this.budgetAmount = budgetAmount; }

        public String getApprovedOn() { return approvedOn; }
        public void setApprovedOn(String approvedOn) { this.approvedOn = approvedOn; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)? null : (User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        req.setAttribute("pending", fetchPending());
        req.setAttribute("approved", fetchApproved());
        req.setAttribute("pendingCount", countByStatus("pending"));
        req.setAttribute("approvedCount", countByStatus("approved"));

        req.getRequestDispatcher("/views/admin/admin-jobs.jsp").forward(req, resp);
    }

    private List<PendingCard> fetchPending() {
        final String sql =
            "SELECT j.job_id, j.client_id, j.title, j.description, j.budget_amount, j.location_text, " +
            "       jc.name AS category_name, u.full_name AS client_name " +
            "FROM job_posts j " +
            "JOIN job_categories jc ON jc.job_category_id = j.job_category_id " +
            "JOIN users u ON u.user_id = j.client_id " +
            "WHERE j.status='pending' " +
            "ORDER BY j.created_at ASC";
        List<PendingCard> list = new ArrayList<>();
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PendingCard p = new PendingCard();
                p.setJobId(rs.getLong("job_id"));
                p.setClientId(rs.getLong("client_id"));
                p.setTitle(rs.getString("title"));
                p.setDescription(rs.getString("description"));
                p.setLocationText(rs.getString("location_text"));
                p.setCategoryName(rs.getString("category_name"));
                p.setClientName(rs.getString("client_name"));
                p.setBudgetAmount(rs.getBigDecimal("budget_amount").toPlainString());
                list.add(p);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return list;
    }

    private List<ApprovedRow> fetchApproved() {
        final String sql =
            "SELECT j.title, u.full_name AS client_name, jc.name AS category_name, " +
            "       j.budget_amount, j.reviewed_at " +
            "FROM job_posts j " +
            "JOIN job_categories jc ON jc.job_category_id = j.job_category_id " +
            "JOIN users u ON u.user_id = j.client_id " +
            "WHERE j.status='approved' " +
            "ORDER BY j.reviewed_at DESC";
        List<ApprovedRow> out = new ArrayList<>();
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ApprovedRow a = new ApprovedRow();
                a.setTitle(rs.getString("title"));
                a.setClientName(rs.getString("client_name"));
                a.setCategoryName(rs.getString("category_name"));
                a.setBudgetAmount(rs.getBigDecimal("budget_amount").toPlainString());
                Timestamp t = rs.getTimestamp("reviewed_at");
                a.setApprovedOn(t == null ? "-" : t.toString());
                out.add(a);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return out;
    }

    private long countByStatus(String status) {
        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM job_posts WHERE status=?")) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next()? rs.getLong(1) : 0L;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}

