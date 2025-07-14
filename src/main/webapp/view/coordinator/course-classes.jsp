<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lớp Học - Coordinator Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/course-classes.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <!-- Sidebar -->
        <jsp:include page="sidebarCoordinator.jsp" />

        <div class="main-content">
            <!-- Header -->
            <jsp:include page="headerCoordinator.jsp" />

            <div class="content-wrapper">
                <div class="page-header">
                    <h1 class="page-title">Danh Sách Lớp Học</h1>
                    <p class="page-subtitle">Quản lý và xem thông tin các lớp học</p>
                </div>

                <!-- Set Current Date -->
                <c:set var="now" value="<%= new java.util.Date() %>"/>

                <!-- Error Message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <!-- Search and Filter Form -->
<!--                <div class="search-container">
                    <form action="${pageContext.request.contextPath}/LoadClass" method="get">
                        <div class="search-input-group">
                            <input type="text" class="search-input" name="teacherID" placeholder="Mã giảng viên (VD: T001)" value="${param.teacherID}">
                            <input type="text" class="search-input" name="courseID" placeholder="Mã khóa học (VD: CO001)" value="${param.courseID}">
                            <button type="submit" class="search-button">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>-->

                <!-- Class List -->
                <c:forEach var="classInfo" items="${listClass}">
                    <div class="class-card">
                        <div class="class-header">
                            <h3 class="class-name">${classInfo.name}</h3>
                            <span class="class-status ${classInfo.endDate >= now ? 'status-active' : 'status-inactive'}">
                                ${classInfo.endDate >= now ? 'Đang hoạt động' : 'Đã kết thúc'}
                            </span>
                        </div>
                        <div class="class-info">
                            <div class="info-item">
                                <span class="info-icon"><i class="fas fa-book"></i></span>
                                <div class="info-content">
                                    <span class="info-label">Khóa học</span>
                                    <span class="info-value">${classInfo.courseTitle}</span>
                                </div>
                            </div>
                            <div class="info-item">
                                <span class="info-icon"><i class="fas fa-chalkboard-teacher"></i></span>
                                <div class="info-content">
                                    <span class="info-label">Giảng viên</span>
                                    <span class="info-value">${classInfo.teacherName != null ? classInfo.teacherName : 'Chưa phân công'}</span>
                                </div>
                            </div>
                            <div class="info-item">
                                <span class="info-icon"><i class="fas fa-users"></i></span>
                                <div class="info-content">
                                    <span class="info-label">Số học viên</span>
                                    <span class="info-value">${classInfo.numberOfStudents}</span>
                                </div>
                            </div>
                            <div class="info-item">
                                <span class="info-icon"><i class="fas fa-calendar-alt"></i></span>
                                <div class="info-content">
                                    <span class="info-label">Ngày bắt đầu</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${classInfo.startDate}" pattern="dd/MM/yyyy" />
                                    </span>
                                </div>
                            </div>
                            <div class="info-item">
                                <span class="info-icon"><i class="fas fa-calendar-check"></i></span>
                                <div class="info-content">
                                    <span class="info-label">Ngày kết thúc</span>
                                    <span class="info-value">
                                        <fmt:formatDate value="${classInfo.endDate}" pattern="dd/MM/yyyy" />
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="class-actions">
                            <a href="${pageContext.request.contextPath}/ClassDetails?classID=${classInfo.classID}" class="action-button btn-view">
                                <i class="fas fa-eye"></i> Xem chi tiết
                            </a>
                        </div>
                    </div>
                </c:forEach>

                <!-- No Classes Message -->
                <c:if test="${empty listClass}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> Không tìm thấy lớp học nào.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>