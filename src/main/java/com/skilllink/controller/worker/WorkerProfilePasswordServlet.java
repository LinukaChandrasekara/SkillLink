package com.skilllink.controller.worker;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name="WorkerProfilePasswordServlet", urlPatterns={"/worker/profile/password"})
public class WorkerProfilePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new JdbcUserDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }

        String current = req.getParameter("current_password");
        String newPwd  = req.getParameter("new_password");
        String confirm = req.getParameter("confirm_password");

        if (newPwd == null || !newPwd.equals(confirm)) {
            resp.sendRedirect(req.getContextPath()+"/worker/profile?error=Passwords%20do%20not%20match");
            return;
        }

        Optional<User> db = userDAO.findById(me.getUserId());
        if (db.isEmpty()) {
            resp.sendRedirect(req.getContextPath()+"/worker/profile?error=User%20not%20found");
            return;
        }

        User u = db.get();
        if (!matches(current, u.getPasswordHash())) {
            resp.sendRedirect(req.getContextPath()+"/worker/profile?error=Current%20password%20is%20incorrect");
            return;
        }

        u.setPasswordHash(hash(newPwd));   // TODO: use your BCrypt (or equivalent)
        userDAO.update(u);
        me.setPasswordHash(u.getPasswordHash()); // keep session in sync

        resp.sendRedirect(req.getContextPath()+"/worker/profile?success=Password%20updated%20successfully");
    }

    private boolean matches(String raw, String storedHash) {
        // TODO: replace with BCrypt.checkpw(raw, storedHash)
        return storedHash != null && storedHash.equals(raw);
    }
    private String hash(String raw) {
        // TODO: replace with BCrypt.hashpw(raw, BCrypt.gensalt())
        return raw;
    }
}
