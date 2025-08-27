<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Admin Dashboard - SkillLink</title>

  <!-- Bootstrap + Font Awesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>

  <!-- Custom Styles -->
  <style>
    :root {
      --primary-color: #4e73df;
      --secondary-color: #1f3bb3;
      --light-bg: #f8f9fc;
      --gray-text: #6c757d;
      --border-color: #e0e6ed;
    }

    html, body {
      height: 100%;
      margin: 0;
    }

    body {
      background: var(--light-bg);
      font-family: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      font-size: 0.95rem;
      color: #343a40;
    }

    .page-wrapper {
      flex: 1;
    }

    .topbar {
      background: var(--primary-color);
      color: #fff;
      border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    }

    .topbar .brand {
      font-size: 1.4rem;
      font-weight: 700;
    }

    .profile-chip {
      display: flex;
      align-items: center;
      gap: 0.75rem;
      color: #fff;
      text-decoration: none;
    }

    .profile-chip:hover {
      opacity: 0.9;
    }

    .avatar {
      width: 56px;
      height: 56px;
      border-radius: 50%;
      background: #e9ecef;
      overflow: hidden;
      display: flex;
      align-items: center;
      justify-content: center;
      border: 2px solid rgba(255, 255, 255, 0.5);
      font-size: 0;
    }

    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .nav-tabs-row {
      background: #fff;
      border-bottom: 1px solid var(--border-color);
    }

    .nav-tabs-row .nav-link {
      border: 0;
      border-radius: 0.5rem;
      margin-right: 0.5rem;
      color: #495057;
      padding: 0.5rem 1rem;
      transition: all 0.2s;
    }

    .nav-tabs-row .nav-link:hover {
      background: #f0f3ff;
      color: var(--secondary-color);
    }

    .nav-tabs-row .nav-link.active {
      background: #eef2ff;
      color: var(--secondary-color);
      font-weight: 600;
      border: 1px solid #dfe4ff;
    }

    .btn-logout {
      background: #dc3545;
      border-color: #dc3545;
      color: #fff;
    }

    .btn-logout:hover {
      background: #bb2d3b;
      border-color: #b02a37;
    }

    .card-kpi {
      background: #fff;
      border: 1px solid var(--border-color);
      border-radius: 1rem;
      padding: 1.25rem;
      min-height: 160px;
      box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
    }

    .kpi-title {
      color: var(--gray-text);
      font-weight: 600;
    }

    .kpi-number {
      font-size: 2rem;
      font-weight: 700;
      color: #1f2937;
    }

    .estimator-card {
      background: #fff;
      border: 1px solid var(--border-color);
      border-radius: 1rem;
      padding: 1.5rem;
    }

    .footer-bar {
      background: var(--primary-color);
      color: #fff;
      border-top-left-radius: 1rem;
      border-top-right-radius: 1rem;
      padding-top: 2rem;
      padding-bottom: 2rem;
    }

    .footer-bar h6 {
      font-weight: 600;
    }

    .footer-bar a {
      color: #dee2e6;
      text-decoration: none;
    }

    .footer-bar a:hover {
      text-decoration: underline;
      color: #fff;
    }

    .footer-divider {
      width: 1px;
      background: rgba(255, 255, 255, 0.3);
      height: 100%;
    }

    @media (max-width: 991.98px) {
      .footer-divider {
        display: none;
      }
    }
  </style>
</head>

