package com.skilllink.filter;

import com.skilllink.dao.UserDAO;
import com.skilllink.dao.jdbc.JdbcUserDAO;
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

@WebFilter(urlPatterns = { "/views/*", "/client/*", "/worker/*", "/admin/*" })
public class AuthFilter implements Filter {

    private final UserDAO userDAO = new JdbcUserDAO();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  r = (HttpServletRequest) req;
        HttpServletResponse p = (HttpServletResponse) res;

        String ctx  = r.getContextPath();
        String path = r.getRequestURI().substring(ctx.length()); // e.g. /client/jobs

        HttpSession s = r.getSession(false);
        User u = (s != null) ? (User) s.getAttribute("authUser") : null;

        // --- 1) must be logged in for any filtered routes
        if (u == null) {
            p.sendRedirect(ctx + "/login.jsp?error=Please+login");
            return;
        }

        // Make JSPs happy: keep roleName as String in session
        if (s != null) {
            s.setAttribute("roleName", u.getRoleName().name()); // "ADMIN" | "WORKER" | "CLIENT"
        }

        // --- 2) basic role→area guard
        if (path.startsWith("/admin/")  && u.getRoleName() != RoleName.ADMIN)  { redirectHome(p, ctx, u); return; }
        if (path.startsWith("/worker/") && u.getRoleName() != RoleName.WORKER) { redirectHome(p, ctx, u); return; }
        if (path.startsWith("/client/") && u.getRoleName() != RoleName.CLIENT) { redirectHome(p, ctx, u); return; }

        // --- 3) client-specific verification gating (UNVERIFIED only)
        if (u.getRoleName() == RoleName.CLIENT && path.startsWith("/client/")) {

            // Always refresh from DB so we don't rely on stale session values
            String vStatus = userDAO.getVerificationStatus(u.getUserId()); // unverified | pending | verified | denied
            if (vStatus == null) vStatus = "unverified";

            // expose it to downstream servlets/JSPs (both request + session are convenient)
            req.setAttribute("verificationStatus", vStatus);
            if (s != null) s.setAttribute("verificationStatus", vStatus);

            boolean unverified = "unverified".equalsIgnoreCase(vStatus);

            boolean wantsJobs      = path.startsWith("/client/jobs");
            boolean wantsMessages  = path.startsWith("/client/messages");
            boolean isDashboard    = path.equals("/client/dashboard");
            boolean isVerification = path.startsWith("/client/verification");

            // Only block UNVERIFIED from jobs/messages.
            // Allow dashboard, profile, verification, etc.
            if (unverified && (wantsJobs || wantsMessages) && !isDashboard && !isVerification) {
                p.sendRedirect(ctx + "/client/dashboard?verify=1");
                return;
            }
        }

        // --- 4) continue as normal
        chain.doFilter(req, res);
    }

    private void redirectHome(HttpServletResponse p, String ctx, User u) throws IOException {
        String home;
        switch (u.getRoleName()) {
            case ADMIN:  home = "/admin/dashboard";  break;
            case WORKER: home = "/worker/dashboard"; break;
            case CLIENT:
            default:     home = "/client/dashboard"; break;
        }
        p.sendRedirect(ctx + home);
    }
}
