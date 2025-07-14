<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Đánh Giá - HIKARI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/admin/manaReviews.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Include Sidebar -->
                <%@ include file="sidebar.jsp" %>
                <div class="main-content">
                    <div class="content-wrapper">
                        <%                            request.setAttribute("pageTitle", "Quản Lý Đánh Giá");
                            request.setAttribute("showAddButton", false);
                            request.setAttribute("pageIcon", "fa-star");
                            request.setAttribute("showNotification", false);
                        %>
                        <%@ include file="headerAdmin.jsp" %>

                        <!-- Messages -->
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> ${param.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i> ${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Enhanced Filter Section -->
                        <div class="filter-section">
                            <form action="${pageContext.request.contextPath}/admin/reviews" method="GET" class="filter-form">
                                <div class="filter-group">
                                    <label for="ratingFilter">
                                        <i class="fas fa-star"></i> Điểm Đánh Giá:
                                    </label>
                                    <select class="form-select" id="ratingFilter" name="rating">
                                        <option value="">Tất cả</option>
                                        <option value="5" ${param.rating == '5' ? 'selected' : ''}>5 Sao</option>
                                        <option value="4" ${param.rating == '4' ? 'selected' : ''}>4 Sao</option>
                                        <option value="3" ${param.rating == '3' ? 'selected' : ''}>3 Sao</option>
                                        <option value="2" ${param.rating == '2' ? 'selected' : ''}>2 Sao</option>
                                        <option value="1" ${param.rating == '1' ? 'selected' : ''}>1 Sao</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="statusFilter">
                                        <i class="fas fa-info-circle"></i> Trạng Thái:
                                    </label>
                                    <select class="form-select" id="statusFilter" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${param.status == 'active' ? 'selected' : ''}>Hoạt Động</option>
                                        <option value="blocked" ${param.status == 'blocked' ? 'selected' : ''}>Bị Chặn</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="reviewDateFromFilter">
                                        <i class="fas fa-calendar-alt"></i> Từ Ngày:
                                    </label>
                                    <input type="date" class="form-control" id="reviewDateFromFilter" name="reviewDateFrom" value="${param.reviewDateFrom}" />
                                </div>
                                <div class="filter-group">
                                    <label for="reviewDateToFilter">
                                        <i class="fas fa-calendar-check"></i> Đến Ngày:
                                    </label>
                                    <input type="date" class="form-control" id="reviewDateToFilter" name="reviewDateTo" value="${param.reviewDateTo}" />
                                </div>
                                <div class="filter-group">
                                    <label for="searchFilter">
                                        <i class="fas fa-search"></i> Tìm Kiếm:
                                    </label>
                                    <input type="text" class="form-control" id="searchFilter" name="search" placeholder="ID, người đánh giá..." value="${param.search}" />
                                </div>
                                <div class="filter-actions">
                                    <button type="submit" class="btn btn-filter">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/reviews" class="btn btn-reset">
                                        <i class="fas fa-refresh"></i> Đặt Lại
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Reviews Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i> ID</th>
                                        <th><i class="fas fa-user"></i> NGƯỜI ĐÁNH GIÁ</th>
                                        <th><i class="fas fa-book"></i> KHÓA HỌC</th>
                                        <th><i class="fas fa-star"></i> ĐIỂM ĐÁNH GIÁ</th>
                                        <th><i class="fas fa-info-circle"></i> TRẠNG THÁI</th>
                                        <th><i class="fas fa-calendar-alt"></i> NGÀY ĐÁNH GIÁ</th>
                                        <th><i class="fas fa-cogs"></i> HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty reviews}">
                                            <tr>
                                                <td colspan="7" class="text-center">
                                                    <i class="fas fa-inbox"></i> Không có đánh giá nào
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="review" items="${reviews}">
                                                <tr>
                                                    <td><strong>REV${String.format("%03d", review.id)}</strong></td>
                                                    <td><strong>${fn:escapeXml(review.reviewerName)}</strong></td>
                                                    <td>${fn:escapeXml(review.courseName)}</td>
                                                    <td>
                                                        <span class="rating-stars">
                                                            <c:forEach begin="1" end="5" var="i">
                                                                <c:choose>
                                                                    <c:when test="${i <= review.rating}">★</c:when>
                                                                    <c:otherwise>☆</c:otherwise>
                                                                </c:choose>
                                                            </c:forEach>
                                                        </span>
                                                        <span class="badge" style="background: linear-gradient(135deg, #f39c12, #ffb347);">
                                                            ${review.rating}/5
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${review.status == 'active'}">
                                                                <span class="badge badge-active">
                                                                    <i class="fas fa-check-circle"></i> Hoạt Động
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-inactive">
                                                                    <i class="fas fa-times-circle"></i> Bị Chặn
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td>
                                                        <button class="btn btn-view btn-sm btn-action" onclick="viewReview(${review.id})">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-edit btn-sm btn-action" onclick="editReview(${review.id})">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button class="btn btn-block btn-sm btn-action" 
                                                                onclick="blockReview(${review.id}, '${fn:escapeXml(review.reviewerName)}', '${review.status}')">
                                                            <c:choose>
                                                                <c:when test="${review.status == 'active'}">
                                                                    <i class="fas fa-lock"></i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-unlock"></i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination" id="pagination">
                                <c:if test="${currentPage > 1}">
                                    <button onclick="goToPage(${currentPage - 1})">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </button>
                                </c:if>
                                <span id="pageInfo">Trang ${currentPage} / ${totalPages}</span>
                                <c:if test="${currentPage < totalPages}">
                                    <button onclick="goToPage(${currentPage + 1})">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </button>
                                </c:if>
                            </div>
                        </c:if>

                        <!-- View Review Modal -->
                        <div class="modal fade view-notification-modal" id="viewReviewModal" tabindex="-1" aria-labelledby="viewReviewModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="viewReviewModalLabel"><i class="fas fa-star"></i> Chi Tiết Đánh Giá</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Đánh Giá</h6>
                                            <div class="info-item">
                                                <span class="info-label">ID:</span>
                                                <span class="info-value" id="viewReviewId"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Người Đánh Giá:</span>
                                                <span class="info-value" id="viewReviewer"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Khóa Học:</span>
                                                <span class="info-value" id="viewCourse"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Điểm Đánh Giá:</span>
                                                <span class="info-value" id="viewRating"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Trạng Thái:</span>
                                                <span class="info-value" id="viewStatus"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày Đánh Giá:</span>
                                                <span class="info-value" id="viewReviewDate"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Nội Dung:</span>
                                                <span class="info-value" id="viewReviewText"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Đóng
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Review Modal -->
                        <div class="modal fade edit-review-modal" id="editReviewModal" tabindex="-1" aria-labelledby="editReviewModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editReviewModalLabel"><i class="fas fa-edit"></i> Chỉnh Sửa Đánh Giá</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form id="editReviewForm" action="${pageContext.request.contextPath}/admin/reviews" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editReviewId" name="reviewId">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-star"></i> Thông Tin Đánh Giá</h6>
                                                <div class="form-group">
                                                    <label for="editRating">Điểm Đánh Giá <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="editRating" name="rating" required>
                                                        <option value="" disabled>Chọn điểm đánh giá</option>
                                                        <option value="5">5 Sao</option>
                                                        <option value="4">4 Sao</option>
                                                        <option value="3">3 Sao</option>
                                                        <option value="2">2 Sao</option>
                                                        <option value="1">1 Sao</option>
                                                    </select>
                                                    <div class="invalid-feedback">Vui lòng chọn điểm đánh giá.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editReviewText">Nội Dung Đánh Giá <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" id="editReviewText" name="reviewText" rows="5" required maxlength="1000"></textarea>
                                                    <small class="text-muted" style="float: right;">0/1000 ký tự</small>
                                                    <div class="invalid-feedback">Nội dung không được để trống.</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                            <button type="submit" class="btn btn-submit">
                                                <i class="fas fa-save"></i> Cập Nhật
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Block/Unblock Review Modal -->
                        <div class="modal fade block-notification-modal" id="blockReviewModal" tabindex="-1" aria-labelledby="blockReviewModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="blockReviewModalLabel"><i class="fas fa-lock"></i> Xác Nhận Khóa/Mở Khóa Đánh Giá</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh Báo</h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn <span id="blockReviewAction">khóa</span> đánh giá 
                                                <strong><span id="blockReviewId"></span></strong> của 
                                                <strong><span id="blockReviewer"></span></strong>?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này sẽ thay đổi trạng thái đánh giá. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Hủy
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/reviews" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="block">
                                            <input type="hidden" id="blockConfirmReviewId" name="reviewId">
                                            <input type="hidden" id="blockReviewStatusInput" name="status">
                                            <button type="submit" class="btn btn-block">
                                                <i class="fas fa-lock"></i> Xác Nhận
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const contextPath = '${pageContext.request.contextPath}';
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaReviews.js"></script>
    </body>
</html>