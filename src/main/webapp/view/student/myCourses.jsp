
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserAccount, model.Course, java.util.List, java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Khóa học của tôi - Học Tiếng Nhật Online</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; }
        .back-btn {
            display: inline-flex; align-items: center; gap: 8px; padding: 10px 16px;
            background: #ff6b35; color: white; text-decoration: none; border-radius: 8px;
            font-weight: 500; margin-bottom: 20px; font-size: 14px; transition: background 0.2s ease;
        }
        .back-btn:hover { background: #e55a2b; }
        .tab-navigation {
            display: flex; background: white; border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); margin-bottom: 20px; overflow: hidden;
        }
        .tab-btn {
            flex: 1; padding: 16px 20px; background: none; border: none;
            font-size: 14px; font-weight: 500; color: #666; cursor: pointer;
            transition: all 0.2s ease; display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        .tab-btn.active { background: #ff6b35; color: white; }
        .tab-btn:hover:not(.active) { background: #f8f9fa; color: #333; }
        .main-grid { display: grid; grid-template-columns: 1fr 350px; gap: 20px; }
        @media (max-width: 1024px) { .main-grid { grid-template-columns: 1fr; } }
        .course-list { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); padding: 20px; }
        .filter-controls { margin-bottom: 20px; display: flex; align-items: center; gap: 16px; }
        .filter-group { display: inline-flex; align-items: center; gap: 10px; }
        .filter-label { font-size: 14px; font-weight: 500; color: #333; }
        .filter-select {
            padding: 8px; border-radius: 8px; border: 1px solid #e9ecef;
            font-size: 14px; background: #f8f9fa; cursor: pointer;
        }
        .course-card {
            display: flex; align-items: center; padding: 16px; margin-bottom: 16px;
            background: #f8f9fa; border-radius: 8px; border: 1px solid #e9ecef;
            transition: all 0.2s ease;
        }
        .course-card:hover { transform: translateX(4px); border-color: #ff6b35; }
        .course-image {
            width: 150px; height: 100px; object-fit: cover; border-radius: 8px; margin-right: 16px;
        }
        .course-content { flex-grow: 1; }
        .course-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; }
        .course-title { font-size: 18px; font-weight: 600; color: #333; margin: 0; }
        .course-meta { display: flex; gap: 10px; color: #666; font-size: 14px; margin-top: 4px; }
        .meta-item i { margin-right: 4px; }
        .course-status {
            padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 500; color: white;
        }
        .status-in-progress { background: #17a2b8; }
        .status-completed { background: #28a745; }
        .course-description {
            font-size: 14px; color: #666; margin: 8px 0; line-height: 1.5;
        }
        .progress-section { margin: 8px 0; }
        .progress-header {
            display: flex; justify-content: space-between; font-size: 14px; margin-bottom: 4px;
        }
        .progress-label { color: #333; font-weight: 500; }
        .progress-value { color: #ff6b35; font-weight: 600; }
        .progress-bar {
            width: 100%; height: 8px; background: #e9ecef; border-radius: 4px; overflow: hidden;
        }
        .progress-fill {
            height: 100%; background: #ff6b35; transition: width 0.3s ease;
        }
        .course-actions { display: flex; gap: 8px; margin-top: 8px; }
        .action-btn {
            padding: 8px 16px; border: none; border-radius: 8px; font-size: 14px;
            font-weight: 500; cursor: pointer; transition: background 0.2s ease; display: flex; align-items: center; gap: 4px;
        }
        .btn-primary { background: #ff6b35; color: white; }
        .btn-primary:hover { background: #e55a2b; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        .empty-state {
            text-align: center; padding: 24px; background: white;
            border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); color: #666;
        }
        .empty-state h3 { font-size: 18px; margin-bottom: 8px; }
        .empty-state p { font-size: 14px; }
        .empty-state i { font-size: 24px; color: #ff6b35; margin-bottom: 8px; }
        .sidebar {
            display: flex; flex-direction: column; gap: 16px;
        }
        .sidebar-card {
            background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); overflow: hidden;
        }
        .card-header {
            padding: 16px; background: #ff6b35; color: white; display: flex; align-items: center; gap: 8px;
        }
        .card-header h3 { font-size: 16px; font-weight: 600; margin: 0; }
        .card-header p { font-size: 12px; opacity: 0.9; margin: 2px 0 0 0; }
        .card-content { padding: 16px; }
        .stats-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px;
        }
        .stat-item {
            text-align: center; padding: 12px; background: #f8f9fa; border-radius: 8px;
        }
        .stat-number {
            font-size: 24px; font-weight: 700; color: #ff6b35; margin-bottom: 4px;
        }
        .stat-label { font-size: 12px; color: #666; }
        .main-stat { text-align: center; margin-bottom: 16px; }
        .main-stat-number { font-size: 36px; font-weight: 700; color: #ff6b35; margin-bottom: 4px; }
        .main-stat-label { font-size: 14px; font-weight: 500; color: #333; }
        .message {
            margin-top: 12px; padding: 12px; border-radius: 6px; text-align: center; font-size: 14px; font-weight: 500;
        }
        .message.error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>
    <div class="container">
        <%
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/loginPage?error=Phiên+làm+việc+hết+hạn");
                return;
            }
            @SuppressWarnings("unchecked")
            List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
            @SuppressWarnings("unchecked")
            Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
            if (enrolledCourses == null) enrolledCourses = new java.util.ArrayList<>();
            if (stats == null) stats = new java.util.HashMap<>();
            String statsError = null;
            if (!stats.containsKey("averageProgress") || !stats.containsKey("totalCourses") ||
                !stats.containsKey("completedCourses") || !stats.containsKey("totalHours")) {
                statsError = "Dữ liệu thống kê không đầy đủ. Vui lòng liên hệ quản trị viên.";
            }
            
            // Debug information
            System.out.println("DEBUG - myCourses.jsp:");
            System.out.println("User ID: " + user.getUserID());
            System.out.println("Enrolled courses count: " + (enrolledCourses != null ? enrolledCourses.size() : "null"));
            System.out.println("Stats keys: " + (stats != null ? stats.keySet() : "null"));
            if (stats != null) {
                for (Map.Entry<String, Object> entry : stats.entrySet()) {
                    System.out.println("  " + entry.getKey() + " = " + entry.getValue());
                }
            }
        %>

        <c:set var="averageProgress" value="${stats['averageProgress'] != null ? stats['averageProgress'] : 0}" />
        <c:set var="totalCourses" value="${stats['totalCourses'] != null ? stats['totalCourses'] : 0}" />
        <c:set var="completedCourses" value="${stats['completedCourses'] != null ? stats['completedCourses'] : 0}" />
        <c:set var="totalHours" value="${stats['totalHours'] != null ? stats['totalHours'] : 0}" />

        <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Trang chủ
        </a>

       <div class="tab-navigation">
            <button class="tab-btn active" onclick="window.location.href='${pageContext.request.contextPath}/view/authentication/profile.jsp'">
                <i class="fas fa-user"></i>
                Thông tin cá nhân
            </button>
            <button class="tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/myCourses'">

                <i class="fas fa-book"></i>
                Khóa học của tôi 
            </button>
            <button class="tab-btn" onclick="window.location.href='${pageContext.request.contextPath}/profile/paymentHistory'">
                <i class="fas fa-credit-card"></i>
                Lịch sử mua hàng
            </button>
        </div>
        <div class="main-grid">
            <div class="course-list">
                <div class="filter-controls">
                    <div class="filter-group">
                        <label class="filter-label" for="courseSortFilter">Sắp xếp:</label>
                        <select class="filter-select" id="courseSortFilter" onchange="sortCourses()">
                            <option value="title">Tên khóa học</option>
                            <option value="progress">Tiến độ</option>
                        </select>
                    </div>
                </div>
                <c:if test="${not empty statsError}">
                    <div class="message error">${statsError}</div>
                </c:if>
                <c:choose>
                    <c:when test="${empty enrolledCourses}">
                        <div class="empty-state">
                            <i class="fas fa-book-open"></i>
                            <h3>Chưa có khóa học nào</h3>
                            <p>Bạn chưa đăng ký khóa học nào. Hãy khám phá các khóa học của chúng tôi!</p>
                            <a href="${pageContext.request.contextPath}/view/courses.jsp" class="action-btn btn-primary">
                                <i class="fas fa-search"></i> Khám phá ngay
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="course" items="${enrolledCourses}">
                            <c:set var="progress" value="${stats[course.courseID] != null ? stats[course.courseID] : 0}" />
                            <div class="course-card" data-progress="${progress}">
                                <img src="${pageContext.request.contextPath}${not empty course.imageUrl ? course.imageUrl : '/assets/img/img_student/course.jpg'}"
                                     alt="${course.title}" class="course-image">
                                <div class="course-content">
                                    <div class="course-header">
                                        <div>
                                            <h3 class="course-title">${course.title}</h3>
                                            <div class="course-meta">
                                            </div>
                                        </div>
                                        <span class="course-status ${progress >= 100 ? 'status-completed' : 'status-in-progress'}">
                                            ${progress >= 100 ? 'Hoàn thành' : 'Đang học'}
                                        </span>
                                    </div>
                                    <p class="course-description">
                                        ${not empty course.description ?
                                            (course.description.length() > 100 ?
                                                course.description.substring(0, 100) + "..." :
                                                course.description) : "Không có mô tả"}
                                    </p>
                                    <div class="progress-section">
                                        <div class="progress-bar">
                                            <div class="progress-fill" style="width: <c:out value='${progress}'/>%;"></div>
                                        </div>
                                    </div>
                                    <div class="course-actions">
                                        <button class="action-btn btn-primary" onclick="continueCourse('${course.courseID}')" aria-label="Tiếp tục học ${course.title}">
                                            <i class="fas fa-play"></i> 
                                            ${progress >= 100 ? 'Ôn tập' : 'Tiếp tục học'}
                                        </button>
                                        <button class="action-btn btn-secondary" onclick="viewCourseDetails('${course.courseID}')" aria-label="Xem chi tiết ${course.title}">
                                            <i class="fas fa-info-circle"></i> Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                <div class="message" id="errorMessage" style="display: none;"></div>
            </div>

            <div class="sidebar">
                <div class="sidebar-card">
                    <div class="card-header stats">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="card-content">
                        <div class="main-stat">
                            <div class="main-stat-number">
                                <c:choose>
                                    <c:when test="${averageProgress != null && averageProgress.getClass().name == 'java.lang.Double'}">
                                        <fmt:formatNumber value="${averageProgress}" type="number" maxFractionDigits="0"/>%
                                    </c:when>
                                    <c:otherwise>0%</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="main-stat-label">Tiến độ trung bình</div>
                        </div>
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:choose>
                                        <c:when test="${totalCourses != null && totalCourses.getClass().name == 'java.lang.Integer'}">
                                            ${totalCourses}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-label">Khóa học</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:choose>
                                        <c:when test="${completedCourses != null && completedCourses.getClass().name == 'java.lang.Integer'}">
                                            ${completedCourses}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="stat-label">Hoàn thành</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">
                                    <c:choose>
                                        <c:when test="${totalHours != null && totalHours.getClass().name == 'java.lang.Double'}">
                                            <fmt:formatNumber value="${totalHours}" type="number" maxFractionDigits="0"/>
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function sortCourses() {
            const select = document.getElementById("courseSortFilter");
            const value = select.value;
            const courseList = document.querySelector(".course-list");
            const courses = Array.from(courseList.getElementsByClassName("course-card"));

            courses.sort((a, b) => {
                const aTitle = a.querySelector(".course-title").textContent;
                const bTitle = b.querySelector(".course-title").textContent;
                const aProgress = parseFloat(a.dataset.progress) || 0;
                const bProgress = parseFloat(b.dataset.progress) || 0;
                if (value === "title") return aTitle.localeCompare(bTitle);
                if (value === "progress") return bProgress - aProgress;
                return 0;
            });

            courses.forEach(course => courseList.appendChild(course));
        }

        function continueCourse(courseId) {
            try {
                window.location.href = "${pageContext.request.contextPath}/view/student/courseDetail.jsp?courseId=" + encodeURIComponent(courseId);
            } catch (e) {
                const errorMessage = document.getElementById("errorMessage");
                errorMessage.className = "message error";
                errorMessage.innerText = "Lỗi khi chuyển hướng đến khóa học. Vui lòng thử lại.";
                errorMessage.style.display = "block";
            }
        }

        function viewCourseDetails(courseId) {
            try {
                window.location.href = "${pageContext.request.contextPath}/view/student/courseDetail.jsp?courseId=" + encodeURIComponent(courseId);
            } catch (e) {
                const errorMessage = document.getElementById("errorMessage");
                errorMessage.className = "message error";
                errorMessage.innerText = "Lỗi khi xem chi tiết khóa học. Vui lòng thử lại.";
                errorMessage.style.display = "block";
            }
        }
    </script>
</body>
</html>
