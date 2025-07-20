<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserAccount" %>

<!-- Add CSS for notifications -->
<link href="${pageContext.request.contextPath}/assets/css/student/notifications.css" rel="stylesheet">

<div class="main-header">
    <div class="header-left">
        <span class="site-title"></span> <!-- Placeholder for title/logo -->
    </div>
    <div class="header-right">
        <button class="icon-btn" aria-label="Shopping Cart" onclick="window.location.href='${pageContext.request.contextPath}/view/student/shopping_cart.jsp'">
            <i class="fa fa-shopping-cart"></i>
        </button>
        <button class="icon-btn notification-bell-btn" aria-label="Notifications">
            <i class="fa fa-bell"></i>
        </button>
        <% 
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user != null) { 
                String profilePic = (user.getProfilePicture() != null && !user.getProfilePicture().isEmpty()) 
                    ? request.getContextPath() + "/uploads/" + user.getProfilePicture() // Sanitized path
                    : request.getContextPath() + "/assets/img/default-avatar.png";
        %>
            <div class="user-info">
                <a href="${pageContext.request.contextPath}/view/authentication/profile.jsp" aria-label="View Profile">
                    <img src="<%= profilePic %>?t=<%= System.currentTimeMillis() %>" alt="User Avatar" class="user-avatar">
                </a>
                <span class="user-name"><%= user.getUsername() != null ? user.getUsername() : user.getFullName() %></span>
                <form action="${pageContext.request.contextPath}/logout" method="post" class="logout-form">
                    <button type="submit" class="logout-btn" onclick="return confirm('Bạn có chắc muốn đăng xuất?')">Đăng xuất</button>
                </form>
            </div>
        <% } else { %>
            <button class="login-btn" onclick="window.location.href='${pageContext.request.contextPath}/loginPage'">Đăng nhập</button>
        <% } %>
    </div>
</div>

<!-- Add JavaScript for notifications -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/assets/js/student/notifications.js"></script>

<style>
    :root {
        --primary-color: #ff9800;
        --secondary-color: #ffb347;
        --text-color: #333;
        --bg-light: #f8f9fa;
    }

    .main-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 32px 0;
        width: 100%;
        max-width: 1600px;
        margin: 0 auto;
    }

    .header-left {
        display: flex;
        align-items: center;
        gap: 12px;
        padding-left: 50px;
    }

    .header-right {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-left: auto;
    }

    .site-title {
        font-size: 26px;
        font-weight: bold;
        color: var(--text-color);
        letter-spacing: 1px;
        transition: color 0.3s ease;
    }

    .site-title:hover {
        color: var(--primary-color);
    }

    .icon-btn {
        background: none;
        border: none;
        padding: 8px;
        cursor: pointer;
        border-radius: 50%;
        font-size: 18px;
        color: var(--primary-color);
        transition: all 0.3s ease;
    }

    .icon-btn:hover {
        transform: scale(1.1);
        background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
        color: white;
        border-radius: 50%;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 5px 10px;
        background-color: var(--bg-light);
        border-radius: 5px;
    }

    .user-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        transition: transform 0.3s ease;
    }

    .user-avatar:hover {
        transform: scale(1.1);
    }

    .user-name {
        font-weight: bold;
        color: var(--text-color);
        transition: color 0.3s ease;
    }

    .user-name:hover {
        color: var(--primary-color);
    }

    .user-info a {
        text-decoration: none;
    }

    .logout-btn, .login-btn {
        padding: 8px 16px;
        background: linear-gradient(90deg, var(--primary-color) 60%, var(--secondary-color) 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .login-btn {
        padding: 8px 28px;
        font-size: 16px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .logout-btn:hover, .login-btn:hover {
        transform: translateY(-2px);
        background: linear-gradient(90deg, #e06e4c 60%, #ffaa66 100%);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }
</style>