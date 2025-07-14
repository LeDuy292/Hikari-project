<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Học Viên - Lớp ${className}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/class-students.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <!-- Sidebar -->
        <jsp:include page="sidebarCoordinator.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <jsp:include page="headerCoordinator.jsp" />

            <!-- Content -->
            <div class="content-wrapper">
                <div class="page-header">
                    <h1 class="page-title">Danh Sách Học Viên - Lớp ${className}</h1>
                    <p class="page-subtitle">Quản lý học viên trong lớp học</p>
                </div>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <!-- Search and Filter Form -->
<!--                <div class="search-container">
                    <form action="${pageContext.request.contextPath}/ClassDetails" method="get">
                        <input type="hidden" name="classID" value="${classID}">
                        <div class="search-input-group">
                            <input type="text" class="search-input" name="search" placeholder="Tìm theo tên hoặc mã học viên" value="${param.search}">
                            <button type="submit" class="search-button">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>-->

                <!-- Student List -->
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="bg-light">
                            <tr>
                                <th>STT</th>
                                <th>Mã Học Viên</th>
                                <th>Tên Học Viên</th>
                                <th>Email</th>
                                <th>Ngày Tham Gia</th>
                                <th>Trạng Thái</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty listStudentOfClass}">
                                <tr>
                                    <td colspan="7" class="text-center">
                                        <div class="alert alert-warning">
                                            Không tìm thấy học viên nào.
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                            <c:forEach var="student" items="${listStudentOfClass}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${student.studentID}</td>
                                    <td>${student.studentName}</td>
                                    <td>${student.email != null ? student.email : 'N/A'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${student.enrollmentDate != null}">
                                                <fmt:formatDate value="${student.enrollmentDate}" pattern="dd/MM/yyyy" />
                                            </c:when>
                                            <c:otherwise>N/A</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${student.active ? 'bg-success' : 'bg-danger'}">
                                            ${student.active ? 'Đang học' : 'Ngừng học'}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/StudentDetails?studentID=${student.studentID}" class="action-button btn-view">
                                            <i class="fas fa-eye"></i> Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>