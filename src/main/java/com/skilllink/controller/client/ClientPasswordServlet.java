package com.skilllink.controller.client;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;
import com.skilllink.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ClientPasswordServlet", urlPatterns={"/client/profile/password"})
public class ClientPasswordServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        String curr = req.getParameter("current_password");
        String npw  = req.getParameter("new_password");
        String cnpw = req.getParameter("confirm_password");
        if (npw == null || !npw.equals(cnpw)) {
            resp.sendRedirect(req.getContextPath()+"/client/profile?error=Passwords%20do%20not%20match");
            return;
        }

        var opt = userDAO.findById(me.getUserId());
        if (opt.isEmpty()) {
            resp.sendRedirect(req.getContextPath()+"/client/profile?error=Account%20not%20found");
            return;
        }
        User u = opt.get();
        if (!PasswordUtil.verify(curr, u.getPasswordHash())) {
            resp.sendRedirect(req.getContextPath()+"/client/profile?error=Current%20password%20is%20incorrect");
            return;
        }

        u.setPasswordHash(PasswordUtil.hash(npw));
        boolean ok = userDAO.update(u);
        resp.sendRedirect(req.getContextPath()+"/client/profile?" + (ok?"success=Password%20updated":"error=Update%20failed"));
    }
}
