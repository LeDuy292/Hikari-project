<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/header.css" />
<%
    String uri = request.getRequestURI();
    String pageTitle = "Trang";

    if (uri.contains("manageClasses")) {
        pageTitle = "Quản lý lớp học";
    } else if (uri.contains("manageCourse")) {
        pageTitle = "Quản Lý Khóa Học";
    } else if (uri.contains("manageDocument")) {
        pageTitle = "Quản lý Tài liệu";
    } else if (uri.contains("manageTest")) {
        pageTitle = "Quản lý bài test";
    } else if (uri.contains("profileTeacher")) {
        pageTitle = "Thông Tin Cá Nhân";
    } else if (uri.contains("message")) {
        pageTitle = "Tin nhắn";
    }
%>
<div class="header">
    <h2 class="header-title"><%= pageTitle %></h2>
    <div class="header-actions">
        <div class="user-profile">
            <a href="${pageContext.request.contextPath}/teacherProfile">
                <img src="${sessionScope.user != null && sessionScope.user.profilePicture != null ? sessionScope.user.profilePicture : pageContext.request.contextPath + '/assets/img/dashborad/defaultAvatar.jpg'}" alt="User Avatar" class="avatar" />
            </a>
            <div class="user-info">
                <span class="user-name">${sessionScope.user != null ? sessionScope.user.fullName : 'Teacher'}</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                </a>
            </div>
        </div>
    </div>
</div>