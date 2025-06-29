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
                            request.setAttribute("pageTitle", "Quản Lý Đánh giá");
                            request.setAttribute("showAddButton", true);
                            request.setAttribute("addButtonText", "Thêm Đánh giá");
                            request.setAttribute("addModalTarget", "createNotificationModal");
                            request.setAttribute("addBtnIcon", "fa-plus");
                            request.setAttribute("pageIcon", "fa-bell");
                            request.setAttribute("showNotification", false);
                        %>
                        <%@ include file="headerAdmin.jsp" %>

                        <div class="filter-section">
                            <div class="filter-row">
                                <label for="courseFilter">Khóa Học:</label>
                                <select class="form-select" id="courseFilter" onchange="filterReviews()">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="course" items="${courses}">
                                        <option value="${course.courseID}" ${param.courseID == course.courseID ? 'selected' : ''}>${course.title}</option>
                                    </c:forEach>
                                </select>
                                <label for="ratingFilter">Điểm Đánh Giá:</label>
                                <select class="form-select" id="ratingFilter" onchange="filterReviews()">
                                    <option value="">Tất cả</option>
                                    <option value="5" ${param.rating == '5' ? 'selected' : ''}>5 Sao</option>
                                    <option value="4" ${param.rating == '4' ? 'selected' : ''}>4 Sao</option>
                                    <option value="3" ${param.rating == '3' ? 'selected' : ''}>3 Sao</option>
                                    <option value="2" ${param.rating == '2' ? 'selected' : ''}>2 Sao</option>
                                    <option value="1" ${param.rating == '1' ? 'selected' : ''}>1 Sao</option>
                                </select>
                                <label for="reviewDateFilter">Ngày Đánh Giá:</label>
                                <input type="date" class="form-control" id="reviewDateFilter" value="${param.date}" onchange="filterReviews()" />
                            </div>
                            <div class="search-row">
                                <label for="search">Tìm Kiếm:</label>
                                <input type="text" class="form-control" id="search" placeholder="Tìm theo ID hoặc người đánh giá..." value="${param.search}" onkeyup="filterReviews()" />
                            </div>
                        </div>

                        <!-- Reviews Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>NGƯỜI ĐÁNH GIÁ</th>
                                        <th>KHÓA HỌC</th>
                                        <th>ĐIỂM ĐÁNH GIÁ</th>
                                        <th>NGÀY ĐÁNH GIÁ</th>
                                        <th>HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody id="reviewTableBody">
                                    <c:forEach var="review" items="${reviews}">
                                        <tr data-review-id="REV${String.format('%03d', review.id)}">
                                            <td>REV${String.format("%03d", review.id)}</td>
                                            <td>${review.reviewerName}</td>
                                            <td>${review.courseName}</td>
                                            <td>
                                                <span class="rating-stars">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <c:choose>
                                                            <c:when test="${i <= review.rating}">★</c:when>
                                                            <c:otherwise>☆</c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </span> (${review.rating})
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
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}" class="btn btn-outline-primary">Trước</a>
                            </c:if>
                            <span>Trang ${currentPage} / ${totalPages}</span>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}" class="btn btn-outline-primary">Sau</a>
                            </c:if>
                        </div>

                        <!-- View Review Modal -->
                        <div class="modal fade view-review-modal" id="viewReviewModal" tabindex="-1" aria-labelledby="viewReviewModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
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
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Đóng</button>
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
                                                <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Đánh Giá</h6>
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
                                                    <textarea class="form-control" id="editReviewText" name="reviewText" required></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-submit">Cập Nhật</button>
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
                                                Bạn có chắc chắn muốn xóa đánh giá <span id="deleteReviewId"></span> của <span id="deleteReviewer"></span>?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này không thể hoàn tác. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                        <form action="${pageContext.request.contextPath}/admin/reviews" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" id="deleteConfirmReviewId" name="reviewId">
                                            <button type="submit" class="btn btn-confirm-delete">Xóa</button>
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

                                function filterReviews() {
                                    const courseID = document.getElementById('courseFilter').value;
                                    const rating = document.getElementById('ratingFilter').value;
                                    const date = document.getElementById('reviewDateFilter').value;
                                    const search = document.getElementById('search').value;

                                    let url = '${pageContext.request.contextPath}/admin/reviews?';
                                    if (courseID)
                                        url += 'courseID=' + encodeURIComponent(courseID) + '&';
                                    if (rating)
                                        url += 'rating=' + encodeURIComponent(rating) + '&';
                                    if (date)
                                        url += 'date=' + encodeURIComponent(date) + '&';
                                    if (search)
                                        url += 'search=' + encodeURIComponent(search) + '&';

                                    window.location.href = url;
                                }
        </script>
    </body>
</html>
