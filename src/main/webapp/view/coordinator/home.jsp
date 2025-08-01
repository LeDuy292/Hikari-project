<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Chủ - Coordinator Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/dashboard.css" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex">
            <!-- Sidebar -->
            <jsp:include page="sidebarCoordinator.jsp" />
            <!-- Main Content -->
            <div class="main-content flex-grow-1">
                <!-- Header -->
                <jsp:include page="headerCoordinator.jsp" />
                <!-- Content -->
                <div class="content-wrapper p-4">
                    <div class="row g-4">
                        <!-- Statistics Cards -->
                        <div class="col-12">
                            <div class="row g-4">
                                <div class="col-md-3">
                                    <div class="card stat-card">
                                        <div class="card-body">
                                            <div class="stat-icon">
                                                <i class="fas fa-graduation-cap"></i>
                                            </div>
                                            <div class="stat-info">
                                                <h6 class="stat-title">Tổng số lớp học</h6>
                                                <div class="stat-value">${totalClasses}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="card stat-card">
                                        <div class="card-body">
                                            <div class="stat-icon">
                                                <i class="fas fa-users"></i>
                                            </div>
                                            <div class="stat-info">
                                                <h6 class="stat-title">Số lớp chưa đủ học viên</h6>
                                                <div class="stat-value">${lowEnrollmentClasses}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="card stat-card">
                                        <div class="card-body">
                                            <div class="stat-icon">
                                                <i class="fas fa-chart-line"></i>
                                            </div>
                                            <div class="stat-info">
                                                <h6 class="stat-title">Số giảng viên đang giảng dạy</h6>
                                                <div class="stat-value">${teachingTeachers}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="card stat-card">
                                        <div class="card-body">
                                            <div class="stat-icon">
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <div class="stat-info">
                                                <h6 class="stat-title">Số lớp sắp kết thúc</h6>
                                                <div class="stat-value">${classesEndingSoon}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Statistics Overview (Courses) -->
                        <div class="col-lg-8">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 48px; height: 48px;">
                                            <i class="fas fa-graduation-cap fa-lg"></i>
                                        </div>
                                        <div>
                                            <h5 class="card-title mb-0">Tổng quan Khóa học</h5>
                                            <p class="text-muted mb-0">Tổng số khóa học hiện có và trạng thái.</p>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <p class="mb-1"><i class="fas fa-book text-primary me-2"></i>Tổng số khóa học: <span class="fw-semibold">${totalCourses}</span></p>
                                        <p class="mb-1"><i class="fas fa-check-circle text-success me-2"></i>Đang hoạt động: <span class="fw-semibold">${activeCourses}</span></p>
                                        <p class="mb-0"><i class="fas fa-history text-warning me-2"></i>Đang soạn thảo: <span class="fw-semibold">${draftCourses}</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Statistics Overview (Teachers) -->
                        <div class="col-lg-4">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 48px; height: 48px;">
                                            <i class="fas fa-users fa-lg"></i>
                                        </div>
                                        <div>
                                            <h5 class="card-title mb-0">Tổng quan Giảng viên</h5>
                                            <p class="text-muted mb-0">Số lượng giảng viên đang hoạt động.</p>
                                        </div>
                                    </div>
                                    <div class="mt-4">
                                        <p class="mb-1"><i class="fas fa-user-graduate text-success me-2"></i>Tổng số giảng viên: <span class="fw-semibold">${totalTeachers}</span></p>
                                        <p class="mb-0"><i class="fas fa-user-clock text-warning me-2"></i>Giảng viên nghỉ: <span class="fw-semibold">${inactiveTeachers}</span></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Course Progress -->
                        <div class="col-md-8">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Tiến độ</h5>
                            </div>
                            <div class="card">
                                <div class="card-body">
                                    <div class="list-group">
                                        <c:forEach var="courseTitle" items="${courseTitles}">
                                            <a href="#"
                                               class="list-group-item list-group-item-action">
                                                Tiến độ ${courseTitle}
                                            </a>
                                        </c:forEach>
                                    </div>
                                    <!-- Pagination Controls -->
                                    <c:if test="${totalPages > 1}">
                                        <nav aria-label="Course pagination" class="mt-3">
                                            <ul class="pagination justify-content-center">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/LoadDashboard?filter=${param.filter}&page=${currentPage - 1}" aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                                <c:forEach begin="1" end="${totalPages}" var="i">
                                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                        <a class="page-link" href="${pageContext.request.contextPath}/LoadDashboard?filter=${param.filter}&page=${i}">${i}</a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="${pageContext.request.contextPath}/LoadDashboard?filter=${param.filter}&page=${currentPage + 1}" aria-label="Next">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Activities -->
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Hoạt động gần đây</h5>
                                </div>
                                <div class="card-body">
                                    <div class="activity-list">
                                        <c:forEach var="activity" items="${recentActivities}">
                                            <div class="activity-item d-flex">
                                                <div class="activity-icon me-3">
                                                    <i class="fas fa-info-circle"></i>
                                                </div>
                                                <div class="activity-info">
                                                    <p class="activity-text mb-1">${activity.title}</p>
                                                    <span class="time-ago text-muted">
                                                        <fmt:formatDate value="${activity.postedDate}" pattern="MMM dd, yyyy HH:mm"/>
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function updateCourseList() {
                const filter = document.getElementById('courseFilter').value;
                window.location.href = '${pageContext.request.contextPath}/LoadDashboard?filter=' + filter + '&page=1';
            }

            document.addEventListener('DOMContentLoaded', function () {
            <c:if test="${not empty errorMessage}">
                alert('${errorMessage}');
            </c:if>
            });
        </script>
    </body>
</html>