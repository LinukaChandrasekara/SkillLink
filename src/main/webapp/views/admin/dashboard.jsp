<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>SkillLink | Admin Dashboard</title>

  <!-- Bootstrap + FA (same as login) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

  <style>
    :root{ --primary-color:#4e73df; --secondary-color:#1cc88a; --dark-color:#5a5c69; --light-color:#f8f9fc; }
    body{ background-color:var(--light-color); }
    .nav-brand{ color:#fff; text-decoration:none; }
    .kpi-card{ box-shadow:0 0.15rem 1.75rem rgba(58,59,69,.15); border-radius:.5rem; }
    .kpi-icon{ width:44px; height:44px; display:flex; align-items:center; justify-content:center; border-radius:.5rem; }
  </style>
</head>
<body>
  <!-- Topbar -->
  <nav class="navbar navbar-expand-lg" style="background-color:var(--primary-color);">
    <div class="container-fluid">
      <a class="navbar-brand nav-brand" href="#"><i class="fas fa-tools me-2"></i> SkillLink Admin</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#topnav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div id="topnav" class="collapse navbar-collapse">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-gauge me-1"></i>Dashboard</a></li>
          <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users me-1"></i>Users</a></li>
          <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/verifications"><i class="fa-regular fa-id-card me-1"></i>Verifications</a></li>
          <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/jobs"><i class="fa-solid fa-clipboard-check me-1"></i>Job Approvals</a></li>
          <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/messages"><i class="fa-regular fa-comments me-1"></i>Messages</a></li>
          <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/auth/logout"><i class="fa-solid fa-right-from-bracket me-1"></i>Logout</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <main class="container py-4">
    <!-- Alerts -->
    <c:if test="${not empty error}">
      <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation me-2"></i>${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success"><i class="fa-solid fa-circle-check me-2"></i>${success}</div>
    </c:if>

    <!-- KPI Row -->
    <div class="row g-3">
      <div class="col-12 col-md-6 col-lg-3">
        <div class="card kpi-card">
          <div class="card-body d-flex align-items-center">
            <div class="kpi-icon bg-primary text-white me-3"><i class="fa-solid fa-users"></i></div>
            <div>
              <div class="text-muted small">Total Users</div>
              <div class="fs-4 fw-bold"><c:out value="${stats.totalUsers}"/></div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-6 col-lg-3">
        <div class="card kpi-card">
          <div class="card-body d-flex align-items-center">
            <div class="kpi-icon bg-success text-white me-3"><i class="fa-solid fa-user-gear"></i></div>
            <div>
              <div class="text-muted small">Workers</div>
              <div class="fs-4 fw-bold"><c:out value="${stats.totalWorkers}"/></div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-6 col-lg-3">
        <div class="card kpi-card">
          <div class="card-body d-flex align-items-center">
            <div class="kpi-icon bg-info text-white me-3"><i class="fa-solid fa-user-tie"></i></div>
            <div>
              <div class="text-muted small">Clients</div>
              <div class="fs-4 fw-bold"><c:out value="${stats.totalClients}"/></div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-6 col-lg-3">
        <div class="card kpi-card">
          <div class="card-body d-flex align-items-center">
            <div class="kpi-icon bg-warning text-dark me-3"><i class="fa-regular fa-id-card"></i></div>
            <div>
              <div class="text-muted small">Pending Verifications</div>
              <div class="fs-4 fw-bold"><c:out value="${stats.pendingVerifications}"/></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Second KPI Row -->
    <div class="row g-3 mt-1">
      <div class="col-12 col-md-6 col-lg-4">
        <div class="card kpi-card">
          <div class="card-body d-flex align-items-center">
            <div class="kpi-icon bg-secondary text-white me-3"><i class="fa-solid fa-clipboard-list"></i></div>
            <div>
              <div class="text-muted small">Pending Jobs</div>
              <div class="fs-4 fw-bold"><c:out value="${stats.pendingJobs}"/></div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-md-6 col-lg-4">
        <div class="card kpi-card">
          <div class="card-body d-flex align-items-center">
            <div class="kpi-icon bg-dark text-white me-3"><i class="fa-solid fa-ban"></i></div>
            <div>
              <div class="text-muted small">Disabled Users</div>
              <div class="fs-4 fw-bold"><c:out value="${stats.disabledUsers}"/></div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-12 col-lg-4">
        <div class="card kpi-card">
          <div class="card-body d-flex align-items-center justify-content-between">
            <div>
              <div class="text-muted small">New Users (7d)</div>
              <div class="fs-4 fw-bold"><c:out value="${stats.newUsers7d}"/></div>
            </div>
            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/admin/users?sort=created_at&dir=desc">
              View <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- Charts -->
    <div class="row g-3 mt-1">
      <div class="col-12 col-lg-6">
        <div class="card kpi-card">
          <div class="card-header bg-white"><strong>Jobs by Status</strong></div>
          <div class="card-body"><canvas id="chartJobsStatus" height="160"></canvas></div>
        </div>
      </div>
      <div class="col-12 col-lg-6">
        <div class="card kpi-card">
          <div class="card-header bg-white"><strong>New Users (last 14 days)</strong></div>
          <div class="card-body"><canvas id="chartUsers" height="160"></canvas></div>
        </div>
      </div>
    </div>

  </main>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <script>
    // Server-provided JSON (ensure you put valid JSON strings in these attributes)
    const jobsStatusLabels = ${empty jobsStatusLabels ? '[]' : jobsStatusLabels};
    const jobsStatusCounts = ${empty jobsStatusCounts ? '[]' : jobsStatusCounts};
    const usersLabels = ${empty usersLabels ? '[]' : usersLabels};
    const usersCounts = ${empty usersCounts ? '[]' : usersCounts};

    new Chart(document.getElementById('chartJobsStatus'), {
      type: 'bar',
      data: { labels: jobsStatusLabels, datasets: [{ label:'Jobs', data: jobsStatusCounts }] },
      options: { responsive:true, maintainAspectRatio:false }
    });

    new Chart(document.getElementById('chartUsers'), {
      type: 'line',
      data: { labels: usersLabels, datasets: [{ label:'New Users', data: usersCounts, fill:false, tension:.3 }] },
      options: { responsive:true, maintainAspectRatio:false }
    });
  </script>
</body>
</html>
