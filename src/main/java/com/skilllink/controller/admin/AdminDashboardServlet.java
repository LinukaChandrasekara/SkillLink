package com.skilllink.controller.admin;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.dao.jdbc.JdbcJobPostDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.JobStatus;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name="AdminDashboardServlet", urlPatterns={"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();
    private final JobPostDAO jobDAO = new JdbcJobPostDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Guard: admin only
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        long totalUsers      = userDAO.countAll();
        long verifiedWorkers = countByRoleAndVerification("worker", "verified");
        long verifiedClients = countByRoleAndVerification("client", "verified");
        long pendingJobs     = jobDAO.countByStatus(JobStatus.PENDING);

        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("verifiedWorkers", verifiedWorkers);
        req.setAttribute("verifiedClients", verifiedClients);
        req.setAttribute("pendingJobs", pendingJobs);

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }

    /** Helper for role+verification pair without changing your other DAOs everywhere. */
    private long countByRoleAndVerification(String roleName, String status) {
        // Small, safe inline query using the existing connection helper:
        final String sql = "SELECT COUNT(*) " +
                "FROM users u JOIN roles r ON r.role_id=u.role_id " +
                "WHERE r.role_name=? AND u.verification_status=?";
        try (var c = com.skilllink.dao.jdbc.DB.getConnection();
             var ps = c.prepareStatement(sql)) {
            ps.setString(1, roleName);
            ps.setString(2, status);
            try (var rs = ps.executeQuery()) {
                return rs.next() ? rs.getLong(1) : 0L;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
