<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CV Submission Closed - HIKARI JAPAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/coordinator_css/cv-closed.css">
</head>
<body>
    <div class="main-container">
        <div class="main-content">
            <!-- Hero Section -->
            <section class="hero-section fade-in-up">
                <div class="hero-content">
                    <div class="hero-text">
                        <h1 class="hero-title">
                            Hiện tại không nhận <span class="highlight">CV</span>
                        </h1>
                        <p class="hero-description">
                            HIKARI JAPAN hiện không nhận CV trong giai đoạn này. Vui lòng theo dõi thông báo để biết khi nào chúng tôi mở lại hệ thống nộp CV.
                        </p>
                        <div class="hero-buttons">
                            <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="btn-primary">
                                Quay lại trang chủ
                            </a>
                            <a href="${pageContext.request.contextPath}/contact" class="btn-outline">
                                Liên hệ tư vấn
                            </a>
                        </div>
                    </div>
                    <div class="hero-image">
                        <div class="hero-card">
                            <img src="${pageContext.request.contextPath}/assets/img/backgroundLogin.png" alt="HIKARI JAPAN" class="hero-img">
                            <div class="floating-elements">
                                <div class="floating-card card-1">
                                    <i class="fas fa-bell"></i> Theo dõi thông báo
                                </div>
                                <div class="floating-card card-2">
                                    <i class="fas fa-info-circle"></i> Cập nhật sớm
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Why Choose HIKARI JAPAN Section -->
            <section class="features-section fade-in-up">
                <div class="section-header">
                    <h2 class="section-title">Tại sao chọn HIKARI JAPAN?</h2>
                    <p class="section-subtitle">Những ưu điểm vượt trội giúp bạn học tiếng Nhật hiệu quả</p>
                </div>
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                        <h3 class="feature-title">Giảng viên chuyên nghiệp</h3>
                        <p class="feature-description">Đội ngũ giảng viên người Nhật và Việt Nam có kinh nghiệm giảng dạy lâu năm.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-laptop"></i></div>
                        <h3 class="feature-title">Học online linh hoạt</h3>
                        <p class="feature-description">Học mọi lúc, mọi nơi với nền tảng học trực tuyến hiện đại và thân thiện.</p>
                    </div>
                    <div class="feature-card">
                        <div class="feature-icon"><i class="fas fa-certificate"></i></div>
                        <h3 class="feature-title">Chứng chỉ uy tín</h3>
                        <p class="feature-description">Cấp chứng chỉ hoàn thành khóa học được công nhận rộng rãi.</p>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <!-- Font Awesome for icons -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</body>
</html>