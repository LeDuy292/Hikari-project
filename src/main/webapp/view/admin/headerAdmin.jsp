<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="${pageContext.request.contextPath}/assets/css/admin/headerAdmin.css" rel="stylesheet" />
<div class="header">
    <h1 class="header-title">
        <c:if test="${not empty pageIcon}">
            <i class="fas ${pageIcon}"></i>
        </c:if>
        ${pageTitle}
    </h1>
    <div class="header-actions">
        <c:if test="${showAddButton != null && showAddButton}">
            <a href="${addBtnLink != null ? addBtnLink : '#'}" 
               class="btn-add-user" 
               ${addModalTarget != null ? 'data-bs-toggle="modal" data-bs-target="#'.concat(addModalTarget).concat('"') : ''}>
                <i class="fas ${addBtnIcon != null ? addBtnIcon : 'fa-plus'}"></i>
                ${addButtonText != null ? addButtonText : 'Thêm Mới'}
            </a>
        </c:if>
        <c:if test="${showNotification != null && showNotification}">
            <div class="notification">
                <button class="btn-notification" data-bs-toggle="modal" data-bs-target="#notificationModal">
                    <i class="fas fa-bell"></i>
                    <span class="notification-count">${notificationCount != null ? notificationCount : 0}</span>
                </button>
            </div>
        </c:if>
        <div class="user-profile">
            <img src="${pageContext.request.contextPath}/assets/img/dashborad/defaultAvatar.jpg" alt="User Avatar" class="avatar" />
            <div class="user-info">
                <span class="user-name">${sessionScope.user != null ? sessionScope.user.fullName : 'Admin'}</span>
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                </a>
            </div>
        </div>
    </div>
</div>
                    