package com.skilllink.controller;

import com.skilllink.dao.UserDAO;
import com.skilllink.model.User;
import com.skilllink.util.AuthUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;

@WebServlet(name = "LoginServlet", urlPatterns = {"/auth/login"})
public class LoginServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private UserDAO userDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDao = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to login page if someone tries to access this directly
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String identifier = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        User user = userDao.findByUsernameOrEmail(identifier);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=User not found");
            return;
        }
        
        // Simple password comparison
        if (!user.getPassword().equals(password)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid credentials");
            return;
        }
        
        
        // Update last login time
        userDao.updateLastLogin(user.getUserId());
        
        // Create session
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        
        // Set remember me cookie if requested
        if (rememberMe != null && rememberMe.equals("on")) {
            Cookie userCookie = new Cookie("rememberUser", String.valueOf(user.getUserId()));
            userCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
            userCookie.setHttpOnly(true);
            userCookie.setSecure(true); // Only send over HTTPS
            response.addCookie(userCookie);
        }
        
        // Redirect based on user type
        String redirectPath;
        switch (user.getUserType()) {
            case "admin":
                redirectPath = request.getContextPath() + "/admin/dashboard.jsp";
                break;
            case "worker":
                redirectPath = request.getContextPath() + "/worker/dashboard.jsp";
                break;
            case "client":
                redirectPath = request.getContextPath() + "/client/dashboard.jsp";
                break;
            default:
                redirectPath = request.getContextPath() + "/";
        }
        
        response.sendRedirect(redirectPath);
    }
}