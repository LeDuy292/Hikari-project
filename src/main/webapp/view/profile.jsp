<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserAccount, java.sql.Date" %>
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
            max-width: 1200px;
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

        .card-header.achievements {
            background: #4285f4;
        }

        .card-header.courses {
            background: #34a853;
        }

        .card-header.stats {
            background: #ff6b35;
        }

        .card-header.progress {
            background: #34a853;
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

        /* Achievement Items */
        .achievement-item {
            display: flex;
            gap: 12px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 12px;
            border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }

        .achievement-item:hover {
            border-color: #4285f4;
            background: white;
        }

        .achievement-logo {
            width: 40px;
            height: 40px;
            border-radius: 6px;
            object-fit: cover;
            background: #e9ecef;
        }

        .achievement-info {
            flex: 1;
        }

        .achievement-category {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            background: #4285f4;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
            font-weight: 500;
            margin-bottom: 6px;
        }

        .achievement-category.course {
            background: #34a853;
        }

        .achievement-title {
            font-weight: 500;
            font-size: 13px;
            color: #333;
            margin-bottom: 4px;
            line-height: 1.3;
        }

        .achievement-institution {
            font-size: 11px;
            color: #666;
            margin-bottom: 8px;
        }

        .achievement-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .achievement-date {
            font-size: 10px;
            color: #999;
        }

        .view-certificate {
            background: #4285f4;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .view-certificate:hover {
            background: #3367d6;
        }

        /* Course Items - Mới thêm */
        .course-item {
            display: flex;
            gap: 12px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 12px;
            border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }

        .course-item:hover {
            border-color: #34a853;
            background: white;
        }

        .course-image {
            width: 50px;
            height: 50px;
            border-radius: 6px;
            object-fit: cover;
            background: #e9ecef;
        }

        .course-info {
            flex: 1;
        }

        .course-title {
            font-weight: 500;
            font-size: 13px;
            color: #333;
            margin-bottom: 6px;
            line-height: 1.3;
        }

        .course-progress-text {
            font-size: 11px;
            color: #666;
            margin-bottom: 8px;
        }

        .course-status {
            display: inline-block;
            background: #34a853;
            color: white;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 9px;
            font-weight: 500;
            margin-bottom: 8px;
        }

        .course-status.paused {
            background: #ff9800;
        }

        .course-status.completed {
            background: #4285f4;
        }

        /* Progress Bar */
        .progress-bar {
            width: 100%;
            height: 6px;
            background: #e9ecef;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 8px;
        }

        .progress-fill {
            height: 100%;
            border-radius: 3px;
            transition: width 0.8s ease;
        }

        .progress-fill.green { background: #34a853; }
        .progress-fill.blue { background: #4285f4; }
        .progress-fill.orange { background: #ff6b35; }

        /* Stats Card */
        .stats-number {
            font-size: 36px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 8px;
        }

        .stats-label {
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 16px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin-bottom: 16px;
        }

        .stat-item {
            text-align: center;
            padding: 12px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 8px;
        }

        .stat-number {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .stat-label {
            font-size: 12px;
            opacity: 0.9;
        }

        .view-all-btn {
            width: 100%;
            padding: 8px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .view-all-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        /* Progress Items */
        .progress-item {
            margin-bottom: 16px;
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 6px;
        }

        .progress-label {
            font-size: 13px;
            font-weight: 500;
            color: #333;
        }

        .progress-value {
            font-size: 13px;
            font-weight: 600;
        }

        .progress-value.green { color: #34a853; }
        .progress-value.blue { color: #4285f4; }
        .progress-value.orange { color: #ff6b35; }

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

        /* Thêm style cho continue button */
        .continue-btn {
            background: #34a853;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s ease;
            margin-top: 4px;
        }

        .continue-btn:hover {
            background: #2d8f47;
        }
    </style>
    
    <script>
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
        
        function viewCertificate(url) {
            window.open(url, '_blank');
        }

        function continueCourse(courseId) {
            window.location.href = '${pageContext.request.contextPath}/course/' + courseId;
        }
        
        document.addEventListener('DOMContentLoaded', function() {
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
</head>
<body>
    <div class="container">
        <% 
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=Phiên+làm+việc+hết+hạn");
            } else {
        %>
        
        <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Trang chủ
        </a>
        
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
                                <div class="info-value" data-field="registrationDate"><%= user.getRegistrationDate() != null ? user.getRegistrationDate() : "Chưa cập nhật" %></div>
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
                                <div class="info-value" data-field="birthDate"><%= user.getBirthDate() != null ? user.getBirthDate() : "Chưa cập nhật" %></div>
                                <input type="date" name="birthDate" class="info-input" style="display: none;">
                            </div>
                        </div>
                    </div>
                    
                    <button class="edit-btn" onclick="toggleEditMode()">
                        <i class="fas fa-edit"></i>
                        Chỉnh sửa thông tin
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
                <!-- Khóa học đang học -->
                <div class="sidebar-card">
                    <div class="card-header courses">
                        <i class="fas fa-play-circle"></i>
                        <div>
                            <h3>Đang học</h3>
                            <p>Khóa học bạn đang theo học</p>
                        </div>
                    </div>
                    <div class="card-content">
                        <div class="course-item">
                            <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N5.jpg" alt="JLPT N5" class="course-image">
                            <div class="course-info">
                                <div class="course-status">Đang học</div>
                                <div class="course-title">JLPT N5 - Tiếng Nhật cơ bản</div>
                                <div class="course-progress-text">Bài 15/20 • 75% hoàn thành</div>
                                <div class="progress-bar">
                                    <div class="progress-fill green" style="width: 75%;"></div>
                                </div>
                                <button class="continue-btn" onclick="continueCourse('n5-basic')">
                                    <i class="fas fa-play"></i> Tiếp tục học
                                </button>
                            </div>
                        </div>
                        
                        <div class="course-item">
                            <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N1.jpg" alt="Kanji" class="course-image">
                            <div class="course-info">
                                <div class="course-status">Đang học</div>
                                <div class="course-title">Luyện tập Kanji cơ bản</div>
                                <div class="course-progress-text">Bài 8/15 • 53% hoàn thành</div>
                                <div class="progress-bar">
                                    <div class="progress-fill blue" style="width: 53%;"></div>
                                </div>
                                <button class="continue-btn" onclick="continueCourse('kanji-basic')">
                                    <i class="fas fa-play"></i> Tiếp tục học
                                </button>
                            </div>
                        </div>
                        
                        <div class="course-item">
                            <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N3.png" alt="Grammar" class="course-image">
                            <div class="course-info">
                                <div class="course-status paused">Tạm dừng</div>
                                <div class="course-title">Ngữ pháp tiếng Nhật nâng cao</div>
                                <div class="course-progress-text">Bài 3/12 • 25% hoàn thành</div>
                                <div class="progress-bar">
                                    <div class="progress-fill orange" style="width: 25%;"></div>
                                </div>
                                <button class="continue-btn" onclick="continueCourse('grammar-advanced')">
                                    <i class="fas fa-play"></i> Tiếp tục học
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Achievements -->
                <div class="sidebar-card">
                    <div class="card-header achievements">
                        <i class="fas fa-trophy"></i>
                        <div>
                            <h3>Thành tựu học tập</h3>
                            <p>Chứng chỉ đã hoàn thành</p>
                        </div>
                    </div>
                    <div class="card-content">
                        <div class="achievement-item">
                            <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N5.jpg" alt="University" class="achievement-logo">
                            <div class="achievement-info">
                                <div class="achievement-category">
                                    <i class="fas fa-award"></i> Chuyên môn
                                </div>
                                <div class="achievement-title">User Experience Research and Design</div>
                                <div class="achievement-institution">University of Michigan</div>
                                <div class="achievement-footer">
                                    <span class="achievement-date">19/3/2024</span>
                                    <button class="view-certificate" onclick="viewCertificate('#')">Xem</button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="achievement-item">
                            <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N5.jpg" alt="Japanese" class="achievement-logo">
                            <div class="achievement-info">
                                <div class="achievement-category course">
                                    <i class="fas fa-book"></i> Khóa học
                                </div>
                                <div class="achievement-title">Japanese Language Fundamentals</div>
                                <div class="achievement-institution">Học Tiếng Nhật Online</div>
                                <div class="achievement-footer">
                                    <span class="achievement-date">10/4/2024</span>
                                    <button class="view-certificate" onclick="viewCertificate('#')">Xem</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Stats -->
                <div class="sidebar-card">
                    <div class="card-header stats">
                        <div style="width: 100%;">
                            <div class="stats-number">6</div>
                            <div class="stats-label">Chứng chỉ đã hoàn thành</div>
                            <div class="stats-grid">
                                <div class="stat-item">
                                    <div class="stat-number">3</div>
                                    <div class="stat-label">Chuyên môn</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number">3</div>
                                    <div class="stat-label">Khóa học</div>
                                </div>
                            </div>
                            <button class="view-all-btn">Xem tất cả thành tựu</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <% } %>
    </div>
</body>
</html>
