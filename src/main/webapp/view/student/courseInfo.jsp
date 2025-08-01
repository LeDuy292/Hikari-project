<%@page import="model.UserAccount"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Course, model.student.CourseInfo, model.Review, java.util.List" %>
<%@ page errorPage="error.jsp" %>
<%
try {
    Course course = (Course) request.getAttribute("course");
    CourseInfo courseInfo = (CourseInfo) request.getAttribute("courseInfo");
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    Double averageRating = (Double) request.getAttribute("averageRating");
    Boolean canReview = (Boolean) request.getAttribute("canReview");
    Boolean isEnrolled = (Boolean) request.getAttribute("isEnrolled");
    String error = request.getParameter("error");
    String requestedId = request.getParameter("id");

    // Safe null checks
    if (reviews == null) {
        reviews = new java.util.ArrayList<>();
    }
    if (averageRating == null) {
        averageRating = 0.0;
    }
    if (canReview == null) {
        canReview = false;
    }
    if (isEnrolled == null) {
        isEnrolled = false;
    }

    // Debug logging với null checks
    System.out.println("JSP Debug - Course: " + (course != null ? course.getCourseID() : "null"));
    System.out.println("JSP Debug - CourseInfo: " + (courseInfo != null ? "exists" : "null"));
    System.out.println("JSP Debug - Error: " + error);
    System.out.println("JSP Debug - Requested ID: " + requestedId);
    System.out.println("JSP Debug - Reviews count: " + (reviews != null ? reviews.size() : "null"));
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
<body class="bg-gradient-to-br from-gray-50 via-blue-50 to-indigo-50 font-sans">

<!-- Loading overlay -->
<div id="loadingOverlay" class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center hidden">
    <div class="bg-white rounded-lg p-6 flex items-center">
        <i class="fas fa-spinner fa-spin text-2xl text-blue-500 mr-3"></i>
        <span class="text-lg">Đang tải...</span>
    </div>
</div>

<div class="flex-container">
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main content -->
    <main class="flex-1 px-8 py-6 flex flex-col course-info-container" style="margin-left: 320px !important;">
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Enhanced Hero Banner -->
        <div class="hero-banner bg-gradient-to-br from-orange-500 via-orange-400 to-pink-400 rounded-3xl overflow-hidden shadow-2xl mb-8 mt-8 w-full-custom">
            <div class="absolute inset-0 bg-black bg-opacity-10"></div>
            <div class="relative z-10 p-8">
                <div class="flex flex-col lg:flex-row items-center justify-between">
                    <div class="text-white mb-6 lg:mb-0 lg:w-3/5">
                        <div class="flex items-center mb-4">
                            <div class="bg-white bg-opacity-20 rounded-full p-4 mr-6 float-animate">
                                <i class="fas fa-graduation-cap text-3xl text-white"></i>
                            </div>
                            <div>
                                <h1 class="text-4xl lg:text-5xl font-bold mb-3 leading-tight">
                                    <%= (course != null && course.getTitle() != null) ? course.getTitle() : "Thông Tin Khóa Học" %>
                                </h1>
                                <p class="text-white text-opacity-90 text-xl">Khám phá hành trình học tiếng Nhật cùng HIKARI</p>
                                <!-- Rating Display -->
                                <% if (averageRating != null && averageRating > 0) { %>
                                <div class="flex items-center mt-4">
                                    <div class="flex text-yellow-300 mr-3">
                                        <% 
                                        int fullStars = (int) Math.floor(averageRating);
                                        boolean hasHalfStar = (averageRating - fullStars) >= 0.5;
                                        
                                        for (int i = 0; i < fullStars; i++) { %>
                                            <i class="fas fa-star text-lg"></i>
                                        <% } 
                                        
                                        if (hasHalfStar) { %>
                                            <i class="fas fa-star-half-alt text-lg"></i>
                                        <% }
                                        
                                        for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) { %>
                                            <i class="far fa-star text-lg"></i>
                                        <% } %>
                                    </div>
                                    <span class="text-white text-opacity-90 text-lg">
                                        <%= String.format("%.1f", averageRating) %> 
                                        (<%= reviews != null ? reviews.size() : 0 %> đánh giá)
                                    </span>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="flex flex-wrap gap-4 mt-8">
                            <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                <i class="fas fa-clock mr-2"></i>Học linh hoạt
                            </span>
                            <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                <i class="fas fa-certificate mr-2"></i>Cấp chứng chỉ
                            </span>
                            <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                <i class="fas fa-users mr-2"></i>Cộng đồng hỗ trợ
                            </span>
                            <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                <i class="fas fa-mobile-alt mr-2"></i>Học mọi lúc mọi nơi
                            </span>
                        </div>
                    </div>
                    <div class="lg:w-2/5 text-center">
                        <div class="bg-white bg-opacity-15 backdrop-blur-lg rounded-3xl p-8 border border-white border-opacity-20 pulse-animate">
                            <div class="text-white text-4xl font-bold mb-3">
                                <% if (course != null && course.getFee() > 0) { %>
                                    <%= String.format("%,.0f VNĐ", course.getFee()) %>
                                <% } else { %>
                                    Liên hệ
                                <% } %>
                            </div>
                            <p class="text-white text-opacity-80 text-lg mb-6">Học phí khóa học</p>
                            <button class="enhanced-button primary w-full text-lg register-course-btn">
                                <i class="fas fa-shopping-cart mr-3"></i>Đăng ký ngay
                            </button>
                            <div class="progress-indicator mt-4"></div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Enhanced Decorative elements -->
            <div class="absolute top-10 right-10 w-32 h-32 bg-white bg-opacity-10 rounded-full blur-2xl float-animate"></div>
            <div class="absolute bottom-10 left-10 w-24 h-24 bg-white bg-opacity-10 rounded-full blur-xl float-animate" style="animation-delay: -2s;"></div>
            <div class="absolute top-1/2 right-1/4 w-16 h-16 bg-white bg-opacity-5 rounded-full blur-lg float-animate" style="animation-delay: -4s;"></div>
        </div>

        <!-- Enhanced Navigation Tabs -->
        <div class="flex justify-center mb-10 w-full-custom">
            <nav class="nav-tabs flex space-x-2">
                <a href="${pageContext.request.contextPath}/courseInfo?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                   class="nav-tab active">
                    <i class="fas fa-info-circle mr-2"></i>Thông tin khóa học
                </a>
                <a href="${pageContext.request.contextPath}/roadmap?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                   class="nav-tab">
                    <i class="fas fa-route mr-2"></i>Lộ trình khóa học
                </a>
                <a href="${pageContext.request.contextPath}/commitments?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                   class="nav-tab">
                    <i class="fas fa-handshake mr-2"></i>Cam kết khóa học
                </a>
            </nav>
        </div>

        <!-- Enhanced Error Message -->
        <% if (error != null) { %>
            <div class="bg-red-50 border-l-4 border-red-400 text-red-700 p-6 rounded-2xl mb-8 shadow-lg w-full-custom">
                <div class="flex items-start">
                    <i class="fas fa-exclamation-triangle mr-3 text-xl mt-1"></i>
                    <div>
                        <h4 class="font-semibold text-lg mb-2">Có lỗi xảy ra</h4>
                        <p class="mb-2">
                            <% if ("no_data".equals(error)) { %>
                                Không tìm thấy khóa học hoặc thông tin chi tiết cho ID: <%= requestedId %>
                            <% } else if ("invalid_id".equals(error)) { %>
                                ID khóa học không được cung cấp hoặc không hợp lệ.
                            <% } else if ("invalid_format".equals(error)) { %>
                                Định dạng ID khóa học không đúng. ID phải có dạng CO###.
                            <% } else if ("course_not_found".equals(error)) { %>
                                Không tìm thấy khóa học với ID: <%= requestedId %>
                            <% } else { %>
                                Đã xảy ra lỗi không xác định: <%= error %>
                            <% } %>
                        </p>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/courses" 
                               class="inline-block bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                                <i class="fas fa-arrow-left mr-2"></i>Quay lại danh sách khóa học
                            </a>
                            <button onclick="window.location.reload()" 
                                    class="ml-3 inline-block bg-gray-600 hover:bg-gray-700 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                                <i class="fas fa-refresh mr-2"></i>Thử lại
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        <% } %>

        <!-- Enhanced Course Content Grid -->
        <div class="content-grid mb-12 w-full-custom">
            <!-- Main Content -->
            <div class="main-content-section space-y-10">
                <% if (course != null && courseInfo != null) { %>
                    <!-- Enhanced Course Overview -->
                    <div class="enhanced-card">
                        <div class="gradient-header orange">
                            <h3 class="text-3xl font-bold mb-3">
                                <i class="fas fa-book-open mr-4"></i>Tổng quan khóa học
                            </h3>
                            <p class="text-white text-opacity-90 text-lg">Khám phá nội dung và mục tiêu học tập chi tiết</p>
                        </div>
                        <div class="content-section">
                            <div class="prose max-w-none">
                                <p class="text-gray-700 leading-relaxed mb-8 text-xl">
                                    <%= courseInfo.getOverview() != null ? courseInfo.getOverview() : "Chưa có thông tin tổng quan" %>
                                </p>
                                <div class="info-box">
                                    <h4 class="font-bold text-gray-800 mb-6 flex items-center text-xl">
                                        <i class="fas fa-target mr-4 text-orange-500 text-2xl"></i>Mục tiêu khóa học
                                    </h4>
                                    <div class="text-gray-700 space-y-3 text-lg leading-relaxed">
                                        <%= courseInfo.getObjectives() != null ? courseInfo.getObjectives().replace("\n", "<br>") : "Chưa có mục tiêu" %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Enhanced Level Description -->
                    <div class="enhanced-card">
                        <div class="gradient-header blue">
                            <h3 class="text-3xl font-bold mb-3">
                                <i class="fas fa-layer-group mr-4"></i>Mô tả trình độ
                            </h3>
                            <p class="text-white text-opacity-90 text-lg">Hiểu rõ yêu cầu và chuẩn đầu ra của khóa học</p>
                        </div>
                        <div class="content-section">
                            <p class="text-gray-700 leading-relaxed mb-10 text-xl">
                                <%= courseInfo.getLevelDescription() != null ? courseInfo.getLevelDescription() : "Chưa có mô tả trình độ" %>
                            </p>
                            <div class="level-cards-grid">
                                <div class="level-card">
                                    <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" 
                                         alt="Học viên học tập" class="w-full h-40 object-cover" />
                                    <div class="p-6 text-center">
                                        <h5 class="font-bold text-lg text-gray-800 mb-2">Học tập cơ bản</h5>
                                        <p class="text-gray-600">Nắm vững kiến thức nền tảng</p>
                                    </div>
                                </div>
                                <div class="level-card">
                                    <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" 
                                         alt="Học viên thực hành" class="w-full h-40 object-cover" />
                                    <div class="p-6 text-center">
                                        <h5 class="font-bold text-lg text-gray-800 mb-2">Thực hành nâng cao</h5>
                                        <p class="text-gray-600">Áp dụng kiến thức vào thực tế</p>
                                    </div>
                                </div>
                                <div class="level-card">
                                    <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" 
                                         alt="Học viên thi cử" class="w-full h-40 object-cover" />
                                    <div class="p-6 text-center">
                                        <h5 class="font-bold text-lg text-gray-800 mb-2">Đánh giá kết quả</h5>
                                        <p class="text-gray-600">Kiểm tra và chứng nhận</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Enhanced Reviews Section -->
                    <div class="enhanced-card">
                        <div class="gradient-header purple">
                            <h3 class="text-3xl font-bold mb-3">
                                <i class="fas fa-star mr-4"></i>Đánh giá khóa học
                            </h3>
                            <p class="text-white text-opacity-90 text-lg">Chia sẻ trải nghiệm từ các học viên</p>
                        </div>
                        <div class="content-section">
                            <!-- Review Form (if user can review) -->
                            <% if (canReview != null && canReview) { %>
                            <% if (course != null && course.getCourseID() != null && !course.getCourseID().trim().isEmpty()) { %>
<div class="review-form-container mb-8 p-6 bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl border border-blue-200">
    <h4 class="text-xl font-bold text-gray-800 mb-4">
        <i class="fas fa-pen-alt mr-2 text-blue-500"></i>Đánh giá khóa học này
    </h4>
    <form id="reviewForm" class="space-y-4">
        <input type="hidden" name="courseID" value="<%= course.getCourseID() %>">
        <!-- Star Rating -->
        <div class="rating-container">
            <label class="block text-sm font-medium text-gray-700 mb-2">Xếp hạng:</label>
            <div class="star-rating flex space-x-1 mb-4">
                <% for (int i = 1; i <= 5; i++) { %>
                <i class="far fa-star text-2xl text-gray-300 cursor-pointer hover:text-yellow-400 transition-colors" 
                   data-rating="<%= i %>"></i>
                <% } %>
            </div>
            <input type="hidden" name="rating" id="ratingInput" required>
        </div>
        <!-- Comment -->
        <div>
            <label for="comment" class="block text-sm font-medium text-gray-700 mb-2">Nhận xét:</label>
            <textarea name="comment" id="comment" rows="4" 
                      class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
                      placeholder="Chia sẻ trải nghiệm của bạn về khóa học này..."></textarea>
        </div>
        <!-- Submit Button -->
        <button type="submit" 
                class="enhanced-button primary text-lg">
            <i class="fas fa-paper-plane mr-3"></i>Gửi đánh giá
        </button>
    </form>
</div>
<% } else { %>
<div class="review-notice mb-8 p-6 bg-gradient-to-r from-red-50 to-orange-50 rounded-2xl border border-red-200">
    <div class="flex items-center">
        <i class="fas fa-exclamation-circle text-2xl text-red-500 mr-4"></i>
        <div>
            <h4 class="text-lg font-semibold text-gray-800 mb-2">Lỗi thông tin khóa học</h4>
            <p class="text-gray-700">Không thể hiển thị form đánh giá do thông tin khóa học không hợp lệ.</p>
        </div>
    </div>
</div>
<% } %>
                            <% } else if (isEnrolled != null && isEnrolled) { %>
                            <div class="review-notice mb-8 p-6 bg-gradient-to-r from-yellow-50 to-orange-50 rounded-2xl border border-yellow-200">
                                <div class="flex items-center">
                                    <i class="fas fa-info-circle text-2xl text-yellow-500 mr-4"></i>
                                    <div>
                                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Điều kiện đánh giá</h4>
                                        <p class="text-gray-700">Bạn cần hoàn thành ít nhất 2 bài học để có thể đánh giá khóa học này.</p>
                                        <div class="mt-3 flex items-center">
                                            <div class="bg-white rounded-lg px-4 py-2 mr-3">
                                                <span class="text-sm text-gray-600">Tiến độ của bạn:</span>
                                                <span id="progressInfo" class="font-semibold text-orange-600 ml-2">Đang tải...</span>
                                            </div>
                                            <button onclick="checkReviewEligibility()" 
                                                    class="text-blue-500 hover:text-blue-700 underline text-sm">
                                                Kiểm tra lại
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } else if (session.getAttribute("user") != null) { %>
                            <div class="review-notice mb-8 p-6 bg-gradient-to-r from-gray-50 to-blue-50 rounded-2xl border border-gray-200">
                                <div class="flex items-center">
                                    <i class="fas fa-graduation-cap text-2xl text-gray-500 mr-4"></i>
                                    <div>
                                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Bạn chưa đăng ký khóa học này</h4>
                                        <p class="text-gray-700">Hãy đăng ký khóa học để có thể đánh giá và chia sẻ trải nghiệm của bạn.</p>
                                    </div>
                                </div>
                            </div>
                            <% } else { %>
                            <div class="review-notice mb-8 p-6 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-2xl border border-blue-200">
                                <div class="flex items-center">
                                    <i class="fas fa-sign-in-alt text-2xl text-blue-500 mr-4"></i>
                                    <div>
                                        <h4 class="text-lg font-semibold text-gray-800 mb-2">Đăng nhập để đánh giá</h4>
                                        <p class="text-gray-700">Bạn cần đăng nhập và đăng ký khóa học để có thể đánh giá.</p>
                                        <div class="mt-3">
                                            <a href="${pageContext.request.contextPath}/view/login.jsp" 
                                               class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
                                                Đăng nhập ngay
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } %>

                            <!-- Reviews List with better error handling -->
                            <div class="reviews-list space-y-6">
                                <% try { %>
                                    <% if (reviews != null && !reviews.isEmpty()) { %>
                                        <% 
                                        UserAccount currentUser = (UserAccount) session.getAttribute("user");
                                        String currentUserID = currentUser != null ? currentUser.getUserID() : null;
                                        %>
                                        <% for (Review review : reviews) { %>
                                            <% if (review != null) { %>
                                            <div class="review-item p-6 bg-white rounded-2xl shadow-md border border-gray-100 hover:shadow-lg transition-shadow" data-user-id="<%= review.getUserID() != null ? review.getUserID() : "" %>">
                                                <div class="flex items-start space-x-4">
                                                    <div class="w-12 h-12 bg-gradient-to-br from-blue-400 to-purple-500 rounded-full flex items-center justify-center text-white font-bold text-lg">
                                                        <% if (review.getProfilePicture() != null && !review.getProfilePicture().isEmpty()) { %>
                                                            <img src="${pageContext.request.contextPath}/<%= review.getProfilePicture() %>" 
                                                                 alt="Avatar" class="w-full h-full rounded-full object-cover">
                                                        <% } else { %>
                                                            <% 
                                                            String displayName = "";
                                                            if (review.getFullName() != null && !review.getFullName().isEmpty()) {
                                                                displayName = review.getFullName().substring(0, 1).toUpperCase();
                                                            } else if (review.getUsername() != null && !review.getUsername().isEmpty()) {
                                                                displayName = review.getUsername().substring(0, 1).toUpperCase();
                                                            } else {
                                                                displayName = "?";
                                                            }
                                                            %>
                                                            <%= displayName %>
                                                        <% } %>
                                                    </div>
                                                    <div class="flex-1">
                                                        <div class="flex items-center justify-between mb-2">
                                                            <div class="flex items-center space-x-3">
                                                                <h5 class="font-semibold text-gray-800">
                                                                    <% 
                                                                    String reviewerName = "";
                                                                    if (review.getFullName() != null && !review.getFullName().isEmpty()) {
                                                                        reviewerName = review.getFullName();
                                                                    } else if (review.getUsername() != null && !review.getUsername().isEmpty()) {
                                                                        reviewerName = review.getUsername();
                                                                    } else {
                                                                        reviewerName = "Người dùng ẩn danh";
                                                                    }
                                                                    %>
                                                                    <%= reviewerName %>
                                                                </h5>
                                                                <% if (currentUserID != null && currentUserID.equals(review.getUserID())) { %>
                                                                <span class="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full font-medium">
                                                                    Bạn
                                                                </span>
                                                                <% } %>
                                                            </div>
                                                            <div class="flex items-center space-x-2">
                                                                <div class="flex text-yellow-400">
                                                                    <% 
                                                                    int rating = review.getRating() > 0 ? review.getRating() : 1;
                                                                    for (int i = 1; i <= 5; i++) { %>
                                                                        <i class="<%= i <= rating ? "fas" : "far" %> fa-star text-sm"></i>
                                                                    <% } %>
                                                                </div>
                                                                <span class="text-sm text-gray-500">
                                                                    <%= review.getReviewDate() != null ? 
                                                                        new java.text.SimpleDateFormat("dd/MM/yyyy").format(review.getReviewDate()) : 
                                                                        "Không xác định" %>
                                                                </span>
                                                                <% if (currentUserID != null && currentUserID.equals(review.getUserID())) { %>
                                                                <div class="flex space-x-1 ml-2">
                                                                    <button onclick="editReview('<%= review.getUserID() %>', '<%= review.getCourseID() %>', <%= review.getRating() %>, `<%= review.getReviewText() != null ? review.getReviewText().replace("`", "\\`").replace("\\", "\\\\").replace("'", "\\'").replace("\r\n", "\\n").replace("\n", "\\n") : "" %>`)" 
                                                                            class="text-blue-500 hover:text-blue-700 p-2 rounded-full hover:bg-blue-50 transition-all duration-200" 
                                                                            title="Chỉnh sửa đánh giá">
                                                                        <i class="fas fa-edit text-sm"></i>
                                                                    </button>
                                                                    <button onclick="confirmDeleteReview('<%= review.getUserID() %>', '<%= review.getCourseID() %>')" 
                                                                            class="text-red-500 hover:text-red-700 p-2 rounded-full hover:bg-red-50 transition-all duration-200" 
                                                                            title="Xóa đánh giá">
                                                                        <i class="fas fa-trash text-sm"></i>
                                                                    </button>
                                                                </div>
                                                                <% } %>
                                                            </div>
                                                        </div>
                                                        <div class="review-content">
                                                            <p class="text-gray-700 leading-relaxed">
                                                                <%= review.getReviewText() != null ? review.getReviewText() : "Không có nhận xét" %>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>
                                        <% } %>
                                    <% } else { %>
                                    <div class="text-center py-12 text-gray-500">
                                        <i class="fas fa-comments text-4xl mb-4"></i>
                                        <p class="text-lg">Chưa có đánh giá nào cho khóa học này</p>
                                    </div>
                                    <% } %>
                                <% } catch (Exception e) { %>
                                    <div class="text-center py-12 text-red-500">
                                        <i class="fas fa-exclamation-triangle text-4xl mb-4"></i>
                                        <p class="text-lg">Có lỗi khi tải đánh giá. Vui lòng thử lại sau.</p>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- Enhanced Sidebar -->
            <div class="sidebar-section space-y-8">
                <!-- Enhanced Course Stats -->
                <div class="enhanced-card">
                    <div class="gradient-header green">
                        <h4 class="font-bold text-xl mb-2">
                            <i class="fas fa-chart-bar mr-3"></i>Thống kê khóa học
                        </h4>
                    </div>
                    <div class="content-section">
                        <div class="stats-grid">
                            <div class="stats-card">
                                <div class="stat-icon">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="text-sm text-gray-600 mb-1">Thời lượng</div>
                                <div class="font-bold text-lg text-gray-800">
                                    <%= (courseInfo != null && courseInfo.getDuration() != null) ? courseInfo.getDuration() : "Chưa xác định" %>
                                </div>
                            </div>
                            <div class="stats-card">
                                <div class="stat-icon">
                                    <i class="fas fa-layer-group"></i>
                                </div>
                                <div class="text-sm text-gray-600 mb-1">Trình độ</div>
                                <div class="font-bold text-lg text-gray-800">Cơ bản - Nâng cao</div>
                            </div>
                            <div class="stats-card">
                                <div class="stat-icon">
                                    <i class="fas fa-certificate"></i>
                                </div>
                                <div class="text-sm text-gray-600 mb-1">Chứng chỉ</div>
                                <div class="font-bold text-lg text-green-600">
                                    <i class="fas fa-check-circle mr-2"></i>Có
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Enhanced Tuition Info -->
                <% if (courseInfo != null) { %>
                    <div class="enhanced-card">
                        <div class="gradient-header purple">
                            <h4 class="font-bold text-xl mb-2">
                                <i class="fas fa-money-bill-wave mr-3"></i>Thông tin học phí
                            </h4>
                        </div>
                        <div class="content-section">
                            <p class="text-gray-700 mb-8 leading-relaxed text-lg">
                                <%= courseInfo.getTuitionInfo() != null ? courseInfo.getTuitionInfo() : "Chưa có thông tin học phí" %>
                            </p>
                            <div class="space-y-4">
                                <button class="enhanced-button primary w-full text-lg register-course-btn">
                                    <i class="fas fa-shopping-cart mr-3"></i>Đăng ký ngay
                                </button>
                                <a href="${pageContext.request.contextPath}/courses" 
                                   class="enhanced-button secondary w-full block text-center text-lg">
                                    <i class="fas fa-list mr-3"></i>Xem khóa học khác
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Enhanced No Data States -->
        <% if (course == null) { %>
            <div class="flex-1 flex items-center justify-center w-full-custom">
                <div class="text-center enhanced-card p-16">
                    <div class="bg-gradient-to-br from-gray-100 to-gray-200 rounded-full w-32 h-32 flex items-center justify-center mx-auto mb-8 float-animate">
                        <i class="fas fa-exclamation-triangle text-5xl text-gray-400"></i>
                    </div>
                    <h3 class="text-3xl font-bold text-gray-800 mb-4">Không tìm thấy khóa học</h3>
                    <p class="text-gray-600 mb-8 text-xl leading-relaxed">Khóa học bạn đang tìm kiếm không tồn tại hoặc đã được gỡ bỏ.</p>
                    <a href="${pageContext.request.contextPath}/courses" 
                       class="enhanced-button primary text-xl">
                        Về trang khóa học
                    </a>
                </div>
            </div>
        <% } else if (courseInfo == null) { %>
            <div class="flex-1 flex items-center justify-center w-full-custom">
                <div class="text-center enhanced-card p-16">
                    <div class="bg-gradient-to-br from-blue-100 to-blue-200 rounded-full w-32 h-32 flex items-center justify-center mx-auto mb-8 pulse-animate">
                        <i class="fas fa-info-circle text-5xl text-blue-400"></i>
                    </div>
                    <h3 class="text-3xl font-bold text-gray-800 mb-4">Thông tin chưa đầy đủ</h3>
                    <p class="text-gray-600 mb-8 text-xl leading-relaxed">Thông tin chi tiết cho khóa học này đang được cập nhật.</p>
                    <a href="${pageContext.request.contextPath}/courses" 
                       class="enhanced-button primary text-xl">
                        Xem khóa học khác
                    </a>
                </div>
            </div>
        <% } %>

        <!-- Footer -->
        <jsp:include page="footer.jsp" />
    </main>
</div>

<!-- Edit Review Modal -->
<div id="editReviewModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl p-6 w-full max-w-md mx-auto shadow-2xl transform transition-all duration-300 scale-95 opacity-0" id="editModalContent">
        <div class="flex items-center justify-between mb-6">
            <h3 class="text-xl font-bold text-gray-800 flex items-center">
                <i class="fas fa-edit mr-3 text-blue-500"></i>Chỉnh sửa đánh giá
            </h3>
            <button onclick="closeEditModal()" class="text-gray-400 hover:text-gray-600 text-xl p-1 rounded-full hover:bg-gray-100 transition-colors">
                <i class="fas fa-times"></i>
            </button>
        </div>
        
        <form id="editReviewForm" class="space-y-6">
            <input type="hidden" id="editUserID" name="userID">
            <input type="hidden" id="editCourseID" name="courseID">
            
            <!-- Enhanced Star Rating -->
            <div class="rating-container">
                <label class="block text-sm font-medium text-gray-700 mb-3">Đánh giá của bạn:</label>
                <div class="edit-star-rating flex space-x-2 mb-4 justify-center">
                    <% for (int i = 1; i <= 5; i++) { %>
                    <i class="far fa-star text-3xl text-gray-300 cursor-pointer hover:text-yellow-400 transition-all duration-200 transform hover:scale-110" 
                       data-rating="<%= i %>" title="<%= i %> sao"></i>
                    <% } %>
                </div>
                <input type="hidden" name="rating" id="editRatingInput" required>
                <div id="editRatingError" class="text-red-500 text-sm hidden">Vui lòng chọn số sao</div>
            </div>
            
            <!-- Enhanced Comment -->
            <div>
                <label for="editComment" class="block text-sm font-medium text-gray-700 mb-2">Nhận xét của bạn:</label>
                <textarea name="comment" id="editComment" rows="4" 
                          class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none transition-all duration-200"
                          placeholder="Chia sẻ trải nghiệm của bạn về khóa học này..."
                          maxlength="1000"></textarea>
                <div class="text-right text-sm text-gray-500 mt-1">
                    <span id="editCommentCount">0</span>/1000 ký tự
                </div>
            </div>
            
            <!-- Enhanced Buttons -->
            <div class="flex space-x-3 pt-4">
                <button type="submit" class="flex-1 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white px-6 py-3 rounded-xl font-medium transition-all duration-200 transform hover:scale-105 flex items-center justify-center">
                    <i class="fas fa-save mr-2"></i>
                    <span class="button-text">Cập nhật đánh giá</span>
                </button>
                <button type="button" onclick="closeEditModal()" class="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-700 px-6 py-3 rounded-xl font-medium transition-all duration-200 flex items-center justify-center">
                    <i class="fas fa-times mr-2"></i>Hủy
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteConfirmModal" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl p-6 w-full max-w-sm mx-auto shadow-2xl transform transition-all duration-300 scale-95 opacity-0" id="deleteModalContent">
        <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100 mb-4">
                <i class="fas fa-exclamation-triangle text-red-600 text-xl"></i>
            </div>
            <h3 class="text-lg font-medium text-gray-900 mb-2">Xác nhận xóa đánh giá</h3>
            <p class="text-sm text-gray-500 mb-6">Bạn có chắc chắn muốn xóa đánh giá này? Hành động này không thể hoàn tác.</p>
            <div class="flex space-x-3">
                <button onclick="proceedDeleteReview()" class="flex-1 bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg font-medium transition-colors">
                    <i class="fas fa-trash mr-2"></i>Xóa
                </button>
                <button onclick="closeDeleteModal()" class="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-700 px-4 py-2 rounded-lg font-medium transition-colors">
                    Hủy
                </button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/student_js/courseInfo.js"></script>
<script>
// Enhanced error handling and page load protection
document.addEventListener('DOMContentLoaded', function() {
    console.log('CourseInfo page loading...');
    
    // Hide loading overlay after page load
    window.addEventListener('load', function() {
        const loadingOverlay = document.getElementById('loadingOverlay');
        if (loadingOverlay) {
            loadingOverlay.classList.add('hidden');
        }
        console.log('CourseInfo page fully loaded');
    });
    
    // Show loading on navigation
    const navLinks = document.querySelectorAll('a[href*="courseInfo"], a[href*="roadmap"], a[href*="commitments"]');
    navLinks.forEach(link => {
        link.addEventListener('click', function() {
            const loadingOverlay = document.getElementById('loadingOverlay');
            if (loadingOverlay) {
                loadingOverlay.classList.remove('hidden');
            }
        });
    });
    
    // Enhanced error boundary
    window.addEventListener('error', function(e) {
        console.error('Page error:', e.error);
        const loadingOverlay = document.getElementById('loadingOverlay');
        if (loadingOverlay && !loadingOverlay.classList.contains('hidden')) {
            loadingOverlay.classList.add('hidden');
        }
    });
    
    // Timeout protection for long-running operations
    setTimeout(function() {
        const loadingOverlay = document.getElementById('loadingOverlay');
        if (loadingOverlay && !loadingOverlay.classList.contains('hidden')) {
            loadingOverlay.classList.add('hidden');
            console.warn('Page load timeout - forcing overlay hide');
        }
    }, 10000); // 10 second timeout
    
    // Star rating functionality
    const stars = document.querySelectorAll('.star-rating i');
    const ratingInput = document.getElementById('ratingInput');
    
    stars.forEach((star, index) => {
        star.addEventListener('click', function() {
            const rating = index + 1;
            ratingInput.value = rating;
            
            // Update star display
            stars.forEach((s, i) => {
                if (i < rating) {
                    s.classList.remove('far');
                    s.classList.add('fas');
                    s.classList.add('text-yellow-400');
                    s.classList.remove('text-gray-300');
                } else {
                    s.classList.add('far');
                    s.classList.remove('fas');
                    s.classList.remove('text-yellow-400');
                    s.classList.add('text-gray-300');
                }
            });
        });
        
        star.addEventListener('mouseover', function() {
            const rating = index + 1;
            stars.forEach((s, i) => {
                if (i < rating) {
                    s.classList.add('text-yellow-400');
                    s.classList.remove('text-gray-300');
                } else {
                    s.classList.remove('text-yellow-400');
                    s.classList.add('text-gray-300');
                }
            });
        });
    });
    
    // Review form submission
    const reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(reviewForm);
            formData.append('action', 'submitReview');
            
            if (!formData.get('rating')) {
                window.courseRegistration.showMessage('Vui lòng chọn số sao đánh giá', 'warning');
                return;
            }
            
            const submitBtn = reviewForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-3"></i>Đang gửi...';
            submitBtn.disabled = true;
            
            fetch('${pageContext.request.contextPath}/review', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    window.courseRegistration.showMessage(data.message, 'success');
                    setTimeout(() => {
                        location.reload();
                    }, 2000);
                } else {
                    window.courseRegistration.showMessage(data.message, 'error');
                    submitBtn.innerHTML = originalText;
                    submitBtn.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                window.courseRegistration.showMessage('Có lỗi xảy ra khi gửi đánh giá', 'error');
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = false;
            });
        });
    }
});

// Course registration functionality
window.courseRegistration = {
    // Check if user is logged in
    checkUserLogin: function() {
        return <c:out value="${sessionScope.user != null}" default="false"/>;
    },
    
    // Get current user ID
    getCurrentUserId: function() {
        return '${sessionScope.user != null ? sessionScope.user.userID : ""}';
    },
    
    // Add course to cart
    addToCart: function(courseId) {
        if (!this.checkUserLogin()) {
            this.showLoginRequired();
            return;
        }
        
        const buttons = document.querySelectorAll('.register-course-btn');
        buttons.forEach(btn => {
            btn.innerHTML = '<i class="fas fa-spinner fa-spin mr-3"></i>Đang thêm vào giỏ...';
            btn.disabled = true;
        });
        
        fetch('${pageContext.request.contextPath}/cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=addToCart&courseID=' + courseId // Sửa từ template literal thành concatenation
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.showMessage(data.message, 'success');
                // Update button state
                buttons.forEach(btn => {
                    btn.innerHTML = '<i class="fas fa-check mr-3"></i>Đã thêm vào giỏ';
                    btn.classList.remove('bg-orange-500', 'hover:bg-orange-600');
                    btn.classList.add('bg-green-500');
                });
                
                // Show option to go to cart
                setTimeout(() => {
                    const goToCartBtn = '<button onclick="window.location.href=\'' + 
                        '${pageContext.request.contextPath}/view/student/shopping_cart.jsp\'" ' +
                        'class="enhanced-button secondary w-full text-lg mt-3">' +
                        '<i class="fas fa-shopping-cart mr-3"></i>Xem giỏ hàng</button>';
                    buttons.forEach(btn => {
                        if (btn.parentNode) {
                            btn.parentNode.insertAdjacentHTML('afterend', goToCartBtn);
                        }
                    });
                }, 1000);
                
            } else {
                this.showMessage(data.message, 'error');
                this.resetButtons();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            this.showMessage('Có lỗi xảy ra khi thêm khóa học vào giỏ hàng', 'error');
            this.resetButtons();
        });
    },
    
    // Reset button states
    resetButtons: function() {
        const buttons = document.querySelectorAll('.register-course-btn');
        buttons.forEach(btn => {
            btn.innerHTML = '<i class="fas fa-shopping-cart mr-3"></i>Đăng ký ngay';
            btn.disabled = false;
            btn.classList.remove('bg-green-500');
            btn.classList.add('bg-orange-500', 'hover:bg-orange-600');
        });
    },
    
    // Show login required message
    showLoginRequired: function() {
        this.showMessage('Bạn cần đăng nhập để đăng ký khóa học!', 'warning');
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/loginPage';
        }, 2000);
    },
    
    // Show notification message
    showMessage: function(message, type, duration) {
        duration = duration || 5000; // Set default duration if not provided
        
        // Remove existing messages
        const existingMessages = document.querySelectorAll('.notification-message');
        existingMessages.forEach(msg => msg.remove());
        
        const colors = {
            success: 'bg-green-500',
            error: 'bg-red-500',
            warning: 'bg-yellow-500',
            info: 'bg-blue-500'
        };
        
        const icons = {
            success: 'fas fa-check-circle',
            error: 'fas fa-exclamation-circle',
            warning: 'fas fa-exclamation-triangle',
            info: 'fas fa-info-circle'
        };
        
        const messageDiv = document.createElement('div');
        messageDiv.className = 'notification-message fixed top-4 right-4 ' + colors[type] + ' text-white px-6 py-4 rounded-lg shadow-lg z-50 transform translate-x-full transition-transform duration-300';
        messageDiv.innerHTML = '<div class="flex items-center">' +
            '<i class="' + icons[type] + ' mr-3"></i>' +
            '<span>' + message + '</span>' +
            '<button onclick="this.parentElement.parentElement.remove()" class="ml-4 text-white hover:text-gray-200">' +
            '<i class="fas fa-times"></i>' +
            '</button>' +
            '</div>';
        
        document.body.appendChild(messageDiv);
        
        // Slide in
        setTimeout(() => {
            messageDiv.classList.remove('translate-x-full');
            messageDiv.classList.add('translate-x-0');
        }, 100);
        
        // Auto remove after duration
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.classList.add('translate-x-full');
                setTimeout(() => {
                    if (messageDiv.parentNode) {
                        messageDiv.remove();
                    }
                }, 300);
            }
        }, duration);
    }
};

