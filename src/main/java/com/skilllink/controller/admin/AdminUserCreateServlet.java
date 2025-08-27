package com.skilllink.controller.admin;

import com.skilllink.dao.*;
import com.skilllink.dao.jdbc.*;
import com.skilllink.model.User;
import com.skilllink.model.enums.ClientType;
import com.skilllink.model.enums.VerificationStatus;
import com.skilllink.model.enums.RoleName;
import com.skilllink.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.*;

@WebServlet(name="AdminUserCreateServlet", urlPatterns={"/admin/users/create"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024, maxRequestSize = 20 * 1024 * 1024)
public class AdminUserCreateServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private final UserDAO userDAO = new JdbcUserDAO();
    private final WorkerDAO workerDAO = new JdbcWorkerDAO();
    private final ClientDAO clientDAO = new JdbcClientDAO();
    private final VerificationSubmissionDAO verDAO = new JdbcVerificationSubmissionDAO();

    private static byte[] read(Part p) throws IOException {
        if (p==null || p.getSize()<=0) return null;
        try (InputStream in=p.getInputStream(); ByteArrayOutputStream out=new ByteArrayOutputStream()){
            byte[] buf=new byte[8192]; int r; while((r=in.read(buf))!=-1) out.write(buf,0,r); return out.toByteArray();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Guard
        HttpSession s = req.getSession(false);
        com.skilllink.model.User me = (s == null) ? null : (com.skilllink.model.User) s.getAttribute("authUser");
        if (me == null || me.getRoleName() != RoleName.ADMIN) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
            return;
        }
        req.setCharacterEncoding("UTF-8");

        String role = req.getParameter("role"); // worker|client|admin
        String fullName = req.getParameter("full_name");
        String nid      = req.getParameter("nid");
        String phone    = req.getParameter("phone");
        String email    = req.getParameter("email");
        int age         = Integer.parseInt(req.getParameter("age"));
        String address  = req.getParameter("address_line");
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        byte[] profilePic = read(req.getPart("profile_picture"));
        byte[] idPhoto    = read(req.getPart("id_photo"));

        User u = new User();
        u.setFullName(fullName);
        u.setNid(nid);
        u.setPhone(phone);
        u.setEmail(email);
        u.setAge(age);
        u.setAddressLine(address);
        u.setUsername(username);
        u.setPasswordHash(PasswordUtil.hash(password));
        u.setProfilePicture(profilePic);
        u.setActive(true);
        u.setVerificationStatus(idPhoto != null ? VerificationStatus.PENDING : VerificationStatus.UNVERIFIED);

        if ("admin".equalsIgnoreCase(role)) {
            u.setRoleId(1);
        } else if ("client".equalsIgnoreCase(role)) {
            u.setRoleId(3);
        } else {
            u.setRoleId(2);
        }

        try {
            long userId = userDAO.create(u);
            if (u.getRoleId() == 2) {
                long catId = Long.parseLong(req.getParameter("job_category_id"));
                int yrs    = Integer.parseInt(req.getParameter("experience_years"));
                new JdbcWorkerDAO().create(userId, catId, yrs);
            } else if (u.getRoleId() == 3) {
                String ct = req.getParameter("client_type");
                new JdbcClientDAO().create(userId, "business".equalsIgnoreCase(ct)? ClientType.BUSINESS: ClientType.INDIVIDUAL);
            } else {
                new JdbcAdminDAO().linkAsAdmin(userId);
            }
            if (idPhoto != null) new JdbcVerificationSubmissionDAO().create(userId, idPhoto);

            resp.sendRedirect(req.getContextPath()+"/admin/users?success=User%20created");
        } catch (RuntimeException ex) {
            resp.sendRedirect(req.getContextPath()+"/admin/users?error=Failed%20to%20create%20user");
        }
    }
}
