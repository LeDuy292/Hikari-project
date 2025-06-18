<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quên mật khẩu - Học Tiếng Nhật Online</title>
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

        .otp-form, .email-form {
            display: none;
        }

        .step-indicator {
            text-align: center;
            margin-bottom: 20px;
            font-size: 14px;
            color: #666;
        }

        .active-step {
            font-weight: bold;
            color: #ff835d;
        }

        .otp-note {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
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
        <!-- Side Inspiration -->
        <div class="auth-side">
            <img src="${pageContext.request.contextPath}/assets/img/logo.png" alt="Logo" class="logo-img" />
            <div class="logo">HiKARI</div>
            <div class="slogan">
                <b>"Khôi phục tài khoản của bạn!"</b><br />
                <span>Đừng lo lắng, chúng tôi sẽ giúp bạn lấy lại mật khẩu.</span>
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
                    Nhanh chóng<br /><span style="font-size: 0.9em; font-weight: 400">Khôi phục</span>
                </div>
                <div class="stat">
                    24/7<br /><span style="font-size: 0.9em; font-weight: 400">Hỗ trợ</span>
                </div>
            </div>
        </div>

        <!-- Form Section -->
        <div class="auth-form-section">
            <div class="auth-form-container">
                <% 
                    String error = (String) request.getAttribute("error");
                    String success = (String) request.getAttribute("success");
                    String email = (String) request.getAttribute("email");
                    boolean otpSent = success != null && success.contains("Mã OTP đã được gửi");
                %>

                <div class="form-title">Quên mật khẩu</div>
                <div class="step-indicator">
                    Bước <%= otpSent ? "2: Nhập mã OTP" : "1: Nhập email" %> <span class="active-step"><%= otpSent ? "✔" : "●" %></span>
                </div>
                <div class="form-desc">
                    <%= otpSent 
                        ? "Vui lòng nhập mã OTP đã được gửi đến " + (email != null ? email : "") + " để tiếp tục."
                        : "Nhập email của bạn và chúng tôi sẽ gửi mã OTP để reset mật khẩu." %>
                </div>

                <% if (error != null) { %>
                    <div class="error-message"><%= error %></div>
                <% } %>

                <% if (success != null) { %>
                    <div class="success-message"><%= success %></div>
                <% } %>

                <!-- Form nhập email -->
                <form id="emailForm" class="email-form" action="${pageContext.request.contextPath}/forgot-password" method="post" style="display: ${otpSent ? 'none' : 'block'}">
                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <div class="input-wrapper">
                            <i class="fa fa-envelope input-icon"></i>
                            <input
                                class="input"
                                id="email"
                                name="email"
                                type="email"
                                placeholder="Nhập email của bạn"
                                value="${email}"
                                required
                                />
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">
                        Gửi mã OTP
                    </button>
                </form>

                <!-- Form nhập OTP -->
                <form id="otpForm" class="otp-form" action="${pageContext.request.contextPath}/forgot-password" method="post" style="display: ${otpSent ? 'block' : 'none'}" onsubmit="return validateOtpForm()">
                    <input type="hidden" name="email" value="${email}" />
                    <div class="form-group">
                        <label class="form-label" for="otp">Mã OTP</label>
                        <div class="input-wrapper">
                            <i class="fa fa-key input-icon"></i>
                            <input
                                class="input"
                                id="otp"
                                name="otp"
                                type="text"
                                placeholder="Nhập mã OTP"
                                required
                                maxlength="6"
                                pattern="[0-9]{6}"
                                title="Mã OTP phải là 6 chữ số"
                                />
                        </div>
                        <div class="otp-note">Mã OTP có hiệu lực trong 10 phút.</div>
                    </div>

                    <button type="submit" class="submit-btn">
                        Xác nhận OTP
                    </button>
                </form>

                <div class="switch-form">
                    <span>Nhớ ra mật khẩu?</span>
                    <a href="${pageContext.request.contextPath}/view/login.jsp?formType=login" class="switch-link">
                        Đăng nhập
                    </a>
                </div>
                <div class="switch-form" id="resendOtp" style="display: ${otpSent ? 'block' : 'none'}">
                    <span>Không nhận được mã? </span>
                    <a href="javascript:void(0)" onclick="resendOtp()" class="switch-link">Gửi lại OTP</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validateOtpForm() {
            const otpInput = document.getElementById('otp');
            otpInput.value = otpInput.value.trim();
            if (!/^\d{6}$/.test(otpInput.value)) {
                alert('Mã OTP phải là 6 chữ số.');
                return false;
            }
            return true;
        }

        window.onload = function() {
            const successMessage = '${success != null ? success : ""}';
            const errorMessage = '${error != null ? error : ""}';
            const emailForm = document.getElementById('emailForm');
            const otpForm = document.getElementById('otpForm');

            if (successMessage.includes("Mã OTP đã được gửi") || errorMessage.includes("Mã OTP không hợp lệ")) {
                emailForm.style.display = 'none';
                otpForm.style.display = 'block';
            }
        };

        function resendOtp() {
            const emailForm = document.getElementById('emailForm');
            emailForm.submit();
        }
    </script>
</body>
</html>