// Initialize course registration when page loads
document.addEventListener('DOMContentLoaded', function() {
    const courseId = '<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "" %>';
    
    // Add click handlers to registration buttons
    const registerButtons = document.querySelectorAll('.register-course-btn');
    registerButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            if (courseId) {
                window.courseRegistration.addToCart(courseId);
            } else {
                window.courseRegistration.showMessage('Không tìm thấy thông tin khóa học', 'error');
            }
        });
    });
});

// Function to check review eligibility and show progress
function checkReviewEligibility() {
    const courseId = '<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "" %>';
    if (!courseId) return;
    
    const progressInfo = document.getElementById('progressInfo');
    if (progressInfo) {
        progressInfo.innerHTML = 'Đang kiểm tra...';
        progressInfo.className = 'font-semibold text-blue-600 ml-2';
    }
    
    fetch('${pageContext.request.contextPath}/review', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=checkEligibility&courseID=' + courseId // Sửa từ template literal
    })
    .then(response => response.json())
    .then(data => {
        console.log('Review eligibility response:', data); // Debug log
        
        const progressInfo = document.getElementById('progressInfo');
        if (progressInfo) {
            if (data.completedLessons !== undefined) {
                if (data.completedLessons === -1) {
                    progressInfo.innerHTML = 'Đã đánh giá rồi';
                    progressInfo.className = 'font-semibold text-blue-600 ml-2';
                } else {
                    progressInfo.innerHTML = data.completedLessons + '/2 bài học đã hoàn thành';
                    progressInfo.className = data.completedLessons >= 2 ? 
                        'font-semibold text-green-600 ml-2' : 
                        'font-semibold text-orange-600 ml-2';
                        
                    if (data.completedLessons >= 2 && data.canReview) {
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    }
                }
            } else {
                progressInfo.innerHTML = 'Không thể tải thông tin tiến độ';
                progressInfo.className = 'font-semibold text-red-600 ml-2';
            }
        }
        
        // Show debug info in console
        if (data.progressDetails) {
            console.log('Progress details:', data.progressDetails);
        }
        
        if (data.message) {
            window.courseRegistration.showMessage(data.message, data.success ? 'info' : 'warning');
        }
    })
    .catch(error => {
        console.error('Error checking eligibility:', error);
        const progressInfo = document.getElementById('progressInfo');
        if (progressInfo) {
            progressInfo.innerHTML = 'Lỗi khi tải thông tin';
            progressInfo.className = 'font-semibold text-red-600 ml-2';
        }
    });
}

