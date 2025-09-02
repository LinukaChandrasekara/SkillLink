package com.skilllink.controller.client;

import com.skilllink.dao.ClientDAO;
import com.skilllink.dao.ReviewDAO;
import com.skilllink.dao.jdbc.JdbcClientDAO;
import com.skilllink.dao.jdbc.JdbcReviewDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ClientReviewCreateServlet", urlPatterns={"/client/reviews/create"})
public class ClientReviewCreateServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final ClientDAO dashDAO = new JdbcClientDAO();
    private final ReviewDAO reviewDAO = new JdbcReviewDAO();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.CLIENT) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }
        long clientId = me.getUserId();

        try {
            long jobId   = Long.parseLong(req.getParameter("job_id"));
            int rating   = Integer.parseInt(req.getParameter("rating"));
            String comment = req.getParameter("comment");
            if (rating < 1 || rating > 5) throw new IllegalArgumentException("Rating must be 1..5");

            // ensure this job belongs to this client and is completed, and get worker id
            var dto = dashDAO.findCompletedJob(clientId, jobId);
            if (dto == null) {
                resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=Invalid%20job%20to%20review");
                return;
            }
            if (dto.isReviewed()) {
                resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=You%20already%20reviewed%20this%20job");
                return;
            }

            reviewDAO.create(jobId, clientId, dto.getWorkerId(), rating, comment==null?null:comment.trim());

            resp.sendRedirect(req.getContextPath()+"/client/dashboard?success=Review%20submitted");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()+"/client/dashboard?error=Could%20not%20save%20review");
        }
    }
}
