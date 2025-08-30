package com.skilllink.controller.client;

import com.skilllink.dao.ConversationMessageDAO;
import com.skilllink.dao.jdbc.JdbcConversationMessageDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name="ClientSendMessageServlet", urlPatterns={"/client/messages/send"})
public class ClientSendMessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final ConversationMessageDAO msgDAO = new JdbcConversationMessageDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        Long cid = parseLong(req.getParameter("cid"));
        Long to  = parseLong(req.getParameter("to"));
        Long job = parseLong(req.getParameter("jobId"));
        String body = req.getParameter("body");

        if ((cid == null || cid == 0) && to != null && to > 0) {
            cid = msgDAO.ensureDirectConversation(me.getUserId(), to, job);
        }
        if (cid == null || cid == 0 || body == null || body.isBlank()) {
            resp.sendRedirect(req.getContextPath()+"/client/messages?cid=" + (cid==null?0:cid) + "&error=Invalid%20message");
            return;
        }
        if (!msgDAO.isParticipant(cid, me.getUserId())) {
            resp.sendRedirect(req.getContextPath()+"/client/messages?error=Not%20a%20participant");
            return;
        }

        msgDAO.send(cid, me.getUserId(), body.trim());
        resp.sendRedirect(req.getContextPath()+"/client/messages?cid=" + cid + "#bottom");
    }

    private static Long parseLong(String s) {
        if (s == null || s.isBlank()) return null;
        try { return Long.parseLong(s.trim()); } catch (NumberFormatException e) { return null; }
    }
}