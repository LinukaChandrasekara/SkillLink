<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
    Object rn = session.getAttribute("roleName");
    if (me == null || rn == null || !"ADMIN".equals(String.valueOf(rn))) {
        response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Job Approvals - SkillLink</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#f5f6f8; }
    body{ background:var(--light); }
    .app{ min-height:100vh; }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.35rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .rounded-outer{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
    .card-pending{ width: 320px; min-width: 320px; border-radius:1rem; border:1px solid #e9ecef; }
    .card-head{ background:#2856ea; color:#fff; border-top-left-radius:1rem; border-top-right-radius:1rem; padding:.6rem .9rem; font-weight:700; }
    .hscroll{ overflow-x:auto; }
    .hscroll .row-flex{ display:flex; flex-wrap:nowrap; gap:1rem; padding:.25rem; }
    .truncate-3{ display:-webkit-box; -webkit-line-clamp:3; -webkit-box-orient:vertical; overflow:hidden; }
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
  </style>
</head>
<body>
<div class="app d-flex flex-column">

  <!-- TOP BAR -->
  <header class="topbar">
    <div class="container-fluid px-3 px-md-4 py-3">
      <div class="d-flex flex-column flex-lg-row align-items-start align-items-lg-center justify-content-between">
        <div class="d-flex align-items-center gap-2">
          <i class="bi bi-tools fs-4"></i>
          <div class="brand">Admin Dashboard - SkillLink</div>
        </div>
        <div class="d-flex align-items-center gap-3 mt-3 mt-lg-0">
			<img class="avatar" src="${pageContext.request.contextPath}/views/admin/Admin.jpg" alt="Profile">	
          <div class="text-end">
            <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
            <div class="small opacity-75">Administrator</div>
          </div>
        </div>
      </div>
    </div>

    <!-- NAV TABS -->
    <div class="nav-tabs-row">
      <div class="container-fluid px-3 px-md-4 py-2 d-flex align-items-center">
        <ul class="nav">
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Manage users</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a></li>
          <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">Messages</a></li>
        </ul>
        <div class="ms-auto">
          <a class="btn btn-logout" href="${pageContext.request.contextPath}/auth/logout">
            <i class="bi bi-box-arrow-right me-1"></i> Logout
          </a>
        </div>
      </div>
    </div>
  </header>

  <!-- MAIN -->
  <main class="flex-grow-1 container-fluid px-3 px-md-4 py-3 py-md-4">

    <!-- Alerts -->
    <c:if test="${not empty error}">
      <div class="alert alert-danger d-flex align-items-center" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i><div>${error}</div>
      </div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success d-flex align-items-center" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i><div>${success}</div>
      </div>
    </c:if>

    <!-- Pending Approvals -->
    <div class="rounded-outer p-3 mb-3">
      <div class="d-flex align-items-center justify-content-between">
        <h5 class="mb-0">Job Approvals</h5>
        <span class="badge text-bg-warning">Total pending approvals: <c:out value="${pendingCount}" default="0"/></span>
      </div>
      <div class="text-muted small">Pending Approvals</div>

      <div class="hscroll mt-3">
        <div class="row-flex">
          <c:forEach var="j" items="${pending}">
            <div class="card-pending">
              <div class="card-head">
                <i class="bi bi-briefcase me-1"></i> <c:out value="${j.title}"/>
              </div>
              <div class="p-3">
                <div class="d-flex align-items-center gap-2 mb-2">
                  <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${j.clientId}" alt="">
                  <div class="small">
                    <div><span class="text-muted">Posted by</span> <strong>${j.clientName}</strong></div>
                    <div class="text-muted">Category: ${j.categoryName}</div>
                  </div>
                </div>
                <div class="small mb-2">
                  <div><i class="bi bi-geo-alt me-1"></i><span class="text-muted">Location:</span> <c:out value="${j.locationText}"/></div>
                  <div><i class="bi bi-cash-coin me-1"></i><span class="text-muted">Budget:</span> Rs. ${j.budgetAmount}</div>
                </div>
                <div class="small text-muted truncate-3 mb-3"><c:out value="${j.description}"/></div>

                <div class="d-grid gap-2">
                  <form method="post" action="${pageContext.request.contextPath}/admin/jobs/decide">
                    <input type="hidden" name="jobId" value="${j.jobId}">
                    <input type="hidden" name="decision" value="approve">
                    <button class="btn btn-success"><i class="bi bi-check-lg me-1"></i>Approve</button>
                  </form>
                  <form method="post" action="${pageContext.request.contextPath}/admin/jobs/decide"
                        onsubmit="return confirm('Reject this job post?');">
                    <input type="hidden" name="jobId" value="${j.jobId}">
                    <input type="hidden" name="decision" value="reject">
                    <button class="btn btn-danger"><i class="bi bi-x-lg me-1"></i>Reject</button>
                  </form>
                </div>
              </div>
            </div>
          </c:forEach>

          <c:if test="${empty pending}">
            <div class="text-muted small d-flex align-items-center">No pending job approvals.</div>
          </c:if>
        </div>
      </div>
    </div>

    <!-- Approved jobs -->
    <div class="rounded-outer p-3">
      <div class="d-flex align-items-center justify-content-between">
        <h5 class="mb-0">Approved jobs</h5>
        <span class="badge text-bg-success">Total Approved: <c:out value="${approvedCount}" default="0"/></span>
      </div>

      <div class="table-responsive mt-3">
        <table class="table table-bordered align-middle">
          <thead class="table-light">
          <tr>
            <th>Job Title</th>
            <th>Client</th>
            <th>Category</th>
            <th>Budget</th>
            <th>Approved On</th>
            <th class="text-center">Status</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="a" items="${approved}">
            <tr>
              <td class="fw-semibold"><c:out value="${a.title}"/></td>
              <td><c:out value="${a.clientName}"/></td>
              <td><c:out value="${a.categoryName}"/></td>
              <td>Rs. ${a.budgetAmount}</td>
              <td>${a.approvedOn}</td>
              <td class="text-center"><span class="badge bg-success">Approved</span></td>
            </tr>
          </c:forEach>
          <c:if test="${empty approved}">
            <tr><td colspan="6" class="text-center text-muted py-4">No approved jobs yet.</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>

  </main>

  <!-- FOOTER -->
  <footer class="footer mt-auto">
    <div class="container-fluid px-3 px-md-4 py-4">
      <div class="row g-4 align-items-start">
        <div class="col-12 col-md-4">
          <h6 class="mb-3">Quick Links</h6>
          <div class="d-flex flex-column gap-1">
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/users">Manage users</a>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/messages">Messages</a>
          </div>
        </div>
        <div class="col-12 col-md-4 text-center">
          <div class="fw-bold">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
          <div class="small opacity-75 mt-2">&copy; <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara</div>
        </div>
        <div class="col-12 col-md-4">
          <h6 class="mb-3">Contact Us</h6>
          <div class="d-flex align-items-center gap-2">
            <a class="contact-icon" href="#"><i class="bi bi-facebook"></i></a>
            <a class="contact-icon" href="#"><i class="bi bi-twitter"></i></a>
            <a class="contact-icon" href="#"><i class="bi bi-instagram"></i></a>
            <a class="contact-icon" href="mailto:support@skilllink.lk"><i class="bi bi-envelope"></i></a>
          </div>
        </div>
      </div>
    </div>
  </footer>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
