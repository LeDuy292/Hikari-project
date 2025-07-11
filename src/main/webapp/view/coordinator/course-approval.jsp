<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Phê Duyệt Bài Học - Coordinator Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/course-approval.css" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex bg-light min-vh-100">
            <jsp:include page="sidebarCoordinator.jsp" />
            <div class="main-content flex-grow-1">
                <jsp:include page="headerCoordinator.jsp" />
                <div class="content-wrapper">
                    <div class="row g-3 mb-4">
                        <div class="col-12 col-md-4">
                            <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                                <div class="stat-icon bg-warning bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                    <i class="fas fa-clock fa-2x text-warning"></i>
                                </div>
                                <div>
                                    <div class="fs-5 fw-bold text-dark">${pendingCount}</div>
                                    <div class="text-muted small">Bài học chờ phê duyệt</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-md-4">
                            <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                                <div class="stat-icon bg-success bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                    <i class="fas fa-check-circle fa-2x text-success"></i>
                                </div>
                                <div>
                                    <div class="fs-5 fw-bold text-dark">${approvedCount}</div>
                                    <div class="text-muted small">Bài học đã phê duyệt</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 col-md-4">
                            <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                                <div class="stat-icon bg-danger bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                    <i class="fas fa-times-circle fa-2x text-danger"></i>
                                </div>
                                <div>
                                    <div class="fs-5 fw-bold text-dark">${rejectedCount}</div>
                                    <div class="text-muted small">Bài học bị từ chối</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card p-0">
                        <div class="card-header bg-white border-bottom-0 pb-0">
                            <div class="row g-2 align-items-center">
                                <div class="col-md-6">
                                    <h5 class="card-title mb-0">Danh sách bài học chờ phê duyệt</h5>
                                </div>
                                <div class="col-md-6">
                                     <form class="d-flex gap-2 justify-content-md-end flex-wrap" action="LessonApprovalServlet" method="get">
                                        <!-- THÊM: Form chỉ để chọn pageSize -->
                                        <input type="hidden" name="page" value="${currentPage}">
                                        <input type="hidden" name="courseID" value="${courseID}">
                                        <select class="form-select shadow-sm rounded-pill" name="pageSize" onchange="this.form.submit()">
                                            <option value="5" ${pageSize == 5 ? 'selected' : ''}>5 bài/trang</option>
                                            <option value="10" ${pageSize == 10 ? 'selected' : ''}>10 bài/trang</option>
                                            <option value="20" ${pageSize == 20 ? 'selected' : ''}>20 bài/trang</option>
                                        </select>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="bg-light">
                                        <tr>
                                            <th>STT</th>
                                            <th>Giảng viên</th>
                                            <th>Tiêu đề bài học</th>
                                            <th>Thời lượng</th>
                                            <th>Chủ đề</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- SỬA: Cập nhật STT dựa trên trang hiện tại và pageSize -->
                                        <c:set var="Cnt" value="${(currentPage - 1) * pageSize}" scope="page" />
                                        <c:forEach var="lesson" items="${lessons}">
                                            <c:set var="Cnt" value="${Cnt + 1}" />
                                            <tr>
                                                <td>${Cnt}</td>
                                                <td>
                                                    ${lesson.teacherName}
                                                </td>
                                                <td>${lesson.title}</td>
                                                <td>${lesson.duration} phút</td>
                                                <td><span>${lesson.topicName}</span></td>
                                                <td>
                                                    <c:forEach var="review" items="${reviews}">
                                                        <c:if test="${review.lessonID == lesson.id}">
                                                            <span class="badge bg-${review.reviewStatus == 'Pending' ? 'warning' : review.reviewStatus == 'Approved' ? 'success' : 'danger'}">
                                                                ${review.reviewStatus}
                                                            </span>
                                                        </c:if>
                                                    </c:forEach>
                                                </td>
                                                <td>
                                                    <div class="btn-group">
                                                        <button type="button" class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal-${lesson.id}">
                                                            <i class="fas fa-clipboard-check"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <!-- THÊM: Phần phân trang -->
                            <nav aria-label="Page navigation" class="mt-3">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="LessonApprovalServlet?page=${currentPage - 1}&pageSize=${pageSize}&courseID=${courseID}">Previous</a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="LessonApprovalServlet?page=${i}&pageSize=${pageSize}&courseID=${courseID}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="LessonApprovalServlet?page=${currentPage + 1}&pageSize=${pageSize}&courseID=${courseID}">Next</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
                <c:forEach var="lesson" items="${lessons}">
                    <div class="modal fade" id="videoModal-${lesson.id}" tabindex="-1" aria-labelledby="videoModalLabel-${lesson.id}" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="videoModalLabel-${lesson.id}">Đánh giá bài học: ${lesson.title}</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="video-container mb-4">
                                        <c:set var="isYoutube" value="${fn:contains(lesson.mediaUrl, 'youtu.be') || fn:contains(lesson.mediaUrl, 'youtube.com')}" />
                                        <c:choose>
                                            <c:when test="${isYoutube}">
                                                <c:set var="videoId" value="${fn:substringAfter(fn:replace(lesson.mediaUrl, 'https://youtu.be/', ''), 'v=')}" />
                                                <c:if test="${empty videoId}">
                                                    <c:set var="videoId" value="${fn:substringAfter(lesson.mediaUrl, 'v=')}" />
                                                    <c:set var="videoId" value="${fn:substringBefore(videoId, '&')}" />
                                                </c:if>
                                                <iframe class="w-100 rounded-3" style="aspect-ratio: 16/9;" src="https://www.youtube.com/embed/${videoId}" frameborder="0" allowfullscreen></iframe>
                                                </c:when>
                                                <c:otherwise>
                                                <video class="w-100 rounded-3 bg-dark" controls>
                                                    <source src="${lesson.mediaUrl}" type="video/mp4">
                                                    Trình duyệt của bạn không hỗ trợ video.
                                                </video>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <form action="ReviewLessonServlet" method="post">
                                        <input type="hidden" name="lessonID" value="${lesson.id}">
                                        <input type="hidden" name="courseID" value="${param.courseID}">
                                        
                                        <input type="hidden" name="page" value="${currentPage}">
                                        <input type="hidden" name="pageSize" value="${pageSize}">
                                        
                                        <h6 class="mb-3">Đánh giá chi tiết</h6>
                                        <div class="mb-3">
                                            <label class="form-label">Chất lượng video (1-5 sao):</label>
                                            <select class="form-select" name="rating" required>
                                                <option value="1">1</option>
                                                <option value="2">2</option>
                                                <option value="3">3</option>
                                                <option value="4">4</option>
                                                <option value="5">5</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="adminComments" class="form-label">Nhận xét của Coordinator:</label>
                                            <textarea class="form-control" id="adminComments" name="reviewText" rows="3" placeholder="Nhập nhận xét tại đây..." required></textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label">Trạng thái:</label>
                                            <select class="form-select" name="reviewStatus" required>
                                                <option value="Approved">Phê duyệt</option>
                                                <option value="Rejected">Từ chối</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary" name="action" value="submit">Gửi đánh giá</button>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>