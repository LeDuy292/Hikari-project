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
                        <%                            
                            request.setAttribute("pageTitle", "Quản Lý Khóa Học");
                            request.setAttribute("showAddButton", true);
                            request.setAttribute("addButtonText", "Thêm Khóa Học");
                            request.setAttribute("addBtnLink", "addCourse.jsp");
                            request.setAttribute("addBtnIcon", "fa-book-medical");
                            request.setAttribute("pageIcon", "fa-book");
                            request.setAttribute("showNotification", false);
                        %>
                        <%@ include file="headerAdmin.jsp" %>


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
                                                <span class="badge ${course.isActive ? 'badge-active' : 'badge-inactive'}">
                                                    ${course.isActive ? 'Hoạt Động' : 'Không Hoạt Động'}
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${course.startDate}" pattern="dd/MM/yyyy"/></td>
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
                                                    <label for="courseID">ID Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="courseID" name="courseID" placeholder="Nhập ID khóa học" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="title">Tên Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="title" name="title" placeholder="Nhập tên khóa học" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="description">Mô Tả</label>
                                                    <textarea class="form-control" id="description" name="description" placeholder="Nhập mô tả khóa học"></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="fee">Học Phí (VND)</label>
                                                    <input type="number" class="form-control" id="fee" name="fee" min="0" placeholder="Nhập học phí" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="duration">Thời Lượng (tuần)</label>
                                                    <input type="number" class="form-control" id="duration" name="duration" min="1" placeholder="Nhập thời lượng" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="startDate">Ngày Bắt Đầu</label>
                                                    <input type="date" class="form-control" id="startDate" name="startDate" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="endDate">Ngày Kết Thúc</label>
                                                    <input type="date" class="form-control" id="endDate" name="endDate" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="isActive">Trạng Thái</label>
                                                    <select class="form-select" id="isActive" name="isActive">
                                                        <option value="true">Hoạt động</option>
                                                        <option value="false">Không hoạt động</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="imageUrl">URL Hình Ảnh</label>
                                                    <input type="url" class="form-control" id="imageUrl" name="imageUrl" placeholder="Nhập URL hình ảnh" />
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
                                    <form action="${pageContext.request.contextPath}/admin/courses" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editCourseID" name="courseID">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Khóa Học</h6>
                                                <div class="form-group">
                                                    <label for="editTitle">Tên Khóa Học <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="editTitle" name="title" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editDescription">Mô Tả</label>
                                                    <textarea class="form-control" id="editDescription" name="description"></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editFee">Học Phí (VND)</label>
                                                    <input type="number" class="form-control" id="editFee" name="fee" min="0" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editDuration">Thời Lượng (tuần)</label>
                                                    <input type="number" class="form-control" id="editDuration" name="duration" min="1" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editStartDate">Ngày Bắt Đầu</label>
                                                    <input type="date" class="form-control" id="editStartDate" name="startDate" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editEndDate">Ngày Kết Thúc</label>
                                                    <input type="date" class="form-control" id="editEndDate" name="endDate" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editIsActive">Trạng Thái</label>
                                                    <select class="form-select" id="editIsActive" name="isActive">
                                                        <option value="true">Hoạt động</option>
                                                        <option value="false">Không hoạt động</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editImageUrl">URL Hình Ảnh</label>
                                                    <input type="url" class="form-control" id="editImageUrl" name="imageUrl" />
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
                        <!-- Delete Course Modal -->
                        <div class="modal fade delete-course-modal" id="deleteCourseModal" tabindex="-1" aria-labelledby="deleteCourseModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="deleteCourseModalLabel"><i class="fas fa-trash"></i> Xác Nhận Xóa Khóa Học</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh Báo</h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn xóa khóa học <span id="deleteCourseTitle"></span> (ID: <span id="deleteCourseID"></span>)?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này không thể hoàn tác. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                        <form action="${pageContext.request.contextPath}/admin/courses" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" id="deleteConfirmCourseID" name="id">
                                            <button type="submit" class="btn btn-confirm-delete">Xóa</button>
                                        </form>
                                    </div>
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
        <script>
// JavaScript functions for modal handling
                                                            function viewCourse(courseId) {
                                                                // Send AJAX request to get course details
                                                                fetch('${pageContext.request.contextPath}/admin/courses?action=detail&id=' + courseId)
                                                                        .then(response => response.json())
                                                                        .then(data => {
                                                                            document.getElementById('viewCourseID').textContent = data.courseID;
                                                                            document.getElementById('viewCourseTitle').textContent = data.title;
                                                                            document.getElementById('viewCourseDescription').textContent = data.description || 'Không có mô tả';
                                                                            document.getElementById('viewCourseFee').textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.fee);
                                                                            document.getElementById('viewCourseDuration').textContent = data.duration + ' tuần';
                                                                            document.getElementById('viewCourseStartDate').textContent = new Date(data.startDate).toLocaleDateString('vi-VN');
                                                                            document.getElementById('viewCourseEndDate').textContent = new Date(data.endDate).toLocaleDateString('vi-VN');
                                                                            document.getElementById('viewCourseStatus').innerHTML = data.isActive ? '<span class="badge badge-active">Hoạt động</span>' : '<span class="badge badge-inactive">Không hoạt động</span>';

                                                                            var modal = new bootstrap.Modal(document.getElementById('viewCourseModal'));
                                                                            modal.show();
                                                                        })
                                                                        .catch(error => {
                                                                            console.error('Error:', error);
                                                                            alert('Có lỗi xảy ra khi tải thông tin khóa học');
                                                                        });
                                                            }

                                                            function editCourse(courseId) {
                                                                // Send AJAX request to get course details for editing
                                                                fetch('${pageContext.request.contextPath}/admin/courses?action=detail&id=' + courseId)
                                                                        .then(response => response.json())
                                                                        .then(data => {
                                                                            document.getElementById('editCourseID').value = data.courseID;
                                                                            document.getElementById('editTitle').value = data.title;
                                                                            document.getElementById('editDescription').value = data.description || '';
                                                                            document.getElementById('editFee').value = data.fee;
                                                                            document.getElementById('editDuration').value = data.duration;
                                                                            document.getElementById('editStartDate').value = data.startDate;
                                                                            document.getElementById('editEndDate').value = data.endDate;
                                                                            document.getElementById('editIsActive').value = data.isActive.toString();
                                                                            document.getElementById('editImageUrl').value = data.imageUrl || '';

                                                                            var modal = new bootstrap.Modal(document.getElementById('editCourseModal'));
                                                                            modal.show();
                                                                        })
                                                                        .catch(error => {
                                                                            console.error('Error:', error);
                                                                            alert('Có lỗi xảy ra khi tải thông tin khóa học');
                                                                        });
                                                            }

                                                            function deleteCourse(courseId) {
                                                                // Send AJAX request to get course details for deletion confirmation
                                                                fetch('${pageContext.request.contextPath}/admin/courses?action=detail&id=' + courseId)
                                                                        .then(response => response.json())
                                                                        .then(data => {
                                                                            document.getElementById('deleteCourseTitle').textContent = data.title;
                                                                            document.getElementById('deleteCourseID').textContent = data.courseID;
                                                                            document.getElementById('deleteConfirmCourseID').value = data.courseID;

                                                                            var modal = new bootstrap.Modal(document.getElementById('deleteCourseModal'));
                                                                            modal.show();
                                                                        })
                                                                        .catch(error => {
                                                                            console.error('Error:', error);
                                                                            alert('Có lỗi xảy ra khi tải thông tin khóa học');
                                                                        });
                                                            }
        </script>

    </body>
</html>