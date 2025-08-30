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
import java.util.HashMap;
import java.util.Map;

@WebServlet(name="ClientProfileServlet", urlPatterns={"/client/profile"})
public class ClientProfileServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();
    private final ClientDAO clientDAO = new JdbcClientDAO();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        var opt = userDAO.findById(me.getUserId());  // full user
        if (opt.isEmpty()) {
            resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=Profile%20not%20found");
            return;
        }
        User u = opt.get();
        String clientType = clientDAO.getClientType(me.getUserId());

        Map<String,Object> profile = new HashMap<>();
        profile.put("fullName", u.getFullName());
        profile.put("username", u.getUsername());
        profile.put("email", u.getEmail());
        profile.put("phone", u.getPhone());
        profile.put("age", u.getAge());
        profile.put("addressLine", u.getAddressLine());
        profile.put("bio", u.getBio());
        profile.put("clientType", clientType == null ? "individual" : clientType);

        req.setAttribute("profile", profile);
        req.setAttribute("verificationStatus", u.getVerificationStatus()==null ? "unverified" : u.getVerificationStatus().toDb());
        req.getRequestDispatcher("/views/client/client-profile.jsp").forward(req, resp);
    }
}
