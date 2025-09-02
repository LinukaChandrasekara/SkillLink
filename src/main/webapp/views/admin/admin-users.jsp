<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // Session & role guard (admin only)
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
  <title>Manage Users - SkillLink</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#DCDCDC; }
    body{ background:var(--light); }
    .app{ min-height:100vh; }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.35rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
    .table thead th{ white-space:nowrap; }
    .kbd-badge{font-size:.8rem;}
    .badge-status{ font-size:.85rem; }
    .rounded-outer{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
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
          <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/users">Manage users</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">Messages</a></li>
        </ul>
        <div class="ms-auto d-flex gap-2">
          <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
            <i class="bi bi-person-plus me-1"></i> Add User
          </button>
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

    <div class="rounded-outer p-3">
      <h5 class="mb-3">User Management</h5>

      <!-- FILTERS -->
      <form class="row g-2 align-items-end mb-3" method="get" action="${pageContext.request.contextPath}/admin/users">
        <div class="col-12 col-md-4">
          <label class="form-label small text-muted">Search</label>
          <input type="text" class="form-control" name="q" value="${param.q}" placeholder="name, username, email">
        </div>
        <div class="col-6 col-md-3">
          <label class="form-label small text-muted">Role</label>
          <select class="form-select" name="role">
            <option value="">All</option>
            <option value="admin"  ${param.role=='admin'?'selected':''}>Admin</option>
            <option value="worker" ${param.role=='worker'?'selected':''}>Worker</option>
            <option value="client" ${param.role=='client'?'selected':''}>Client</option>
          </select>
        </div>
        <div class="col-6 col-md-3">
          <label class="form-label small text-muted">Verification</label>
          <select class="form-select" name="verification">
            <option value="">All</option>
            <option value="unverified" ${param.verification=='unverified'?'selected':''}>Unverified</option>
            <option value="pending"    ${param.verification=='pending'?'selected':''}>Pending</option>
            <option value="verified"   ${param.verification=='verified'?'selected':''}>Verified</option>
            <option value="denied"     ${param.verification=='denied'?'selected':''}>Denied</option>
          </select>
        </div>
        <div class="col-12 col-md-2 d-grid">
          <button class="btn btn-outline-primary"><i class="bi bi-funnel me-1"></i> Apply</button>
        </div>
      </form>

      <!-- TABLE -->
      <div class="table-responsive">
        <table class="table table-bordered align-middle">
          <thead class="table-light">
          <tr>
            <th style="width:100px;">ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Address</th>
            <th class="text-center" style="width:120px;">Type</th>
            <th class="text-center" style="width:140px;">Status</th>
            <th class="text-center" style="width:140px;">Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="u" items="${pageResult.items}">
            <tr data-user='{"id":${u.userId},"name":"${fn:escapeXml(u.fullName)}","username":"${fn:escapeXml(u.username)}","email":"${fn:escapeXml(u.email)}","role":"${u.roleName}","status":"${u.verificationStatus}","active":${u.active}}'>
              <td><span class="text-muted">${u.userId}</span></td>
              <td>
                <div class="d-flex align-items-center gap-2">
                  <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${u.userId}" alt="">
                  <div>
                    <div class="fw-semibold">${u.fullName}</div>
                    <div class="text-muted small">@${u.username}</div>
                  </div>
                </div>
              </td>
              <td>${u.email}</td>
              <td>${u.addressLine}</td>
              <td class="text-center">
                <c:choose>
                  <c:when test="${u.roleName.name()=='ADMIN'}"><span class="badge bg-dark">Admin</span></c:when>
                  <c:when test="${u.roleName.name()=='WORKER'}"><span class="badge bg-secondary">Worker</span></c:when>
                  <c:otherwise><span class="badge bg-info text-dark">Client</span></c:otherwise>
                </c:choose>
              </td>
              <td class="text-center">
                <c:choose>
                  <c:when test="${u.verificationStatus.name()=='VERIFIED'}"><span class="badge bg-success badge-status">Verified</span></c:when>
                  <c:when test="${u.verificationStatus.name()=='PENDING'}"><span class="badge bg-warning text-dark badge-status">pending</span></c:when>
                  <c:when test="${u.verificationStatus.name()=='DENIED'}"><span class="badge bg-danger badge-status">denied</span></c:when>
                  <c:otherwise><span class="badge bg-secondary badge-status">unverified</span></c:otherwise>
                </c:choose>
                <c:if test="${!u.active}">
                  <div class="small mt-1"><span class="badge bg-danger">Suspended</span></div>
                </c:if>
              </td>
              <td class="text-center">
                <button class="btn btn-outline-secondary btn-sm me-1" data-bs-toggle="modal" data-bs-target="#editUserModal"
                        onclick="openEdit(this)" title="Edit"><i class="bi bi-pencil-square"></i></button>

                <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/users/delete"
                      onsubmit="return confirm('Delete this user? This cannot be undone.');">
                  <input type="hidden" name="userId" value="${u.userId}">
                  <button class="btn btn-outline-danger btn-sm" title="Delete"><i class="bi bi-trash"></i></button>
                </form>
              </td>
            </tr>
          </c:forEach>

          <c:if test="${empty pageResult.items}">
            <tr><td colspan="7" class="text-center text-muted py-4">No users found.</td></tr>
          </c:if>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <c:if test="${pageResult.totalPages > 1}">
        <nav aria-label="Users pages">
          <ul class="pagination justify-content-end">
            <c:set var="page" value="${pageResult.page}"/>
            <c:forEach var="p" begin="1" end="${pageResult.totalPages}">
              <li class="page-item ${p==page?'active':''}">
                <a class="page-link"
                   href="${pageContext.request.contextPath}/admin/users?q=${fn:escapeXml(param.q)}&role=${param.role}&verification=${param.verification}&page=${p}">
                  ${p}
                </a>
              </li>
            </c:forEach>
          </ul>
        </nav>
      </c:if>

    </div>

  </main>

  <!-- STICKY FOOTER -->
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

<!-- ========= ADD USER MODAL ========= -->
<div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/admin/users/create" enctype="multipart/form-data">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-person-plus me-2"></i>Add User</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-12 col-md-4">
            <label class="form-label">Role</label>
            <select class="form-select" name="role" id="roleSelect" required>
              <option value="worker">Worker</option>
              <option value="client">Client</option>
              <option value="admin">Admin</option>
            </select>
          </div>
          <div class="col-12 col-md-8">
            <div class="alert alert-light border small mb-0">
              <i class="bi bi-info-circle me-1"></i>
              Workers need a <b>job category</b> and <b>experience</b>. Clients must choose <b>Individual/Business</b>.
            </div>
          </div>

          <div class="col-12 col-md-6">
            <label class="form-label">Full name</label>
            <input name="full_name" class="form-control" required maxlength="150">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">NID</label>
            <input name="nid" class="form-control" required maxlength="50">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Phone</label>
            <input name="phone" class="form-control" required maxlength="30">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required maxlength="160">
          </div>
          <div class="col-12 col-md-3">
            <label class="form-label">Age</label>
            <input type="number" name="age" min="16" max="100" class="form-control" required>
          </div>
          <div class="col-12 col-md-9">
            <label class="form-label">Address</label>
            <input name="address_line" class="form-control" required maxlength="255">
          </div>

          <div class="col-12 col-md-6">
            <label class="form-label">Username</label>
            <input name="username" class="form-control" required minlength="4" maxlength="60">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" required minlength="8">
          </div>

          <!-- Worker-only -->
          <div class="col-12 col-md-6 role-worker">
            <label class="form-label">Job category</label>
            <select name="job_category_id" class="form-select">
              <c:forEach var="cat" items="${jobCategories}">
                <option value="${cat.jobCategoryId}">${cat.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-12 col-md-6 role-worker">
            <label class="form-label">Experience (years)</label>
            <input type="number" name="experience_years" class="form-control" min="0" max="60" value="0">
          </div>

          <!-- Client-only -->
          <div class="col-12 role-client">
            <label class="form-label">Client type</label>
            <div class="d-flex gap-4">
              <div class="form-check">
                <input class="form-check-input" type="radio" name="client_type" id="ctype1" value="individual" checked>
                <label class="form-check-label" for="ctype1"><i class="bi bi-person"></i> Individual</label>
              </div>
              <div class="form-check">
                <input class="form-check-input" type="radio" name="client_type" id="ctype2" value="business">
                <label class="form-check-label" for="ctype2"><i class="bi bi-buildings"></i> Business</label>
              </div>
            </div>
          </div>

          <div class="col-12 col-md-6">
            <label class="form-label">Profile picture</label>
            <input type="file" class="form-control" name="profile_picture" accept="image/*" required>
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">ID photo (optional)</label>
            <input type="file" class="form-control" name="id_photo" accept="image/*">
          </div>

        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary"><i class="bi bi-save me-1"></i> Save</button>
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </form>
  </div>
</div>

<!-- ========= EDIT STATUS / SUSPEND MODAL ========= -->
<div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/admin/users/update">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit User</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="userId" id="editUserId">
        <div class="mb-2">
          <div class="small text-muted">User</div>
          <div id="editUserLabel" class="fw-semibold"></div>
          <div class="text-muted small" id="editUserMeta"></div>
        </div>
        <div class="mb-3">
          <label class="form-label">Verification status</label>
          <select class="form-select" name="verificationStatus" id="editStatus">
            <option value="unverified">unverified</option>
            <option value="pending">pending</option>
            <option value="verified">verified</option>
            <option value="denied">denied</option>
          </select>
        </div>
        <div class="form-check form-switch">
          <input class="form-check-input" type="checkbox" id="editActive" name="active" value="true">
          <label class="form-check-label" for="editActive">Active (untick to suspend)</label>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary"><i class="bi bi-save me-1"></i> Update</button>
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function toggleRoleSections(role){
    document.querySelectorAll('.role-worker').forEach(el=>el.style.display = role==='worker' ? '' : 'none');
    document.querySelectorAll('.role-client').forEach(el=>el.style.display = role==='client' ? '' : 'none');
  }
  document.getElementById('roleSelect')?.addEventListener('change', function(){ toggleRoleSections(this.value); });
  toggleRoleSections(document.getElementById('roleSelect')?.value || 'worker');

  // Fill Edit modal from the row's data-user attribute
  window.openEdit = function(btn){
    const tr = btn.closest('tr');
    const data = JSON.parse(tr.getAttribute('data-user'));
    document.getElementById('editUserId').value = data.id;
    document.getElementById('editUserLabel').textContent = data.name;
    document.getElementById('editUserMeta').textContent = '@'+data.username+' • '+data.role;
    document.getElementById('editStatus').value = (data.status||'unverified').toLowerCase();
    document.getElementById('editActive').checked = !!data.active;
  }
</script>
</body>
</html>
