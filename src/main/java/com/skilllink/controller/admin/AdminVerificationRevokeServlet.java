package com.skilllink.controller.admin;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;
import com.skilllink.model.enums.VerificationStatus;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name="AdminVerificationRevokeServlet", urlPatterns={"/admin/verifications/revoke"})
public class AdminVerificationRevokeServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        long userId = Long.parseLong(req.getParameter("userId"));
        try {
            userDAO.setVerificationStatus(userId, VerificationStatus.DENIED); // "Revoke" → mark as denied
            resp.sendRedirect(req.getContextPath()+"/admin/verifications?success=Verification%20revoked");
        } catch (RuntimeException e) {
            resp.sendRedirect(req.getContextPath()+"/admin/verifications?error=Failed%20to%20revoke");
        }
    }
}
