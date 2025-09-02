<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>SkillLink | Login</title>

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <!-- Theme + Animated Background -->
  <style>
    :root{
      --primary:#4e73df;         /* SkillLink blue */
      --primary-darker:#2e59d9;
      --primary-darkest:#2653d4;
      --secondary:#1cc88a;
      --ink:#0f172a;
      --light:#f8f9fc;
      --accent:#6c8efb;          /* lighter blue for blend */
      --purple:#8a6cff;
      --teal:#2dd4bf;
    }

    /* Shell centers card; backgrounds sit behind it */
	.auth-shell{
	  min-height:100vh;
	  display:grid;
	  place-items:center;
	  position:relative;
	  isolation:isolate;       /* <-- new: creates its own stacking context */
	  overflow:hidden;
	  background:#f8f9fc;
	}

    /* Animated gradient mesh */
	.bg-animated{
	  position:absolute; inset:0;
	  z-index:0;                                /* was negative */
	  background:
	    radial-gradient(1200px 800px at 10% 0%, rgba(255,255,255,0.15), transparent 60%),
	    radial-gradient(900px 600px at 90% 100%, rgba(255,255,255,0.08), transparent 60%),
	    linear-gradient(120deg, #4e73df, #6c8efb, #8a6cff);
	  background-size:200% 200%;
	  animation: meshShift 18s ease-in-out infinite;
	  filter: saturate(1.05);
	}
    @keyframes meshShift{
      0%{   background-position:0% 50%; }
      50%{  background-position:100% 50%; }
      100%{ background-position:0% 50%; }
    }

    /* Glowing orbs */
	.orb{
	  position:absolute;
	  width:42vmax; height:42vmax; border-radius:50%;
	  pointer-events:none; filter: blur(40px) saturate(1.2);
	  mix-blend-mode: screen; opacity:.35;
	  z-index:1;                               /* was negative */
	}
    .orb--blue{ background: radial-gradient(circle at 30% 30%, var(--accent), transparent 55%); top:-12vmax; left:-14vmax; animation: float1 22s ease-in-out infinite; }
    .orb--teal{ background: radial-gradient(circle at 60% 40%, var(--teal),  transparent 55%); bottom:-14vmax; right:-16vmax; animation: float2 26s ease-in-out infinite; }
    .orb--vio{  background: radial-gradient(circle at 50% 50%, var(--purple),transparent 55%); top:50%; left:60%; transform:translate(-50%,-50%); animation: float3 28s ease-in-out infinite; }

    @keyframes float1{
      0%,100%{ transform: translate(0,0) scale(1); }
      50%{ transform: translate(4vmax,2vmax) scale(1.05); }
    }
    @keyframes float2{
      0%,100%{ transform: translate(0,0) scale(1.05); }
      50%{ transform: translate(-5vmax,3vmax) scale(1); }
    }
    @keyframes float3{
      0%,100%{ transform: translate(-50%,-50%) scale(1); }
      50%{ transform: translate(-48%,-52%) scale(1.06); }
    }

    /* Subtle moving dot grid */
	.bg-dots{
	  position:absolute; inset:0;
	  z-index:2;                               /* keep below card, above mesh/orbs */
	  opacity:.25;
	  background-image: radial-gradient(rgba(255,255,255,.45) 1px, transparent 3px);
	  background-size:40px 40px;
	  animation: drift 60s linear infinite;
	}	
    @keyframes drift{
      0%{ background-position:0 0; transform: rotate(0deg) scale(1); }
      100%{ background-position:1000px 600px; transform: rotate(0.01turn) scale(1.02); }
    }

    /* Login card (glassy) */
    .auth-card{
	  position:relative; z-index:3; 
      width:min(460px, 92vw);
      background: rgba(255,255,255,.9);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      border: 1px solid rgba(255,255,255,.55);
      border-radius: 18px;
      box-shadow:
        0 20px 45px rgba(17,24,39,.18),
        inset 0 1px 0 rgba(255,255,255,.5);
      overflow:hidden;
    }

    /* Your original header/body styles adapted */
    .login-header{
      background: linear-gradient(135deg, var(--primary), var(--accent));
      color:#fff;
      padding:1.5rem;
      text-align:center;
    }
    .login-body{ background:#fff; padding:2rem; }

    .form-control:focus{
      border-color: var(--primary);
      box-shadow: 0 0 0 0.25rem rgba(78,115,223,.25);
    }

    .btn-primary{
      background: var(--primary);
      border-color: var(--primary);
      box-shadow: 0 6px 20px rgba(78,115,223,.35);
      transition: transform .15s ease, box-shadow .2s ease;
    }
    .btn-primary:hover{
      background: var(--primary-darker);
      border-color: var(--primary-darkest);
      transform: translateY(-1px);
      box-shadow: 0 10px 28px rgba(78,115,223,.45);
    }

    .divider{
      display:flex; align-items:center; text-align:center; color:#5a5c69; margin:1.5rem 0;
    }
    .divider::before, .divider::after{ content:""; flex:1; border-bottom:1px solid #e6e6e6; }
    .divider::before{ margin-right:1rem; }
    .divider::after{ margin-left:1rem; }

    .social-login .btn{ width:100%; margin-bottom:.5rem; }
    .btn-google{ background:#ea4335; color:#fff; }
    .btn-facebook{ background:#3b5998; color:#fff; }

    .link-primary{ color: var(--primary); }
    .link-primary:hover{ color: #3053c7; }

    /* Respect accessibility */
    @media (prefers-reduced-motion: reduce){
      .bg-animated, .orb, .bg-dots{ animation:none !important; }
    }
  </style>
</head>
<body>
  <div class="auth-shell">
    <!-- Animated background layers -->
    <div class="bg-animated"></div>
    <div class="orb orb--blue"></div>
    <div class="orb orb--teal"></div>
    <div class="orb orb--vio"></div>
    <div class="bg-dots"></div>

    <!-- Login Card -->
    <div class="auth-card">
      <!-- Header -->
      <div class="login-header">
        <h2 class="mb-1"><i class="fas fa-hands-helping me-2"></i>SkillLink</h2>
        <p class="mb-0">Connect with local service providers</p>
      </div>

      <!-- Body -->
      <div class="login-body">
        <!-- Alerts -->
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

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/auth/login" method="post" novalidate>
          <div class="mb-3">
            <label for="username" class="form-label">
              <i class="fas fa-user me-2"></i>Username or Email
            </label>
            <input type="text" class="form-control" id="username" name="username" placeholder="Enter your username or email" required>
          </div>

          <div class="mb-3">
            <label for="password" class="form-label">
              <i class="fas fa-lock me-2"></i>Password
            </label>
            <div class="input-group">
              <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
              <button class="btn btn-outline-secondary" type="button" id="togglePassword" aria-label="Toggle password visibility">
                <i class="fas fa-eye"></i>
              </button>
            </div>
          </div>

          <div class="d-flex justify-content-between mb-3">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="rememberMe">
              <label class="form-check-label" for="rememberMe">Remember me</label>
            </div>
            <a href="forgot-password.jsp" class="text-decoration-none">Forgot password?</a>
          </div>

          <button type="submit" class="btn btn-primary w-100 py-2 mb-3">
            <i class="fas fa-sign-in-alt me-2"></i>Login
          </button>
        </form>

        <!-- Divider -->
        <div class="divider">OR</div>

        <!-- Social logins -->
        <div class="social-login mb-4">
          <button class="btn btn-google"><i class="fab fa-google me-2"></i>Continue with Google</button>
          <button class="btn btn-facebook"><i class="fab fa-facebook-f me-2"></i>Continue with Facebook</button>
        </div>

        <!-- Register / Terms -->
        <div class="text-center">
          <p>Don't have an account? <a href="register.jsp" class="text-decoration-none">Register here</a></p>
          <p class="mt-3 small text-muted mb-0">
            By continuing you accept our
            <a href="#" class="link-primary" data-bs-toggle="modal" data-bs-target="#termsModal">Terms of Service</a>
            and
            <a href="#" class="link-primary" data-bs-toggle="modal" data-bs-target="#privacyModal">Privacy Policy</a>.
          </p>
        </div>
      </div>
    </div>
  </div>

  <!-- TERMS OF SERVICE Modal -->
  <div class="modal fade" id="termsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">SkillLink – Terms of Service</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <p class="small text-muted mb-3">Effective date: 02 Sep 2025</p>

          <h6>1) Overview</h6>
          <p>SkillLink (“we”, “our”, “us”) is a marketplace that connects clients with skilled workers across Sri Lanka. By creating an account, logging in, or using the website/app (the “Platform”), you agree to these Terms.</p>

          <h6>2) Eligibility & Accounts</h6>
          <ul>
            <li>You must be at least 16 years old and capable of forming a binding contract.</li>
            <li>Provide accurate information and keep your credentials secure. You’re responsible for all activity on your account.</li>
            <li>We may require identity verification (e.g., NIC image) before unlocking certain features.</li>
          </ul>

          <h6>3) Roles on SkillLink</h6>
          <ul>
            <li><strong>Clients</strong> can post jobs, communicate with workers, and close/completed jobs.</li>
            <li><strong>Workers</strong> can manage profiles, view approved job posts in their category, accept offers, and message clients.</li>
            <li><strong>Admins</strong> review verifications and job posts to keep the Platform safe and compliant.</li>
          </ul>

          <h6>4) Job Posts & Offers</h6>
          <ul>
            <li>Job posts may be reviewed by admins before workers can see them.</li>
            <li>Budgets shown are indicative. SkillLink does not collect or process payments on your behalf.</li>
            <li>When a worker accepts a job offer, the Platform notifies the client and opens/updates a conversation.</li>
            <li>Clients can mark jobs closed/completed; after completion, clients may leave a review.</li>
          </ul>

          <h6>5) Messaging & Reviews</h6>
          <ul>
            <li>Use messaging respectfully. Don’t share illegal content or spam.</li>
            <li>Reviews must be honest, accurate, and non-abusive. We may remove content that violates these Terms.</li>
          </ul>

          <h6>6) Prohibited Activities</h6>
          <ul>
            <li>Impersonation, fraud, scraping, reverse engineering, or security probing.</li>
            <li>Posting illegal, hateful, pornographic, or otherwise harmful content.</li>
            <li>Sharing someone else’s personal data without consent.</li>
          </ul>

          <h6>7) Intellectual Property</h6>
          <p>The Platform, logos, and software are our property. You’re given a limited, revocable, non-exclusive license to use the Platform in line with these Terms.</p>

          <h6>8) Disclaimers & Liability</h6>
          <ul>
            <li>We provide a marketplace and do not guarantee job outcomes, worker performance, or client payments.</li>
            <li>To the extent permitted by law, we’re not liable for indirect or consequential damages arising from your use of the Platform.</li>
          </ul>

          <h6>9) Suspension & Termination</h6>
          <p>We may suspend or terminate accounts that violate these Terms or create risk for other users or the Platform.</p>

          <h6>10) Changes</h6>
          <p>We may update these Terms. We’ll post the new version with an “Effective date.” Your continued use means you accept the changes.</p>

          <h6>11) Governing Law & Disputes</h6>
          <p>These Terms are governed by the laws of Sri Lanka. Disputes will be resolved in courts of competent jurisdiction in Sri Lanka.</p>

          <h6>12) Contact</h6>
          <p class="mb-0">Questions? Email <a href="mailto:support@skilllink.lk">support@skilllink.lk</a>.</p>
        </div>
        <div class="modal-footer">
          <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- PRIVACY POLICY Modal -->
  <div class="modal fade" id="privacyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">SkillLink – Privacy Policy</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <p class="small text-muted mb-3">Effective date: 02 Sep 2025</p>

          <h6>1) What this Policy Covers</h6>
          <p>This explains how we collect, use, share, and protect your information when you use SkillLink’s Platform.</p>

          <h6>2) Data We Collect</h6>
          <ul>
            <li><strong>Account details:</strong> full name, username, email, phone, age, address, bio, profile picture.</li>
            <li><strong>Identity verification:</strong> NIC/ID image and verification status (unverified, pending, verified, denied).</li>
            <li><strong>Platform activity:</strong> job posts, budgets, categories, location text, offers/acceptance, job status, reviews and ratings.</li>
            <li><strong>Messages:</strong> conversation metadata and message content you send/receive.</li>
            <li><strong>Device & usage:</strong> cookies or similar tech, logs (e.g., IP, timestamps, pages/features used) to improve security and performance.</li>
          </ul>

          <h6>3) How We Use Your Data</h6>
          <ul>
            <li>To operate the Platform (profiles, job posts, offers, messaging, reviews).</li>
            <li>To verify users and protect against fraud/spam.</li>
            <li>To improve features, analytics, and safety.</li>
            <li>To communicate important updates and respond to support requests.</li>
          </ul>

          <h6>4) Sharing</h6>
          <ul>
            <li><strong>With other users:</strong> we share only what’s needed (e.g., your name/profile when you post/accept jobs or message).</li>
            <li><strong>With admins:</strong> to review verifications and job posts.</li>
            <li><strong>With service providers:</strong> hosting, analytics, or security partners under appropriate safeguards.</li>
            <li><strong>Legal:</strong> if required by law or to protect rights, safety, or integrity of the Platform.</li>
          </ul>

          <h6>5) Cookies & Similar Technologies</h6>
          <p>We use cookies for session management, security, and usage analytics. You can control cookies in your browser, but some features may not work properly without them.</p>

          <h6>6) Data Retention</h6>
          <p>We retain information as long as necessary to provide the service, comply with legal obligations, resolve disputes, and enforce agreements. ID photos are kept only as long as needed for verification and audit requirements.</p>

          <h6>7) Security</h6>
          <p>We take reasonable technical and organizational measures to protect your data. No method is 100% secure; use strong passwords and keep them confidential.</p>

          <h6>8) Your Rights</h6>
          <ul>
            <li>Access, correct, or delete your information (subject to legal exceptions).</li>
            <li>Object to or restrict certain processing; request a copy of your data (portability).</li>
            <li>To exercise any of these rights, contact <a href="mailto:support@skilllink.lk">support@skilllink.lk</a>.</li>
          </ul>

          <h6>9) Children</h6>
          <p>The Platform isn’t intended for children under 16. If you believe a minor has provided data, contact us to remove it.</p>

          <h6>10) Changes</h6>
          <p>We may update this Policy and will post the new effective date. Continued use means you accept the changes.</p>

          <h6>11) Contact</h6>
          <p class="mb-0">Questions or requests: <a href="mailto:support@skilllink.lk">support@skilllink.lk</a>.</p>
        </div>
        <div class="modal-footer">
          <button class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap Bundle -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Small JS helpers -->
  <script>
    // Toggle password visibility
    document.getElementById('togglePassword').addEventListener('click', function() {
      const input = document.getElementById('password');
      const icon = this.querySelector('i');
      const isPw = input.type === 'password';
      input.type = isPw ? 'text' : 'password';
      icon.classList.toggle('fa-eye', !isPw);
      icon.classList.toggle('fa-eye-slash', isPw);
    });

    // Optional verification banner
    (function(){
      const params = new URLSearchParams(location.search);
      const status = params.get('verification');
      if(!status) return;
      if(status === 'pending') alert('Your account is pending verification. Please wait for admin approval.');
      if(status === 'rejected') alert('Your account verification was rejected. Please contact support.');
    })();
  </script>
</body>
</html>
