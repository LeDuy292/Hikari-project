<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liên hệ tư vấn - HIKARI JAPAN</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/contact.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
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
            max-width: 480px;
            margin: 64px auto 48px auto;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 6px 24px rgba(0, 0, 0, 0.08), 0 2px 8px rgba(0, 0, 0, 0.04);
            padding: 48px 40px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .contact-form-wrapper:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12), 0 3px 12px rgba(0, 0, 0, 0.06);
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
            margin-bottom: 24px;
            width: 100%;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
            font-size: 0.95rem;
            letter-spacing: 0.2px;
        }
        .input-icon {
            position: relative;
            width: 100%;
        }
        .input-icon input,
        .input-icon textarea {
            width: 100%;
            padding: 12px 16px 12px 48px;
            border-radius: 8px;
            border: 1px solid #ffe0b2;
            font-size: 1rem;
            background: #fff;
            transition: border-color 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        .input-icon input:focus,
        .input-icon textarea:focus {
            border-color: #e67e22;
            outline: none;
            background: #fff;
            box-shadow: 0 3px 12px rgba(230, 126, 34, 0.15);
        }
        .input-icon i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #e67e22;
            font-size: 1.2rem;
            transition: color 0.3s ease;
        }
        .contact-form button[type="submit"] {
            background: linear-gradient(90deg, #e67e22 0%, #f39c12 100%);
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 3px 12px rgba(230, 126, 34, 0.2);
            transition: background 0.3s ease, box-shadow 0.3s ease, transform 0.2s ease;
            width: 100%;
            margin-top: 12px;
            letter-spacing: 0.3px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .contact-form button[type="submit"]:hover {
            background: linear-gradient(90deg, #d35400 0%, #e67e22 100%);
            box-shadow: 0 5px 20px rgba(230, 126, 34, 0.3);
            transform: translateY(-2px);
        }
        .contact-form button[type="submit"]:active {
            transform: translateY(0);
            box-shadow: 0 2px 8px rgba(230, 126, 34, 0.2);
        }
        .contact-form textarea {
            min-height: 100px;
            resize: vertical;
        }
        .main-header {
            background: rgba(255, 245, 230, 0.9);
            box-shadow: 0 3px 16px rgba(230, 126, 34, 0.1);
            border-bottom-left-radius: 16px;
            border-bottom-right-radius: 16px;
            min-height: 80px;
            display: flex;
            justify-content: flex-end;
            padding: 0 24px;
            width: 300px;
            margin-left: auto;
            margin-bottom: 24px;
        }
        .main-header > div {
            gap: 24px;
        }
        .main-header .user-info {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(230, 126, 34, 0.1);
            padding: 8px 16px;
            font-weight: 500;
        }
        .fancy-title-wrapper {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 24px;
            margin-bottom: 12px;
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
        @media (max-width: 600px) {
            .contact-form-wrapper {
                padding: 24px 12px;
                max-width: 95vw;
                margin: 32px auto;
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
            .input-icon textarea {
                padding: 10px 14px 10px 42px;
                font-size: 0.95rem;
            }
            .contact-form button[type="submit"] {
                padding: 12px;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <div class="contact-form-wrapper">
        <form class="contact-form">
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
            <div class="form-group">
                <label for="name">Họ và tên:</label>
                <div class="input-icon">
                    <i class="fas fa-user"></i>
                    <input type="text" id="name" name="name" required placeholder="Nhập họ và tên">
                </div>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <div class="input-icon">
                    <i class="fas fa-envelope"></i>
                    <input type="email" id="email" name="email" required placeholder="Nhập email">
                </div>
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại:</label>
                <div class="input-icon">
                    <i class="fas fa-phone"></i>
                    <input type="tel" id="phone" name="phone" required pattern="[0-9]{10,11}" placeholder="Nhập số điện thoại">
                </div>
            </div>
            <div class="form-group">
                <label for="message">Nội dung:</label>
                <div class="input-icon">
                    <i class="fas fa-comment-dots"></i>
                    <textarea id="message" name="message" required rows="5" placeholder="Nhập nội dung cần tư vấn"></textarea>
                </div>
            </div>
            <button type="submit"><i class="fas fa-paper-plane"></i> Gửi liên hệ</button>
        </form>
    </div>
    <%@ include file="footer.jsp" %>
    <script>
        document.querySelector('.contact-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            // Basic validation
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            const phone = document.getElementById('phone').value;
            const message = document.getElementById('message').value;

            if (name && email && phone && message) {
                // Show success message
                alert('Đã gửi thành công! Cảm ơn bạn đã liên hệ.');
                // Optional: Reset form
                this.reset();
            } else {
                alert('Vui lòng điền đầy đủ thông tin!');
            }
        });
    </script>
</body>
</html>