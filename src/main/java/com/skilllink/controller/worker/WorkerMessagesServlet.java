// src/main/java/com/skilllink/controller/worker/WorkerMessagesServlet.java
package com.skilllink.controller.worker;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.MessageDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.dto.ConversationSummary;
import com.skilllink.dao.jdbc.JdbcConversationDAO;
import com.skilllink.dao.jdbc.JdbcMessageDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.Message;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "WorkerMessagesServlet", urlPatterns = {"/worker/messages"})
public class WorkerMessagesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ConversationDAO conversationDAO = new JdbcConversationDAO();
    private final MessageDAO messageDAO = new JdbcMessageDAO();
    private final UserDAO userDAO = new JdbcUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }

        long workerId = me.getUserId();

        // Sidebar: conversations this worker participates in
        List<ConversationSummary> convos = conversationDAO.listForUser(workerId);
        req.setAttribute("conversations", convos);

        // Suggestions in “Start new chat” modal (recent non-admins)
        req.setAttribute("userSuggestions", userDAO.listRecentNonAdmin(20));

        // Which conversation to open?
        Long cid = null;
        try { cid = Long.valueOf(req.getParameter("cid")); } catch (Exception ignored) {}
        if (cid == null && !convos.isEmpty()) cid = convos.get(0).getConversationId();
        req.setAttribute("currentConversationId", cid);

        if (cid != null) {
            // Resolve the "other user" (for the header)
            long otherUserId = conversationDAO.findOtherParticipant(cid, workerId);
            User otherUser = userDAO.findById(otherUserId).orElse(null);
            req.setAttribute("otherUser", otherUser); // not Optional – avoids EL error

            // Load messages
            List<Message> msgs = messageDAO.listByConversation(cid, 300, 0);
            req.setAttribute("messages", msgs);

            // Mark unread as read for the viewer
            messageDAO.markReadAllForViewer(cid, workerId);
        }

        req.getRequestDispatcher("/views/worker/worker-messages.jsp").forward(req, resp);
    }
}
