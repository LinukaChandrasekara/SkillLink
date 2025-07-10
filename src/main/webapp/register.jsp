<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillLink | Register</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
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
            padding: 2rem 0;
        }
        
        .register-container {
            max-width: 800px;
            width: 100%;
            margin: 0 auto;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            border-radius: 0.35rem;
            overflow: hidden;
        }
        
        .register-header {
            background-color: var(--primary-color);
            color: white;
            padding: 1.5rem;
            text-align: center;
        }
        
        .register-body {
            background-color: white;
            padding: 2rem;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(78, 115, 223, 0.25);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2653d4;
        }
        
        .nav-tabs .nav-link {
            color: var(--dark-color);
        }
        
        .nav-tabs .nav-link.active {
            color: var(--primary-color);
            font-weight: bold;
        }
        
        .preview-image {
            max-width: 150px;
            max-height: 150px;
            border-radius: 0.25rem;
            margin-top: 0.5rem;
            display: none;
        }
        
        .required-field::after {
            content: " *";
            color: red;
        }
        
        @media (max-width: 768px) {
            .register-container {
                margin: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <!-- Header Section -->
            <div class="register-header">
                <h2><i class="fas fa-hands-helping me-2"></i> SkillLink</h2>
                <p class="mb-0">Join our community of skilled workers and clients</p>
            </div>
            
            <!-- Body Section -->
            <div class="register-body">
                <!-- Error/Success Messages -->
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i> <%= request.getParameter("error") %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>
                
                <!-- Registration Type Tabs -->
                <ul class="nav nav-tabs nav-justified mb-4" id="registerTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="worker-tab" data-bs-toggle="tab" 
                                data-bs-target="#worker-form" type="button" role="tab">
                            <i class="fas fa-tools me-2"></i>Register as Worker
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="client-tab" data-bs-toggle="tab" 
                                data-bs-target="#client-form" type="button" role="tab">
                            <i class="fas fa-user-tie me-2"></i>Register as Client
                        </button>
                    </li>
                </ul>
                
                <!-- Tab Content -->
                <div class="tab-content" id="registerTabsContent">
                    <!-- Worker Registration Form -->
                    <div class="tab-pane fade show active" id="worker-form" role="tabpanel">
                        <form action="${pageContext.request.contextPath}/auth/register" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="userType" value="worker">
                            
                            <h5 class="mb-4"><i class="fas fa-user-circle me-2"></i>Basic Information</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="w-fullName" class="form-label required-field">Full Name</label>
                                    <input type="text" class="form-control" id="w-fullName" name="fullName" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-idNumber" class="form-label required-field">ID Number</label>
                                    <input type="text" class="form-control" id="w-idNumber" name="idNumber" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-email" class="form-label required-field">Email</label>
                                    <input type="email" class="form-control" id="w-email" name="email" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-phone" class="form-label required-field">Phone Number</label>
                                    <input type="tel" class="form-control" id="w-phone" name="phone" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-age" class="form-label required-field">Age</label>
                                    <input type="number" class="form-control" id="w-age" name="age" min="18" max="99" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-location" class="form-label required-field">Location</label>
                                    <input type="text" class="form-control" id="w-location" name="location" required>
                                </div>
                            </div>
                            
                            <h5 class="mb-4"><i class="fas fa-briefcase me-2"></i>Work Details</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="w-jobCategory" class="form-label required-field">Job Category</label>
                                    <select class="form-select" id="w-jobCategory" name="jobCategory" required>
                                        <option value="" selected disabled>Select your category</option>
                                        <option value="Electrician">Electrician</option>
                                        <option value="Plumber">Plumber</option>
                                        <option value="Carpenter">Carpenter</option>
                                        <option value="Cleaner">Cleaner</option>
                                        <option value="Tutor">Tutor</option>
                                        <option value="Driver">Driver</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-experience" class="form-label required-field">Experience (Years)</label>
                                    <input type="number" class="form-control" id="w-experience" name="experienceYears" min="0" max="50" required>
                                </div>
                                <div class="col-12">
                                    <label for="w-description" class="form-label required-field">Description</label>
                                    <textarea class="form-control" id="w-description" name="description" rows="3" required></textarea>
                                    <small class="text-muted">Tell us about your skills and experience</small>
                                </div>
                            </div>
                            
                            <h5 class="mb-4"><i class="fas fa-lock me-2"></i>Account Security</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="w-username" class="form-label required-field">Username</label>
                                    <input type="text" class="form-control" id="w-username" name="username" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-password" class="form-label required-field">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="w-password" name="password" required>
                                        <button class="btn btn-outline-secondary" type="button" id="w-togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="password-strength mt-2">
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                        </div>
                                        <small class="text-muted">Password strength: <span id="w-strength-text">Weak</span></small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="w-confirmPassword" class="form-label required-field">Confirm Password</label>
                                    <input type="password" class="form-control" id="w-confirmPassword" required>
                                    <div class="invalid-feedback" id="w-password-match-feedback">
                                        Passwords do not match
                                    </div>
                                </div>
                            </div>
                            
                            <h5 class="mb-4"><i class="fas fa-id-card me-2"></i>Verification Documents</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="w-profilePicture" class="form-label required-field">Profile Picture</label>
                                    <input type="file" class="form-control" id="w-profilePicture" name="profilePicture" accept="image/*" required>
                                    <img id="w-profilePreview" class="preview-image" alt="Profile preview">
                                </div>
                                <div class="col-md-6">
                                    <label for="w-idProof" class="form-label required-field">ID Proof (Photo)</label>
                                    <input type="file" class="form-control" id="w-idProof" name="idProof" accept="image/*" required>
                                    <img id="w-idPreview" class="preview-image" alt="ID preview">
                                    <small class="text-muted">Upload a clear photo of your government-issued ID</small>
                                </div>
                            </div>
                            
                            <div class="form-check mb-4">
                                <input class="form-check-input" type="checkbox" id="w-terms" required>
                                <label class="form-check-label" for="w-terms">
                                    I agree to the <a href="#" class="text-decoration-none">Terms of Service</a> and 
                                    <a href="#" class="text-decoration-none">Privacy Policy</a>
                                </label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary py-2">
                                    <i class="fas fa-user-plus me-2"></i>Register as Worker
                                </button>
                            </div>
                        </form>
                    </div>
                    
                    <!-- Client Registration Form -->
                    <div class="tab-pane fade" id="client-form" role="tabpanel">
                        <form action="${pageContext.request.contextPath}/auth/register" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="userType" value="client">
                            
                            <h5 class="mb-4"><i class="fas fa-user-circle me-2"></i>Basic Information</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="c-fullName" class="form-label required-field">Full Name</label>
                                    <input type="text" class="form-control" id="c-fullName" name="fullName" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="c-idNumber" class="form-label required-field">ID Number</label>
                                    <input type="text" class="form-control" id="c-idNumber" name="idNumber" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="c-email" class="form-label required-field">Email</label>
                                    <input type="email" class="form-control" id="c-email" name="email" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="c-phone" class="form-label required-field">Phone Number</label>
                                    <input type="tel" class="form-control" id="c-phone" name="phone" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="c-age" class="form-label required-field">Age</label>
                                    <input type="number" class="form-control" id="c-age" name="age" min="18" max="99" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="c-location" class="form-label required-field">Location</label>
                                    <input type="text" class="form-control" id="c-location" name="location" required>
                                </div>
                            </div>
                            
                            <h5 class="mb-4"><i class="fas fa-building me-2"></i>Client Type</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-12">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="clientType" id="individual" value="individual" checked>
                                        <label class="form-check-label" for="individual">Individual</label>
                                    </div>
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="clientType" id="business" value="business">
                                        <label class="form-check-label" for="business">Business</label>
                                    </div>
                                </div>
                                <div class="col-12" id="businessFields" style="display: none;">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label for="c-businessName" class="form-label">Business Name</label>
                                            <input type="text" class="form-control" id="c-businessName" name="businessName">
                                        </div>
                                        <div class="col-md-6">
                                            <label for="c-businessAddress" class="form-label">Business Address</label>
                                            <input type="text" class="form-control" id="c-businessAddress" name="businessAddress">
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <h5 class="mb-4"><i class="fas fa-lock me-2"></i>Account Security</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="c-username" class="form-label required-field">Username</label>
                                    <input type="text" class="form-control" id="c-username" name="username" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="c-password" class="form-label required-field">Password</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="c-password" name="password" required>
                                        <button class="btn btn-outline-secondary" type="button" id="c-togglePassword">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="password-strength mt-2">
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" role="progressbar" style="width: 0%"></div>
                                        </div>
                                        <small class="text-muted">Password strength: <span id="c-strength-text">Weak</span></small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="c-confirmPassword" class="form-label required-field">Confirm Password</label>
                                    <input type="password" class="form-control" id="c-confirmPassword" required>
                                    <div class="invalid-feedback" id="c-password-match-feedback">
                                        Passwords do not match
                                    </div>
                                </div>
                            </div>
                            
                            <h5 class="mb-4"><i class="fas fa-id-card me-2"></i>Verification Documents</h5>
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="c-profilePicture" class="form-label required-field">Profile Picture</label>
                                    <input type="file" class="form-control" id="c-profilePicture" name="profilePicture" accept="image/*" required>
                                    <img id="c-profilePreview" class="preview-image" alt="Profile preview">
                                </div>
                                <div class="col-md-6">
                                    <label for="c-idProof" class="form-label required-field">ID Proof (Photo)</label>
                                    <input type="file" class="form-control" id="c-idProof" name="idProof" accept="image/*" required>
                                    <img id="c-idPreview" class="preview-image" alt="ID preview">
                                    <small class="text-muted">Upload a clear photo of your government-issued ID</small>
                                </div>
                            </div>
                            
                            <div class="form-check mb-4">
                                <input class="form-check-input" type="checkbox" id="c-terms" required>
                                <label class="form-check-label" for="c-terms">
                                    I agree to the <a href="#" class="text-decoration-none">Terms of Service</a> and 
                                    <a href="#" class="text-decoration-none">Privacy Policy</a>
                                </label>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary py-2">
                                    <i class="fas fa-user-plus me-2"></i>Register as Client
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Login Link -->
                <div class="text-center mt-4">
                    <p>Already have an account? <a href="login.jsp" class="text-decoration-none">Login here</a></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Toggle password visibility for both forms
        document.querySelectorAll('[id$="togglePassword"]').forEach(button => {
            button.addEventListener('click', function() {
                const formPrefix = this.id.split('-')[0];
                const passwordInput = document.getElementById(`${formPrefix}-password`);
                const icon = this.querySelector('i');
                
                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    passwordInput.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            });
        });
        
        // Password strength indicator for both forms
        document.querySelectorAll('[id$="password"]').forEach(input => {
            input.addEventListener('input', function() {
                const formPrefix = this.id.split('-')[0];
                const strengthBar = document.querySelector(`#${formPrefix}-password`).parentElement.nextElementSibling.querySelector('.progress-bar');
                const strengthText = document.getElementById(`${formPrefix}-strength-text`);
                const password = this.value;
                let strength = 0;
                
                // Length check
                if (password.length >= 8) strength += 25;
                if (password.length >= 12) strength += 25;
                
                // Complexity checks
                if (/[A-Z]/.test(password)) strength += 15;
                if (/[0-9]/.test(password)) strength += 15;
                if (/[^A-Za-z0-9]/.test(password)) strength += 20;
                
                // Update UI
                strengthBar.style.width = `${strength}%`;
                
                if (strength < 50) {
                    strengthBar.className = 'progress-bar bg-danger';
                    strengthText.textContent = 'Weak';
                } else if (strength < 75) {
                    strengthBar.className = 'progress-bar bg-warning';
                    strengthText.textContent = 'Moderate';
                } else {
                    strengthBar.className = 'progress-bar bg-success';
                    strengthText.textContent = 'Strong';
                }
            });
        });
        
        // Password confirmation validation for both forms
        document.querySelectorAll('[id$="confirmPassword"]').forEach(input => {
            input.addEventListener('input', function() {
                const formPrefix = this.id.split('-')[0];
                const password = document.getElementById(`${formPrefix}-password`).value;
                const confirmPassword = this.value;
                const feedback = document.getElementById(`${formPrefix}-password-match-feedback`);
                
                if (confirmPassword && password !== confirmPassword) {
                    this.classList.add('is-invalid');
                    feedback.style.display = 'block';
                } else {
                    this.classList.remove('is-invalid');
                    feedback.style.display = 'none';
                }
            });
        });
        
        // Image preview for both forms
        document.querySelectorAll('input[type="file"]').forEach(input => {
            input.addEventListener('change', function() {
                const formPrefix = this.id.split('-')[0];
                const fieldType = this.id.split('-')[1];
                const preview = document.getElementById(`${formPrefix}-${fieldType}Preview`);
                
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    
                    reader.onload = function(e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    }
                    
                    reader.readAsDataURL(this.files[0]);
                }
            });
        });
        
        // Show/hide business fields based on client type selection
        document.querySelectorAll('input[name="clientType"]').forEach(radio => {
            radio.addEventListener('change', function() {
                const businessFields = document.getElementById('businessFields');
                if (this.value === 'business') {
                    businessFields.style.display = 'block';
                    document.getElementById('c-businessName').required = true;
                    document.getElementById('c-businessAddress').required = true;
                } else {
                    businessFields.style.display = 'none';
                    document.getElementById('c-businessName').required = false;
                    document.getElementById('c-businessAddress').required = false;
                }
            });
        });
        
        // Form validation before submission
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                const formPrefix = this.querySelector('[id$="confirmPassword"]').id.split('-')[0];
                const password = document.getElementById(`${formPrefix}-password`).value;
                const confirmPassword = document.getElementById(`${formPrefix}-confirmPassword`).value;
                
                if (password !== confirmPassword) {
                    e.preventDefault();
                    document.getElementById(`${formPrefix}-confirmPassword`).classList.add('is-invalid');
                    document.getElementById(`${formPrefix}-password-match-feedback`).style.display = 'block';
                    document.getElementById(`${formPrefix}-confirmPassword`).scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                    });
                }
            });
        });
    </script>
</body>
</html>