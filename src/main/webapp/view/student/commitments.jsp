<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Course, model.student.Commitment, java.util.List" %>
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
              <a href="${pageContext.request.contextPath}/courseInfo?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                 class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold hover:bg-gray-200 transition-colors">Thông tin khóa học</a>
              <a href="${pageContext.request.contextPath}/roadmap?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                 class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold hover:bg-gray-200 transition-colors">Lộ trình khóa học</a>
              <a href="${pageContext.request.contextPath}/commitments?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                 class="tab-btn custom-active-btn px-5 py-2 font-semibold bg-orange-500 text-white rounded-full shadow-md">Cam kết khóa học</a>
          </div>

        <!-- Commitments Content -->
          <section class="commitments-container max-w-6xl mx-auto mb-10 p-6 bg-white rounded-3xl shadow-xl">
              <h2 class="text-3xl font-bold text-center mb-8 bg-gradient-to-r from-orange-400 to-orange-600 bg-clip-text text-transparent animate-pulse-slow">
                  Cam Kết Của Chúng Tôi
              </h2>
              <div class="commitments-grid grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                  <% 
                  if (commitments != null && !commitments.isEmpty()) {
                      for (Commitment commitment : commitments) {
                  %>
                        <div class="commitment-card bg-gray-50 rounded-2xl overflow-hidden shadow-md hover:shadow-lg transition-shadow duration-300 transform hover:-translate-y-1">
                            <div class="commitment-image relative h-48">
                                <img src="${pageContext.request.contextPath}<%= commitment.getImageUrl() %>" 
                                     alt="<%= commitment.getTitle() %>" 
                                     class="w-full h-full object-cover" loading="lazy" 
                                     onerror="this.src='${pageContext.request.contextPath}/assets/img/course-placeholder.jpg';" />
                                <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
                            </div>
                            <div class="commitment-content p-6 text-center">
                                <div class="text-orange-500 text-4xl mb-4">
                                    <i class="<%= commitment.getIcon() %>"></i>
                                </div>
                                <h3 class="text-xl font-bold text-gray-900 mb-2"><%= commitment.getTitle() %></h3>
                                <p class="text-gray-700 text-base leading-relaxed"><%= commitment.getDescription() %></p>
                            </div>
                        </div>
                  <%
                      }
                  } else {
                  %>
                      <div class="col-span-full text-center py-10">
                          <p class="text-gray-500 text-lg">Không có thông tin cam kết cho khóa học này.</p>
                      </div>
                  <%
                  }
                  %>
              </div>
          </section>

        <!-- Buttons Section -->
          <section class="buttons-container max-w-4xl mx-auto mb-10 flex flex-col sm:flex-row justify-center space-y-4 sm:space-y-0 sm:space-x-4">
              <button id="courseActionBtn_<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                      data-course-id="<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>"
                      class="register-btn px-8 py-4 rounded-xl font-bold text-white bg-orange-500 hover:bg-orange-600 transition-colors shadow-lg transform hover:-translate-y-1" 
                      aria-label="Thêm vào giỏ hàng">
                  Thêm vào giỏ hàng
              </button>
              <a href="${pageContext.request.contextPath}/courses" 
                 class="other-courses-btn px-8 py-4 rounded-xl font-bold text-gray-800 bg-gray-200 hover:bg-gray-300 transition-colors shadow-lg transform hover:-translate-y-1" 
                 aria-label="Khóa học khác">
                 Khóa học khác
              </a>
          </section>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />
    </main>
</div>

<script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
<script>
    // Ensure contextPath is available for shopping.js
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/assets/js/student_js/shopping.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const courseId = "<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>";
        if (window.cart && courseId) {
            window.cart.updateCourseActionButton(courseId);
        }
    });
</script>
</body>
</html>
