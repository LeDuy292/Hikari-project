<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Nhiệm vụ - Điều phối viên | HIKARI Japanese</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/coordinator_css/coordinator-task.css">
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="../coordinator/sidebarCoordinator.jsp" %>

        <div class="main-content">
            <!-- Include Header -->
            <%@ include file="../coordinator/headerCoordinator.jsp" %>

            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h1 class="page-title">
                            <i class="fas fa-tasks"></i>
                            Quản lý Nhiệm vụ
                        </h1>
                        <p class="page-subtitle">Giao và theo dõi nhiệm vụ cho giáo viên</p>
                    </div>
                    <button class="btn btn-primary btn-lg" data-bs-toggle="modal" data-bs-target="#createTaskModal">
                        <i class="fas fa-plus"></i>
                        Tạo nhiệm vụ mới
                    </button>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i>
                    ${sessionScope.successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:if>

            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i>
                    ${sessionScope.errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="errorMessage" scope="session" />
            </c:if>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card pending">
                    <div class="stat-header">
                        <span class="stat-title">Chờ duyệt</span>
                        <i class="fas fa-clock stat-icon"></i>
                    </div>
                    <div class="stat-value">${statistics.pending}</div>
                    <div class="stat-description">Nhiệm vụ đang chờ xử lý</div>
                </div>

                <div class="stat-card submitted">
                    <div class="stat-header">
                        <span class="stat-title">Chờ phê duyệt</span>
                        <i class="fas fa-eye stat-icon"></i>
                    </div>
                    <div class="stat-value">${statistics.submitted}</div>
                    <div class="stat-description">Nhiệm vụ đã nộp</div>
                </div>

                <div class="stat-card completed">
                    <div class="stat-header">
                        <span class="stat-title">Hoàn thành</span>
                        <i class="fas fa-check-circle stat-icon"></i>
                    </div>
                    <div class="stat-value">${statistics.completed}</div>
                    <div class="stat-description">Nhiệm vụ đã duyệt</div>
                </div>

                <div class="stat-card overdue">
                    <div class="stat-header">
                        <span class="stat-title">Quá hạn</span>
                        <i class="fas fa-exclamation-triangle stat-icon"></i>
                    </div>
                    <div class="stat-value">${statistics.overdue}</div>
                    <div class="stat-description">Nhiệm vụ quá hạn</div>
                </div>
            </div>

            <!-- Tasks Tabs -->
            <div class="tabs-container">
                <ul class="nav nav-tabs" id="taskTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="overview-tab" data-bs-toggle="tab" 
                                data-bs-target="#overview" type="button" role="tab">
                            <i class="fas fa-chart-pie"></i>
                            Tổng quan
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="pending-tab" data-bs-toggle="tab" 
                                data-bs-target="#pending" type="button" role="tab">
                            <i class="fas fa-clock"></i>
                            Chờ xử lý
                            <span class="badge bg-warning ms-1" id="pending-count">0</span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="submitted-tab" data-bs-toggle="tab" 
                                data-bs-target="#submitted" type="button" role="tab">
                            <i class="fas fa-eye"></i>
                            Chờ duyệt
                            <span class="badge bg-info ms-1" id="submitted-count">0</span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" 
                                data-bs-target="#reviews" type="button" role="tab">
                            <i class="fas fa-comment-dots"></i>
                            Đánh giá
                            <span class="badge bg-primary ms-1">${reviews.size()}</span>
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="taskTabsContent">
                    <!-- Overview Tab -->
                    <div class="tab-pane fade show active" id="overview" role="tabpanel">
                        <div class="row">
                            <div class="col-lg-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title">
                                            <i class="fas fa-tasks"></i>
                                            Nhiệm vụ gần đây
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <c:forEach var="task" items="${allTasks}" begin="0" end="4">
                                            <div class="recent-task-item">
                                                <div class="task-info">
                                                    <div class="task-type-icon ${task.courseID != null ? 'course' : 'test'}">
                                                        <i class="fas fa-${task.courseID != null ? 'book-open' : 'clipboard-check'}"></i>
                                                    </div>
                                                    <div class="task-details">
                                                        <h6 class="task-name">
                                                            ${task.courseID != null ? 'Quản lý Khóa học' : 'Tạo Bài Test'}
                                                        </h6>
                                                        <p class="task-teacher">${task.teacherName}</p>
                                                    </div>
                                                </div>
                                                <span class="badge task-status-${task.status.toLowerCase().replace(' ', '-')}">${task.status}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title">
                                            <i class="fas fa-star"></i>
                                            Đánh giá gần đây
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <c:forEach var="review" items="${reviews}" begin="0" end="4">
                                            <div class="recent-review-item">
                                                <div class="review-info">
                                                    <h6 class="review-title">${review.entityTitle}</h6>
                                                    <div class="review-rating">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                                        </c:forEach>
                                                        <span class="ms-1">(${review.rating}/5)</span>
                                                    </div>
                                                    <p class="review-author">bởi ${review.reviewerName}</p>
                                                </div>
                                                <span class="badge review-status-${review.reviewStatus}">${review.reviewStatus}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pending Tasks Tab -->
                    <div class="tab-pane fade" id="pending" role="tabpanel">
                        <div class="tasks-list">
                            <c:set var="pendingCount" value="0" />
                            <c:forEach var="task" items="${allTasks}">
                                <c:if test="${task.status == 'Assigned' || task.status == 'In Progress'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                    <div class="task-card ${task.courseID != null ? 'course' : 'test'}">
                                        <div class="task-header">
                                            <div class="task-title-section">
                                                <div class="task-type-icon">
                                                    <i class="fas fa-${task.courseID != null ? 'book-open' : 'clipboard-check'}"></i>
                                                </div>
                                                <div>
                                                    <h3 class="task-title">
                                                        ${task.courseID != null ? 'Quản lý Khóa học' : 'Tạo Bài Test'}
                                                    </h3>
                                                    <p class="task-subtitle">
                                                        ${task.courseID != null ? task.courseName : 'JLPT '.concat(task.jlptLevel)}
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="task-badges">
                                                <span class="badge task-status-${task.status.toLowerCase().replace(' ', '-')}">${task.status}</span>
                                                <c:if test="${task.overdue}">
                                                    <span class="badge bg-danger">
                                                        <i class="fas fa-exclamation-triangle"></i>
                                                        Quá hạn
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>

                                        <p class="task-description">${task.description}</p>

                                        <div class="task-meta">
                                            <div class="task-meta-item">
                                                <i class="fas fa-user"></i>
                                                <span>Giáo viên: ${task.teacherName}</span>
                                            </div>
                                            <div class="task-meta-item">
                                                <i class="fas fa-calendar"></i>
                                                <span>Hạn chót: <fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy" /></span>
                                            </div>
                                            <div class="task-meta-item">
                                                <i class="fas fa-clock"></i>
                                                <span>Giao ngày: <fmt:formatDate value="${task.assignedDate}" pattern="dd/MM/yyyy" /></span>
                                            </div>
                                        </div>

                                        <div class="task-actions">
                                            <button class="btn btn-outline-primary btn-sm" 
                                                    onclick="viewTaskDetail(${task.id})">
                                                <i class="fas fa-eye"></i>
                                                Xem chi tiết
                                            </button>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <c:if test="${pendingCount == 0}">
                                <div class="empty-state">
                                    <i class="fas fa-check-circle empty-state-icon"></i>
                                    <h3>Không có nhiệm vụ chờ xử lý</h3>
                                    <p>Tất cả nhiệm vụ đã được xử lý hoặc hoàn thành.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Submitted Tasks Tab -->
                    <div class="tab-pane fade" id="submitted" role="tabpanel">
                        <div class="tasks-list">
                            <c:set var="submittedCount" value="0" />
                            <c:forEach var="task" items="${allTasks}">
                                <c:if test="${task.status == 'Submitted'}">
                                    <c:set var="submittedCount" value="${submittedCount + 1}" />
                                    <div class="task-card ${task.courseID != null ? 'course' : 'test'}">
                                        <div class="task-header">
                                            <div class="task-title-section">
                                                <div class="task-type-icon">
                                                    <i class="fas fa-${task.courseID != null ? 'book-open' : 'clipboard-check'}"></i>
                                                </div>
                                                <div>
                                                    <h3 class="task-title">
                                                        ${task.courseID != null ? 'Quản lý Khóa học' : 'Tạo Bài Test'}
                                                    </h3>
                                                    <p class="task-subtitle">
                                                        ${task.courseID != null ? task.courseName : 'JLPT '.concat(task.jlptLevel)}
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="task-badges">
                                                <span class="badge task-status-submitted">${task.status}</span>
                                            </div>
                                        </div>

                                        <p class="task-description">${task.description}</p>

                                        <div class="task-meta">
                                            <div class="task-meta-item">
                                                <i class="fas fa-user"></i>
                                                <span>Giáo viên: ${task.teacherName}</span>
                                            </div>
                                            <div class="task-meta-item">
                                                <i class="fas fa-calendar"></i>
                                                <span>Hạn chót: <fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy" /></span>
                                            </div>
                                            <div class="task-meta-item">
                                                <i class="fas fa-clock"></i>
                                                <span>Giao ngày: <fmt:formatDate value="${task.assignedDate}" pattern="dd/MM/yyyy" /></span>
                                            </div>
                                        </div>

                                        <div class="task-actions">
                                            <button class="btn btn-outline-primary btn-sm" 
                                                    onclick="viewTaskDetail(${task.id})">
                                                <i class="fas fa-eye"></i>
                                                Xem chi tiết
                                            </button>
                                            <button class="btn btn-success btn-sm" 
                                                    onclick="approveTask(${task.id})">
                                                <i class="fas fa-check"></i>
                                                Duyệt
                                            </button>
                                            <button class="btn btn-danger btn-sm" 
                                                    onclick="rejectTask(${task.id})">
                                                <i class="fas fa-times"></i>
                                                Từ chối
                                            </button>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>

                            <c:if test="${submittedCount == 0}">
                                <div class="empty-state">
                                    <i class="fas fa-clock empty-state-icon"></i>
                                    <h3>Không có nhiệm vụ chờ duyệt</h3>
                                    <p>Các nhiệm vụ đã nộp sẽ hiển thị ở đây.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Reviews Tab -->
                    <div class="tab-pane fade" id="reviews" role="tabpanel">
                        <div class="reviews-list">
                            <c:forEach var="review" items="${reviews}">
                                <div class="review-card ${review.reviewStatus}">
                                    <div class="review-header">
                                        <div class="review-title-section">
                                            <i class="fas fa-comment-dots"></i>
                                            <div>
                                                <h3 class="review-title">${review.entityTitle}</h3>
                                                <p class="review-subtitle">
                                                    ${review.courseID != null ? 'Đánh giá Khóa học' : 'Đánh giá Bài Test'}
                                                </p>
                                            </div>
                                        </div>
                                        <span class="badge review-status-${review.reviewStatus}">${review.reviewStatus}</span>
                                    </div>

                                    <div class="review-rating">
                                        <span>Đánh giá:</span>
                                        <div class="stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="fas fa-star ${i <= review.rating ? 'text-warning' : 'text-muted'}"></i>
                                            </c:forEach>
                                        </div>
                                        <span>(${review.rating}/5)</span>
                                    </div>

                                    <div class="review-text">
                                        ${review.reviewText}
                                    </div>

                                    <div class="review-footer">
                                        <span><i class="fas fa-user"></i> Đánh giá bởi: ${review.reviewerName}</span>
                                        <span><i class="fas fa-clock"></i> <fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy HH:mm" /></span>
                                    </div>

                                    <c:if test="${review.reviewStatus == 'pending'}">
                                        <div class="review-actions">
                                            <button class="btn btn-success btn-sm">
                                                <i class="fas fa-check"></i>
                                                Phê duyệt
                                            </button>
                                            <button class="btn btn-danger btn-sm">
                                                <i class="fas fa-times"></i>
                                                Từ chối
                                            </button>
                                        </div>
                                    </c:if>
                                </div>
                            </c:forEach>

                            <c:if test="${reviews.size() == 0}">
                                <div class="empty-state">
                                    <i class="fas fa-comment-dots empty-state-icon"></i>
                                    <h3>Không có đánh giá</h3>
                                    <p>Các đánh giá từ học viên sẽ hiển thị ở đây.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Create Task Modal -->
        <div class="modal fade" id="createTaskModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-plus"></i>
                            Tạo nhiệm vụ mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/CoordinatorTask" method="post">
                        <input type="hidden" name="action" value="create">
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="teacherID" class="form-label">Giáo viên được giao *</label>
                                        <select class="form-select" id="teacherID" name="teacherID" required>
                                            <option value="">Chọn giáo viên</option>
                                            <c:forEach var="teacher" items="${teachers}">
                                                <option value="${teacher.teacherID}">
                                                    ${teacher.fullName} - ${teacher.specialization}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Loại nhiệm vụ *</label>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="taskType" 
                                                   id="courseTask" value="course" checked>
                                            <label class="form-check-label" for="courseTask">
                                                Hoàn thành học liệu cho khóa học
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="taskType" 
                                                   id="testTask" value="test">
                                            <label class="form-check-label" for="testTask">
                                                Hoàn thành bài kiểm tra
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3" id="courseSelection">
                                <label for="courseID" class="form-label">Chọn khóa học *</label>
                                <select class="form-select" id="courseID" name="courseID">
                                    <option value="">Chọn khóa học</option>
                                    <c:forEach var="course" items="${courses}">
                                        <option value="${course.courseID}">${course.title}</option>
                                    </c:forEach>
                                </select>
                                <div class="form-text">
                                    <i class="fas fa-info-circle"></i>
                                    Lưu ý: Khóa học sẽ được đặt trạng thái không hoạt động cho đến khi nhiệm vụ được phê duyệt.
                                </div>
                            </div>

                            <div class="mb-3" id="testSelection" style="display: none;">
                                <label for="testID" class="form-label">Chọn bài kiểm tra *</label>
                                <select class="form-select" id="testID" name="testID">
                                    <option value="">Chọn bài kiểm tra</option>
                                    <c:forEach var="test" items="${tests}">
                                        <option value="${test.id}">${test.title} - JLPT ${test.jlptLevel}</option>
                                    </c:forEach>
                                </select>
                                <!--                                <select class="form-select" id="testID" name="testID">
                                                                    <option value="">Chọn bài kiểm tra</option>
                                                                    <option value="JLPT_N1">JLPT N1</option>
                                                                    <option value="JLPT_N2">JLPT N2</option>
                                                                    <option value="JLPT_N3">JLPT N3</option>
                                                                    <option value="JLPT_N4">JLPT N4</option>
                                                                    <option value="JLPT_N5">JLPT N5</option>
                                                                    <option value="TEST_LEVEL">Test Level</option>
                                                                </select>-->
                                <div class="form-text">
                                    <i class="fas fa-info-circle"></i>
                                    Lưu ý: Trạng thái bài kiểm tra sẽ được cập nhật sau khi phê duyệt.
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">Mô tả nhiệm vụ *</label>
                                <textarea class="form-control" id="description" name="description" 
                                          rows="4" placeholder="Nhập chi tiết mô tả công việc..." required></textarea>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="deadline" class="form-label">Thời hạn hoàn thành *</label>
                                        <input type="date" class="form-control" id="deadline" name="deadline" 
                                               min="<fmt:formatDate value='<%=new java.util.Date()%>' pattern='yyyy-MM-dd'/>" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Ngày giao nhiệm vụ</label>
                                        <input type="text" class="form-control" 
                                               value="<fmt:formatDate value='<%=new java.util.Date()%>' pattern='dd/MM/yyyy'/>" 
                                               disabled>
                                        <div class="form-text">Tự động điền ngày hiện tại</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-plus"></i>
                                Tạo nhiệm vụ
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Task Detail Modal -->
        <div class="modal fade" id="taskDetailModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-eye"></i>
                            Chi tiết nhiệm vụ
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="taskDetailContent">
                        <!-- Content will be loaded via JavaScript -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Reject Task Modal -->
        <div class="modal fade" id="rejectTaskModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-times"></i>
                            Từ chối nhiệm vụ
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="${pageContext.request.contextPath}/CoordinatorTask" method="post">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="taskId" id="rejectTaskId">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="rejectReason" class="form-label">Lý do từ chối *</label>
                                <textarea class="form-control" id="rejectReason" name="rejectReason" 
                                          rows="4" placeholder="Nhập lý do từ chối nhiệm vụ..." required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-times"></i>
                                Từ chối
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/coordinator/coordinator-task.js"></script>

        <script>
                                                        // Update tab counts
                                                        document.getElementById('pending-count').textContent = '${pendingCount}';
                                                        document.getElementById('submitted-count').textContent = '${submittedCount}';
        </script>
    </body>
</html>
