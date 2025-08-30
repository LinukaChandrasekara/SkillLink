package com.skilllink.controller.client;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;

@WebServlet(name="ClientProfilePictureServlet", urlPatterns={"/client/profile/picture"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class ClientProfilePictureServlet extends HttpServlet {
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

        Part part = req.getPart("profile_picture");
        if (part == null || part.getSize()==0) {
            resp.sendRedirect(req.getContextPath()+"/client/profile?error=Choose%20an%20image");
            return;
        }
        byte[] bytes;
        try (InputStream in = part.getInputStream()) {
            bytes = in.readAllBytes();
        }
        boolean ok = userDAO.updateProfilePicture(me.getUserId(), bytes);
        resp.sendRedirect(req.getContextPath()+"/client/profile?" + (ok?"success=Profile%20picture%20updated":"error=Upload%20failed"));
    }
}
