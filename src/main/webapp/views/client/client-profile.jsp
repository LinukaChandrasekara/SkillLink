<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
    String roleName = (String) session.getAttribute("roleName");
    if (me == null || !"CLIENT".equals(roleName)) {
        response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
        return;
    }
    String vStatus = (String) request.getAttribute("verificationStatus");
    boolean unverified = "unverified".equalsIgnoreCase(vStatus);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>SkillLink | Client • Manage Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#DCDCDC; }
    body{ background:var(--light); }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.25rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .cardish{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
    .chip{ display:inline-block; padding:.2rem .6rem; border-radius:999px; font-size:.8rem; }
    .chip-verified{ background:#d1e7dd; color:#0f5132; }
    .chip-pending{ background:#fff3cd; color:#664d03; }
    .chip-unverified{ background:#f8d7da; color:#842029; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
  </style>
</head>
<body>
<header class="topbar">
  <div class="container-fluid px-3 px-md-4 py-3 d-flex justify-content-between align-items-center flex-wrap">
    <div class="d-flex align-items-center gap-2">
      <i class="bi bi-people fs-4"></i><div class="brand">Client Dashboard - SkillLink</div>
    </div>
    <div class="d-flex align-items-center gap-3 mt-3 mt-md-0">
      <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}" alt="">
      <div class="text-end">
        <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
        <div class="small opacity-75">Client</div>
      </div>
    </div>
  </div>
  <div class="nav-tabs-row">
    <div class="container-fluid px-3 px-md-4 py-2">
      <ul class="nav">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/client/profile">Manage Profile</a></li>
			<!-- Verifications (only if NOT verified) -->
			<c:if test="<%= unverified %>">
			  <li class="nav-item">
			    <a class="nav-link" href="javascript:void(0)"
			       data-bs-toggle="modal" data-bs-target="#uploadIdModal">
			      Verifications
			    </a>
			  </li>
			</c:if>
        <li class="nav-item">
          <c:choose>
            <c:when test="<%= unverified %>">
              <a class="nav-link disabled" title="Verify your account to access">Job Post Management</a>
            </c:when>
            <c:otherwise><a class="nav-link" href="${pageContext.request.contextPath}/client/jobs">Job Post Management</a></c:otherwise>
          </c:choose>
        </li>
        <li class="nav-item">
          <c:choose>
            <c:when test="<%= unverified %>">
              <a class="nav-link disabled" title="Verify your account to access">Messages</a>
            </c:when>
            <c:otherwise><a class="nav-link" href="${pageContext.request.contextPath}/client/messages">Messages</a></c:otherwise>
          </c:choose>
        </li>
          <div class="ms-auto">
          <a class="btn btn-logout" href="${pageContext.request.contextPath}/auth/logout">
            <i class="bi bi-box-arrow-right me-1"></i> Logout
          </a>
        </div>
      </ul>
    </div>
  </div>
</header>

<main class="container-fluid px-3 px-md-4 py-3">
  <!-- Flash messages -->
  <c:if test="${not empty param.success}">
    <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle me-2"></i>${param.success}<button class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle me-2"></i>${param.error}<button class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>

  <div class="row g-3">
    <!-- LEFT: Avatar & verification -->
    <div class="col-12 col-lg-4">
      <div class="cardish p-3">
        <div class="text-center">
          <img class="avatar mb-2" src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}" alt="">
          <div class="mb-3">
            <c:choose>
              <c:when test="${verificationStatus eq 'verified'}"><span class="chip chip-verified"><i class="bi bi-patch-check-fill me-1"></i>Verified</span></c:when>
              <c:when test="${verificationStatus eq 'pending'}"><span class="chip chip-pending"><i class="bi bi-hourglass-split me-1"></i>Pending</span></c:when>
              <c:otherwise><span class="chip chip-unverified"><i class="bi bi-shield-exclamation me-1"></i>Unverified</span></c:otherwise>
            </c:choose>
          </div>
        </div>
        <form class="d-grid gap-2" method="post" action="${pageContext.request.contextPath}/client/profile/picture" enctype="multipart/form-data">
          <label class="form-label fw-semibold">Change profile picture</label>
          <input type="file" name="profile_picture" accept="image/*" class="form-control" required>
          <button class="btn btn-primary"><i class="bi bi-upload me-1"></i>Upload</button>
        </form>
      </div>

      <div class="cardish p-3 mt-3">
        <h6 class="fw-bold mb-3"><i class="bi bi-key me-1"></i> Change Password</h6>
        <form method="post" action="${pageContext.request.contextPath}/client/profile/password" class="row g-2">
          <div class="col-12">
            <label class="form-label">Current password</label>
            <input type="password" name="current_password" class="form-control" required>
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">New password</label>
            <input type="password" name="new_password" minlength="8" class="form-control" required>
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Confirm new password</label>
            <input type="password" name="confirm_password" minlength="8" class="form-control" required>
          </div>
          <div class="col-12"><button class="btn btn-outline-primary w-100"><i class="bi bi-shield-lock me-1"></i>Update Password</button></div>
        </form>
      </div>
    </div>

    <!-- RIGHT: Account details -->
    <div class="col-12 col-lg-8">
      <div class="cardish p-3">
        <h6 class="fw-bold mb-3"><i class="bi bi-person-lines-fill me-1"></i> Account Details</h6>
        <form method="post" action="${pageContext.request.contextPath}/client/profile/update" class="row g-3">
          <div class="col-12 col-md-6">
            <label class="form-label">Full name</label>
            <input type="text" name="full_name" class="form-control" value="${profile.fullName}" required maxlength="150">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Username <span class="text-muted">(read-only)</span></label>
            <input type="text" class="form-control" value="${profile.username}" disabled>
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" value="${profile.email}" required maxlength="160">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control" value="${profile.phone}" required maxlength="30">
          </div>
          <div class="col-12 col-md-4">
            <label class="form-label">Age</label>
            <input type="number" name="age" min="16" max="100" class="form-control" value="${profile.age}" required>
          </div>
          <div class="col-12 col-md-8">
            <label class="form-label">Address / Location</label>
            <input type="text" name="address_line" class="form-control" value="${profile.addressLine}" required maxlength="255">
          </div>
          <div class="col-12">
            <label class="form-label">Bio</label>
            <textarea name="bio" class="form-control" rows="3" maxlength="1000">${profile.bio}</textarea>
          </div>

          <div class="col-12">
            <label class="form-label fw-semibold">Client Type</label>
            <div class="d-flex gap-4">
              <div class="form-check">
                <input class="form-check-input" type="radio" name="client_type" id="ctype-ind" value="individual" ${profile.clientType=='individual'?'checked':''}>
                <label class="form-check-label" for="ctype-ind"><i class="bi bi-person me-1"></i>Individual</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="client_type" id="ctype-biz" value="business" ${profile.clientType=='business'?'checked':''}>
                <label class="form-check-label" for="ctype-biz"><i class="bi bi-building me-1"></i>Business</label>
              </div>
            </div>
          </div>

          <div class="col-12">
            <button class="btn btn-primary"><i class="bi bi-save me-1"></i>Save Changes</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>

<footer class="footer mt-4">
  <div class="container-fluid px-3 px-md-4 py-4">
    <div class="row g-4">
      <div class="col-12 col-md-4">
        <h6>Quick Links</h6>
        <div class="d-flex flex-column gap-1">
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/client/profile">Manage Profile</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/client/verification">Verifications</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/client/jobs">Job Approvals</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/client/messages">Messages</a>
        </div>
      </div>
      <div class="col-12 col-md-4 text-center">
        <div class="fw-bold">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
        <div class="small opacity-75 mt-2">&copy; <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara</div>
      </div>
      <div class="col-12 col-md-4">
        <h6>Contact Us</h6>
        <div class="d-flex align-items-center gap-2">
          <a class="contact-icon" href="#"><i class="bi bi-facebook"></i></a>
          <a class="contact-icon" href="#"><i class="bi bi-twitter-x"></i></a>
          <a class="contact-icon" href="#"><i class="bi bi-instagram"></i></a>
          <a class="contact-icon" href="mailto:support@skilllink.lk"><i class="bi bi-envelope"></i></a>
        </div>
      </div>
    </div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
