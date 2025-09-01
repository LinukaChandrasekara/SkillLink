// src/main/java/com/skilllink/controller/common/VerificationUploadServlet.java
package com.skilllink.controller.common;

import com.skilllink.dao.VerificationDAO;
import com.skilllink.dao.jdbc.JdbcVerificationDAO;
import com.skilllink.model.User;
import com.skilllink.model.enums.RoleName;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;

@WebServlet(
  name = "VerificationUploadServlet",
  urlPatterns = { "/client/verification/upload", "/worker/verification/upload" }
)
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, fileSizeThreshold = 32 * 1024)
public class VerificationUploadServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;
  private final VerificationDAO verificationDAO = new JdbcVerificationDAO();

  @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {

    HttpSession s = req.getSession(false);
    User me = (s == null) ? null : (User) s.getAttribute("authUser");
    if (me == null) {
      resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Please%20login");
      return;
    }

    String path = req.getServletPath();
    if (path.startsWith("/client/") && me.getRoleName() != RoleName.CLIENT) {
      resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client"); return;
    }
    if (path.startsWith("/worker/") && me.getRoleName() != RoleName.WORKER) {
      resp.sendRedirect(req.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker"); return;
    }

    Part p = req.getPart("id_photo");
    if (p == null || p.getSize() == 0) {
      back(resp, req, "error=Please%20attach%20an%20image"); return;
    }
    if (!String.valueOf(p.getContentType()).toLowerCase().startsWith("image/")) {
      back(resp, req, "error=Please%20upload%20an%20image%20file"); return;
    }
    byte[] data;
    try (InputStream in = p.getInputStream()) { data = in.readAllBytes(); }
    if (data.length == 0) { back(resp, req, "error=Empty%20file"); return; }

    verificationDAO.createPendingSubmission(me.getUserId(), data);
    back(resp, req, "success=Submitted.%20Status%20changed%20to%20Pending");
  }

  private void back(HttpServletResponse resp, HttpServletRequest req, String q) throws IOException {
    String to = req.getServletPath().startsWith("/worker/") ? "/worker/dashboard" : "/client/dashboard";
    resp.sendRedirect(req.getContextPath() + to + (q == null ? "" : "?" + q));
  }
}
