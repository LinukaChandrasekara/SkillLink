package com.skilllink.controller.client;

import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.jdbc.JdbcJobPostDAO;
import com.skilllink.model.JobPost;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name="ClientJobUpdateServlet", urlPatterns={"/client/jobs/update"})
public class ClientJobUpdateServlet extends HttpServlet {
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
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String loc = req.getParameter("location_text");
            BigDecimal budget = new BigDecimal(req.getParameter("budget_amount"));
            int catId = Integer.parseInt(req.getParameter("job_category_id"));

            JobPost j = new JobPost();
            j.setJobId(jobId);
            j.setClientId(me.getUserId());
            j.setTitle(title);
            j.setDescription(description);
            j.setLocationText(loc);
            j.setBudgetAmount(budget);
            j.setJobCategoryId(catId);

            boolean ok = jobDAO.updateByClientRepend(j); // sets status='pending' if allowed
            resp.sendRedirect(req.getContextPath()+"/client/jobs?" + (ok ? "success=Job%20updated%20and%20resubmitted" : "error=Update%20not%20permitted"));
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/client/jobs?error=Update%20failed");
        }
    }
}
