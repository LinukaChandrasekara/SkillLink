package com.skilllink.controller.client;

import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.JobCategoryDAO;
import com.skilllink.dao.jdbc.JdbcJobPostDAO;
import com.skilllink.dao.jdbc.JdbcJobCategoryDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name="ClientJobsServlet", urlPatterns={"/client/jobs"})
public class ClientJobsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final JobPostDAO jobDAO = new JdbcJobPostDAO();
    private final JobCategoryDAO categoryDAO = new JdbcJobCategoryDAO();
    private final UserDAO userDAO = new JdbcUserDAO();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        // Read fresh from DB every time; do not gate with redirects.
        String vStatus = Optional.ofNullable(userDAO.getVerificationStatus(me.getUserId()))
                                 .map(String::trim).orElse("unverified");
        req.setAttribute("verificationStatus", vStatus);

        // Optional: see what the server actually reads
        System.out.println("[ClientJobsServlet] userId=" + me.getUserId() + " verificationStatus=" + vStatus);

        req.setAttribute("jobs", jobDAO.listByClient(me.getUserId()));
        req.setAttribute("jobCategories", categoryDAO.listAll());

        // Always forward; JSP already disables Add/Edit/Delete when unverified/denied.
        req.getRequestDispatcher("/views/client/client-jobs.jsp").forward(req, resp);
    }
}
