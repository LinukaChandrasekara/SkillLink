package com.skilllink.controller.worker;

import com.skilllink.dao.WorkerJobDAO;
import com.skilllink.dao.jdbc.JdbcWorkerJobDAO;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.MessageDAO;
import com.skilllink.dao.jdbc.JdbcConversationDAO;
import com.skilllink.dao.jdbc.JdbcMessageDAO;

import com.skilllink.dao.jdbc.DB;

import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;
import java.io.IOException;
import java.sql.*;

@WebServlet(name="WorkerAcceptOfferServlet", urlPatterns={"/worker/jobs/accept"})
public class WorkerAcceptOfferServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final WorkerJobDAO workerJobDAO = new JdbcWorkerJobDAO();
    private final ConversationDAO conversationDAO = new JdbcConversationDAO();
    private final MessageDAO messageDAO = new JdbcMessageDAO();

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

        boolean ok = workerJobDAO.acceptJob(jobId, me.getUserId());

        if (ok) {
            // find client for that job and DM them
            Long clientId = null;
            String title = null;
            try (Connection c = DB.getConnection();
                 PreparedStatement ps = c.prepareStatement("SELECT client_id, title FROM job_posts WHERE job_id=?")) {
                ps.setLong(1, jobId);
                try (ResultSet rs = ps.executeQuery()) { if (rs.next()) { clientId = rs.getLong(1); title = rs.getString(2); } }
            } catch (SQLException ignored) {}

            if (clientId != null) {
                Long cid = conversationDAO.findDirectConversation(me.getUserId(), clientId);
                if (cid == null) {
                    cid = conversationDAO.create(me.getUserId(), jobId, false);
                    conversationDAO.addParticipant(cid, me.getUserId());
                    conversationDAO.addParticipant(cid, clientId);
                }
                String body = "Hello! I've accepted your job offer **" + (title==null?"":title) + "**.\n\n"
                            + "Worker: " + me.getFullName() + "\n"
                            + "Phone: " + me.getPhone() + "\n"
                            + "We can coordinate details here.";
                messageDAO.create(cid, me.getUserId(), body, null);
            }

            resp.sendRedirect(req.getContextPath()+"/worker/jobs?accepted=1&jobId="+jobId);
        } else {
            resp.sendRedirect(req.getContextPath()+"/worker/jobs?error=Job+was+already+taken");
        }
    }
}
