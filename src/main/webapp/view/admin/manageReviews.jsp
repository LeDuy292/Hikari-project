<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                        <%                  
                            request.setAttribute("pageTitle", "Quản Lý Đánh Giá");
                            request.setAttribute("showAddButton", false);
                            request.setAttribute("pageIcon", "fa-star");
                            request.setAttribute("showNotification", false);
                        %>
                        <%@ include file="headerAdmin.jsp" %>

                        <!-- Messages -->
                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Enhanced Filter Section -->
                        <div class="filter-section">
                            <form action="${pageContext.request.contextPath}/admin/reviews" method="GET" class="filter-form">
                                <div class="filter-group">
                                    <label for="courseFilter">
                                        <i class="fas fa-book"></i> Khóa Học:
                                    </label>
                                    <select class="form-select" id="courseFilter" name="courseID">
                                        <option value="">Tất cả</option>
                                        <c:forEach var="course" items="${courses}">
                                            <option value="${course.courseID}" ${param.courseID == course.courseID ? 'selected' : ''}>${course.title}</option>
                                        </c:forEach>
                                    </select>
                                </div>
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
                                    <label for="reviewDateFilter">
                                        <i class="fas fa-calendar-alt"></i> Ngày Đánh Giá:
                                    </label>
                                    <input type="date" class="form-control" id="reviewDateFilter" name="date" value="${param.date}" />
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
                                        <th><i class="fas fa-calendar-alt"></i> NGÀY ĐÁNH GIÁ</th>
                                        <th><i class="fas fa-cogs"></i> HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="review" items="${reviews}">
                                        <tr>
                                            <td><strong>REV${String.format("%03d", review.id)}</strong></td>
                                            <td><strong>${review.reviewerName}</strong></td>
                                            <td>${review.courseName}</td>
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
                                            <td><fmt:formatDate value="${review.reviewDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <button class="btn btn-view btn-sm btn-action" onclick="viewReview(${review.id})">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-edit btn-sm btn-action" onclick="editReview(${review.id})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-delete btn-sm btn-action" onclick="deleteReview(${review.id})">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination" id="pagination">
                            <button id="prevPage" ${currentPage <= 1 ? 'disabled' : ''} onclick="goToPage(${currentPage - 1})">
                                <i class="fas fa-chevron-left"></i> Trước
                            </button>
                            <span id="pageInfo">Trang ${currentPage} / ${totalPages}</span>
                            <button id="nextPage" ${currentPage >= totalPages ? 'disabled' : ''} onclick="goToPage(${currentPage + 1})">
                                Sau <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>

                        <!-- View Review Modal -->
                        <div class="modal fade view-review-modal" id="viewReviewModal" tabindex="-1" aria-labelledby="viewReviewModalLabel" aria-hidden="true">
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
                                                <span class="info-value" id="modalReviewId"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Người Đánh Giá:</span>
                                                <span class="info-value" id="modalReviewer"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Khóa Học:</span>
                                                <span class="info-value" id="modalCourse"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Điểm Đánh Giá:</span>
                                                <span class="info-value" id="modalRating"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày Đánh Giá:</span>
                                                <span class="info-value" id="modalReviewDate"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Nội Dung:</span>
                                                <span class="info-value" id="modalReviewText"></span>
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
                                    <form action="${pageContext.request.contextPath}/admin/reviews" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editReviewId" name="reviewId">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-star"></i> Thông Tin Đánh Giá</h6>
                                                <div class="form-group">
                                                    <label for="editRating">Điểm Đánh Giá <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="editRating" name="rating" required>
                                                        <option value="5">5 Sao</option>
                                                        <option value="4">4 Sao</option>
                                                        <option value="3">3 Sao</option>
                                                        <option value="2">2 Sao</option>
                                                        <option value="1">1 Sao</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editReviewText">Nội Dung Đánh Giá <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" id="editReviewText" name="reviewText" rows="5" required></textarea>
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

                        <!-- Delete Review Modal -->
                        <div class="modal fade delete-review-modal" id="deleteReviewModal" tabindex="-1" aria-labelledby="deleteReviewModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="deleteReviewModalLabel"><i class="fas fa-trash"></i> Xác Nhận Xóa Đánh Giá</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh Báo</h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn xóa đánh giá <strong><span id="deleteReviewId"></span></strong> của <strong><span id="deleteReviewer"></span></strong>?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này không thể hoàn tác. Đánh giá sẽ bị xóa vĩnh viễn khỏi hệ thống.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Hủy
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/reviews" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" id="deleteConfirmReviewId" name="reviewId">
                                            <button type="submit" class="btn btn-confirm-delete">
                                                <i class="fas fa-trash"></i> Xóa
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
            function viewReview(reviewId) {
                fetch('${pageContext.request.contextPath}/admin/reviews?action=view&id=' + reviewId)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('modalReviewId').textContent = 'REV' + String(data.id).padStart(3, '0');
                        document.getElementById('modalReviewer').textContent = data.reviewerName;
                        document.getElementById('modalCourse').textContent = data.courseName;
                        document.getElementById('modalRating').innerHTML = generateStars(data.rating) + ' (' + data.rating + ')';
                        document.getElementById('modalReviewDate').textContent = new Date(data.reviewDate).toLocaleDateString('vi-VN');
                        document.getElementById('modalReviewText').textContent = data.reviewText;

                        var modal = new bootstrap.Modal(document.getElementById('viewReviewModal'));
                        modal.show();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi tải thông tin đánh giá');
                    });
            }

            function editReview(reviewId) {
                fetch('${pageContext.request.contextPath}/admin/reviews?action=view&id=' + reviewId)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('editReviewId').value = data.id;
                        document.getElementById('editRating').value = data.rating;
                        document.getElementById('editReviewText').value = data.reviewText;

                        var modal = new bootstrap.Modal(document.getElementById('editReviewModal'));
                        modal.show();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi tải thông tin đánh giá');
                    });
            }

            function deleteReview(reviewId) {
                fetch('${pageContext.request.contextPath}/admin/reviews?action=view&id=' + reviewId)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('deleteReviewId').textContent = 'REV' + String(data.id).padStart(3, '0');
                        document.getElementById('deleteReviewer').textContent = data.reviewerName;
                        document.getElementById('deleteConfirmReviewId').value = data.id;

                        var modal = new bootstrap.Modal(document.getElementById('deleteReviewModal'));
                        modal.show();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi tải thông tin đánh giá');
                    });
            }

            function generateStars(rating) {
                let stars = '';
                for (let i = 1; i <= 5; i++) {
                    stars += i <= rating ? '★' : '☆';
                }
                return '<span class="rating-stars">' + stars + '</span>';
            }

            function goToPage(page) {
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('page', page);
                window.location.href = '${pageContext.request.contextPath}/admin/reviews?' + urlParams.toString();
            }

            // Auto-dismiss alerts after 5 seconds
            document.addEventListener('DOMContentLoaded', function() {
                const alerts = document.querySelectorAll(".alert");
                alerts.forEach((alert) => {
                    setTimeout(() => {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });
        </script>
    </body>
</html>
