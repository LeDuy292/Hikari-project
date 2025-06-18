<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>HIKARI | Thông Tin Khóa Học</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/index.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/roadmap.css" />
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
            <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Hikari Course Info Banner" class="absolute inset-0 w-full h-full object-cover" loading="lazy" />
            <div class="absolute inset-0 bg-black bg-opacity-20"></div>
            <div class="absolute left-8 top-8 z-10">
              <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">Thông Tin Khóa Học</h1>
              <p class="text-white text-base">Khám phá hành trình học tiếng Nhật</p>
            </div>
            <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
          </div>
        </div>
      </div>

      <!-- Navigation Tabs (as Links) -->
      <div class="flex justify-center mb-6 space-x-2">
        <a href="courseInfo.jsp" class="tab-btn custom-active-btn px-5 py-2 font-semibold">Thông tin khóa học</a>
        <a href="roadmap.jsp" class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Lộ trình khóa học</a>
        <a href="commitments.jsp" class="tab-btn px-5 py-2 bg-gray-100 text-gray-700 rounded-full font-semibold">Cam kết khóa học</a>
      </div>

      <!-- Course Info Content -->
      <section class="course-info-container max-w-4xl mx-auto mb-10">
        <h2 class="text-2xl font-bold text-center mb-6 text-gray-800">Xây dựng và phát triển vốn từ vựng căn thiết trong trình độ B2</h2>
        <div class="course-overview bg-white rounded-xl p-6 shadow-lg mb-6">
          <ul class="list-disc list-inside text-gray-600 space-y-2">
            <li>Nắm vững vốn từ vựng và kỹ năng nghe hiểu trong các bài học Reading và Listening.</li>
            <li>Nắm vững cách tiếp cận các bài Writing trong các bài học cơ bản.</li>
            <li>Tăng cường thực hành rèn luyện kỹ năng trung cấp qua các bài luyện tập thực tế trên các bộ môn.</li>
            <li>Làm quen với việc thi trên máy tính IELTS Computer Test.</li>
          </ul>
        </div>
        <div class="course-levels bg-white rounded-xl p-6 shadow-lg mb-6">
          <h3 class="text-xl font-semibold text-gray-800 mb-4">Khóa học nâng cao trình độ viên đạt được trong thời gian ngắn</h3>
          <p class="text-gray-600 mb-4">Khóa học nâng cao trình độ viên đạt được trong thời gian ngắn. Với khóa học này, học viên sẽ được hỗ trợ luyện thi các kỹ năng Listening, Reading, Writing, Speaking. Khóa IELTS Intermediate sẽ hỗ trợ học viên nâng cao trình độ Part 1. Tất cả các kỹ năng này sẽ được hỗ trợ trong khóa học IELTS Beginner.</p>
          <div class="level-images flex flex-wrap gap-4 mb-4">
            <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" alt="Học viên học Listening" class="w-32 h-32 object-cover rounded-lg" loading="lazy" />
            <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" alt="Học viên học Reading" class="w-32 h-32 object-cover rounded-lg" loading="lazy" />
            <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" alt="Học viên học Writing" class="w-32 h-32 object-cover rounded-lg" loading="lazy" />
          </div>
        </div>
        <div class="tuition-info bg-white rounded-xl p-6 shadow-lg">
          <h3 class="text-xl font-semibold text-gray-800 mb-4">Học phí</h3>
          <p class="text-gray-600 mb-4">Học phí: 6.250.000 VND / 2.5 tháng. Phí này đã được tính trên cơ bản Writing được hỗ trợ Writing 8.5 chuẩn quốc tế. Ngay cả khi bạn không đạt được IELTS, bạn sẽ được hỗ trợ thêm trong vòng 5 ngày để hoàn thành mục tiêu của bạn.</p>
          <div class="buttons flex justify-between mt-4">
            <button class="bg-gray-200 text-gray-700 px-4 py-2 rounded-full hover:bg-gray-300 transition-colors">Khóa học khác</button>
            <button class="bg-orange-500 text-white px-4 py-2 rounded-full hover:bg-orange-600 transition-colors">Đăng ký ngay</button>
          </div>
        </div>
      </section>

      <!-- Footer -->
      <jsp:include page="footer.jsp" />
    </main>
  </div>

  <script src="${pageContext.request.contextPath}/assets/js/student_js/scripts.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/student_js/courseInfo.js"></script>
</body>
</html>