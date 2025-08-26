package com.skilllink.controller;

import com.skilllink.dao.JobCategoryDao;
import com.skilllink.dao.JobCategoryDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="RegisterPageServlet", urlPatterns={"/register"})
public class RegisterPageServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final JobCategoryDao jobDao = new JobCategoryDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            req.setAttribute("jobCategories", jobDao.findAll());
        } catch (Exception e) { /* ignore, JSP has defaults */ }
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}
