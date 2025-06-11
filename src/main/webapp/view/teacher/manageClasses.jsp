<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Lớp Học - Nền Tảng Giáo Dục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/manageClasses.css" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <%@ include file="sidebar.jsp" %>
                <!-- Main Content -->
                <main class="main-content">
                    <div class="content-wrapper">
                        <!-- Header -->
                        <%@ include file="header.jsp" %>
                        <!-- Main Content -->
                        <div class="row" id="classView">
                            <div class="col-12">
                                <!-- Search Input -->
                                <div class="mb-4">
                                    <input type="text" class="search-input" id="searchInput" placeholder="Tìm kiếm lớp học..." aria-label="Tìm kiếm lớp học" />
                                </div>
                                <!-- Classes Table -->
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th scope="col">Tên Lớp</th>
                                                <th scope="col">Thời Gian</th>
                                                <th scope="col">Thứ</th>
                                                <th scope="col">Số Buổi</th>
                                                <th scope="col">Số Sinh Viên</th>
                                                <th scope="col">Khóa Học</th>
                                                <th scope="col">Hành Động</th>
                                            </tr>
                                        </thead>
                                        <tbody id="classTableBody">
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <!-- Student List View -->
                        <div class="row" id="studentView" style="display: none;">
                            <div class="col-12">
                                <a href="#" class="back-btn" onclick="showClassView()"><i class="fas fa-arrow-left"></i> Quay lại danh sách lớp học</a>
                                <h2 class="lesson-list-title" id="selectedClassName"></h2>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th scope="col">Tên Sinh Viên</th>
                                                <th scope="col">Email</th>
                                                <th scope="col">Tiến Độ Học Tập</th>
                                                <th scope="col">Xem Bài Làm</th>
                                                <th scope="col">Nhắn Tin</th>
                                            </tr>
                                        </thead>
                                        <tbody id="studentTableBody">
                                            <!-- Populated by JavaScript -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageClasses.js"></script>
    </body>
</html>