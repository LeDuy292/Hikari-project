<%@page import="model.Course"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giám Sát Khóa Học - Coordinator Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/course-monitoring.css" rel="stylesheet">
    </head>

    <body>
        <%
            List<Course> list = (List<Course>) request.getAttribute("list");
            int currentPage = (int) request.getAttribute("currentPage");
            int totalPages = (int) request.getAttribute("totalPages");
        %>
        <div class="d-flex">
            <!-- Sidebar -->
            <jsp:include page="sidebarCoordinator.jsp" />

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <jsp:include page="headerCoordinator.jsp" />

                <!-- Content -->
                <div class="content-wrapper">
                    <!-- Course List -->
                    <div class="row g-4">
                        <div class="col-12">
                            <div class="course-card-main">
                                <div class="course-card-header">
                                    <div class="filter-section">
                                        <form action="${pageContext.request.contextPath}/LoadCourse" method="GET" class="filter-form">
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
                                                <a href="${pageContext.request.contextPath}/LoadCourse" class="btn btn-reset">
                                                    <i class="fas fa-refresh"></i> Đặt Lại
                                                </a>
                                            </div>
                                        </form>
                                        <button class="btn btn-primary" onclick="openModal()">
                                            <i class="fas fa-plus me-2"></i>Thêm khóa học
                                        </button>
                                    </div>
                                </div>
                                <div class="course-card-body">
                                    <div class="row g-4">
                                        <c:if test="${empty list}">
                                            <div class="alert alert-warning text-center">
                                                Không có khóa học nào được tìm thấy.
                                            </div>
                                        </c:if>
                                        <c:forEach var="course" items="${list}">
                                            <div class="col-md-6 col-lg-4">
                                                <div class="course-card">
                                                    <div class="course-header">
                                                        <h6 class="course-title">${course.title}</h6>
                                                        <span class="course-status ${course.isActive ? 'status-active' : 'status-inactive'}">
                                                            ${course.isActive ? "Đang hoạt động" : "Không hoạt động"}
                                                        </span>
                                                    </div>
                                                    <div class="course-stats">
                                                        <div class="stat-item">
                                                            <i class="fas fa-users"></i>
                                                            <span>${course.classCount} Lớp học</span>
                                                        </div>
                                                        <div class="stat-item">
                                                            <i class="fas fa-clock"></i>
                                                            Bắt đầu:<span>${course.startDate}</span>Kết thúc:<span>${course.endDate}</span>
                                                        </div>
                                                        <div class="stat-item">
                                                            <i class="fas fa-chart-line"></i>
                                                            <span>75% hoàn thành</span>
                                                        </div>
                                                    </div>
                                                    <div class="course-progress">
                                                        <div class="progress">
                                                            <div class="progress-bar" role="progressbar" style="width: 75%"></div>
                                                        </div>
                                                    </div>
                                                    <div class="course-actions">
                                                        <a href="LoadClass?courseID=${course.courseID}"" class="btn btn-sm btn-outline-secondary" title="Xem lớp học">
                                                            <i class="fas fa-chalkboard-teacher"></i>
                                                        </a>
                                                        <a href="NextEditCourse?id=${course.courseID}" class="btn btn-sm btn-outline-primary" title="Chỉnh sửa khóa học">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <a href="LessonApprovalServlet?courseID=${course.courseID}" class="btn btn-sm btn-outline-success" title="Phê duyệt bài học">
                                                            <i class="fas fa-check-circle"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <nav aria-label="Course pagination">
                                        <ul class="pagination justify-content-center mt-4">
                                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                <a class="page-link" href="LoadCourse?page=${currentPage - 1}">Trước</a>
                                            </li>
                                            <c:forEach begin="1" end="${totalPages}" var="i">
                                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                    <a class="page-link" href="LoadCourse?page=${i}">${i}</a>
                                                </li>
                                            </c:forEach>
                                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                <a class="page-link" href="LoadCourse?page=${currentPage + 1}">Sau</a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <div id="addCourseModal" class="modal-overlay">
            <div class="form-container">
                <span onclick="closeModal()" class="close-button">×</span>
                <h2 class="form-title">Thêm Khóa Học</h2>
                <form action="AddCourse" method="post" class="course-form" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="courseID" class="form-label">Mã khóa học:</label> <!-- Thêm trường courseID -->
                        <input type="text" id="courseID" name="courseID" class="form-input" required>
                        <span class="error-message" id="courseID-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="title" class="form-label">Tên khóa học:</label>
                        <input type="text" id="title" name="title" class="form-input" required>
                        <span class="error-message" id="title-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="description" class="form-label">Mô tả:</label>
                        <textarea id="description" name="description" class="form-textarea" required></textarea>
                        <span class="error-message" id="description-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="fee" class="form-label">Học phí:</label>
                        <input type="number" step="0.01" id="fee" name="fee" class="form-input" required>
                        <span class="error-message" id="fee-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="duration" class="form-label">Thời lượng (giờ):</label>
                        <input type="number" id="duration" name="duration" class="form-input" required>
                        <span class="error-message" id="duration-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="startDate" class="form-label">Ngày bắt đầu:</label>
                        <input type="date" id="startDate" name="startDate" class="form-input" required>
                        <span class="error-message" id="startDate-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="endDate" class="form-label">Ngày kết thúc:</label>
                        <input type="date" id="endDate" name="endDate" class="form-input" required>
                         <span class="error-message" id="endDate-error"></span>
                    </div>
                    <div class="form-group">
                        <label for="isActive" class="form-label">Hoạt động:</label>
                        <select id="isActive" name="isActive" class="form-select" required>
                            <option value="true">Có</option>
                            <option value="false">Không</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="imageUrl" class="form-label">Ảnh khóa học:</label> <!-- Thay đổi: Thêm label cho input file -->
                        <input type="file" id="imageUrl" name="imageUrl" class="form-input" accept="image/png,image/jpeg,image/jpg"> <!-- Thay đổi: Thêm input file cho ảnh -->
                        <span class="error-message" id="imageUrl-error"></span> <!-- Thay đổi: Thêm span để hiển thị lỗi -->
                        <div class="image-preview">
                            <img id="imagePreview" src="" alt="Course Image Preview" style="display: none; max-width: 200px; border-radius: 12px; margin-top: 10px;"> <!-- Thay đổi: Thêm preview ảnh -->
                        </div>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="submit-button">Thêm khóa học</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openModal() {
                document.getElementById('addCourseModal').style.display = 'flex';
            }
            function closeModal() {
                document.getElementById('addCourseModal').style.display = 'none';
            }
            document.getElementById('addCourseModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeModal();
                }
            });

