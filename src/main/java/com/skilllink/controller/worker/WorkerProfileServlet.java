package com.skilllink.controller.worker;

import com.skilllink.dao.JobCategoryDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.WorkerDAO;
import com.skilllink.dao.jdbc.JdbcJobCategoryDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.dao.jdbc.JdbcWorkerDAO;
import com.skilllink.model.User;
import com.skilllink.model.Worker;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name="WorkerProfileServlet", urlPatterns={"/worker/profile"})
public class WorkerProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new JdbcUserDAO();
    private final JobCategoryDAO jobCategoryDAO = new JdbcJobCategoryDAO();
    private final WorkerDAO workerDAO = new JdbcWorkerDAO();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }
        long uid = me.getUserId();

        // base profile + verification chip
        req.setAttribute("profile", userDAO.findById(uid).orElse(me));
        req.setAttribute("verificationStatus", userDAO.getVerificationStatus(uid));

        // trade details + categories for select
        Optional<Worker> w = workerDAO.findById(uid);
        req.setAttribute("worker", w.orElseGet(() -> {
            Worker nw = new Worker(); nw.setUserId(uid); nw.setExperienceYears(0); return nw;
        }));
        req.setAttribute("categories", jobCategoryDAO.listAll());

        req.getRequestDispatcher("/views/worker/worker-profile.jsp").forward(req, resp);
    }
}
