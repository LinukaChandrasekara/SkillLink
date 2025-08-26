package com.skilllink.filter;

import com.skilllink.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/views/*", "/client/*", "/worker/*", "/admin/*"
})
public class AuthFilter implements Filter {
    @Override public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest r = (HttpServletRequest) req;
        HttpServletResponse p = (HttpServletResponse) res;
        HttpSession s = r.getSession(false);
        User u = (s != null) ? (User) s.getAttribute("authUser") : null;

        if (u == null) {
            p.sendRedirect(r.getContextPath() + "/login.jsp?error=Please+login");
            return;
        }
        chain.doFilter(req, res);
    }
}
