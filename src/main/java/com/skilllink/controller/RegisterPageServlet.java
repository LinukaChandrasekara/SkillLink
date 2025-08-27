package com.skilllink.controller;

import com.skilllink.dao.JobCategoryDAO;
import com.skilllink.dao.jdbc.JdbcJobCategoryDAO;
import com.skilllink.model.JobCategory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name="RegisterPageServlet", urlPatterns={"/register"})
public class RegisterPageServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final JobCategoryDAO jobCategoryDAO = new JdbcJobCategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<JobCategory> cats = jobCategoryDAO.listAll();
        req.setAttribute("jobCategories", cats);
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}
