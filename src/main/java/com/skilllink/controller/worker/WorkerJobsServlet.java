package com.skilllink.controller.worker;

import com.skilllink.dao.WorkerJobDAO;
import com.skilllink.dao.jdbc.JdbcWorkerJobDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="WorkerJobsServlet", urlPatterns={"/worker/jobs"})
public class WorkerJobsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final WorkerJobDAO workerJobDAO = new JdbcWorkerJobDAO();
    private final UserDAO userDAO = new JdbcUserDAO();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }

        // for banner chips etc.
        String vStatus = userDAO.getVerificationStatus(me.getUserId());
        req.setAttribute("verificationStatus", vStatus);

        req.setAttribute("offers", workerJobDAO.listOffersForWorker(me.getUserId(), 12));
        req.setAttribute("accepted", workerJobDAO.listAcceptedByWorker(me.getUserId()));

        req.getRequestDispatcher("/views/worker/worker-jobs.jsp").forward(req, resp);
    }
}
