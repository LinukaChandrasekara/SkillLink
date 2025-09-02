package com.skilllink.controller.worker;

import com.skilllink.dao.WorkerJobDAO;
import com.skilllink.dao.jdbc.JdbcWorkerJobDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;

@WebServlet(name="WorkerJobStatusServlet", urlPatterns={"/worker/jobs/status"})
public class WorkerJobStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final WorkerJobDAO workerJobDAO = new JdbcWorkerJobDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }
        long jobId;
        try { jobId = Long.parseLong(req.getParameter("jobId")); }
        catch (Exception e) { resp.sendRedirect(req.getContextPath()+"/worker/jobs?error=Invalid+job"); return; }

        String action = req.getParameter("action");
        boolean ok = false;
        if ("complete".equalsIgnoreCase(action)) {
            ok = workerJobDAO.markCompleted(jobId, me.getUserId());
        }

        if (ok) resp.sendRedirect(req.getContextPath()+"/worker/jobs?done=1");
        else    resp.sendRedirect(req.getContextPath()+"/worker/jobs?error=Could+not+update");
    }
}