// Auto check progress on page load for enrolled users
document.addEventListener('DOMContentLoaded', function() {
    // ...existing code...
    
    // Auto check progress if user is enrolled but can't review
    const isEnrolled = <%= isEnrolled != null ? isEnrolled : false %>;
    const canReview = <%= canReview != null ? canReview : false %>;
    
    if (isEnrolled && !canReview) {
        setTimeout(checkReviewEligibility, 1000);
    }
});

// Enhanced edit review functionality
let currentDeleteInfo = null;

function editReview(userID, courseID, currentRating, currentComment) {
    console.log('Edit review called with:', { userID, courseID, currentRating, currentComment });
    
    const modal = document.getElementById('editReviewModal');
    const modalContent = document.getElementById('editModalContent');
    const form = document.getElementById('editReviewForm');
    
    if (!modal || !form) {
        console.error('Modal or form not found');
        window.courseRegistration.showMessage('Lỗi hiển thị form chỉnh sửa', 'error');
        return;
    }
    
    // Reset form
    form.reset();
    
    // Populate form
    document.getElementById('editUserID').value = userID;
    document.getElementById('editCourseID').value = courseID;
    document.getElementById('editComment').value = currentComment || '';
    document.getElementById('editRatingInput').value = currentRating;
    
    // Update character count
    updateEditCommentCount();
    
    // Set stars
    const editStars = document.querySelectorAll('.edit-star-rating i');
    editStars.forEach((star, index) => {
        if (index < currentRating) {
            star.classList.remove('far');
            star.classList.add('fas');
            star.classList.add('text-yellow-400');
            star.classList.remove('text-gray-300');
        } else {
            star.classList.add('far');
            star.classList.remove('fas');
            star.classList.remove('text-yellow-400');
            star.classList.add('text-gray-300');
        }
    });
    
    // Show modal with animation
    modal.classList.remove('hidden');
    setTimeout(() => {
        modalContent.classList.remove('scale-95', 'opacity-0');
        modalContent.classList.add('scale-100', 'opacity-100');
    }, 10);
    
    console.log('Modal shown successfully');
}

