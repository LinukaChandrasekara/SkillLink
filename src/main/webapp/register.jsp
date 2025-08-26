<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Optional: preselect tab via ?role=worker|client
    String roleParam = request.getParameter("role");
    String defaultRole = (roleParam == null || (!roleParam.equals("worker") && !roleParam.equals("client"))) ? "worker" : roleParam;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SkillLink | Register</title>

  <!-- Bootstrap 5 + Font Awesome (match login) -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <!-- Same theme as login -->
  <style>
    :root {
      --primary-color: #4e73df;
      --secondary-color: #1cc88a;
      --dark-color: #5a5c69;
      --light-color: #f8f9fc;
    }
    body {
      background-color: var(--light-color);
      min-height: 100vh;
      display: flex;
      align-items: center;
    }
    /* Reuse login container look; widen for registration forms */
    .login-container {
      max-width: 980px; /* wider than login for two rich forms */
      width: 100%;
      margin: 24px auto;
      box-shadow: 0 0.15rem 1.75rem 0 rgba(58,59,69,0.15);
      border-radius: 0.35rem;
      overflow: hidden;
      background: #fff;
    }
    .login-header {
      background-color: var(--primary-color);
      color: #fff;
      padding: 1.25rem 1.5rem;
      text-align: center;
    }
    .login-body {
      padding: 1.25rem;
    }
    .form-control:focus, .form-select:focus {
      border-color: var(--primary-color);
      box-shadow: 0 0 0 0.2rem rgba(78,115,223,0.25);
    }
    .btn-primary {
      background-color: var(--primary-color);
      border-color: var(--primary-color);
    }
    .btn-primary:hover {
      background-color: #2e59d9;
      border-color: #2653d4;
    }
    .avatar-preview {
      width: 84px; height: 84px; border-radius: .5rem;
      background: #f1f3f6; background-position: center; background-size: cover;
      border: 1px dashed #ced4da;
    }
    .help-text { font-size: .875rem; color: #6c757d; }
    .badge-required { color: var(--primary-color); }
    .tab-pill .nav-link.active { background: var(--primary-color); }
  </style>
</head>
<body>
  <div class="container">
    <div class="login-container">
      <!-- Header (same visual as login) -->
      <div class="login-header">
        <h2 class="mb-0"><i class="fas fa-hands-helping me-2"></i> SkillLink</h2>
        <p class="mb-0">Create your account</p>
      </div>

      <div class="login-body">
        <!-- Alerts (scriptlet style to match your login) -->
        <% if (request.getParameter("error") != null) { %>
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> <%= request.getParameter("error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        <% } %>
        <% if (request.getParameter("success") != null) { %>
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> <%= request.getParameter("success") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        <% } %>

        <!-- Tabs -->
        <ul class="nav nav-pills mb-3 tab-pill" id="regTabs" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="worker-tab" data-bs-toggle="pill" data-bs-target="#worker-pane"
                    type="button" role="tab" aria-controls="worker-pane" aria-selected="true">
              <i class="fa-solid fa-user-gear me-1"></i> Register as Worker
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="client-tab" data-bs-toggle="pill" data-bs-target="#client-pane"
                    type="button" role="tab" aria-controls="client-pane" aria-selected="false">
              <i class="fa-solid fa-user-tie me-1"></i> Register as Client
            </button>
          </li>
        </ul>

        <div class="tab-content" id="regTabsContent">
          <!-- ======================== WORKER ======================== -->
          <div class="tab-pane fade" id="worker-pane" role="tabpanel" aria-labelledby="worker-tab" tabindex="0">
            <form class="row g-3 needs-validation" novalidate
                  method="post" action="${pageContext.request.contextPath}/register-worker"
                  enctype="multipart/form-data">
              <input type="hidden" name="role" value="worker"/>

              <div class="col-12"><h5 class="text-primary"><i class="fa-solid fa-id-card-clip me-2"></i>Personal Information</h5></div>

              <div class="col-12 col-md-6">
                <label class="form-label">Full name <span class="badge-required">*</span></label>
                <input type="text" name="full_name" maxlength="150" class="form-control" required placeholder="e.g., Ama Perera">
                <div class="invalid-feedback">Full name is required.</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">National ID (NID) <span class="badge-required">*</span></label>
                <input type="text" name="nid" maxlength="50" class="form-control" required placeholder="Enter your NID">
                <div class="invalid-feedback">NID is required.</div>
              </div>

              <div class="col-12 col-md-6">
                <label class="form-label">Telephone <span class="badge-required">*</span></label>
                <input type="text" name="phone" maxlength="30" class="form-control" required placeholder="071 234 5678">
                <div class="invalid-feedback">Telephone is required.</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">Email <span class="badge-required">*</span></label>
                <input type="email" name="email" maxlength="160" class="form-control" required placeholder="you@example.com">
                <div class="invalid-feedback">Valid email is required.</div>
              </div>

              <div class="col-12 col-md-6">
                <label class="form-label">Age <span class="badge-required">*</span></label>
                <input type="number" name="age" min="16" max="100" class="form-control" required placeholder="18">
                <div class="invalid-feedback">Age is required (16–100).</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">Address / Location <span class="badge-required">*</span></label>
                <input type="text" name="address_line" maxlength="255" class="form-control" required placeholder="City, street, etc.">
                <div class="invalid-feedback">Address/location is required.</div>
              </div>

              <div class="col-12"><h5 class="text-primary mt-2"><i class="fa-solid fa-shield-halved me-2"></i>Account</h5></div>
              <div class="col-12 col-md-6">
                <label class="form-label">Username <span class="badge-required">*</span></label>
                <input type="text" name="username" minlength="4" maxlength="60" class="form-control" required placeholder="Choose a unique name">
                <div class="invalid-feedback">Username is required (min 4 chars).</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">Password <span class="badge-required">*</span></label>
                <div class="input-group">
                  <input type="password" name="password" minlength="8" maxlength="255" class="form-control" required placeholder="Min 8 characters" id="w-pass">
                  <button class="btn btn-outline-secondary" type="button" onclick="togglePwd('w-pass', this)"><i class="fa-solid fa-eye"></i></button>
                </div>
                <div class="invalid-feedback">Password is required (min 8 chars).</div>
              </div>
              <div class="col-12">
                <label class="form-label">Bio</label>
                <textarea name="bio" maxlength="1000" class="form-control" placeholder="Tell clients about your skills, tools, and availability."></textarea>
              </div>

              <div class="col-12"><h5 class="text-primary mt-2"><i class="fa-solid fa-briefcase me-2"></i>Professional</h5></div>
              <div class="col-12 col-md-6">
                <label class="form-label">Job category <span class="badge-required">*</span></label>
                <select name="job_category_id" class="form-select" required>
                  <c:forEach var="cat" items="${jobCategories}">
                    <option value="${cat.jobCategoryId}">${cat.name}</option>
                  </c:forEach>
                  <c:if test="${empty jobCategories}">
                    <option value="1">Plumbing</option>
                    <option value="2">Electrical</option>
                    <option value="3">Carpentry</option>
                    <option value="4">Cleaning</option>
                  </c:if>
                </select>
                <div class="help-text">Used to match you with relevant job posts.</div>
                <div class="invalid-feedback">Please choose a category.</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">Experience (years) <span class="badge-required">*</span></label>
                <input type="number" name="experience_years" min="0" max="60" class="form-control" required placeholder="e.g., 3">
                <div class="invalid-feedback">Enter your experience in years.</div>
              </div>

              <div class="col-12"><h5 class="text-primary mt-2"><i class="fa-solid fa-images me-2"></i>Media</h5></div>
              <div class="col-12 col-md-6">
                <label class="form-label">Profile picture <span class="badge-required">*</span></label>
                <div class="d-flex align-items-center gap-3">
                  <div id="w-profile-preview" class="avatar-preview"></div>
                  <input type="file" name="profile_picture" id="w-profile" accept="image/*" class="form-control" required>
                </div>
                <div class="invalid-feedback">Profile picture is required.</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">ID photo (optional at signup)</label>
                <div class="d-flex align-items-center gap-3">
                  <div id="w-id-preview" class="avatar-preview"></div>
                  <input type="file" name="id_photo" id="w-id" accept="image/*" class="form-control">
                </div>
                <div class="alert alert-warning mt-2 py-2 mb-0" role="alert">
                  <i class="fa-solid fa-circle-info me-1"></i> You must upload an ID later to get verified by Admin.
                </div>
              </div>

              <div class="col-12">
                <button class="btn btn-primary" type="submit"><i class="fa-solid fa-user-plus me-1"></i> Create Worker Account</button>
                <button class="btn btn-outline-primary ms-2" type="button" data-bs-toggle="pill" data-bs-target="#client-pane">
                  <i class="fa-solid fa-arrow-right-to-bracket me-1"></i> Switch to Client
                </button>
              </div>
            </form>
          </div>

          <!-- ======================== CLIENT ======================== -->
          <div class="tab-pane fade" id="client-pane" role="tabpanel" aria-labelledby="client-tab" tabindex="0">
            <form class="row g-3 needs-validation" novalidate
                  method="post" action="${pageContext.request.contextPath}/register-client"
                  enctype="multipart/form-data">
              <input type="hidden" name="role" value="client"/>

              <div class="col-12"><h5 class="text-primary"><i class="fa-solid fa-id-card-clip me-2"></i>Personal Information</h5></div>

              <div class="col-12 col-md-6">
                <label class="form-label">Full name <span class="badge-required">*</span></label>
                <input type="text" name="full_name" maxlength="150" class="form-control" required placeholder="e.g., Nimal Jayasinghe">
                <div class="invalid-feedback">Full name is required.</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">National ID (NID) <span class="badge-required">*</span></label>
                <input type="text" name="nid" maxlength="50" class="form-control" required placeholder="Enter your NID">
                <div class="invalid-feedback">NID is required.</div>
              </div>

              <div class="col-12 col-md-6">
                <label class="form-label">Telephone <span class="badge-required">*</span></label>
                <input type="text" name="phone" maxlength="30" class="form-control" required placeholder="077 987 6543">
                <div class="invalid-feedback">Telephone is required.</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">Email <span class="badge-required">*</span></label>
                <input type="email" name="email" maxlength="160" class="form-control" required placeholder="you@company.com">
                <div class="invalid-feedback">Valid email is required.</div>
              </div>

              <div class="col-12 col-md-6">
                <label class="form-label">Age <span class="badge-required">*</span></label>
                <input type="number" name="age" min="16" max="100" class="form-control" required placeholder="18">
                <div class="invalid-feedback">Age is required (16–100).</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">Address / Location <span class="badge-required">*</span></label>
                <input type="text" name="address_line" maxlength="255" class="form-control" required placeholder="City, street, etc.">
                <div class="invalid-feedback">Address/location is required.</div>
              </div>

              <div class="col-12"><h5 class="text-primary mt-2"><i class="fa-solid fa-shield-halved me-2"></i>Account</h5></div>
              <div class="col-12 col-md-6">
                <label class="form-label">Username <span class="badge-required">*</span></label>
                <input type="text" name="username" minlength="4" maxlength="60" class="form-control" required placeholder="Choose a unique name">
                <div class="invalid-feedback">Username is required (min 4 chars).</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">Password <span class="badge-required">*</span></label>
                <div class="input-group">
                  <input type="password" name="password" minlength="8" maxlength="255" class="form-control" required placeholder="Min 8 characters" id="c-pass">
                  <button class="btn btn-outline-secondary" type="button" onclick="togglePwd('c-pass', this)"><i class="fa-solid fa-eye"></i></button>
                </div>
                <div class="invalid-feedback">Password is required (min 8 chars).</div>
              </div>

              <div class="col-12"><h5 class="text-primary mt-2"><i class="fa-solid fa-building me-2"></i>Client Type</h5></div>
              <div class="col-12">
                <div class="d-flex align-items-center gap-4">
                  <div class="form-check">
                    <input class="form-check-input" type="radio" name="client_type" id="ctype-ind" value="individual" required>
                    <label class="form-check-label" for="ctype-ind"><i class="fa-solid fa-user me-1"></i> Individual</label>
                  </div>
                  <div class="form-check">
                    <input class="form-check-input" type="radio" name="client_type" id="ctype-biz" value="business">
                    <label class="form-check-label" for="ctype-biz"><i class="fa-solid fa-building-columns me-1"></i> Business</label>
                  </div>
                </div>
                <div class="invalid-feedback d-block">Please select a client type.</div>
                <div class="help-text">Only clients choose Individual or Business. (Workers/Admin are Individual by default.)</div>
              </div>

              <div class="col-12"><h5 class="text-primary mt-2"><i class="fa-solid fa-images me-2"></i>Media</h5></div>
              <div class="col-12 col-md-6">
                <label class="form-label">Profile picture <span class="badge-required">*</span></label>
                <div class="d-flex align-items-center gap-3">
                  <div id="c-profile-preview" class="avatar-preview"></div>
                  <input type="file" name="profile_picture" id="c-profile" accept="image/*" class="form-control" required>
                </div>
                <div class="invalid-feedback">Profile picture is required.</div>
              </div>
              <div class="col-12 col-md-6">
                <label class="form-label">ID photo (optional at signup)</label>
                <div class="d-flex align-items-center gap-3">
                  <div id="c-id-preview" class="avatar-preview"></div>
                  <input type="file" name="id_photo" id="c-id" accept="image/*" class="form-control">
                </div>
                <div class="alert alert-warning mt-2 py-2 mb-0" role="alert">
                  <i class="fa-solid fa-circle-info me-1"></i> Upload later to get verified by Admin.
                </div>
              </div>

              <div class="col-12">
                <button class="btn btn-primary" type="submit"><i class="fa-solid fa-user-plus me-1"></i> Create Client Account</button>
                <button class="btn btn-outline-primary ms-2" type="button" data-bs-toggle="pill" data-bs-target="#worker-pane">
                  <i class="fa-solid fa-arrow-left-long me-1"></i> Switch to Worker
                </button>
              </div>
            </form>
          </div>
        </div>

        <!-- Footer note + link to login -->
        <div class="alert alert-light border d-flex align-items-center mt-3 mb-2" role="alert">
          <i class="fa-solid fa-shield-check text-primary me-2"></i>
          Admins review ID photos for security. Until approved, your account shows as <strong>Unverified</strong>.
        </div>
        <div class="text-center">
          <p class="mb-1">Already have an account?
            <a href="login.jsp" class="text-decoration-none">Back to login</a>
          </p>
          <p class="small text-muted mb-0">
            By registering, you agree to our <a href="#" class="text-decoration-none">Terms</a> and
            <a href="#" class="text-decoration-none">Privacy Policy</a>.
          </p>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap bundle -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <script>
    // Default tab from query (?role=worker|client)
    (function initTabs(){
      const role = "<%= defaultRole %>";
      const tabId = role === "client" ? "client-tab" : "worker-tab";
      const el = document.getElementById(tabId);
      if (el) new bootstrap.Tab(el).show();
    })();

    // Bootstrap validation UX
    document.querySelectorAll('.needs-validation').forEach(form=>{
      form.addEventListener('submit', function (e) {
        if (!form.checkValidity()) {
          e.preventDefault();
          e.stopPropagation();
        }
        form.classList.add('was-validated');
      }, false);
    });

    // Image previews
    function bindPreview(inputId, previewId){
      const input = document.getElementById(inputId);
      const preview = document.getElementById(previewId);
      if(!input || !preview) return;
      input.addEventListener('change', (e)=>{
        const file = e.target.files && e.target.files[0];
        if(!file){ preview.style.backgroundImage = ''; return; }
        const reader = new FileReader();
        reader.onload = ev => preview.style.backgroundImage = `url(${ev.target.result})`;
        reader.readAsDataURL(file);
      });
    }
    bindPreview('w-profile','w-profile-preview');
    bindPreview('w-id','w-id-preview');
    bindPreview('c-profile','c-profile-preview');
    bindPreview('c-id','c-id-preview');

    // Password toggles (match login behavior)
    function togglePwd(id, btn){
      const el = document.getElementById(id);
      const icon = btn.querySelector('i');
      if (el.type === 'password') {
        el.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
      } else {
        el.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
      }
    }
  </script>
</body>
</html>
