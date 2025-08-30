package com.skilllink.controller.auth;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;
import com.skilllink.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@jakarta.servlet.annotation.WebServlet(name="AuthLoginServlet", urlPatterns={"/auth/login"})
public class AuthLoginServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String login = req.getParameter("username");  // username or email
        String pass  = req.getParameter("password");
        boolean remember = "on".equalsIgnoreCase(req.getParameter("rememberMe")) || "true".equalsIgnoreCase(req.getParameter("rememberMe"));

        if (login == null || pass == null || login.isBlank() || pass.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20enter%20username%20and%20password");
            return;
        }

        Optional<User> opt = userDAO.findByUsernameOrEmail(login);
        if (opt.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid%20credentials");
            return;
        }
        User u = opt.get();

        // Only accept our PBKDF2 format
        if (!PasswordUtil.verify(pass, u.getPasswordHash())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid%20credentials");
            return;
        }
        if (!u.isActive()) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Your%20account%20is%20suspended");
            return;
        }

        // Login OK → session
        HttpSession session = req.getSession(true);
        session.setAttribute("authUser", u);
        session.setAttribute("roleName", u.getRoleName().name());


        // Lightweight “remember me” (username only; not auto-login token)
        if (remember) {
            Cookie c = new Cookie("sl_remember", u.getUsername());
            c.setHttpOnly(true);
            c.setPath(req.getContextPath().isEmpty()?"/":req.getContextPath());
            c.setMaxAge(7 * 24 * 3600);
            resp.addCookie(c);
        } else {
            Cookie c = new Cookie("sl_remember", "");
            c.setPath(req.getContextPath().isEmpty()?"/":req.getContextPath());
            c.setMaxAge(0);
            resp.addCookie(c);
        }

        // Redirect per role
        String target;
        if (u.getRoleName() == RoleName.ADMIN) {
            target = "/admin/dashboard";
        } else if (u.getRoleName() == RoleName.WORKER) {
            target = "/worker/dashboard"; // Also use servlet here if you have one
        } else {
            target = "/client/dashboard"; // Same note here
        }
        resp.sendRedirect(req.getContextPath() + target);
    }
}
