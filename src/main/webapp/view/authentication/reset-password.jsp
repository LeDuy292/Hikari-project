<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Cập nhật mật khẩu - Học Tiếng Nhật Online</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
    <link href="${pageContext.request.contextPath}/assets/css/main-login.css" rel="stylesheet" />
    <style>
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            font-size: 14px;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="bg-decor">
        <span>🌸</span>
        <span>⛩️</span>
        <span>🎌</span>
        <span>🗻</span>
    </div>
    <div class="auth-wrapper">
        <div class="auth-side">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" class="logo-img" />
            <div class="logo">HiKARI</div>
            <div class="slogan">
                <b>"Cập nhật mật khẩu mới!"</b><br />
                <span>Vui lòng đặt mật khẩu mới cho tài khoản của bạn.</span>
            </div>
            <div class="quote">
                <div class="japanese">七転び八起き</div>
                <div class="romaji">Nanakorobi yaoki</div>
                <div class="vi">"Ngã bảy lần, đứng dậy tám lần"</div>
            </div>
            <div class="stats">
                <div class="stat">
                    Bảo mật<br /><span style="font-size: 0.9em; font-weight: 400">Cao</span>
                </div>
                <div class="stat">
                    Nhanh chóng<br /><span style="font-size: 0.9em; font-weight: 400">Cập nhật</span>
                </div>
                <div class="stat">
                    24/7<br /><span style="font-size: 0.9em; font-weight: 400">Hỗ trợ</span>
                </div>
            </div>
        </div>
        
        <div class="auth-form-section">
            <div class="auth-form-container">
                <% 
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                    
                    // FIX: Handle both String and Integer types from session
                    Object resetUserNumObj = session.getAttribute("resetUserNum");
                    String resetUserNum = null;
                    
                    if (resetUserNumObj instanceof Integer) {
                        resetUserNum = ((Integer) resetUserNumObj).toString();
                    } else if (resetUserNumObj instanceof String) {
                        resetUserNum = (String) resetUserNumObj;
                    }
                    
                    if (resetUserNum == null) {
                        response.sendRedirect(request.getContextPath() + "/view/authentication/forgot-password.jsp");
                        return;
                    }
                %>
                
                <div class="form-title">Cập nhật mật khẩu</div>
                <div class="form-desc">
                    Vui lòng nhập mật khẩu mới cho tài khoản của bạn.
                </div>
                
                <% if (error != null) { %>
                    <div class="error-message"><%= error %></div>
                <% } %>
                
                <% if (success != null) { %>
                    <div class="success-message"><%= success %></div>
                <% } %>
                
                <form id="resetForm" action="${pageContext.request.contextPath}/reset-password" method="post" onsubmit="return validateResetForm()">
                    <!-- FIX: Use consistent parameter name -->
                    <input type="hidden" name="userNum" value="<%= resetUserNum %>" />
                    <div class="form-group">
                        <label class="form-label" for="newPassword">Mật khẩu mới</label>
                        <div class="input-wrapper">
                            <i class="fa fa-lock input-icon"></i>
                            <input
                                class="input"
                                id="newPassword"
                                name="newPassword"
                                type="password"
                                placeholder="Nhập mật khẩu mới"
                                required
                                minlength="6"
                                pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                                title="Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ và số"
                            />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Xác nhận mật khẩu</label>
                        <div class="input-wrapper">
                            <i class="fa fa-lock input-icon"></i>
                            <input
                                class="input"
                                id="confirmPassword"
                                name="confirmPassword"
                                type="password"
                                placeholder="Xác nhận mật khẩu mới"
                                required
                                minlength="6"
                                pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$"
                                title="Mật khẩu phải có ít nhất 6 ký tự, bao gồm chữ và số"
                            />
                        </div>
                    </div>
                    
                    <button type="submit" class="submit-btn" id="submitBtn">
                        Cập nhật mật khẩu
                    </button>
                    
                    <div class="switch-form">
                        <span>Có vấn đề?</span>
                        <a href="${pageContext.request.contextPath}/view/authentication/forgot-password.jsp" class="switch-link">
                            Yêu cầu lại mã OTP
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        function validateResetForm() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const submitBtn = document.getElementById('submitBtn');

            if (newPassword.trim() === '') {
                alert('Vui lòng nhập mật khẩu mới.');
                return false;
            }

            if (confirmPassword.trim() === '') {
                alert('Vui lòng xác nhận mật khẩu.');
                return false;
            }

            if (newPassword !== confirmPassword) {
                alert('Mật khẩu xác nhận không khớp.');
                return false;
            }

            if (newPassword.length < 6) {
                alert('Mật khẩu phải có ít nhất 6 ký tự.');
                return false;
            }

            // Check if password contains both letters and numbers
            const hasLetter = /[A-Za-z]/.test(newPassword);
            const hasNumber = /\d/.test(newPassword);
            
            if (!hasLetter || !hasNumber) {
                alert('Mật khẩu phải chứa ít nhất một chữ cái và một số.');
                return false;
            }

            submitBtn.innerHTML = 'Đang xử lý...';
            submitBtn.disabled = true;
            return true;
        }

        window.onload = function() {
            const submitBtn = document.getElementById('submitBtn');
            // Reset button state on page load
            submitBtn.innerHTML = 'Cập nhật mật khẩu';
            submitBtn.disabled = false;
        };
    </script>
</body>
</html>
