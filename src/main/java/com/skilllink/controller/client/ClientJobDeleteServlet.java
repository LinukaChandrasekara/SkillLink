package com.skilllink.controller.client;

import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.jdbc.JdbcJobPostDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ClientJobDeleteServlet", urlPatterns={"/client/jobs/delete"})
public class ClientJobDeleteServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final JobPostDAO jobDAO = new JdbcJobPostDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me==null || me.getRoleName()!= RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        try {
            long jobId = Long.parseLong(req.getParameter("job_id"));
            boolean ok = jobDAO.deleteByClientIfEditable(jobId, me.getUserId());
            resp.sendRedirect(req.getContextPath()+"/client/jobs?" + (ok ? "success=Job%20deleted" : "error=Delete%20not%20permitted"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/client/jobs?error=Delete%20failed");
        }
    }
}
