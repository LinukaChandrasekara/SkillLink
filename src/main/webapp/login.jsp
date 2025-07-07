<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillLink - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4cc9f0;
            --light-bg: #f8f9fa;
            --dark-text: #212529;
            --success-color: #4caf50;
            --danger-color: #f44336;
        }
        
        body {
            background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .login-container {
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            max-width: 1000px;
            width: 100%;
        }
        
        .login-left {
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect width="100" height="100" fill="%234361ee" opacity="0.1"/><path d="M20,20 Q40,5 60,20 T100,20 V80 Q80,95 60,80 T20,80 Z" fill="none" stroke="%234cc9f0" stroke-width="0.5"/></svg>') center/cover;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background-color: rgba(67, 97, 238, 0.05);
        }
        
        .login-right {
            padding: 40px;
            background-color: white;
        }
        
        .brand-logo {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .brand-logo span {
            color: var(--accent-color);
        }
        
        .slogan {
            font-size: 1.8rem;
            font-weight: 600;
            color: var(--dark-text);
            margin-bottom: 15px;
            line-height: 1.3;
        }
        
        .highlight {
            color: var(--primary-color);
        }
        
        .features-list {
            list-style-type: none;
            padding: 0;
            margin-top: 30px;
        }
        
        .features-list li {
            padding: 8px 0;
            display: flex;
            align-items: center;
        }
        
        .features-list i {
            color: var(--success-color);
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-header h2 {
            color: var(--dark-text);
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .login-header p {
            color: #6c757d;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
            color: var(--dark-text);
        }
        
        .input-group-text {
            background-color: var(--light-bg);
            border-right: none;
        }
        
        .form-control {
            border-left: none;
            padding-left: 5px;
        }
        
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
            border-color: var(--primary-color);
        }
        
        .role-selector {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .role-option {
            flex: 1;
            text-align: center;
            padding: 15px;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .role-option:hover {
            border-color: var(--accent-color);
        }
        
        .role-option.active {
            border-color: var(--primary-color);
            background-color: rgba(67, 97, 238, 0.05);
        }
        
        .role-option i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: var(--primary-color);
        }
        
        .btn-login {
            background-color: var(--primary-color);
            border: none;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
        }
        
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 25px 0;
            color: #6c757d;
        }
        
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #dee2e6;
        }
        
        .divider::before {
            margin-right: 10px;
        }
        
        .divider::after {
            margin-left: 10px;
        }
        
        .social-login {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .social-btn {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            transition: all 0.3s ease;
        }
        
        .social-btn:hover {
            transform: translateY(-3px);
        }
        
        .btn-google {
            background-color: #db4a39;
            color: white;
        }
        
        .btn-facebook {
            background-color: #3b5998;
            color: white;
        }
        
        .btn-linkedin {
            background-color: #0077b5;
            color: white;
        }
        
        .signup-link {
            text-align: center;
            margin-top: 20px;
            color: #6c757d;
        }
        
        .signup-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .signup-link a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .login-left {
                display: none;
            }
            
            .role-selector {
                flex-direction: column;
            }
        }
        
        .animated-input {
            transition: transform 0.3s ease;
        }
        
        .animated-input:focus {
            transform: scale(1.02);
        }
        
        .password-toggle {
            cursor: pointer;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 5;
        }
        
        .password-container {
            position: relative;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="row g-0">
            <div class="col-lg-6 d-none d-lg-block">
                <div class="login-left">
                    <div class="brand-logo">Skill<span>Link</span></div>
                    <h2 class="slogan">Connecting <span class="highlight">Informal Workers</span> with Local Opportunities</h2>
                    <p>Our AI-powered platform bridges the gap between skilled workers and clients in need of services.</p>
                    
                    <ul class="features-list">
                        <li><i class="bi bi-check-circle-fill"></i> AI-Powered Job Matching</li>
                        <li><i class="bi bi-check-circle-fill"></i> Secure Communication Channels</li>
                        <li><i class="bi bi-check-circle-fill"></i> Real-time Analytics</li>
                        <li><i class="bi bi-check-circle-fill"></i> Client & Worker Verification</li>
                        <li><i class="bi bi-check-circle-fill"></i> Rating & Review System</li>
                    </ul>
                    
                    <div class="mt-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="bi bi-people-fill me-2" style="color: var(--primary-color); font-size: 1.5rem;"></i>
                            <div>
                                <h5 class="mb-0">5,000+ Workers</h5>
                                <small>Registered on our platform</small>
                            </div>
                        </div>
                        <div class="d-flex align-items-center">
                            <i class="bi bi-briefcase-fill me-2" style="color: var(--accent-color); font-size: 1.5rem;"></i>
                            <div>
                                <h5 class="mb-0">12,000+ Jobs</h5>
                                <small>Posted and completed</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="login-right">
                    <div class="login-header">
                        <h2>Welcome Back!</h2>
                        <p>Sign in to access your SkillLink account</p>
                    </div>
                    
                    <form action="login" method="POST">
                        <div class="role-selector">
                            <div class="role-option active" data-role="client">
                                <i class="bi bi-person-badge"></i>
                                <div>Client</div>
                            </div>
                            <div class="role-option" data-role="worker">
                                <i class="bi bi-tools"></i>
                                <div>Worker</div>
                            </div>
                            <div class="role-option" data-role="admin">
                                <i class="bi bi-shield-lock"></i>
                                <div>Admin</div>
                            </div>
                        </div>
                        <input type="hidden" id="userRole" name="role" value="client">
                        
                        <div class="form-group">
                            <label class="form-label">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="email" class="form-control animated-input" name="email" placeholder="Enter your email" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <div class="password-container">
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" class="form-control animated-input" id="password" name="password" placeholder="Enter your password" required>
                                </div>
                                <span class="password-toggle" id="togglePassword">
                                    <i class="bi bi-eye"></i>
                                </span>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="rememberMe">
                                <label class="form-check-label" for="rememberMe">Remember me</label>
                            </div>
                            <a href="#" class="text-decoration-none">Forgot password?</a>
                        </div>
                        
                        <button type="submit" class="btn btn-login btn-primary w-100">Sign In</button>
                    </form>
                    
                    <div class="divider">Or continue with</div>
                    
                    <div class="social-login">
                        <a href="#" class="social-btn btn-google"><i class="bi bi-google"></i></a>
                        <a href="#" class="social-btn btn-facebook"><i class="bi bi-facebook"></i></a>
                        <a href="#" class="social-btn btn-linkedin"><i class="bi bi-linkedin"></i></a>
                    </div>
                    
                    <div class="signup-link">
                        Don't have an account? <a href="register.jsp">Sign Up</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Role selection
        document.querySelectorAll('.role-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelectorAll('.role-option').forEach(el => el.classList.remove('active'));
                this.classList.add('active');
                document.getElementById('userRole').value = this.getAttribute('data-role');
            });
        });
        
        // Password visibility toggle
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');
        
        togglePassword.addEventListener('click', function() {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const email = this.elements['email'].value;
            const password = this.elements['password'].value;
            
            if (!email || !password) {
                e.preventDefault();
                alert('Please fill in all required fields.');
            }
        });
    </script>
</body>
</html>