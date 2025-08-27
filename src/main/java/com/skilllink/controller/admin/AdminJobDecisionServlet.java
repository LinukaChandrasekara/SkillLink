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
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet(name="AdminJobDecisionServlet", urlPatterns={"/admin/jobs/decide"})
public class AdminJobDecisionServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        long jobId = Long.parseLong(req.getParameter("jobId"));
        String decision = req.getParameter("decision"); // approve | reject
        String newStatus = "approve".equalsIgnoreCase(decision) ? "approved" : "denied";

        final String sql =
            "UPDATE job_posts " +
            "SET status=?, reviewer_admin_id=?, reviewed_at=NOW() " +
            "WHERE job_id=? AND status='pending'";

        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, me.getUserId());
            ps.setLong(3, jobId);
            int n = ps.executeUpdate();
            String msg = (n>0)
                    ? ("approved".equals(newStatus) ? "Job%20approved" : "Job%20rejected")
                    : "No%20pending%20job%20to%20update";
            resp.sendRedirect(req.getContextPath()+"/admin/jobs?success=" + msg);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/admin/jobs?error=Failed%20to%20update%20job");
        }
    }
}
