<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:url var="jobsUrl" value="/client/jobs"/>
<c:url var="messagesUrl" value="/client/messages"/>



<%
    com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
    Object rn = session.getAttribute("roleName");
    if (me == null || rn == null || !"CLIENT".equals(String.valueOf(rn))) {
        response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
        return;
    }
    String vStatus = (String) request.getAttribute("verificationStatus"); // unverified | pending | verified
    boolean unverified = "unverified".equalsIgnoreCase(vStatus);
    boolean pending    = "pending".equalsIgnoreCase(vStatus);
    boolean verified   = "verified".equalsIgnoreCase(vStatus);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Client Dashboard - SkillLink</title>
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
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
    .stat{ border:1px solid #e9ecef; border-radius:1rem; background:#fff; }
    .chip{ display:inline-block; padding:.2rem .6rem; border-radius:999px; font-size:.8rem; }
    .chip-verified{ background:#d1e7dd; color:#0f5132; }
    .chip-pending{ background:#fff3cd; color:#664d03; }
    .chip-unverified{ background:#f8d7da; color:#842029; }
  </style>
</head>
<body>
<div class="app d-flex flex-column">

  <!-- TOP BAR -->
  <header class="topbar">
    <div class="container-fluid px-3 px-md-4 py-3">
      <div class="d-flex flex-column flex-lg-row align-items-start align-items-lg-center justify-content-between">
        <div class="d-flex align-items-center gap-2">
          <i class="bi bi-people fs-4"></i>
          <div class="brand">Client Dashboard - SkillLink</div>
        </div>
        <div class="d-flex align-items-center gap-3 mt-3 mt-lg-0">
          <img class="avatar"
               src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}"
               alt="Profile">
          <div class="text-end">
            <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
            <div class="small opacity-75">Client</div>
          </div>
        </div>
      </div>
    </div>

    <!-- NAV TABS -->
    <div class="nav-tabs-row">
      <div class="container-fluid px-3 px-md-4 py-2 d-flex align-items-center">
		<ul class="nav">
		  <li class="nav-item">
		    <a class="nav-link active" href="${pageContext.request.contextPath}/client/dashboard">Dashboard</a>
		  </li>
		
		  <li class="nav-item">
		    <a class="nav-link" href="${pageContext.request.contextPath}/client/profile">Manage Profile</a>
		  </li>
		
		  <%-- Verifications: only show if NOT verified --%>
		  <c:if test="<%= !verified %>">
		    <li class="nav-item">
		      <a class="nav-link" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#uploadIdModal">
		        Verifications
		      </a>
		    </li>
		  </c:if>
		
		  <%-- Always point to /client/jobs, gate with JS if unverified --%>
		  <li class="nav-item">
		    <a class="nav-link" id="nav-jobs" href="${jobsUrl}" data-gate="verify">Job Post Management</a>
		  </li>
		
		  <%-- Always point to /client/messages, gate with JS if unverified --%>
		  <li class="nav-item">
		    <a class="nav-link" id="nav-msg"  href="${messagesUrl}" data-gate="verify">Messages</a>
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

    <!-- Only for UNVERIFIED -->
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

    <!-- For PENDING -->
    <c:if test="<%= pending %>">
      <div class="alert alert-info d-flex align-items-center rounded-outer">
        <i class="bi bi-hourglass-split me-2"></i>
        Your verification is pending admin review.
      </div>
    </c:if>

    <div class="row g-3">
      <!-- LEFT PROFILE CARD -->
      <div class="col-12 col-lg-3">
        <div class="rounded-outer p-3 text-center">
          <img class="avatar mb-2"
               src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}"
               alt="Profile">
          <div class="mb-2">
            <c:choose>
              <c:when test="<%= verified %>"><span class="chip chip-verified"><i class="bi bi-patch-check-fill me-1"></i>Verified</span></c:when>
              <c:when test="<%= pending %>"><span class="chip chip-pending"><i class="bi bi-hourglass-split me-1"></i>Pending</span></c:when>
              <c:otherwise><span class="chip chip-unverified"><i class="bi bi-shield-exclamation me-1"></i>Unverified</span></c:otherwise>
            </c:choose>
          </div>
          <div class="fw-semibold"><c:out value="${profile.fullName}"/></div>
          <div class="small text-muted mb-2"><c:out value="${profile.addressLine}"/></div>
          <div class="small text-muted mb-3" style="min-height:2.6rem;"><c:out value="${profile.bio}"/></div>
          <a class="btn btn-outline-primary w-100" href="${pageContext.request.contextPath}/client/profile">
            <i class="bi bi-pencil-square me-1"></i> Edit profile
          </a>
        </div>
      </div>

      <!-- RIGHT CONTENT -->
      <div class="col-12 col-lg-9">
        <!-- Stats -->
        <div class="row g-3">
          <div class="col-12 col-md-4">
            <div class="stat p-3">
              <div class="text-muted">Jobs posted</div>
              <div class="display-6 fw-bold">${stats.jobsPosted}</div>
            </div>
          </div>
          <div class="col-12 col-md-4">
            <div class="stat p-3">
              <div class="text-muted">Hired / Completed</div>
              <div class="display-6 fw-bold">${stats.hired}</div>
            </div>
          </div>
          <div class="col-12 col-md-4">
            <div class="stat p-3">
              <div class="text-muted">Pending job posts</div>
              <div class="display-6 fw-bold">${stats.pendingPosts}</div>
            </div>
          </div>
        </div>

        <!-- Completed jobs needing review -->
        <div class="rounded-outer p-3 mt-3">
          <div class="d-flex align-items-center justify-content-between">
            <h6 class="mb-0">Completed jobs</h6>
            <span class="badge text-bg-success">${completed.size()}</span>
          </div>
          <div class="table-responsive mt-2">
            <table class="table table-sm align-middle">
              <thead class="table-light">
                <tr>
                  <th>Job title</th>
                  <th class="text-center">Profile Picture</th>
                  <th>Worker name</th>
                  <th class="text-center">Action</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="j" items="${completed}">
                  <tr>
                    <td class="fw-semibold">${j.title}</td>
                    <td class="text-center">
                      <img src="${pageContext.request.contextPath}/media/user/profile?userId=${j.workerId}"
                           class="rounded-circle" style="width:36px;height:36px;object-fit:cover" alt="">
                    </td>
                    <td>${j.workerName}</td>
                    <td class="text-center">
                      <a class="btn btn-outline-primary btn-sm"
                         href="${pageContext.request.contextPath}/client/reviews/new?jobId=${j.jobId}">
                        Review
                      </a>
                    </td>
                  </tr>
                </c:forEach>
                <c:if test="${empty completed}">
                  <tr><td colspan="4" class="text-center text-muted py-4">No completed jobs yet.</td></tr>
                </c:if>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Wage estimator promo -->
        <div class="rounded-outer p-3 mt-3">
          <div class="d-flex align-items-center justify-content-between">
            <div>
              <div class="fw-bold">Hourly Wage Estimator</div>
              <div class="small text-muted">
                A machine-learning model that predicts a fair hourly pay range for a job posting using role,
                skills, location, experience, and other available details.
              </div>
            </div>
            <a class="btn btn-primary" href="javascript:void(0)"
  			 data-bs-toggle="modal" data-bs-target="#wageEstimatorModal">
  				To the Model
			</a>
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
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/client/profile">Manage Profile</a>

            <!-- Verifications quick link: only if NOT verified -->
            <c:if test="<%= !verified %>">
              <a class="link-light text-decoration-none"
                 href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#uploadIdModal">
                Verifications
              </a>
            </c:if>

            <!-- Job Post Management quick link: modal if unverified -->
            <c:choose>
              <c:when test="<%= unverified %>">
                <a class="link-light text-decoration-none" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#uploadIdModal">Job Post Management</a>
              </c:when>
              <c:otherwise>
                <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/client/jobs">Job Post Management</a>
              </c:otherwise>
            </c:choose>

            <!-- Messages quick link: modal if unverified -->
            <c:choose>
              <c:when test="<%= unverified %>">
                <a class="link-light text-decoration-none" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#uploadIdModal">Messages</a>
              </c:when>
              <c:otherwise>
                <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/client/messages">Messages</a>
              </c:otherwise>
            </c:choose>
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
<!-- Wage Estimator Modal -->
<div class="modal fade" id="wageEstimatorModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <form class="modal-content" id="wageEstimatorForm">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-cash-coin me-1"></i> Hourly Wage Estimator</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">
        <div class="row g-3">
          <div class="col-12 col-md-6">
            <label class="form-label">Job Title</label>
            <input type="text" class="form-control" id="fJobTitle" placeholder="Senior Data Engineer">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Role</label>
            <input type="text" class="form-control" id="fRole" placeholder="Engineering">
          </div>

          <div class="col-12">
            <label class="form-label">Key Skills (comma-separated)</label>
            <input type="text" class="form-control" id="fSkills" placeholder="Python, SQL, Spark, Airflow, AWS">
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Work Type</label>
            <select class="form-select" id="fWorkType">
              <option>Full-time</option>
              <option>Part-time</option>
              <option>Contract</option>
              <option>Temporary</option>
            </select>
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Location</label>
            <input type="text" class="form-control" id="fLocation" placeholder="Seattle, WA">
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Company Size</label>
            <select class="form-select" id="fCompanySize">
              <option>1-10</option>
              <option>11-50</option>
              <option selected>51-200</option>
              <option>201-500</option>
              <option>501-1000</option>
              <option>1001+</option>
            </select>
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Experience (years)</label>
            <input type="number" class="form-control" id="fExperienceYears" step="0.1" min="0" placeholder="5.0">
          </div>
        </div>

        <!-- Result area -->
        <div id="wageResult" class="alert alert-secondary mt-3 d-none"></div>
      </div>

      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">
          <span class="me-1" id="wageBtnText">Estimate</span>
          <span class="spinner-border spinner-border-sm d-none" id="wageSpinner"></span>
        </button>
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </form>
  </div>
</div>
<!-- Upload ID Modal -->
<div class="modal fade" id="uploadIdModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/client/verification/upload" enctype="multipart/form-data">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-shield-lock me-1"></i>Upload ID for Verification</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <p class="small text-muted">
          Upload a clear photo/scan of your NIC/ID. Your account status will change to <strong>Pending</strong> until an admin reviews it.
        </p>
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
    const isUnverified = '<%= ("unverified".equalsIgnoreCase(vStatus)) ? "1" : "0" %>' === '1';

    // Gate any link marked with data-gate="verify"
    document.querySelectorAll('a[data-gate="verify"]').forEach(a => {
      a.addEventListener('click', function (e) {
        if (isUnverified) {
          e.preventDefault();
          const m = new bootstrap.Modal(document.getElementById('uploadIdModal'));
          m.show();
        }
      });
    });

    // Optional: handle ?verify=1 only for unverified users
    const params = new URLSearchParams(location.search);
    if (params.get('verify') === '1' && isUnverified) {
      new bootstrap.Modal(document.getElementById('uploadIdModal')).show();
      params.delete('verify');
      history.replaceState({}, '', location.pathname + (params.toString() ? '?' + params : ''));
    }
  })();
