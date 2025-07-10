package com.skilllink.filter;

import com.skilllink.dao.UserDAO;
import com.skilllink.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    private UserDAO userDao;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDao = new UserDAO();
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Allow public resources
        if (path.startsWith("/public/") || path.startsWith("/login.jsp") 
                || path.startsWith("/register.jsp") || path.startsWith("/auth/login") 
                || path.startsWith("/auth/register") || path.startsWith("/css/") 
                || path.startsWith("/js/") || path.startsWith("/img/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check session first
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check remember me cookie
        Cookie[] cookies = httpRequest.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("rememberUser")) {
                    try {
                        int userId = Integer.parseInt(cookie.getValue());
                        User user = userDao.findById(userId); // You'll need to implement this method
                        if (user != null) {
                            HttpSession newSession = httpRequest.getSession();
                            newSession.setAttribute("user", user);
                            chain.doFilter(request, response);
                            return;
                        }
                    } catch (NumberFormatException e) {
                        // Invalid cookie value
                    }
                }
            }
        }
        
        // Not authenticated - redirect to login
        httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}