<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String uri = request.getRequestURI();
    String pageTitle = "Trang";

    if (uri.contains("class-management")) {
        pageTitle = "Quản lý lớp học ";
    } else if (uri.contains("course-approval")) {
        pageTitle = "Phê duyệt khóa học ";
    } else if (uri.contains("document-approval")) {
        pageTitle = "Phê duyệt tài liệu  ";
    } else if (uri.contains("home")) {
        pageTitle = "Dashboard";
    } else if (uri.contains("teacher-cv-review")) {
        pageTitle = "Phê duyệt hồ sơ ";
    } else if (uri.contains("test-approval")) {
        pageTitle = "Phê duyệt bài test ";
    }
%>

<div class="header">
    <h2 class="header-title"><%= pageTitle%></h2>
<!--<div class="header">
  <h2 class="header-title">Dashboard</h2>-->
  <div class="header-actions">
    <div class="user-profile">
        <img src="${pageContext.request.contextPath}/assets/images/avatar.png" alt="Ảnh Đại Diện Quản Trị" class="avatar" />
      <div class="user-info">
        <span class="user-name">Xin Chào, Quản Trị</span>
        <a href="${pageContext.request.contextPath}/Logout" class="logout-btn">
          <i class="fas fa-sign-out-alt"></i>
          Đăng Xuất
        </a>
      </div>
    </div>
  </div>
</div>

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