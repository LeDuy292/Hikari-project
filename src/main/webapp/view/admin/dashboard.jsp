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
                            <h1>Dashboard</h1>
                            <p>Tổng quan hệ thống quản lý</p>
                        </div>


                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="icon users">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div>
                                        <h6 class="card-subtitle mb-2">TỔNG NGƯỜI DÙNG</h6>
                                        <h3 class="card-title">${totalUsers != null ? totalUsers : 0}</h3>
                                        <small class="growth text-muted">
                                            <i class="fas fa-arrow-up"></i> Tổng số
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="icon courses">
                                        <i class="fas fa-book"></i>
                                    </div>
                                    <div>
                                        <h6 class="card-subtitle mb-2">TỔNG KHÓA HỌC</h6>
                                        <h3 class="card-title">${totalCourses != null ? totalCourses : 0}</h3>
                                        <small class="growth text-muted">
                                            <i class="fas fa-arrow-up"></i> Tổng số
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="icon materials">
                                        <i class="fas fa-credit-card"></i>
                                    </div>
                                    <div>
                                        <h6 class="card-subtitle mb-2">TỔNG THANH TOÁN</h6>
                                        <h3 class="card-title">${totalPayments != null ? totalPayments : 0}</h3>
                                        <small class="growth text-success">
                                            <i class="fas fa-arrow-up"></i> Tổng số
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="icon tests">
                                        <i class="fas fa-star"></i>
                                    </div>
                                    <div>
                                        <h6 class="card-subtitle mb-2">TỔNG ĐÁNH GIÁ</h6>
                                        <h3 class="card-title">${totalReviews != null ? totalReviews : 0}</h3>
                                        <small class="growth text-success">
                                            <i class="fas fa-arrow-up"></i> Tổng số
                                        </small>
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
                            <!-- Recent Courses -->
                            <div class="col-md-12">
                                <div class="course-section-container">
                                    <div class="course-section">
                                        <div class="section-header">
                                            <h5>Khóa Học Gần Đây</h5>
                                            <a href="${pageContext.request.contextPath}/admin/courses" class="view-all">Xem tất cả</a>
                                        </div>
                                        <div class="recent-items">
                                            <div class="row">
                                                <c:choose>
                                                    <c:when test="${not empty recentCourses}">
                                                        <c:forEach var="course" items="${recentCourses}" varStatus="loop" end="3">
                                                            <div class="col-md-3">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${course.title}</h6>
                                                                        <p><fmt:formatNumber value="${course.fee}" type="currency" currencySymbol="₫"/></p>
                                                                        <span class="status-badge ${course.isActive ? 'active' : 'inactive'}">
                                                                            ${course.isActive ? 'Hoạt động' : 'Không hoạt động'}
                                                                        </span>
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <fmt:formatDate value="${course.startDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="no-data">Không có dữ liệu khóa học</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Users -->
                            <div class="col-md-12">
                                <div class="course-section-container">
                                    <div class="course-section">
                                        <div class="section-header">
                                            <h5>Người Dùng Mới</h5>
                                            <a href="${pageContext.request.contextPath}/admin/users" class="view-all">Xem tất cả</a>
                                        </div>
                                        <div class="recent-items">
                                            <div class="row">
                                                <c:choose>
                                                    <c:when test="${not empty recentUsers}">
                                                        <c:forEach var="user" items="${recentUsers}" varStatus="loop" end="3">
                                                            <div class="col-md-3">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${user.fullName}</h6>
                                                                        <p>${user.email}</p>
                                                                        <span class="role-badge ${user.role.toLowerCase()}">${user.role}</span>
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <fmt:formatDate value="${user.registrationDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="no-data">Không có dữ liệu người dùng</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Payments -->
                            <div class="col-md-12">
                                <div class="course-section-container">
                                    <div class="course-section">
                                        <div class="section-header">
                                            <h5>Thanh Toán Gần Đây</h5>
                                            <a href="${pageContext.request.contextPath}/admin/payments" class="view-all">Xem tất cả</a>
                                        </div>
                                        <div class="recent-items">
                                            <div class="row">
                                                <c:choose>
                                                    <c:when test="${not empty recentPayments}">
                                                        <c:forEach var="payment" items="${recentPayments}" varStatus="loop" end="3">
                                                            <div class="col-md-3">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${payment.studentName}</h6>
                                                                        <p>${payment.courseName}</p>
                                                                        <span class="payment-amount">
                                                                            <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫"/>
                                                                        </span>
                                                                        <span class="status-badge ${payment.paymentStatus.toLowerCase()}">
                                                                            ${payment.paymentStatus}
                                                                        </span>
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="no-data">Không có dữ liệu thanh toán</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Reviews -->
                            <div class="col-md-12">
                                <div class="course-section-container">
                                    <div class="course-section">
                                        <div class="section-header">
                                            <h5>Đánh Giá Gần Đây</h5>
                                            <a href="${pageContext.request.contextPath}/admin/reviews" class="view-all">Xem tất cả</a>
                                        </div>
                                        <div class="recent-items">
                                            <div class="row">
                                                <c:choose>
                                                    <c:when test="${not empty recentReviews}">
                                                        <c:forEach var="review" items="${recentReviews}" varStatus="loop" end="3">
                                                            <div class="col-md-3">
                                                                <div class="recent-item">
                                                                    <div class="item-info">
                                                                        <h6>${review.reviewerName}</h6>
                                                                        <p>${review.courseName}</p>
                                                                        <div class="rating">
                                                                            <c:forEach begin="1" end="5" var="i">
                                                                                <i class="fas fa-star ${i <= review.rating ? 'filled' : ''}"></i>
                                                                            </c:forEach>
                                                                        </div>
                                                                        <p class="review-text">${review.reviewText}</p>
                                                                    </div>
                                                                    <div class="item-date">
                                                                        <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p class="no-data">Không có dữ liệu đánh giá</p>
                                                    </c:otherwise>
                                                </c:choose>
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
    </div>
                                        
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Pass data from JSP to JavaScript -->
    <script>
        // Ensure data is valid JSON
        window.dashboardData = {
            monthlyStats: JSON.parse('${monthlyStats != null ? monthlyStats : "{}"}'),
            paymentStats: JSON.parse('${paymentStats != null ? paymentStats : "{}"}'),
            courseStats: JSON.parse('${courseStats != null ? courseStats : "{}"}')
        };
        
        // Log data for debugging
        console.log("Dashboard Data:", window.dashboardData);
    </script>
    
    <!-- Custom JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/admin/mainDashboard.js"></script>
</body>
</html>