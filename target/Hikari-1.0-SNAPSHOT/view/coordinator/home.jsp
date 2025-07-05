<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        <div class="main-content">
            <!-- Header -->
            <jsp:include page="headerCoordinator.jsp" />
            <!-- Content -->
            <div class="content-wrapper">
                <div class="row g-4">
                    <!-- Statistics Overview -->
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
                                    <p class="mb-1"><i class="fas fa-book text-primary me-2"></i>Tổng số khóa học: <span class="fw-semibold">50</span></p>
                                    <p class="mb-1"><i class="fas fa-check-circle text-success me-2"></i>Đang hoạt động: <span class="fw-semibold">45</span></p>
                                    <p class="mb-0"><i class="fas fa-history text-warning me-2"></i>Đang soạn thảo: <span class="fw-semibold">5</span></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Statistics Overview (Students) -->
                    <div class="col-lg-4">
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="bg-success bg-opacity-10 text-success rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 48px; height: 48px;">
                                        <i class="fas fa-users fa-lg"></i>
                                    </div>
                                    <div>
                                        <h5 class="card-title mb-0">Tổng quan giảng viên</h5>
                                        <p class="text-muted mb-0">Số lượng giảng viên đang hoạt động.</p>
                                    </div>
                                </div>
                                <div class="mt-4">
                                     <p class="mb-1"><i class="fas fa-user-graduate text-success me-2"></i>Tổng số giảng viên: <span class="fw-semibold">15</span></p>
                                    <p class="mb-0"><i class="fas fa-user-clock text-warning me-2"></i>Giảng viên nghỉ: <span class="fw-semibold">2</span></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Progress Report Sections -->
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
                                            <div class="stat-value">25</div>
                                            <div class="stat-trend positive">
                                                <i class="fas fa-arrow-up"></i> 5
                                            </div>
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
                                            <div class="stat-value">4</div>
                                            <div class="stat-trend positive">
                                                <i class="fas fa-arrow-up"></i> 2
                                            </div>
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
                                            <div class="stat-value">10</div>
                                            <div class="stat-trend positive">
                                                <i class="fas fa-arrow-up"></i> 3
                                            </div>
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
                                            <div class="stat-value">4</div>
                                            <div class="stat-trend positive">
                                                <i class="fas fa-arrow-up"></i> 1
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Course Progress -->
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">Tiến độ khóa học</h5>
                                <div class="d-flex gap-2">
                                    <select class="form-select form-select-sm" style="width: auto;">
                                        <option value="all">Tất cả khóa học</option>
                                        <option value="active">Đang diễn ra</option>
                                        <option value="completed">Đã hoàn thành</option>
                                    </select>
                                    <button class="btn btn-primary btn-sm">
                                        <i class="fas fa-download me-1"></i>Xuất báo cáo
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <%-- Course Progress Buttons --%>
                                <div class="list-group">
                                    <button type="button" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#classProgressModal" data-bs-course-title="JLPT N1">
                                        Tiến độ JLPT N1
                                    </button>
                                     <button type="button" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#classProgressModal" data-bs-course-title="JLPT N2">
                                        Tiến độ JLPT N2
                                    </button>
                                     <button type="button" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#classProgressModal" data-bs-course-title="JLPT N3">
                                        Tiến độ JLPT N3
                                    </button>
                                     <button type="button" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#classProgressModal" data-bs-course-title="JLPT N4">
                                        Tiến độ JLPT N4
                                    </button>
                                     <button type="button" class="list-group-item list-group-item-action" data-bs-toggle="modal" data-bs-target="#classProgressModal" data-bs-course-title="JLPT N5">
                                        Tiến độ JLPT N5
                                    </button>
                                     <%-- Add more buttons for other courses --%>
                                </div>
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
                                    <!-- Activity Item -->
                                    <div class="activity-item">
                                        <div class="activity-icon">
                                            <i class="fas fa-graduation-cap"></i>
                                        </div>
                                        <div class="activity-info">
                                            <p class="activity-text">Khóa học JLPT N1 đã hoàn thành 80%</p>
                                            <span class="activity-time">3 giờ trước</span>
                                        </div>
                                    </div>
                                    <!-- Activity Item -->
                                    <div class="activity-item">
                                        <div class="activity-icon">
                                            <i class="fas fa-user-plus"></i>
                                        </div>
                                        <div class="activity-info">
                                            <p class="activity-text">Thêm 8 học viên mới vào khóa JLPT N3</p>
                                            <span class="activity-time">6 giờ trước</span>
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

    <!-- Class Progress Modal -->
    <div class="modal fade" id="classProgressModal" tabindex="-1" aria-labelledby="classProgressModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="classProgressModalLabel">Tiến độ lớp học: <span id="modalCourseTitle"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="classProgressList">
                        <%-- Example class progress items (replace with dynamic data) --%>
                        <div class="progress-item mb-3">
                            <div class="progress-info d-flex justify-content-between mb-1">
                                <h6 class="progress-title mb-0">Lớp [Tên lớp]</h6>
                                <span class="progress-percentage">[X]% hoàn thành</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar" role="progressbar" aria-valuenow="[X]" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                         <div class="progress-item mb-3">
                            <div class="progress-info d-flex justify-content-between mb-1">
                                <h6 class="progress-title mb-0">Lớp [Tên lớp khác]</h6>
                                <span class="progress-percentage">[Y]% hoàn thành</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar" role="progressbar" aria-valuenow="[Y]" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </div>
                        <%-- Add more class progress items as needed --%>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        var classProgressModal = document.getElementById('classProgressModal');
        classProgressModal.addEventListener('show.bs.modal', function (event) {
            // Button that triggered the modal
            var button = event.relatedTarget;
            // Extract info from data-bs-whatever attributes
            var courseTitle = button.getAttribute('data-bs-course-title');
            // Update the modal's content.
            var modalTitle = classProgressModal.querySelector('.modal-title span');
            modalTitle.textContent = courseTitle;
            
            // In a real application, you would fetch class progress data for this course
            // and populate the #classProgressList div dynamically.
        });
    </script>
</body>
</html>