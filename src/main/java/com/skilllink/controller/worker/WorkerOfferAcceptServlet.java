package com.skilllink.controller.worker;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.MessageDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcConversationDAO;
import com.skilllink.dao.jdbc.JdbcJobPostDAO;
import com.skilllink.dao.jdbc.JdbcMessageDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.JobPost;
import com.skilllink.model.User;
import com.skilllink.model.enums.JobStatus;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "WorkerOfferAcceptServlet", urlPatterns = {"/worker/offers/accept"})
public class WorkerOfferAcceptServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final JobPostDAO jobPostDAO = new JdbcJobPostDAO();
    private final ConversationDAO conversationDAO = new JdbcConversationDAO();
    private final MessageDAO messageDAO = new JdbcMessageDAO();
    private final UserDAO userDAO = new JdbcUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // You can switch to POST later; we support GET because the dashboard uses a link.
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }

        long jobId;
        try {
            jobId = Long.parseLong(req.getParameter("jobId"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/worker/dashboard?error=Invalid%20job%20id#offers");
            return;
        }

        Optional<JobPost> optJob = jobPostDAO.findById(jobId);
        if (optJob.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/worker/dashboard?error=Job%20not%20found#offers");
            return;
        }

        JobPost job = optJob.get();

        // Only accept approved jobs (avoid race conditions / invalid states)
        if (job.getStatus() != JobStatus.APPROVED) {
            resp.sendRedirect(req.getContextPath() + "/worker/dashboard?error=This%20job%20is%20not%20open%20for%20acceptance#offers");
            return;
        }

        long workerId = me.getUserId();
        long clientId = job.getClientId();

        // Ensure we have a direct conversation Worker <-> Client (re-use existing if any)
        Long cid = conversationDAO.findDirectConversation(workerId, clientId);
        if (cid == null) {
            cid = conversationDAO.create(workerId, job.getJobId(), false);
            conversationDAO.addParticipant(cid, workerId);
            conversationDAO.addParticipant(cid, clientId);
        }

        // Compose the notification message to the client
        String clientName = userDAO.findById(clientId).map(User::getFullName).orElse("Client");
        String budget = (job.getBudgetAmount() == null) ? "-" : job.getBudgetAmount().toPlainString();
        String location = (job.getLocationText() == null || job.getLocationText().isBlank()) ? "-" : job.getLocationText();
        String category = (job.getJobCategoryName() == null) ? "" : job.getJobCategoryName();

        String body = ""
            + "Hi " + clientName + ",\n\n"
            + "I’ve **accepted** your job offer.\n\n"
            + "— Job: " + job.getTitle() + "\n"
            + "— Category: " + category + "\n"
            + "— Location: " + location + "\n"
            + "— Budget: Rs. " + budget + "\n\n"
            + "My details:\n"
            + "— Name: " + me.getFullName() + "\n"
            + "— Username: @" + me.getUsername() + "\n"
            + "— Phone: " + (me.getPhone() == null ? "-" : me.getPhone()) + "\n"
            + "— Address: " + (me.getAddressLine() == null ? "-" : me.getAddressLine()) + "\n\n"
            + "Let me know the next steps. Thanks!";

        // Send the message (plain text; your Messages UI can render markdown later if desired)
        messageDAO.create(cid, workerId, body, null);

        // (Optional) Future step:
        // - record a "job_acceptances" row or transition job status to "closed/assigned".
        //   Not done here because it’s outside the current schema/UI.

        // <<< change here: carry job id back to the dashboard so the button flips >>>
        resp.sendRedirect(
            req.getContextPath()
            + "/worker/dashboard?success=Offer%20accepted%20and%20client%20notified"
            + "&acceptedId=" + jobId
            + "#offers"
        );
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Support POST as well (e.g., if you later change the Accept button to a form)
        doGet(req, resp);
    }
}
