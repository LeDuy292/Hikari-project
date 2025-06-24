<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Complete Your Profile</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: url('${pageContext.request.contextPath}/assets/img/backgroundLogin.png') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #ff835d;
        }
        .container {
            display: flex;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            width: 900px;
            height: 650px;
        }
        .left-panel {
            background: #ff835d;
            width: 40%;
            padding: 20px;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
        }
        .left-panel img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin-bottom: 20px;
        }
        .left-panel h2 {
            font-size: 24px;
            margin: 10px 0;
        }
        .left-panel p {
            font-size: 14px;
            opacity: 0.8;
        }
        .right-panel {
            width: 60%;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .right-panel h2 {
            color: #ff835d;
            margin-bottom: 20px;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #ff835d;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .form-group input[type="date"] {
            padding: 10px;
        }
        .submit-btn {
            background: #ff835d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            width: 100%;
        }
        .submit-btn:hover {
            background: #e5941d;
        }
        .error-message {
            color: #ff835d;
            font-size: 14px;
            margin-top: 10px;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="left-panel">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Hikari Logo">
            <h2>HIKARI</h2>
            <p>"Học 6m nay, làm chủ trong lát!"</p>
            <p>Chinh phục tiếng Nhật cùng hàng ngàn học viên moi ngày.</p>
            <div style="margin-top: 20px;">
                <span style="margin: 0 10px;">+2000</span>
                <span style="margin: 0 10px;">+100</span>
                <span style="margin: 0 10px;">24/7</span>
            </div>
            <div>
                <span style="margin: 0 10px;">Tu vung</span>
                <span style="margin: 0 10px;">Bai hoc</span>
                <span style="margin: 0 10px;">Ho tro</span>
            </div>
        </div>
        <div class="right-panel">
            <h2>Hoàn tất hồ sơ</h2>
            <form action="${pageContext.request.contextPath}/completeProfile" method="post">
                <div class="form-group">
                    <label for="fullName">Họ và tên:</label>
                    <input type="text" id="fullName" name="fullName" value="${sessionScope.user.fullName}" required>
                </div>
                <div class="form-group">
                    <label for="username">Tên đăng nhập:</label>
                    <input type="text" id="username" name="username" value="${sessionScope.user.username}" required>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại:</label>
                    <input type="text" id="phone" name="phone">
                </div>
                <div class="form-group">
                    <label for="birthDate">Ngày sinh (YYYY-MM-DD):</label>
                    <input type="date" id="birthDate" name="birthDate">
                </div>
                <div class="form-group">
                    <input type="submit" value="Hoàn tất" class="submit-btn">
                </div>
                <div class="error-message" id="errorMessage">${errorMessage}</div>
            </form>
        </div>
    </div>
</body>
</html>