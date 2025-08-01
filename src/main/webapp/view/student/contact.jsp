<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ tư vấn - HIKARI JAPAN</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        /* Reset button styles to ensure our custom styles work */
        button, input[type="submit"], input[type="button"] {
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }
        
        * {
            box-sizing: border-box;
        }
        body {
            background: linear-gradient(145deg, #fff8e1 0%, #fff3e0 100%);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        .contact-form-wrapper {
            max-width: 600px;
            margin: 64px auto 48px auto;
            background: #ffffff;
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1), 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 48px 40px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .contact-form-wrapper::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #e67e22 0%, #f39c12 50%, #f1c40f 100%);
        }
        .contact-form-wrapper:hover {
            transform: translateY(-6px);
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.15), 0 6px 30px rgba(0, 0, 0, 0.08);
        }
        .contact-form h1 {
            text-align: center;
            color: #e67e22;
            margin-bottom: 16px;
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            letter-spacing: 0.8px;
        }
        .contact-form .desc {
            color: #555;
            margin-bottom: 32px;
            font-size: 1.1rem;
            text-align: center;
            line-height: 1.6;
        }
        .form-group {
            margin-bottom: 28px;
            width: 100%;
        }
        .form-group label {
            display: block;
            margin-bottom: 10px;
            color: #333;
            font-weight: 600;
            font-size: 0.95rem;
            letter-spacing: 0.2px;
            position: relative;
        }
        .form-group label::after {
            content: ' *';
            color: #e74c3c;
            font-weight: bold;
        }
        .input-icon {
            position: relative;
            width: 100%;
        }
        .input-icon input,
        .input-icon textarea,
        .input-icon select {
            width: 100%;
            padding: 16px 16px 16px 52px;
            border-radius: 12px;
            border: 2px solid #ffe0b2;
            font-size: 1rem;
            background: #fff;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            font-family: 'Inter', sans-serif;
        }
        .input-icon input:focus,
        .input-icon textarea:focus,
        .input-icon select:focus {
            border-color: #e67e22;
            outline: none;
            background: #fff;
            box-shadow: 0 4px 20px rgba(230, 126, 34, 0.15);
            transform: translateY(-1px);
        }
        .input-icon textarea {
            padding-left: 16px;
            min-height: 120px;
            resize: vertical;
        }
        .input-icon select {
            padding-left: 16px;
            cursor: pointer;
        }
        .input-icon i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #e67e22;
            font-size: 1.3rem;
            transition: all 0.3s ease;
            z-index: 2;
        }
        .input-icon:focus-within i {
            color: #d35400;
            transform: translateY(-50%) scale(1.1);
        }
        .contact-form button[type="submit"],
        .contact-form #submitBtn,
        button#submitBtn {
            background: linear-gradient(135deg, #ff6b35 0%, #f7931e 50%, #ffd23f 100%) !important;
            color: #fff !important;
            border: none !important;
            padding: 20px 40px !important;
            border-radius: 25px !important;
            font-size: 1.1rem !important;
            font-weight: 700 !important;
            cursor: pointer !important;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1) !important;
            width: 100% !important;
            display: flex !important;
            align-items: center !important;
            justify-content: center !important;
            gap: 12px !important;
            letter-spacing: 1px !important;
            text-transform: uppercase !important;
            font-family: 'Inter', sans-serif !important;
            position: relative !important;
            overflow: hidden !important;
            box-shadow: 0 8px 25px rgba(255, 107, 53, 0.3) !important;
            border: 2px solid rgba(255, 255, 255, 0.1) !important;
        }
        
        .contact-form button[type="submit"]::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s ease;
        }
        
        .contact-form button[type="submit"]:hover::before {
            left: 100%;
        }
        
        .contact-form button[type="submit"]:hover,
        .contact-form #submitBtn:hover,
        button#submitBtn:hover {
            background: linear-gradient(135deg, #e55a2b 0%, #e67e22 50%, #f39c12 100%) !important;
            transform: translateY(-2px) !important;
            box-shadow: 0 12px 35px rgba(255, 107, 53, 0.4) !important;
            letter-spacing: 1.2px !important;
        }
        
        .contact-form button[type="submit"]:active {
            transform: translateY(0);
            box-shadow: 0 6px 20px rgba(255, 107, 53, 0.3);
        }
        
        .contact-form button[type="submit"]:focus {
            outline: none;
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.3), 0 8px 25px rgba(255, 107, 53, 0.3);
        }
        
        .contact-form button[type="submit"]:disabled {
            background: linear-gradient(135deg, #bdc3c7 0%, #95a5a6 100%);
            cursor: not-allowed;
            transform: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .contact-form button[type="submit"] i {
            font-size: 1rem;
            transition: transform 0.3s ease;
        }
        
        .contact-form button[type="submit"]:hover i {
            transform: translateX(3px);
        }
        
        .contact-form button[type="submit"] span {
            font-weight: 700;
            letter-spacing: 1px;
        }
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            backdrop-filter: blur(4px);
        }
        .loading-spinner {
            width: 60px;
            height: 60px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid #e67e22;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 18px 24px;
            border-radius: 12px;
            color: #fff;
            font-weight: 600;
            z-index: 10000;
            transform: translateX(400px);
            transition: transform 0.3s ease;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            max-width: 400px;
        }
        .notification.show {
            transform: translateX(0);
        }
        .notification.success {
            background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
        }
        .notification.error {
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
        }
        .fancy-title-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 24px;
            margin-bottom: 16px;
        }
        .fancy-title {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            font-weight: 700;
            background: linear-gradient(90deg, #e67e22 30%, #f1c40f 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-fill-color: transparent;
            text-shadow: 1px 2px 8px rgba(230, 126, 34, 0.15);
            letter-spacing: 1px;
            padding: 0 10px;
        }
        .fancy-title-icon {
            color: #f39c12;
            font-size: 2.3rem;
            filter: drop-shadow(0 3px 8px rgba(243, 156, 18, 0.5));
        }
        .fancy-title-line {
            flex: 1;
            height: 4px;
            border-radius: 2px;
            background: linear-gradient(90deg, #f1c40f 0%, #e67e22 100%);
            opacity: 0.6;
            min-width: 40px;
        }
        .modern-title {
            font-family: 'Inter', sans-serif;
            font-size: 2.3rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: #e67e22;
            text-align: center;
            margin-bottom: 0.6rem;
        }
        .modern-title-underline {
            width: 80px;
            height: 5px;
            margin: 0 auto 24px auto;
            border-radius: 3px;
            background: linear-gradient(90deg, #e67e22 0%, #f1c40f 100%);
            opacity: 0.9;
        }
        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .form-header .subtitle {
            color: #666;
            font-size: 1rem;
            margin-top: 8px;
        }
        .field-hint {
            font-size: 0.85rem;
            color: #888;
            margin-top: 6px;
            font-style: italic;
        }
        .error-message {
            color: #e74c3c;
            font-size: 0.85rem;
            margin-top: 6px;
            display: none;
        }
        .success-message {
            color: #27ae60;
            font-size: 0.85rem;
            margin-top: 6px;
            display: none;
        }
        @media (max-width: 600px) {
            .contact-form-wrapper {
                padding: 32px 20px;
                max-width: 95vw;
                margin: 32px auto;
                border-radius: 16px;
            }
            .main-header {
                width: 100%;
                padding: 0 16px;
                min-height: 64px;
                justify-content: flex-end;
            }
            .contact-form h1 {
                font-size: 1.8rem;
            }
            .fancy-title {
                font-size: 2rem;
            }
            .fancy-title-icon {
                font-size: 1.5rem;
            }
            .modern-title {
                font-size: 1.6rem;
                letter-spacing: 1.5px;
            }
            .modern-title-underline {
                width: 50px;
                height: 4px;
            }
            .form-group label {
                font-size: 0.9rem;
            }
            .input-icon input,
            .input-icon textarea,
            .input-icon select {
                padding: 14px 14px 14px 48px;
                font-size: 0.95rem;
            }
            .input-icon textarea {
                padding-left: 14px;
            }
            .input-icon select {
                padding-left: 14px;
            }
            .contact-form button[type="submit"] {
                padding: 16px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner"></div>
    </div>
    
    <div class="contact-form-wrapper">
        <!-- Server-side messages -->
        <c:if test="${not empty success}">
            <div class="notification success show" style="position: static; margin-bottom: 20px;">
                <i class="fas fa-check-circle" style="margin-right: 8px;"></i>${success}
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="notification error show" style="position: static; margin-bottom: 20px;">
                <i class="fas fa-exclamation-circle" style="margin-right: 8px;"></i>${error}
            </div>
        </c:if>
        
        <form id="contactForm" method="post" action="${pageContext.request.contextPath}/contact">
            <div class="form-header">
                <div class="fancy-title-wrapper">
                    <span class="fancy-title-line"></span>
                    <i class="fas fa-headset fancy-title-icon"></i>
                    <span class="fancy-title">HIKARI JAPAN</span>
                    <i class="fas fa-headset fancy-title-icon"></i>
                    <span class="fancy-title-line"></span>
                </div>
                <div class="modern-title">Liên hệ tư vấn</div>
                <span class="modern-title-underline"></span>
                <div class="desc">Vui lòng điền thông tin để được hỗ trợ nhanh nhất!</div>
                <div class="subtitle">Chúng tôi sẽ phản hồi trong vòng 24 giờ</div>
            </div>
            
            <div class="form-group">
                <label for="name">Họ và tên</label>
                <div class="input-icon">
                    <i class="fas fa-user"></i>
                    <input type="text" id="name" name="name" required placeholder="Nhập họ và tên đầy đủ">
                </div>
                <div class="field-hint">Ví dụ: Nguyễn Văn A hoặc Nguyen Van A</div>
                <div class="error-message" id="nameError"></div>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <div class="input-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email" required placeholder="Nhập địa chỉ email">
                </div>
                <div class="field-hint">Ví dụ: example@gmail.com</div>
                <div class="error-message" id="emailError"></div>
            </div>
            
            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <div class="input-icon">
                    <i class="fas fa-phone"></i>
                    <input type="tel" id="phone" name="phone" required placeholder="Nhập số điện thoại">
                </div>
                <div class="field-hint">Ví dụ: 0901234567 hoặc 0123456789</div>
                <div class="error-message" id="phoneError"></div>
            </div>
            
            <div class="form-group">
                <label for="issueType">Tình trạng đang gặp phải</label>
                <div class="input-icon">
                    <i class="fas fa-exclamation-circle"></i>
                    <select id="issueType" name="issueType" required>
                        <option value="">Chọn tình trạng</option>
                        <option value="COURSE_ADVICE">🎓 Tôi cần tư vấn khóa học</option>
                        <option value="TECHNICAL_ISSUE">🔧 Tôi gặp lỗi kỹ thuật</option>
                        <option value="TUITION_SCHEDULE">💰 Tôi muốn hỏi về học phí/lịch học</option>
                        <option value="PAYMENT_SUPPORT">💳 Tôi cần hỗ trợ thanh toán</option>
                        <option value="OTHER">❓ Khác</option>
                    </select>
                </div>
                <div class="field-hint">Chọn loại yêu cầu phù hợp nhất</div>
                <div class="error-message" id="issueTypeError"></div>
            </div>
            
            <div class="form-group">
                <label for="message">Nội dung yêu cầu chi tiết</label>
                <div class="input-icon">
                    <textarea id="message" name="message" required rows="6" placeholder="Mô tả chi tiết yêu cầu của bạn..."></textarea>
                </div>
                <div class="field-hint">Tối thiểu 10 ký tự, tối đa 1000 ký tự</div>
                <div class="error-message" id="messageError"></div>
            </div>
            
            <button type="submit" id="submitBtn" style="background: linear-gradient(135deg, #ff6b35 0%, #f7931e 50%, #ffd23f 100%); color: #fff; border: none; padding: 20px 40px; border-radius: 25px; font-size: 1.1rem; font-weight: 700; cursor: pointer; width: 100%; display: flex; align-items: center; justify-content: center; gap: 12px; letter-spacing: 1px; text-transform: uppercase; font-family: 'Inter', sans-serif; box-shadow: 0 8px 25px rgba(255, 107, 53, 0.3);">
                <i class="fas fa-paper-plane"></i> 
                <span>GỬI YÊU CẦU</span>
            </button>
        </form>
    </div>
    
    <%@ include file="footer.jsp" %>
    
    <script>
        var contextPath = '${pageContext.request.contextPath}';
        
        // Show notification function
        function showNotification(message, type) {
            type = type || 'success';
            var notification = document.createElement('div');
            notification.className = 'notification ' + type;
            
            var iconClass = 'fas fa-check-circle';
            if (type === 'error') {
                iconClass = 'fas fa-exclamation-circle';
            }
            
            notification.innerHTML = '<i class="' + iconClass + '" style="margin-right: 8px;"></i>' + message;
            document.body.appendChild(notification);
            
            setTimeout(function() {
                notification.classList.add('show');
            }, 100);
            
            setTimeout(function() {
                notification.classList.remove('show');
                setTimeout(function() {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 300);
            }, 4000);
        }
        
        // Show/hide loading
        function showLoading() {
            document.getElementById('loadingOverlay').style.display = 'flex';
            document.getElementById('submitBtn').disabled = true;
        }
        
        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
            document.getElementById('submitBtn').disabled = false;
        }
        
        // Show field error
        function showFieldError(fieldId, message) {
            var errorElement = document.getElementById(fieldId + 'Error');
            if (errorElement) {
                errorElement.textContent = message;
                errorElement.style.display = 'block';
            }
        }
        
        // Hide field error
        function hideFieldError(fieldId) {
            var errorElement = document.getElementById(fieldId + 'Error');
            if (errorElement) {
                errorElement.style.display = 'none';
            }
        }
        
        // Form validation with better error handling
        function validateForm() {
            var isValid = true;
            var name = document.getElementById('name').value.trim();
            var email = document.getElementById('email').value.trim();
            var phone = document.getElementById('phone').value.trim();
            var issueType = document.getElementById('issueType').value;
            var message = document.getElementById('message').value.trim();
            
            // Clear all previous errors
            hideFieldError('name');
            hideFieldError('email');
            hideFieldError('phone');
            hideFieldError('issueType');
            hideFieldError('message');
            
            // Validate name
            if (!name) {
                showFieldError('name', 'Vui lòng nhập họ và tên!');
                isValid = false;
            } else if (name.length < 2) {
                showFieldError('name', 'Họ tên phải có ít nhất 2 ký tự!');
                isValid = false;
            } else if (name.length > 50) {
                showFieldError('name', 'Họ tên không được quá 50 ký tự!');
                isValid = false;
            }
            
            // Validate email
            if (!email) {
                showFieldError('email', 'Vui lòng nhập email!');
                isValid = false;
            } else {
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    showFieldError('email', 'Email không hợp lệ!');
                    isValid = false;
                }
            }
            
            // Validate phone
            if (!phone) {
                showFieldError('phone', 'Vui lòng nhập số điện thoại!');
                isValid = false;
            } else {
                // Clean phone number
                var cleanPhone = phone.replace(/[\s\-\(\)]/g, '');
                if (!/^0[3-9][0-9]{8}$/.test(cleanPhone)) {
                    showFieldError('phone', 'Số điện thoại không hợp lệ! Vui lòng nhập số Việt Nam (10-11 chữ số)');
                    isValid = false;
                }
            }
            
            // Validate issue type
            if (!issueType) {
                showFieldError('issueType', 'Vui lòng chọn loại yêu cầu!');
                isValid = false;
            }
            
            // Validate message
            if (!message) {
                showFieldError('message', 'Vui lòng nhập nội dung yêu cầu!');
                isValid = false;
            } else if (message.length < 10) {
                showFieldError('message', 'Nội dung phải có ít nhất 10 ký tự!');
                isValid = false;
            } else if (message.length > 1000) {
                showFieldError('message', 'Nội dung không được quá 1000 ký tự!');
                isValid = false;
            }
            
            return isValid;
        }
        
        // Form submission with better error handling
        document.getElementById('contactForm').addEventListener('submit', function(e) {
            // Clear any existing notifications first
            var existingNotifications = document.querySelectorAll('.notification');
            existingNotifications.forEach(function(notification) {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            });
            
            if (!validateForm()) {
                e.preventDefault();
                showNotification('Vui lòng kiểm tra lại thông tin!', 'error');
                return false;
            }
            
            // Show loading
            showLoading();
            
            // Let the form submit naturally
            // The form will redirect to the servlet and we'll handle the response
            return true;
        });
        
        // Real-time validation with better UX
        document.getElementById('name').addEventListener('blur', function() {
            var name = this.value.trim();
            if (name) {
                if (name.length < 2) {
                    this.style.borderColor = '#e74c3c';
                } else if (name.length > 50) {
                    this.style.borderColor = '#e74c3c';
                } else {
                    this.style.borderColor = '#27ae60';
                }
            } else {
                this.style.borderColor = '#ffe0b2';
            }
        });
        
        document.getElementById('email').addEventListener('blur', function() {
            var email = this.value.trim();
            if (email) {
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    this.style.borderColor = '#e74c3c';
                } else {
                    this.style.borderColor = '#27ae60';
                }
            } else {
                this.style.borderColor = '#ffe0b2';
            }
        });
        
        document.getElementById('phone').addEventListener('blur', function() {
            var phone = this.value.trim();
            if (phone) {
                var cleanPhone = phone.replace(/[\s\-\(\)]/g, '');
                if (!/^0[3-9][0-9]{8}$/.test(cleanPhone)) {
                    this.style.borderColor = '#e74c3c';
                } else {
                    this.style.borderColor = '#27ae60';
                }
            } else {
                this.style.borderColor = '#ffe0b2';
            }
        });
        
        document.getElementById('message').addEventListener('blur', function() {
            var message = this.value.trim();
            if (message) {
                if (message.length < 10) {
                    this.style.borderColor = '#e74c3c';
                } else if (message.length > 1000) {
                    this.style.borderColor = '#e74c3c';
                } else {
                    this.style.borderColor = '#27ae60';
                }
            } else {
                this.style.borderColor = '#ffe0b2';
            }
        });
        
        // Reset border colors on focus
        document.querySelectorAll('.input-icon input, .input-icon textarea, .input-icon select').forEach(function(element) {
            element.addEventListener('focus', function() {
                this.style.borderColor = '#e67e22';
            });
        });
    </script>
</body>
</html>
