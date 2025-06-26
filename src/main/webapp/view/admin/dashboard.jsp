<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Hikari Learning</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <!-- Custom CSS -->
        <link href="${pageContext.request.contextPath}/assets/css/admin/mainDashboard.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Include Sidebar -->
                <%@ include file="sidebar.jsp" %>   

                <!-- Main Content -->
                <div class="main-content">
                    <div class="content-wrapper">
                        <!-- Header -->
                        <%@ include file="headerAdmin.jsp" %>

                        <!-- Dashboard Content -->
                        <div class="dashboard-content">
                            <div class="page-header">
                                <h1>Trang Chủ</h1>
                                <p>Tổng quan hệ thống quản lý</p>
                            </div>

                            <!-- Statistics Cards -->
                            <div class="row mb-4">
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="stat-icon users">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div class="stat-info">
                                            <h3>${totalUsers != null ? totalUsers : 0}</h3>
                                            <p>TỔNG NGƯỜI DÙNG</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="stat-icon courses">
                                            <i class="fas fa-book"></i>
                                        </div>
                                        <div class="stat-info">
                                            <h3>${totalCourses != null ? totalCourses : 0}</h3>
                                            <p>TỔNG KHÓA HỌC</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="stat-icon payments">
                                            <i class="fas fa-credit-card"></i>
                                        </div>
                                        <div class="stat-info">
                                            <h3>${totalPayments != null ? totalPayments : 0}</h3>
                                            <p>TỔNG THANH TOÁN</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="stat-card">
                                        <div class="stat-icon reviews">
                                            <i class="fas fa-star"></i>
                                        </div>
                                        <div class="stat-info">
                                            <h3>${totalReviews != null ? totalReviews : 0}</h3>
                                            <p>TỔNG ĐÁNH GIÁ</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Charts -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="chart-container">
                                        <h5 class="mb-4">Tăng Trưởng Người Dùng Theo Tháng</h5>
                                        <canvas id="userGrowthChart"></canvas>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="chart-container">
                                        <h5 class="mb-4">Doanh Thu Theo Tháng</h5>
                                        <canvas id="revenueChart"></canvas>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Data Sections -->
                            <div class="row mb-4">
                                <!-- Left Column (6/12) - Collapsible Recent Data Sections -->
                                <div class="col-md-6">
                                    <!-- Recent Courses -->
                                    <div class="course-section-container collapsible-section">
                                        <div class="section-header" >
                                            <div data-bs-toggle="collapse" data-bs-target="#recentCoursesContent" aria-expanded="false">
                                                <h5><i class="fas fa-book"></i> Khóa Học Gần Đây</h5>
                                            </div>
                                            <div class="header-actions">
                                                <a href="${pageContext.request.contextPath}/admin/courses" class="view-all">Xem tất cả</a>
                                                <i class="fas fa-chevron-down toggle-icon" data-bs-toggle="collapse" data-bs-target="#recentCoursesContent" aria-expanded="false"></i>
                                            </div>
                                        </div>
                                        <div class="collapse" id="recentCoursesContent">
                                            <div class="recent-items">
                                                <div class="row">
                                                    <c:choose>
                                                        <c:when test="${not empty recentCourses}">
                                                            <c:forEach var="course" items="${recentCourses}" varStatus="loop" end="1">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${course.title}</h6>
                                                                        <p><strong>Giá:</strong> <fmt:formatNumber value="${course.fee}" type="currency" currencySymbol="₫"/></p>
                                                                        <span class="status-badge ${course.isActive ? 'active' : 'inactive'}">
                                                                            ${course.isActive ? 'Hoạt động' : 'Không hoạt động'}
                                                                        </span>
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <i class="fas fa-calendar-alt"></i>
                                                                        <fmt:formatDate value="${course.startDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="no-data">
                                                                <i class="fas fa-inbox" style="font-size: 2rem; margin-bottom: 10px; color: #ccc;"></i>
                                                                <p>Không có dữ liệu khóa học</p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Recent Users -->
                                    <div class="course-section-container collapsible-section">
                                        <div class="section-header" >
                                            <div data-bs-toggle="collapse" data-bs-toggle="collapse" data-bs-target="#recentUsersContent" aria-expanded="false">
                                                <h5><i class="fas fa-users"></i> Người Dùng Mới</h5>
                                            </div>
                                            <div class="header-actions">
                                                <a href="${pageContext.request.contextPath}/admin/users" class="view-all">Xem tất cả</a>
                                                <i class="fas fa-chevron-down toggle-icon" data-bs-toggle="collapse" data-bs-target="#recentUsersContent" aria-expanded="false"></i>
                                            </div>
                                        </div>
                                        <div class="collapse" id="recentUsersContent">
                                            <div class="recent-items">
                                                <div class="row">
                                                    <c:choose>
                                                        <c:when test="${not empty recentUsers}">
                                                            <c:forEach var="user" items="${recentUsers}" varStatus="loop" end="1">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${user.fullName}</h6>
                                                                        <p><strong>Email:</strong> ${user.email}</p>
                                                                        <span class="role-badge ${user.role.toLowerCase()}">${user.role}</span>
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <i class="fas fa-user-plus"></i>
                                                                        <fmt:formatDate value="${user.registrationDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="no-data">
                                                                <i class="fas fa-user-slash" style="font-size: 2rem; margin-bottom: 10px; color: #ccc;"></i>
                                                                <p>Không có dữ liệu người dùng</p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Recent Payments -->
                                    <div class="course-section-container collapsible-section">
                                        <div class="section-header">
                                            <div data-bs-toggle="collapse" data-bs-target="#recentPaymentsContent" aria-expanded="false">
                                                <h5><i class="fas fa-credit-card"></i> Thanh Toán Gần Đây</h5>
                                            </div>
                                            <div class="header-actions">
                                                <a href="${pageContext.request.contextPath}/admin/payments" class="view-all">Xem tất cả</a>
                                                <i class="fas fa-chevron-down toggle-icon" data-bs-toggle="collapse" data-bs-target="#recentPaymentsContent" aria-expanded="false"></i>
                                            </div>
                                        </div>
                                        <div class="collapse" id="recentPaymentsContent">
                                            <div class="recent-items">
                                                <div class="row">
                                                    <c:choose>
                                                        <c:when test="${not empty recentPayments}">
                                                            <c:forEach var="payment" items="${recentPayments}" varStatus="loop" end="1">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${payment.studentName}</h6>
                                                                        <p><strong>Khóa học:</strong> ${payment.courseName}</p>
                                                                        <span class="payment-amount">
                                                                            <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫"/>
                                                                        </span>
                                                                        <span class="status-badge ${payment.paymentStatus.toLowerCase()}">
                                                                            ${payment.paymentStatus}
                                                                        </span>
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <i class="fas fa-money-bill-wave"></i>
                                                                        <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="no-data">
                                                                <i class="fas fa-receipt" style="font-size: 2rem; margin-bottom: 10px; color: #ccc;"></i>
                                                                <p>Không có dữ liệu thanh toán</p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Recent Notifications -->
                                    <div class="course-section-container collapsible-section">
                                        <div class="section-header">
                                            <div data-bs-toggle="collapse" data-bs-target="#recentNotificationsContent" aria-expanded="false">
                                                <h5><i class="fas fa-bell"></i> Thông Báo Gần Đây</h5>                                                
                                            </div>
                                            <div class="header-actions">
                                                <a href="${pageContext.request.contextPath}/admin/notifications" class="view-all">Xem tất cả</a>
                                                <i class="fas fa-chevron-down toggle-icon" data-bs-toggle="collapse" data-bs-target="#recentNotificationsContent" aria-expanded="false"></i>
                                            </div>
                                        </div>
                                        <div class="collapse" id="recentNotificationsContent">
                                            <div class="recent-items">
                                                <div class="row">
                                                    <c:choose>
                                                        <c:when test="${not empty recentNotifications}">
                                                            <c:forEach var="notification" items="${recentNotifications}" varStatus="loop" end="1">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${notification.title}</h6>
                                                                        <p>${notification.content}</p>
                                                                        ${notification.status}
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <i class="fas fa-clock"></i>
                                                                        <fmt:formatDate value="${notification.postedDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="no-data">
                                                                <i class="fas fa-bell-slash" style="font-size: 2rem; margin-bottom: 10px; color: #ccc;"></i>
                                                                <p>Không có dữ liệu thông báo</p>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Right Column (6/12) - Overview Chart -->
                                <div class="col-md-6">
                                    <div class="chart-container overview-chart-container">
                                        <div class="section-header">
                                            <h5><i class="fas fa-chart-pie"></i> Tổng Quan Hệ Thống</h5>
                                        </div>
                                        <div class="chart-content">
                                            <div class="chart-wrapper position-relative">
                                                <canvas id="overviewChart"></canvas>
                                                <div class="chart-center-text" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); text-align: center;">
                                                    <div class="center-value" id="centerValue">
                                                        <fmt:formatNumber value="${totalUsers + totalCourses + totalPayments + totalReviews}" pattern="#,###"/>
                                                    </div>
                                                    <div class="center-label">Tổng Cộng</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="chart-legend">
                                            <div class="legend-item">
                                                <span class="legend-color" style="background: #3498db;"></span>
                                                <span class="legend-text">Người Dùng</span>
                                                <span class="legend-value">${totalUsers != null ? totalUsers : 0}</span>
                                            </div>
                                            <div class="legend-item">
                                                <span class="legend-color" style="background: #27ae60;"></span>
                                                <span class="legend-text">Khóa Học</span>
                                                <span class="legend-value">${totalCourses != null ? totalCourses : 0}</span>
                                            </div>
                                            <div class="legend-item">
                                                <span class="legend-color" style="background: #f39c12;"></span>
                                                <span class="legend-text">Thanh Toán</span>
                                                <span class="legend-value">${totalPayments != null ? totalPayments : 0}</span>
                                            </div>
                                            <div class="legend-item">
                                                <span class="legend-color" style="background: #e74c3c;"></span>
                                                <span class="legend-text">Đánh Giá</span>
                                                <span class="legend-value">${totalReviews != null ? totalReviews : 0}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Pass data from JSP to JavaScript -->
        <script>
            // Ensure data is valid JSON
            window.dashboardData = {
                monthlyStats: JSON.parse('${monthlyStats != null ? monthlyStats : "{}"}'),
                paymentStats: JSON.parse('${paymentStats != null ? paymentStats : "{}"}'),
                courseStats: JSON.parse('${courseStats != null ? courseStats : "{}"}'),
                overviewStats: JSON.parse('${overviewStats != null ? overviewStats : "{}"}'),
                overviewData: {
                    totalUsers: ${totalUsers != null ? totalUsers : 0},
                    totalCourses: ${totalCourses != null ? totalCourses : 0},
                    totalPayments: ${totalPayments != null ? totalPayments : 0},
                    totalReviews: ${totalReviews != null ? totalReviews : 0}
                }
            };

            // Log data for debugging
            console.log("Dashboard Data:", window.dashboardData);
        </script>

        <!-- Custom JavaScript -->
        <script src="${pageContext.request.contextPath}/assets/js/admin/mainDashboard.js"></script>
    </body>
</html>
