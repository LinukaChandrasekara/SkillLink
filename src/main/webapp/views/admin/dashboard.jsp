<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SkillLink</title>
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
        
        /* Verification Requests */
        .verification-request {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .verification-request:hover {
            background-color: #f8f9fa;
        }
        
        /* Analytics Charts */
        .chart-container {
            height: 300px;
            width: 100%;
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
                
                <div class="sidebar-item" data-target="users">
                    <i class="bi bi-people"></i>
                    <span>Manage Users</span>
                </div>
                
                <div class="sidebar-item" data-target="verifications">
                    <i class="bi bi-shield-check"></i>
                    <span>Verifications</span>
                    <span class="notification-badge">5</span>
                </div>
                
                <div class="sidebar-item" data-target="jobs">
                    <i class="bi bi-briefcase"></i>
                    <span>Job Approvals</span>
                    <span class="notification-badge">3</span>
                </div>
                
                <div class="sidebar-item" data-target="chat">
                    <i class="bi bi-chat-dots"></i>
                    <span>Messages</span>
                    <span class="notification-badge">2</span>
                </div>
                
                <div class="sidebar-item" data-target="analytics">
                    <i class="bi bi-graph-up"></i>
                    <span>Analytics</span>
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
                        <img src="https://randomuser.me/api/portraits/men/75.jpg" alt="User" class="user-avatar">
                        <div>
                            <div class="fw-bold">Admin User</div>
                            <div class="text-muted small">Administrator</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Content Area -->
            <div class="content-area">
                <!-- Dashboard Overview -->
                <div class="dashboard-section active" id="dashboard">
                    <h3 class="mb-4">Admin Dashboard</h3>
                    
                    <div class="row">
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="stat-number">1,245</div>
                                <div class="stat-label">Total Users</div>
                                <div class="progress mt-2" style="height: 6px;">
                                    <div class="progress-bar bg-primary" style="width: 75%"></div>
                                </div>
                                <div class="text-muted small mt-1">+12% from last month</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="stat-number">856</div>
                                <div class="stat-label">Verified Workers</div>
                                <div class="progress mt-2" style="height: 6px;">
                                    <div class="progress-bar bg-success" style="width: 65%"></div>
                                </div>
                                <div class="text-muted small mt-1">+8% from last month</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="stat-number">389</div>
                                <div class="stat-label">Clients</div>
                                <div class="progress mt-2" style="height: 6px;">
                                    <div class="progress-bar bg-info" style="width: 45%"></div>
                                </div>
                                <div class="text-muted small mt-1">+5% from last month</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="dashboard-card">
                                <div class="stat-number">243</div>
                                <div class="stat-label">Pending Jobs</div>
                                <div class="progress mt-2" style="height: 6px;">
                                    <div class="progress-bar bg-warning" style="width: 30%"></div>
                                </div>
                                <div class="text-muted small mt-1">+15% from last month</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
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
                                                <i class="bi bi-person-plus text-primary"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">New User Registration</div>
                                                <div class="text-muted small">Michael Brown registered as a worker</div>
                                            </div>
                                            <div class="text-muted small">2 hours ago</div>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-success bg-opacity-10 p-2 rounded-circle me-3">
                                                <i class="bi bi-shield-check text-success"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Account Verified</div>
                                                <div class="text-muted small">Sarah Johnson's account was verified</div>
                                            </div>
                                            <div class="text-muted small">1 day ago</div>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-info bg-opacity-10 p-2 rounded-circle me-3">
                                                <i class="bi bi-briefcase text-info"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">Job Approved</div>
                                                <div class="text-muted small">"Home Cleaning" job was published</div>
                                            </div>
                                            <div class="text-muted small">2 days ago</div>
                                        </div>
                                    </div>
                                    
                                    <div class="list-group-item border-0 py-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-warning bg-opacity-10 p-2 rounded-circle me-3">
                                                <i class="bi bi-chat-dots text-warning"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="fw-bold">New Message</div>
                                                <div class="text-muted small">Support request from David Wilson</div>
                                            </div>
                                            <div class="text-muted small">3 days ago</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Quick Actions</span>
                                    <i class="bi bi-lightning"></i>
                                </div>
                                
                                <div class="d-grid gap-2">
                                    <button class="btn btn-outline-primary text-start">
                                        <i class="bi bi-shield-check me-2"></i> Review Verifications
                                    </button>
                                    <button class="btn btn-outline-primary text-start">
                                        <i class="bi bi-briefcase me-2"></i> Approve Jobs
                                    </button>
                                    <button class="btn btn-outline-primary text-start">
                                        <i class="bi bi-person-plus me-2"></i> Add New User
                                    </button>
                                    <button class="btn btn-outline-primary text-start">
                                        <i class="bi bi-graph-up me-2"></i> View Analytics
                                    </button>
                                    <button class="btn btn-outline-primary text-start">
                                        <i class="bi bi-chat-dots me-2"></i> Check Messages
                                    </button>
                                </div>
                            </div>
                            
                            <div class="dashboard-card mt-4">
                                <div class="card-title">
                                    <span>System Status</span>
                                    <i class="bi bi-server"></i>
                                </div>
                                
                                <div class="alert alert-success">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-check-circle-fill me-2"></i>
                                        <div>All systems operational</div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Database</span>
                                        <span>78%</span>
                                    </div>
                                    <div class="progress" style="height: 6px;">
                                        <div class="progress-bar bg-success" style="width: 78%"></div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Storage</span>
                                        <span>45%</span>
                                    </div>
                                    <div class="progress" style="height: 6px;">
                                        <div class="progress-bar bg-info" style="width: 45%"></div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <div class="d-flex justify-content-between mb-1">
                                        <span>Memory</span>
                                        <span>62%</span>
                                    </div>
                                    <div class="progress" style="height: 6px;">
                                        <div class="progress-bar bg-warning" style="width: 62%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Manage Users Section -->
                <div class="dashboard-section" id="users">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="mb-0">Manage Users</h3>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="bi bi-plus me-2"></i> Add User
                        </button>
                    </div>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>All Users</span>
                            <div class="input-group" style="width: 300px;">
                                <input type="text" class="form-control" placeholder="Search users...">
                                <button class="btn btn-outline-secondary" type="button">
                                    <i class="bi bi-search"></i>
                                </button>
                            </div>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Email</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Joined</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1001</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/42.jpg" alt="John" class="rounded-circle me-2" width="30" height="30">
                                                John Smith
                                            </div>
                                        </td>
                                        <td>john@example.com</td>
                                        <td><span class="badge bg-primary">Worker</span></td>
                                        <td><span class="badge bg-success">Verified</span></td>
                                        <td>Jun 15, 2023</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>1002</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Sarah" class="rounded-circle me-2" width="30" height="30">
                                                Sarah Johnson
                                            </div>
                                        </td>
                                        <td>sarah@example.com</td>
                                        <td><span class="badge bg-info">Client</span></td>
                                        <td><span class="badge bg-success">Verified</span></td>
                                        <td>Jun 20, 2023</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>1003</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/22.jpg" alt="Michael" class="rounded-circle me-2" width="30" height="30">
                                                Michael Brown
                                            </div>
                                        </td>
                                        <td>michael@example.com</td>
                                        <td><span class="badge bg-primary">Worker</span></td>
                                        <td><span class="badge bg-warning">Pending</span></td>
                                        <td>Jul 5, 2023</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>1004</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Emma" class="rounded-circle me-2" width="30" height="30">
                                                Emma Rodriguez
                                            </div>
                                        </td>
                                        <td>emma@example.com</td>
                                        <td><span class="badge bg-primary">Worker</span></td>
                                        <td><span class="badge bg-success">Verified</span></td>
                                        <td>Jul 10, 2023</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>1005</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="rounded-circle me-2" width="30" height="30">
                                                David Wilson
                                            </div>
                                        </td>
                                        <td>david@example.com</td>
                                        <td><span class="badge bg-info">Client</span></td>
                                        <td><span class="badge bg-danger">Suspended</span></td>
                                        <td>Jul 12, 2023</td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-primary me-1">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-secondary me-1">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        
                        <nav class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
                
                <!-- Verifications Section -->
                <div class="dashboard-section" id="verifications">
                    <h3 class="mb-4">Verification Requests</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>Pending Verifications</span>
                            <span class="badge bg-warning">5 new</span>
                        </div>
                        
                        <div class="list-group">
                            <div class="verification-request">
                                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Michael" class="rounded-circle me-3" width="50" height="50">
                                <div class="flex-grow-1">
                                    <div class="fw-bold">Michael Chen</div>
                                    <div class="text-muted small">Electrician - ID submitted on Jul 18, 2023</div>
                                </div>
                                <div>
                                    <button class="btn btn-sm btn-success me-2">
                                        <i class="bi bi-check"></i> Approve
                                    </button>
                                    <button class="btn btn-sm btn-danger">
                                        <i class="bi bi-x"></i> Reject
                                    </button>
                                </div>
                            </div>
                            
                            <div class="verification-request">
                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="rounded-circle me-3" width="50" height="50">
                                <div class="flex-grow-1">
                                    <div class="fw-bold">Sophia Kim</div>
                                    <div class="text-muted small">Math Tutor - ID submitted on Jul 17, 2023</div>
                                </div>
                                <div>
                                    <button class="btn btn-sm btn-success me-2">
                                        <i class="bi bi-check"></i> Approve
                                    </button>
                                    <button class="btn btn-sm btn-danger">
                                        <i class="bi bi-x"></i> Reject
                                    </button>
                                </div>
                            </div>
                            
                            <div class="verification-request">
                                <img src="https://randomuser.me/api/portraits/men/41.jpg" alt="Robert" class="rounded-circle me-3" width="50" height="50">
                                <div class="flex-grow-1">
                                    <div class="fw-bold">Robert Johnson</div>
                                    <div class="text-muted small">Carpenter - ID submitted on Jul 16, 2023</div>
                                </div>
                                <div>
                                    <button class="btn btn-sm btn-success me-2">
                                        <i class="bi bi-check"></i> Approve
                                    </button>
                                    <button class="btn btn-sm btn-danger">
                                        <i class="bi bi-x"></i> Reject
                                    </button>
                                </div>
                            </div>
                            
                            <div class="verification-request">
                                <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Emma" class="rounded-circle me-3" width="50" height="50">
                                <div class="flex-grow-1">
                                    <div class="fw-bold">Emma Rodriguez</div>
                                    <div class="text-muted small">Cleaner - ID submitted on Jul 15, 2023</div>
                                </div>
                                <div>
                                    <button class="btn btn-sm btn-success me-2">
                                        <i class="bi bi-check"></i> Approve
                                    </button>
                                    <button class="btn btn-sm btn-danger">
                                        <i class="bi bi-x"></i> Reject
                                    </button>
                                </div>
                            </div>
                            
                            <div class="verification-request">
                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="rounded-circle me-3" width="50" height="50">
                                <div class="flex-grow-1">
                                    <div class="fw-bold">David Wilson</div>
                                    <div class="text-muted small">Plumber - ID submitted on Jul 14, 2023</div>
                                </div>
                                <div>
                                    <button class="btn btn-sm btn-success me-2">
                                        <i class="bi bi-check"></i> Approve
                                    </button>
                                    <button class="btn btn-sm btn-danger">
                                        <i class="bi bi-x"></i> Reject
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="dashboard-card mt-4">
                        <div class="card-title">
                            <span>Verified Users</span>
                            <span class="badge bg-success">24 verified</span>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Type</th>
                                        <th>Verified On</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/men/42.jpg" alt="John" class="rounded-circle me-2" width="30" height="30">
                                                John Smith
                                            </div>
                                        </td>
                                        <td>Worker</td>
                                        <td>Jul 10, 2023</td>
                                        <td><span class="badge bg-success">Active</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-x"></i> Revoke
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Sarah" class="rounded-circle me-2" width="30" height="30">
                                                Sarah Johnson
                                            </div>
                                        </td>
                                        <td>Client</td>
                                        <td>Jul 8, 2023</td>
                                        <td><span class="badge bg-success">Active</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-x"></i> Revoke
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://randomuser.me/api/portraits/women/22.jpg" alt="Sophia" class="rounded-circle me-2" width="30" height="30">
                                                Sophia Kim
                                            </div>
                                        </td>
                                        <td>Worker</td>
                                        <td>Jul 5, 2023</td>
                                        <td><span class="badge bg-success">Active</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-x"></i> Revoke
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                
                <!-- Job Approvals Section -->
                <div class="dashboard-section" id="jobs">
                    <h3 class="mb-4">Job Approvals</h3>
                    
                    <div class="dashboard-card">
                        <div class="card-title">
                            <span>Pending Approval</span>
                            <span class="badge bg-warning">3 new</span>
                        </div>
                        
                        <div class="jobs-grid">
                            <!-- Job 1 -->
                            <div class="job-card">
                                <div class="job-header">
                                    <div class="job-title">Home Cleaning</div>
                                    <div class="job-category">Cleaning</div>
                                </div>
                                <div class="job-body">
                                    <div class="job-info">
                                        <i class="bi bi-person"></i>
                                        <div>Posted by Sarah Johnson</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>Manhattan, NY</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-cash"></i>
                                        <div>$120 fixed price</div>
                                    </div>
                                    
                                    <p class="mb-3">Need a deep cleaning for my 2-bedroom apartment before moving in. Includes vacuuming, mopping, dusting, and bathroom cleaning.</p>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-success">
                                            <i class="bi bi-check me-1"></i> Approve
                                        </button>
                                        <button class="btn btn-outline-danger">
                                            <i class="bi bi-x me-1"></i> Reject
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-chat me-1"></i> Message Client
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Job 2 -->
                            <div class="job-card">
                                <div class="job-header">
                                    <div class="job-title">Electrical Wiring</div>
                                    <div class="job-category">Electrical</div>
                                </div>
                                <div class="job-body">
                                    <div class="job-info">
                                        <i class="bi bi-person"></i>
                                        <div>Posted by David Wilson</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>Brooklyn, NY</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-cash"></i>
                                        <div>$85 per hour</div>
                                    </div>
                                    
                                    <p class="mb-3">Need an electrician to rewire several outlets in my kitchen. Some outlets stopped working after a minor flood.</p>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-success">
                                            <i class="bi bi-check me-1"></i> Approve
                                        </button>
                                        <button class="btn btn-outline-danger">
                                            <i class="bi bi-x me-1"></i> Reject
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-chat me-1"></i> Message Client
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Job 3 -->
                            <div class="job-card">
                                <div class="job-header">
                                    <div class="job-title">Math Tutoring</div>
                                    <div class="job-category">Education</div>
                                </div>
                                <div class="job-body">
                                    <div class="job-info">
                                        <i class="bi bi-person"></i>
                                        <div>Posted by Emma Davis</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-geo-alt"></i>
                                        <div>Queens, NY</div>
                                    </div>
                                    <div class="job-info">
                                        <i class="bi bi-cash"></i>
                                        <div>$40 per hour</div>
                                    </div>
                                    
                                    <p class="mb-3">Looking for a math tutor for my 10th grade daughter. Needs help with algebra and geometry twice a week.</p>
                                    
                                    <div class="d-grid gap-2">
                                        <button class="btn btn-success">
                                            <i class="bi bi-check me-1"></i> Approve
                                        </button>
                                        <button class="btn btn-outline-danger">
                                            <i class="bi bi-x me-1"></i> Reject
                                        </button>
                                        <button class="btn btn-outline-primary">
                                            <i class="bi bi-chat me-1"></i> Message Client
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="dashboard-card mt-4">
                        <div class="card-title">
                            <span>Recently Approved Jobs</span>
                            <span class="badge bg-success">12 approved</span>
                        </div>
                        
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Job Title</th>
                                        <th>Client</th>
                                        <th>Category</th>
                                        <th>Budget</th>
                                        <th>Approved On</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Plumbing Repair</td>
                                        <td>Michael Brown</td>
                                        <td>Plumbing</td>
                                        <td>$150</td>
                                        <td>Jul 15, 2023</td>
                                        <td><span class="badge bg-success">Active</span></td>
                                    </tr>
                                    <tr>
                                        <td>Carpentry Work</td>
                                        <td>Robert Johnson</td>
                                        <td>Carpentry</td>
                                        <td>$250</td>
                                        <td>Jul 14, 2023</td>
                                        <td><span class="badge bg-success">Active</span></td>
                                    </tr>
                                    <tr>
                                        <td>Garden Maintenance</td>
                                        <td>Sophia Kim</td>
                                        <td>Gardening</td>
                                        <td>$35/hr</td>
                                        <td>Jul 12, 2023</td>
                                        <td><span class="badge bg-success">Active</span></td>
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
                                    <div class="text-muted small">Client</div>
                                </div>
                                <span class="badge bg-primary ms-auto">2</span>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/men/42.jpg" alt="John" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">John Smith</div>
                                    <div class="text-muted small">Worker</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/men/22.jpg" alt="Michael" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Michael Brown</div>
                                    <div class="text-muted small">Client</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/women/65.jpg" alt="Emma" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">Emma Rodriguez</div>
                                    <div class="text-muted small">Worker</div>
                                </div>
                            </div>
                            
                            <div class="chat-contact">
                                <img src="https://randomuser.me/api/portraits/men/67.jpg" alt="David" class="chat-contact-avatar">
                                <div>
                                    <div class="fw-bold">David Wilson</div>
                                    <div class="text-muted small">Client</div>
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
                                    Hi Admin, I'm having trouble posting a new job. The system says it's pending approval but it's been 2 days.
                                    <span class="message-time">10:24 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    Hi Sarah! I'll check on your job posting right away. Can you tell me the job title?
                                    <span class="message-time">10:26 AM</span>
                                </div>
                                
                                <div class="message received">
                                    It's for "Home Cleaning" in Manhattan. I really need someone by this weekend.
                                    <span class="message-time">10:28 AM</span>
                                </div>
                                
                                <div class="message sent">
                                    I see it in our queue. I'll prioritize the approval and you should see it live within the hour.
                                    <span class="message-time">10:29 AM</span>
                                </div>
                                
                                <div class="message received">
                                    Thank you so much! I really appreciate your help.
                                    <span class="message-time">10:30 AM</span>
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
                
                <!-- Analytics Section -->
                <div class="dashboard-section" id="analytics">
                    <h3 class="mb-4">System Analytics</h3>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>User Growth</span>
                                    <i class="bi bi-people"></i>
                                </div>
                                <div class="chart-container">
                                    <!-- Placeholder for chart - would be replaced with actual chart in implementation -->
                                    <img src="https://via.placeholder.com/600x300?text=User+Growth+Chart" alt="User Growth Chart" class="img-fluid">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Job Categories</span>
                                    <i class="bi bi-briefcase"></i>
                                </div>
                                <div class="chart-container">
                                    <!-- Placeholder for chart - would be replaced with actual chart in implementation -->
                                    <img src="https://via.placeholder.com/600x300?text=Job+Categories+Chart" alt="Job Categories Chart" class="img-fluid">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>Revenue</span>
                                    <i class="bi bi-currency-dollar"></i>
                                </div>
                                <div class="chart-container">
                                    <!-- Placeholder for chart - would be replaced with actual chart in implementation -->
                                    <img src="https://via.placeholder.com/600x300?text=Revenue+Chart" alt="Revenue Chart" class="img-fluid">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="dashboard-card">
                                <div class="card-title">
                                    <span>User Activity</span>
                                    <i class="bi bi-activity"></i>
                                </div>
                                <div class="chart-container">
                                    <!-- Placeholder for chart - would be replaced with actual chart in implementation -->
                                    <img src="https://via.placeholder.com/600x300?text=User+Activity+Chart" alt="User Activity Chart" class="img-fluid">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="dashboard-card mt-4">
                        <div class="card-title">
                            <span>Key Metrics</span>
                            <i class="bi bi-graph-up"></i>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4">
                                <div class="p-3 text-center">
                                    <div class="stat-number">78%</div>
                                    <div class="stat-label">Worker Verification Rate</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 text-center">
                                    <div class="stat-number">4.6</div>
                                    <div class="stat-label">Average Rating</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 text-center">
                                    <div class="stat-number">92%</div>
                                    <div class="stat-label">Job Completion Rate</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 text-center">
                                    <div class="stat-number">24h</div>
                                    <div class="stat-label">Avg. Job Posting Time</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 text-center">
                                    <div class="stat-number">65%</div>
                                    <div class="stat-label">Repeat Client Rate</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="p-3 text-center">
                                    <div class="stat-number">2.3k</div>
                                    <div class="stat-label">Monthly Active Users</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
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
                                    <label class="form-label">Password</label>
                                    <input type="password" class="form-control" placeholder="Password">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Confirm Password</label>
                                    <input type="password" class="form-control" placeholder="Confirm password">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">User Type</label>
                                    <select class="form-select">
                                        <option value="client">Client</option>
                                        <option value="worker">Worker</option>
                                        <option value="admin">Admin</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Status</label>
                                    <select class="form-select">
                                        <option value="active">Active</option>
                                        <option value="pending">Pending</option>
                                        <option value="suspended">Suspended</option>
                                    </select>
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
                    <button type="button" class="btn btn-primary">Add User</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- View ID Modal -->
    <div class="modal fade" id="viewIdModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">ID Verification</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-4">
                                <h6>Front of ID</h6>
                                <img src="https://via.placeholder.com/500x300?text=Front+of+ID" alt="ID Front" class="img-fluid rounded">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-4">
                                <h6>Back of ID</h6>
                                <img src="https://via.placeholder.com/500x300?text=Back+of+ID" alt="ID Back" class="img-fluid rounded">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Verification Decision</label>
                        <select class="form-select">
                            <option value="">Select decision</option>
                            <option value="approve">Approve</option>
                            <option value="reject">Reject - Poor Quality</option>
                            <option value="reject_fake">Reject - Suspected Fake</option>
                            <option value="request_more">Request More Information</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Notes</label>
                        <textarea class="form-control" rows="3" placeholder="Add any notes about this verification..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Submit Decision</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- View Job Modal -->
    <div class="modal fade" id="viewJobModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Job Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-4">
                        <h4>Home Cleaning</h4>
                        <span class="badge bg-primary">Cleaning</span>
                    </div>
                    
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Client</label>
                                <div class="d-flex align-items-center">
                                    <img src="https://randomuser.me/api/portraits/women/43.jpg" alt="Sarah" class="rounded-circle me-2" width="40" height="40">
                                    <div>
                                        <div class="fw-bold">Sarah Johnson</div>
                                        <div class="text-muted small">Verified Client</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Location</label>
                                <p>Manhattan, NY</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Budget</label>
                                <p>$120 fixed price</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Deadline</label>
                                <p>July 25, 2023</p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">Job Description</label>
                        <div class="p-3 bg-light rounded">
                            <p>Need a deep cleaning for my 2-bedroom apartment before moving in. Includes vacuuming, mopping, dusting, and bathroom cleaning. I have all the necessary cleaning supplies.</p>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Job Photo</label>
                        <img src="https://via.placeholder.com/800x400?text=Job+Photo" alt="Job Photo" class="img-fluid rounded">
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Approval Decision</label>
                        <select class="form-select">
                            <option value="">Select decision</option>
                            <option value="approve">Approve</option>
                            <option value="reject">Reject - Incomplete Info</option>
                            <option value="request_more">Request More Information</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Notes</label>
                        <textarea class="form-control" rows="3" placeholder="Add any notes about this job..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary">Submit Decision</button>
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
        document.querySelectorAll('.verification-request .btn-success').forEach(btn => {
            btn.addEventListener('click', function() {
                const request = this.closest('.verification-request');
                request.innerHTML = `
                    <div class="d-flex align-items-center text-success">
                        <i class="bi bi-check-circle-fill me-2 fs-4"></i>
                        <div>
                            <h5 class="mb-1">Verification Approved</h5>
                            <p class="mb-0">This user has been verified</p>
                        </div>
                    </div>
                `;
            });
        });
        
        document.querySelectorAll('.verification-request .btn-danger').forEach(btn => {
            btn.addEventListener('click', function() {
                const request = this.closest('.verification-request');
                request.innerHTML = `
                    <div class="d-flex align-items-center text-danger">
                        <i class="bi bi-x-circle-fill me-2 fs-4"></i>
                        <div>
                            <h5 class="mb-1">Verification Rejected</h5>
                            <p class="mb-0">This user needs to submit better ID photos</p>
                        </div>
                    </div>
                `;
            });
        });
    </script>
</body>
</html>