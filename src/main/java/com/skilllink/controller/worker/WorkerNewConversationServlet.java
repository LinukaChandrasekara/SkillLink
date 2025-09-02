// src/main/java/com/skilllink/controller/worker/WorkerNewConversationServlet.java
package com.skilllink.controller.worker;

import com.skilllink.dao.ConversationDAO;
import com.skilllink.dao.jdbc.JdbcConversationDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "WorkerNewConversationServlet", urlPatterns = {"/worker/messages/new"})
public class WorkerNewConversationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ConversationDAO conversationDAO = new JdbcConversationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }

        long myId = me.getUserId();
        Long otherId = null;
        try { otherId = Long.valueOf(req.getParameter("otherUserId")); } catch (Exception ignored) {}

        if (otherId == null || otherId == myId) {
            resp.sendRedirect(req.getContextPath() + "/worker/messages?error=Choose%20a%20valid%20user");
            return;
        }

        // Re-use existing direct conversation if present
        Long cid = conversationDAO.findDirectConversation(myId, otherId);
        if (cid == null) {
            cid = conversationDAO.create(myId, null, false);
            conversationDAO.addParticipant(cid, myId);
            conversationDAO.addParticipant(cid, otherId);
        }

        resp.sendRedirect(req.getContextPath() + "/worker/messages?cid=" + cid);
    }
}
