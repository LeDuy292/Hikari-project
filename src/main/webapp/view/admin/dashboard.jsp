<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Admin Dashboard - Nền Tảng Giáo Dục</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <!-- Google Fonts for Elegant Font -->
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
                        <c:set var="pageTitle" value="Dashboard" scope="request"/>
						<jsp:include page="headerAdmin.jsp">
						    <jsp:param name="pageTitle" value="Dashboard"/>
						    <jsp:param name="showAddButton" value="false"/>
						    <jsp:param name="showNotification" value="false"/>
						</jsp:include>

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="icon users">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div>
                                        <h6 class="card-subtitle mb-2">TỔNG SỐ NGƯỜI DÙNG</h6>
                                        <h5 class="card-title">17</h5>
                                        <small class="growth text-muted">
                                            <i class="fas fa-arrow-up"></i> 0%
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
                                        <h6 class="card-subtitle mb-2">TỔNG SỐ KHÓA HỌC</h6>
                                        <h5 class="card-title">5</h5>
                                        <small class="growth text-muted">
                                            <i class="fas fa-arrow-up"></i> 0%
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="icon materials">
                                        <i class="fas fa-file-alt"></i>
                                    </div>
                                    <div>
                                        <h6 class="card-subtitle mb-2">TỔNG SỐ TÀI LIỆU</h6>
                                        <h5 class="card-title">46</h5>
                                        <small class="growth text-success">
                                            <i class="fas fa-arrow-up"></i> +3.7%
                                        </small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="icon tests">
                                        <i class="fas fa-check-square"></i>
                                    </div>
                                    <div>
                                        <h6 class="card-subtitle mb-2">BÀI KIỂM TRA ĐÃ TẠO</h6>
                                        <h5 class="card-title">8</h5>
                                        <small class="growth text-success">
                                            <i class="fas fa-arrow-up"></i> +1.8%
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Charts -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="chart-container">
                                    <h5 class="mb-4">Tăng Trưởng Người Dùng</h5>
                                    <canvas id="userGrowthChart"></canvas>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="chart-container">
                                    <h5 class="mb-4">Tổng Doanh Thu Theo Tháng</h5>
                                    <canvas id="revenueChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Courses Section -->
                        <div class="course-section">
                            <h5>Khóa Học Gần Đây</h5>
                            <div class="course-grid">
                                <!-- Course Card 1 -->
                                <div class="course-card" data-id="CRS001">
                                    <img src="${pageContext.request.contextPath}/img/courses/Japanese-N1.jpg" alt="Tiếng Nhật N1" />
                                    <div class="course-info">
                                        <h6>Tiếng Nhật N1</h6>
                                        <p><strong>Giảng viên:</strong> Nguyễn Văn A</p>
                                        <p><strong>Học viên:</strong> 25</p>
                                        <p><span class="badge badge-success">Đang Mở</span></p>
                                    </div>
                                    <div class="tooltip">Xem Chi Tiết</div>
                                </div>
                                <!-- Course Card 2 -->
                                <div class="course-card" data-id="CRS002">
                                    <img src="${pageContext.request.contextPath}/img/courses/Japanese-N2.png" alt="Tiếng Nhật N2" />
                                    <div class="course-info">
                                        <h6>Tiếng Nhật N2</h6>
                                        <p><strong>Giảng viên:</strong> Trần Thị B</p>
                                        <p><strong>Học viên:</strong> 18</p>
                                        <p><span class="badge badge-warning">Sắp Khai Giảng</span></p>
                                    </div>
                                    <div class="tooltip">Xem Chi Tiết</div>
                                </div>
                                <!-- Course Card 3 -->
                                <div class="course-card" data-id="CRS003">
                                    <img src="${pageContext.request.contextPath}/img/courses/Japanese-N3.png" alt="Tiếng Nhật N3" />
                                    <div class="course-info">
                                        <h6>Tiếng Nhật N3</h6>
                                        <p><strong>Giảng viên:</strong> Lê Văn C</p>
                                        <p><strong>Học viên:</strong> 30</p>
                                        <p><span class="badge badge-success">Đang Mở</span></p>
                                    </div>
                                    <div class="tooltip">Xem Chi Tiết</div>
                                </div>
                                <!-- Course Card 4 -->
                                <div class="course-card" data-id="CRS004">
                                    <img src="${pageContext.request.contextPath}/img/courses/Japanese-N4.jpg" alt="Tiếng Nhật N4" />
                                    <div class="course-info">
                                        <h6>Tiếng Nhật N4</h6>
                                        <p><strong>Giảng viên:</strong> Phạm Thị D</p>
                                        <p><strong>Học viên:</strong> 15</p>
                                        <p><span class="badge badge-success">Đang Mở</span></p>
                                    </div>
                                    <div class="tooltip">Xem Chi Tiết</div>
                                </div>
                                <!-- Course Card 5 -->
                                <div class="course-card" data-id="CRS005">
                                    <img src="${pageContext.request.contextPath}/img/courses/Japanese-N5.jpg" alt="Tiếng Nhật N5" />
                                    <div class="course-info">
                                        <h6>Tiếng Nhật N5</h6>
                                        <p><strong>Giảng viên:</strong> Hoàng Văn E</p>
                                        <p><strong>Học viên:</strong> 22</p>
                                        <p><span class="badge badge-success">Đang Mở</span></p>
                                    </div>
                                    <div class="tooltip">Xem Chi Tiết</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Chart.js Initialization -->
        <script src="${pageContext.request.contextPath}/assets/js/admin/mainDashboard.js"></script>
    </body>
</html>
