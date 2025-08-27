package com.skilllink.controller.admin;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.MessageDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.dto.ConversationSummary;
import com.skilllink.model.Message;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.skilllink.dao.jdbc.JdbcConversationDAO;
import com.skilllink.dao.jdbc.JdbcMessageDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;


import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name="AdminMessagesServlet", urlPatterns={"/admin/messages"})
public class AdminMessagesServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final ConversationDAO conversationDAO = new JdbcConversationDAO();
    private final MessageDAO messageDAO = new JdbcMessageDAO();
    private final UserDAO userDAO = new JdbcUserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Guard
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        long adminId = me.getUserId();

        // Left list
        List<ConversationSummary> convos = conversationDAO.listForUser(adminId);
        req.setAttribute("conversations", convos);

        // Suggestions for "Start new chat" modal (recent users)
        req.setAttribute("userSuggestions", userDAO.listRecentNonAdmin(20));

        // Which conversation to open?
        Long cid = null;
        try { cid = Long.valueOf(req.getParameter("cid")); } catch (Exception ignored) {}
        if (cid == null && !convos.isEmpty()) cid = convos.get(0).getConversationId();

        req.setAttribute("currentConversationId", cid);

        if (cid != null) {
            // Participants (we show "other" user in header)
            long otherUserId = conversationDAO.findOtherParticipant(cid, adminId);
            Optional<User> other = userDAO.findById(otherUserId);
            req.setAttribute("otherUser", other);

            // Messages
            List<Message> msgs = messageDAO.listByConversation(cid, 300, 0);
            req.setAttribute("messages", msgs);

            // Mark unread as read for admin
            messageDAO.markReadAllForViewer(cid, adminId);
        }

        req.getRequestDispatcher("/views/admin/admin-messages.jsp").forward(req, resp);
    }
}