function closeEditModal() {
    const modal = document.getElementById('editReviewModal');
    const modalContent = document.getElementById('editModalContent');
    
    if (modal && modalContent) {
        modalContent.classList.add('scale-95', 'opacity-0');
        modalContent.classList.remove('scale-100', 'opacity-100');
        
        setTimeout(() => {
            modal.classList.add('hidden');
        }, 300);
        
        console.log('Modal closed');
    }
}

function confirmDeleteReview(userID, courseID) {
    console.log('Confirm delete review called with:', { userID, courseID });
    
    currentDeleteInfo = { userID, courseID };
    const modal = document.getElementById('deleteConfirmModal');
    const modalContent = document.getElementById('deleteModalContent');
    
    if (modal && modalContent) {
        modal.classList.remove('hidden');
        setTimeout(() => {
            modalContent.classList.remove('scale-95', 'opacity-0');
            modalContent.classList.add('scale-100', 'opacity-100');
        }, 10);
    }
}

function closeDeleteModal() {
    const modal = document.getElementById('deleteConfirmModal');
    const modalContent = document.getElementById('deleteModalContent');
    
    if (modal && modalContent) {
        modalContent.classList.add('scale-95', 'opacity-0');
        modalContent.classList.remove('scale-100', 'opacity-100');
        
        setTimeout(() => {
            modal.classList.add('hidden');
            currentDeleteInfo = null;
        }, 300);
    }
}

