<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HIKARI | Giỏ hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css?v=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css?v=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css?v=1"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/shopping.css?v=1"/>
    <style>
        /* Notification styles - Fixed positioning and z-index */
        #messages {
            position: relative;
            z-index: 9999;
        }
        
        .message { 
            margin: 12px auto; 
            padding: 16px 20px; 
            border-radius: 12px; 
            text-align: center; 
            font-size: 14px; 
            font-weight: 500; 
            max-width: 600px;
            position: relative;
            z-index: 10000;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            animation: slideInDown 0.3s ease-out;
        }
        
        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .message.success { 
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%); 
            color: #155724; 
            border: 1px solid #c3e6cb;
            border-left: 4px solid #28a745;
        }
        
        .message.error { 
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%); 
            color: #721c24; 
            border: 1px solid #f5c6cb;
            border-left: 4px solid #dc3545;
        }
        
        .message.info {
            background: linear-gradient(135deg, #d1ecf1 0%, #bee5eb 100%);
            color: #0c5460;
            border: 1px solid #bee5eb;
            border-left: 4px solid #17a2b8;
        }
        
        .message .close-btn { 
            position: absolute; 
            right: 12px; 
            top: 12px; 
            cursor: pointer; 
            color: inherit;
            font-size: 18px;
            font-weight: bold;
            opacity: 0.7;
            transition: opacity 0.2s;
        }
        
        .message .close-btn:hover {
            opacity: 1;
        }
        
        /* Cart notification styles */
        .cart-message {
            position: fixed !important;
            top: 20px !important;
            right: 20px !important;
            z-index: 10001 !important;
            min-width: 300px;
            max-width: 500px;
            padding: 16px 20px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 500;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            animation: slideInRight 0.3s ease-out;
            pointer-events: auto;
        }
        
        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(100%);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        /* Discount section styles */
        .discount-section {
            background: linear-gradient(135deg, #fff5f5 0%, #fef5e7 100%);
            border: 1px solid #fed7aa;
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 24px;
        }
        
        .discount-input-group {
            position: relative;
            display: flex;
            border-radius: 50px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            transition: box-shadow 0.3s ease;
        }
        
        .discount-input-group:focus-within {
            box-shadow: 0 4px 12px rgba(249, 115, 22, 0.2);
        }
        
        .discount-input {
            flex: 1;
            border: none;
            padding: 14px 16px 14px 45px;
            font-size: 14px;
            outline: none;
            background: white;
        }
        
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #f97316;
            z-index: 1;
        }
        
        .discount-btn {
            border: none;
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            color: white;
            padding: 14px 24px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .discount-btn:hover {
            background: linear-gradient(135deg, #ea580c 0%, #dc2626 100%);
            transform: translateY(-1px);
        }
        
        .discount-btn:active {
            transform: translateY(0);
        }
        
        .discount-btn:disabled {
            background: #d1d5db;
            cursor: not-allowed;
            transform: none;
        }
        
        .discount-message {
            margin-top: 12px;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .discount-message.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .discount-message.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .cart-item { transition: all 0.3s ease; }
        .cart-item:hover { background: #f8f9fa; }
        .loading-spinner { 
            display: none; 
            text-align: center; 
            padding: 20px; 
            color: #666; 
        }
        .loading-spinner.active { display: block; }
        #cartEmpty { 
            transition: opacity 0.3s ease; 
        }
        @media (max-width: 768px) {
            main { margin-left: 0 !important; }
            .cart-item-grid { grid-template-columns: 1fr; }
        }
    </style>
    <script>
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body class="bg-[#f7f7fa] font-sans">
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <%@ include file="sidebar.jsp" %>
        <!-- Main content -->
        <main class="flex-1 px-4 sm:px-8 py-6 flex flex-col min-h-screen" style="margin-left: 320px;">
            <!-- Header -->
            <%@ include file="header.jsp" %>
            <!-- Messages -->
            <div id="messages" class="mb-4">
                <%@ include file="payment_messages.jsp" %>
            </div>
            <!-- Banner -->
            <div class="bg-white rounded-3xl overflow-hidden shadow-xl mb-8 mt-8">
                <div class="mt-2 px-8 pb-8">
                    <div class="relative rounded-[2.5rem] overflow-hidden" style="height: 200px;">
                        <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Banner" class="absolute inset-0 w-full h-full object-cover" />
                        <div class="absolute inset-0 bg-black bg-opacity-20"></div>
                        <div class="absolute left-8 top-8 z-10">
                            <h1 class="text-2xl md:text-3xl font-bold text-white mb-2">Giỏ hàng</h1>
                            <p class="text-white text-base">Quản lý các khóa học bạn đã chọn</p>
                        </div>
                        <div class="absolute left-0 right-0 bottom-0 h-2 bg-gradient-to-r from-orange-400 to-orange-300 rounded-b-[2.5rem]"></div>
                    </div>
                </div>
            </div>
            <!-- Cart Content -->
            <div id="cartContent" class="bg-white rounded-3xl shadow-xl p-6 mb-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center bg-gradient-to-r from-orange-400 to-orange-600 bg-clip-text text-transparent">
                    Giỏ hàng của bạn
                </h2>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 cart-item-grid">
                    <div class="lg:col-span-2">
                        <div id="cartList" class="divide-y divide-gray-200 border-t border-gray-200 opacity-0 transition-opacity duration-300">
                            <!-- Cart items will be dynamically loaded here -->
                        </div>
                        <div id="cartEmpty" class="hidden text-center py-10" aria-live="polite">
                            <i class="fa fa-shopping-cart text-4xl text-gray-400 mb-4"></i>
                            <p class="text-gray-500 text-lg mb-4">Giỏ hàng của bạn đang trống</p>
                            <a href="${pageContext.request.contextPath}/courses" class="text-orange-500 font-semibold hover:underline text-lg mr-4" aria-label="Quay lại mua sắm">Quay lại mua sắm</a>
                            <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="text-orange-500 font-semibold hover:underline text-lg" aria-label="Quay lại trang chủ">Quay lại trang chủ</a>
                        </div>
                        <div id="cartLoading" class="loading-spinner">
                            <i class="fa fa-spinner fa-spin text-2xl"></i>
                            <p>Đang tải giỏ hàng...</p>
                        </div>
                    </div>
                    <div class="lg:col-span-1 bg-gray-50 p-6 rounded-2xl shadow-md">
                        <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-3 border-gray-200">Tóm tắt đơn hàng</h3>
                        <div class="flex justify-between items-center mb-2">
                            <span class="text-gray-700 font-medium">Số khóa học:</span>
                            <span id="cartItemCount" class="text-gray-800 font-semibold">0</span>
                        </div>
                        <div class="flex justify-between items-center mb-2">
                            <span class="text-gray-700 font-medium">Tổng giá:</span>
                            <span id="subTotal" class="text-gray-800 font-semibold">0 VNĐ</span>
                        </div>
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-gray-700 font-medium">Giảm giá:</span>
                            <span id="discountAmount" class="text-gray-800 font-semibold">0 VNĐ</span>
                        </div>
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-gray-700 font-medium">Tổng cộng:</span>
                            <span id="cartTotal" class="text-xl font-bold text-orange-600">0 VNĐ</span>
                        </div>
                        <div class="mb-6 discount-section">
                            <label for="discountCode" class="block text-sm font-medium text-gray-700 mb-3">
                                <i class="fa fa-tag text-orange-500 mr-2"></i>Mã giảm giá
                            </label>
                            <div class="discount-input-group">
                                <i class="fa fa-ticket-alt input-icon"></i>
                                <input type="text" id="discountCode" placeholder="Nhập mã giảm giá của bạn" 
                                       class="discount-input"
                                       aria-label="Nhập mã giảm giá" maxlength="20">
                                <button id="applyDiscount" class="discount-btn"
                                        aria-label="Áp dụng mã giảm giá">
                                    <span class="btn-text">Áp dụng</span>
                                    <i class="fa fa-spinner fa-spin btn-spinner" style="display: none;"></i>
                                </button>
                            </div>
                            <div id="discountMessage" class="discount-message"></div>
                        </div>
                        <button id="checkoutBtn" class="w-full bg-orange-500 text-white font-bold py-3 px-6 rounded-xl hover:bg-orange-600 transition-colors shadow-lg disabled:opacity-50 disabled:cursor-not-allowed transform hover:-translate-y-1"
                                aria-label="Thanh toán ngay">
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