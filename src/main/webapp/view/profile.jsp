<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserAccount, java.sql.Date" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Thông tin tài khoản - Học Tiếng Nhật Online</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .profile-container {
            background: white;
            max-width: 700px;
            width: 90%;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin: 20px 0;
            position: relative;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-header img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #ff9800;
            margin-bottom: 15px;
            transition: transform 0.3s ease;
        }
        .profile-header img:hover {
            transform: scale(1.1);
        }
        .profile-header h2 {
            color: #333;
            font-size: 28px;
            margin: 0;
        }
        .profile-header .upload-btn {
            margin-top: 10px;
            padding: 8px 15px;
            background: #ff9800;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .profile-header .upload-btn:hover {
            background: #e06e4c;
        }
        .profile-details {
            display: grid;
            gap: 15px;
        }
        .profile-item {
            background: #f9f9f9;
            padding: 15px;
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: box-shadow 0.3s ease;
        }
        .profile-item:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        .profile-item label {
            font-weight: 500;
            color: #555;
            margin-right: 10px;
            min-width: 150px;
        }
        .profile-item span, .profile-item input {
            color: #333;
            font-weight: 400;
            width: 100%;
            border: none;
            background: transparent;
            font-size: 16px;
        }
        .profile-item input {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 5px;
        }
        .profile-item input:focus {
            outline: none;
            border-color: #ff9800;
        }
        .logout-btn, .edit-btn, .save-btn, .cancel-btn, .back-btn {
            display: block;
            padding: 12px;
            background: linear-gradient(90deg, #ff9800 60%, #ffb347 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
            text-align: center;
        }
        .logout-btn:hover, .edit-btn:hover, .save-btn:hover, .cancel-btn:hover, .back-btn:hover {
            background: linear-gradient(90deg, #e06e4c 60%, #ffaa66 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        .edit-btn, .save-btn, .cancel-btn {
            width: 48%;
            display: inline-block;
            margin-right: 4%;
        }
        .cancel-btn {
            background: linear-gradient(90deg, #ccc 60%, #ddd 100%);
        }
        .cancel-btn:hover {
            background: linear-gradient(90deg, #bbb 60%, #ccc 100%);
        }
        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            width: 120px;
            padding: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
            text-decoration: none;
            background: linear-gradient(90deg, #ff9800 60%, #ffb347 100%);
            color: white;
            border-radius: 10px;
        }
        .back-btn i {
            font-size: 16px;
        }
        .message {
            text-align: center;
            margin-top: 20px;
            color: #333;
            font-weight: 500;
        }
        .error {
            color: #d32f2f;
        }
        .success {
            color: #388e3c;
        }
    </style>
    <script>
        function toggleEditMode() {
            const spans = document.querySelectorAll('.profile-item span');
            const inputs = document.querySelectorAll('.profile-item input');
            const editBtn = document.querySelector('.edit-btn');
            const saveBtn = document.querySelector('.save-btn');
            const cancelBtn = document.querySelector('.cancel-btn');
            const fileInput = document.querySelector('#profileImage');

            if (editBtn.style.display === 'none') {
                spans.forEach(span => span.style.display = 'block');
                inputs.forEach(input => input.style.display = 'none');
                fileInput.style.display = 'none';
                editBtn.style.display = 'block';
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
                        input.value = input.parentElement.querySelector('span').innerText !== 'Chưa cập nhật' 
                            ? input.parentElement.querySelector('span').innerText 
                            : '';
                    }
                });
                fileInput.style.display = 'block';
                editBtn.style.display = 'none';
                saveBtn.style.display = 'inline-block';
                cancelBtn.style.display = 'inline-block';
            }
        }

        function saveProfile() {
            const fullName = document.querySelector('input[name="fullName"]').value;
            const phone = document.querySelector('input[name="phone"]').value;
            const birthDate = document.querySelector('input[name="birthDate"]').value;
            const email = document.querySelector('input[name="email"]').value;
            const fileInput = document.querySelector('#profileImage');
            const messageDiv = document.querySelector('.message');

            if (!fullName.match(/^[a-zA-Z\s]{2,50}$/)) {
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
                        document.querySelector('.profile-item span[data-field="fullName"]').innerText = fullName || 'Chưa cập nhật';
                        document.querySelector('.profile-item span[data-field="phone"]').innerText = phone || 'Chưa cập nhật';
                        document.querySelector('.profile-item span[data-field="birthDate"]').innerText = birthDate || 'Chưa cập nhật';
                        document.querySelector('.profile-item span[data-field="email"]').innerText = email || 'Chưa cập nhật';
                        if (response.profilePicture) {
                            document.querySelector('.profile-header img').src = '${pageContext.request.contextPath}' + response.profilePicture;
                        }
                        toggleEditMode();
                    }
                }
            };
            xhr.send(formData);
        }
    </script>