function proceedDeleteReview() {
    if (!currentDeleteInfo) {
        window.courseRegistration.showMessage('Thông tin xóa không hợp lệ', 'error');
        return;
    }
    
    closeDeleteModal();
    deleteReview(currentDeleteInfo.userID, currentDeleteInfo.courseID);
}

function deleteReview(userID, courseID) {
    console.log('Delete review called with:', { userID, courseID });
    
    // Show loading message
    window.courseRegistration.showMessage('Đang xóa đánh giá...', 'info', 2000);
    
    console.log('Sending delete request...');
    
    fetch('${pageContext.request.contextPath}/review', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=deleteReview&courseID=' + courseID // Sửa từ encodeURIComponent thành concatenation thông thường
    })
    .then(response => {
        console.log('Delete response status:', response.status);
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        console.log('Delete response data:', data);
        if (data.success) {
            window.courseRegistration.showMessage(data.message, 'success');
            setTimeout(() => {
                location.reload();
            }, 1500);
        } else {
            window.courseRegistration.showMessage(data.message || 'Có lỗi xảy ra khi xóa đánh giá', 'error');
        }
    })
    .catch(error => {
        console.error('Delete error:', error);
        window.courseRegistration.showMessage('Có lỗi xảy ra khi xóa đánh giá. Vui lòng thử lại.', 'error');
    });
}

