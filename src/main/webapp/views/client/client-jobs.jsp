<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
	Object rn = session.getAttribute("roleName");
	if (me == null || rn == null || !"CLIENT".equals(String.valueOf(rn))) {
	    response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
	    return;
	}
    String vStatus = (String) request.getAttribute("verificationStatus");
    boolean unverified = vStatus == null || "unverified".equalsIgnoreCase(vStatus) || "denied".equalsIgnoreCase(vStatus);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>SkillLink | Client • Job Post Management</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#f5f6f8; }
    body{ background:var(--light); }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.25rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .cardish{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
    /* table */
    .tbl-wrap{ overflow-x:auto; }
    .status-badge{ padding:.25rem .6rem; border-radius:999px; font-size:.78rem; }
    .status-approved{ background:#d1e7dd; color:#0f5132; }
    .status-pending{ background:#fff3cd; color:#664d03; }
    .status-denied{  background:#f8d7da; color:#842029; }
    .status-closed{  background:#e2e3e5; color:#41464b; }
    .status-completed{ background:#cfe2ff; color:#084298; }
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
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/profile">Manage Profile</a></li>
			<!-- Verifications (only if NOT verified) -->
			<c:if test="<%= unverified %>">
			  <li class="nav-item">
			    <a class="nav-link" href="javascript:void(0)"
			       data-bs-toggle="modal" data-bs-target="#uploadIdModal">
			      Verifications
			    </a>
			  </li>
			</c:if>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/client/jobs">Job Post Management</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/messages">Messages</a></li>
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
  <!-- Alerts -->
  <c:if test="${not empty param.success}">
    <div class="alert alert-success alert-dismissible fade show"><i class="bi bi-check-circle me-1"></i>${param.success}<button class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show"><i class="bi bi-exclamation-triangle me-1"></i>${param.error}<button class="btn-close" data-bs-dismiss="alert"></button></div>
  </c:if>

  <!-- Unverified banner -->
  <c:if test="<%= unverified %>">
    <div class="alert alert-warning d-flex align-items-center" role="alert">
      <i class="bi bi-shield-exclamation me-2"></i>
      <div>Your account is <strong>not verified</strong>. You can view posts, but adding or editing is disabled. Please upload your ID on the <a class="link-dark fw-semibold ms-1" href="${pageContext.request.contextPath}/client/verification">Verifications</a> page.</div>
    </div>
  </c:if>

  <div class="cardish p-3">
    <div class="d-flex justify-content-between align-items-center mb-2">
      <h5 class="mb-0"><i class="bi bi-briefcase me-2"></i>Job Management</h5>
      <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addJobModal" <%= unverified ? "disabled" : "" %>>
        <i class="bi bi-plus-circle me-1"></i> Add Job
      </button>
    </div>

    <div class="tbl-wrap">
      <table class="table table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th style="min-width:80px">ID</th>
            <th style="min-width:160px">Title</th>
            <th style="min-width:240px">Description</th>
            <th style="min-width:180px">Location/Address</th>
            <th style="min-width:120px">Budget</th>
            <th style="min-width:120px">Status</th>
            <th style="min-width:140px">Actions</th>
          </tr>
        </thead>
        <tbody>
        <c:forEach var="j" items="${jobs}">
          <tr>
            <td>${j.jobId}</td>
            <td><c:out value="${j.title}"/></td>
            <td class="text-muted"><div style="max-width:340px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;"><c:out value="${j.description}"/></div></td>
            <td><c:out value="${j.locationText}"/></td>
            <td>Rs. ${j.budgetAmount}</td>
			<td>
			  <c:set var="st" value="${fn:toLowerCase(j.status)}"/>
			  <span class="status-badge
			    ${st eq 'approved'  ? 'status-approved'  : ''}
			    ${st eq 'pending'   ? 'status-pending'   : ''}
			    ${st eq 'denied'    ? 'status-denied'    : ''}
			    ${st eq 'closed'    ? 'status-closed'    : ''}
			    ${st eq 'completed' ? 'status-completed' : ''}">
			    <c:out value="${st}"/>
			  </span>
			</td>
            <td>
              <div class="btn-group">
                <button type="button" class="btn btn-sm btn-outline-secondary"
                        title="Edit"
                        data-bs-toggle="modal" data-bs-target="#editJobModal"
                        data-jobid="${j.jobId}"
                        data-title="${fn:escapeXml(j.title)}"
                        data-desc="${fn:escapeXml(j.description)}"
                        data-loc="${fn:escapeXml(j.locationText)}"
                        data-budget="${j.budgetAmount}"
                        data-category="${j.jobCategoryId}"
                        <%= unverified ? "disabled" : "" %>>
                  <i class="bi bi-pencil-square"></i>
                </button>
                <form method="post" action="${pageContext.request.contextPath}/client/jobs/delete" class="d-inline"
                      onsubmit="return confirm('Delete this job? This cannot be undone.');">
                  <input type="hidden" name="job_id" value="${j.jobId}">
                  <button class="btn btn-sm btn-outline-danger" title="Delete" <%= unverified ? "disabled" : "" %>>
                    <i class="bi bi-trash"></i>
                  </button>
                </form>
              </div>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty jobs}">
          <tr><td colspan="7" class="text-center text-muted py-4">No jobs yet. Click <strong>Add Job</strong> to post your first job.</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</main>

<!-- Add Job Modal -->
<div class="modal fade" id="addJobModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/client/jobs/create">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-plus-circle me-2"></i>Add Job</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-12 col-md-8">
            <label class="form-label">Title</label>
            <input type="text" name="title" maxlength="150" class="form-control" required>
          </div>
          <div class="col-12 col-md-4">
            <label class="form-label">Category</label>
            <select name="job_category_id" class="form-select" required>
              <c:forEach var="cat" items="${jobCategories}">
                <option value="${cat.jobCategoryId}">${cat.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-12">
            <label class="form-label">Description</label>
            <textarea name="description" rows="4" class="form-control" required></textarea>
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Location / Address</label>
            <input type="text" name="location_text" maxlength="255" class="form-control">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Budget (Rs.)</label>
            <input type="number" step="0.01" min="0" name="budget_amount" class="form-control" required>
          </div>
          <div class="col-12">
            <div class="alert alert-info mb-0"><i class="bi bi-info-circle me-1"></i>
              New jobs are submitted to Admin for review. Status will be <strong>pending</strong> until approved.
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary"><i class="bi bi-save me-1"></i>Submit</button>
      </div>
    </form>
  </div>
</div>

<!-- Edit Job Modal -->
<div class="modal fade" id="editJobModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/client/jobs/update">
      <input type="hidden" name="job_id" id="e_job_id">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Edit Job</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="row g-3">
          <div class="col-12 col-md-8">
            <label class="form-label">Title</label>
            <input type="text" name="title" id="e_title" maxlength="150" class="form-control" required>
          </div>
          <div class="col-12 col-md-4">
            <label class="form-label">Category</label>
            <select name="job_category_id" id="e_category" class="form-select" required>
              <c:forEach var="cat" items="${jobCategories}">
                <option value="${cat.jobCategoryId}">${cat.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-12">
            <label class="form-label">Description</label>
            <textarea name="description" id="e_desc" rows="4" class="form-control" required></textarea>
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Location / Address</label>
            <input type="text" name="location_text" id="e_loc" maxlength="255" class="form-control">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Budget (Rs.)</label>
            <input type="number" step="0.01" min="0" name="budget_amount" id="e_budget" class="form-control" required>
          </div>
          <div class="col-12">
            <div class="alert alert-warning mb-0"><i class="bi bi-info-circle me-1"></i>
              Editing a job sets its status back to <strong>pending</strong> for re-review (applies to pending/denied jobs).
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary"><i class="bi bi-save me-1"></i>Save</button>
      </div>
    </form>
  </div>
</div>

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
<script>
  const editModal = document.getElementById('editJobModal');
  if (editModal) {
    editModal.addEventListener('show.bs.modal', function (ev) {
      const btn = ev.relatedTarget;
      if (!btn) return;
      document.getElementById('e_job_id').value = btn.getAttribute('data-jobid');
      document.getElementById('e_title').value = btn.getAttribute('data-title');
      document.getElementById('e_desc').value = btn.getAttribute('data-desc');
      document.getElementById('e_loc').value  = btn.getAttribute('data-loc');
      document.getElementById('e_budget').value = btn.getAttribute('data-budget');
      const cat = btn.getAttribute('data-category');
      const sel = document.getElementById('e_category');
      if (sel) sel.value = cat;
    });
  }
</script>
</body>
</html>
