package com.skilllink.filter;

import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName="ClientVerificationGuardFilter",
           urlPatterns={"/client/jobs/*", "/client/jobs", "/client/messages/*", "/client/messages"})
public class ClientVerificationGuardFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession s = req.getSession(false);
        User me = (s==null)?null:(User) s.getAttribute("authUser");
        String roleName = (s==null)?null:(String) s.getAttribute("roleName");
        String verif = (String) (s==null?null:s.getAttribute("verificationStatus")); // optional cache

        // If not in session, reload from DB on your side; for simplicity rely on controller-set attr on dashboard.
        if (me == null || roleName == null || !"CLIENT".equals(roleName)) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
            return;
        }

        // Most robust: re-check on each guarded request via DB if you prefer.
        if (verif == null || "unverified".equalsIgnoreCase(verif)) {
            resp.sendRedirect(req.getContextPath()+"/client/dashboard?verify=1");
            return;
        }

        chain.doFilter(request, response);
    }
}
