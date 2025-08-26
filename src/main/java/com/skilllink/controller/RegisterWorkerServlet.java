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

@WebServlet(name="RegisterWorkerServlet", urlPatterns={"/register-worker"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class RegisterWorkerServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            // Basic fields
            String fullName = req.getParameter("full_name");
            String nid = req.getParameter("nid");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");
            short age = Short.parseShort(req.getParameter("age"));
            String address = req.getParameter("address_line");
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String bio = req.getParameter("bio");

            int categoryId = Integer.parseInt(req.getParameter("job_category_id"));
            int expYears = Integer.parseInt(req.getParameter("experience_years"));

            Part profile = req.getPart("profile_picture");
            Part idPhoto = req.getPart("id_photo");

            if (userDao.existsByUsernameOrEmail(username, email)) {
                resp.sendRedirect(req.getContextPath() + "/register.jsp?role=worker&error=Username+or+email+already+exists");
                return;
            }

            User u = new User();
            u.setRoleId(2); // worker
            u.setFullName(fullName);
            u.setNid(nid);
            u.setPhone(phone);
            u.setEmail(email);
            u.setAge(age);
            u.setAddressLine(address);
            u.setUsername(username);
            u.setPasswordHash(PasswordUtil.hash(password));
            u.setBio(bio);
            u.setProfilePicture(IOUtil.toBytes(profile, 5L * 1024 * 1024));

            long userId = userDao.insertUser(u);
            userDao.insertWorker(userId, categoryId, expYears);
            userDao.insertVerificationSubmission(userId, IOUtil.toBytes(idPhoto, 5L * 1024 * 1024));

            resp.sendRedirect(req.getContextPath() +
                    "/login.jsp?success=Registration+successful.+Please+login.&verification=pending");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/register.jsp?role=worker&error=Server+error");
        }
    }
}
