<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>HIKARI | Khóa học</title>
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css?v=1"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css?v=1"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css?v=1"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/shopping.css?v=1"/>
<script>
  window.contextPath = '${pageContext.request.contextPath}';
</script>
</head>
<body class="bg-[#f7f7fa] font-sans">
<div class="flex min-h-screen">
  <!-- Sidebar -->
  <%@ include file="sidebar.jsp" %>
  <!-- Main content -->
  <main class="flex-1 px-8 py-6 flex flex-col min-h-screen" style="margin-left: 270px;">
      <!-- Header -->
      <%@ include file="header.jsp" %>
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
                  <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Banner" class="absolute inset-0 w-full h-full object-cover" />
                  <div class="absolute inset-0 bg-black bg-opacity-20"></div>
                  <div class="absolute left-8 top-8 z-10">
                      <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">Khóa học trực tuyến</h1>
                      <p class="text-white text-base">Khám phá các khóa học tiếng Nhật chất lượng cao</p>
                  </div>
                  <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
              </div>
          </div>
      </div>
      <!-- Course Categories and Search -->
      <div class="bg-white rounded-3xl shadow-xl p-6 mb-8">
          <div class="flex flex-col md:flex-row justify-between items-center mb-6">
              <div class="flex space-x-4 mb-4 md:mb-0">
                  <a href="${pageContext.request.contextPath}/courses?category=paid" class="px-4 py-2 rounded-full text-sm font-semibold ${param.category == null || param.category == 'paid' ? 'bg-orange-500 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">Khóa học trả phí</a>
                  <a href="${pageContext.request.contextPath}/courses?category=free" class="px-4 py-2 rounded-full text-sm font-semibold ${param.category == 'free' ? 'bg-orange-500 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">Khóa học miễn phí</a>
              </div>
              <form action="${pageContext.request.contextPath}/courses" method="get" class="w-full md:w-auto flex">
                  <input type="hidden" name="action" value="list">
                  <input type="hidden" name="category" value="${param.category != null ? param.category : 'paid'}">
                  <input type="text" name="search" placeholder="Tìm kiếm khóa học..." class="flex-1 border border-gray-300 rounded-l-full px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200" value="${param.search != null ? param.search : ''}">
                  <button type="submit" class="bg-orange-500 text-white px-5 py-2 rounded-r-full hover:bg-orange-600 transition">
                      <i class="fa fa-search"></i>
                  </button>
              </form>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <c:choose>
                  <c:when test="${empty courses}">
                      <div class="col-span-full text-center py-10 text-gray-500">
                          <i class="fa fa-exclamation-circle text-4xl mb-4"></i>
                          <p class="text-lg">Không tìm thấy khóa học nào phù hợp.</p>
                      </div>
                  </c:when>
                  <c:otherwise>
                      <!-- Pagination Logic -->
                      <c:set var="pageSize" value="6"/>
                      <c:set var="currentPage" value="${param.page != null ? param.page : 1}"/>
                      <c:set var="totalCourses" value="${courses.size()}"/>
                      <c:set var="totalPages" value="${(totalCourses + pageSize - 1) div pageSize}"/>
                      <c:set var="startIndex" value="${(currentPage - 1) * pageSize}"/>
                      <c:set var="endIndex" value="${startIndex + pageSize - 1 < totalCourses ? startIndex + pageSize - 1 : totalCourses - 1}"/>

                      <c:forEach var="course" items="${courses}" begin="${startIndex}" end="${endIndex}">
                          <div class="bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                              <a href="${pageContext.request.contextPath}/courseInfo?id=${course.courseID}">
                                  <img src="${pageContext.request.contextPath}${course.imageUrl != null && course.imageUrl != '' ? course.imageUrl : '/assets/img/course-placeholder.jpg'}" alt="${course.title}" class="w-full h-48 object-cover">
                              </a>
                              <div class="p-5">
                                  <h3 class="text-xl font-bold text-gray-800 mb-2">
                                      <a href="${pageContext.request.contextPath}/courseInfo?id=${course.courseID}" class="hover:text-orange-600">${course.title}</a>
                                  </h3>
                                  <p class="text-gray-600 text-sm mb-4 line-clamp-2">${course.description}</p>
                                  <div class="flex items-center justify-between mb-4">
                                      <span class="text-lg font-bold text-orange-600">
                                          <c:if test="${course.fee == 0}">Miễn phí</c:if>
                                          <c:if test="${course.fee > 0}">
                                              ${String.format("%,.0f", course.fee)} VNĐ
                                          </c:if>
                                      </span>
                                      <span class="text-gray-500 text-sm">
                                          <i class="fa fa-clock mr-1"></i>${course.duration} giờ
                                      </span>
                                  </div>
                                  <div class="flex justify-between items-center">
                                      <a href="${pageContext.request.contextPath}/courseInfo?id=${course.courseID}" class="text-orange-500 hover:underline font-semibold">Xem chi tiết</a>
                                      <button class="bg-orange-500 text-white px-4 py-2 rounded-full text-sm font-semibold hover:bg-orange-600 transition add-to-cart-btn" data-course-id="${course.courseID}" onclick="cart.addToCart('${course.courseID}')">
                                          <i class="fa fa-cart-plus mr-2"></i>Thêm vào giỏ
                                      </button>
                                  </div>
                              </div>
                          </div>
                      </c:forEach>

                      <!-- Pagination Controls -->
                      <c:if test="${totalPages > 1}">
                          <div class="col-span-full flex justify-center mt-6">
                              <div class="flex space-x-2">
                                  <!-- Previous Button -->
                                  <c:if test="${currentPage > 1}">
                                      <a href="${pageContext.request.contextPath}/courses?action=list&category=${param.category != null ? param.category : 'paid'}&search=${param.search != null ? param.search : ''}&page=${currentPage - 1}" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-full hover:bg-gray-200">
                                          <i class="fa fa-chevron-left"></i>
                                      </a>
                                  </c:if>
                                  <!-- Page Numbers -->
                                  <c:forEach var="i" begin="1" end="${totalPages}">
                                      <a href="${pageContext.request.contextPath}/courses?action=list&category=${param.category != null ? param.category : 'paid'}&search=${param.search != null ? param.search : ''}&page=${i}" class="px-4 py-2 rounded-full ${currentPage == i ? 'bg-orange-500 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">${i}</a>
                                  </c:forEach>
                                  <!-- Next Button -->
                                  <c:if test="${currentPage < totalPages}">
                                      <a href="${pageContext.request.contextPath}/courses?action=list&category=${param.category != null ? param.category : 'paid'}&search=${param.search != null ? param.search : ''}&page=${currentPage + 1}" class="px-4 py-2 bg-gray-100 text-gray-700 rounded-full hover:bg-gray-200">
                                          <i class="fa fa-chevron-right"></i>
                                      </a>
                                  </c:if>
                              </div>
                          </div>
                      </c:if>
                  </c:otherwise>
              </c:choose>
          </div>
      </div>
      <!-- Footer -->
      <%@ include file="footer.jsp" %>
  </main>
</div>
<script src="${pageContext.request.contextPath}/assets/js/student_js/shopping.js?v=3"></script>
</body>
</html>
