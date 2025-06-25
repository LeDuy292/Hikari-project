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
                <!-- Include Sidebar -->
                <%@ include file="sidebar.jsp" %>
                <div class="main-content">
                    <div class="content-wrapper">
                        <!-- Include Header -->
                        <jsp:include page="headerAdmin.jsp">
                            <jsp:param name="pageTitle" value="Quản Lý Khóa Học"/>
                            <jsp:param name="showAddButton" value="true"/>
                            <jsp:param name="addButtonText" value="Thêm Khóa Học"/>
                            <jsp:param name="addModalTarget" value="addCourseModal"/>
                            <jsp:param name="showNotification" value="false"/>
                        </jsp:include>

                        <div class="filter-section">
                            <label for="teacherFilter">Giáo Viên:</label>
                            <select class="form-select" id="teacherFilter">
                                <option value="">Tất cả</option>
                                <option value="Trần Thị B">Trần Thị B</option>
                                <option value="Đỗ Thị F">Đỗ Thị F</option>
                                <option value="Vũ Thị H">Vũ Thị H</option>
                            </select>
                            <label for="levelFilter">Cấp Độ:</label>
                            <select class="form-select" id="levelFilter">
                                <option value="">Tất cả</option>
                                <option value="Sơ Cấp">Sơ Cấp</option>
                                <option value="Trung Cấp">Trung Cấp</option>
                                <option value="Cao Cấp">Cao Cấp</option>
                            </select>
                            <label for="statusFilter">Trạng Thái:</label>
                            <select class="form-select" id="statusFilter">
                                <option value="">Tất cả</option>
                                <option value="Hoạt Động">Hoạt Động</option>
                                <option value="Khóa">Khóa</option>
                            </select>
                            <label for="createdDateFilter">Created Date:</label>
                            <input type="date" class="form-control" id="createdDateFilter" />
                            <label for="nameSearch">Tìm Kiếm:</label>
                            <input type="text" class="form-control" id="nameSearch" placeholder="Tìm theo tên khóa học..." />
                        </div>
                        <!-- Courses Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>TÊN KHÓA HỌC</th>
                                        <th>GIẢNG VIÊN</th>
                                        <th>HỌC VIÊN</th>
                                        <th>CẤP ĐỘ</th>
                                        <th>TRẠNG THÁI</th>
                                        <th>NGÀY TẠO</th>
                                        <th>MÃ GIẢM GIÁ</th>
                                        <th>HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody id="courseTableBody">
                                    <c:forEach var="course" items="${courses}">
                                        <tr>
                                            <td>${course.courseID}</td>
                                            <td>${course.title}</td>
                                            <td><!-- Teacher name from course --></td>
                                            <td><!-- Student count --></td>
                                            <td><!-- Level --></td>
                                            <td>
                                                <span class="badge ${course.active ? 'badge-active' : 'badge-inactive'}">
                                                    ${course.active ? 'Hoạt Động' : 'Khóa'}
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${course.startDate}" pattern="yyyy-MM-dd"/></td>
                                            <td><!-- Discount info --></td>
                                            <td>
                                                <button class="btn btn-view btn-sm btn-action" 
                                                        onclick="viewCourse('${course.courseID}')">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-edit btn-sm btn-action" 
                                                        onclick="editCourse('${course.courseID}')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-delete btn-sm btn-action" 
                                                        onclick="deleteCourse('${course.courseID}')">
                                                    <i class="fas fa-lock"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <!-- Pagination -->
                        <div class="pagination" id="pagination">
                            <button id="prevPage" disabled>Trước</button>
                            <span id="pageInfo"></span>
                            <button id="nextPage">Sau</button>
                        </div>
                        <!-- Add Course Modal -->
                        <div class="modal fade add-course-modal" id="addCourseModal" tabindex="-1" aria-labelledby="addCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addCourseModalLabel"><i class="fas fa-plus-circle"></i> Thêm Khóa Học</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/courses" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Khóa Học</h6>
                                                <div class="form-group">
                                                    <label for="courseName">Tên Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="courseName" name="courseName" placeholder="Nhập tên khóa học" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="teacher">Giảng Viên <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="teacher" name="teacher" required>
                                                        <option value="" disabled selected>Chọn giảng viên</option>
                                                        <option value="Trần Thị B">Trần Thị B</option>
                                                        <option value="Đỗ Thị F">Đỗ Thị F</option>
                                                        <option value="Vũ Thị H">Vũ Thị H</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="level">Cấp Độ <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="level" name="level" required>
                                                        <option value="" disabled selected>Chọn cấp độ</option>
                                                        <option value="Sơ Cấp">Sơ Cấp</option>
                                                        <option value="Trung Cấp">Trung Cấp</option>
                                                        <option value="Cao Cấp">Cao Cấp</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="status">Trạng Thái <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="status" name="status" required>
                                                        <option value="" disabled selected>Chọn trạng thái</option>
                                                        <option value="Hoạt Động">Hoạt Động</option>
                                                        <option value="Khóa">Khóa</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-file-alt"></i> Mô Tả & Thời Lượng</h6>
                                                <div class="form-group">
                                                    <label for="description">Mô Tả <span class="optional-label">(Tùy chọn)</span></label>
                                                    <textarea class="form-control" id="description" name="description" placeholder="Nhập mô tả khóa học"></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="duration">Thời Lượng <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="text" class="form-control" id="duration" name="duration" placeholder="Ví dụ: 3 tháng" />
                                                </div>
                                            </div>
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-money-bill-wave"></i> Giá & Giảm Giá</h6>
                                                <div class="form-group">
                                                    <label for="price">Giá (VND) <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="number" class="form-control" id="price" name="price" min="0" placeholder="Nhập giá khóa học" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="discountCode">Mã Giảm Giá <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="text" class="form-control" id="discountCode" name="discountCode" placeholder="Ví dụ: DISCOUNT10" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="discountPercent">Phần Trăm Giảm Giá (%) <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="number" class="form-control" id="discountPercent" name="discountPercent" min="0" max="100" placeholder="0-100" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-submit">Thêm</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Edit Course Modal -->
                        <div class="modal fade edit-course-modal" id="editCourseModal" tabindex="-1" aria-labelledby="editCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editCourseModalLabel"><i class="fas fa-edit"></i> Chỉnh Sửa Khóa Học</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="/EditCourseServlet" method="POST">
                                        <div class="modal-body">
                                            <input type="hidden" id="editCourseId" name="courseId" />
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Khóa Học</h6>
                                                <div class="form-group">
                                                    <label for="editCourseName">Tên Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="editCourseName" name="courseName" placeholder="Nhập tên khóa học" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editTeacher">Giảng Viên <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="editTeacher" name="teacher" required>
                                                        <option value="" disabled selected>Chọn giảng viên</option>
                                                        <option value="Trần Thị B">Trần Thị B</option>
                                                        <option value="Đỗ Thị F">Đỗ Thị F</option>
                                                        <option value="Vũ Thị H">Vũ Thị H</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editLevel">Cấp Độ <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="editLevel" name="level" required>
                                                        <option value="" disabled selected>Chọn cấp độ</option>
                                                        <option value="Sơ Cấp">Sơ Cấp</option>
                                                        <option value="Trung Cấp">Trung Cấp</option>
                                                        <option value="Cao Cấp">Cao Cấp</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editStatus">Trạng Thái <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="editStatus" name="status" required>
                                                        <option value="" disabled selected>Chọn trạng thái</option>
                                                        <option value="Hoạt Động">Hoạt Động</option>
                                                        <option value="Khóa">Khóa</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-file-alt"></i> Mô Tả & Thời Lượng</h6>
                                                <div class="form-group">
                                                    <label for="editDescription">Mô Tả <span class="optional-label">(Tùy chọn)</span></label>
                                                    <textarea class="form-control" id="editDescription" name="description" placeholder="Nhập mô tả khóa học"></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editDuration">Thời Lượng <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="text" class="form-control" id="editDuration" name="duration" placeholder="Ví dụ: 3 tháng" />
                                                </div>
                                            </div>
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-money-bill-wave"></i> Giá & Giảm Giá</h6>
                                                <div class="form-group">
                                                    <label for="editPrice">Giá (VND) <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="number" class="form-control" id="editPrice" name="price" min="0" placeholder="Nhập giá khóa học" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editDiscountCode">Mã Giảm Giá <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="text" class="form-control" id="editDiscountCode" name="discountCode" placeholder="Ví dụ: DISCOUNT10" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editDiscountPercent">Phần Trăm Giảm Giá (%) <span class="optional-label">(Tùy chọn)</span></label>
                                                    <input type="number" class="form-control" id="editDiscountPercent" name="discountPercent" min="0" max="100" placeholder="0-100" />
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
                        <!-- View Course Details Modal -->
                        <div class="modal fade view-course-modal" id="viewCourseModal" tabindex="-1" aria-labelledby="viewCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="viewCourseModalLabel"><i class="fas fa-book"></i> Chi Tiết Khóa Học</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Khóa Học</h6>
                                            <div class="info-item">
                                                <span class="info-label">ID Khóa Học:</span>
                                                <span class="info-value" id="viewCourseId"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Tên Khóa Học:</span>
                                                <span class="info-value" id="viewCourseName"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Giảng Viên:</span>
                                                <span class="info-value" id="viewTeacher"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Số Học Viên:</span>
                                                <span class="info-value" id="viewStudents"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Cấp Độ:</span>
                                                <span class="info-value" id="viewLevel"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Trạng Thái:</span>
                                                <span class="info-value" id="viewStatus"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày Tạo:</span>
                                                <span class="info-value" id="viewCreatedDate"></span>
                                            </div>
                                        </div>
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-file-alt"></i> Mô Tả & Thời Lượng</h6>
                                            <div class="info-item">
                                                <span class="info-label">Mô Tả:</span>
                                                <span class="info-value" id="viewDescription"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Thời Lượng:</span>
                                                <span class="info-value" id="viewDuration"></span>
                                            </div>
                                        </div>
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-money-bill-wave"></i> Giá & Giảm Giá</h6>
                                            <div class="info-item">
                                                <span class="info-label">Giá (VND):</span>
                                                <span class="info-value" id="viewPrice"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Mã Giảm Giá:</span>
                                                <span class="info-value" id="viewDiscountCode"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Phần Trăm Giảm Giá:</span>
                                                <span class="info-value" id="viewDiscountPercent"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Block Course Confirmation Modal -->
                        <div class="modal fade block-course-modal" id="blockCourseModal" tabindex="-1" aria-labelledby="blockCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="blockCourseModalLabel"><i class="fas fa-lock"></i> Xác Nhận Khóa Khóa Học</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh Báo</h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn khóa khóa học <span id="blockCourseName"></span> (ID: <span id="blockCourseId"></span>)?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này sẽ tạm thời vô hiệu hóa khóa học. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                        <form action="/BlockCourseServlet" method="POST">
                                            <input type="hidden" id="blockCourseIdInput" name="courseId" />
                                            <button type="submit" class="btn btn-confirm-block">Khóa</button>
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
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaCourses.js"></script>

    </body>
</html>
