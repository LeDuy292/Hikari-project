<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Nhiệm vụ - HIKARI Japanese</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/task.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/notifications.css">
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="sidebar.jsp" %>

        <div class="main-content">
            <!-- Include Header -->
            <%@ include file="header.jsp" %>        
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card incomplete">
                    <div class="stat-header">
                        <span class="stat-title">Nhiệm vụ chưa hoàn thành</span>
                        <i class="fas fa-clock stat-icon"></i>
                    </div>
                    <div class="stat-value">${statistics[0]}</div>
                </div>

                <div class="stat-card completed">
                    <div class="stat-header">
                        <span class="stat-title">Nhiệm vụ hoàn thành</span>
                        <i class="fas fa-check-circle stat-icon"></i>
                    </div>
                    <div class="stat-value">${statistics[1]}</div>
                </div>

                <div class="stat-card reviews">
                    <div class="stat-header">
                        <span class="stat-title">Nhiệm vụ đang chờ xử lý</span>
                        <i class="fas fa-comment-dots stat-icon"></i>
                    </div>
                    <div class="stat-value">${statistics[2]}</div>
                </div>


            </div>

            <!-- Tasks Tabs -->
            <div class="tabs-container">
                <div class="tabs-nav">
                    <button class="tab-button active" onclick="showTab('incomplete')">
                        <i class="fas fa-clock"></i>
                        Nhiệm vụ chưa hoàn thành (<span id="incomplete-count">0</span>)
                    </button>
                    <button class="tab-button" onclick="showTab('completed')">
                        <i class="fas fa-check-circle"></i>
                        Nhiệm vụ hoàn thành (<span id="completed-count">0</span>)
                    </button>
                    <button class="tab-button" onclick="showTab('reviews')">
                        <i class="fas fa-comment-dots"></i>
                        Thông báo đánh giá (${reviews.size()})
                    </button>
                </div>

                <!-- Incomplete Tasks Tab -->
                <div id="incomplete-tab" class="tab-content">
                    <c:set var="incompleteCount" value="0" />
                    <c:forEach var="task" items="${allTasks}">
                        <c:if test="${task.status == 'Assigned' || task.status == 'In Progress'}">
                            <c:set var="incompleteCount" value="${incompleteCount + 1}" />
                            <div class="task-card ${not empty task.courseID ? 'course' : 'test'}" data-task-id="${task.taskID}">
                                <div class="task-header">
                                    <h3 class="task-title">
                                        <i class="task-icon ${not empty task.courseID ? 'fas fa-book-open' : 'fas fa-clipboard-check'}"></i>
                                        <c:choose>
                                            <c:when test="${not empty task.courseID}">Quản lý Khóa học</c:when>
                                            <c:otherwise>Tạo Bài Test</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <span class="task-status ${task.status == 'Assigned' ? 'status-assigned' : 'status-progress'}">
                                        ${task.status}
                                    </span>
                                </div>

                                <p class="task-description">${task.description}</p>

                                <div class="task-meta">
                                    <div class="task-meta-item">
                                        <i class="fas fa-user task-meta-icon"></i>
                                        <span>Phân công bởi: ${task.coordinatorName}</span>
                                    </div>

                                    <c:if test="${not empty task.courseID}">
                                        <div class="task-meta-item">
                                            <i class="fas fa-book-open task-meta-icon"></i>
                                            <span>Khóa học: ${task.courseName}</span>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty task.testID}">
                                        <div class="task-meta-item">
                                            <i class="fas fa-clipboard-check task-meta-icon"></i>
                                            <span>Cấp độ: JLPT ${task.jlptLevel}</span>
                                        </div>
                                    </c:if>

                                    <div class="task-meta-item">
                                        <i class="fas fa-calendar task-meta-icon"></i>
                                        <span>Hạn chót: <fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy" /></span>
                                        <c:set var="now" value="<%= new java.util.Date()%>" />
                                        <c:set var="deadline" value="${task.deadline}" />
                                    </div>
                                </div>

                                <div class="task-actions">
                                    <a href="${pageContext.request.contextPath}/teacher/tasks/detail/${task.taskID}" class="btn btn-outline">
                                        <i class="fas fa-eye"></i>
                                        Xem chi tiết
                                    </a>

                                    <c:choose>
                                        <c:when test="${task.status == 'Assigned'}">
                                            <button class="btn btn-primary" onclick="startTask(${task.taskID}, '${not empty task.courseID ? 'course' : 'test'}','${task.courseID}')">
                                                <i class="fas fa-play"></i>
                                                Bắt đầu làm
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-success" onclick="continueTask(${task.taskID}, '${not empty task.courseID ? 'course' : 'test'}','${task.courseID}')">
                                                <i class="fas fa-arrow-right"></i>
                                                Tiếp tục
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${incompleteCount == 0}">
                        <div class="empty-state">
                            <i class="fas fa-check-circle empty-state-icon"></i>
                            <h3>Không có nhiệm vụ chưa hoàn thành</h3>
                            <p>Tuyệt vời! Bạn đã hoàn thành tất cả nhiệm vụ được giao.</p>
                        </div>
                    </c:if>

                    <!-- Pagination for Incomplete Tasks -->
                    <div id="incomplete-pagination" class="pagination-container" style="display: none;">
                        <div class="pagination-info">
                            <span class="pagination-text">Hiển thị <span id="incomplete-start">1</span> - <span id="incomplete-end">3</span> của <span id="incomplete-total">0</span> nhiệm vụ</span>
                        </div>
                        <div class="pagination-controls">
                            <button id="incomplete-prev" class="pagination-btn prev-btn" onclick="changePage('incomplete', -1)">
                                <i class="fas fa-chevron-left"></i> Trước
                            </button>
                            <div id="incomplete-page-numbers" class="page-numbers"></div>
                            <button id="incomplete-next" class="pagination-btn next-btn" onclick="changePage('incomplete', 1)">
                                Sau <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Completed Tasks Tab -->
                <div id="completed-tab" class="tab-content" style="display: none;">
                    <c:set var="completedCount" value="0" />
                    <c:forEach var="task" items="${allTasks}">
                        <c:if test="${task.status == 'Submitted' || task.status == 'Reviewed'}">
                            <c:set var="completedCount" value="${completedCount + 1}" />
                            <div class="task-card ${not empty task.courseID ? 'course' : 'test'}" data-task-id="${task.taskID}">
                                <div class="task-header">
                                    <h3 class="task-title">
                                        <i class="task-icon ${not empty task.courseID ? 'fas fa-book-open' : 'fas fa-clipboard-check'}"></i>
                                        <c:choose>
                                            <c:when test="${not empty task.courseID}">Quản lý Khóa học</c:when>
                                            <c:otherwise>Tạo Bài Test</c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <span class="task-status ${task.status == 'Submitted' ? 'status-submitted' : 'status-reviewed'}">
                                        ${task.status}
                                    </span>
                                </div>

                                <p class="task-description">${task.description}</p>

                                <div class="task-meta">
                                    <div class="task-meta-item">
                                        <i class="fas fa-user task-meta-icon"></i>
                                        <span>Phân công bởi: ${task.coordinatorName}</span>
                                    </div>

                                    <c:if test="${not empty task.courseID}">
                                        <div class="task-meta-item">
                                            <i class="fas fa-book-open task-meta-icon"></i>
                                            <span>Khóa học: ${task.courseName}</span>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty task.testID}">
                                        <div class="task-meta-item">
                                            <i class="fas fa-clipboard-check task-meta-icon"></i>
                                            <span>Cấp độ: JLPT ${task.jlptLevel}</span>
                                        </div>
                                    </c:if>

                                    <div class="task-meta-item">
                                        <i class="fas fa-calendar task-meta-icon"></i>
                                        <span>Hạn chót: <fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy" /></span>
                                    </div>
                                </div>

                                <div class="task-actions">
                                    <a href="${pageContext.request.contextPath}/teacher/tasks/detail/${task.taskID}" class="btn btn-outline">
                                        <i class="fas fa-eye"></i>
                                        Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>

                    <c:if test="${completedCount == 0}">
                        <div class="empty-state">
                            <i class="fas fa-clock empty-state-icon"></i>
                            <h3>Chưa có nhiệm vụ hoàn thành</h3>
                            <p>Các nhiệm vụ đã hoàn thành sẽ hiển thị ở đây.</p>
                        </div>
                    </c:if>

                    <!-- Pagination for Completed Tasks -->
                    <div id="completed-pagination" class="pagination-container" style="display: none;">
                        <div class="pagination-info">
                            <span class="pagination-text">Hiển thị <span id="completed-start">1</span> - <span id="completed-end">3</span> của <span id="completed-total">0</span> nhiệm vụ</span>
                        </div>
                        <div class="pagination-controls">
                            <button id="completed-prev" class="pagination-btn prev-btn" onclick="changePage('completed', -1)">
                                <i class="fas fa-chevron-left"></i> Trước
                            </button>
                            <div id="completed-page-numbers" class="page-numbers"></div>
                            <button id="completed-next" class="pagination-btn next-btn" onclick="changePage('completed', 1)">
                                Sau <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Reviews Tab -->
                <div id="reviews-tab" class="tab-content" style="display: none;">
                    <c:if test="${reviews.size() == 0}">
                        <div class="reviews-empty-state">
                            <i class="fas fa-comment-dots empty-state-icon"></i>
                            <h3>Không có thông báo đánh giá</h3>
                            <p>Các đánh giá từ coordinator sẽ hiển thị ở đây khi có nội dung được đánh giá.</p>
                        </div>
                    </c:if>

                    <c:forEach var="review" items="${reviews}">
                        <div class="review-card ${review.reviewStatus.toLowerCase()}">
                            <div class="review-header">
                                <h3 class="review-title">
                                    <i class="fas fa-comment-dots"></i>
                                    <c:choose>
                                        <c:when test="${not empty review.courseID}">Đánh giá Khóa học</c:when>
                                        <c:otherwise>Đánh giá Bài Test</c:otherwise>
                                    </c:choose>
                                </h3>
                                <span class="review-status ${review.reviewStatus.toLowerCase()}">
                                    ${review.reviewStatus}
                                </span>
                            </div>

                            <div class="review-type-badge ${not empty review.courseID ? 'course' : 'test'}">
                                <i class="fas fa-${not empty review.courseID ? 'book-open' : 'clipboard-check'}"></i>
                                ${not empty review.courseID ? 'course' : 'test'}
                            </div>

                            <p class="task-description">${review.entityTitle}</p>

                            <div class="review-rating">
                                <span>Đánh giá:</span>
                                <div class="stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fas fa-star ${i <= review.rating ? 'star' : 'star empty'}"></i>
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

                            <c:if test="${review.reviewStatus == 'rejected'}">
                                <div class="review-actions">
                                    <button class="btn btn-primary">
                                        <i class="fas fa-edit"></i>
                                        Chỉnh sửa và gửi lại
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                    
                    <!-- Pagination for Reviews -->
                    <div id="reviews-pagination" class="pagination-container" style="display: none;">
                        <div class="pagination-info">
                            <span class="pagination-text">Hiển thị <span id="reviews-start">1</span> - <span id="reviews-end">3</span> của <span id="reviews-total">0</span> đánh giá</span>
                        </div>
                        <div class="pagination-controls">
                            <button id="reviews-prev" class="pagination-btn prev-btn" onclick="changePage('reviews', -1)">
                                <i class="fas fa-chevron-left"></i> Trước
                            </button>
                            <div id="reviews-page-numbers" class="page-numbers"></div>
                            <button id="reviews-next" class="pagination-btn next-btn" onclick="changePage('reviews', 1)">
                                Sau <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alert for actions -->
            <div id="alert-container"></div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/notification-utils.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/task.js"></script>

        <script>
            document.getElementById('incomplete-count').textContent = '${incompleteCount}';
            document.getElementById('completed-count').textContent = '${completedCount}';
            
            // Initialize pagination after page loads
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize pagination for the active tab
                const activeTab = document.querySelector('.tab-button.active');
                if (activeTab) {
                    const tabName = activeTab.getAttribute('onclick').match(/'([^']+)'/)[1];
                    if (tabName === 'incomplete' || tabName === 'completed' || tabName === 'reviews') {
                        showTab(tabName);
                    }
                }
                
                // Initialize reviews pagination if there are reviews
                const reviewCards = document.querySelectorAll('#reviews-tab .review-card');
                if (reviewCards.length > 0) {
                    totalTasks.reviews = reviewCards.length;
                    totalPages.reviews = Math.max(1, Math.ceil(totalTasks.reviews / pageSize));
                    
                    if (document.querySelector('#reviews-tab').style.display === 'block') {
                        initializePagination('reviews');
                        showCurrentPage('reviews');
                    }
                }
            });
        </script>
    </body>
</html>