</head>
<body>
    <div class="profile-container">
        <% 
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/view/login.jsp?error=Phiên+làm+việc+hết+hạn");
            } else {
        %>
        <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Trang chủ
        </a>
        <div class="profile-header">
            <img src="<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() 
                ? (request.getContextPath() + user.getProfilePicture()) 
                : (request.getContextPath() + "/assets/img/avatar.png") %>" alt="Avatar">
            <input type="file" id="profileImage" name="profileImage" style="display: none;" accept="image/*">
            <button class="upload-btn" onclick="document.getElementById('profileImage').click()">Thay đổi ảnh</button>
            <h2>Thông tin tài khoản</h2>
        </div>
        <div class="profile-details">
            <div class="profile-item">
                <label>Tên đăng nhập:</label>
                <span data-field="username"><%= user.getUsername() != null ? user.getUsername() : "Chưa cập nhật" %></span>
            </div>
            <div class="profile-item">
                <label>Họ và tên:</label>
                <span data-field="fullName"><%= user.getFullName() != null ? user.getFullName() : "Chưa cập nhật" %></span>
                <input type="text" name="fullName" style="display: none;">
            </div>
            <div class="profile-item">
                <label>Email:</label>
                <span data-field="email"><%= user.getEmail() != null ? user.getEmail() : "Chưa cập nhật" %></span>
                <input type="text" name="email" style="display: none;">
            </div>
            <div class="profile-item">
                <label>Vai trò:</label>
                <span data-field="role"><%= user.getRole() != null ? user.getRole() : "Chưa xác định" %></span>
            </div>
            <div class="profile-item">
                <label>Ngày đăng ký:</label>
                <span data-field="registrationDate"><%= user.getRegistrationDate() != null ? user.getRegistrationDate() : "Chưa cập nhật" %></span>
            </div>
            <div class="profile-item">
                <label>Số điện thoại:</label>
                <span data-field="phone"><%= user.getPhone() != null ? user.getPhone() : "Chưa cập nhật" %></span>
                <input type="text" name="phone" style="display: none;">
            </div>
            <div class="profile-item">
                <label>Ngày sinh:</label>
                <span data-field="birthDate"><%= user.getBirthDate() != null ? user.getBirthDate() : "Chưa cập nhật" %></span>
                <input type="text" name="birthDate" placeholder="YYYY-MM-DD" style="display: none;">
            </div>
        </div>
        <button class="edit-btn" onclick="toggleEditMode()">Chỉnh sửa</button>
        <button class="save-btn" onclick="saveProfile()" style="display: none;">Lưu</button>
        <button class="cancel-btn" onclick="toggleEditMode()" style="display: none;">Hủy</button>
        <div class="message"></div>
        <form action="${pageContext.request.contextPath}/logout" method="post" style="text-align:center; margin-top:30px;">
            <button type="submit" class="logout-btn">Đăng xuất</button>
        </form>
        <% } %>
    </div>
</body>
</html>