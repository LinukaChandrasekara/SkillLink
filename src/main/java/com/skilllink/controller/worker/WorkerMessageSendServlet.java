// src/main/java/com/skilllink/controller/worker/WorkerMessageSendServlet.java
package com.skilllink.controller.worker;

import com.skilllink.dao.MessageDAO;
import com.skilllink.dao.jdbc.JdbcMessageDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "WorkerMessageSendServlet", urlPatterns = {"/worker/messages/send"})
public class WorkerMessageSendServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final MessageDAO messageDAO = new JdbcMessageDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }

        String body = req.getParameter("body");
        String cidStr = req.getParameter("cid");
        Long cid = null;
        try { cid = Long.valueOf(cidStr); } catch (Exception ignored) {}

        if (cid == null || body == null || body.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/worker/messages?cid=" + (cid == null ? "" : cid) +
                    "&error=Message%20cannot%20be%20empty");
            return;
        }

        messageDAO.create(cid, me.getUserId(), body.trim(), null);
        resp.sendRedirect(req.getContextPath() + "/worker/messages?cid=" + cid + "#end");
    }
}
