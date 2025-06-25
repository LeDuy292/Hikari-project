<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Course, model.student.CourseInfo" %>
<%
Course course = (Course) request.getAttribute("course");
CourseInfo courseInfo = (CourseInfo) request.getAttribute("courseInfo");
String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>HIKARI | <%= (course != null && course.getTitle() != null) ? course.getTitle() : "Thông Tin Khóa Học" %></title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/index.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/roadmap.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/courseInfo.css" />
</head>
<body class="bg-[#f7f7fa] font-sans">
<div class="flex-container">
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main content -->
    <main class="flex-1 px-8 py-6 flex flex-col">
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Banner -->
        <div class="bg-white rounded-3xl overflow-hidden shadow-xl mb-8 mt-8">
            <div class="mt-2 px-8 pb-8">
                <div class="relative rounded-[2.5rem] overflow-hidden" style="height: 200px;">
                    <img src="${pageContext.request.contextPath}<%= (course != null && course.getImageUrl() != null) ? course.getImageUrl() : "/assets/img/img_student/study.jpg" %>" 
                         alt="<%= (course != null && course.getTitle() != null) ? course.getTitle() : "Course Banner" %>" 
                         class="absolute inset-0 w-full h-full object-cover" loading="lazy" 
                         onerror="this.src='${pageContext.request.contextPath}/assets/img/img_student/study.jpg';" />
                    <div class="absolute inset-0 bg-black bg-opacity-20"></div>
                    <div class="absolute left-8 top-8 z-10">
                        <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">
                            <%= (course != null && course.getTitle() != null) ? course.getTitle() : "Thông Tin Khóa Học" %>
                        </h1>
                        <p class="text-white text-base">Khám phá hành trình học tiếng Nhật</p>
                    </div>
                    <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
                </div>
            </div>
        </div>

        <!-- Navigation Tabs -->
        <div class="flex justify-center mb-6 space-x-2">
            <a href="${pageContext.request.contextPath}/courseInfo?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
               class="tab-btn custom-active-btn px-5 py-2 font-semibold">Thông tin khóa học</a>
            <a href="${pageContext.request.contextPath}/roadmap?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
               class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Lộ trình khóa học</a>
            <a href="${pageContext.request.contextPath}/commitments?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
               class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Cam kết khóa học</a>
        </div>

        <!-- Error Message from Servlet -->
        <% if (error != null) { %>
            <div class="bg-red-100 text-red-700 p-4 rounded-xl mb-6 text-center">
                <%= error.equals("no_data") ? "Không tìm thấy khóa học hoặc thông tin chi tiết." : "ID khóa học không hợp lệ." %>
            </div>
        <% } %>

        <!-- Course Info Content -->
        <section class="course-info-container max-w-4xl mx-auto mb-10">
            <h2 class="text-2xl font-bold text-center mb-6 text-gray-800">
                <%= (course != null && course.getTitle() != null) ? course.getTitle() : "Thông tin khóa học" %>
            </h2>
            
            <% if (course != null) { %>
                <% if (courseInfo != null) { %>
                    <div class="course-overview bg-white rounded-xl p-6 shadow-lg mb-6">
                        <h3 class="text-xl font-semibold text-gray-800 mb-4">Tổng quan khóa học</h3>
                        <p class="text-gray-600 mb-4"><%= courseInfo.getOverview() != null ? courseInfo.getOverview() : "Chưa có thông tin tổng quan" %></p>
                        <div class="objectives">
                            <h4 class="font-semibold text-gray-800 mb-2">Mục tiêu khóa học:</h4>
                            <div class="text-gray-600">
                                <%= courseInfo.getObjectives() != null ? courseInfo.getObjectives().replace("\n", "<br>") : "Chưa có mục tiêu" %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="course-levels bg-white rounded-xl p-6 shadow-lg mb-6">
                        <h3 class="text-xl font-semibold text-gray-800 mb-4">Mô tả trình độ</h3>
                        <p class="text-gray-600 mb-4"><%= courseInfo.getLevelDescription() != null ? courseInfo.getLevelDescription() : "Chưa có mô tả trình độ" %></p>
                        <div class="level-images flex flex-wrap gap-4 mb-4">
                            <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" 
                                 alt="Học viên học tập" class="w-32 h-32 object-cover rounded-lg" loading="lazy" />
                            <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" 
                                 alt="Học viên thực hành" class="w-32 h-32 object-cover rounded-lg" loading="lazy" />
                            <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" 
                                 alt="Học viên thi cử" class="w-32 h-32 object-cover rounded-lg" loading="lazy" />
                        </div>
                    </div>
                    
                    <div class="tuition-info bg-white rounded-xl p-6 shadow-lg">
                        <h3 class="text-xl font-semibold text-gray-800 mb-4">Thông tin học phí</h3>
                        <p class="text-gray-600 mb-4"><%= courseInfo.getTuitionInfo() != null ? courseInfo.getTuitionInfo() : "Chưa có thông tin học phí" %></p>
                        <p class="text-gray-600 mb-4"><strong>Thời gian:</strong> <%= courseInfo.getDuration() != null ? courseInfo.getDuration() : "Chưa xác định" %></p>
                        <div class="buttons flex justify-between mt-4">
                            <a href="${pageContext.request.contextPath}/courses" 
                               class="bg-gray-200 text-gray-700 px-4 py-2 rounded-full hover:bg-gray-300 transition-colors">
                                Khóa học khác
                            </a>
                            <button class="bg-orange-500 text-white px-4 py-2 rounded-full hover:bg-orange-600 transition-colors">
                                Đăng ký ngay
                            </button>
                        </div>
                    </div>
                <% } else { %>
                    <div class="bg-white rounded-xl p-6 shadow-lg">
                        <p class="text-gray-500 text-center">Không tìm thấy thông tin chi tiết cho khóa học này.</p>
                    </div>
                <% } %>
            <% } else { %>
                <div class="bg-white rounded-xl p-6 shadow-lg">
                    <p class="text-gray-500 text-center">Không tìm thấy khóa học.</p>
                </div>
            <% } %>
        </section>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/student_js/courseInfo.js"></script>
</body>
</html>
