<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Course, model.student.Roadmap, java.util.List" %>
<%
Course course = (Course) request.getAttribute("course");
List<Roadmap> roadmaps = (List<Roadmap>) request.getAttribute("roadmaps");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>HIKARI | <%= course != null ? course.getTitle() + " - Lộ Trình" : "Lộ Trình Khóa Học" %></title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/index.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" /> 
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/roadmap.css" />
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
            <%= course != null ? course.getTitle() + " - Lộ Trình" : "Lộ Trình Khóa Học" %>
          </h1>
          <p class="text-white text-base">Hành trình chinh phục tiếng Nhật</p>
        </div>
        <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
      </div>
    </div>
  </div>

  <!-- Navigation Tabs -->
  <div class="flex justify-center mb-6 space-x-2">
      <a href="${pageContext.request.contextPath}/courseInfo?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
         class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Thông tin khóa học</a>
      <a href="${pageContext.request.contextPath}/roadmap?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
         class="tab-btn custom-active-btn px-5 py-2 font-semibold">Lộ trình khóa học</a>
      <a href="${pageContext.request.contextPath}/commitments?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
         class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Cam kết khóa học</a>
  </div>

  <!-- Roadmap Content -->
  <section class="roadmap-container max-w-4xl mx-auto mb-10">
    <h2 class="text-3xl font-bold text-center mb-8 bg-gradient-to-r from-orange-400 to-orange-600 bg-clip-text text-transparent animate-pulse-slow">
      Lộ Trình Học Tập
    </h2>
    <div class="roadmap-timeline">
      <% 
      if (roadmaps != null && !roadmaps.isEmpty()) {
          for (Roadmap roadmap : roadmaps) {
      %>
        <div class="roadmap-item">
          <div class="roadmap-marker"><%= roadmap.getStepNumber() %></div>
          <div class="roadmap-content">
            <h3 class="text-xl font-semibold text-gray-800"><%= roadmap.getTitle() %></h3>
            <p class="text-gray-600"><%= roadmap.getDescription() %></p>
            <p class="text-sm text-orange-600 font-semibold mt-2">
              <i class="fas fa-clock"></i> <%= roadmap.getDuration() %>
            </p>
          </div>
        </div>
      <%
          }
      } else {
      %>
        <div class="text-center">
          <p class="text-gray-500">Không có thông tin lộ trình cho khóa học này.</p>
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
</body>
</html>
