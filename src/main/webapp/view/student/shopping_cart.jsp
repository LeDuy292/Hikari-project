<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HIKARI | Giỏ hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css?v=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css?v=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css?v=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/shopping.css?v=1"/>
    <script src="${pageContext.request.contextPath}/assets/js/student_js/shopping.js?v=1"></script>
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
                            <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">Giỏ hàng</h1>
                            <p class="text-white text-base">Quản lý các tài liệu bạn đã chọn</p>
                        </div>
                        <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
                    </div>
                </div>
            </div>
            <!-- Cart Content -->
            <div class="bg-white rounded-3xl shadow-xl p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">Giỏ hàng của bạn</h2>
                <div id="cartList" class="divide-y divide-gray-200">
                    <!-- Cart items will be dynamically loaded here -->
                </div>
                <div id="cartLoading" class="text-center py-10">
                    <i class="fa fa-spinner fa-spin text-4xl text-gray-400 mb-4"></i>
                    <p class="text-gray-500 text-lg">Đang tải giỏ hàng...</p>
                </div>
                <div id="cartEmpty" class="hidden text-center py-10">
                    <i class="fa fa-shopping-cart text-4xl text-gray-400 mb-4"></i>
                    <p class="text-gray-500 text-lg">Giỏ hàng của bạn đang trống</p>
                    <a href="${pageContext.request.contextPath}/courses" class="text-orange-500 font-semibold hover:underline">Quay lại mua sắm</a>
                </div>
                <div class="mt-6">
                    <div class="flex flex-col sm:flex-row gap-4 mb-6">
                        <div class="relative flex-1">
                            <input type="text" id="discountCode" placeholder="Nhập mã giảm giá" class="border border-orange-200 px-5 py-2 rounded-full w-full pl-11 shadow-sm focus:outline-none focus:ring-2 focus:ring-orange-200">
                            <i class="fa fa-ticket-alt absolute left-4 top-1/2 transform -translate-y-1/2 text-orange-400"></i>
                        </div>
                        <button id="applyDiscount" class="bg-orange-500 text-white font-bold py-2 px-6 rounded-full hover:bg-orange-600 transition">Áp dụng</button>
                    </div>
                    <div id="discountMessage" class="text-sm text-gray-500 mb-4 hidden"></div>
                    <div class="flex justify-between items-center">
                        <div class="text-lg font-semibold text-gray-800">
                            Tổng cộng: <span id="cartTotal">0 VNĐ</span>
                        </div>
                        <button id="checkoutBtn" class="bg-orange-500 text-white font-bold py-2 px-6 rounded-full hover:bg-orange-600 transition disabled:opacity-50 disabled:cursor-not-allowed">
                            Thanh toán
                        </button>
                    </div>
                </div>
            </div>
            <!-- Footer -->
            <%@ include file="footer.jsp" %>
        </main>
    </div>
</body>
</html>