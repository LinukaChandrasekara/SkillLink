package com.skilllink.controller.admin;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.jdbc.JdbcConversationDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name="AdminConversationStartServlet", urlPatterns={"/admin/messages/start"})
public class AdminConversationStartServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final ConversationDAO conversationDAO = new JdbcConversationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        long targetUserId = Long.parseLong(req.getParameter("userId"));

        // Reuse existing 1:1 if present, else create
        Long convId = conversationDAO.findDirectConversation(
                (me.getUserId() instanceof Long) ? ((Long) me.getUserId()).longValue() : me.getUserId(),
                targetUserId
        );

        if (convId == null) {
            convId = conversationDAO.create(me.getUserId(), null, false);
            conversationDAO.addParticipant(convId, me.getUserId());
            conversationDAO.addParticipant(convId, targetUserId);
        }

        resp.sendRedirect(req.getContextPath()+"/admin/messages?cid=" + convId);
    }
}
