<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>HIKARI | Tài liệu học tập</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/index.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" />
</head>
<body class="bg-[#f7f7fa] font-sans">
  <div class="flex-container">
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main content -->
    <main class="flex-1 px-8 py-6 flex flex-col" style="margin-left: 320px !important;">
      <!-- Header -->
      <jsp:include page="header.jsp" />

      <!-- Registration Modal -->
      <div class="modal" id="signupModal">
        <div class="modal-content">
          <span class="close" onclick="closeModal()">×</span>
          <h2>Đăng ký tài khoản</h2>
          <form action="${pageContext.request.contextPath}/register" method="post">
            <input type="text" name="fullName" placeholder="Họ và tên" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <select name="role" required>
              <option value="" disabled selected>Chọn vai trò</option>
              <option value="student">Học viên</option>
              <option value="teacher">Giáo viên</option>
            </select>
            <button type="submit">Đăng ký</button>
          </form>
        </div>
      </div>

      <!-- Banner -->
      <div class="bg-white rounded-3xl overflow-hidden shadow-xl mb-8 mt-8">
        <div class="mt-2 px-8 pb-8">
          <div class="relative rounded-[2.5rem] overflow-hidden" style="height: 200px;">
            <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" 
                 alt="Banner" 
                 class="absolute inset-0 w-full h-full object-cover" />
            <div class="absolute inset-0 bg-black bg-opacity-20"></div>
            <div class="absolute left-8 top-8 z-10">
              <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">Tài liệu học tập</h1>
              <p class="text-white text-base">Bộ sưu tập tài liệu học tiếng Nhật</p>
            </div>
            <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
          </div>
        </div>
      </div>

      <!-- Filter Section -->
      <div class="mb-6 flex flex-wrap gap-4">
        <select id="categorySelect" class="border border-orange-200 px-5 py-2 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-orange-200">
          <option value="">Tất cả danh mục</option>
          <option value="N5">N5</option>
          <option value="N4">N4</option>
          <option value="N3">N3</option>
          <option value="N2">N2</option>
          <option value="N1">N1</option>
          <option value="kanji">Kanji</option>
          <option value="grammar">Ngữ pháp</option>
          <option value="vocabulary">Từ vựng</option>
        </select>

        <c:if test="${not empty classes}">
          <select id="classSelect" class="border border-orange-200 px-5 py-2 rounded-full shadow-sm focus:outline-none focus:ring-2 focus:ring-orange-200">
            <option value="">Tất cả lớp học</option>
            <c:forEach var="classRoom" items="${classes}">
              <option value="${classRoom.classID}">${classRoom.name}</option>
            </c:forEach>
          </select>
        </c:if>

        <div class="text-sm text-gray-500" id="documentCount">
          Đang tải...
        </div>
      </div>

      <!-- Search Bar -->
      <div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-3">
        <div class="flex items-center space-x-2">
          <button class="px-5 py-2 custom-active-btn font-semibold shadow hover:shadow-lg transition">
            <i class="fa fa-file-pdf mr-2"></i>
            Tài liệu PDF
          </button>
        </div>
        <div class="relative w-full md:w-1/3">
          <input type="text" 
                 id="searchInput" 
                 placeholder="Tìm kiếm tài liệu..." 
                 class="border border-orange-200 px-5 py-2 rounded-full w-full pl-11 shadow-sm focus:outline-none focus:ring-2 focus:ring-orange-200">
          <i class="fa fa-search absolute left-4 top-1/2 transform -translate-y-1/2 text-orange-400"></i>
        </div>
      </div>

      <!-- Document List Section -->
      <div id="documentList" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-7 mb-10 transition-all duration-500 ease-in-out min-h-[400px]">
        <div class="col-span-full text-center py-8">
          <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-500 mx-auto mb-4"></div>
          <p class="text-gray-500">Đang tải tài liệu...</p>
        </div>
      </div>

      <!-- Pagination -->
      <div class="flex justify-center items-center space-x-2 mb-10">
        <button id="prevPage" class="pagination-btn disabled:opacity-50 disabled:cursor-not-allowed">
          <i class="fa fa-chevron-left"></i>
        </button>
        <div id="pageNumbers" class="flex space-x-2">
          <!-- Page numbers will be dynamically generated -->
        </div>
        <button id="nextPage" class="pagination-btn disabled:opacity-50 disabled:cursor-not-allowed">
          <i class="fa fa-chevron-right"></i>
        </button>
      </div>

      <!-- Error Message -->
      <div id="errorMessage" class="text-red-500 text-center mt-4 hidden">
        <i class="fa fa-exclamation-triangle mr-2"></i>
        Không tìm thấy tài liệu phù hợp.
      </div>

      <!-- Footer -->
      <jsp:include page="footer.jsp" />
    </main>
  </div>

  <!-- Load JavaScript -->
  <script src="${pageContext.request.contextPath}/assets/js/student_js/document.js"></script>
</body>
</html>