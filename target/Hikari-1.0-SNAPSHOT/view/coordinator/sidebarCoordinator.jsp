<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
<!-- Google Fonts for Elegant Font -->
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
<style>
    :root {
        --primary-color: #4a90e2;
        --secondary-color: #34495e;
        --accent-color: #f39c12;
        --background-color: #f7f9fb;
        --text-color: #ffffff;
        --text-dark: #333333;
        --table-header-color: #34495e;
    }

    .sidebar {
        width: 320px;
        min-height: 100vh;
        background: linear-gradient(45deg, var(--secondary-color), var(--primary-color));
        background-size: 200% 200%;
        animation: gradientAnimation 10s ease infinite;
        padding: 20px;
        position: fixed;
        left: 0;
        top: 0;
        bottom: 0;
        box-shadow: 5px 0 20px rgba(52, 73, 94, 0.3);
        border-right: 2px solid transparent;
        border-image: linear-gradient(45deg, var(--secondary-color), var(--primary-color)) 1;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    @keyframes gradientAnimation {
        0% {
            background-position: 0% 0%;
        }
        50% {
            background-position: 100% 100%;
        }
        100% {
            background-position: 0% 0%;
        }
    }

    .sidebar .nav-link {
        color: var(--text-color);
        padding: 12px 20px;
        margin: 8px 0;
        border-radius: 5px;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 500;
        background: rgba(255, 255, 255, 0.1);
    }

    .sidebar .nav-link:hover {
        background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
        transform: translateX(5px);
        color: var(--text-color);
        box-shadow: 0 0 10px rgba(74, 144, 226, 0.5);
    }

    .sidebar .nav-link.active {
        background: linear-gradient(90deg, var(--secondary-color), var(--primary-color));
        color: var(--text-color);
        box-shadow: 0 0 10px rgba(52, 73, 94, 0.5);
    }

    .sidebar-header {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
        margin-left: -20px;
    }

    .sidebar-logo {
        max-width: 200px;
        margin-right: -20px;
    }

    .sidebar-title {
        color: var(--text-color);
        font-size: 2rem;
        font-weight: 700;
        font-family: 'Dancing Script', cursive;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        letter-spacing: 1px;
    }

    .sidebar-nav-item {
        display: flex;
        align-items: center;
        padding: 16px 20px;
        margin-top: 10px;
        color: var(--text-color);
        text-decoration: none;
        font-size: 1rem;
        transition: background-color 0.3s;
        border-radius: 8px;
    }

    .sidebar-nav-item i {
        margin-right: 10px;
        font-size: 1.2rem;
        color: var(--text-color);
    }

    .sidebar-nav-item:hover {
        background: linear-gradient(90deg, var(--accent-color), var(--primary-color));
        color: var(--text-color);
    }

    .sidebar-nav-item.active {
        background: linear-gradient(90deg, var(--accent-color), var(--primary-color));
        color: var(--text-color);
    }

    .sidebar-bottom {
        margin-top: auto;
        margin-bottom: 20px;
    }

    .sidebar-image {
        width: 100%;
        height: auto;
        border-radius: 10px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        margin-bottom: 15px;
    }

    .sidebar-message-link {
        display: flex;
        align-items: center;
        padding: 12px 20px;
        margin: 8px 0;
        border-radius: 5px;
        background: linear-gradient(90deg, var(--accent-color), var(--primary-color));
        color: var(--text-color);
        text-decoration: none;
        font-size: 1rem;
        font-weight: 600;
        transition: transform 0.3s, box-shadow 0.3s;
    }

    .sidebar-message-link i {
        margin-right: 10px;
        font-size: 1.3rem;
    }

    .sidebar-message-link:hover {
        transform: scale(1.05);
        box-shadow: 0 0 15px rgba(243, 156, 18, 0.5);
        background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
    }

    .sidebar-subtitle {
        color: var(--text-color);
        font-size: 1.2rem;
        font-weight: 700;
        font-family: 'Dancing Script', cursive;
        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        letter-spacing: 1px;
        line-height: 1.2;
        margin: 0;
    }
</style>

<%
    // Get the current page name from the request
    String currentPage = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
%>

<div class="sidebar">
    <div class="sidebar-top">
        <div class="sidebar-header">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo HIKARI" class="sidebar-logo" />
            <div>
                <span class="sidebar-title">HIKARI</span>
                <br> 
                <span class="sidebar-subtitle">Japanese</span> 
            </div>
        </div>    
        <a href="view/coordinator/home.jsp" class="sidebar-nav-item <%= currentPage.equals("home.jsp") ? "active" : ""%>">
            <i class="fas fa-chart-line"></i>
            <span>Trang chủ</span>
        </a>
        <a href="${pageContext.request.contextPath}/LoadCourse" class="sidebar-nav-item <%= currentPage.equals("course-monitoring.jsp") ? "active" : ""%>">
            <i class="fas fa-users"></i>
            <span>Giám sát khóa học</span>
        </a>
        <a href="course-approval.jsp" class="sidebar-nav-item <%= currentPage.equals("course-approval.jsp") ? "active" : ""%>">
            <i class="fas fa-book"></i>
            <span>Phê duyệt khóa học</span>
        </a>
        <a href="document-approval.jsp" class="sidebar-nav-item <%= currentPage.equals("document-approval.jsp") ? "active" : ""%>">
            <i class="fas fa-credit-card"></i>
            <span>Phê duyệt tài liệu</span>
        </a>
        <a href="test-approval.jsp" class="sidebar-nav-item <%= currentPage.equals("test-approval.jsp") ? "active" : ""%>">
            <i class="fas fa-star"></i>
            <span>Phê duyệt bài kiểm tra</span>
        </a>
        <a href="${pageContext.request.contextPath}/LoadInstructor" class="sidebar-nav-item <%= currentPage.equals("instructor-assignment.jsp") ? "active" : ""%>">
            <i class="fas fa-bell"></i>
            <span>Phân công giảng viên</span>
        </a>
        <a href="teacher-cv-review.jsp" class="sidebar-nav-item <%= currentPage.equals("teacher-cv-review.jsp") ? "active" : ""%>">
            <i class="fas fa-users"></i>
            <span>Phê Duyệt Hồ Sơ Giảng Viên</span>
        </a>
    </div>
    <div class="sidebar-bottom">
        <img src="${pageContext.request.contextPath}/assets/img/learning.jpg" alt="Sidebar Image" class="sidebar-image" />
        <a href="manageMessages.jsp" class="sidebar-message-link <%= currentPage.equals("manageMessages.jsp") ? "active" : ""%>">
            <i class="fas fa-envelope"></i>
            <span>Nhắn Tin</span>
        </a>
    </div>
</div>