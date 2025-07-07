<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
<!-- Google Fonts for Elegant Font -->
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/sidebar.css" />
 
<%
    // Get the current page name from the request
    String currentPage = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
%>


<div class="sidebar">
    <div class="sidebar-top">
        <div class="sidebar-header">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo HIKARI" class="sidebar-logo" />
            <div class="sidebar-title-container">
                <span class="sidebar-title">HIKARI</span>
                <span class="sidebar-subtitle">Japanese</span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/view/teacher/profileTeacher.jsp" class="sidebar-nav-item <%= currentPage.equals("profileTeacher.jsp") ? "active" : ""%>">
            <i class="fa fa-user"></i><span>Hồ Sơ Của Tôi</span></a>
        <a href="${pageContext.request.contextPath}/manageCourse" class="sidebar-nav-item <%= currentPage.equals("manageCourse.jsp") ? "active" : ""%>">
            <i class="fa fa-book-open"></i>
            <span>Quản lý khóa học </span>
        </a>
        <a href="${pageContext.request.contextPath}/view/teacher/manageClasses.jsp" class="sidebar-nav-item <%= currentPage.equals("manageClasses.jsp") ? "active" : ""%>">
            <i class="fa fa-chalkboard"></i><span>Quản Lý Lớp Học</span>
        </a>
        <a href="${pageContext.request.contextPath}/manageTests" class="sidebar-nav-item <%= currentPage.equals("manageTest.jsp") ? "active" : ""%>">
            <i class="fa fa-clipboard-check"></i><span>Bài Tập & Test</span>
        </a>
        <a href="${pageContext.request.contextPath}/view/teacher/manageDocument.jsp" class="sidebar-nav-item <%= currentPage.equals("manageDocument.jsp") ? "active" : ""%>">
            <i class="fa fa-file-alt"></i><span>Quản Lý Tài Liệu</span>
        </a>   
        <a href="${pageContext.request.contextPath}/view/teacher/forum.jsp" class="sidebar-nav-item <%= currentPage.equals("forum.jsp") ? "active" : ""%>">
            <i class="fa fa-comments"></i><span>Diễn Đàn</span>
        </a>
    </div>
    <div class="sidebar-bottom">
        <img src="${pageContext.request.contextPath}/assets/img/learning.jpg" alt="Sidebar Image" class="sidebar-image" />
        <a href="${pageContext.request.contextPath}/view/notification/messages.jsp" class="sidebar-message-link <%= currentPage.equals("messages.jsp") ? "active" : ""%>">
            <i class="fas fa-envelope"></i><span>Nhắn Tin</span></a>
    </div>
</div>