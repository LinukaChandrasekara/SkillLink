<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Worker Dashboard - SkillLink</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Reuse the same CSS styles from client dashboard */
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
        
        /* Job Cards */
        .job-card {
            background-color: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }
        
        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }
        
        .job-header {
            padding: 20px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            color: white;
        }
        
        .job-title {
            font-size: 1.2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .job-category {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .job-body {
            padding: 20px;
        }
        
        .job-info {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        
        .job-info i {
            color: var(--primary-color);
            margin-right: 10px;
            width: 20px;
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
            margin-bottom: 15px;
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
        
        /* Job Grid */
        .jobs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        /* Skill Tags */
        .skill-tag {
            display: inline-block;
            background-color: #e9ecef;
            color: #495057;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            margin-right: 5px;
            margin-bottom: 5px;
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
                
                <div class="sidebar-item" data-target="jobs">
                    <i class="bi bi-briefcase"></i>
                    <span>Available Jobs</span>
                </div>
                
                <div class="sidebar-item" data-target="my-jobs">
                    <i class="bi bi-list-check"></i>
                    <span>My Jobs</span>
                </div>
                
                <div class="sidebar-item" data-target="chat">
                    <i class="bi bi-chat-dots"></i>
                    <span>Messages</span>
                    <span class="notification-badge">3</span>
                </div>
                
                <div class="sidebar-item" data-target="reviews">
                    <i class="bi bi-star"></i>
                    <span>My Reviews</span>
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
                    <input type="text" class="form-control" placeholder="Search jobs...">
                </div>
                
                <div class="user-info">
                    <div class="notification-icon position-relative me-4">
                        <i class="bi bi-bell fs-5"></i>
                        <span class="notification-badge">5</span>
                    </div>
                    
                    <div class="d-flex align-items-center">
                        <img src="https://randomuser.me/api/portraits/men/42.jpg" alt="User" class="user-avatar">
                        <div>
                            <div class="fw-bold">John Smith</div>
                            <div class="text-muted small">Electrician</div>
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
                                                <div class="fw-bold">New Job Match</div>
                                                <div class="text-muted small">You've been matched with a new electrical repair job</div>
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
                                                <div class="text-muted small">Your electrical repair job was completed successfully</div>
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
                                                <div class="text-muted small">You received a message from Sarah</div>
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
                                                <div class="fw-bold">New Review</div>
                                                <div class="text-muted small">Sarah rated your work 5 stars</div>
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
                                    <img src="https://randomuser.me/api/portraits/men/42.jpg" alt="Profile" class="profile-avatar">
                                    <div class="verification-badge">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                </div>
                                
                                <h3 class="profile-name">John Smith</h3>
                                <div class="profile-location">
                                    <i class="bi bi-geo-alt me-1"></i> New York, NY
                                </div>
                                
                                <div class="profile-stats">
                                    <div class="stat-item">
                                        <div class="number">24</div>
                                        <div class="label">Jobs Done</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">4.8</div>
                                        <div class="label">Rating</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">5</div>
                                        <div class="label">Active Jobs</div>
                                    </div>
                                </div>
                                
                                <button class="btn btn-primary w-100" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="bi bi-pencil me-2"></i> Edit Profile
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Recent Job Offers</span>
                                    <i class="bi bi-briefcase"></i>
                                </div>
                                
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Job Title</th>
                                                <th>Client</th>
                                                <th>Status</th>
                                                <th>Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Kitchen Wiring</td>
                                                <td>Sarah Johnson</td>
                                                <td><span class="badge bg-warning">Pending</span></td>
                                                <td>Today</td>
                                            </tr>
                                            <tr>
                                                <td>Outlet Installation</td>
                                                <td>Michael Brown</td>
                                                <td><span class="badge bg-success">Completed</span></td>
                                                <td>2 days ago</td>
                                            </tr>
                                            <tr>
                                                <td>Light Fixture Repair</td>
                                                <td>Emma Davis</td>
                                                <td><span class="badge bg-info">In Progress</span></td>
                                                <td>5 days ago</td>
                                            </tr>
                                            <tr>
                                                <td>Circuit Panel Check</td>
                                                <td>David Wilson</td>
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
                                    <span>Skill Demand</span>
                                    <i class="bi bi-graph-up"></i>
                                </div>
                                
                                <div class="p-3">
                                    <h5>Top In-Demand Skills in Your Area</h5>
                                    <div class="mt-3">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Electrical Repairs</span>
                                            <span>85% match</span>
                                        </div>
                                        <div class="progress" style="height: 10px;">
                                            <div class="progress-bar bg-primary" style="width: 85%"></div>
                                        </div>
                                        
                                        <div class="d-flex justify-content-between mb-2 mt-3">
                                            <span>Smart Home Installation</span>
                                            <span>72% match</span>
                                        </div>
                                        <div class="progress" style="height: 10px;">
                                            <div class="progress-bar bg-primary" style="width: 72%"></div>
                                        </div>
                                        
                                        <div class="d-flex justify-content-between mb-2 mt-3">
                                            <span>Emergency Electrical</span>
                                            <span>68% match</span>
                                        </div>
                                        <div class="progress" style="height: 10px;">
                                            <div class="progress-bar bg-primary" style="width: 68%"></div>
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
                                    <img src="https://randomuser.me/api/portraits/men/42.jpg" alt="Profile" class="profile-avatar">
                                    <div class="verification-badge">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                </div>
                                
                                <h3 class="profile-name">John Smith</h3>
                                <div class="profile-location">
                                    <i class="bi bi-geo-alt me-1"></i> New York, NY
                                </div>
                                
                                <div class="profile-stats">
                                    <div class="stat-item">
                                        <div class="number">24</div>
                                        <div class="label">Jobs Done</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">4.8</div>
                                        <div class="label">Rating</div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="number">5</div>
                                        <div class="label">Active Jobs</div>
                                    </div>
                                </div>
                                
                                <button class="btn btn-primary w-100" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                    <i class="bi bi-pencil me-2"></i> Edit Profile
                                </button>
                            </div>
                            
                            <div class="dashboard-card mt-4">
                                <div class="card-title">
                                    <span>My Skills</span>
                                    <i class="bi bi-tools"></i>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="skill-tag">Electrical Repairs</div>
                                    <div class="skill-tag">Wiring Installation</div>
                                    <div class="skill-tag">Circuit Breakers</div>
                                    <div class="skill-tag">Lighting Installation</div>
                                    <div class="skill-tag">Smart Home Setup</div>
                                    <div class="skill-tag">Emergency Services</div>
                                </div>
                                
                                <button class="btn btn-outline-primary w-100">
                                    <i class="bi bi-plus me-2"></i> Add Skills
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
                                            <input type="text" class="form-control" value="John Smith">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Email Address</label>
                                            <input type="email" class="form-control" value="john@example.com">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Phone Number</label>
                                            <input type="tel" class="form-control" value="+1 (555) 987-6543">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Location</label>
                                            <input type="text" class="form-control" value="New York, NY">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Profession</label>
                                            <input type="text" class="form-control" value="Electrician">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label">Years of Experience</label>
                                            <input type="number" class="form-control" value="8">
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="mb-3">
                                            <label class="form-label">About Me</label>
                                            <textarea class="form-control" rows="4">Licensed electrician with 8 years of experience in residential and commercial electrical work. Specializing in wiring, lighting installation, and emergency repairs. Fully insured and certified.</textarea>
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
                                            <p class="mb-0">ID verification completed on July 10, 2023</p>
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
                
                <!-- Available Jobs Section -->
                <div class="dashboard-section" id="jobs">
                    <h3 class="mb-4">Available Jobs</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>AI-Powered Job Matching</span>
                            <i class="bi bi-robot"></i>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-9">
                                <div class="input-group mb-3">
                                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                                    <input type="text" class="form-control" placeholder="Search for jobs by title or location...">
                                    <button class="btn btn-primary">Search</button>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select class="form-select">
                                    <option value="">All Categories</option>
                                    <option value="cleaning">Cleaning</option>
                                    <option value="electrical" selected>Electrical</option>
                                    <option value="plumbing">Plumbing</option>
                                    <option value="carpentry">Carpentry</option>
                                    <option value="tutoring">Tutoring</option>
                                    <option value="gardening">Gardening</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="jobs-grid">
                            <!-- Job 1 -->
                            <div class="job-card">
                                <div class="job-header">
                                    <div class="job-title">Kitchen Electrical Repair</div>
                                    <div class="job-category">Electrical</div>
                                </div>
                                <div class="job-body">
                                    <div class="ai-match-badge">
                                        <i class="bi bi-lightning"></i> 98% AI Match
                                    </div>
                                    
                                    <div class="job-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>2.1 miles away - Manhattan, NY</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-cash"></i>
                                        <div>$250 fixed price</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-calendar"></i>
                                        <div>Needs to be done by July 25, 2023</div>
                                    </div>
                                    
                                    <p class="mb-3">Several outlets in the kitchen stopped working suddenly. Need an electrician to diagnose and fix the issue. One of the light switches is also sparking occasionally.</p>
                                    
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="d-flex align-items-center">
                                            <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Client" class="rounded-circle me-2" width="30" height="30">
                                            <div>
                                                <div class="fw-bold">Sarah Johnson</div>
                                                <div class="text-muted small">4.8 rating (12 reviews)</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary">
                                            <i class="bi bi-chat me-1"></i> Message Client
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-briefcase me-1"></i> Apply for Job
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Job 2 -->
                            <div class="job-card">
                                <div class="job-header">
                                    <div class="job-title">Smart Light Installation</div>
                                    <div class="job-category">Electrical</div>
                                </div>
                                <div class="job-body">
                                    <div class="ai-match-badge">
                                        <i class="bi bi-lightning"></i> 92% AI Match
                                    </div>
                                    
                                    <div class="job-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>3.5 miles away - Brooklyn, NY</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-cash"></i>
                                        <div>$45 per hour</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-calendar"></i>
                                        <div>Flexible schedule</div>
                                    </div>
                                    
                                    <p class="mb-3">Need help installing 8 smart light fixtures throughout my apartment. I already purchased the lights but need professional installation and setup with my home automation system.</p>
                                    
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="d-flex align-items-center">
                                            <img src="https://randomuser.me/api/portraits/men/22.jpg" alt="Client" class="rounded-circle me-2" width="30" height="30">
                                            <div>
                                                <div class="fw-bold">Michael Brown</div>
                                                <div class="text-muted small">4.5 rating (8 reviews)</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary">
                                            <i class="bi bi-chat me-1"></i> Message Client
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-briefcase me-1"></i> Apply for Job
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Job 3 -->
                            <div class="job-card">
                                <div class="job-header">
                                    <div class="job-title">Emergency Circuit Panel Repair</div>
                                    <div class="job-category">Electrical</div>
                                </div>
                                <div class="job-body">
                                    <div class="ai-match-badge">
                                        <i class="bi bi-lightning"></i> 95% AI Match
                                    </div>
                                    
                                    <div class="job-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>1.2 miles away - Queens, NY</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-cash"></i>
                                        <div>$85 per hour (emergency rate)</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-calendar"></i>
                                        <div>ASAP - Today if possible</div>
                                    </div>
                                    
                                    <p class="mb-3">Circuit breaker keeps tripping and won't stay reset. Need an emergency electrician to diagnose and fix the issue. Some rooms have no power at all.</p>
                                    
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="d-flex align-items-center">
                                            <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Client" class="rounded-circle me-2" width="30" height="30">
                                            <div>
                                                <div class="fw-bold">Emma Davis</div>
                                                <div class="text-muted small">New client</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-primary">
                                            <i class="bi bi-chat me-1"></i> Message Client
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-briefcase me-1"></i> Apply for Job
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- My Jobs Section -->
                <div class="dashboard-section" id="my-jobs">
                    <h3 class="mb-4">My Jobs</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>Current Jobs</span>
                            <i class="bi bi-list-check"></i>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Job Title</th>
                                        <th>Client</th>
                                        <th>Start Date</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Kitchen Wiring</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Sarah" class="rounded-circle me-2" width="30" height="30">
                                                Sarah Johnson
                                            </div>
                                        </td>
                                        <td>July 18, 2023</td>
                                        <td><span class="badge bg-info">In Progress</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary">View Details</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Light Fixture Repair</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Emma" class="rounded-circle me-2" width="30" height="30">
                                                Emma Davis
                                            </div>
                                        </td>
                                        <td>July 15, 2023</td>
                                        <td><span class="badge bg-info">In Progress</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary">View Details</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Outlet Installation</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/22.jpg" alt="Michael" class="rounded-circle me-2" width="30" height="30">
                                                Michael Brown
                                            </div>
                                        </td>
                                        <td>July 12, 2023</td>
                                        <td><span class="badge bg-warning">Pending Approval</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary">View Details</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <div class="dashboard-card mt-4">
                        <div class="card-title">
                            <span>Completed Jobs</span>
                            <i class="bi bi-check-circle"></i>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Job Title</th>
                                        <th>Client</th>
                                        <th>Completed Date</th>
                                        <th>Rating</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Circuit Panel Check</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="rounded-circle me-2" width="30" height="30">
                                                David Wilson
                                            </div>
                                        </td>
                                        <td>July 10, 2023</td>
                                        <td>
                                            <div class="stars">
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                            </div>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-secondary">View Details</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Emergency Electrical Repair</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="rounded-circle me-2" width="30" height="30">
                                                Sophia Kim
                                            </div>
                                        </td>
                                        <td>July 5, 2023</td>
                                        <td>
                                            <div class="stars">
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-half text-warning"></i>
                                            </div>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-secondary">View Details</button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Wiring Inspection</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Robert" class="rounded-circle me-2" width="30" height="30">
                                                Robert Johnson
                                            </div>
                                        </td>
                                        <td>June 28, 2023</td>
                                        <td>
                                            <div class="stars">
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                                <i class="bi bi-star-fill text-warning"></i>
                                            </div>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-secondary">View Details</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
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
                                <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Sarah" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Sarah Johnson</div>
                                    <div class="text-muted small">Kitchen Wiring</div>
                                </div>
                                <span class="badge bg-primary ms-auto">3</span>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Emma" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Emma Davis</div>
                                    <div class="text-muted small">Light Fixture Repair</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/men/22.jpg" alt="Michael" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Michael Brown</div>
                                    <div class="text-muted small">Outlet Installation</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">David Wilson</div>
                                    <div class="text-muted small">Circuit Panel Check</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Sophia Kim</div>
                                    <div class="text-muted small">Emergency Repair</div>
                                </div>
                                <span class="badge bg-primary ms-auto">1</span>
                            </div>
                        </div>
                        
                        <div class="chat-main">
                            <div class="chat-header d-flex align-items-center">
                                <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Sarah" class="chat-contact-avatar me-2">
                                <div>
                                    <div class="fw-bold">Sarah Johnson</div>
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
                                    Hi John, thanks for accepting my job request for the kitchen wiring. When can you start?
                                    <span class="message-time">10:24 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    Hi Sarah! I can start tomorrow afternoon if that works for you.
                                    <span class="message-time">10:26 AM</span>
                                </div>
                                
                                <div class="message received">
                                    Tomorrow afternoon would be perfect. What time exactly?
                                    <span class="message-time">10:28 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    How about 2:30pm? I'll need about 3 hours to complete the work.
                                    <span class="message-time">10:29 AM</span>
                                </div>
                                
                                <div class="message received">
                                    That works for me. Do you need me to purchase any materials beforehand?
                                    <span class="message-time">10:30 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    I'll bring all the necessary wiring and tools. Just need access to your circuit panel.
                                    <span class="message-time">10:31 AM</span>
                                </div>
                                
                                <div class="message received">
                                    Great! I'll make sure the panel is accessible. See you tomorrow at 2:30pm.
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
                    <h3 class="mb-4">My Reviews</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>Client Reviews</span>
                            <i class="bi bi-star"></i>
                        </div>
                        
                        <div class="review-card">
                            <div class="review-header">
                                <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Sarah" class="review-avatar">
                                <div class="review-meta">
                                    <div class="review-name">Sarah Johnson</div>
                                    <div class="review-job">Kitchen Wiring</div>
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
                                John did an excellent job fixing our kitchen wiring issues. He was punctual, professional, and explained everything clearly. The work was completed efficiently and everything works perfectly now. Highly recommend!
                            </div>
                            <div class="text-muted small mt-2">Posted on July 12, 2023</div>
                        </div>
                        
                        <div class="review-card">
                            <div class="review-header">
                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="review-avatar">
                                <div class="review-meta">
                                    <div class="review-name">David Wilson</div>
                                    <div class="review-job">Circuit Panel Check</div>
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
                                Outstanding service! John identified the issue with our circuit panel quickly and fixed it at a reasonable price. He even took the time to explain how to prevent similar issues in the future. Will definitely hire again for any electrical needs.
                            </div>
                            <div class="text-muted small mt-2">Posted on July 10, 2023</div>
                        </div>
                        
                        <div class="review-card">
                            <div class="review-header">
                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="review-avatar">
                                <div class="review-meta">
                                    <div class="review-name">Sophia Kim</div>
                                    <div class="review-job">Emergency Electrical Repair</div>
                                </div>
                                <div class="review-stars">
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-fill"></i>
                                    <i class="bi bi-star-half"></i>
                                </div>
                            </div>
                            <div class="review-content">
                                John responded quickly to our emergency call when our circuit panel failed. He arrived within 2 hours and fixed the issue professionally. The only reason for 4.5 stars instead of 5 is that the final cost was slightly higher than initially estimated, but the quality of work was excellent.
                            </div>
                            <div class="text-muted small mt-2">Posted on July 5, 2023</div>
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
    
    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Profile</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">First Name</label>
                                    <input type="text" class="form-control" placeholder="First name">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Last Name</label>
                                    <input type="text" class="form-control" placeholder="Last name">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" placeholder="Email address">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" placeholder="Phone number">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Profession</label>
                                    <input type="text" class="form-control" placeholder="Your profession">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Years of Experience</label>
                                    <input type="number" class="form-control" placeholder="Years of experience">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="mb-3">
                                    <label class="form-label">Location</label>
                                    <input type="text" class="form-control" placeholder="Your location">
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="mb-3">
                                    <label class="form-label">About Me</label>
                                    <textarea class="form-control" rows="4" placeholder="Describe your skills and experience"></textarea>
                                </div>
                            </div>
                            <div class="col-md-12">
                                <div class="mb-3">
                                    <label class="form-label">Profile Picture</label>
                                    <input type="file" class="form-control">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Save Changes</button>
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