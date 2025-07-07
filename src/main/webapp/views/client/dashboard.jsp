<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Client Dashboard - SkillLink</title>
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
            --sidebar-width: 260px;
        }
        
        body {
            background-color: #f5f7fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        
        /* Main Layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar */
        .sidebar {
            width: var(--sidebar-width);
            background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 3px 0 10px rgba(0, 0, 0, 0.1);
            z-index: 100;
        }
        
        .brand-logo {
            padding: 25px 20px;
            font-size: 1.8rem;
            font-weight: 700;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .brand-logo span {
            color: #ffd166;
        }
        
        .sidebar-menu {
            padding: 20px 0;
        }
        
        .sidebar-item {
            padding: 12px 20px;
            margin: 5px 0;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
            cursor: pointer;
            border-left: 4px solid transparent;
        }
        
        .sidebar-item:hover, .sidebar-item.active {
            background-color: rgba(255, 255, 255, 0.1);
            border-left: 4px solid var(--accent-color);
        }
        
        .sidebar-item i {
            margin-right: 12px;
            font-size: 1.2rem;
        }
        
        .sidebar-divider {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin: 15px 20px;
        }
        
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
        }
        
        /* Topbar */
        .topbar {
            background-color: white;
            padding: 15px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 0;
            z-index: 99;
        }
        
        .search-bar {
            position: relative;
            width: 400px;
        }
        
        .search-bar input {
            padding-left: 40px;
            border-radius: 50px;
            height: 40px;
        }
        
        .search-bar i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        
        .user-info {
            display: flex;
            align-items: center;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 10px;
            border: 2px solid var(--accent-color);
        }
        
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            width: 18px;
            height: 18px;
            background-color: var(--danger-color);
            border-radius: 50%;
            color: white;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* Dashboard Cards */
        .dashboard-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 25px;
            transition: transform 0.3s ease;
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }
        
        .card-title {
            font-weight: 600;
            color: var(--dark-text);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .card-title i {
            color: var(--primary-color);
            font-size: 1.2rem;
        }
        
        .stat-number {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        /* Content Area */
        .content-area {
            padding: 30px;
        }
        
        /* Verification Status */
        .verification-banner {
            background: linear-gradient(90deg, var(--warning-color), #ffc107);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .verification-banner.verified {
            background: linear-gradient(90deg, var(--success-color), #66bb6a);
        }
        
        .verification-banner i {
            font-size: 1.5rem;
            margin-right: 15px;
        }
        
        /* Profile Card */
        .profile-card {
            text-align: center;
            padding: 30px 20px;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--accent-color);
            margin: 0 auto 20px;
        }
        
        .verification-badge {
            position: absolute;
            bottom: 10px;
            right: 10px;
            width: 30px;
            height: 30px;
            background-color: var(--success-color);
            border-radius: 50%;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid white;
        }
        
        .profile-name {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .profile-location {
            color: #6c757d;
            margin-bottom: 20px;
        }
        
        .profile-stats {
            display: flex;
            justify-content: space-around;
            margin: 20px 0;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-item .number {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-item .label {
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        /* Job Post Form */
        .job-form .form-group {
            margin-bottom: 20px;
        }
        
        .job-form .form-label {
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .job-form .form-control, .job-form .form-select {
            border-radius: 10px;
            height: 45px;
            border: 2px solid #dee2e6;
        }
        
        .job-form textarea {
            min-height: 150px;
        }
        
        /* Workers Grid */
        .workers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .worker-card {
            background-color: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        
        .worker-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        
        .worker-header {
            padding: 20px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            color: white;
            text-align: center;
        }
        
        .worker-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            margin: 0 auto 15px;
        }
        
        .worker-name {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .worker-category {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .worker-body {
            padding: 20px;
        }
        
        .worker-info {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        
        .worker-info i {
            color: var(--primary-color);
            margin-right: 10px;
            width: 20px;
        }
        
        .worker-rating {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .stars {
            color: #ffc107;
            margin-right: 10px;
        }
        
        .rating-number {
            font-weight: 600;
            color: var(--dark-text);
        }
        
        .ai-match-badge {
            background-color: rgba(76, 201, 240, 0.2);
            color: var(--accent-color);
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
        }
        
        .ai-match-badge i {
            margin-right: 5px;
        }
        
        /* Chat Interface */
        .chat-container {
            display: flex;
            height: 600px;
            background-color: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .chat-sidebar {
            width: 300px;
            border-right: 1px solid #eee;
            background-color: #f8f9fa;
            overflow-y: auto;
        }
        
        .chat-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-weight: 600;
        }
        
        .chat-contact {
            padding: 15px;
            display: flex;
            align-items: center;
            cursor: pointer;
            border-bottom: 1px solid #eee;
            transition: background-color 0.2s;
        }
        
        .chat-contact:hover, .chat-contact.active {
            background-color: white;
        }
        
        .chat-contact-avatar {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
        }
        
        .chat-main {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        .chat-messages {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background-color: #f0f4f8;
        }
        
        .message {
            max-width: 70%;
            margin-bottom: 15px;
            padding: 12px 15px;
            border-radius: 15px;
            position: relative;
        }
        
        .received {
            background-color: white;
            border-bottom-left-radius: 5px;
            align-self: flex-start;
        }
        
        .sent {
            background-color: var(--primary-color);
            color: white;
            border-bottom-right-radius: 5px;
            align-self: flex-end;
            margin-left: auto;
        }
        
        .message-time {
            font-size: 0.7rem;
            opacity: 0.7;
            margin-top: 5px;
            display: block;
            text-align: right;
        }
        
        .chat-input {
            padding: 15px;
            border-top: 1px solid #eee;
            background-color: white;
            display: flex;
            align-items: center;
        }
        
        .chat-input input {
            flex: 1;
            border-radius: 50px;
            padding: 10px 20px;
            border: 1px solid #dee2e6;
        }
        
        .chat-input button {
            background-color: var(--primary-color);
            color: white;
            border: none;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            margin-left: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* Review Card */
        .review-card {
            background-color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .review-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .review-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
        }
        
        .review-meta {
            flex: 1;
        }
        
        .review-name {
            font-weight: 600;
            margin-bottom: 3px;
        }
        
        .review-job {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .review-stars {
            color: #ffc107;
            font-size: 1.2rem;
        }
        
        .review-content {
            line-height: 1.6;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
                overflow: visible;
            }
            
            .brand-logo span, .sidebar-item span {
                display: none;
            }
            
            .sidebar-item {
                justify-content: center;
            }
            
            .sidebar-item i {
                margin-right: 0;
                font-size: 1.4rem;
            }
            
            .main-content {
                margin-left: 70px;
            }
        }
        
        @media (max-width: 768px) {
            .search-bar {
                width: 200px;
            }
            
            .dashboard-stats {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .workers-grid {
                grid-template-columns: 1fr;
            }
            
            .chat-container {
                flex-direction: column;
                height: auto;
            }
            
            .chat-sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #eee;
            }
        }
        
        @media (max-width: 576px) {
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
            
            .topbar {
                padding: 15px;
            }
            
            .search-bar {
                display: none;
            }
            
            .content-area {
                padding: 15px;
            }
        }
        
        /* Active Section Highlight */
        .dashboard-section {
            display: none;
        }
        
        .dashboard-section.active {
            display: block;
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .fade-in {
            animation: fadeIn 0.5s ease forwards;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="brand-logo">
                <i class="bi bi-link-45deg"></i> Skill<span>Link</span>
            </div>
            
            <div class="sidebar-menu">
                <div class="sidebar-item active" data-target="dashboard">
                    <i class="bi bi-speedometer2"></i>
                    <span>Dashboard</span>
                </div>
                
                <div class="sidebar-item" data-target="profile">
                    <i class="bi bi-person"></i>
                    <span>My Profile</span>
                </div>
                
                <div class="sidebar-item" data-target="post-job">
                    <i class="bi bi-file-earmark-plus"></i>
                    <span>Post a Job</span>
                </div>
                
                <div class="sidebar-item" data-target="my-jobs">
                    <i class="bi bi-briefcase"></i>
                    <span>My Jobs</span>
                </div>
                
                <div class="sidebar-item" data-target="workers">
                    <i class="bi bi-people"></i>
                    <span>Find Workers</span>
                </div>
                
                <div class="sidebar-item" data-target="chat">
                    <i class="bi bi-chat-dots"></i>
                    <span>Messages</span>
                    <span class="notification-badge">3</span>
                </div>
                
                <div class="sidebar-item" data-target="reviews">
                    <i class="bi bi-star"></i>
                    <span>Leave Reviews</span>
                </div>
                
                <div class="sidebar-divider"></div>
                
                <div class="sidebar-item">
                    <i class="bi bi-gear"></i>
                    <span>Settings</span>
                </div>
                
                <div class="sidebar-item">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </div>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Topbar -->
            <div class="topbar">
                <div class="search-bar">
                    <i class="bi bi-search"></i>
                    <input type="text" class="form-control" placeholder="Search...">
                </div>
                
                <div class="user-info">
                    <div class="notification-icon position-relative me-4">
                        <i class="bi bi-bell fs-5"></i>
                        <span class="notification-badge">5</span>
                    </div>
                    
                    <div class="d-flex align-items-center">
                        <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="User" class="user-avatar">
                        <div>
                            <div class="fw-bold">Sarah Johnson</div>
                            <div class="text-muted small">Client</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Content Area -->
            <div class="content-area">
                <!-- Verification Banner -->
                <div class="verification-banner">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-shield-exclamation"></i>
                        <div>
                            <h5 class="mb-1">Account Verification Required</h5>
                            <p class="mb-0">Upload your ID photo to get verified and unlock all features</p>
                        </div>
                    </div>
                    <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#uploadIdModal">
                        Upload ID Now
                    </button>
                </div>
                
                <!-- Dashboard Overview -->
                <div class="dashboard-section active" id="dashboard">
                    <h3 class="mb-4">Dashboard Overview</h3>
                    
                    <div class="row">
                        <div class="col-md-8">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Recent Activity</span>
                                    <i class="bi bi-activity"></i>
                                </div>
                                
                                <div class="list-group">
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-primary bg-opacity-10 p-2 rounded-circle me-3">
                                                <i class="bi bi-briefcase text-primary"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Job Posted</div>
                                                <div class="text-muted small">You posted a job for "Home Cleaning"</div>
                                            </div>
                                            <div class="text-muted small">2 hours ago</div>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-success bg-opacity-10 p-2 rounded-circle me-3">
                                                <i class="bi bi-check-circle text-success"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Job Completed</div>
                                                <div class="text-muted small">Your electrical repair job was completed by Michael</div>
                                            </div>
                                            <div class="text-muted small">1 day ago</div>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-info bg-opacity-10 p-2 rounded-circle me-3">
                                                <i class="bi bi-chat-dots text-info"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">New Message</div>
                                                <div class="text-muted small">You received a message from Robert</div>
                                            </div>
                                            <div class="text-muted small">2 days ago</div>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-warning bg-opacity-10 p-2 rounded-circle me-3">
                                                <i class="bi bi-star text-warning"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Review Received</div>
                                                <div class="text-muted small">David rated your job 5 stars</div>
                                            </div>
                                            <div class="text-muted small">3 days ago</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="dashboard-card profile-card">
                                <div class="position-relative d-inline-block">
                                    <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Profile" class="profile-avatar">
                                    <div class="verification-badge">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                </div>
                                
                                <h3 class="profile-name">Sarah Johnson</h3>
                                <div class="profile-location">
                                    <i class="bi bi-geo-alt me-1"></i> New York, NY
                                </div>
                                
                                <div class="profile-stats">
                                    <div class="stat-item">
                                        <div class="number">12</div>
                                        <div class="label">Jobs Posted</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">8</div>
                                        <div class="label">Hired</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">4.8</div>
                                        <div class="label">Rating</div>
                                    </div>
                                </div>
                                
                                <button class="btn btn-primary w-100">
                                    <i class="bi bi-pencil me-2"></i> Edit Profile
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Recent Job Postings</span>
                                    <i class="bi bi-file-earmark-text"></i>
                                </div>
                                
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Job Title</th>
                                                <th>Category</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Home Cleaning</td>
                                                <td>Cleaning</td>
                                                <td><span class="badge bg-warning">Pending</span></td>
                                                <td>Today</td>
                                            </tr>
                                            <tr>
                                                <td>Electrical Repair</td>
                                                <td>Electrical</td>
                                                <td><span class="badge bg-success">Completed</span></td>
                                                <td>2 days ago</td>
                                            </tr>
                                            <tr>
                                                <td>Plumbing Fix</td>
                                                <td>Plumbing</td>
                                                <td><span class="badge bg-info">In Progress</span></td>
                                                <td>5 days ago</td>
                                            </tr>
                                            <tr>
                                                <td>Math Tutoring</td>
                                                <td>Education</td>
                                                <td><span class="badge bg-success">Completed</span></td>
                                                <td>1 week ago</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Top Rated Workers</span>
                                    <i class="bi bi-star"></i>
                                </div>
                                
                                <div class="list-group">
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Worker" class="rounded-circle me-3" width="50" height="50">
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Michael Chen</div>
                                                <div class="d-flex align-items-center">
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                    <div class="ms-2 text-muted small">Electrician</div>
                                                </div>
                                            </div>
                                            <button class="btn btn-sm btn-outline-primary">Hire</button>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Worker" class="rounded-circle me-3" width="50" height="50">
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Emma Rodriguez</div>
                                                <div class="d-flex align-items-center">
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-half"></i>
                                                    </div>
                                                    <div class="ms-2 text-muted small">Cleaner</div>
                                                </div>
                                            </div>
                                            <button class="btn btn-sm btn-outline-primary">Hire</button>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="Worker" class="rounded-circle me-3" width="50" height="50">
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">David Wilson</div>
                                                <div class="d-flex align-items-center">
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star"></i>
                                                    </div>
                                                    <div class="ms-2 text-muted small">Plumber</div>
                                                </div>
                                            </div>
                                            <button class="btn btn-sm btn-outline-primary">Hire</button>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Worker" class="rounded-circle me-3" width="50" height="50">
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Sophia Kim</div>
                                                <div class="d-flex align-items-center">
                                                    <div class="stars">
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                        <i class="bi bi-star-fill"></i>
                                                    </div>
                                                    <div class="ms-2 text-muted small">Tutor</div>
                                                </div>
                                            </div>
                                            <button class="btn btn-sm btn-outline-primary">Hire</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Profile Section -->
                <div class="dashboard-section" id="profile">
                    <h3 class="mb-4">My Profile</h3>
                    
                    <div class="row">
                        <div class="col-md-4">
                            <div class="dashboard-card profile-card">
                                <div class="position-relative d-inline-block">
                                    <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Profile" class="profile-avatar">
                                    <div class="verification-badge">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                </div>
                                
                                <h3 class="profile-name">Sarah Johnson</h3>
                                <div class="profile-location">
                                    <i class="bi bi-geo-alt me-1"></i> New York, NY
                                </div>
                                
                                <div class="profile-stats">
                                    <div class="stat-item">
                                        <div class="number">12</div>
                                        <div class="label">Jobs Posted</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">8</div>
                                        <div class="label">Hired</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">4.8</div>
                                        <div class="label">Rating</div>
                                    </div>
                                </div>
                                
                                <button class="btn btn-primary w-100" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="bi bi-pencil me-2"></i> Edit Profile
                                </button>
                            </div>
                        </div>
                        
                        <div class="col-md-8">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Profile Information</span>
                                    <i class="bi bi-info-circle"></i>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Full Name</label>
                                            <input type="text" class="form-control" value="Sarah Johnson">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Email Address</label>
                                            <input type="email" class="form-control" value="sarah@example.com">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Phone Number</label>
                                            <input type="tel" class="form-control" value="+1 (555) 123-4567">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Location</label>
                                            <input type="text" class="form-control" value="New York, NY">
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="mb-3">
                                            <label class="form-label">About Me</label>
                                            <textarea class="form-control" rows="4">I'm a homeowner looking for reliable service professionals for various home improvement projects. I value quality work and punctuality.</textarea>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="d-flex justify-content-end">
                                    <button class="btn btn-primary">Save Changes</button>
                                </div>
                            </div>
                            
                            <div class="dashboard-card mt-4">
                                <div class="card-title">
                                    <span>Account Verification</span>
                                    <i class="bi bi-shield-check"></i>
                                </div>
                                
                                <div class="alert alert-success">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-check-circle-fill me-2 fs-4"></i>
                                        <div>
                                            <h5 class="mb-1">Your account is verified</h5>
                                            <p class="mb-0">ID verification completed on July 15, 2023</p>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="d-flex align-items-center">
                                    <div class="me-3">
                                        <img src="https://via.placeholder.com/150" alt="ID Photo" class="img-thumbnail" width="150">
                                    </div>
                                    <div>
                                        <p>Uploaded ID document for verification</p>
                                        <button class="btn btn-outline-secondary">Update ID Document</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Post Job Section -->
                <div class="dashboard-section" id="post-job">
                    <h3 class="mb-4">Post a New Job</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>Job Details</span>
                            <i class="bi bi-briefcase"></i>
                        </div>
                        
                        <form class="job-form">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Job Title <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" placeholder="e.g. Home Cleaning, Electrical Repair">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Job Category <span class="text-danger">*</span></label>
                                        <select class="form-select">
                                            <option value="">Select category</option>
                                            <option value="cleaning">Cleaning</option>
                                            <option value="electrical">Electrical</option>
                                            <option value="plumbing">Plumbing</option>
                                            <option value="carpentry">Carpentry</option>
                                            <option value="tutoring">Tutoring</option>
                                            <option value="gardening">Gardening</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Salary/Budget ($) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" placeholder="Enter amount">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Location <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" placeholder="Enter job location">
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label class="form-label">Job Description <span class="text-danger">*</span></label>
                                        <textarea class="form-control" placeholder="Describe the job in detail..." rows="5"></textarea>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label class="form-label">Job Photo</label>
                                        <input type="file" class="form-control">
                                        <div class="form-text">Upload a photo that represents the job (optional)</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-flex justify-content-end mt-4">
                                <button type="reset" class="btn btn-outline-secondary me-2">Reset</button>
                                <button type="submit" class="btn btn-primary">Post Job</button>
                            </div>
                        </form>
                    </div>
                    
                    <div class="dashboard-card mt-4">
                        <div class="card-title">
                            <span>AI Job Description Helper</span>
                            <i class="bi bi-robot"></i>
                        </div>
                        
                        <div class="alert alert-info">
                            <i class="bi bi-lightbulb me-2"></i> Use our AI assistant to help create a better job description
                        </div>
                        
                        <div class="row">
                            <div class="col-md-8">
                                <div class="mb-3">
                                    <label class="form-label">Brief Description</label>
                                    <textarea class="form-control" placeholder="Describe what you need in a few words..." rows="3"></textarea>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <button class="btn btn-primary w-100 h-100">
                                    <i class="bi bi-magic me-2"></i> Generate Description
                                </button>
                            </div>
                        </div>
                        
                        <div class="mt-3 p-3 bg-light rounded">
                            <h6>AI Generated Description:</h6>
                            <p class="mb-0">"Looking for a professional home cleaner to thoroughly clean a 3-bedroom apartment. The job includes vacuuming, mopping floors, cleaning bathrooms and kitchen, dusting surfaces, and taking out trash. Must have own cleaning supplies and transportation. Attention to detail is essential. The apartment is 1200 sq ft and should take approximately 4 hours to complete."</p>
                        </div>
                    </div>
                </div>
                
                <!-- Find Workers Section -->
                <div class="dashboard-section" id="workers">
                    <h3 class="mb-4">Find Skilled Workers</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>AI-Powered Worker Matching</span>
                            <i class="bi bi-robot"></i>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-9">
                                <div class="input-group mb-3">
                                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" placeholder="Search for workers by skill or location...">
                                    <button class="btn btn-primary">Search</button>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select">
                                    <option value="">All Categories</option>
                                    <option value="cleaning">Cleaning</option>
                                    <option value="electrical">Electrical</option>
                                    <option value="plumbing">Plumbing</option>
                                    <option value="carpentry">Carpentry</option>
                                    <option value="tutoring">Tutoring</option>
                                    <option value="gardening">Gardening</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="workers-grid">
                            <!-- Worker 1 -->
                            <div class="worker-card">
                                <div class="worker-header">
                                    <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Worker" class="worker-avatar">
                                    <div class="worker-name">Michael Chen</div>
                                    <div class="worker-category">Electrician</div>
                                </div>
                                <div class="worker-body">
                                    <div class="worker-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>2.1 miles away</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-briefcase"></i>
                                        <div>8 years experience</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-currency-dollar"></i>
                                        <div>$45 per hour</div>
                                    </div>
                                    
                                    <div class="worker-rating">
                                        <div class="stars">
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                        </div>
                                        <div class="rating-number">4.9 (128 reviews)</div>
                                    </div>
                                    
                                    <div class="ai-match-badge mb-3">
                                        <i class="bi bi-lightning"></i> 98% AI Match
                                    </div>
                                    
                                    <p class="mb-3">Licensed electrician specializing in residential repairs, installations, and safety inspections. Available for emergency services.</p>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary">
                                            <i class="bi bi-chat me-1"></i> Message
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-briefcase me-1"></i> Hire Now
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Worker 2 -->
                            <div class="worker-card">
                                <div class="worker-header">
                                    <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Worker" class="worker-avatar">
                                    <div class="worker-name">Emma Rodriguez</div>
                                    <div class="worker-category">Professional Cleaner</div>
                                </div>
                                <div class="worker-body">
                                    <div class="worker-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>1.5 miles away</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-briefcase"></i>
                                        <div>5 years experience</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-currency-dollar"></i>
                                        <div>$35 per hour</div>
                                    </div>
                                    
                                    <div class="worker-rating">
                                        <div class="stars">
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-half"></i>
                                        </div>
                                        <div class="rating-number">4.7 (94 reviews)</div>
                                    </div>
                                    
                                    <div class="ai-match-badge mb-3">
                                        <i class="bi bi-lightning"></i> 95% AI Match
                                    </div>
                                    
                                    <p class="mb-3">Professional cleaner with expertise in deep cleaning, move-in/move-out cleans, and regular maintenance. Eco-friendly products available.</p>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary">
                                            <i class="bi bi-chat me-1"></i> Message
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-briefcase me-1"></i> Hire Now
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Worker 3 -->
                            <div class="worker-card">
                                <div class="worker-header">
                                    <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="Worker" class="worker-avatar">
                                    <div class="worker-name">David Wilson</div>
                                    <div class="worker-category">Plumber</div>
                                </div>
                                <div class="worker-body">
                                    <div class="worker-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>3.2 miles away</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-briefcase"></i>
                                        <div>12 years experience</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-currency-dollar"></i>
                                        <div>$65 per hour</div>
                                    </div>
                                    
                                    <div class="worker-rating">
                                        <div class="stars">
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star"></i>
                                        </div>
                                        <div class="rating-number">4.2 (76 reviews)</div>
                                    </div>
                                    
                                    <div class="ai-match-badge mb-3">
                                        <i class="bi bi-lightning"></i> 92% AI Match
                                    </div>
                                    
                                    <p class="mb-3">Master plumber with expertise in pipe repairs, installations, water heater services, and emergency leak fixes. Licensed and insured.</p>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary">
                                            <i class="bi bi-chat me-1"></i> Message
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-briefcase me-1"></i> Hire Now
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Worker 4 -->
                            <div class="worker-card">
                                <div class="worker-header">
                                    <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Worker" class="worker-avatar">
                                    <div class="worker-name">Sophia Kim</div>
                                    <div class="worker-category">Math Tutor</div>
                                </div>
                                <div class="worker-body">
                                    <div class="worker-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>0.8 miles away</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-briefcase"></i>
                                        <div>6 years experience</div>
                                    </div>
                                    <div class="worker-info">
                                        <i class="bi bi-currency-dollar"></i>
                                        <div>$40 per hour</div>
                                    </div>
                                    
                                    <div class="worker-rating">
                                        <div class="stars">
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                            <i class="bi bi-star-fill"></i>
                                        </div>
                                        <div class="rating-number">5.0 (63 reviews)</div>
                                    </div>
                                    
                                    <div class="ai-match-badge mb-3">
                                        <i class="bi bi-lightning"></i> 97% AI Match
                                    </div>
                                    
                                    <p class="mb-3">Certified math teacher specializing in algebra, calculus, and test preparation. Experience with high school and college students.</p>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary">
                                            <i class="bi bi-chat me-1"></i> Message
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-briefcase me-1"></i> Hire Now
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Chat Section -->
                <div class="dashboard-section" id="chat">
                    <h3 class="mb-4">Messages</h3>
                    
                    <div class="chat-container">
                        <div class="chat-sidebar">
                            <div class="chat-header">Conversations</div>
                            
                            <div class="chat-contact active">
                                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Michael" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Michael Chen</div>
                                    <div class="text-muted small">Electrician</div>
                                </div>
                                <span class="badge bg-primary ms-auto">3</span>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Emma" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Emma Rodriguez</div>
                                    <div class="text-muted small">Cleaner</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">David Wilson</div>
                                    <div class="text-muted small">Plumber</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Sophia Kim</div>
                                    <div class="text-muted small">Math Tutor</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Robert" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Robert Johnson</div>
                                    <div class="text-muted small">Carpenter</div>
                                </div>
                                <span class="badge bg-primary ms-auto">1</span>
                            </div>
                        </div>
                        
                        <div class="chat-main">
                            <div class="chat-header d-flex align-items-center">
                                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Michael" class="chat-contact-avatar me-2">
                                <div>
                                    <div class="fw-bold">Michael Chen</div>
                                    <div class="text-muted small">Online now</div>
                                </div>
                                <div class="ms-auto">
                                    <button class="btn btn-sm btn-outline-secondary">
                                        <i class="bi bi-telephone"></i>
                                    </button>
                                    <button class="btn btn-sm btn-outline-secondary ms-2">
                                        <i class="bi bi-three-dots"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="chat-messages">
                                <div class="message received">
                                    Hi Sarah, I saw your job posting for electrical repair. Can you tell me more about what needs to be fixed?
                                    <span class="message-time">10:24 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    Hi Michael! Thanks for reaching out. I have several outlets in the kitchen that stopped working suddenly. Also, one of the light switches is sparking.
                                    <span class="message-time">10:26 AM</span>
                                </div>
                                
                                <div class="message received">
                                    I see. That sounds like it could be a circuit issue. When would be a good time for me to come take a look?
                                    <span class="message-time">10:28 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    Would tomorrow afternoon work? Anytime after 2pm?
                                    <span class="message-time">10:29 AM</span>
                                </div>
                                
                                <div class="message received">
                                    Tomorrow at 2:30pm works perfectly for me. Can you send me your address?
                                    <span class="message-time">10:30 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    Great! I'll send the address through the app. Looking forward to meeting you.
                                    <span class="message-time">10:31 AM</span>
                                </div>
                                
                                <div class="message received">
                                    Likewise! I'll bring all necessary tools. See you tomorrow.
                                    <span class="message-time">10:32 AM</span>
                                </div>
                            </div>
                            
                            <div class="chat-input">
                                <input type="text" placeholder="Type your message...">
                                <button>
                                    <i class="bi bi-send"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Reviews Section -->
                <div class="dashboard-section" id="reviews">
                    <h3 class="mb-4">Leave a Review</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>Completed Jobs</span>
                            <i class="bi bi-check-circle"></i>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Job Title</th>
                                        <th>Worker</th>
                                        <th>Completed Date</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Kitchen Electrical Repair</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Michael" class="rounded-circle me-2" width="30" height="30">
                                                Michael Chen
                                            </div>
                                        </td>
                                        <td>July 15, 2023</td>
                                        <td><span class="badge bg-success">Completed</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#reviewModal">
                                                Leave Review
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Bathroom Plumbing Fix</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="rounded-circle me-2" width="30" height="30">
                                                David Wilson
                                            </div>
                                        </td>
                                        <td>July 10, 2023</td>
                                        <td><span class="badge bg-success">Completed</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#reviewModal">
                                                Leave Review
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Deep Home Cleaning</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Emma" class="rounded-circle me-2" width="30" height="30">
                                                Emma Rodriguez
                                            </div>
                                        </td>
                                        <td>July 5, 2023</td>
                                        <td><span class="badge bg-success">Completed</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#reviewModal">
                                                Leave Review
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Algebra Tutoring</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="rounded-circle me-2" width="30" height="30">
                                                Sophia Kim
                                            </div>
                                        </td>
                                        <td>June 28, 2023</td>
                                        <td><span class="badge bg-success">Completed</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-secondary" disabled>
                                                Reviewed
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <div class="dashboard-card mt-4">
                        <div class="card-title">
                            <span>Your Recent Reviews</span>
                            <i class="bi bi-star"></i>
                        </div>
                        
                        <div class="review-card">
                            <div class="review-header">
                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="review-avatar">
                                <div class="review-meta">
                                    <div class="review-name">Sophia Kim</div>
                                    <div class="review-job">Math Tutor</div>
                                </div>
                                <div class="review-stars">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                </div>
                            </div>
                            <div class="review-content">
                                Sophia was an excellent tutor for my daughter who was struggling with algebra. She explained concepts clearly, was patient, and provided helpful resources. My daughter's grade improved from a C to an A in just two months. Highly recommend!
                            </div>
                            <div class="text-muted small mt-2">Posted on June 30, 2023</div>
                        </div>
                        
                        <div class="review-card">
                            <div class="review-header">
                                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Robert" class="review-avatar">
                                <div class="review-meta">
                                    <div class="review-name">Robert Johnson</div>
                                    <div class="review-job">Carpenter</div>
                                </div>
                                <div class="review-stars">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star"></i>
                                </div>
                            </div>
                            <div class="review-content">
                                Robert built custom bookshelves for my home office. The craftsmanship is excellent and he completed the job on time. The only reason for 4 stars instead of 5 is that the project went slightly over budget. Overall a good experience and I'm happy with the final result.
                            </div>
                            <div class="text-muted small mt-2">Posted on June 15, 2023</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Upload ID Modal -->
    <div class="modal fade" id="uploadIdModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Upload ID for Verification</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i> Please upload a clear photo of your government-issued ID for verification.
                    </div>
                    
                    <div class="mb-4 text-center">
                        <div class="border rounded p-4 mb-3" style="cursor: pointer; border-style: dashed !important;">
                            <i class="bi bi-cloud-arrow-up fs-1 text-primary"></i>
                            <h5>Click to upload ID photo</h5>
                            <p class="text-muted mb-0">JPG, PNG or PDF (Max 5MB)</p>
                        </div>
                        <input type="file" class="d-none">
                    </div>
                    
                    <div class="form-check mb-3">
                        <input class="form-check-input" type="checkbox" id="idConsent">
                        <label class="form-check-label" for="idConsent">
                            I consent to SkillLink using my ID solely for verification purposes
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Upload ID</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Review Modal -->
    <div class="modal fade" id="reviewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Leave a Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="d-flex align-items-center mb-4">
                        <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Michael" class="rounded-circle me-3" width="60" height="60">
                        <div>
                            <h5 class="mb-0">Michael Chen</h5>
                            <p class="text-muted mb-0">Electrician - Kitchen Electrical Repair</p>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">Overall Rating</label>
                        <div class="d-flex align-items-center">
                            <div class="rating">
                                <input type="radio" id="star5" name="rating" value="5">
                                <label for="star5"><i class="bi bi-star-fill fs-2"></i></label>
                                <input type="radio" id="star4" name="rating" value="4">
                                <label for="star4"><i class="bi bi-star-fill fs-2"></i></label>
                                <input type="radio" id="star3" name="rating" value="3" checked>
                                <label for="star3"><i class="bi bi-star-fill fs-2"></i></label>
                                <input type="radio" id="star2" name="rating" value="2">
                                <label for="star2"><i class="bi bi-star-fill fs-2"></i></label>
                                <input type="radio" id="star1" name="rating" value="1">
                                <label for="star1"><i class="bi bi-star-fill fs-2"></i></label>
                            </div>
                            <span class="ms-3 fs-5 fw-bold">3.0</span>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Review Title</label>
                        <input type="text" class="form-control" placeholder="Summarize your experience">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Detailed Review</label>
                        <textarea class="form-control" rows="5" placeholder="Describe your experience with this worker..."></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Would you hire this worker again?</label>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="hireAgain" id="hireYes" value="yes">
                            <label class="form-check-label" for="hireYes">Yes, definitely</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="hireAgain" id="hireMaybe" value="maybe">
                            <label class="form-check-label" for="hireMaybe">Maybe</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="hireAgain" id="hireNo" value="no">
                            <label class="form-check-label" for="hireNo">No</label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Submit Review</button>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Sidebar navigation
        document.querySelectorAll('.sidebar-item').forEach(item => {
            item.addEventListener('click', function() {
                // Remove active class from all items
                document.querySelectorAll('.sidebar-item').forEach(i => {
                    i.classList.remove('active');
                });
                
                // Add active class to clicked item
                this.classList.add('active');
                
                // Hide all sections
                document.querySelectorAll('.dashboard-section').forEach(section => {
                    section.classList.remove('active');
                });
                
                // Show target section
                const target = this.getAttribute('data-target');
                document.getElementById(target).classList.add('active');
            });
        });
        
        // Star rating for review modal
        const stars = document.querySelectorAll('.rating input');
        stars.forEach(star => {
            star.addEventListener('change', function() {
                const ratingValue = this.value;
                document.querySelector('.rating + span').textContent = ratingValue + '.0';
            });
        });
        
        // Simulate verification status change
        document.querySelector('.verification-banner button').addEventListener('click', function() {
            this.closest('.verification-banner').classList.add('verified');
            this.closest('.verification-banner').innerHTML = `
                <div class="d-flex align-items-center">
                    <i class="bi bi-shield-check"></i>
                    <div>
                        <h5 class="mb-1">Account Verified</h5>
                        <p class="mb-0">Your account has been successfully verified</p>
                    </div>
                </div>
            `;
        });
    </script>
</body>
</html>