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
  <title>Verifications - SkillLink</title>
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
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
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
          <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a></li>
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

    <!-- Pending Verifications -->
    <div class="rounded-outer p-3 mb-3">
      <div class="d-flex align-items-center justify-content-between">
        <h5 class="mb-0">Verification Requests</h5>
        <span class="badge text-bg-warning">Total pending verifications: <c:out value="${pendingCount}" default="0"/></span>
      </div>
      <div class="text-muted small">Pending Verifications</div>

      <div class="table-responsive mt-2">
        <table class="table table-bordered align-middle">
          <thead class="table-light">
          <tr>
            <th style="width:80px;">Profile</th>
            <th>Name / Info</th>
            <th style="width:260px;" class="text-center">Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="row" items="${pending}">
            <tr data-submission-id="${row.submissionId}" data-user-id="${row.userId}"
                data-name="${row.fullName}" data-username="${row.username}">
              <td>
                <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${row.userId}" alt="">
              </td>
              <td>
                <div class="fw-semibold">${row.fullName}</div>
                <div class="small text-muted">
                  <span class="me-2"><i class="bi bi-person-badge"></i> ${row.roleName}</span>
                  <c:if test="${not empty row.jobCategoryName}">
                    <span class="me-2"><i class="bi bi-briefcase"></i> ${row.jobCategoryName}</span>
                  </c:if>
                  <span><i class="bi bi-calendar-event"></i>
                    ID submitted on ${row.createdAt}
                  </span>
                </div>
              </td>
              <td class="text-center">
                <button type="button" class="btn btn-primary btn-sm me-1" data-bs-toggle="modal"
                        data-bs-target="#viewModal"
                        onclick="openView(this)">
                  <i class="bi bi-eye me-1"></i> View
                </button>

                <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/verifications/decide">
                  <input type="hidden" name="submissionId" value="${row.submissionId}">
                  <input type="hidden" name="decision" value="approved">
                  <button class="btn btn-success btn-sm me-1"><i class="bi bi-check-lg me-1"></i>Approve</button>
                </form>

                <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/verifications/decide"
                      onsubmit="return confirm('Reject this verification?');">
                  <input type="hidden" name="submissionId" value="${row.submissionId}">
                  <input type="hidden" name="decision" value="denied">
                  <button class="btn btn-danger btn-sm"><i class="bi bi-x-lg me-1"></i>Reject</button>
                </form>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty pending}">
            <tr><td colspan="3" class="text-center text-muted py-4">No pending verifications.</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Verified Users -->
    <div class="rounded-outer p-3">
      <div class="d-flex align-items-center justify-content-between">
        <h5 class="mb-0">Verified Users</h5>
        <span class="badge text-bg-success">Total verified users: <c:out value="${verifiedCount}" default="0"/></span>
      </div>

      <div class="table-responsive mt-2">
        <table class="table table-bordered align-middle">
          <thead class="table-light">
          <tr>
            <th style="width:80px;">Profile</th>
            <th>Name</th>
            <th style="width:150px;" class="text-center">Type</th>
            <th style="width:160px;" class="text-center">Verified On</th>
            <th style="width:140px;" class="text-center">Status</th>
            <th style="width:140px;" class="text-center">Action</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="v" items="${verified}">
            <tr>
              <td><img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${v.userId}" alt=""></td>
              <td class="fw-semibold">${v.fullName}</td>
              <td class="text-center">
                <c:choose>
                  <c:when test="${v.roleName=='admin'}"><span class="badge bg-dark">Admin</span></c:when>
                  <c:when test="${v.roleName=='worker'}"><span class="badge bg-secondary">Worker</span></c:when>
                  <c:otherwise><span class="badge bg-info text-dark">Client</span></c:otherwise>
                </c:choose>
              </td>
              <td class="text-center">${v.verifiedOn}</td>
              <td class="text-center"><span class="badge bg-success">Verified</span></td>
              <td class="text-center">
                <form method="post" action="${pageContext.request.contextPath}/admin/verifications/revoke"
                      onsubmit="return confirm('Revoke verification for this user?');">
                  <input type="hidden" name="userId" value="${v.userId}">
                  <button class="btn btn-outline-danger btn-sm"><i class="bi bi-shield-x me-1"></i>Revoke</button>
                </form>
              </td>
            </tr>
          </c:forEach>
          <c:if test="${empty verified}">
            <tr><td colspan="6" class="text-center text-muted py-4">No verified users yet.</td></tr>
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
            <a class="contact-icon" href="#" title="Facebook"><i class="bi bi-facebook"></i></a>
            <a class="contact-icon" href="#" title="X"><i class="bi bi-twitter"></i></a>
            <a class="contact-icon" href="#" title="Instagram"><i class="bi bi-instagram"></i></a>
            <a class="contact-icon" href="mailto:support@skilllink.lk" title="Email"><i class="bi bi-envelope"></i></a>
          </div>
        </div>
      </div>
    </div>
  </footer>
</div>

<!-- VIEW MODAL -->
<div class="modal fade" id="viewModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-eye me-2"></i>ID Photo</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="d-flex align-items-center gap-3 mb-3">
          <img class="avatar" id="viewProfile" src="" alt="">
          <div>
            <div id="viewName" class="fw-semibold"></div>
            <div id="viewUsername" class="small text-muted"></div>
          </div>
        </div>
        <img id="viewIdPhoto" class="img-fluid rounded border" alt="ID Photo">
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function openView(btn){
    const tr = btn.closest('tr');
    const submissionId = tr.getAttribute('data-submission-id');
    const userId = tr.getAttribute('data-user-id');
    const name = tr.getAttribute('data-name');
    const username = tr.getAttribute('data-username');

    document.getElementById('viewName').textContent = name;
    document.getElementById('viewUsername').textContent = '@'+username;
    document.getElementById('viewProfile').src = '${pageContext.request.contextPath}/media/user/profile?userId=' + userId;
    document.getElementById('viewIdPhoto').src = '${pageContext.request.contextPath}/media/verification/photo?submissionId=' + submissionId;
  }
</script>
</body>
</html>
