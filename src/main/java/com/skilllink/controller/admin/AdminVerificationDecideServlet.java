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

@WebServlet(name="AdminVerificationDecideServlet", urlPatterns={"/admin/verifications/decide"})
public class AdminVerificationDecideServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        long submissionId = Long.parseLong(req.getParameter("submissionId"));
        String decision = req.getParameter("decision"); // approve | reject
        String notes = req.getParameter("notes");

        String newStatus = "approved".equalsIgnoreCase(decision) ? "approved" : "denied";

        final String sql =
            "UPDATE verification_submissions " +
            "SET status=?, reviewer_admin_id=?, reviewer_notes=?, decided_at=NOW() " +
            "WHERE submission_id=? AND status='pending'";

        try (Connection c = DB.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, me.getUserId());
            ps.setString(3, notes);
            ps.setLong(4, submissionId);
            int n = ps.executeUpdate();
            String msg = (n>0)
                    ? ("approved".equals(newStatus) ? "Verification%20approved" : "Verification%20rejected")
                    : "No%20pending%20submission%20to%20update";
            resp.sendRedirect(req.getContextPath()+"/admin/verifications?success=" + msg);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/admin/verifications?error=Failed%20to%20update");
        }
    }
}
