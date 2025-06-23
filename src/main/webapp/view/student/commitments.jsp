<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Course, model.Commitment, java.util.List" %>
<%
  Course course = (Course) request.getAttribute("course");
  List<Commitment> commitments = (List<Commitment>) request.getAttribute("commitments");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>HIKARI | <%= course != null ? course.getTitle() + " - Cam Kết" : "Cam Kết Khóa Học" %></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/index.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/roadmap.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/commitments.css" />
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
                        <img src="${pageContext.request.contextPath}<%= course != null ? course.getImageUrl() : "/assets/img/img_student/study.jpg" %>" 
                             alt="<%= course != null ? course.getTitle() : "Course Banner" %>" 
                             class="absolute inset-0 w-full h-full object-cover" loading="lazy" />
                        <div class="absolute inset-0 bg-black bg-opacity-20"></div>
                        <div class="absolute left-8 top-8 z-10">
                            <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">
                                <%= course != null ? course.getTitle() + " - Cam Kết" : "Cam Kết Khóa Học" %>
                            </h1>
                            <p class="text-white text-base">Đồng hành cùng bạn trên hành trình học tập</p>
                        </div>
                        <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
                    </div>
                </div>
            </div>

            <!-- Navigation Tabs -->
            <div class="flex justify-center mb-6 space-x-2">
                <a href="${pageContext.request.contextPath}/courseInfo?id=<%= (course != null && course.getCourseNum() != 0) ? course.getCourseNum() : "1" %>" 
                   class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Thông tin khóa học</a>
                <a href="${pageContext.request.contextPath}/roadmap?id=<%= (course != null && course.getCourseNum() != 0) ? course.getCourseNum() : "1" %>" 
                   class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Lộ trình khóa học</a>
                <a href="${pageContext.request.contextPath}/commitments?id=<%= (course != null && course.getCourseNum() != 0) ? course.getCourseNum() : "1" %>" 
                   class="tab-btn custom-active-btn px-5 py-2 font-semibold">Cam kết khóa học</a>
            </div>

            <!-- Commitments Content -->
            <section class="commitments-container max-w-4xl mx-auto mb-10">
                <h2 class="text-3xl font-bold text-center mb-8 bg-gradient-to-r from-orange-400 to-orange-600 bg-clip-text text-transparent animate-pulse-slow">
                    Cam Kết Của Chúng Tôi
                </h2>
                <div class="commitments-grid grid grid-cols-1 md:grid-cols-2 gap-6">
                    <% 
                    if (commitments != null && !commitments.isEmpty()) {
                        for (Commitment commitment : commitments) {
                    %>
                        <div class="commitment-card">
                            <div class="commitment-image">
                                <img src="${pageContext.request.contextPath}<%= commitment.getImageUrl() %>" 
                                     alt="<%= commitment.getTitle() %>" 
                                     class="w-full h-40 object-cover rounded-t-xl" loading="lazy" />
                            </div>
                            <div class="commitment-content">
                                <i class="<%= commitment.getIcon() %> text-orange-500 text-2xl mb-4"></i>
                                <h3 class="text-xl font-semibold text-gray-800 mb-2"><%= commitment.getTitle() %></h3>
                                <p class="text-gray-600"><%= commitment.getDescription() %></p>
                            </div>
                        </div>
                    <%
                        }
                    } else {
                    %>
                        <div class="col-span-2 text-center">
                            <p class="text-gray-500">Không có thông tin cam kết cho khóa học này.</p>
                        </div>
                    <%
                    }
                    %>
                </div>
            </section>

            <!-- Buttons Section -->
            <section class="buttons-container max-w-4xl mx-auto mb-10 flex justify-center space-x-4">
                <button class="register-btn px-6 py-3 rounded-xl font-semibold" aria-label="Đăng ký ngay">
                    Đăng ký ngay
                </button>
                <a href="${pageContext.request.contextPath}/courses" 
                   class="other-courses-btn px-6 py-3 rounded-xl font-semibold" aria-label="Khóa học khác">
                   Khóa học khác
                </a>
            </section>

            <!-- Footer -->
            <jsp:include page="footer.jsp" />
        </main>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/commitments.js"></script>
</body>
</html>