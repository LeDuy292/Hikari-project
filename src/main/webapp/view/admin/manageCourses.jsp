<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Khóa Học - HIKARI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/admin/manaCourses.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <%@ include file="sidebar.jsp" %>
                <div class="main-content">
                    <div class="content-wrapper">
                        <%
                            request.setAttribute("pageTitle", "Quản Lý Khóa Học");
                            request.setAttribute("showAddButton", true);
                            request.setAttribute("addButtonText", "Thêm Khóa Học");
                            request.setAttribute("addModalTarget", "addCourseModal");
                            request.setAttribute("addBtnIcon", "fa-book-medical");
                            request.setAttribute("pageIcon", "fa-book");
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
                            <form action="${pageContext.request.contextPath}/admin/courses" method="GET" class="filter-form">
                                <div class="filter-group">
                                    <label for="statusFilter">
                                        <i class="fas fa-toggle-on"></i> Trạng Thái:
                                    </label>
                                    <select class="form-select" id="statusFilter" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="true" ${param.status == 'true' ? 'selected' : ''}>Hoạt Động</option>
                                        <option value="false" ${param.status == 'false' ? 'selected' : ''}>Không Hoạt Động</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="feeFromFilter">
                                        <i class="fas fa-money-bill"></i> Học Phí Từ:
                                    </label>
                                    <input type="number" class="form-control" id="feeFromFilter" name="feeFrom" min="0" value="${param.feeFrom}" placeholder="VND" />
                                </div>
                                <div class="filter-group">
                                    <label for="feeToFilter">
                                        <i class="fas fa-money-bill-wave"></i> Học Phí Đến:
                                    </label>
                                    <input type="number" class="form-control" id="feeToFilter" name="feeTo" min="0" value="${param.feeTo}" placeholder="VND" />
                                </div>
                                <div class="filter-group">
                                    <label for="startDateFilter">
                                        <i class="fas fa-calendar-alt"></i> Ngày Bắt Đầu:
                                    </label>
                                    <input type="date" class="form-control" id="startDateFilter" name="startDate" value="${param.startDate}" />
                                </div>
                                <div class="filter-group">
                                    <label for="keywordSearch">
                                        <i class="fas fa-search"></i> Tìm Kiếm:
                                    </label>
                                    <input type="text" class="form-control" id="keywordSearch" name="keyword" placeholder="Tên khóa học, mô tả..." value="${param.keyword}" />
                                </div>
                                <div class="filter-actions">
                                    <button type="submit" class="btn btn-filter">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-reset">
                                        <i class="fas fa-refresh"></i> Đặt Lại
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Courses Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-id-card"></i> ID</th>
                                        <th><i class="fas fa-book"></i> TÊN KHÓA HỌC</th>
                                        <th><i class="fas fa-money-bill"></i> HỌC PHÍ</th>
                                        <th><i class="fas fa-clock"></i> THỜI LƯỢNG</th>
                                        <th><i class="fas fa-calendar-alt"></i> NGÀY BẮT ĐẦU</th>
                                        <th><i class="fas fa-calendar-check"></i> NGÀY KẾT THÚC</th>
                                        <th><i class="fas fa-toggle-on"></i> TRẠNG THÁI</th>
                                        <th><i class="fas fa-cogs"></i> HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody id="courseTableBody">
                                    <c:forEach var="course" items="${courses}">
                                        <tr>
                                            <td><strong>${course.courseID}</strong></td>
                                            <td><strong>${course.title}</strong></td>
                                            <td>
                                                <span class="badge" style="background: linear-gradient(135deg, #28a745, #34ce57);">
                                                    <fmt:formatNumber value="${course.fee}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                </span>
                                            </td>
                                            <td>${course.duration} tuần</td>
                                            <td><fmt:formatDate value="${course.startDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${course.endDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${course.isActive}">
                                                        <span class="badge badge-active">
                                                            <i class="fas fa-check-circle"></i> Hoạt Động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-inactive">
                                                            <i class="fas fa-times-circle"></i> Không Hoạt Động
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="btn btn-view btn-sm btn-action" 
                                                        onclick="viewCourse('${course.courseID}')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-edit btn-sm btn-action" 
                                                        onclick="editCourse('${course.courseID}')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-block btn-sm btn-action" 
                                                        onclick="blockCourse('${course.courseID}', '${course.title}', ${course.isActive})">
                                                    <c:choose>
                                                        <c:when test="${course.isActive}">
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
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination" id="pagination">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <button onclick="window.location.href = '${pageContext.request.contextPath}/admin/courses?page=${currentPage - 1}&keyword=${param.keyword}&status=${param.status}&feeFrom=${param.feeFrom}&feeTo=${param.feeTo}&startDate=${param.startDate}'">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button disabled>
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <span id="pageInfo">Trang ${currentPage} / ${totalPages}</span>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <button onclick="window.location.href = '${pageContext.request.contextPath}/admin/courses?page=${currentPage + 1}&keyword=${param.keyword}&status=${param.status}&feeFrom=${param.feeFrom}&feeTo=${param.feeTo}&startDate=${param.startDate}'">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button disabled>
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Add Course Modal -->
                        <div class="modal fade add-course-modal" id="addCourseModal" tabindex="-1" aria-labelledby="addCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addCourseModalLabel">
                                            <i class="fas fa-plus-circle"></i> Thêm Khóa Học
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form id="addCourseForm" action="${pageContext.request.contextPath}/admin/courses" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-info-circle"></i> Thông Tin Khóa Học
                                                </h6>
                                                <div class="form-group">
                                                    <label for="courseID">ID Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="courseID" name="courseID" placeholder="Nhập ID khóa học (COxxx)" pattern="CO[0-9]{3}" required />
                                                    <div class="invalid-feedback">ID khóa học phải có định dạng COxxx (ví dụ: CO001).</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="title">Tên Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="title" name="title" placeholder="Nhập tên khóa học" required />
                                                    <div class="invalid-feedback">Tên khóa học không được để trống.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="description">Mô Tả</label>
                                                    <textarea class="form-control" id="description" name="description" placeholder="Nhập mô tả khóa học"></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="fee">Học Phí (VND)</label>
                                                    <input type="number" class="form-control" id="fee" name="fee" min="0" placeholder="Nhập học phí" />
                                                    <div class="invalid-feedback">Học phí phải là số không âm.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="duration">Thời Lượng (tuần)</label>
                                                    <input type="number" class="form-control" id="duration" name="duration" min="1" placeholder="Nhập thời lượng" />
                                                    <div class="invalid-feedback">Thời lượng phải là số nguyên dương.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="startDate">Ngày Bắt Đầu</label>
                                                    <input type="date" class="form-control" id="startDate" name="startDate" />
                                                    <div class="invalid-feedback">Ngày bắt đầu không hợp lệ.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="endDate">Ngày Kết Thúc</label>
                                                    <input type="date" class="form-control" id="endDate" name="endDate" />
                                                    <div class="invalid-feedback">Ngày kết thúc phải sau ngày bắt đầu.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="isActive">Trạng Thái</label>
                                                    <select class="form-select" id="isActive" name="isActive">
                                                        <option value="true">Hoạt động</option>
                                                        <option value="false">Không hoạt động</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="imageUrl">URL Hình Ảnh <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" placeholder="Nhập URL hình ảnh" />
                                                    <div class="invalid-feedback">URL hình ảnh không hợp lệ.</div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                            <button type="submit" class="btn btn-submit">
                                                <i class="fas fa-plus"></i> Thêm
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- View Course Modal -->
                        <div class="modal fade view-course-modal" id="viewCourseModal" tabindex="-1" aria-labelledby="viewCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="viewCourseModalLabel">
                                            <i class="fas fa-book"></i> Chi Tiết Khóa Học
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="section">
                                            <h6 class="section-title">
                                                <i class="fas fa-info-circle"></i> Thông Tin Khóa Học
                                            </h6>
                                            <div class="info-item">
                                                <span class="info-label">ID Khóa Học:</span>
                                                <span class="info-value" id="viewCourseID"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Tên Khóa Học:</span>
                                                <span class="info-value" id="viewCourseTitle"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Mô Tả:</span>
                                                <span class="info-value" id="viewCourseDescription"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Học Phí:</span>
                                                <span class="info-value" id="viewCourseFee"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Thời Lượng:</span>
                                                <span class="info-value" id="viewCourseDuration"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày Bắt Đầu:</span>
                                                <span class="info-value" id="viewCourseStartDate"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày Kết Thúc:</span>
                                                <span class="info-value" id="viewCourseEndDate"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Trạng Thái:</span>
                                                <span class="info-value" id="viewCourseStatus"></span>
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

                        <!-- Edit Course Modal -->
                        <div class="modal fade edit-course-modal" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editCourseModalLabel">
                                            <i class="fas fa-edit"></i> Chỉnh Sửa Khóa Học
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form id="editCourseForm" action="${pageContext.request.contextPath}/admin/courses" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editCourseID" name="courseID">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-info-circle"></i> Thông Tin Khóa Học
                                                </h6>
                                                <div class="form-group">
                                                    <label for="editTitle">Tên Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="editTitle" name="title" required />
                                                    <div class="invalid-feedback">Tên khóa học không được để trống.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editDescription">Mô Tả</label>
                                                    <textarea class="form-control" id="editDescription" name="description"></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editFee">Học Phí (VND)</label>
                                                    <input type="number" class="form-control" id="editFee" name="fee" min="0" />
                                                    <div class="invalid-feedback">Học phí phải là số không âm.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editDuration">Thời Lượng (tuần)</label>
                                                    <input type="number" class="form-control" id="editDuration" name="duration" min="1" />
                                                    <div class="invalid-feedback">Thời lượng phải là số nguyên dương.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editStartDate">Ngày Bắt Đầu</label>
                                                    <input type="date" class="form-control" id="editStartDate" name="startDate" />
                                                    <div class="invalid-feedback">Ngày bắt đầu không hợp lệ.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editEndDate">Ngày Kết Thúc</label>
                                                    <input type="date" class="form-control" id="editEndDate" name="endDate" />
                                                    <div class="invalid-feedback">Ngày kết thúc phải sau ngày bắt đầu.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editIsActive">Trạng Thái</label>
                                                    <select class="form-select" id="editIsActive" name="isActive">
                                                        <option value="true">Hoạt động</option>
                                                        <option value="false">Không hoạt động</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editImageUrl">URL Hình Ảnh <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="url" class="form-control" id="editImageUrl" name="imageUrl" />
                                                    <div class="invalid-feedback">URL hình ảnh không hợp lệ.</div>
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

                        <!-- Block Course Modal -->
                        <div class="modal fade block-course-modal" id="blockCourseModal" tabindex="-1" aria-labelledby="blockCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="blockCourseModalLabel">
                                            <i class="fas fa-lock"></i> Xác Nhận Khóa/Mở Khóa Khóa Học
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title">
                                                <i class="fas fa-exclamation-triangle"></i> Cảnh Báo
                                            </h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn <span id="blockCourseAction">khóa</span> khóa học 
                                                <strong><span id="blockCourseTitle"></span></strong> (ID: <strong><span id="blockCourseId"></span></strong>)?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này sẽ thay đổi trạng thái khóa học. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Hủy
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/courses" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="block">
                                            <input type="hidden" id="blockCourseIdInput" name="id" />
                                            <input type="hidden" id="blockCourseStatusInput" name="isActive" />
                                            <button type="submit" class="btn btn-confirm-delete">
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
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaCourses.js"></script>
    </body>
</html>