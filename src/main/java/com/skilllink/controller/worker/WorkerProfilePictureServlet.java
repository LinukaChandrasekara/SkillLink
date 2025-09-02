package com.skilllink.controller.worker;

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

@WebServlet(name="WorkerProfilePictureServlet", urlPatterns={"/worker/profile/picture"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class WorkerProfilePictureServlet extends HttpServlet {
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

        Part part = req.getPart("profile_picture");
        if (part == null || part.getSize() == 0) {
            resp.sendRedirect(req.getContextPath()+"/worker/profile?error=Please%20choose%20an%20image");
            return;
        }

        try (InputStream in = part.getInputStream()) {
            byte[] data = in.readAllBytes();
            userDAO.updateProfilePicture(me.getUserId(), data);
            resp.sendRedirect(req.getContextPath()+"/worker/profile?success=Profile%20picture%20updated");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/worker/profile?error=Upload%20failed");
        }
    }
}