<body class="d-flex flex-column min-vh-100">

  <div class="page-wrapper">
    <!-- TOPBAR -->
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
                <c:otherwise>
                  <i class="fa-regular fa-user fa-2x text-muted"></i>
                </c:otherwise>
              </c:choose>
            </div>
            <div class="text-end">
              <div class="fw-bold">
                <c:out value="${empty sessionScope.adminUser.fullName ? 'Admin User Name' : sessionScope.adminUser.fullName}"/>
              </div>
              <div class="small opacity-75">Administrator</div>
            </div>
          </a>
        </div>
      </div>

      <!-- NAV TABS -->
      <div class="nav-tabs-row">
        <div class="container-fluid px-3 px-md-4 py-2">
          <div class="d-flex align-items-center">
            <ul class="nav">
              <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
              <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Manage users</a></li>
              <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a></li>
              <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a></li>
              <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/messages">Messages</a></li>
            </ul>
            <div class="ms-auto">
              <a class="btn btn-logout" href="${pageContext.request.contextPath}/auth/logout">Logout</a>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- PAGE CONTENT -->
    <main class="container-fluid px-3 px-md-4 py-3 py-md-4">

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

      <div class="row g-3">
        <div class="col-12 col-md-6 col-xl-3">
          <div class="card-kpi">
            <div class="kpi-title">Total Users</div>
            <div class="kpi-number mt-2">${empty stats.totalUsers ? 0 : stats.totalUsers}</div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card-kpi">
            <div class="kpi-title">Verified Workers</div>
            <div class="kpi-number mt-2">${empty stats.verifiedWorkers ? 0 : stats.verifiedWorkers}</div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card-kpi">
            <div class="kpi-title">Verified Clients</div>
            <div class="kpi-number mt-2">${empty stats.verifiedClients ? 0 : stats.verifiedClients}</div>
          </div>
        </div>

        <div class="col-12 col-md-6 col-xl-3">
          <div class="card-kpi">
            <div class="kpi-title">Pending Jobs</div>
            <div class="kpi-number mt-2">${empty stats.pendingJobs ? 0 : stats.pendingJobs}</div>
          </div>
        </div>
      </div>

      <!-- HOURLY WAGE ESTIMATOR -->
      <div class="estimator-card mt-3">
        <div class="row g-3 align-items-center">
          <div class="col-12 col-lg-9">
            <h5 class="mb-1">Hourly Wage Estimator</h5>
            <p class="mb-0 text-muted">A machine-learning model that predicts a fair hourly pay range for a job posting using role, skills, location, experience, and other details.</p>
          </div>
          <div class="col-12 col-lg-3 text-lg-end">
            <a href="${pageContext.request.contextPath}/admin/wage-estimator" class="btn btn-primary">
              To the Model <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
          </div>
        </div>
      </div>
    </main>
  </div>

  <!-- FOOTER BAR -->
  <footer class="footer-bar mt-auto">
    <div class="container-fluid px-3 px-md-4">
      <div class="row align-items-center gy-4">
        <div class="col-12 col-lg-3">
          <h6 class="mb-3">Quick Links</h6>
          <div class="d-flex flex-column gap-1">
            <a class="link-light" href="${pageContext.request.contextPath}/admin/users">Manage users</a>
            <a class="link-light" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a>
            <a class="link-light" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a>
            <a class="link-light" href="${pageContext.request.contextPath}/admin/messages">Messages</a>
          </div>
        </div>

        <div class="col-12 col-lg-6 d-none d-lg-flex justify-content-center">
          <div class="footer-divider me-4"></div>
          <div class="text-center">
            <div class="fw-bold">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
            <div class="small opacity-75 mt-2">&copy; <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara</div>
          </div>
          <div class="footer-divider ms-4"></div>
        </div>

        <div class="col-12 col-lg-3">
          <h6 class="mb-3">Contact Us</h6>
          <div class="d-flex align-items-center gap-2">
            <a class="btn btn-light btn-sm" href="https://facebook.com/yourpage" target="_blank" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
            <a class="btn btn-light btn-sm" href="https://x.com/yourhandle" target="_blank" aria-label="X"><i class="fab fa-x-twitter"></i></a>
            <a class="btn btn-light btn-sm" href="https://instagram.com/yourprofile" target="_blank" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
            <a class="btn btn-light btn-sm" href="mailto:support@skilllink.lk" aria-label="Email"><i class="fa-regular fa-envelope"></i></a>
          </div>
        </div>
      </div>

      <div class="d-lg-none text-center mt-3">
        <div class="fw-bold">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
        <div class="small opacity-75 mt-2">&copy; <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara</div>
      </div>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
