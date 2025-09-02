package com.skilllink.controller.worker;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.WorkerDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.dao.jdbc.JdbcWorkerDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name="WorkerProfileUpdateServlet", urlPatterns={"/worker/profile/update"})
public class WorkerProfileUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new JdbcUserDAO();
    private final WorkerDAO workerDAO = new JdbcWorkerDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }
        long uid = me.getUserId();

        String fullName = req.getParameter("full_name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String ageStr = req.getParameter("age");
        String address = req.getParameter("address_line");
        String bio = req.getParameter("bio");
        String catStr = req.getParameter("job_category_id");
        String expStr = req.getParameter("experience_years");

        try {
            Optional<User> db = userDAO.findById(uid);
            User u = db.orElse(me);
            u.setFullName(fullName);
            u.setEmail(email);
            u.setPhone(phone);
            u.setAge(Integer.parseInt(ageStr));
            u.setAddressLine(address);
            u.setBio(bio);

            userDAO.update(u);

            long jobCategoryId = Long.parseLong(catStr);
            int exp = (expStr==null || expStr.isBlank()) ? 0 : Integer.parseInt(expStr);
            workerDAO.upsert(uid, jobCategoryId, Math.max(0, exp));

            // refresh session user’s visible fields
            me.setFullName(u.getFullName());
            me.setEmail(u.getEmail());
            me.setPhone(u.getPhone());
            me.setAge(u.getAge());
            me.setAddressLine(u.getAddressLine());
            me.setBio(u.getBio());

            resp.sendRedirect(req.getContextPath()+"/worker/profile?success=Profile%20updated%20successfully");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/worker/profile?error=Could%20not%20update%20profile");
        }
    }
}
