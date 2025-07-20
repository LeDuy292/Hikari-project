<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HIKARI | Giỏ hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
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
        <main class="flex-1 px-8 py-6 flex flex-col min-h-screen" style="margin-left: 320px;">
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
                        <c:if test="${not empty param.success}">
                <div class="bg-green-500 text-white p-4 rounded-lg mb-4 text-center">
                    <c:choose>
                        <c:when test="${param.success == 'payment_completed'}">
                            Thanh toán thành công! Các khóa học đã được thêm vào tài khoản của bạn.
                        </c:when>
                        <c:otherwise>
                            Thông báo thành công không xác định.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="bg-red-500 text-white p-4 rounded-lg mb-4 text-center">
                    <c:choose>
                        <c:when test="${param.error == 'empty_cart'}">
                            Giỏ hàng trống. Vui lòng thêm khóa học.
                        </c:when>
                        <c:when test="${param.error == 'payment_failed'}">
                            Thanh toán thất bại. Vui lòng thử lại.
                        </c:when>
                        <c:when test="${param.error == 'payment_cancelled'}">
                            Thanh toán đã bị hủy. Vui lòng kiểm tra lại!
                        </c:when>
                        <c:when test="${param.error == 'partial_enrollment'}">
                            <c:choose>
                                <c:when test="${not empty param.failedCourses}">
                                    Không thể đăng ký các khóa học: ${param.failedCourses}. Vui lòng liên hệ hỗ trợ.
                                </c:when>
                                <c:otherwise>
                                    Có lỗi khi đăng ký một số khóa học. Vui lòng liên hệ hỗ trợ.
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:when test="${param.error == 'invalid_session'}">
                            Phiên đăng nhập không hợp lệ. Vui lòng đăng nhập lại.
                        </c:when>
                        <c:when test="${param.error == 'payment_error'}">
                            Đã xảy ra lỗi trong quá trình thanh toán. Vui lòng thử lại sau.
                        </c:when>
                        <c:when test="${param.error == 'invalid_request'}">
                            Yêu cầu không hợp lệ. Vui lòng kiểm tra lại.
                        </c:when>
                        <c:when test="${param.error == 'unknown_status'}">
                            Trạng thái thanh toán không xác định. Vui lòng liên hệ hỗ trợ.
                        </c:when>
                        <c:otherwise>
                            Có lỗi xảy ra. Vui lòng liên hệ hỗ trợ.
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
            <!-- Banner -->
            <div class="bg-white rounded-3xl overflow-hidden shadow-xl mb-8 mt-8">
                <div class="mt-2 px-8 pb-8">
                    <div class="relative rounded-[2.5rem] overflow-hidden" style="height: 200px;">
                        <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Banner" class="absolute inset-0 w-full h-full object-cover" />
                        <div class="absolute inset-0 bg-black bg-opacity-20"></div>
                        <div class="absolute left-8 top-8 z-10">
                            <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">Giỏ hàng</h1>
                            <p class="text-white text-base">Quản lý các tài liệu bạn đã chọn</p>
                        </div>
                        <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
                    </div>
                </div>
            </div>
            <!-- Cart Content -->
            <div class="bg-white rounded-3xl shadow-xl p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center bg-gradient-to-r from-orange-400 to-orange-600 bg-clip-text text-transparent">
                    Giỏ hàng của bạn
                </h2>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    <div class="lg:col-span-2">
                        <div id="cartList" class="divide-y divide-gray-200 border-t border-gray-200">
                            <!-- Cart items will be dynamically loaded here -->
                        </div>
                        <div id="cartEmpty" class="hidden text-center py-10">
                            <i class="fa fa-shopping-cart text-4xl text-gray-400 mb-4"></i>
                            <p class="text-gray-500 text-lg mb-4">Giỏ hàng của bạn đang trống</p>
                            <a href="${pageContext.request.contextPath}/courses" class="text-orange-500 font-semibold hover:underline text-lg">Quay lại mua sắm</a>
                        </div>
                    </div>
                    <div class="lg:col-span-1 bg-gray-50 p-6 rounded-2xl shadow-md">
                        <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-3 border-gray-200">Tóm tắt đơn hàng</h3>
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-gray-700 font-medium">Tổng cộng:</span>
                            <span id="cartTotal" class="text-xl font-bold text-orange-600">0 VNĐ</span>
                        </div>
                        <div class="mb-6">
                            <label for="discountCode" class="block text-sm font-medium text-gray-700 mb-2">Mã giảm giá</label>
                            <div class="relative flex">
                                <input type="text" id="discountCode" placeholder="Nhập mã giảm giá" 
                                       class="flex-1 border border-orange-200 px-4 py-2 rounded-l-full w-full pl-10 shadow-sm focus:outline-none focus:ring-2 focus:ring-orange-200">
                                <i class="fa fa-ticket-alt absolute left-3 top-1/2 transform -translate-y-1/2 text-orange-400"></i>
                                <button id="applyDiscount" class="bg-orange-500 text-white font-bold py-2 px-6 rounded-r-full hover:bg-orange-600 transition-colors">Áp dụng</button>
                            </div>
                            <div id="discountMessage" class="text-sm text-gray-500 mt-2 hidden"></div>
                        </div>
                        <button id="checkoutBtn" class="w-full bg-orange-500 text-white font-bold py-3 px-6 rounded-xl hover:bg-orange-600 transition-colors shadow-lg disabled:opacity-50 disabled:cursor-not-allowed transform hover:-translate-y-1">
                            Thanh toán ngay
                        </button>
                    </div>
                </div>
            </div>
            <!-- Footer -->
            <%@ include file="footer.jsp" %>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/student_js/shopping.js?v=6"></script>
</body>
</html>