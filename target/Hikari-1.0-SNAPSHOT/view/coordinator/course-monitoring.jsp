<%@page import="model.Course"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giám Sát Khóa Học - Coordinator Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/course-monitoring.css" rel="stylesheet">

        <style>
            /* Lớp phủ mờ cho nền */
            .modal-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }

            /* Container cho form */
            .form-container {
                background-color: #ffffff;
                margin: 5% auto;
                padding: 30px;
                border-radius: 16px; /* Tăng bo góc */
                width: 100%;
                max-width: 600px; /* Tăng chiều rộng */
                position: relative;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            }

            /* Styling cho nút đóng */
            .close-button {
                position: absolute;
                top: 15px;
                right: 20px;
                cursor: pointer;
                font-size: 24px;
                color: #333;
                transition: color 0.3s;
            }

            .close-button:hover {
                color: #ff0000;
            }

            /* Styling cho tiêu đề */
            .form-title {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                font-size: 24px;
                font-weight: 600;
                color: #333;
                margin-bottom: 20px;
                text-align: center;
            }

            /* Styling cho form */
            .course-form {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* Styling cho các div chứa label và input */
            .form-group {
                margin-bottom: 20px;
            }

            /* Styling cho label */
            .form-label {
                display: block;
                font-size: 14px;
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }

            /* Styling cho input */
            .form-input {
                width: 100%;
                padding: 12px;
                border: 1px solid #dfe1e5;
                border-radius: 12px; /* Tăng bo góc */
                font-size: 14px;
                color: #333;
                background-color: #fafafa;
                transition: border-color 0.3s, box-shadow 0.3s;
                box-sizing: border-box;
            }

            /* Styling cho textarea */
            .form-textarea {
                width: 100%;
                padding: 12px;
                border: 1px solid #dfe1e5;
                border-radius: 12px; /* Tăng bo góc */
                font-size: 14px;
                color: #333;
                background-color: #fafafa;
                transition: border-color 0.3s, box-shadow 0.3s;
                box-sizing: border-box;
                resize: vertical;
                min-height: 100px;
            }

            /* Styling cho select */
            .form-select {
                width: 100%;
                padding: 12px;
                border: 1px solid #dfe1e5;
                border-radius: 12px; /* Tăng bo góc */
                font-size: 14px;
                color: #333;
                background-color: #fafafa;
                transition: border-color 0.3s, box-shadow 0.3s;
                box-sizing: border-box;
            }

            /* Hiệu ứng khi focus vào input, textarea, select */
            .form-input:focus, .form-textarea:focus, .form-select:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
                background-color: #fff;
            }

            /* Styling cho button */
            .submit-button {
                width: 100%;
                padding: 12px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 12px; /* Tăng bo góc */
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: background-color 0.3s, transform 0.2s;
            }

            /* Hiệu ứng hover và active cho button */
            .submit-button:hover {
                background-color: #0056b3;
                transform: translateY(-2px);
            }

            .submit-button:active {
                transform: translateY(0);
            }

            /* Responsive cho màn hình nhỏ */
            @media (max-width: 480px) {
                .form-container {
                    padding: 20px;
                    max-width: 90%; /* Giảm chiều rộng cho màn hình nhỏ */
                }

                .form-title {
                    font-size: 20px;
                }

                .form-label {
                    font-size: 12px;
                }

                .form-input, .form-textarea, .form-select, .submit-button {
                    font-size: 13px;
                }

                .close-button {
                    font-size: 20px;
                }
            }
            /*gợi ý*/
            .search-container {
                position: relative;
                max-width: 300px;
                margin: 20px;
            }
            
            .search-input-group {
                display: flex;
                align-items: center;
                background: #f8f9fa;
                border-radius: 12px;
                padding: 5px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            }
            
            .search-input {
                border: none;
                background: transparent;
                padding: 8px 12px;
                width: 100%;
                font-size: 14px;
            }
            
            .search-input:focus {
                outline: none;
            }
            
            .search-button {
                background: transparent;
                border: none;
                color: #007bff;
                padding: 8px 12px;
                cursor: pointer;
                transition: color 0.3s;
            }
            
            .search-button:hover {
                color: #0056b3;
            }
            
            .suggestions-container {
                position: absolute;
                width: 100%;
                background: white;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                max-height: 250px;
                overflow-y: auto;
                display: none;
                z-index: 1000;
                margin-top: 5px;
            }
            
            .suggestion-item {
                padding: 12px 16px;
                cursor: pointer;
                transition: background-color 0.2s;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .suggestion-item:last-child {
                border-bottom: none;
            }
            
            .suggestion-item:hover {
                background-color: #f8f9fa;
            }
        </style>
    </head>

    <body>
        <%
            List<Course> list = (List<Course>) request.getAttribute("list");
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
                                    <h5 class="course-card-title mb-0">Danh sách khóa học tiếng Nhật</h5>
                                    <div class="d-flex gap-2">
                                        <div class="search-container">
                                            <div class="search-input-group">
                                                <input type="text" class="search-input" id="searchInput" placeholder="Tìm kiếm khóa học...">
                                                <button class="search-button" id="searchButton">
                                                    <i class="fas fa-search"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <div id="suggestionsContainer" class="suggestions-container"></div>
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
                                                        <span class="course-status status-active">${course.isActive ? "Đang hoạt động" : "Không hoạt động"}</span>
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
                                                        <a href="LoadClass?id=${course.courseID}" class="btn btn-sm btn-outline-secondary" title="Xem lớp học">
                                                            <i class="fas fa-chalkboard-teacher"></i>
                                                        </a>
                                                        <a href="NextEditCourse?id=${course.courseNum}" class="btn btn-sm btn-outline-primary" title="Chỉnh sửa khóa học">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
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
                <form action="AddCourse" method="get" class="course-form">
                    <div class="form-group">
                        <label for="title" class="form-label">Tên khóa học:</label>
                        <input type="text" id="title" name="title" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label for="description" class="form-label">Mô tả:</label>
                        <textarea id="description" name="description" class="form-textarea" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="fee" class="form-label">Học phí:</label>
                        <input type="number" step="0.01" id="fee" name="fee" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label for="duration" class="form-label">Thời lượng (giờ):</label>
                        <input type="number" id="duration" name="duration" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label for="startDate" class="form-label">Ngày bắt đầu:</label>
                        <input type="date" id="startDate" name="startDate" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate" class="form-label">Ngày kết thúc:</label>
                        <input type="date" id="endDate" name="endDate" class="form-input" required>
                    </div>
                    <div class="form-group">
                        <label for="isActive" class="form-label">Hoạt động:</label>
                        <select id="isActive" name="isActive" class="form-select" required>
                            <option value="true">Có</option>
                            <option value="false">Không</option>
                        </select>
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
        </script>

        <script>
            const searchInput = document.getElementById('searchInput');
            const suggestionsContainer = document.getElementById('suggestionsContainer');
            const searchButton = document.getElementById('searchButton');
            const courseCards = document.querySelectorAll('.course-card');

            // Lấy dữ liệu khóa học từ các card hiện có
            const courseData = Array.from(courseCards).map(card => ({
                title: card.querySelector('.course-title').textContent,
                element: card.closest('.col-md-6')
            }));

            function filterCourses(query) {
                const searchTerm = query.toLowerCase();
                courseCards.forEach(card => {
                    const title = card.querySelector('.course-title').textContent.toLowerCase();
                    const parent = card.closest('.col-md-6');
                    
                    if (title.includes(searchTerm)) {
                        parent.style.display = '';
                    } else {
                        parent.style.display = 'none';
                    }
                });
            }

            function showSuggestions(query) {
                if (!query) {
                    suggestionsContainer.style.display = 'none';
                    return;
                }

                const filteredCourses = courseData.filter(course => 
                    course.title.toLowerCase().includes(query.toLowerCase())
                );

                if (filteredCourses.length > 0) {
                    suggestionsContainer.innerHTML = '';
                    filteredCourses.forEach(course => {
                        const div = document.createElement('div');
                        div.className = 'suggestion-item';
                        div.textContent = course.title;
                        div.addEventListener('click', () => {
                            searchInput.value = course.title;
                            suggestionsContainer.style.display = 'none';
                            filterCourses(course.title);
                        });
                        suggestionsContainer.appendChild(div);
                    });
                    suggestionsContainer.style.display = 'block';
                } else {
                    suggestionsContainer.style.display = 'none';
                }
            }

            // Xử lý sự kiện input
            searchInput.addEventListener('input', function() {
                const query = this.value.trim();
                showSuggestions(query);
                filterCourses(query);
            });

            // Đóng suggestions khi click ra ngoài
            document.addEventListener('click', function(e) {
                if (!searchInput.contains(e.target) && !suggestionsContainer.contains(e.target)) {
                    suggestionsContainer.style.display = 'none';
                }
            });

            // Xử lý sự kiện Enter
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    const query = this.value.trim();
                    filterCourses(query);
                    suggestionsContainer.style.display = 'none';
                }
            });

            // Xử lý sự kiện click nút tìm kiếm
            searchButton.addEventListener('click', function() {
                const query = searchInput.value.trim();
                filterCourses(query);
                suggestionsContainer.style.display = 'none';
            });
        </script>
    </body>
</html> 