function updateEditCommentCount() {
    const comment = document.getElementById('editComment');
    const counter = document.getElementById('editCommentCount');
    if (comment && counter) {
        counter.textContent = comment.value.length;
    }
}

// Enhanced document ready function
document.addEventListener('DOMContentLoaded', function() {
    // ...existing code...
    
    // Edit review star rating with enhanced interaction
    const editStars = document.querySelectorAll('.edit-star-rating i');
    const editRatingInput = document.getElementById('editRatingInput');
    const editRatingError = document.getElementById('editRatingError');
    
    editStars.forEach((star, index) => {
        star.addEventListener('click', function() {
            const rating = index + 1;
            editRatingInput.value = rating;
            
            // Hide error message
            if (editRatingError) {
                editRatingError.classList.add('hidden');
            }
            
            // Update star display
            editStars.forEach((s, i) => {
                if (i < rating) {
                    s.classList.remove('far');
                    s.classList.add('fas');
                    s.classList.add('text-yellow-400');
                    s.classList.remove('text-gray-300');
                } else {
                    s.classList.add('far');
                    s.classList.remove('fas');
                    s.classList.remove('text-yellow-400');
                    s.classList.add('text-gray-300');
                }
            });
        });
        
        star.addEventListener('mouseover', function() {
            const rating = index + 1;
            editStars.forEach((s, i) => {
                if (i < rating) {
                    s.classList.add('text-yellow-400');
                    s.classList.remove('text-gray-300');
                } else {
                    s.classList.remove('text-yellow-400');
                    s.classList.add('text-gray-300');
                }
            });
        });
        
        star.addEventListener('mouseleave', function() {
            const currentRating = parseInt(editRatingInput.value) || 0;
            editStars.forEach((s, i) => {
                if (i < currentRating) {
                    s.classList.add('text-yellow-400');
                    s.classList.remove('text-gray-300');
                } else {
                    s.classList.remove('text-yellow-400');
                    s.classList.add('text-gray-300');
                }
            });
        });
    });
    
    // Comment character counter
    const editComment = document.getElementById('editComment');
    if (editComment) {
        editComment.addEventListener('input', updateEditCommentCount);
    }
    
    // Enhanced edit review form submission
    const editReviewForm = document.getElementById('editReviewForm');
    if (editReviewForm) {
        editReviewForm.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('Edit form submitted');
            
            const formData = new FormData(editReviewForm);
            formData.append('action', 'updateReview');
            
            // Validate rating
            if (!formData.get('rating')) {
                console.log('Missing rating');
                if (editRatingError) {
                    editRatingError.classList.remove('hidden');
                }
                window.courseRegistration.showMessage('Vui lòng chọn số sao đánh giá', 'warning');
                return;
            }
            
            const submitBtn = editReviewForm.querySelector('button[type="submit"]');
            const buttonText = submitBtn.querySelector('.button-text');
            const originalText = buttonText.innerHTML;
            
            // Show loading state
            submitBtn.disabled = true;
            submitBtn.classList.add('opacity-75', 'cursor-not-allowed');
            buttonText.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Đang cập nhật...';
            
            console.log('Sending update request...');
            
            fetch('${pageContext.request.contextPath}/review', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                console.log('Update response status:', response.status);
                if (!response.ok) {
                    throw new Error('HTTP error! status: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Update response data:', data);
                if (data.success) {
                    window.courseRegistration.showMessage(data.message, 'success');
                    closeEditModal();
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                } else {
                    window.courseRegistration.showMessage(data.message || 'Có lỗi xảy ra khi cập nhật đánh giá', 'error');
                }
            })
            .catch(error => {
                console.error('Update error:', error);
                window.courseRegistration.showMessage('Có lỗi xảy ra khi cập nhật đánh giá. Vui lòng thử lại.', 'error');
            })
            .finally(() => {
                // Restore button state
                submitBtn.disabled = false;
                submitBtn.classList.remove('opacity-75', 'cursor-not-allowed');
                buttonText.innerHTML = originalText;
            });
        });
    }
    
    // Close modals when clicking outside
    const editModal = document.getElementById('editReviewModal');
    const deleteModal = document.getElementById('deleteConfirmModal');
    
    if (editModal) {
        editModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });
    }
    
    if (deleteModal) {
        deleteModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closeDeleteModal();
            }
        });
    }
    
    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (!editModal.classList.contains('hidden')) {
                closeEditModal();
            }
            if (!deleteModal.classList.contains('hidden')) {
                closeDeleteModal();
            }
        }
    });
});
</script>
</body>
</html>

<%
} catch (Exception e) {
    System.err.println("JSP Error: " + e.getMessage());
    e.printStackTrace();
    response.sendRedirect(request.getContextPath() + "/courses?error=page_error");
}
%>
%>
}
%>
