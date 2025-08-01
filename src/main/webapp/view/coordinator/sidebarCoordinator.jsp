<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
<!-- Google Fonts for Elegant Font -->
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/assets/css/coordinator_css/sidebarCoordinator.css" rel="stylesheet">


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
        <a href="${pageContext.request.contextPath}/LoadDashboard" class="sidebar-nav-item <%= currentPage.equals("home.jsp") ? "active" : ""%>">
            <i class="fas fa-chart-line"></i>
            <span>Trang chủ</span>
        </a>
        <a href="${pageContext.request.contextPath}/LoadCourse" class="sidebar-nav-item <%= currentPage.equals("course-monitoring.jsp") ? "active" : ""%>">
            <i class="fas fa-users"></i>
            <span>Giám sát khóa học</span>
        </a>
<!--        <a href="${pageContext.request.contextPath}/LessonApprovalServlet" class="sidebar-nav-item <%= currentPage.equals("course-approval.jsp") ? "active" : ""%>">
            <i class="fas fa-book"></i>
            <span>Phê duyệt bài học</span>
        </a>
     
<!--        <a href="${pageContext.request.contextPath}/view/coordinator/document-approval.jsp" class="sidebar-nav-item <%= currentPage.equals("document-approval.jsp") ? "active" : ""%>">
        -->        
       <a href="${pageContext.request.contextPath}/CoordinatorTask" class="sidebar-nav-item <%= currentPage.equals("test-approval.jsp") ? "active" : ""%>">
            <i class="fas fa-star"></i>
            <span>Nhiệm vụ</span>

        <a href="${pageContext.request.contextPath}/LoadTeacher" class="sidebar-nav-item <%= currentPage.equals("instructor-assignment.jsp") ? "active" : ""%>">
            <i class="fas fa-bell"></i>
            <span>Phân công giảng viên</span>
        </a>
        <a href="${pageContext.request.contextPath}/cv" class="sidebar-nav-item <%= currentPage.equals("teacher-cv-review.jsp") ? "active" : ""%>">
            <i class="fas fa-users"></i>
            <span>Phê Duyệt Hồ Sơ Giảng Viên</span>
        </a>
        <a href="${pageContext.request.contextPath}/coordinator/contact-management" class="sidebar-nav-item <%= currentPage.equals("contact-management.jsp") ? "active" : ""%>">
            <i class="fas fa-headset"></i>
            <span>Trung tâm hỗ trợ</span>
        </a>
        <a href="${pageContext.request.contextPath}/forum" class="sidebar-nav-item <%= currentPage.equals("forum.jsp") ? "active" : ""%>">
            <i class="fa fa-comments"></i><span>Diễn Đàn</span>
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