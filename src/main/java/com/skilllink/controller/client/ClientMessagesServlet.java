package com.skilllink.controller.client;

import com.skilllink.dao.ConversationMessageDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcConversationMessageDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.ConversationSummary;
import com.skilllink.model.Message;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name="ClientMessagesServlet", urlPatterns={"/client/messages"})
public class ClientMessagesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ConversationMessageDAO msgDAO = new JdbcConversationMessageDAO();
    private final UserDAO userDAO = new JdbcUserDAO();

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        // For header badge on this page (optional)
        String vStatus = userDAO.getVerificationStatus(me.getUserId());
        req.setAttribute("verificationStatus", vStatus == null ? "unverified" : vStatus);

        // Conversations list (left panel)
        List<ConversationSummary> convs = msgDAO.listUserConversations(me.getUserId());
        req.setAttribute("conversations", convs);

        // Which conversation to open?
        Long cid = parseLong(req.getParameter("cid"));
        Long with = parseLong(req.getParameter("with"));  // start/open with a specific user
        Long jobId = parseLong(req.getParameter("jobId")); // optional scoping

        if (cid == null && with != null && with > 0) {
            // Create or reuse a direct conversation with this user (optionally by job)
            cid = msgDAO.ensureDirectConversation(me.getUserId(), with, jobId);
        }
        if (cid == null && !convs.isEmpty()) {
            cid = convs.get(0).getConversationId();
        }

        req.setAttribute("cid", cid == null ? 0 : cid);

        if (cid != null && cid > 0) {
            if (!msgDAO.isParticipant(cid, me.getUserId())) {
                resp.sendRedirect(req.getContextPath()+"/client/messages?error=Not%20a%20participant");
                return;
            }

            // peer info
            Optional<Long> peerId = msgDAO.findPeer(cid, me.getUserId());
            peerId.flatMap(userDAO::findById).ifPresent(u -> req.setAttribute("withUser", u));

            // thread
            List<Message> thread = msgDAO.listMessages(cid, 200);
            req.setAttribute("thread", thread);

            // mark read (incoming only)
            msgDAO.markRead(cid, me.getUserId());
        }

        req.getRequestDispatcher("/views/client/client-messages.jsp").forward(req, resp);
    }

    private static Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s.trim()); } catch (NumberFormatException e) { return null; }
    }
}