<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String uri = request.getRequestURI();
    String pageTitle = "";

    if (uri.contains("class-management")) {
        pageTitle = "Quản lý lớp học";
    } else if (uri.contains("course-approval")) {
        pageTitle = "Phê duyệt bài học ";
    } else if (uri.contains("document-approval")) {
        pageTitle = "Phê duyệt tài liệu  ";
    } else if (uri.contains("home")) {
        pageTitle = "Trang chủ";
    } else if (uri.contains("teacher-cv-review")) {
        pageTitle = "Phê duyệt hồ sơ";
    } else if (uri.contains("test-approval")) {
        pageTitle = "Phê duyệt bài kiểm tra";
    } else if (uri.contains("course-monitoring")) {
        pageTitle = "Giám sát khóa học";
    }
%>

<!-- Add CSS for notifications -->
<link href="${pageContext.request.contextPath}/assets/css/admin/admin-notifications.css" rel="stylesheet" />

<div class="header">
    <h2 class="header-title"><%= pageTitle%></h2>
    <div class="header-actions">
        
        <!-- Notification will be inserted here by JavaScript -->
        
        <div class="user-profile">
            <img src="${pageContext.request.contextPath}/img/dashborad/defaultAvatar.jpg" alt="Ảnh Đại Diện Quản Trị" class="avatar" />
            <div class="user-info">
                <span class="user-name">Xin Chào, Điều phối viên</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    Đăng Xuất
                </a>
            </div>
        </div>
    </div>
</div>

<!-- Add JavaScript for notifications -->
<script>
    window.contextPath = '${pageContext.request.contextPath}';
    
    // Ensure only one notification system
    if (window.adminNotificationManager) {
        window.adminNotificationManager.destroy()
        window.adminNotificationManager = null
    }
    
    // Initialize after DOM is ready
    document.addEventListener("DOMContentLoaded", function() {
        setTimeout(function() {
            try {
                // Remove any existing notification containers
                const existingContainers = document.querySelectorAll('.admin-notification-container')
                existingContainers.forEach(container => container.remove())
                
                // Initialize new notification manager
                window.adminNotificationManager = new AdminNotificationManager("coordinator")
            } catch (error) {
                console.error("Failed to initialize coordinator notifications:", error)
            }
        }, 200)
    })
</script>
<script src="${pageContext.request.contextPath}/assets/js/admin/admin-notifications.js"></script>

<script>
    function confirmLogout(logoutUrl) {
        if (confirm("Bạn có chắc muốn đăng xuất?")) {
            window.location.href = logoutUrl;
        }
    }
</script>

<style>
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 2rem;
        background: #ffffff;
        border-radius: 10px;
        margin-bottom: 2rem;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.25);
    }

    .header-title {
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--text-dark);
        margin: 0;
    }

    .header-actions {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .user-profile {
        display: flex;
        align-items: center;
        gap: 1rem;
        margin-left: 1.5rem;
        padding-left: 1.5rem;
        border-left: 1px solid rgba(0, 0, 0, 0.2);
    }

    .avatar {
        width: 60px; /* Increased from 40px to make avatar larger */
        height: 60px; /* Increased from 40px to make avatar larger */
        border-radius: 50%;
        object-fit: cover;
    }

    .user-info {
        display: flex;
        flex-direction: column;
        gap: 0.25rem;
    }

    .user-name {
        font-size: 0.9rem;
        color: var(--text-dark);
        font-weight: 500;
    }

    .logout-btn {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        color: var(--text-dark);
        font-size: 0.85rem;
        text-decoration: none;
        transition: color 0.2s;
    }

    .logout-btn:hover {
        color: var(--accent-color);
    }
</style>
