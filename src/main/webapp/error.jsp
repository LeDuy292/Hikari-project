<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi - HIKARI JAPAN</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-lg max-w-md w-full">
        <div class="text-center">
            <div class="text-6xl text-red-500 mb-4">
                <i class="fas fa-exclamation-circle"></i>
            </div>
            <h1 class="text-2xl font-bold text-gray-800 mb-2">Đã xảy ra lỗi</h1>
            
            <c:if test="${not empty errorMessage}">
                <p class="text-gray-600 mb-6">${errorMessage}</p>
            </c:if>
            
            <c:if test="${empty errorMessage}">
                <p class="text-gray-600 mb-6">Xin lỗi, đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn.</p>
            </c:if>
            
            <div class="flex justify-center space-x-4">
                <a href="${pageContext.request.contextPath}/home" class="bg-blue-500 hover:bg-blue-600 text-white font-medium py-2 px-6 rounded-md transition duration-300">
                    Về Trang Chủ
                </a>
                <button onclick="window.history.back()" class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-medium py-2 px-6 rounded-md transition duration-300">
                    Quay Lại
                </button>
            </div>
            
            <!-- Debug information (only show in development) -->
            <c:if test="${pageContext.request.serverName == 'localhost'}">
                <div class="mt-8 p-4 bg-gray-100 rounded-md text-left text-sm">
                    <p class="font-medium mb-2">Thông tin lỗi:</p>
                    <p>Status Code: ${pageContext.errorData.statusCode}</p>
                    <c:if test="${not empty pageContext.exception}">
                        <p>Exception: ${pageContext.exception}</p>
                        <p>Message: ${pageContext.exception.message}</p>
                    </c:if>
                    <c:if test="${not empty requestScope['jakarta.servlet.error.message']}">
                        <p>Error Message: ${requestScope['jakarta.servlet.error.message']}</p>
                    </c:if>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