//            const searchInput = document.getElementById('searchInput');
//            const suggestionsContainer = document.getElementById('suggestionsContainer');
//            const searchButton = document.getElementById('searchButton');
//            const courseCards = document.querySelectorAll('.course-card');
//
//            // Lấy dữ liệu khóa học từ các card hiện có
//            const courseData = Array.from(courseCards).map(card => ({
//                    title: card.querySelector('.course-title').textContent,
//                    element: card.closest('.col-md-6')
//                }));
//
//            function filterCourses(query) {
//                const searchTerm = query.toLowerCase();
//                courseCards.forEach(card => {
//                    const title = card.querySelector('.course-title').textContent.toLowerCase();
//                    const parent = card.closest('.col-md-6');
//
//                    if (title.includes(searchTerm)) {
//                        parent.style.display = '';
//                    } else {
//                        parent.style.display = 'none';
//                    }
//                });
//            }
//
//            function showSuggestions(query) {
//                if (!query) {
//                    suggestionsContainer.style.display = 'none';
//                    return;
//                }
//
//                const filteredCourses = courseData.filter(course =>
//                    course.title.toLowerCase().includes(query.toLowerCase())
//                );
//
//                if (filteredCourses.length > 0) {
//                    suggestionsContainer.innerHTML = '';
//                    filteredCourses.forEach(course => {
//                        const div = document.createElement('div');
//                        div.className = 'suggestion-item';
//                        div.textContent = course.title;
//                        div.addEventListener('click', () => {
//                            searchInput.value = course.title;
//                            suggestionsContainer.style.display = 'none';
//                            filterCourses(course.title);
//                        });
//                        suggestionsContainer.appendChild(div);
//                    });
//                    suggestionsContainer.style.display = 'block';
//                } else {
//                    suggestionsContainer.style.display = 'none';
//                }
//            }
//
//            // Xử lý sự kiện input
//            searchInput.addEventListener('input', function () {
//                const query = this.value.trim();
//                showSuggestions(query);
//                filterCourses(query);
//            });
//
//            // Đóng suggestions khi click ra ngoài
//            document.addEventListener('click', function (e) {
//                if (!searchInput.contains(e.target) && !suggestionsContainer.contains(e.target)) {
//                    suggestionsContainer.style.display = 'none';
//                }
//            });
//
//            // Xử lý sự kiện Enter
//            searchInput.addEventListener('keypress', function (e) {
//                if (e.key === 'Enter') {
//                    const query = this.value.trim();
//                    filterCourses(query);
//                    suggestionsContainer.style.display = 'none';
//                }
//            });
//
//            // Xử lý sự kiện click nút tìm kiếm
//            searchButton.addEventListener('click', function () {
//                const query = searchInput.value.trim();
//                filterCourses(query);
//                suggestionsContainer.style.display = 'none';
//            });

            // Thay đổi: Thêm JavaScript để xử lý preview và validation cho ảnh
            document.getElementById('imageUrl').addEventListener('change', function (event) {
                const file = event.target.files[0];
                const preview = document.getElementById('imagePreview');
                const error = document.getElementById('imageUrl-error');

                if (file) {
                    const validTypes = ['image/png', 'image/jpeg', 'image/jpg'];
                    if (!validTypes.includes(file.type)) {
                        error.textContent = 'Vui lòng chọn file ảnh (PNG, JPG, JPEG)';
                        error.style.display = 'block';
                        this.value = '';
                        preview.style.display = 'none';
                        return;
                    }
                    if (file.size > 5 * 1024 * 1024) {
                        error.textContent = 'Kích thước ảnh không được vượt quá 5MB';
                        error.style.display = 'block';
                        this.value = '';
                        preview.style.display = 'none';
                        return;
                    }

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                    error.textContent = '';
                    error.style.display = 'none';
                } else {
                    preview.style.display = 'none';
                }
            });

            // Thay đổi: Thêm validation cho form khi submit
            document.querySelector('#addCourseModal .course-form').addEventListener('submit', function (e) {
                let isValid = true;
                const title = document.getElementById('title').value.trim();
                const description = document.getElementById('description').value.trim();
                const fee = parseFloat(document.getElementById('fee').value);
                const duration = parseInt(document.getElementById('duration').value);
                const startDate = document.getElementById('startDate').value;
                const endDate = document.getElementById('endDate').value;
                const imageUrl = document.getElementById('imageUrl').files[0];

                // Reset error messages
                document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');

                if (!title) {
                    document.getElementById('title-error').textContent = 'Vui lòng nhập tên khóa học';
                    document.getElementById('title-error').style.display = 'block';
                    isValid = false;
                }
                if (!description) {
                    document.getElementById('description-error').textContent = 'Vui lòng nhập mô tả';
                    document.getElementById('description-error').style.display = 'block';
                    isValid = false;
                }
                if (isNaN(fee) || fee <= 0) {
                    document.getElementById('fee-error').textContent = 'Học phí phải lớn hơn 0';
                    document.getElementById('fee-error').style.display = 'block';
                    isValid = false;
                }
                if (isNaN(duration) || duration <= 0) {
                    document.getElementById('duration-error').textContent = 'Thời lượng phải lớn hơn 0';
                    document.getElementById('duration-error').style.display = 'block';
                    isValid = false;
                }
                if (!startDate) {
                    document.getElementById('startDate-error').textContent = 'Vui lòng chọn ngày bắt đầu';
                    document.getElementById('startDate-error').style.display = 'block';
                    isValid = false;
                }
                if (!endDate) {
                    document.getElementById('endDate-error').textContent = 'Vui lòng chọn ngày kết thúc';
                    document.getElementById('endDate-error').style.display = 'block';
                    isValid = false;
                } else if (startDate && endDate && new Date(startDate) > new Date(endDate)) {
                    document.getElementById('endDate-error').textContent = 'Ngày kết thúc phải sau ngày bắt đầu';
                    document.getElementById('endDate-error').style.display = 'block';
                    isValid = false;
                }
                if (imageUrl) {
                    const validTypes = ['image/png', 'image/jpeg', 'image/jpg'];
                    if (!validTypes.includes(imageUrl.type)) {
                        document.getElementById('imageUrl-error').textContent = 'Vui lòng chọn file ảnh (PNG, JPG, JPEG)';
                        document.getElementById('imageUrl-error').style.display = 'block';
                        isValid = false;
                    }
                    if (imageUrl.size > 5 * 1024 * 1024) {
                        document.getElementById('imageUrl-error').textContent = 'Kích thước ảnh không được vượt quá 5MB';
                        document.getElementById('imageUrl-error').style.display = 'block';
                        isValid = false;
                    }
                }

                if (!isValid) {
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html> 