<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
  String currentPage = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
%>
<div class="sidebar">
  <div class="sidebar-top">
    <div class="logo">
      <img src="${pageContext.request.contextPath}/assets/img/img_student/logoHikari.png" alt="Logo" />
      <div>
        <div class="logo-text">HIKARI</div>
        <div class="logo-sub">JAPAN</div>
      </div>
    </div>
    <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="menu-item <%= currentPage.equals("home.jsp") ? "active" : "" %>"><i class="fa fa-home"></i>Trang chủ</a>
    <a href="${pageContext.request.contextPath}/documents" class="menu-item <%= currentPage.equals("documents.jsp") ? "active" : "" %>"><i class="fa fa-book"></i>Tài liệu</a>
    <a href="${pageContext.request.contextPath}/courses?category=paid" class="menu-item <%= currentPage.equals("courses.jsp") ? "active" : "" %>"><i class="fa fa-play-circle"></i>Khóa học online</a>
    <a href="${pageContext.request.contextPath}/forum" class="menu-item <%= currentPage.equals("forum.jsp") ? "active" : "" %>"><i class="fa fa-chalkboard"></i>Diễn đàn</a>
    <a href="${pageContext.request.contextPath}/view/student/test.jsp" class="menu-item <%= currentPage.equals("test.jsp") ? "active" : "" %>"><i class="fa fa-file-alt"></i>Bài kiểm tra</a>
    <a href="${pageContext.request.contextPath}/dictionary" class="menu-item <%= currentPage.equals("dictionary.jsp") ? "active" : "" %>"><i class="fa fa-book-open"></i>Từ điển</a>
    <a href="${pageContext.request.contextPath}/view/student/account.jsp" class="menu-item <%= currentPage.equals("account.jsp") ? "active" : "" %>"><i class="fa fa-user"></i>Quản lý tài khoản</a>
  </div>
  <div class="bottom-section">
    <div class="image-placeholder">
      <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Placeholder Image" />
    </div>
    <a href="${pageContext.request.contextPath}/message" class="menu-item"><i class="fa fa-comments"></i>Chat</a>
  </div>
</div>
