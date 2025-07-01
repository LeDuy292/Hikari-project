<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserAccount, model.student.CourseEnrollment, model.admin.Payment, java.util.List, java.util.Map, java.text.NumberFormat, java.util.Locale, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thông tin tài khoản - Học Tiếng Nhật Online</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: #f5f5f5;
            padding: 20px;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 16px;
            background: #ff6b35;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            margin-bottom: 20px;
            font-size: 14px;
            transition: background 0.2s ease;
        }
        .back-btn:hover {
            background: #e55a2b;
        }

        /* Tab Navigation */
        .tab-navigation {
            display: flex;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .tab-btn {
            flex: 1;
            padding: 16px 20px;
            background: none;
            border: none;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .tab-btn.active {
            background: #ff6b35;
            color: white;
        }
        .tab-btn:hover:not(.active) {
            background: #f8f9fa;
            color: #333;
        }

        /* Tab Content */
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }

        .main-grid {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 20px;
        }
        @media (max-width: 1024px) {
            .main-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Profile Card */
        .profile-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .profile-header {
            background: #ff6b35;
            padding: 30px;
            text-align: center;
            color: white;
        }
        .avatar-container {
            position: relative;
            display: inline-block;
            margin-bottom: 15px;
        }
        .profile-avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid white;
            background: white;
        }
        .avatar-upload {
            position: absolute;
            bottom: 0;
            right: 0;
            width: 24px;
            height: 24px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        .avatar-upload i {
            color: #ff6b35;
            font-size: 12px;
        }
        .profile-title {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }
        .profile-subtitle {
            font-size: 14px;
            opacity: 0.9;
            margin-top: 5px;
        }

        /* Profile Content */
        .profile-content {
            padding: 20px;
        }
        .info-grid {
            display: grid;
            gap: 12px;
        }
        .info-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }
        .info-item:hover {
            transform: translateX(4px);
            border-color: #ff6b35;
        }
        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
            flex-shrink: 0;
        }
        .info-icon.username { background: #ff6b35; }
        .info-icon.fullname { background: #4285f4; }
        .info-icon.email { background: #34a853; }
        .info-icon.role { background: #9c27b0; }
        .info-icon.date { background: #ff9800; }
        .info-icon.phone { background: #f44336; }
        .info-icon.birth { background: #e91e63; }
        .info-content {
            flex: 1;
        }
        .info-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 2px;
        }
        .info-value {
            font-size: 14px;
            font-weight: 500;
            color: #333;
        }
        .info-input {
            width: 100%;
            padding: 8px 0;
            border: none;
            background: transparent;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            border-bottom: 2px solid #ff6b35;
        }
        .info-input:focus {
            outline: none;
        }
        .role-badge {
            background: #ff6b35;
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
            margin-left: 8px;
        }

        /* Edit Button */
        .edit-btn {
            width: 100%;
            padding: 12px;
            background: #ff6b35;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.2s ease;
        }
        .edit-btn:hover {
            background: #e55a2b;
        }
        .save-btn {
            background: #34a853;
        }
        .save-btn:hover {
            background: #2d8f47;
        }
        .cancel-btn {
            background: #6c757d;
            margin-top: 10px;
        }
        .cancel-btn:hover {
            background: #5a6268;
        }

        /* Course List */
        .course-list {
            display: grid;
            gap: 16px;
        }
        .course-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.2s ease;
        }
        .course-card:hover {
            transform: translateY(-2px);
        }
        .course-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: #f0f0f0;
        }
        .course-content {
            padding: 20px;
        }
        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        .course-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        .course-status {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
            white-space: nowrap;
        }
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        .status-in-progress {
            background: #fff3cd;
            color: #856404;
        }
        .status-not-started {
            background: #f8d7da;
            color: #721c24;
        }
        .course-description {
            font-size: 14px;
            color: #666;
            margin-bottom: 16px;
            line-height: 1.5;
        }
        .course-meta {
            display: flex;
            gap: 16px;
            margin-bottom: 16px;
            font-size: 12px;
            color: #666;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .progress-section {
            margin-bottom: 16px;
        }
        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .progress-label {
            font-size: 13px;
            font-weight: 500;
            color: #333;
        }
        .progress-value {
            font-size: 13px;
            font-weight: 600;
            color: #ff6b35;
        }
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            background: #ff6b35;
            border-radius: 4px;
            transition: width 0.8s ease;
        }
        .course-actions {
            display: flex;
            gap: 8px;
        }
        .action-btn {
            flex: 1;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 4px;
        }
        .btn-primary {
            background: #ff6b35;
            color: white;
        }
        .btn-primary:hover {
            background: #e55a2b;
        }
        .btn-secondary {
            background: #f8f9fa;
            color: #666;
            border: 1px solid #e9ecef;
        }
        .btn-secondary:hover {
            background: #e9ecef;
        }

        /* Payment History */
        .payment-list {
            display: grid;
            gap: 12px;
        }
        .payment-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            transition: transform 0.2s ease;
        }
        .payment-card:hover {
            transform: translateY(-1px);
        }
        .payment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        .payment-course {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 4px;
        }
        .payment-id {
            font-size: 12px;
            color: #666;
        }
        .payment-status {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
            white-space: nowrap;
        }
        .status-complete {
            background: #d4edda;
            color: #155724;
        }
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        .status-cancel {
            background: #f8d7da;
            color: #721c24;
        }
        .payment-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 12px;
        }
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .detail-label {
            font-size: 12px;
            color: #666;
        }
        .detail-value {
            font-size: 14px;
            font-weight: 500;
            color: #333;
        }
        .payment-amount {
            font-size: 18px;
            font-weight: 700;
            color: #ff6b35;
        }

        /* Filter Controls */
        .filter-controls {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            padding: 16px;
            margin-bottom: 20px;
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }
        .filter-group {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .filter-label {
            font-size: 14px;
            font-weight: 500;
            color: #333;
        }
        .filter-select {
            padding: 8px 12px;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            background: white;
            cursor: pointer;
        }
        .filter-select:focus {
            outline: none;
            border-color: #ff6b35;
        }

        /* Sidebar */
        .sidebar {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .sidebar-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .card-header {
            padding: 16px;
            color: white;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .card-header.stats {
            background: #ff6b35;
        }
        .card-header.achievements {
            background: #4285f4;
        }
        .card-header h3 {
            font-size: 16px;
            font-weight: 600;
            margin: 0;
        }
        .card-header p {
            font-size: 12px;
            opacity: 0.9;
            margin: 2px 0 0 0;
        }
        .card-content {
            padding: 16px;
        }

        /* Stats */
        .stats-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 16px;
        }
        .stat-item {
            text-align: center;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .stat-number {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
            color: #ff6b35;
        }
        .stat-label {
            font-size: 12px;
            color: #666;
        }
        .main-stat {
            text-align: center;
            margin-bottom: 16px;
        }
        .main-stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #ff6b35;
            margin-bottom: 4px;
        }
        .main-stat-label {
            font-size: 14px;
            font-weight: 500;
            color: #333;
        }

        /* Message */
        .message {
            margin-top: 12px;
            padding: 12px;
            border-radius: 6px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }
        .message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 16px;
            opacity: 0.5;
        }
        .empty-state h3 {
            font-size: 18px;
            margin-bottom: 8px;
        }
        .empty-state p {
            font-size: 14px;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="container">
        <% 
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=Phiên+làm+việc+hết+hạn");
                return;
            }
            
            @SuppressWarnings("unchecked")
            List<CourseEnrollment> enrolledCourses = (List<CourseEnrollment>) request.getAttribute("enrolledCourses");
            @SuppressWarnings("unchecked")
            Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
            
            if (enrolledCourses == null) enrolledCourses = new java.util.ArrayList<>();
            if (stats == null) stats = new java.util.HashMap<>();
            
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>
        
        <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Trang chủ
        </a>
        
        <!-- Tab Navigation -->
        <div class="tab-navigation">
            <button class="tab-btn active" onclick="switchTab('profile')">
                <i class="fas fa-user"></i>
                Thông tin cá nhân
            </button>
            <button class="tab-btn" onclick="switchTab('courses')">
                <i class="fas fa-book"></i>
                Khóa học của tôi (<%= enrolledCourses.size() %>)
            </button>
            <button class="tab-btn" onclick="switchTab('payments')">
                <i class="fas fa-credit-card"></i>
                Lịch sử mua hàng (0)
            </button>
        </div>
        
        <!-- Profile Tab -->
        <div id="profile-tab" class="tab-content active">
            <div class="main-grid">
                <!-- Profile Card -->
                <div class="profile-card">
                    <div class="profile-header">
                        <div class="avatar-container">
                            <img src="<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() 
                                ? (request.getContextPath() + user.getProfilePicture()) 
                                : (request.getContextPath() + "/assets/img/avatar.png") %>" 
                                alt="Avatar" class="profile-avatar">
                            <div class="avatar-upload" onclick="document.getElementById('profileImage').click()">
                                <i class="fas fa-camera"></i>
                            </div>
                            <input type="file" id="profileImage" name="profileImage" style="display: none;" accept="image/*">
                        </div>
                        <h1 class="profile-title">Thông tin tài khoản</h1>
                        <p class="profile-subtitle">Quản lý thông tin cá nhân của bạn</p>
                    </div>
                    
                    <div class="profile-content">
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-icon username">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Tên đăng nhập</div>
                                    <div class="info-value" data-field="username"><%= user.getUsername() != null ? user.getUsername() : "Chưa cập nhật" %></div>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon fullname">
                                    <i class="fas fa-id-card"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Họ và tên</div>
                                    <div class="info-value" data-field="fullName"><%= user.getFullName() != null ? user.getFullName() : "Chưa cập nhật" %></div>
                                    <input type="text" name="fullName" class="info-input" style="display: none;">
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon email">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Email</div>
                                    <div class="info-value" data-field="email"><%= user.getEmail() != null ? user.getEmail() : "Chưa cập nhật" %></div>
                                    <input type="email" name="email" class="info-input" style="display: none;">
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon role">
                                    <i class="fas fa-user-tag"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Vai trò</div>
                                    <div class="info-value" data-field="role">
                                        <%= user.getRole() != null ? user.getRole() : "Chưa xác định" %>
                                        <span class="role-badge">Active</span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon date">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Ngày đăng ký</div>
                                    <div class="info-value" data-field="registrationDate"><%= user.getRegistrationDate() != null ? dateFormat.format(user.getRegistrationDate()) : "Chưa cập nhật" %></div>
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon phone">
                                    <i class="fas fa-phone"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Số điện thoại</div>
                                    <div class="info-value" data-field="phone"><%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật" %></div>
                                    <input type="tel" name="phone" class="info-input" style="display: none;">
                                </div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-icon birth">
                                    <i class="fas fa-birthday-cake"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Ngày sinh</div>
                                    <div class="info-value" data-field="birthDate"><%= user.getBirthDate() != null ? dateFormat.format(user.getBirthDate()) : "Chưa cập nhật" %></div>
                                    <input type="date" name="birthDate" class="info-input" style="display: none;">
                                </div>
                            </div>
                        </div>
                        
                        <button class="edit-btn" onclick="toggleEditMode()">
                            <i class="fas fa-edit"></i>
                            Chỉnh sửa thông

 tin
                        </button>
                        <button class="edit-btn save-btn" onclick="saveProfile()" style="display: none;">
                            <i class="fas fa-save"></i>
                            Lưu thay đổi
                        </button>
                        <button class="edit-btn cancel-btn" onclick="toggleEditMode()" style="display: none;">
                            <i class="fas fa-times"></i>
                            Hủy bỏ
                        </button>
                        
                        <div class="message"></div>
                    </div>
                </div>
                
                <!-- Sidebar -->
                <div class="sidebar">
                    <!-- Learning Stats -->
                    <div class="sidebar-card">
                        <div class="card-header stats">
                            <i class="fas fa-chart-line"></i>
                            <div>
                                <h3>Thống kê học tập</h3>
                                <p>Tiến độ học tập của bạn</p>
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="main-stat">
                                <div class="main-stat-number"><%= stats.get("averageProgress") != null ? stats.get("averageProgress") : 0 %>%</div>
                                <div class="main-stat-label">Tiến độ trung bình</div>
                            </div>
                            <div class="stats-grid">
                                <div class="stat-item">
                                    <div class="stat-number"><%= stats.get("totalCourses") != null ? stats.get("totalCourses") : 0 %></div>
                                    <div class="stat-label">Khóa học</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number"><%= stats.get("completedCourses") != null ? stats.get("completedCourses") : 0 %></div>
                                    <div class="stat-label">Hoàn thành</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number"><%= stats.get("totalHours") != null ? stats.get("totalHours") : 0 %></div>
                                    <div class="stat-label">Giờ học</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number"><%= stats.get("completedPayments") != null ? stats.get("completedPayments") : 0 %></div>
                                    <div class="stat-label">Thanh toán</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Payment Summary -->
                    <div class="sidebar-card">
                        <div class="card-header achievements">
                            <i class="fas fa-wallet"></i>
                            <div>
                                <h3>Tổng chi tiêu</h3>
                                <p>Thống kê thanh toán</p>
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="main-stat">
                                <div class="main-stat-number">
                                    <%= stats.get("totalSpent") != null ? 
                                        String.format("%,.0f", ((Double)stats.get("totalSpent"))) + "đ" : "0đ" %>
                                </div>
                                <div class="main-stat-label">Tổng đã chi tiêu</div>
                            </div>
                            <div class="stats-grid">
                                <div class="stat-item">
                                    <div class="stat-number"><%= stats.get("completedPayments") != null ? stats.get("completedPayments") : 0 %></div>
                                    <div class="stat-label">Thành công</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number"><%= stats.get("pendingPayments") != null ? stats.get("pendingPayments") : 0 %></div>
                                    <div class="stat-label">Đang chờ</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Courses Tab -->
        <div id="courses-tab" class="tab-content">
            <div class="filter-controls">
                <div class="filter-group">
                    <label class="filter-label">Trạng thái:</label>
                    <select class="filter-select" id="courseStatusFilter" onchange="filterCourses()">
                        <option value="all">Tất cả</option>
                        <option value="completed">Đã hoàn thành</option>
                        <option value="in-progress">Đang học</option>
                        <option value="not-started">Chưa bắt đầu</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">Sắp xếp:</label>
                    <select class="filter-select" id="courseSortFilter" onchange="sortCourses()">
                        <option value="newest">Mới nhất</option>
                        <option value="oldest">Cũ nhất</option>
                        <option value="progress">Tiến độ</option>
                        <option value="title">Tên khóa học</option>
                    </select>
                </div>
            </div>
            
            <div class="course-list" id="courseList">
                <% if (enrolledCourses.isEmpty()) { %>
                    <div class="empty-state">
                        <i class="fas fa-book-open"></i>
                        <h3>Chưa có khóa học nào</h3>
                        <p>Bạn chưa đăng ký khóa học nào. Hãy khám phá các khóa học của chúng tôi!</p>
                    </div>
                <% } else { %>
                    <% for (CourseEnrollment enrollment : enrolledCourses) { %>
                        <div class="course-card" data-status="<%= enrollment.getStatus().toLowerCase().replace(" ", "-") %>">
                            <img src="<%= enrollment.getCourseImageUrl() != null ? 
                                request.getContextPath() + enrollment.getCourseImageUrl() : 
                                request.getContextPath() + "/assets/img/course-default.jpg" %>" 
                                alt="<%= enrollment.getCourseTitle() %>" class="course-image">
                            <div class="course-content">
                                <div class="course-header">
                                    <div>
                                        <h3 class="course-title"><%= enrollment.getCourseTitle() %></h3>
                                        <div class="course-meta">
                                            <div class="meta-item">
                                                <i class="fas fa-clock"></i>
                                                <%= enrollment.getCourseDuration() %> giờ
                                            </div>
                                            <div class="meta-item">
                                                <i class="fas fa-calendar"></i>
                                                <%= dateFormat.format(enrollment.getEnrollmentDate()) %>
                                            </div>
                                            <% if (enrollment.getCompletionDate() != null) { %>
                                                <div class="meta-item">
                                                    <i class="fas fa-check-circle"></i>
                                                    <%= dateFormat.format(enrollment.getCompletionDate()) %>
                                                </div>
                                            <% } %>
                                        </div>
                                    </div>
                                    <span class="course-status <%= enrollment.isCompleted() ? "status-completed" : 
                                        (enrollment.getProgressPercentage() > 0 ? "status-in-progress" : "status-not-started") %>">
                                        <%= enrollment.getStatusDisplay() %>
                                    </span>
                                </div>
                                
                                <p class="course-description">
                                    <%= enrollment.getCourseDescription() != null ? 
                                        (enrollment.getCourseDescription().length() > 100 ? 
                                            enrollment.getCourseDescription().substring(0, 100) + "..." : 
                                            enrollment.getCourseDescription()) : "Không có mô tả" %>
                                </p>
                                
                                <div class="progress-section">
                                    <div class="progress-header">
                                        <span class="progress-label">Tiến độ học tập</span>
                                        <span class="progress-value"><%= enrollment.getProgressPercentage() %>%</span>
                                    </div>
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: <%= enrollment.getProgressPercentage() %>%;"></div>
                                    </div>
                                </div>
                                
                                <div class="course-actions">
                                    <% if (enrollment.isCompleted()) { %>
                                        <button class="action-btn btn-primary" onclick="viewCertificate('<%= enrollment.getEnrollmentID() %>')">
                                            <i class="fas fa-certificate"></i>
                                            Xem chứng chỉ
                                        </button>
                                    <% } else { %>
                                        <button class="action-btn btn-primary" onclick="continueCourse('<%= enrollment.getCourseID() %>')">
                                            <i class="fas fa-play"></i>
                                            Tiếp tục học
                                        </button>
                                    <% } %>
                                    <button class="action-btn btn-secondary" onclick="viewCourseDetails('<%= enrollment.getCourseID() %>')">
                                        <i class="fas fa-info-circle"></i>
                                        Chi tiết
                                    </button>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
        
        <!-- Payments Tab (Giữ nguyên, vì không liên quan trực tiếp đến yêu cầu) -->
        <div id="payments-tab" class="tab-content">
            <div class="filter-controls">
                <div class="filter-group">
                    <label class="filter-label">Trạng thái:</label>
                    <select class="filter-select" id="paymentStatusFilter" onchange="filterPayments()">
                        <option value="all">Tất cả</option>
                        <option value="complete">Thành công</option>
                        <option value="pending">Đang chờ</option>
                        <option value="cancel">Đã hủy</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label class="filter-label">Sắp xếp:</label>
                    <select class="filter-select" id="paymentSortFilter" onchange="sortPayments()">
                        <option value="newest">Mới nhất</option>
                        <option value="oldest">Cũ nhất</option>
                        <option value="amount-high">Số tiền cao</option>
                        <option value="amount-low">Số tiền thấp</option>
                    </select>
                </div>
            </div>
            
            <div class="payment-list" id="paymentList">
                <div class="empty-state">
                    <i class="fas fa-receipt"></i>
                    <h3>Chưa có giao dịch nào</h3>
                    <p>Bạn chưa có giao dịch thanh toán nào. Hãy đăng ký khóa học để bắt đầu!</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Tab switching
        function switchTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            document.getElementById(tabName + '-tab').classList.add('active');
            document.querySelector(`[onclick="switchTab('${tabName}')"]`).classList.add('active');
            const url = new URL(window.location);
            url.searchParams.set('section', tabName);
            window.history.pushState({}, '', url);
        }

        // Profile editing functions
        function toggleEditMode() {
            const spans = document.querySelectorAll('.info-value');
            const inputs = document.querySelectorAll('.info-input');
            const editBtn = document.querySelector('.edit-btn');
            const saveBtn = document.querySelector('.save-btn');
            const cancelBtn = document.querySelector('.cancel-btn');

            if (editBtn.style.display === 'none') {
                spans.forEach(span => span.style.display = 'block');
                inputs.forEach(input => input.style.display = 'none');
                editBtn.style.display = 'flex';
                saveBtn.style.display = 'none';
                cancelBtn.style.display = 'none';
                document.querySelector('.message').innerText = '';
            } else {
                spans.forEach(span => {
                    if (span.dataset.field !== 'username' && span.dataset.field !== 'role' && span.dataset.field !== 'registrationDate') {
                        span.style.display = 'none';
                    }
                });
                inputs.forEach(input => {
                    const field = input.name;
                    if (field === 'fullName' || field === 'phone' || field === 'birthDate' || field === 'email') {
                        input.style.display = 'block';
                        const spanValue = input.parentElement.querySelector('.info-value').innerText;
                        input.value = spanValue !== 'Chưa cập nhật' ? spanValue : '';
                    }
                });
                editBtn.style.display = 'none';
                saveBtn.style.display = 'flex';
                cancelBtn.style.display = 'flex';
            }
        }

        function saveProfile() {
            const fullName = document.querySelector('input[name="fullName"]').value;
            const phone = document.querySelector('input[name="phone"]').value;
            const birthDate = document.querySelector('input[name="birthDate"]').value;
            const email = document.querySelector('input[name="email"]').value;
            const fileInput = document.querySelector('#profileImage');
            const messageDiv = document.querySelector('.message');

            if (!fullName.match(/^[a-zA-ZÀ-ỹ\s]{2,50}$/)) {
                messageDiv.className = 'message error';
                messageDiv.innerText = 'Họ và tên không hợp lệ';
                return;
            }

            if (phone && !phone.match(/^\d{10,11}$/)) {
                messageDiv.className = 'message error';
                messageDiv.innerText = 'Số điện thoại không hợp lệ';
                return;
            }

            if (birthDate && !birthDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                messageDiv.className = 'message error';
                messageDiv.innerText = 'Ngày sinh không hợp lệ';
                return;
            }

            if (email && !email.match(/^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$/)) {
                messageDiv.className = 'message error';
                messageDiv.innerText = 'Email không hợp lệ';
                return;
            }

            const formData = new FormData();
            formData.append('fullName', fullName);
            formData.append('phone', phone);
            formData.append('birthDate', birthDate);
            formData.append('email', email);
            if (fileInput.files.length > 0) {
                formData.append('profileImage', fileInput.files[0]);
            }

            const xhr = new XMLHttpRequest();
            xhr.open('POST', '${pageContext.request.contextPath}/UpdateProfileServlet', true);
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4) {
                    const response = JSON.parse(xhr.responseText);
                    messageDiv.className = 'message ' + (response.success ? 'success' : 'error');
                    messageDiv.innerText = response.message;

                    if (response.success) {
                        document.querySelector('.info-value[data-field="fullName"]').innerText = fullName || 'Chưa cập nhật';
                        document.querySelector('.info-value[data-field="phone"]').innerText = phone || 'Chưa cập nhật';
                        document.querySelector('.info-value[data-field="birthDate"]').innerText = birthDate || 'Chưa cập nhật';
                        document.querySelector('.info-value[data-field="email"]').innerText = email || 'Chưa cập nhật';
                        if (response.profilePicture) {
                            document.querySelector('.profile-avatar').src = '${pageContext.request.contextPath}' + response.profilePicture;
                        }
                        toggleEditMode();
                    }
                }
            };
            xhr.send(formData);
        }

        // Course functions
        function filterCourses() {
            const filter = document.getElementById('courseStatusFilter').value;
            const courses = document.querySelectorAll('.course-card');
            courses.forEach(course => {
                if (filter === 'all' || course.dataset.status === filter) {
                    course.style.display = 'block';
                } else {
                    course.style.display = 'none';
                }
            });
        }

        function sortCourses() {
            const sortBy = document.getElementById('courseSortFilter').value;
            const courseList = document.getElementById('courseList');
            const courses = Array.from(courseList.querySelectorAll('.course-card'));
            
            courses.sort((a, b) => {
                switch(sortBy) {
                    case 'title':
                        return a.querySelector('.course-title').textContent.localeCompare(b.querySelector('.course-title').textContent);
                    case 'progress':
                        const progressA = parseInt(a.querySelector('.progress-value').textContent);
                        const progressB = parseInt(b.querySelector('.progress-value').textContent);
                        return progressB - progressA;
                    case 'oldest':
                        const dateA = new Date(a.querySelector('.meta-item:nth-child(2)').textContent.trim());
                        const dateB = new Date(b.querySelector('.meta-item:nth-child(2)').textContent.trim());
                        return dateA - dateB;
                    case 'newest':
                        const dateA2 = new Date(a.querySelector('.meta-item:nth-child(2)').textContent.trim());
                        const dateB2 = new Date(b.querySelector('.meta-item:nth-child(2)').textContent.trim());
                        return dateB2 - dateA2;
                }
            });
            
            courses.forEach(course => courseList.appendChild(course));
        }

        function continueCourse(courseId) {
            window.location.href = '${pageContext.request.contextPath}/course/' + courseId;
        }

        function viewCourseDetails(courseId) {
            window.location.href = '${pageContext.request.contextPath}/courseInfo?courseId=' + courseId;
        }

        function viewCertificate(enrollmentId) {
            window.open('${pageContext.request.contextPath}/certificate/' + enrollmentId, '_blank');
        }

        // Payment functions
        function filterPayments() {
            const filter = document.getElementById('paymentStatusFilter').value;
            const payments = document.querySelectorAll('.payment-card');
            payments.forEach(payment => {
                if (filter === 'all' || payment.dataset.status === filter) {
                    payment.style.display = 'block';
                } else {
                    payment.style.display = 'none';
                }
            });
        }

        function sortPayments() {
            const sortBy = document.getElementById('paymentSortFilter').value;
            const paymentList = document.getElementById('paymentList');
            const payments = Array.from(paymentList.querySelectorAll('.payment-card'));
            
            payments.sort((a, b) => {
                switch(sortBy) {
                    case 'amount-high':
                        const amountA = parseFloat(a.querySelector('.payment-amount').textContent.replace(/[^\d]/g, ''));
                        const amountB = parseFloat(b.querySelector('.payment-amount').textContent.replace(/[^\d]/g, ''));
                        return amountB - amountA;
                    case 'amount-low':
                        const amountA2 = parseFloat(a.querySelector('.payment-amount').textContent.replace(/[^\d]/g, ''));
                        const amountB2 = parseFloat(b.querySelector('.payment-amount').textContent.replace(/[^\d]/g, ''));
                        return amountA2 - amountB2;
                    case 'oldest':
                        return 1; // Implement date comparison if needed
                    default: // newest
                        return -1;
                }
            });
            
            payments.forEach(payment => paymentList.appendChild(payment));
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const section = urlParams.get('section');
            if (section && ['profile', 'courses', 'payments'].includes(section)) {
                document.querySelector('.tab-btn.active').classList.remove('active');
                document.querySelector('.tab-content.active').classList.remove('active');
                document.querySelector(`[onclick="switchTab('${section}')"]`).classList.add('active');
                document.getElementById(section + '-tab').classList.add('active');
            }

            const progressBars = document.querySelectorAll('.progress-fill');
            progressBars.forEach((bar, index) => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.width = width;
                }, 500 + (index * 100));
            });
        });
    </script>
</body>
</html> 
