package com.skilllink.controller.client;

import com.skilllink.dao.ClientDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcClientDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ClientProfileUpdateServlet", urlPatterns={"/client/profile/update"})
public class ClientProfileUpdateServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();
    private final ClientDAO clientDAO = new JdbcClientDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        String fullName = req.getParameter("full_name");
        String email    = req.getParameter("email");
        String phone    = req.getParameter("phone");
        String ageStr   = req.getParameter("age");
        String address  = req.getParameter("address_line");
        String bio      = req.getParameter("bio");
        String ctype    = req.getParameter("client_type");

        var opt = userDAO.findById(me.getUserId());
        if (opt.isEmpty()) {
            resp.sendRedirect(req.getContextPath()+"/client/profile?error=Profile%20not%20found");
            return;
        }
        User u = opt.get();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        try { u.setAge(Integer.parseInt(ageStr)); } catch (Exception ignored) { u.setAge(u.getAge()); }
        u.setAddressLine(address);
        u.setBio(bio);

        boolean ok = userDAO.update(u);
        boolean ok2 = clientDAO.setClientType(me.getUserId(), ctype==null?"individual":ctype);
        if (ok && ok2) {
            // keep session name fresh
            me.setFullName(fullName);
            resp.sendRedirect(req.getContextPath()+"/client/profile?success=Profile%20updated");
        } else {
            resp.sendRedirect(req.getContextPath()+"/client/profile?error=Update%20failed");
        }
    }
}
