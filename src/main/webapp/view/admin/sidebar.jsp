<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
<!-- Google Fonts for Elegant Font -->
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
<link href="${pageContext.request.contextPath}/assets/css/admin/sidebarAdmin.css" rel="stylesheet" />
<% 
  // Get the current page name from the request
  String currentPage = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
%>

<div class="sidebar">
  <div class="sidebar-top">
    <div class="sidebar-header">
      <img src="${pageContext.request.contextPath}/assets/img/dashborad/logo.png" alt="Logo HIKARI" class="sidebar-logo" />
      <div class="sidebar-title-container">
        <span class="sidebar-title">HIKARI</span>
        <span class="sidebar-subtitle">Japanese</span>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-item <%= currentPage.equals("dashboard.jsp") ? "active" : "" %>">
      <i class="fas fa-chart-line"></i>
      <span>Dashboard</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-item <%= currentPage.equals("manageUsers.jsp") ? "active" : "" %>">
      <i class="fas fa-users"></i>
      <span>Quản Lý Tài Khoản</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/courses" class="sidebar-nav-item <%= currentPage.equals("manageCourses.jsp") ? "active" : "" %>">
      <i class="fas fa-book"></i>
      <span>Quản Lý Khóa Học</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/payments" class="sidebar-nav-item <%= currentPage.equals("managePayments.jsp") ? "active" : "" %>">
      <i class="fas fa-credit-card"></i>
      <span>Quản Lý Thanh Toán</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/reviews" class="sidebar-nav-item <%= currentPage.equals("manageReviews.jsp") ? "active" : "" %>">
      <i class="fas fa-star"></i>
      <span>Quản Lý Đánh Giá</span>
    </a>
    <a href="${pageContext.request.contextPath}/admin/notifications" class="sidebar-nav-item <%= currentPage.equals("manageNotifications.jsp") ? "active" : "" %>">
      <i class="fas fa-bell"></i>
      <span>Quản Lý Thông Báo</span>
    </a>
      <a href="${pageContext.request.contextPath}/forum" class="sidebar-nav-item <%= currentPage.equals("forum.jsp") ? "active" : ""%>">
            <i class="fa fa-comments"></i><span>Diễn Đàn</span>
     </a>
  </div>
  <div class="sidebar-bottom">
    <img src="${pageContext.request.contextPath}/assets/img/dashborad/learning.jpg" alt="Sidebar Image" class="sidebar-image" />
    <a href="${pageContext.request.contextPath}/admin/messages" class="sidebar-message-link <%= currentPage.equals("manageMessages.jsp") ? "active" : "" %>">
      <i class="fas fa-envelope"></i>
      <span>Nhắn Tin</span>
    </a>
  </div>
</div>
