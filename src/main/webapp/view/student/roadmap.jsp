<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>HIKARI | Lộ Trình Khóa Học</title>
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
            <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Hikari Course Roadmap Banner" class="absolute inset-0 w-full h-full object-cover" loading="lazy" />
            <div class="absolute inset-0 bg-black bg-opacity-20"></div>
            <div class="absolute left-8 top-8 z-10">
              <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">Lộ Trình Khóa Học</h1>
              <p class="text-white text-base">Hành trình chinh phục tiếng Nhật</p>
            </div>
            <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
          </div>
        </div>
      </div>

      <!-- Navigation Tabs (as Links) -->
      <div class="flex justify-center mb-6 space-x-2">
        <a href="courseInfo.jsp" class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Thông tin khóa học</a>
        <a href="roadmap.jsp" class="tab-btn custom-active-btn px-5 py-2 font-semibold">Lộ trình khóa học</a>
        <a href="commitments.jsp" class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Cam kết khóa học</a>
      </div>

      <!-- Roadmap Content -->
      <section class="roadmap-container max-w-4xl mx-auto mb-10">
        <h2 class="text-3xl font-bold text-center mb-8 bg-gradient-to-r from-orange-400 to-orange-600 bg-clip-text text-transparent animate-pulse-slow">Lộ Trình Học Tập</h2>
        <div class="roadmap-timeline">
          <div class="roadmap-item">
            <div class="roadmap-marker">1</div>
            <div class="roadmap-content">
              <h3 class="text-xl font-semibold text-gray-800">Tuần 1-2: Làm quen với tiếng Anh cơ bản</h3>
              <p class="text-gray-600">Tập trung vào kỹ năng Reading và Listening. Học viên sẽ làm quen với tiếng Anh cơ bản thông qua B2 qua các bài học cơ bản, kỹ năng phát âm nhịp nhàng.</p>
            </div>
          </div>
          <div class="roadmap-item">
            <div class="roadmap-marker">2</div>
            <div class="roadmap-content">
              <h3 class="text-xl font-semibold text-gray-800">Tuần 3-4: Phát triển kỹ năng cao</h3>
              <p class="text-gray-600">Thực hành Writing và Speaking với tiếng Anh nâng cao, học viên sẽ được nâng cao trong các tình huống thực tế, môi cách thực tế.</p>
            </div>
          </div>
          <div class="roadmap-item">
            <div class="roadmap-marker">3</div>
            <div class="roadmap-content">
              <h3 class="text-xl font-semibold text-gray-800">Tuần 5-6: Thực hành IELTS Computer Test</h3>
              <p class="text-gray-600">Làm quen với hình thức IELTS trên máy tính, tập trung cải thiện phần xá giao tiếp và kỹ năng nghe qua các bài tập chuyên sâu.</p>
            </div>
          </div>
          <div class="roadmap-item">
            <div class="roadmap-marker">4</div>
            <div class="roadmap-content">
              <h3 class="text-xl font-semibold text-gray-800">Tuần 7-8: Ôn tập và kiểm tra</h3>
              <p class="text-gray-600">Ôn tập toàn bộ kỹ năng, thực hiện bài kiểm tra mô phỏng IELTS, và nhận hỗ trợ từ đội ngũ chuyên gia để hoàn thiện trước kỳ thi.</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Buttons Section -->
      <section class="buttons-container max-w-4xl mx-auto mb-10 flex justify-center space-x-4">
        <a href="register.jsp" class="register-btn px-6 py-3 rounded-xl font-semibold" aria-label="Đăng ký ngay">Đăng ký ngay</a>
        <a href="otherCourses.jsp" class="other-courses-btn px-6 py-3 rounded-xl font-semibold" aria-label="Khóa học khác">Khóa học khác</a>
      </section>

      <!-- Footer -->
      <jsp:include page="footer.jsp" />
    </main>
  </div>

  <script src="${pageContext.request.contextPath}/assets/js/student_js/scripts.js"></script>
</body>
</html>