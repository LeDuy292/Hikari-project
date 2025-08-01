<%@page import="dao.admin.ProgressDAO"%>
<%@page import="dao.student.CourseEnrollmentDAO"%>
<%@page import="model.Course"%>
<%@page import="dao.CourseDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserAccount, java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thông tin tài khoản - Học Tiếng Nhật Online</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; }
        .back-btn { display: inline-flex; align-items: center; gap: 8px; padding: 10px 16px; background: #ff6b35; color: white; text-decoration: none; border-radius: 8px; font-weight: 500; margin-bottom: 20px; font-size: 14px; transition: background 0.2s ease; }
        .back-btn:hover { background: #e55a2b; }
        .tab-navigation { display: flex; background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); margin-bottom: 20px; overflow: hidden; }
        .tab-btn { flex: 1; padding: 16px 20px; background: none; border: none; font-size: 14px; font-weight: 500; color: #666; cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .tab-btn.active { background: #ff6b35; color: white; }
        .tab-btn:hover:not(.active) { background: #f8f9fa; color: #333; }
        .main-grid { display: grid; grid-template-columns: 1fr 350px; gap: 20px; }
        @media (max-width: 1024px) { .main-grid { grid-template-columns: 1fr; } }
        .profile-card { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .profile-header { background: #ff6b35; padding: 30px; text-align: center; color: white; }
        .avatar-container { position: relative; display: inline-block; margin-bottom: 15px; }
        .profile-avatar { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid white; background: white; }
        .avatar-upload { position: absolute; bottom: 0; right: 0; width: 24px; height: 24px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor: pointer; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2); }
        .avatar-upload i { color: #ff6b35; font-size: 12px; }
        .profile-title { font-size: 20px; font-weight: 600; margin: 0; }
        .profile-subtitle { font-size: 14px; opacity: 0.9; margin-top: 5px; }
        .profile-content { padding: 20px; }
        .info-grid { display: grid; gap: 12px; }
        .info-item { display: flex; align-items: center; gap: 12px; padding: 16px; background: #f8f9fa; border-radius: 8px; border: 1px solid #e9ecef; transition: all 0.2s ease; }
        .info-item:hover { transform: translateX(4px); border-color: #ff6b35; }
        .info-icon { width: 40px; height: 40px; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: white; font-size: 16px; flex-shrink: 0; }
        .info-icon.username { background: #ff6b35; }
        .info-icon.fullname { background: #4285f4; }
        .info-icon.email { background: #34a853; }
        .info-icon.role { background: #9c27b0; }
        .info-icon.date { background: #ff9800; }
        .info-icon.phone { background: #f44336; }
        .info-icon.birth { background: #e91e63; }
        .info-content { flex: 1; }
        .info-label { font-size: 12px; color: #666; margin-bottom: 2px; }
        .info-value { font-size: 14px; font-weight: 500; color: #333; }
        .info-input { width: 100%; padding: 8px 0; border: none; background: transparent; font-size: 14px; font-weight: 500; color: #333; border-bottom: 2px solid #ff6b35; }
        .info-input:focus { outline: none; }
        .role-badge { background: #ff6b35; color: white; padding: 2px 8px; border-radius: 12px; font-size: 11px; font-weight: 500; margin-left: 8px; }
        .edit-btn { width: 100%; padding: 12px; background: #ff6b35; color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; margin-top: 20px; display: flex; align-items: center; justify-content: center; gap: 8px; transition: background 0.2s ease; }
        .edit-btn:hover { background: #e55a2b; }
        .save-btn { background: #34a853; }
        .save-btn:hover { background: #2d8f47; }
        .cancel-btn { background: #6c757d; margin-top: 10px; }
        .cancel-btn:hover { background: #5a6268; }
        .sidebar { display: flex; flex-direction: column; gap: 16px; }
        .sidebar-card { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); overflow: hidden; }
        .card-header { padding: 16px; color: white; display: flex; align-items: center; gap: 8px; }
        .card-header.stats { background: #ff6b35; }
        .card-header h3 { font-size: 16px; font-weight: 600; margin: 0; }
        .card-header p { font-size: 12px; opacity: 0.9; margin: 2px 0 0 0; }
        .card-content { padding: 16px; }
        .stats-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px; }
        .stat-item { text-align: center; padding: 12px; background: #f8f9fa; border-radius: 8px; }
        .stat-number { font-size: 24px; font-weight: 700; margin-bottom: 4px; color: #ff6b35; }
        .stat-label { font-size: 12px; color: #666; }
        .main-stat { text-align: center; margin-bottom: 16px; }
        .main-stat-number { font-size: 36px; font-weight: 700; color: #ff6b35; margin-bottom: 4px; }
        .main-stat-label { font-size: 14px; font-weight: 500; color: #333; }
        .message { margin-top: 12px; padding: 12px; border-radius: 6px; text-align: center; font-size: 14px; font-weight: 500; }
        .message.success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .message.error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
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
            
            CourseEnrollmentDAO courseEnrollmentDAO = new CourseEnrollmentDAO();
            ProgressDAO progressDAO = new ProgressDAO();
            dao.student.StudentProgressDAO studentProgressDAO = new dao.student.StudentProgressDAO();
            
            List<Course> enrolledCourses = null;
            try {
                enrolledCourses = courseEnrollmentDAO.getEnrolledCoursesByUserID(user.getUserID());
            } catch (Exception e) {
                System.err.println("Error fetching enrolled courses: " + e.getMessage());
                enrolledCourses = new java.util.ArrayList<>();
            }
            if (enrolledCourses == null) enrolledCourses = new java.util.ArrayList<>();
            
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

            // Sử dụng StudentProgressDAO để tính toán thống kê chính xác
            java.util.Map<String, Object> statsMap = studentProgressDAO.getStudentStats(user.getUserID());
            
            int totalCourses = (Integer) statsMap.getOrDefault("totalCourses", 0);
            int completedCourses = (Integer) statsMap.getOrDefault("completedCourses", 0);
            double averageProgress = (Double) statsMap.getOrDefault("averageProgress", 0.0);
            double totalHours = (Double) statsMap.getOrDefault("totalHours", 0.0);

            // Cleanup connections
            try {
                courseEnrollmentDAO.closeConnection();
                progressDAO.closeConnection();
                studentProgressDAO.closeConnection();
            } catch (Exception e) {
                System.err.println("Error closing connections: " + e.getMessage());
            }
        %>
        
        <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i>
            Trang chủ
        </a>
        
        <div class="tab-navigation">
            <button class="tab-btn active" onclick="window.location.href='${pageContext.request.contextPath}/view/student/profile.jsp'">
                <i class="fas fa-user"></i>
                Thông tin cá nhân
            </button>
            <button class="tab-btn" onclick="window.location.href='http://localhost:8080/Hikari/profile/myCourses'">
                <i class="fas fa-book"></i>
                Khóa học của tôi 
            </button>
            <button class="tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/paymentHistory'">
                <i class="fas fa-credit-card"></i>
                Lịch sử mua hàng
            </button>
        </div>
        
        <div class="main-grid">
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
            
            <div class="sidebar">
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
                            <div class="main-stat-number"><%= Math.round(averageProgress) %>%</div>
                            <div class="main-stat-label">Tiến độ trung bình</div>
                        </div>
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-number"><%= totalCourses %></div>
                                <div class="stat-label">Khóa học</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number"><%= completedCourses %></div>
                                <div class="stat-label">Hoàn thành</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number"><%= Math.round(totalHours) %></div>
                                <div class="stat-label">Giờ học</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
                    if (spanValue !== 'Chưa cập nhật') {
                        if (field === 'birthDate') {
                            const parts = spanValue.split('/');
                            if (parts.length === 3) {
                                input.value = `${parts[2]}-${parts[1]}-${parts[0]}`;
                            }
                        } else {
                            input.value = spanValue;
                        }
                    }
                }
            });
            editBtn.style.display = 'none';
            saveBtn.style.display = 'flex';
            cancelBtn.style.display = 'flex';
        }
    }

    function saveProfile() {
        const fullName = document.querySelector('input[name="fullName"]').value.trim();
        const phone = document.querySelector('input[name="phone"]').value.trim();
        const birthDate = document.querySelector('input[name="birthDate"]').value.trim();
        const email = document.querySelector('input[name="email"]').value.trim();
        const fileInput = document.querySelector('#profileImage');
        const messageDiv = document.querySelector('.message');

        // Validation
        if (!fullName.match(/^[\p{L} ]{2,50}$/u)) {
            messageDiv.className = 'message error';
            messageDiv.innerText = 'Họ và tên không hợp lệ';
            return;
        }

        if (phone && !phone.match(/^0\d{9}$/)) {
            messageDiv.className = 'message error';
            messageDiv.innerText = 'Số điện thoại không hợp lệ';
            return;
        }

        if (birthDate) {
            const today = new Date().toISOString().split('T')[0];
            if (!birthDate.match(/^\d{4}-\d{2}-\d{2}$/)) {
                messageDiv.className = 'message error';
                messageDiv.innerText = 'Ngày sinh không hợp lệ';
                return;
            }
            if (birthDate > today) {
                messageDiv.className = 'message error';
                messageDiv.innerText = 'Ngày sinh không được ở tương lai';
                return;
            }
        }

        if (email && !email.match(/^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$/)) {
            messageDiv.className = 'message error';
            messageDiv.innerText = 'Email không hợp lệ';
            return;
        }

        // Chuẩn bị form gửi
        const formData = new FormData();
        formData.append('fullName', fullName);
        formData.append('phone', phone);
        formData.append('birthDate', birthDate);
        formData.append('email', email);
        if (fileInput.files.length > 0) {
            formData.append('profileImage', fileInput.files[0]);
        }

        messageDiv.className = 'message';
        messageDiv.innerText = 'Đang cập nhật...';

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
</script>
</body>
</html>