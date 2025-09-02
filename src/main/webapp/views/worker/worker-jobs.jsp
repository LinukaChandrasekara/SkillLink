<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
  com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
  String rn = (String) session.getAttribute("roleName");
  if (me == null || !"WORKER".equals(rn)) {
      response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
      return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Worker • Job Offers - SkillLink</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#DCDCDC; }
    html,body { height:100%; }
    body{ background:var(--light); display:flex; flex-direction:column; min-height:100vh; }
    main{ flex:1 0 auto; }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.25rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .avatar{ width:48px; height:48px; border-radius:50%; object-fit:cover; background:#e9ecef; }
    .card-offer{ border:1px solid #e9ecef; border-radius:1rem; overflow:hidden; }
    .card-offer .hdr{ background:#2856ea; color:#fff; font-weight:700; padding:.55rem .8rem; }
    .card-offer .body{ padding:.75rem .8rem; font-size:.95rem; }
    .card-offer .meta{ color:#6c757d; font-size:.9rem; }
    .footer{ background:var(--primary); color:#fff; flex-shrink:0; }
    .badge-soft{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
  </style>
</head>
<body>

<header class="topbar">
  <div class="container-fluid px-3 px-md-4 py-3 d-flex justify-content-between align-items-center flex-wrap">
    <div class="d-flex align-items-center gap-2">
      <i class="bi bi-tools fs-4"></i><div class="brand">Worker Dashboard - SkillLink</div>
    </div>
    <div class="d-flex align-items-center gap-2 mt-2 mt-md-0">
      <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}" alt="">
      <div class="text-end">
        <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
        <div class="small opacity-75">Worker</div>
      </div>
      <a class="btn btn-logout ms-3" href="${pageContext.request.contextPath}/auth/logout"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
    </div>
  </div>
  <div class="nav-tabs-row">
    <div class="container-fluid px-3 px-md-4 py-2">
      <ul class="nav">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/worker/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/worker/jobs">Job Offers</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/worker/messages">Messages</a></li>
      </ul>
    </div>
  </div>
</header>

<main class="container-fluid px-3 px-md-4 py-3">
  <!-- Flash -->
  <c:if test="${not empty param.accepted}">
    <div class="alert alert-success"><i class="bi bi-check2-circle me-1"></i>Offer accepted. The client has been notified.</div>
  </c:if>
  <c:if test="${not empty param.done}">
    <div class="alert alert-success"><i class="bi bi-check2-circle me-1"></i>Job marked as completed.</div>
  </c:if>
  <c:if test="${not empty param.error}">
    <div class="alert alert-danger"><i class="bi bi-exclamation-triangle me-1"></i>${param.error}</div>
  </c:if>

  <!-- Offers -->
  <div class="d-flex align-items-center justify-content-between">
    <h5 class="mb-2 mb-md-0">Job offers</h5>
    <span class="badge badge-soft">Available: ${fn:length(offers)}</span>
  </div>

  <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-3 mt-1">
    <c:forEach var="j" items="${offers}">
      <div class="col">
        <div class="card-offer h-100">
          <div class="hdr"><i class="bi bi-briefcase me-1"></i><c:out value="${j.title}"/></div>
          <div class="body">
            <div class="d-flex align-items-center gap-2 mb-2">
              <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${j.clientId}" alt="">
              <div>
                <div class="fw-semibold">Posted by <span class="text-primary"><c:out value="${j.clientName}"/></span></div>
                <div class="meta">Category: <c:out value="${j.jobCategoryName}"/></div>
              </div>
            </div>
            <div class="meta mb-2">
              <div><i class="bi bi-geo-alt me-1"></i><c:out value="${j.locationText}"/></div>
              <div><i class="bi bi-cash-coin me-1"></i>Rs. ${j.budgetAmount}</div>
            </div>
            <div class="small text-muted mb-3" style="min-height:3.2rem;"><c:out value="${j.description}"/></div>

            <form method="post" action="${pageContext.request.contextPath}/worker/jobs/accept" class="d-grid">
              <input type="hidden" name="jobId" value="${j.jobId}"/>
              <button class="btn btn-success">
                <i class="bi bi-check2 me-1"></i>Accept
              </button>
            </form>
          </div>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty offers}">
      <div class="col">
        <div class="alert alert-info mb-0"><i class="bi bi-info-circle me-1"></i>No matching offers right now.</div>
      </div>
    </c:if>
  </div>

  <!-- Accepted jobs -->
  <div class="mt-4">
    <div class="d-flex align-items-center justify-content-between">
      <h5 class="mb-2 mb-md-0">Accepted jobs</h5>
      <span class="badge text-bg-success">Total: ${fn:length(accepted)}</span>
    </div>

    <div class="table-responsive mt-2">
      <table class="table table-bordered align-middle bg-white">
        <thead class="table-light">
        <tr>
          <th>Job Title</th>
          <th>Client</th>
          <th>Category</th>
          <th>Budget</th>
          <th>Accepted On</th>
          <th class="text-center">Status</th>
          <th class="text-center">Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${accepted}">
          <tr>
            <td class="fw-semibold"><c:out value="${a.title}"/></td>
            <td><c:out value="${a.clientName}"/></td>
            <td><c:out value="${a.categoryName}"/></td>
            <td>Rs. ${a.budgetAmount}</td>
            <td><c:out value="${a.acceptedAt}"/></td>
            <td class="text-center">
              <c:choose>
                <c:when test="${a.assignmentStatus eq 'completed'}"><span class="badge bg-success">Completed</span></c:when>
                <c:when test="${a.assignmentStatus eq 'in_progress'}"><span class="badge bg-primary">In progress</span></c:when>
                <c:otherwise><span class="badge bg-warning text-dark">Accepted</span></c:otherwise>
              </c:choose>
            </td>
            <td class="text-center">
              <c:choose>
                <c:when test="${a.assignmentStatus eq 'completed'}">
                  <button class="btn btn-outline-secondary btn-sm" disabled>Done</button>
                </c:when>
                <c:otherwise>
                  <form method="post" action="${pageContext.request.contextPath}/worker/jobs/status" class="d-inline">
                    <input type="hidden" name="jobId" value="${a.jobId}"/>
                    <input type="hidden" name="action" value="complete"/>
                    <button class="btn btn-success btn-sm"><i class="bi bi-check2 me-1"></i>Mark completed</button>
                  </form>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty accepted}">
          <tr><td colspan="7" class="text-center text-muted py-4">No accepted jobs yet.</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>
  </div>
</main>

<footer class="footer mt-auto">
  <div class="container-fluid px-3 px-md-4 py-3 d-flex justify-content-between align-items-center flex-wrap">
    <div class="small">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
    <div class="small">&copy; <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara</div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
