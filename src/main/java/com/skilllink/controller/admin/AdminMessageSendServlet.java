package com.skilllink.controller.admin;

import com.skilllink.dao.MessageDAO;
import com.skilllink.dao.jdbc.JdbcMessageDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name="AdminMessageSendServlet", urlPatterns={"/admin/messages/send"})
public class AdminMessageSendServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final MessageDAO messageDAO = new JdbcMessageDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        long convId = Long.parseLong(req.getParameter("conversationId"));
        String body = req.getParameter("body");
        if (body != null) body = body.trim();
        if (body == null || body.isEmpty()) {
            resp.sendRedirect(req.getContextPath()+"/admin/messages?cid=" + convId + "&error=Message%20is%20empty");
            return;
        }

        messageDAO.create(convId, me.getUserId(), body, null);
        resp.sendRedirect(req.getContextPath()+"/admin/messages?cid=" + convId + "#bottom");
    }
}
