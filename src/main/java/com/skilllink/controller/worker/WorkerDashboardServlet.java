package com.skilllink.controller.worker;

import com.skilllink.dao.JobPostDAO;
import com.skilllink.dao.ReviewDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.WorkerDAO;
import com.skilllink.dao.dto.RecentReview;
import com.skilllink.dao.jdbc.JdbcJobPostDAO;
import com.skilllink.dao.jdbc.JdbcReviewDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.dao.jdbc.JdbcWorkerDAO;
import com.skilllink.model.JobPost;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "WorkerDashboardServlet", urlPatterns = {"/worker/dashboard"})
public class WorkerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final UserDAO   userDAO   = new JdbcUserDAO();
    private final ReviewDAO reviewDAO = new JdbcReviewDAO();
    private final WorkerDAO workerDAO = new JdbcWorkerDAO();
    private final JobPostDAO jobPostDAO = new JdbcJobPostDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.WORKER) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20login%20as%20a%20worker");
            return;
        }
        long workerId = me.getUserId();

        // Verification chip
        String vStatus = Optional.ofNullable(userDAO.getVerificationStatus(workerId))
                                 .map(String::trim).orElse("unverified");
        req.setAttribute("verificationStatus", vStatus);

        // Stats / ratings
        long completed = reviewDAO.countCompletedForWorker(workerId);   // number of completed jobs (from reviews/jobs)
        req.setAttribute("completedJobs", completed);

        var rating = reviewDAO.getRatingSummary(workerId);              // record with avg() and count()
        double avg = (rating == null) ? 0.0 : rating.avg();
        long   cnt = (rating == null) ? 0L  : rating.count();
        req.setAttribute("ratingAvg", avg);
        req.setAttribute("ratingCount", cnt);
        req.setAttribute("ratingRounded", Math.round(avg));

        // Find worker's category
        Integer workerCatId = workerDAO.getCategoryId(workerId);
        req.setAttribute("workerCategoryId", workerCatId);

        // Matching offers: APPROVED jobs having the same category as this worker
        List<JobPost> matching =
                (workerCatId == null) ? Collections.emptyList()
                                      : jobPostDAO.listApprovedByCategory(workerCatId, 9); // newest first, limit 9
        req.setAttribute("matchingJobs", matching);
        
        // NEW: recent reviews from clients for this worker (limit 5)
        List<RecentReview> recent = reviewDAO.listRecentForWorker(workerId, 5);
        req.setAttribute("recentReviews", recent);

        // (Optional: keep a legacy attribute if your JSPs already reference "offers")
        req.setAttribute("offers", matching);

        // Forward to JSP
        req.getRequestDispatcher("/views/worker/worker-dashboard.jsp").forward(req, resp);
    }
}
