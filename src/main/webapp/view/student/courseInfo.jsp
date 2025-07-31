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
<body class="bg-gradient-to-br from-gray-50 via-blue-50 to-indigo-50 font-sans">
<div class="flex-container">
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp" />

    <!-- Main content - Full width như index.jsp -->
    <main class="flex-1 px-8 py-6 flex flex-col course-info-container" style="margin-left: 320px !important;">
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Enhanced Hero Banner - Full Width -->
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

        <!-- Enhanced Navigation Tabs - Full Width -->
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

        <!-- Error Message -->
        <% if (error != null) { %>
            <div class="bg-red-50 border-l-4 border-red-400 text-red-700 p-6 rounded-2xl mb-8 shadow-lg w-full-custom">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-triangle mr-3 text-xl"></i>
                    <span class="font-medium text-lg">
                        <%= error.equals("no_data") ? "Không tìm thấy khóa học hoặc thông tin chi tiết." : "ID khóa học không hợp lệ." %>
                    </span>
                </div>
            </div>
        <% } %>

        <!-- Enhanced Course Content Grid - Full Width -->
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

<script src="${pageContext.request.contextPath}/assets/js/student_js/courseInfo.js"></script>
<script>
// Course registration functionality
window.courseRegistration = {
    // Check if user is logged in
    checkUserLogin: function() {
        return ${sessionScope.user != null};
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
            body: `action=addToCart&courseID=${courseId}`
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
                    const goToCartBtn = `
                        <button onclick="window.location.href='${pageContext.request.contextPath}/view/student/shopping_cart.jsp'" 
                                class="enhanced-button secondary w-full text-lg mt-3">
                            <i class="fas fa-shopping-cart mr-3"></i>Xem giỏ hàng
                        </button>
                    `;
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
            window.location.href = '${pageContext.request.contextPath}/view/login.jsp';
        }, 2000);
    },
    
    // Show notification message
    showMessage: function(message, type) {
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
        messageDiv.className = `notification-message fixed top-4 right-4 ${colors[type]} text-white px-6 py-4 rounded-lg shadow-lg z-50 transform translate-x-full transition-transform duration-300`;
        messageDiv.innerHTML = `
            <div class="flex items-center">
                <i class="${icons[type]} mr-3"></i>
                <span>${message}</span>
                <button onclick="this.parentElement.parentElement.remove()" class="ml-4 text-white hover:text-gray-200">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;
        
        document.body.appendChild(messageDiv);
        
        // Slide in
        setTimeout(() => {
            messageDiv.classList.remove('translate-x-full');
            messageDiv.classList.add('translate-x-0');
        }, 100);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (messageDiv.parentNode) {
                messageDiv.classList.add('translate-x-full');
                setTimeout(() => {
                    if (messageDiv.parentNode) {
                        messageDiv.remove();
                    }
                }, 300);
            }
        }, 5000);
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
</script>
</body>
</html>
