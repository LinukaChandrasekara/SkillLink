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

@WebServlet(name="ClientJobCreateServlet", urlPatterns={"/client/jobs/create"})
public class ClientJobCreateServlet extends HttpServlet {
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
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String loc = req.getParameter("location_text");
            BigDecimal budget = new BigDecimal(req.getParameter("budget_amount"));
            long catId = Long.parseLong(req.getParameter("job_category_id"));

            JobPost j = new JobPost();
            j.setClientId(me.getUserId());
            j.setJobCategoryId((int)catId);
            j.setTitle(title);
            j.setDescription(description);
            j.setLocationText(loc);
            j.setBudgetAmount(budget);
            // status defaults to 'pending' in DAO/DB

            long id = jobDAO.create(j);
            resp.sendRedirect(req.getContextPath()+"/client/jobs?success=Job%20submitted%20for%20review%20(ID%3A%20"+id+")");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()+"/client/jobs?error=Create%20failed");
        }
    }
}
