<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
  com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
  Object rn = session.getAttribute("roleName");
  if (me == null || rn == null || !"WORKER".equals(String.valueOf(rn))) {
      response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
      return;
  }
  String vStatus = (String) request.getAttribute("verificationStatus"); // unverified | pending | verified | denied
  boolean unverified = "unverified".equalsIgnoreCase(vStatus) || "denied".equalsIgnoreCase(vStatus);
  boolean pending    = "pending".equalsIgnoreCase(vStatus);
  boolean verified   = "verified".equalsIgnoreCase(vStatus);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Worker Dashboard - SkillLink</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#f5f6f8; }
    body{ background:var(--light); }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.35rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .rounded-outer{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
    .chip{ display:inline-block; padding:.2rem .6rem; border-radius:999px; font-size:.8rem; }
    .chip-verified{ background:#d1e7dd; color:#0f5132; }
    .chip-pending{ background:#fff3cd; color:#664d03; }
    .chip-unverified{ background:#f8d7da; color:#842029; }
    .offer-card{ border:1px solid #e9ecef; border-radius:1rem; }
    .offer-head{ background:#eef2ff; border-top-left-radius:1rem; border-top-right-radius:1rem; padding:.5rem .75rem; font-weight:700; }
    .stat{ border:1px solid #e9ecef; border-radius:1rem; background:#fff; }
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
          <div class="brand">Worker Dashboard - SkillLink</div>
        </div>
        <div class="d-flex align-items-center gap-3 mt-3 mt-lg-0">
          <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}" alt="Profile">
          <div class="text-end">
            <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
            <div class="small opacity-75">Worker</div>
          </div>
        </div>
      </div>
    </div>

    <!-- NAV TABS -->
    <div class="nav-tabs-row">
      <div class="container-fluid px-3 px-md-4 py-2 d-flex align-items-center">
        <ul class="nav">
          <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/worker/dashboard">Dashboard</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/worker/profile">Manage Profile</a></li>

          <c:if test="<%= !verified %>">
            <li class="nav-item">
              <a class="nav-link" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#uploadIdModal">Verifications</a>
            </li>
          </c:if>

          <li class="nav-item">
            <a class="nav-link" id="nav-offers" href="${pageContext.request.contextPath}/worker/dashboard#offers" data-gate="verify">Job offers</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="nav-msg" href="${pageContext.request.contextPath}/worker/messages" data-gate="verify">Messages</a>
          </li>
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

    <!-- Verification banners -->
    <c:if test="<%= unverified %>">
      <div class="alert alert-warning d-flex align-items-center justify-content-between rounded-outer">
        <div>
          <strong>Account Verification Required</strong> — Upload your ID photo to get verified and unlock all features.
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#uploadIdModal">
          <i class="bi bi-upload me-1"></i> Upload ID
        </button>
      </div>
    </c:if>
    <c:if test="<%= pending %>">
      <div class="alert alert-info d-flex align-items-center rounded-outer">
        <i class="bi bi-hourglass-split me-2"></i> Your verification is pending admin review.
      </div>
    </c:if>

    <div class="row g-3">
      <!-- LEFT PROFILE CARD -->
      <div class="col-12 col-lg-3">
        <div class="rounded-outer p-3 text-center">
          <img class="avatar mb-2" src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}" alt="Profile">
          <div class="mb-2">
            <c:choose>
              <c:when test="<%= verified %>"><span class="chip chip-verified"><i class="bi bi-patch-check-fill me-1"></i>Verified</span></c:when>
              <c:when test="<%= pending %>"><span class="chip chip-pending"><i class="bi bi-hourglass-split me-1"></i>Pending</span></c:when>
              <c:otherwise><span class="chip chip-unverified"><i class="bi bi-shield-exclamation me-1"></i>Unverified</span></c:otherwise>
            </c:choose>
          </div>

          <div class="fw-semibold"><c:out value="${sessionScope.authUser.fullName}"/></div>
          <div class="small text-muted mb-1"><c:out value="${sessionScope.authUser.addressLine}"/></div>

          <div class="small text-muted mb-2" style="min-height:2.6rem;">
            <c:out value="${sessionScope.authUser.bio}"/>
          </div>

          <div class="mb-2">
            <span class="text-warning">
              <c:forEach var="i" begin="1" end="5">
                <i class="bi" style="font-size:1rem; vertical-align:middle; <%-- filled or empty --%>">
                  <c:choose>
                    <c:when test="${i <= ratingRounded}">★</c:when>
                    <c:otherwise>☆</c:otherwise>
                  </c:choose>
                </i>
              </c:forEach>
            </span>
            <span class="small text-muted ms-1">(${ratingCount} reviews)</span>
          </div>

          <a class="btn btn-outline-primary w-100" href="${pageContext.request.contextPath}/worker/profile">
            <i class="bi bi-pencil-square me-1"></i> Edit profile
          </a>
        </div>
      </div>

      <!-- RIGHT CONTENT -->
      <div class="col-12 col-lg-9">
        <!-- Stats row -->
        <div class="row g-3">
          <div class="col-12 col-md-4">
            <div class="stat p-3">
              <div class="text-muted">Completed jobs</div>
              <div class="display-6 fw-bold">${completedJobs}</div>
            </div>
          </div>
          <div class="col-12 col-md-8">
            <div class="rounded-outer p-3 d-flex align-items-center justify-content-between">
              <div>
                <div class="fw-bold">Hourly Wage Estimator</div>
                <div class="small text-muted">A machine-learning model that predicts a fair hourly pay range for a job using role, skills, location and experience.</div>
              </div>
              <a class="btn btn-primary disabled" href="#">To the Model</a>
            </div>
          </div>
        </div>

        <!-- Job offers -->
        <div id="offers" class="rounded-outer p-3 mt-3">
          <div class="d-flex align-items-center justify-content-between">
            <h6 class="mb-0">Job offers</h6>
            <span class="badge text-bg-primary">${fn:length(offers)}</span>
          </div>
			  <div class="row row-cols-1 row-cols-md-3 g-3 mt-2">
			    <c:forEach var="j" items="${matchingJobs}">
			      <div class="col">
			        <div class="card h-100">
			          <div class="card-header fw-semibold">
			            <i class="bi bi-briefcase me-1"></i><c:out value="${j.title}"/>
			          </div>
			          <div class="card-body small">
			            <div class="mb-2 text-muted" style="min-height:3.6rem;">
			              <c:out value="${j.description}"/>
			            </div>
			            <div class="d-flex flex-column gap-1">
			              <div><i class="bi bi-geo-alt me-1"></i><c:out value="${j.locationText}"/></div>
			              <div><i class="bi bi-tag me-1"></i><c:out value="${j.jobCategoryName}"/></div>
			              <div><i class="bi bi-person me-1"></i>Client: <c:out value="${j.clientName}"/></div>
			              <div><i class="bi bi-cash-coin me-1"></i>Rs. ${j.budgetAmount}</div>
			            </div>
			          </div>
			          <div class="card-footer text-end">
			            <a class="btn btn-success btn-sm"
			               href="${pageContext.request.contextPath}/worker/offers/accept?jobId=${j.jobId}">
			              Accept
			            </a>
			          </div>
			        </div>
			      </div>
			    </c:forEach>
			
			    <c:if test="${empty matchingJobs}">
			      <div class="col">
			        <div class="alert alert-info mb-0">
			          No matching jobs yet for your category
			          <c:if test="${empty workerCategoryId}">(please set your category in profile)</c:if>.
			        </div>
			      </div>
			    </c:if>
          </div>
        </div>

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
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/worker/profile">Manage Profile</a>
            <c:choose>
              <c:when test="<%= unverified %>"><a class="link-light text-decoration-none" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#uploadIdModal">Verifications</a></c:when>
              <c:otherwise><a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/worker/verification">Verifications</a></c:otherwise>
            </c:choose>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/worker/dashboard#offers">Job offers</a>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/worker/messages">Messages</a>
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
            <a class="contact-icon" href="#"><i class="bi bi-twitter-x"></i></a>
            <a class="contact-icon" href="#"><i class="bi bi-instagram"></i></a>
            <a class="contact-icon" href="mailto:support@skilllink.lk"><i class="bi bi-envelope"></i></a>
          </div>
        </div>
      </div>
    </div>
  </footer>
</div>

<!-- Upload ID Modal -->
<div class="modal fade" id="uploadIdModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/worker/verification/upload" enctype="multipart/form-data">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-shield-lock me-1"></i>Upload ID for Verification</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p class="small text-muted">Upload a clear photo/scan of your NIC/ID. Your account status will change to <strong>Pending</strong> until an admin reviews it.</p>
        <input type="file" class="form-control" name="id_photo" accept="image/*" required />
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary"><i class="bi bi-upload me-1"></i> Submit</button>
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  (function () {
    const isUnverified = '<%= (unverified) ? "1" : "0" %>' === '1';
    document.querySelectorAll('a[data-gate="verify"]').forEach(a => {
      a.addEventListener('click', function (e) {
        if (isUnverified) {
          e.preventDefault();
          const m = new bootstrap.Modal(document.getElementById('uploadIdModal'));
          m.show();
        }
      });
    });
  })();
</script>
</body>
</html>