</script>
<script>
  // Where your FastAPI is running
  const API_URL = "http://localhost:8000/predict"; // change to your reverse-proxy path in prod

  const form = document.getElementById('wageEstimatorForm');
  const wageResult = document.getElementById('wageResult');
  const btnText = document.getElementById('wageBtnText');
  const spinner = document.getElementById('wageSpinner');

  form.addEventListener('submit', async function (e) {
    e.preventDefault();
    wageResult.classList.add('d-none');
    btnText.textContent = 'Estimating...';
    spinner.classList.remove('d-none');

    // Gather form values
    const payload = {
      job_title:      document.getElementById('fJobTitle').value.trim(),
      role:           document.getElementById('fRole').value.trim(),
      skills:         document.getElementById('fSkills').value.trim(),
      work_type:      document.getElementById('fWorkType').value,
      location:       document.getElementById('fLocation').value.trim(),
      company_size:   document.getElementById('fCompanySize').value,
      experience_years: parseFloat(document.getElementById('fExperienceYears').value || '0')
    };

    try {
      const res = await fetch(API_URL, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(payload)
      });

      if (!res.ok) {
        throw new Error('API error: ' + res.status);
      }

      const data = await res.json();
      wageResult.classList.remove('d-none');
      wageResult.classList.remove('alert-secondary','alert-danger');
      wageResult.classList.add('alert-success');

      wageResult.innerHTML = `
        <div class="fw-semibold mb-1">Estimated Hourly Wage:</div>
        <div class="display-6">$${data.predicted_hourly_wage.toFixed(2)}/hr</div>
        <div class="small text-muted">Suggested range: $${data.suggested_range_low.toFixed(2)} – $${data.suggested_range_high.toFixed(2)} /hr</div>
      `;
    } catch (err) {
      wageResult.classList.remove('d-none');
      wageResult.classList.remove('alert-secondary','alert-success');
      wageResult.classList.add('alert-danger');
      wageResult.textContent = 'Sorry, we could not get an estimate. ' + err.message;
    } finally {
      btnText.textContent = 'Estimate';
      spinner.classList.add('d-none');
    }
  });
</script>

</body>
</html>
