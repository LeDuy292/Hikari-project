<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ page import="model.UserAccount" %>
<%
    UserAccount currentUser = (UserAccount) session.getAttribute("user");
    String userName = (currentUser != null) ? currentUser.getFullName() : "Quản Trị";
    String userAvatar = (currentUser != null && currentUser.getProfilePicture() != null)
            ? currentUser.getProfilePicture()
            : "assets/img/dashborad/defaultLogoAdmin.jpg";
%>

<div class="header">
    <h2 class="header-title">${param.pageTitle != null ? param.pageTitle : 'Dashboard'}</h2>
    <div class="header-actions">
        <c:if test="${param.showAddButton == 'true'}">
            <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#${param.addModalTarget}">
                <i class="fas fa-plus"></i> ${param.addButtonText != null ? param.addButtonText : 'Thêm'}
            </button>
        </c:if>

        <c:if test="${param.showNotification == 'true'}">
            <div class="notification">
                <button class="btn-notification" data-bs-toggle="modal" data-bs-target="#notificationModal">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count" id="notificationCount">2</span>
                </button>
            </div>
        </c:if>

        <div class="user-profile">
            <img src="${pageContext.request.contextPath}/<%= userAvatar%>" alt="Ảnh Đại Diện Quản Trị" class="avatar" />
            <div class="user-info">
                <span class="user-name">Xin Chào, <%= userName%></span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    Đăng Xuất
                </a>
            </div>
        </div>
    </div>
</div>
