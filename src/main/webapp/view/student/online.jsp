<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HIKARI | ${pageTitle != null ? pageTitle : 'Khóa học'}</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css?v=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css?v=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css?v=1"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/shopping.css?v=1"/>
        <style>
            .course-card {
                transition: all 0.3s ease;
            }
            .course-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            }
            .enrolled-badge {
                background: linear-gradient(135deg, #10b981, #059669);
                animation: pulse 2s infinite;
            }
            @keyframes pulse {
                0%, 100% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.8;
                }
            }
            .progress-bar {
                background: linear-gradient(90deg, #f59e0b, #d97706);
                height: 4px;
                border-radius: 2px;
            }
            .progress-fill {
                height: 100%;
                background: linear-gradient(90deg, #3498db, #2ecc71);
                border-radius: 4px;
                transition: width 0.3s ease;
            }
            .empty-state {
                text-align: center;
                padding: 80px 20px;
                color: #7f8c8d;
            }
            .empty-state i {
                font-size: 4rem;
                margin-bottom: 20px;
                color: #bdc3c7;
            }
            .btn-explore {
                background: linear-gradient(135deg, #f59e0b, #d97706);
                color: white;
                padding: 12px 30px;
                border-radius: 25px;
                text-decoration: none;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);
            }
            .btn-explore:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(245, 158, 11, 0.4);
            }
            .notification {
                min-width: 300px;
                max-width: 400px;
                padding: 16px 24px;
                border-radius: 8px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                color: white;
                font-weight: 500;
                font-size: 14px;
                line-height: 1.4;
                backdrop-filter: blur(10px);
                border-left: 4px solid rgba(255, 255, 255, 0.3);
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 1000;
                opacity: 0;
                transform: scale(0.95);
                transition: opacity 0.3s ease, transform 0.3s ease;
            }
            .notification.active {
                opacity: 1;
                transform: scale(1);
            }
            .notification.success {
                background: linear-gradient(135deg, #10b981, #059669);
                border-left-color: #34d399;
            }
            .notification.error {
                background: linear-gradient(135deg, #ef4444, #dc2626);
                border-left-color: #f87171;
            }
            .notification button {
                background: none;
                border: none;
                color: white;
                font-size: 18px;
                font-weight: bold;
                cursor: pointer;
                padding: 0;
                margin-left: 8px;
                opacity: 0.8;
                transition: opacity 0.2s ease;
            }
            .notification button:hover {
                opacity: 1;
            }
            .notification i {
                color: white;
                margin-right: 8px;
            }
            .notification span {
                color: white;
            }
        </style>
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
        </script>
    </head>
    <body class="bg-[#f7f7fa] font-sans">
        <div id="notification-container" class="fixed top-4 right-4 z-50 w-80 space-y-2"></div>

        <div class="flex min-h-screen">
            <%@ include file="sidebar.jsp" %>
            <main class="flex-1 px-8 py-6 flex flex-col min-h-screen" style="margin-left: 320px;">
                <%@ include file="header.jsp" %>

                <div id="signupModal" class="modal hidden">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal()">&times;</span>
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

                <div class="bg-white rounded-3xl overflow-hidden shadow-xl mb-8 mt-8">
                    <div class="mt-2 px-8 pb-8">
                        <div class="relative rounded-[2.5rem] overflow-hidden" style="height: 200px;">
                            <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Banner" class="absolute inset-0 w-full h-full object-cover" />
                            <div class="absolute inset-0 bg-black bg-opacity-20"></div>
                            <div class="absolute left-8 top-8 z-10">
                                <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">
                                    ${category == 'my-courses' ? 'Khóa học của tôi' : 'Khóa học trực tuyến'}
                                </h1>
                                <p class="text-white text-base">
                                    ${category == 'my-courses' ? 'Các khóa học bạn đã đăng ký' : 'Khám phá các khóa học tiếng Nhật chất lượng cao'}
                                </p>
                            </div>
                            <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-3xl shadow-xl p-6 mb-8">
                    <div class="flex flex-col md:flex-row justify-between items-center mb-6">
                        <div class="flex space-x-4 mb-4 md:mb-0">
                            <a href="${pageContext.request.contextPath}/courses?category=paid" 
                               class="px-6 py-3 rounded-full text-sm font-semibold transition-all duration-300 ${param.category == null || param.category == 'paid' ? 'bg-orange-500 text-white shadow-lg' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                                <i class="fas fa-book mr-2"></i>Khóa học trả phí
                            </a>
                            <c:if test="${sessionScope.user != null}">
                                <a href="${pageContext.request.contextPath}/myCourses" 
                                   class="px-6 py-3 rounded-full text-sm font-semibold transition-all duration-300 ${category == 'my-courses' ? 'bg-green-500 text-white shadow-lg' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">
                                    <i class="fas fa-graduation-cap mr-2"></i>Khóa học của tôi
                                </a>
                            </c:if>
                        </div>

                        <c:if test="${category != 'my-courses'}">
                            <form action="${pageContext.request.contextPath}/courses" method="get" class="w-full md:w-auto flex">
                                <input type="hidden" name="action" value="list">
                                <input type="hidden" name="category" value="${param.category != null ? param.category : 'paid'}">
                                <input type="text" name="search" placeholder="Tìm kiếm khóa học..." 
                                       class="flex-1 border border-gray-300 rounded-l-full px-4 py-2 focus:outline-none focus:ring-2 focus:ring-orange-200" 
                                       value="${param.search != null ? param.search : ''}">
                                <button type="submit" class="bg-orange-500 text-white px-5 py-2 rounded-r-full hover:bg-orange-600 transition">
                                    <i class="fa fa-search"></i>
                                </button>
                            </form>
                        </c:if>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <c:choose>
                            <c:when test="${category == 'my-courses'}">
                                <c:choose>
                                    <c:when test="${empty courses}">
                                        <div class="col-span-full empty-state">
                                            <div class="mb-8">
                                                <i class="fas fa-graduation-cap text-8xl text-gray-300 mb-6"></i>
                                                <h3 class="text-3xl font-bold text-gray-600 mb-4">Chưa có khóa học nào</h3>
                                                <p class="text-gray-500 text-lg mb-8 max-w-md mx-auto">
                                                    Bạn chưa đăng ký khóa học nào. Hãy khám phá các khóa học tuyệt vời của chúng tôi để bắt đầu hành trình học tập!
                                                </p>
                                                <a href="${pageContext.request.contextPath}/courses?category=paid" class="btn-explore">
                                                    <i class="fas fa-search"></i>Khám phá khóa học
                                                </a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mb-8 col-span-full">
                                            <div class="flex items-center justify-between">
                                                <div>
                                                    <h2 class="text-3xl font-bold text-gray-800 mb-2">Khóa học của bạn</h2>
                                                    <p class="text-gray-600 text-lg">Bạn đã đăng ký ${totalCourses} khóa học</p>
                                                </div>
                                                <div class="bg-green-100 text-green-800 px-4 py-2 rounded-full font-semibold">
                                                    <i class="fas fa-check-circle mr-2"></i>${totalCourses} khóa học
                                                </div>
                                            </div>
                                        </div>
                                        <c:forEach var="course" items="${courses}">
                                            <div class="course-card bg-white border border-gray-200 rounded-2xl overflow-hidden shadow-lg hover:shadow-xl transition-all duration-300">
                                                <div class="relative">
                                                    <img src="${pageContext.request.contextPath}${course.imageUrl != null && course.imageUrl != '' ? course.imageUrl : '/assets/img/JLPT-N1.png'}" 
                                                         alt="${course.title}" 
                                                         class="w-full h-48 object-cover">
                                                    <div class="absolute top-4 right-4">
                                                        <span class="enrolled-badge text-white px-3 py-1 rounded-full text-sm font-semibold">
                                                            <i class="fas fa-check-circle mr-1"></i>Đã đăng ký
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="p-6">
                                                    <h3 class="text-xl font-bold text-gray-800 mb-3 line-clamp-2">${course.title}</h3>
                                                    <p class="text-gray-600 mb-4 line-clamp-3">${course.description}</p>
                                                    <div class="flex items-center justify-between mb-4">
                                                        <div class="flex items-center text-gray-500">
                                                            <i class="fas fa-clock mr-2"></i>
                                                            <span>${course.duration} giờ</span>
                                                        </div>
                                                    </div>
                                                    <div class="mb-4">
                                                        <div class="flex justify-between text-sm text-gray-600 mb-1">
                                                            <span>Tiến độ học tập</span>
                                                            <span>0%</span>
                                                        </div>
                                                        <div class="w-full bg-gray-200 rounded-full h-2">
                                                            <div class="progress-fill bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full" style="width: 0%"></div>
                                                        </div>
                                                    </div>
                                                    <div class="space-y-3">
                                                        <button onclick="continueLearning('${course.courseID}')" 
                                                                class="w-full bg-green-500 text-white py-3 px-6 rounded-xl font-semibold hover:bg-green-600 transition-all duration-300 transform hover:scale-105">
                                                            <i class="fas fa-play mr-2"></i>Tiếp tục học
                                                        </button>
                                                        <div class="flex space-x-2">
                                                            <a href="${pageContext.request.contextPath}/courseInfo?id=${course.courseID}" 
                                                               class="flex-1 bg-gray-100 text-gray-700 py-2 px-4 rounded-xl font-medium hover:bg-gray-200 transition-colors text-center">
                                                                <i class="fas fa-info-circle mr-1"></i>Chi tiết
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${empty courses}">
                                        <div class="col-span-full empty-state">
                                            <i class="fa fa-exclamation-circle text-4xl mb-4"></i>
                                            <p class="text-lg">Không tìm thấy khóa học nào phù hợp.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="pageSize" value="6"/>
                                        <c:set var="currentPage" value="${param.page != null ? param.page : 1}"/>
                                        <c:set var="totalCourses" value="${courses.size()}"/>
                                        <c:set var="totalPages" value="${(totalCourses + pageSize - 1) div pageSize}"/>
                                        <c:set var="startIndex" value="${(currentPage - 1) * pageSize}"/>
                                        <c:set var="endIndex" value="${startIndex + pageSize - 1 < totalCourses ? startIndex + pageSize - 1 : totalCourses - 1}"/>

                                        <c:forEach var="course" items="${courses}" begin="${startIndex}" end="${endIndex}">
                                            <c:if test="${sessionScope.user == null || !enrolledCourses.contains(course.courseID)}">
                                                <div class="course-card bg-white rounded-2xl shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-300">
                                                    <a href="${pageContext.request.contextPath}/courseInfo?id=${course.courseID}">
                                                        <img src="${pageContext.request.contextPath}${course.imageUrl != null && course.imageUrl != '' ? course.imageUrl : '/assets/img/img_student/JLPT-N1.png'}" 
                                                             alt="${course.title}" class="w-full h-48 object-cover">
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
                                                                    <fmt:formatNumber value="${course.fee}" type="currency" currencySymbol="" pattern="#,##0"/> VNĐ
                                                                </c:if>
                                                            </span>
                                                            <span class="text-gray-500 text-sm">
                                                                <i class="fa fa-clock mr-1"></i>${course.duration} giờ
                                                            </span>
                                                        </div>
                                                        <div class="flex justify-between items-center">
                                                            <a href="${pageContext.request.contextPath}/courseInfo?id=${course.courseID}" class="text-orange-500 hover:underline font-semibold">Xem chi tiết</a>
                                                            <c:choose>
                                                                <c:when test="${sessionScope.user == null}">
                                                                    <button class="bg-gray-500 text-white px-4 py-2 rounded-full text-sm font-semibold hover:bg-gray-600 transition" onclick="showLoginRequired()">
                                                                        <i class="fa fa-sign-in-alt mr-2"></i>Đăng nhập để mua
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button class="bg-orange-500 text-white px-4 py-2 rounded-full text-sm font-semibold hover:bg-orange-600 transition add-to-cart-btn" 
                                                                            data-course-id="${course.courseID}" onclick="window.cart.addToCart('${course.courseID}')">
                                                                        <i class="fa fa-cart-plus mr-2"></i>Thêm vào giỏ
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${totalPages > 1}">
                                            <div class="col-span-full flex justify-center mt-6">
                                                <div class="flex space-x-2">
                                                    <c:if test="${currentPage > 1}">
                                                        <a href="${pageContext.request.contextPath}/courses?action=list&category=${param.category != null ? param.category : 'paid'}&search=${param.search != null ? param.search : ''}&page=${currentPage - 1}" 
                                                           class="px-4 py-2 bg-gray-100 text-gray-700 rounded-full hover:bg-gray-200">
                                                            <i class="fa fa-chevron-left"></i>
                                                        </a>
                                                    </c:if>
                                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                                        <a href="${pageContext.request.contextPath}/courses?action=list&category=${param.category != null ? param.category : 'paid'}&search=${param.search != null ? param.search : ''}&page=${i}" 
                                                           class="px-4 py-2 rounded-full ${currentPage == i ? 'bg-orange-500 text-white' : 'bg-gray-100 text-gray-700 hover:bg-gray-200'}">${i}</a>
                                                    </c:forEach>
                                                    <c:if test="${currentPage < totalPages}">
                                                        <a href="${pageContext.request.contextPath}/courses?action=list&category=${param.category != null ? param.category : 'paid'}&search=${param.search != null ? param.search : ''}&page=${currentPage + 1}" 
                                                           class="px-4 py-2 bg-gray-100 text-gray-700 rounded-full hover:bg-gray-200">
                                                            <i class="fa fa-chevron-right"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%@ include file="footer.jsp" %>
            </main>
        </div>

        <script>
            // CHANGE START: Added global showMessage function to use showNotification
            // Global showMessage function to display toast notifications
            window.showMessage = function (message, type = 'success', duration = 5000) {
                console.log('showMessage called:', {message, type, duration}); // Debug
                showNotification(message, type, duration);
            };
            // CHANGE END

            // Notification system
            function showNotification(message, type = 'success', duration = 5000) {
                console.log('showNotification called:', {message, type, duration}); // Debug
                const container = document.getElementById('notification-container');
                if (!container) {
                    console.error('Notification container not found');
                    return;
                }
                const notification = document.createElement('div');
                notification.className = `notification \${type.toLowerCase().trim() === 'success' ? 'success' : 'error'} opacity-0 scale-95 transition-all duration-300`;
                notification.innerHTML = `
                    <div class="flex items-center justify-between">
                        <div class="flex items-center">
                            <i class="\${type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle'} mr-2"></i>
                            <span>\${message || (type === 'success' ? 'Thành công!' : 'Lỗi xảy ra!')}</span>
                        </div>
                        <button onclick="this.parentElement.parentElement.remove()" class="ml-4 text-white hover:text-gray-200 focus:outline-none">&times;</button>
                    </div>`;

                container.appendChild(notification);

                // Fade in
                setTimeout(() => {
                    notification.classList.remove('opacity-0', 'scale-95');
                    notification.classList.add('opacity-100', 'scale-100');
                }, 50);

                // Fade out
                setTimeout(() => {
                    notification.classList.remove('opacity-100', 'scale-100');
                    notification.classList.add('opacity-0', 'scale-95');
                    setTimeout(() => {
                        if (notification.parentNode) {
                            notification.parentNode.removeChild(notification);
                        }
                    }, 300);
                }, duration);
            }

            // Time display function
            function updateTime() {
                const timeElement = document.getElementById('current-time');
                if (timeElement) {
                    const now = new Date();
                    timeElement.textContent = now.toLocaleTimeString('vi-VN', {hour12: false});
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                console.log('online.jsp loaded'); // Debug
                updateTime();
                setInterval(updateTime, 1000);

                const urlParams = new URLSearchParams(window.location.search);
                if (urlParams.get('payment') === 'success') {
                    window.showMessage('Thanh toán thành công! Khóa học đã được thêm.', 'success', 5000);
                }
                // Debug: Check for URL params
                if (urlParams.has('success') || urlParams.has('error')) {
                    console.log('URL params:', Object.fromEntries(urlParams));
                }

                setTimeout(() => {
                    document.querySelectorAll('.progress-fill').forEach(bar => {
                        const width = bar.style.width;
                        bar.style.width = '0%';
                        setTimeout(() => {
                            bar.style.width = width;
                        }, 100);
                    });
                }, 500);
            });

            // Continue learning function
            function continueLearning(courseID) {
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Đang tải...';
                button.disabled = true;
                setTimeout(() => {
                    window.location.href = window.contextPath + '/learn?courseID=' + courseID;
                }, 1000);
            }

            // Download certificate function
            function downloadCertificate(courseID) {
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin mr-1"></i>Đang tải...';
                button.disabled = true;
                window.showMessage('Chức năng tải chứng chỉ đang được phát triển!', 'info', 5000);
                button.innerHTML = originalText;
                button.disabled = false;
            }

            // Show login required message and redirect to login page
            function showLoginRequired() {
                window.showMessage('Bạn cần đăng nhập để mua khóa học!', 'info', 3000);
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/loginPage';
                }, 3000);
            }

            // Modal functions
            function openModal() {
                const modal = document.getElementById("signupModal");
                if (modal)
                    modal.style.display = "flex";
            }

            function closeModal() {
                const modal = document.getElementById("signupModal");
                if (modal)
                    modal.style.display = "none";
            }

            window.onclick = function (event) {
                const modal = document.getElementById('signupModal');
                if (event.target == modal) {
                    modal.style.display = 'none';
                }
            }
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/student_js/shopping.js?v=4"></script>
    </body>
</html>