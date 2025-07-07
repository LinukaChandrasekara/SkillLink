<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillLink - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3f37c9;
            --accent-color: #4cc9f0;
            --success-color: #4caf50;
            --warning-color: #ff9800;
            --danger-color: #f44336;
            --light-bg: #f8f9fa;
            --dark-text: #212529;
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
        
        .register-container {
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            max-width: 1200px;
            width: 100%;
        }
        
        .register-header {
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            padding: 25px;
            text-align: center;
            color: white;
        }
        
        .brand-logo {
            font-size: 2.8rem;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .brand-logo span {
            color: #ffd166;
        }
        
        .register-body {
            padding: 40px;
        }
        
        .form-section {
            margin-bottom: 30px;
            padding: 25px;
            border-radius: 15px;
            background-color: var(--light-bg);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border-left: 4px solid var(--primary-color);
        }
        
        .section-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px dashed #dee2e6;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 10px;
            font-size: 1.5rem;
        }
        
        .account-type {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .account-type .form-check {
            flex: 1;
            min-width: 200px;
        }
        
        .account-type .form-check-input {
            display: none;
        }
        
        .account-type .form-check-label {
            display: block;
            padding: 20px;
            border: 2px solid #dee2e6;
            border-radius: 12px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .account-type .form-check-input:checked + .form-check-label {
            border-color: var(--primary-color);
            background-color: rgba(67, 97, 238, 0.05);
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(67, 97, 238, 0.15);
        }
        
        .account-type .form-check-label i {
            font-size: 2.5rem;
            display: block;
            margin-bottom: 15px;
            color: var(--primary-color);
        }
        
        .account-type .form-check-label h5 {
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--dark-text);
        }
        
        .account-type .form-check-label p {
            color: #6c757d;
            margin-bottom: 0;
            font-size: 0.9rem;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            font-weight: 600;
            margin-bottom: 8px;
            color: var(--dark-text);
            display: flex;
            align-items: center;
        }
        
        .form-label .required {
            color: var(--danger-color);
            margin-left: 5px;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary-color);
            z-index: 10;
        }
        
        .form-control {
            padding-left: 45px;
            border-radius: 10px;
            height: 50px;
            border: 2px solid #dee2e6;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
            border-color: var(--primary-color);
        }
        
        .input-group-text {
            background-color: var(--light-bg);
            border-radius: 10px 0 0 10px;
            border: 2px solid #dee2e6;
            border-right: none;
        }
        
        .photo-upload {
            border: 2px dashed #dee2e6;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            background-color: rgba(67, 97, 238, 0.03);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .photo-upload:hover {
            border-color: var(--primary-color);
            background-color: rgba(67, 97, 238, 0.08);
        }
        
        .photo-upload i {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .photo-upload h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .photo-preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            display: none;
            margin: 0 auto;
            border: 3px solid var(--primary-color);
        }
        
        .btn-submit {
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
            border: none;
            padding: 15px 30px;
            font-size: 1.1rem;
            font-weight: 700;
            border-radius: 50px;
            transition: all 0.3s ease;
            display: block;
            margin: 30px auto 0;
            width: 250px;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(67, 97, 238, 0.3);
        }
        
        .form-note {
            background-color: #e3f2fd;
            border-left: 4px solid var(--primary-color);
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .form-note i {
            color: var(--primary-color);
            margin-right: 10px;
        }
        
        .progress-container {
            margin: 30px 0;
        }
        
        .progress {
            height: 12px;
            border-radius: 6px;
            margin-bottom: 10px;
        }
        
        .progress-bar {
            background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
        }
        
        .step-indicator {
            display: flex;
            justify-content: space-between;
            position: relative;
        }
        
        .step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #dee2e6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #6c757d;
            position: relative;
            z-index: 2;
        }
        
        .step.active {
            background-color: var(--primary-color);
            color: white;
        }
        
        .step-label {
            position: absolute;
            top: 45px;
            font-size: 0.85rem;
            color: #6c757d;
            white-space: nowrap;
            text-align: center;
            width: 100px;
            left: 50%;
            transform: translateX(-50%);
        }
        
        .step-indicator::before {
            content: '';
            position: absolute;
            top: 20px;
            left: 0;
            width: 100%;
            height: 4px;
            background-color: #dee2e6;
            z-index: 1;
        }
        
        @media (max-width: 768px) {
            .register-body {
                padding: 20px;
            }
            
            .account-type .form-check {
                min-width: 100%;
            }
            
            .form-section {
                padding: 20px;
            }
        }
        
        .worker-fields, .business-fields {
            display: none;
        }
        
        .animated-field {
            animation: fadeIn 0.5s ease;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .password-container {
            position: relative;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
            z-index: 10;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <div class="brand-logo">Skill<span>Link</span></div>
            <p class="lead">Join our platform to find opportunities or skilled workers in your area</p>
        </div>
        
        <div class="register-body">
            <div class="progress-container">
                <div class="progress">
                    <div class="progress-bar" role="progressbar" style="width: 33%;" aria-valuenow="33" aria-valuemin="0" aria-valuemax="100"></div>
                </div>
                <div class="step-indicator">
                    <div class="step active">1</div>
                    <div class="step">2</div>
                    <div class="step">3</div>
                </div>
            </div>
            
            <form action="register" method="POST" enctype="multipart/form-data">
                <div class="form-section">
                    <h3 class="section-title"><i class="bi bi-person-badge"></i> Account Type</h3>
                    
                    <div class="account-type">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="accountType" id="individual" value="individual" checked>
                            <label class="form-check-label" for="individual">
                                <i class="bi bi-person"></i>
                                <h5>Individual Client</h5>
                                <p>Looking for services as an individual</p>
                            </label>
                        </div>
                        
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="accountType" id="business" value="business">
                            <label class="form-check-label" for="business">
                                <i class="bi bi-building"></i>
                                <h5>Business Client</h5>
                                <p>Company or organization seeking services</p>
                            </label>
                        </div>
                        
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="accountType" id="worker" value="worker">
                            <label class="form-check-label" for="worker">
                                <i class="bi bi-tools"></i>
                                <h5>Worker</h5>
                                <p>Provide services as a skilled professional</p>
                            </label>
                        </div>
                        
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="accountType" id="admin" value="admin">
                            <label class="form-check-label" for="admin">
                                <i class="bi bi-shield-lock"></i>
                                <h5>Administrator</h5>
                                <p>Platform manager and moderator</p>
                            </label>
                        </div>
                    </div>
                    
                    <div class="form-note">
                        <i class="bi bi-info-circle"></i>
                        <strong>Note:</strong> All accounts require ID verification after registration. 
                        Administrators will review your information before granting full access.
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="bi bi-person-lines-fill"></i> Personal Information</h3>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Full Name <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-person input-icon"></i>
                                    <input type="text" class="form-control" name="fullName" placeholder="Enter your full name" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">National ID Number <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-credit-card input-icon"></i>
                                    <input type="text" class="form-control" name="nationalId" placeholder="Enter your ID number" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Email Address <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-envelope input-icon"></i>
                                    <input type="email" class="form-control" name="email" placeholder="Enter your email" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Phone Number <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-telephone input-icon"></i>
                                    <input type="tel" class="form-control" name="phone" placeholder="Enter your phone number" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Password <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-lock input-icon"></i>
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Create a password" required>
                                    <span class="password-toggle" id="togglePassword">
                                        <i class="bi bi-eye"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Confirm Password <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-lock input-icon"></i>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm your password" required>
                                    <span class="password-toggle" id="toggleConfirmPassword">
                                        <i class="bi bi-eye"></i>
                                    </span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Age <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-calendar input-icon"></i>
                                    <input type="number" class="form-control" name="age" placeholder="Enter your age" min="18" max="100" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Location <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-geo-alt input-icon"></i>
                                    <input type="text" class="form-control" name="location" placeholder="Enter your location" required>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="bi bi-card-image"></i> Photo Upload</h3>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="photo-upload" id="profileUpload">
                                <i class="bi bi-person-square"></i>
                                <h5>Upload Profile Photo</h5>
                                <p>Click to upload or drag & drop</p>
                                <p class="small text-muted">JPG or PNG, Max 2MB</p>
                                <input type="file" id="profilePhoto" name="profilePhoto" accept="image/*" class="d-none">
                                <img id="profilePreview" class="photo-preview" alt="Profile preview">
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="photo-upload" id="idUpload">
                                <i class="bi bi-person-badge"></i>
                                <h5>Upload ID Photo</h5>
                                <p>Click to upload or drag & drop</p>
                                <p class="small text-muted">JPG or PNG, Max 3MB</p>
                                <input type="file" id="idPhoto" name="idPhoto" accept="image/*" class="d-none">
                                <img id="idPreview" class="photo-preview" alt="ID preview">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-note mt-4">
                        <i class="bi bi-shield-check"></i>
                        <strong>Security Note:</strong> Your ID photo is required for verification purposes only. 
                        It will be securely stored and only accessible to administrators.
                    </div>
                </div>
                
                <div class="form-section business-fields">
                    <h3 class="section-title"><i class="bi bi-building"></i> Business Information</h3>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Business Name <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-building input-icon"></i>
                                    <input type="text" class="form-control" name="businessName" placeholder="Enter business name">
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Business Type</label>
                                <div class="position-relative">
                                    <i class="bi bi-diagram-3 input-icon"></i>
                                    <select class="form-control" name="businessType">
                                        <option value="">Select business type</option>
                                        <option value="retail">Retail</option>
                                        <option value="service">Service Provider</option>
                                        <option value="manufacturing">Manufacturing</option>
                                        <option value="hospitality">Hospitality</option>
                                        <option value="education">Education</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="form-label">Business Description</label>
                                <textarea class="form-control" name="businessDescription" rows="3" placeholder="Briefly describe your business"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="form-section worker-fields">
                    <h3 class="section-title"><i class="bi bi-tools"></i> Worker Information</h3>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Job Category <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-briefcase input-icon"></i>
                                    <select class="form-control" name="jobCategory">
                                        <option value="">Select your category</option>
                                        <option value="electrician">Electrician</option>
                                        <option value="plumber">Plumber</option>
                                        <option value="carpenter">Carpenter</option>
                                        <option value="cleaner">Cleaner</option>
                                        <option value="tutor">Tutor</option>
                                        <option value="driver">Driver</option>
                                        <option value="mechanic">Mechanic</option>
                                        <option value="gardener">Gardener</option>
                                        <option value="painter">Painter</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Years of Experience <span class="required">*</span></label>
                                <div class="position-relative">
                                    <i class="bi bi-award input-icon"></i>
                                    <select class="form-control" name="experience">
                                        <option value="">Select experience</option>
                                        <option value="0">Less than 1 year</option>
                                        <option value="1">1-2 years</option>
                                        <option value="3">3-5 years</option>
                                        <option value="6">6-10 years</option>
                                        <option value="11">More than 10 years</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="form-label">Professional Description <span class="required">*</span></label>
                                <textarea class="form-control" name="description" rows="4" placeholder="Describe your skills, experience, and services you offer"></textarea>
                            </div>
                        </div>
                        
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="form-label">Hourly Rate (Optional)</label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number" class="form-control" name="hourlyRate" placeholder="Enter your hourly rate">
                                    <span class="input-group-text">per hour</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="form-check mb-4">
                    <input class="form-check-input" type="checkbox" id="terms" required>
                    <label class="form-check-label" for="terms">
                        I agree to the <a href="#" class="text-decoration-none">Terms of Service</a> and <a href="#" class="text-decoration-none">Privacy Policy</a>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-submit">Create Account</button>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle password visibility
        const togglePassword = document.querySelector('#togglePassword');
        const password = document.querySelector('#password');
        
        togglePassword.addEventListener('click', function() {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
        });
        
        const toggleConfirmPassword = document.querySelector('#toggleConfirmPassword');
        const confirmPassword = document.querySelector('#confirmPassword');
        
        toggleConfirmPassword.addEventListener('click', function() {
            const type = confirmPassword.getAttribute('type') === 'password' ? 'text' : 'password';
            confirmPassword.setAttribute('type', type);
            this.innerHTML = type === 'password' ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
        });
        
        // Account type selection
        const accountTypeRadios = document.querySelectorAll('input[name="accountType"]');
        const businessFields = document.querySelector('.business-fields');
        const workerFields = document.querySelector('.worker-fields');
        
        accountTypeRadios.forEach(radio => {
            radio.addEventListener('change', function() {
                if (this.value === 'business') {
                    businessFields.style.display = 'block';
                    workerFields.style.display = 'none';
                } else if (this.value === 'worker') {
                    workerFields.style.display = 'block';
                    businessFields.style.display = 'none';
                } else {
                    businessFields.style.display = 'none';
                    workerFields.style.display = 'none';
                }
                
                // Add animation to newly shown fields
                if (businessFields.style.display === 'block') {
                    businessFields.classList.add('animated-field');
                } else if (workerFields.style.display === 'block') {
                    workerFields.classList.add('animated-field');
                }
            });
        });
        
        // Photo upload functionality
        const profileUpload = document.getElementById('profileUpload');
        const profileInput = document.getElementById('profilePhoto');
        const profilePreview = document.getElementById('profilePreview');
        
        profileUpload.addEventListener('click', function() {
            profileInput.click();
        });
        
        profileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    profilePreview.src = e.target.result;
                    profilePreview.style.display = 'block';
                    profileUpload.querySelector('p').style.display = 'none';
                }
                
                reader.readAsDataURL(this.files[0]);
            }
        });
        
        const idUpload = document.getElementById('idUpload');
        const idInput = document.getElementById('idPhoto');
        const idPreview = document.getElementById('idPreview');
        
        idUpload.addEventListener('click', function() {
            idInput.click();
        });
        
        idInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    idPreview.src = e.target.result;
                    idPreview.style.display = 'block';
                    idUpload.querySelector('p').style.display = 'none';
                }
                
                reader.readAsDataURL(this.files[0]);
            }
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            const accountType = document.querySelector('input[name="accountType"]:checked').value;
            const profilePhoto = document.getElementById('profilePhoto').files.length;
            const idPhoto = document.getElementById('idPhoto').files.length;
            
            if (!profilePhoto || !idPhoto) {
                e.preventDefault();
                alert('Please upload both profile photo and ID photo!');
                return false;
            }
            
            if (accountType === 'worker') {
                const jobCategory = document.querySelector('select[name="jobCategory"]').value;
                const experience = document.querySelector('select[name="experience"]').value;
                const description = document.querySelector('textarea[name="description"]').value;
                
                if (!jobCategory || !experience || !description) {
                    e.preventDefault();
                    alert('Please fill all required worker information!');
                    return false;
                }
            }
            
            return true;
        });
    </script>
</body>
</html>