package com.skilllink.controller;

import com.skilllink.dao.UserDao;
import com.skilllink.dao.UserDaoImpl;
import com.skilllink.model.User;
import com.skilllink.util.IOUtil;
import com.skilllink.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name="RegisterClientServlet", urlPatterns={"/register-client"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class RegisterClientServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            String fullName = req.getParameter("full_name");
            String nid = req.getParameter("nid");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            short age = Short.parseShort(req.getParameter("age"));
            String address = req.getParameter("address_line");
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String clientType = req.getParameter("client_type"); // individual | business

            Part profile = req.getPart("profile_picture");
            Part idPhoto = req.getPart("id_photo");

            if (userDao.existsByUsernameOrEmail(username, email)) {
                resp.sendRedirect(req.getContextPath() + "/register.jsp?role=client&error=Username+or+email+already+exists");
                return;
            }

            User u = new User();
            u.setRoleId(3); // client
            u.setFullName(fullName);
            u.setNid(nid);
            u.setPhone(phone);
            u.setEmail(email);
            u.setAge(age);
            u.setAddressLine(address);
            u.setUsername(username);
            u.setPasswordHash(PasswordUtil.hash(password));
            u.setBio(null);
            u.setProfilePicture(IOUtil.toBytes(profile, 5L * 1024 * 1024));

            long userId = userDao.insertUser(u);
            userDao.insertClient(userId, clientType);
            userDao.insertVerificationSubmission(userId, IOUtil.toBytes(idPhoto, 5L * 1024 * 1024));

            resp.sendRedirect(req.getContextPath() +
                    "/login.jsp?success=Registration+successful.+Please+login.&verification=pending");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/register.jsp?role=client&error=Server+error");
        }
    }
}
