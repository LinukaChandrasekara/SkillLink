<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // ----- Session & role guard (admin only) -----
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
  <title>Admin Dashboard - SkillLink</title>

  <!-- Bootstrap 5 + Bootstrap Icons -->
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
    .kpi-card{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .kpi-title{ color:#6c757d; font-size:.95rem; }
    .kpi-value{ font-weight:800; font-size:2rem; }
    .module-card{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
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
          <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Manage users</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a></li>
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

    <!-- KPI ROW -->
    <c:set var="totalUsers"        value="${not empty stats ? stats.totalUsers : totalUsers}" />
    <c:set var="verifiedWorkers"   value="${not empty stats ? stats.verifiedWorkers : verifiedWorkers}" />
    <c:set var="verifiedClients"   value="${not empty stats ? stats.verifiedClients : verifiedClients}" />
    <c:set var="pendingJobs"       value="${not empty stats ? stats.pendingJobs : pendingJobs}" />

    <div class="row g-3">
      <div class="col-12 col-md-6 col-xl-3">
        <div class="kpi-card p-3">
          <div class="d-flex align-items-center justify-content-between">
            <div class="kpi-title">Total Users</div>
            <i class="bi bi-people-fill fs-3 text-primary"></i>
          </div>
          <div class="kpi-value mt-2"><c:out value="${totalUsers}" default="0"/></div>
        </div>
      </div>
      <div class="col-12 col-md-6 col-xl-3">
        <div class="kpi-card p-3">
          <div class="d-flex align-items-center justify-content-between">
            <div class="kpi-title">Verified Workers</div>
            <i class="bi bi-patch-check-fill fs-3 text-success"></i>
          </div>
          <div class="kpi-value mt-2"><c:out value="${verifiedWorkers}" default="0"/></div>
        </div>
      </div>
      <div class="col-12 col-md-6 col-xl-3">
        <div class="kpi-card p-3">
          <div class="d-flex align-items-center justify-content-between">
            <div class="kpi-title">Verified Clients</div>
            <i class="bi bi-person-badge-fill fs-3 text-info"></i>
          </div>
          <div class="kpi-value mt-2"><c:out value="${verifiedClients}" default="0"/></div>
        </div>
      </div>
      <div class="col-12 col-md-6 col-xl-3">
        <div class="kpi-card p-3">
          <div class="d-flex align-items-center justify-content-between">
            <div class="kpi-title">Pending jobs</div>
            <i class="bi bi-hourglass-split fs-3 text-warning"></i>
          </div>
          <div class="kpi-value mt-2"><c:out value="${pendingJobs}" default="0"/></div>
        </div>
      </div>
    </div>

    <!-- HOURLY WAGE ESTIMATOR -->
    <div class="module-card p-3 mt-3">
      <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between">
        <div>
          <h5 class="mb-1">Hourly Wage Estimator</h5>
          <p class="mb-0 text-muted">
            A machine-learning model that predicts a fair hourly pay range for a job posting using role,
            skills, location, experience, and other available details.
          </p>
        </div>
            <a class="btn btn-primary" href="javascript:void(0)" data-bs-toggle="modal" data-bs-target="#wageEstimatorModal">Try<i class="bi bi-arrow-right-short ms-1"></i>
        </a>
      </div>
    </div>

  </main>
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
            <input type="text" class="form-control" id="fJobTitle" placeholder="plumber">
          </div>
          <div class="col-12 col-md-6">
            <label class="form-label">Role</label>
            <input type="text" class="form-control" id="fRole" placeholder="plumbing">
          </div>

          <div class="col-12">
            <label class="form-label">Key Skills (comma-separated)</label>
            <input type="text" class="form-control" id="fSkills" placeholder="plumbing">
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Work Type</label>
            <select class="form-select" id="fWorkType">
              <option>Full-time</option><option>Part-time</option><option>Contract</option><option>Temporary</option>
            </select>
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Location</label>
            <input type="text" class="form-control" id="fLocation" placeholder="Seattle, WA">
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Company Size</label>
            <select class="form-select" id="fCompanySize">
              <option>1-10</option><option>11-50</option><option selected>51-200</option><option>201-500</option><option>501-1000</option><option>1001+</option>
            </select>
          </div>

          <div class="col-12 col-md-4">
            <label class="form-label">Experience</label>
            <input type="text" class="form-control" id="fExperienceYears" placeholder="e.g., 2 or 3-5 years">
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // API endpoint (proxy in prod; localhost in dev)
  const API_URL = "http://localhost:8000/predict";

  const form = document.getElementById('wageEstimatorForm');
  const wageResult = document.getElementById('wageResult');
  const btnText = document.getElementById('wageBtnText');
  const spinner = document.getElementById('wageSpinner');
  const submitBtn = form.querySelector('button[type="submit"]');

  const money = v => Number(v).toLocaleString('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 2 });

  function showOk(pred, lo, hi) {
    wageResult.classList.remove('d-none','alert-secondary','alert-danger');
    wageResult.classList.add('alert-success');
    wageResult.innerHTML =
      '<div class="fw-semibold mb-1">Estimated Hourly Wage:</div>' +
      '<div class="display-6">' + money(pred) + '/hr</div>' +
      '<div class="small text-muted">Suggested range: ' + money(lo) + ' – ' + money(hi) + ' /hr</div>';
  }

  function showErr(msg) {
    wageResult.classList.remove('d-none','alert-secondary','alert-success');
    wageResult.classList.add('alert-danger');
    wageResult.textContent = 'Sorry, we could not get an estimate. ' + msg;
  }

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    wageResult.classList.add('d-none');
    btnText.textContent = 'Estimating...';
    spinner.classList.remove('d-none');
    submitBtn.disabled = true;

    const payload = {
      job_title:    document.getElementById('fJobTitle').value.trim(),
      role:         document.getElementById('fRole').value.trim(),
      skills:       document.getElementById('fSkills').value.trim(),
      work_type:    document.getElementById('fWorkType').value,
      location:     document.getElementById('fLocation').value.trim(),
      company_size: document.getElementById('fCompanySize').value,
      experience_years: document.getElementById('fExperienceYears').value.trim() // allow "2" or "3-5 years"
    };

    try {
      const res = await fetch(API_URL, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(payload)
      });

      const raw = await res.text(); // for diagnostics
      if (!res.ok) throw new Error('HTTP ' + res.status + ' ' + res.statusText + ': ' + raw.slice(0, 200));
      let data;
      try { data = JSON.parse(raw); } catch (e) {
        console.error('Non-JSON response body:', raw);
        throw new Error('API returned non-JSON. See console.');
      }
      console.log('API response:', data);

      const pred = Number(data.predicted_hourly_wage);
      const lo   = Number(data.suggested_range_low);
      const hi   = Number(data.suggested_range_high);

      if (!Number.isFinite(pred) || !Number.isFinite(lo) || !Number.isFinite(hi)) {
        throw new Error('Invalid numbers in response: ' + JSON.stringify(data));
      }

      showOk(pred, lo, hi);
    } catch (err) {
      console.error(err);
      showErr(err.message || String(err));
    } finally {
      btnText.textContent = 'Estimate';
      spinner.classList.add('d-none');
      submitBtn.disabled = false;
    }
  });
</script>
</body>
</html>
