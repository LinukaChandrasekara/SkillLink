package com.skilllink.controller.worker;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.MessageDAO;
import com.skilllink.dao.jdbc.JdbcConversationDAO;
import com.skilllink.dao.jdbc.JdbcJobPostDAO;
import com.skilllink.dao.jdbc.JdbcMessageDAO;
import com.skilllink.model.JobPost;
import com.skilllink.model.User;
import com.skilllink.model.enums.JobStatus;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name="WorkerAcceptJobServlet", urlPatterns={"/worker/offers/accept"})
public class WorkerAcceptJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final JobPostDAO jobDAO = new JdbcJobPostDAO();
    private final ConversationDAO convDAO = new JdbcConversationDAO();
    private final MessageDAO msgDAO = new JdbcMessageDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }
        long workerId = me.getUserId();

        long jobId = 0L, clientId = 0L;
        try { jobId = Long.parseLong(req.getParameter("job_id")); } catch (Exception ignored) {}
        try { clientId = Long.parseLong(req.getParameter("client_id")); } catch (Exception ignored) {}

        Optional<JobPost> opt = jobDAO.findById(jobId);
        if (opt.isEmpty() || opt.get().getStatus() != JobStatus.APPROVED) {
            resp.sendRedirect(req.getContextPath()+"/worker/dashboard?error=Invalid%20job");
            return;
        }

        // Reuse existing direct convo if any, otherwise create a job-bound convo
        Long cid = convDAO.findDirectConversation(workerId, clientId);
        if (cid == null) {
            cid = convDAO.create(workerId, jobId, false);
            convDAO.addParticipant(cid, workerId);
            convDAO.addParticipant(cid, clientId);
            // First message so the client sees interest
            msgDAO.create(cid, workerId, "Hi! I'm interested in your job (ID: " + jobId + ").", null);
        }

        resp.sendRedirect(req.getContextPath()+"/worker/messages?cid=" + cid);
    }
}
