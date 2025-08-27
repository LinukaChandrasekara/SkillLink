package com.skilllink.controller.admin;

import com.skilllink.dao.JobCategoryDAO;
import com.skilllink.dao.UserDAO;
import com.skilllink.dao.dto.PagedResult;
import com.skilllink.dao.jdbc.JdbcJobCategoryDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
import com.skilllink.model.JobCategory;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name="AdminUsersServlet", urlPatterns={"/admin/users"})
public class AdminUsersServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();
    private final JobCategoryDAO jobCategoryDAO = new JdbcJobCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Guard
        HttpSession s = req.getSession(false);
        User me = (s == null) ? null : (User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }

        String q = req.getParameter("q");
        String role = req.getParameter("role");
        String verification = req.getParameter("verification");
        int page = 1;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}

        PagedResult<User> result = userDAO.list(q, role, verification, page, 10);
        req.setAttribute("pageResult", result);

        // For Add User modal (worker section)
        List<JobCategory> cats = jobCategoryDAO.listAll();
        req.setAttribute("jobCategories", cats);

        req.getRequestDispatcher("/views/admin/admin-users.jsp").forward(req, resp);
    }
}
