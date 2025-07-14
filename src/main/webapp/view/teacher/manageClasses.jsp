<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="context-path" content="${pageContext.request.contextPath}" />
        <title>Quản Lý Lớp Học</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
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

                        <!-- Class List View -->
                        <div class="row" id="classView">
                            <div class="col-12">                     
                                <!-- Classes Grid -->
                                <div class="classes-grid" id="classesGrid">
                                    <c:choose>
                                        <c:when test="${empty classes}">
                                            <div class="alert alert-info text-center">
                                                Không tìm thấy lớp học nào.
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="classInfo" items="${classes}">
                                                <div class="class-card card">
                                                    <div class="card-body">
                                                        <h5 class="card-title">
                                                            <c:out value="${classInfo.name}"/>
                                                        </h5>
                                                        <p class="card-text">
                                                        <div class="detail-item">
                                                            <i class="fas fa-book me-2"></i>
                                                            <strong>Khóa học:</strong> <c:out value="${classInfo.courseTitle}"/>
                                                        </div>
                                                        <div class="detail-item">
                                                            <i class="fas fa-id-card me-2"></i>
                                                            <strong>Mã lớp:</strong> <c:out value="${classInfo.classID}"/>
                                                        </div>
                                                        <div class="detail-item">
                                                            <i class="fas fa-users me-2"></i>
                                                            <strong>Sĩ số:</strong> <c:out value="${classInfo.numberOfStudents}"/> học sinh
                                                        </div>
                                                        
                                                        </p>
                                                    </div>
                                                    <div class="class-card-footer">
                                                        <a class="btn btn-primary btn-sm btn-view-students" onclick="classManager.viewStudents('${classInfo.classID}')">
                                                            Xem chi tiết
                                                        </a>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <!-- Pagination for Classes -->
                                <nav aria-label="Class pagination" class="mt-4">
                                    <ul class="pagination justify-content-center" id="classPagination">
                                    </ul>
                                </nav>
                            </div>
                        </div>

                        <!-- Student List View -->
                        <div class="row" id="studentView" style="display: none;">
                            <div class="col-12">
                                <div class="back-navigation">
                                    <button class="btn btn-outline-primary" onclick="showClassView()">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Quay lại danh sách lớp học
                                    </button>
                                </div>

                                <div class="page-header">
                                    <h1 class="page-title" id="selectedClassName"></h1>
                                    <p class="page-subtitle" id="selectedClassInfo"></p>
                                </div>

                                <!-- Student Search -->
                                <div class="search-filter-section">
                                    <div class="row align-items-center">
                                        <div class="col-md-6">
                                            <div class="search-box">
                                                <i class="fas fa-search search-icon"></i>
                                                <input type="text" class="form-control search-input" id="studentSearchInput" 
                                                       placeholder="Tìm kiếm học sinh theo tên, email, mã số..." />
                                            </div>
                                        </div>
                                        <div class="col-md-6 text-end">
                                            <div class="stats-badge">
                                                <span class="badge bg-success fs-6" id="studentCount">
                                                    <i class="fas fa-user-graduate me-1"></i>
                                                    0 học sinh
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Students Table -->
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i class="fas fa-users me-2"></i>
                                            Danh sách học sinh
                                        </h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="table-responsive">
                                            <table class="table table-hover mb-0" id="studentsTable">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th style="width: 50px;">#</th>
                                                        <th>Học sinh</th>
                                                        <th>Thông tin liên hệ</th>
                                                        <th class="text-center">Tiến độ học tập</th>
                                                        <th class="text-center">Điểm TB</th>
                                                        <th class="text-center">Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="studentsTableBody">
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- Pagination for Students -->
                                <nav aria-label="Student pagination" class="mt-4">
                                    <ul class="pagination justify-content-center" id="studentPagination">
                                    </ul>
                                </nav>
                            </div>
                        </div>

                        <!-- Student Profile View -->
                        <div class="row" id="profileView" style="display: none;">
                            <div class="col-12">
                                <div class="back-navigation">
                                    <button class="btn btn-outline-primary" onclick="showStudentView()">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Quay lại danh sách học sinh
                                    </button>
                                </div>

                                <!-- Student Profile Content -->
                                <div id="studentProfileContent">
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <!-- Loading Spinner -->
        <div class="loading-spinner" id="loadingSpinner" style="display: none;">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>

        <!-- Toast Container -->
        <div class="toast-container position-fixed top-0 end-0 p-3" id="toastContainer">
            <!-- Toasts will be added here -->
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageClasses.js"></script>
    </body>
</html>
