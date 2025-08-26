package com.skilllink.controller;

import com.skilllink.dao.UserDao;
import com.skilllink.dao.UserDaoImpl;
import com.skilllink.model.Role;
import com.skilllink.model.User;
import com.skilllink.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AuthLoginServlet", urlPatterns = {"/auth/login"})
public class AuthLoginServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String usernameOrEmail = req.getParameter("username");
        String password = req.getParameter("password");

        try {
            User u = userDao.findByUsernameOrEmail(usernameOrEmail);
            if (u == null || !u.isActive() || !PasswordUtil.verify(password, u.getPasswordHash())) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid+credentials");
                return;
            }

            // Optional: block if verification denied
            if ("denied".equalsIgnoreCase(u.getVerificationStatus())) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Account+denied");
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("authUser", u);
            session.setMaxInactiveInterval(60 * 60 * 4); // 4h

            // redirect by role
            Role role = Role.fromId(u.getRoleId());
            String target;
            if (role == Role.ADMIN) {
                target = "/views/admin/dashboard.jsp";
            } else if (role == Role.WORKER) {
                target = "/views/worker/dashboard.jsp";  // create this page
            } else {
                target = "/views/client/dashboard.jsp";  // create this page
            }
            resp.sendRedirect(req.getContextPath() + target);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Server+error");
        }
    }
}
