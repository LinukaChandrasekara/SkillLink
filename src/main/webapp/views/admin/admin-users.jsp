<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Admin | Manage Users - SkillLink</title>

  <!-- Bootstrap + Font Awesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

  <style>
    :root{ --primary-color:#4e73df; --light-color:#f5f6f8; }
    body{ background:var(--light-color); }
    /* Top bar (same as dashboard) */
    .topbar{ background:var(--primary-color); color:#fff; border-bottom:1px solid rgba(255,255,255,.15); }
    .topbar .brand{ font-size:1.35rem; font-weight:700; }
    .profile-chip{ display:flex; align-items:center; gap:.75rem; color:#fff; text-decoration:none; }
    .profile-chip .avatar{ width:64px; height:64px; border-radius:50%; background:#e9ecef; overflow:hidden; border:3px solid rgba(255,255,255,.5); display:flex; align-items:center; justify-content:center; }
    .profile-chip .avatar img{ width:100%; height:100%; object-fit:cover; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.75rem; margin-right:.5rem; color:#495057; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; font-weight:600; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }

    /* User Management card */
    .um-card{ background:#fff; border:1px solid #e9ecef; border-radius:1.25rem; }
    .um-title{ font-weight:700; }
    .table thead th{ white-space:nowrap; }
    .badge-role{ font-weight:700; }
    .btn-square{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; border-radius:.5rem; }
    .btn-edit{ background:#fff; border:1px solid #adb5bd; color:#495057; }
    .btn-delete{ background:#fff; border:2px solid #dc3545; color:#dc3545; }
    .footer-bar{ background:var(--primary-color); color:#fff; border-top-left-radius:1rem; border-top-right-radius:1rem; }
  </style>
</head>
<body>

  <!-- TOP BLUE BAR -->
  <header class="topbar">
    <div class="container-fluid px-3 px-md-4 py-3">
      <div class="d-flex flex-column flex-lg-row align-items-start align-items-lg-center justify-content-between">
        <div class="brand d-flex align-items-center gap-2">
          <i class="fas fa-tools"></i>
          <span>Admin Dashboard - SkillLink</span>
        </div>
        <a class="profile-chip mt-3 mt-lg-0" href="${pageContext.request.contextPath}/admin/users/view?id=${sessionScope.adminUser.userId}">
          <div class="avatar">
            <c:choose>
              <c:when test="${not empty sessionScope.adminUser.userId}">
                <img src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.adminUser.userId}" alt="Profile">
              </c:when>
              <c:otherwise><i class="fa-regular fa-user fa-2x text-muted"></i></c:otherwise>
            </c:choose>
          </div>
          <div class="text-end">
            <div class="fw-bold"><c:out value="${empty sessionScope.adminUser.fullName ? 'Admin User Name' : sessionScope.adminUser.fullName}"/></div>
            <div class="small opacity-75">Administrator</div>
          </div>
        </a>
      </div>
    </div>
    <!-- Tabs row -->
    <div class="nav-tabs-row">
      <div class="container-fluid px-3 px-md-4 py-2 d-flex align-items-center">
        <ul class="nav">
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">Manage users</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">Messages</a></li>
        </ul>
        <div class="ms-auto">
          <a class="btn btn-logout" href="${pageContext.request.contextPath}/auth/logout">Logout</a>
        </div>
      </div>
    </div>
  </header>

  <!-- PAGE CONTENT -->
  <main class="container-fluid px-3 px-md-4 py-3 py-md-4">

    <!-- Bootstrap alerts -->
    <c:if test="${not empty error}">
      <div class="alert alert-danger d-flex align-items-center" role="alert">
        <i class="fa-solid fa-circle-exclamation me-2"></i><div>${error}</div>
      </div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success d-flex align-items-center" role="alert">
        <i class="fa-solid fa-circle-check me-2"></i><div>${success}</div>
      </div>
    </c:if>

    <!-- USER MANAGEMENT -->
    <div class="um-card p-3 p-md-4">
      <div class="d-flex align-items-center justify-content-between mb-2">
        <h5 class="um-title mb-0">User Management</h5>
        <a href="${pageContext.request.contextPath}/admin/users/new" class="btn btn-primary">
          <i class="fa-solid fa-user-plus me-1"></i> Add User
        </a>
      </div>

      <div class="table-responsive">
        <table class="table align-middle">
          <thead class="table-light">
            <tr>
              <th>ID</th>
              <th style="min-width:260px;">Name</th>
              <th>Email</th>
              <th>Address</th>
              <th>Type</th>
              <th>Status</th>
              <th class="text-end">Actions</th>
            </tr>
          </thead>
          <tbody>
            <!-- Render users from DB (no dummy data) -->
            <c:forEach var="u" items="${users}">
              <tr>
                <td>${u.userId}</td>

                <!-- Name col: profile + name -->
                <td>
                  <div class="d-flex align-items-center">
                    <img src="${pageContext.request.contextPath}/media/user/profile?userId=${u.userId}"
                         alt="" class="rounded me-3" style="width:48px;height:48px;object-fit:cover;">
                    <div>
                      <div class="fw-semibold">${u.fullName}</div>
                      <div class="text-muted small">@${u.username}</div>
                    </div>
                  </div>
                </td>

                <td>${u.email}</td>
                <td>${u.addressLine}</td>

                <!-- Type chip (role) -->
                <td>
                  <c:choose>
                    <c:when test="${u.roleName=='worker'}">
                      <span class="badge text-bg-secondary badge-role">Worker</span>
                    </c:when>
                    <c:when test="${u.roleName=='client'}">
                      <span class="badge text-bg-info text-dark badge-role">Client</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge text-bg-primary badge-role">Admin</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <!-- Status chip (Verified / pending / Suspended) -->
                <td>
                  <c:choose>
                    <!-- Suspended if not active -->
                    <c:when test="${!u.active}">
                      <span class="badge text-bg-danger">Suspended</span>
                    </c:when>
                    <c:when test="${u.verificationStatus=='verified'}">
                      <span class="badge text-bg-success">Verified</span>
                    </c:when>
                    <c:when test="${u.verificationStatus=='pending' || u.verificationStatus=='unverified'}">
                      <span class="badge text-bg-warning text-dark">pending</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge text-bg-danger">denied</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <!-- Actions (Edit / Delete) -->
                <td class="text-end">
                  <a class="btn btn-edit btn-square me-1" title="Edit"
                     href="${pageContext.request.contextPath}/admin/users/edit?id=${u.userId}">
                    <strong>E</strong>
                  </a>

                  <!-- Delete confirm modal trigger -->
                  <button type="button" class="btn btn-delete btn-square" title="Delete"
                          data-bs-toggle="modal" data-bs-target="#del${u.userId}">
                    <strong>D</strong>
                  </button>

                  <!-- Delete Modal -->
                  <div class="modal fade" id="del${u.userId}" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                      <form class="modal-content" method="post" action="${pageContext.request.contextPath}/admin/users/delete">
                        <div class="modal-header">
                          <h5 class="modal-title"><i class="fa-solid fa-triangle-exclamation text-danger me-2"></i>Delete User</h5>
                          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                          <input type="hidden" name="userId" value="${u.userId}">
                          <p class="mb-0">Are you sure you want to delete <strong>${u.fullName}</strong> (@${u.username})? This action cannot be undone.</p>
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                          <button type="submit" class="btn btn-danger">Delete</button>
                        </div>
                      </form>
                    </div>
                  </div>
                </td>
              </tr>
            </c:forEach>

            <!-- Empty state -->
            <c:if test="${empty users}">
              <tr>
                <td colspan="7" class="text-center text-muted py-4">
                  No users found.
                </td>
              </tr>
            </c:if>
          </tbody>
        </table>
      </div>

      <!-- Optional pagination (only show if servlet sets totalPages > 1) -->
      <c:if test="${totalPages > 1}">
        <div class="d-flex justify-content-between align-items-center mt-2">
          <div class="small text-muted">Page ${page} of ${totalPages}</div>
          <ul class="pagination mb-0">
            <li class="page-item <c:if test='${page<=1}'>disabled</c:if>'">
              <a class="page-link" href="${pageContext.request.contextPath}/admin/users?${queryNoPage}&page=${page-1}">Prev</a>
            </li>
            <li class="page-item <c:if test='${page>=totalPages}'>disabled</c:if>'">
              <a class="page-link" href="${pageContext.request.contextPath}/admin/users?${queryNoPage}&page=${page+1}">Next</a>
            </li>
          </ul>
        </div>
      </c:if>
    </div>
  </main>

  <!-- FOOTER (same visual as dashboard) -->
  <footer class="footer-bar mt-4">
    <div class="container-fluid px-3 px-md-4 py-4 d-flex flex-column flex-lg-row gap-4 justify-content-between align-items-start">
      <div>
        <h6 class="mb-3">Quick Links</h6>
        <div class="d-flex flex-column gap-1">
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/users">Manage users</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/messages">Messages</a>
        </div>
      </div>
      <div class="text-center flex-fill">
        <div class="fw-bold">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
        <div class="small opacity-75 mt-2">&copy; <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara</div>
      </div>
      <div>
        <h6 class="mb-3">Contact Us</h6>
        <div class="d-flex align-items-center gap-2">
          <a class="btn btn-light btn-sm" title="Facebook" href="#"><i class="fab fa-facebook-f"></i></a>
          <a class="btn btn-light btn-sm" title="X" href="#"><i class="fab fa-x-twitter"></i></a>
          <a class="btn btn-light btn-sm" title="LinkedIn" href="#"><i class="fab fa-linkedin-in"></i></a>
          <a class="btn btn-light btn-sm" title="Email" href="mailto:support@skilllink.lk"><i class="fa-regular fa-envelope"></i></a>
        </div>
      </div>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
