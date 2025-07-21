<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.UserAccount" %>

<!DOCTYPE html> 
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kiểm tra ngữ pháp - HIKARI JAPAN</title>

        <!-- CSS Libraries -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', sans-serif;
                background-color: #f8fafc;
                line-height: 1.6;
            }

            /* Main Layout */
            .main-container {
                margin-left: 260px;
                padding-top: 80px;
                min-height: 100vh;
                transition: margin-left 0.3s ease;
            }

            .main-content {
                padding: 40px;
            }

            .content-wrapper {
                max-width: 1200px;
                margin: 0 auto;
            }

            /* Header Styles */
            .header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                height: 80px;
                background: white;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                z-index: 1000;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 0 30px;
            }

            .logo {
                font-size: 1.5rem;
                font-weight: 700;
                color: #ff9800;
            }

            .user-menu {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            /* Sidebar Styles */
            .sidebar {
                position: fixed;
                top: 80px;
                left: 0;
                width: 260px;
                height: calc(100vh - 80px);
                background: white;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
                padding: 30px 0;
                z-index: 999;
            }

            .nav-menu {
                list-style: none;
                padding: 0 20px;
            }

            .nav-item {
                margin-bottom: 8px;
            }

            .nav-link {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                color: #64748b;
                text-decoration: none;
                border-radius: 10px;
                transition: all 0.3s ease;
                gap: 12px;
            }

            .nav-link:hover,
            .nav-link.active {
                background: linear-gradient(90deg, #ff9100, #ffb347);
                color: white;
            }

            /* Grammar Check Specific Styles */
            .section-header {
                text-align: center;
                margin-bottom: 40px;
                padding: 20px 0;
            }

            .section-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: #1a1a1a;
                margin-bottom: 12px;
                background: linear-gradient(90deg, #ff9100, #ffb347);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .section-subtitle {
                font-size: 1.1rem;
                color: #666;
                max-width: 700px;
                margin: 0 auto;
                line-height: 1.6;
            }

            .grammar-section {
                background: white;
                padding: 40px 30px;
                border-radius: 20px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                margin: 30px 0;
                position: relative;
                overflow: hidden;
            }

            .grammar-section::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #ff9100 0%, #ffb347 100%);
            }

            .grammar-form {
                max-width: 800px;
                margin: 0 auto;
            }

            .form-group {
                margin-bottom: 24px;
            }

            .form-label {
                display: block;
                font-weight: 600;
                color: #1a1a1a;
                margin-bottom: 12px;
                font-size: 1.1rem;
            }

            .form-input {
                width: 100%;
                padding: 16px 20px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 1rem;
                font-family: 'Inter', sans-serif;
                transition: all 0.3s ease;
                resize: vertical;
                min-height: 120px;
                background: #fafbfc;
            }

            .form-input:focus {
                outline: none;
                border-color: #ff9800;
                box-shadow: 0 0 0 4px rgba(255, 152, 0, 0.1);
                background: white;
            }

            .form-input::placeholder {
                color: #999;
                font-style: italic;
            }

            .btn-primary {
                background: linear-gradient(90deg, #ff9100 0%, #ffb347 100%);
                color: white;
                border: none;
                padding: 16px 32px;
                border-radius: 12px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                box-shadow: 0 4px 15px rgba(255, 152, 0, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(255, 152, 0, 0.4);
                background: linear-gradient(90deg, #f57c00 0%, #ff9800 100%);
            }

            .btn-primary:active {
                transform: translateY(0);
            }

            .result-section {
                margin-top: 30px;
                padding: 24px 28px;
                border-radius: 16px;
                position: relative;
                overflow: hidden;
            }

            .result-section.success {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                border: 2px solid #0ea5e9;
            }

            .result-section.error {
                background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
                border: 2px solid #ef4444;
            }

            .result-header {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 16px;
                font-size: 1.1rem;
                font-weight: 600;
            }

            .result-section.success .result-header {
                color: #0369a1;
            }

            .result-section.error .result-header {
                color: #dc2626;
            }

            .result-header i {
                font-size: 1.3rem;
            }

            .result-content, .error-content {
                background: white;
                padding: 20px 24px;
                border-radius: 12px;
                line-height: 1.8;
                font-family: 'Inter', sans-serif;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                white-space: pre-line;
            }

            .result-content {
                border-left: 4px solid #0ea5e9;
            }

            .error-content {
                border-left: 4px solid #ef4444;
                color: #dc2626;
            }

            .usage-tips {
                background: linear-gradient(135deg, #fff9f0 0%, #fff4e5 100%);
                padding: 24px 28px;
                border-radius: 16px;
                margin: 30px 0;
                border-left: 4px solid #ff9800;
            }

            .tips-title {
                font-weight: 600;
                color: #1a1a1a;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .tips-title i {
                color: #ff9800;
            }

            .tips-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .tips-list li {
                padding: 8px 0;
                color: #555;
                position: relative;
                padding-left: 24px;
            }

            .tips-list li:before {
                content: "•";
                color: #ff9800;
                font-weight: bold;
                position: absolute;
                left: 0;
            }

            /* Footer */
            .footer {
                background: #1a1a1a;
                color: white;
                text-align: center;
                padding: 30px 0;
                margin-top: 60px;
            }

            /* Loading state */
            .btn-primary.loading {
                position: relative;
                color: transparent;
            }

            .btn-primary.loading::after {
                content: "";
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 20px;
                height: 20px;
                border: 2px solid rgba(255, 255, 255, 0.3);
                border-top: 2px solid white;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: translate(-50%, -50%) rotate(0deg);
                }
                100% {
                    transform: translate(-50%, -50%) rotate(360deg);
                }
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-container {
                    margin-left: 0;
                    padding-top: 60px;
                }

                .sidebar {
                    display: none;
                }

                .main-content {
                    padding: 20px;
                }

                .grammar-section {
                    padding: 24px 20px;
                    margin: 20px 0;
                }

                .section-title {
                    font-size: 1.8rem;
                }

                .form-input {
                    padding: 14px 16px;
                }

                .btn-primary {
                    width: 100%;
                    justify-content: center;
                }
            }

            /* Animation */
            .fade-in {
                animation: fadeInUp 0.6s ease-out;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <%@ include file="sidebar.jsp" %>

        <!-- Main Container -->
        <div class="main-container">
            <%@ include file="header.jsp" %>
            <!-- Main Content -->
            <div class="main-content">
                <div class="content-wrapper">
                    <!-- Section Header -->
                    <div class="section-header fade-in">
                        <h1 class="section-title">Kiểm tra ngữ pháp tiếng Nhật</h1>
                        <p class="section-subtitle">Sử dụng công nghệ AI tiên tiến để kiểm tra và sửa lỗi ngữ pháp trong câu tiếng Nhật của bạn một cách chính xác và nhanh chóng</p>
                    </div>

                    <!-- Grammar Check Form -->
                    <div class="grammar-section fade-in">
                        <form method="post" action="${pageContext.request.contextPath}/checkGrammar" class="grammar-form" id="grammarForm">
                            <div class="form-group">
                                <label for="text" class="form-label">
                                    <i class="fas fa-edit"></i>
                                    Nhập câu tiếng Nhật cần kiểm tra:
                                </label>
                                <textarea 
                                    id="text" 
                                    name="text" 
                                    class="form-input"
                                    placeholder="例：わたしは学生です。&#10;私の名前はタナカです。&#10;今日は天気がいいですね。"
                                    required
                                    >${param.text}</textarea>
                            </div>

                            <button type="submit" class="btn-primary" id="submitBtn">
                                <i class="fas fa-check-circle"></i>
                                Kiểm tra ngữ pháp
                            </button>
                        </form>
                    </div>

                    <!-- Success Result Section -->
                    <c:if test="${not empty correctedText}">
                        <div class="result-section success fade-in">
                            <div class="result-header">
                                <i class="fas fa-check-circle"></i>
                                ${not empty message ? message : "Kết quả kiểm tra ngữ pháp"}
                            </div>
                            <div class="result-content">
                                ${correctedText}
                            </div>
                        </div>
                    </c:if>

                    <!-- Error Result Section -->
                    <c:if test="${not empty error}">
                        <div class="result-section error fade-in">
                            <div class="result-header">
                                <i class="fas fa-exclamation-triangle"></i>
                                Có lỗi xảy ra
                            </div>
                            <div class="error-content">
                                ${error}
                            </div>
                        </div>
                    </c:if>

                    <!-- Usage Tips -->
                    <div class="usage-tips fade-in">
                        <div class="tips-title">
                            <i class="fas fa-lightbulb"></i>
                            Mẹo sử dụng hiệu quả
                        </div>
                        <ul class="tips-list">
                            <li>Nhập câu tiếng Nhật hoàn chỉnh để có kết quả kiểm tra tốt nhất</li>
                            <li>Bạn có thể nhập nhiều câu cùng lúc, mỗi câu trên một dòng</li>
                            <li>Hệ thống sẽ tự động phát hiện và sửa các lỗi ngữ pháp phổ biến</li>
                            <li>Kết quả sẽ hiển thị câu đã sửa và giải thích các thay đổi</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Form submission handling với loading state
            document.getElementById('grammarForm').addEventListener('submit', function (e) {
                const submitBtn = document.getElementById('submitBtn');
                const textArea = document.getElementById('text');

                // Kiểm tra input không rỗng
                if (!textArea.value.trim()) {
                    e.preventDefault();
                    alert('Vui lòng nhập câu tiếng Nhật cần kiểm tra');
                    textArea.focus();
                    return;
                }

                // Thêm loading state
                submitBtn.classList.add('loading');
                submitBtn.disabled = true;
            });

            // Auto-resize textarea
            const textarea = document.getElementById('text');
            textarea.addEventListener('input', function () {
                this.style.height = 'auto';
                this.style.height = Math.max(120, this.scrollHeight) + 'px';
            });

            // Fade in animation cho các elements
            window.addEventListener('load', function () {
                const elements = document.querySelectorAll('.fade-in');
                elements.forEach((el, index) => {
                    setTimeout(() => {
                        el.style.opacity = '1';
                        el.style.transform = 'translateY(0)';
                    }, index * 100);
                });
            });
        </script>
    </body>
</html>
