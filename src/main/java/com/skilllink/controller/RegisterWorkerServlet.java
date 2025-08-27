package com.skilllink.controller;

import com.skilllink.dao.*;
import com.skilllink.dao.jdbc.*;
import com.skilllink.model.User;
import com.skilllink.model.enums.VerificationStatus;
import com.skilllink.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLIntegrityConstraintViolationException;

@WebServlet(name="RegisterWorkerServlet", urlPatterns={"/register-worker"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024, maxRequestSize = 20 * 1024 * 1024)
public class RegisterWorkerServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();
    private final WorkerDAO workerDAO = new JdbcWorkerDAO();
    private final VerificationSubmissionDAO verDAO = new JdbcVerificationSubmissionDAO();

    private static byte[] readPart(Part p) throws IOException {
        if (p == null || p.getSize() <= 0) return null;
        try (InputStream in = p.getInputStream(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            byte[] buf = new byte[8192]; int r;
            while ((r = in.read(buf)) != -1) out.write(buf, 0, r);
            return out.toByteArray();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // Required fields
        String fullName = req.getParameter("full_name");
        String nid      = req.getParameter("nid");
        String phone    = req.getParameter("phone");
        String email    = req.getParameter("email");
        String ageStr   = req.getParameter("age");
        String address  = req.getParameter("address_line");
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String bio      = req.getParameter("bio");
        String expStr   = req.getParameter("experience_years");
        String catStr   = req.getParameter("job_category_id");

        Part profileP   = req.getPart("profile_picture");
        Part idPhotoP   = req.getPart("id_photo");

        if (fullName==null || nid==null || phone==null || email==null || ageStr==null ||
            address==null || username==null || password==null || expStr==null || catStr==null ||
            fullName.isBlank() || nid.isBlank() || phone.isBlank() || email.isBlank() ||
            ageStr.isBlank() || address.isBlank() || username.isBlank() || password.isBlank() ||
            expStr.isBlank() || catStr.isBlank()) {
            resp.sendRedirect(req.getContextPath()+"/register.jsp?error=Please%20fill%20all%20required%20fields&role=worker");
            return;
        }

        int age = Integer.parseInt(ageStr);
        int years = Integer.parseInt(expStr);
        long categoryId = Long.parseLong(catStr);

        byte[] profilePic = readPart(profileP);
        byte[] idPhoto    = readPart(idPhotoP);

        // Build user (role_id = 2 for worker as per schema seed)
        User u = new User();
        u.setRoleId(2);
        u.setFullName(fullName);
        u.setNid(nid);
        u.setPhone(phone);
        u.setEmail(email);
        u.setAge(age);
        u.setAddressLine(address);
        u.setUsername(username);
        u.setPasswordHash(PasswordUtil.hash(password));
        u.setBio(bio);
        u.setProfilePicture(profilePic);
        u.setVerificationStatus(idPhoto != null ? VerificationStatus.PENDING : VerificationStatus.UNVERIFIED);
        u.setActive(true);

        try {
            long userId = userDAO.create(u);
            // worker extension
            workerDAO.create(userId, categoryId, years);

            // If ID provided at registration => create a pending verification submission
            if (idPhoto != null) {
                verDAO.create(userId, idPhoto); // status defaults to 'pending'
            }

            // Redirect to login with success + optional verification flag (your login page will show alert)
            String extra = (idPhoto != null) ? "&verification=pending" : "";
            resp.sendRedirect(req.getContextPath()+"/login.jsp?success=Account%20created.%20Please%20login"+extra);
        } catch (RuntimeException e) {
            Throwable cause = e.getCause();
            if (cause instanceof SQLIntegrityConstraintViolationException) {
                // Unique username/email
                resp.sendRedirect(req.getContextPath()+"/register.jsp?error=Username%20or%20Email%20already%20exists&role=worker");
            } else {
                resp.sendRedirect(req.getContextPath()+"/register.jsp?error=Registration%20failed&role=worker");
            }
        }
    }
}
