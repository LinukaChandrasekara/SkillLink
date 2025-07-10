package com.skilllink.controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/auth/logout"})
public class LogoutServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidate the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        // Remove remember me cookie
        Cookie rememberCookie = new Cookie("rememberUser", "");
        rememberCookie.setMaxAge(0);
        rememberCookie.setHttpOnly(true);
        rememberCookie.setSecure(true);
        response.addCookie(rememberCookie);
        
        // Redirect to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp?success=You have been logged out successfully");
    }
}