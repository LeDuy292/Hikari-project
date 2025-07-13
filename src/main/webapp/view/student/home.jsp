
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>HIKARI JAPAN - Học tiếng Nhật chuyên nghiệp</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@400;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/home.css">
    </head>
    <body>
        <!-- Include Sidebar -->
        <%@ include file="sidebar.jsp" %>

        <div class="main-container">
            <!-- Include Header -->
            <%@ include file="header.jsp" %>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Hero Section -->
                <section class="hero-section">
                    <div class="hero-content">
                        <div class="hero-text">
                            <h1 class="hero-title">
                                Chinh phục <span class="highlight">tiếng Nhật</span><br>
                                cùng HIKARI JAPAN
                            </h1>
                            <p class="hero-description">
                                Nền tảng học tiếng Nhật hàng đầu với phương pháp giảng dạy hiện đại, 
                                giúp bạn nắm vững ngôn ngữ và văn hóa Nhật Bản một cách hiệu quả nhất.
                            </p>
                            <div class="hero-buttons">
                                <button class="btn-primary" onclick="startLearning()">
                                    <i class="fas fa-play"></i>
                                    Bắt đầu học ngay
                                </button>
                                <button class="btn-secondary" onclick="viewCourses()">
                                    <i class="fas fa-book-open"></i>
                                    Xem khóa học
                                </button>
                            </div>
                            <div class="hero-stats">
                                <div class="stat-item">
                                    <span class="stat-number">10,000+</span>
                                    <span class="stat-label">Học viên</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-number">50+</span>
                                    <span class="stat-label">Khóa học</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-number">98%</span>
                                    <span class="stat-label">Hài lòng</span>
                                </div>
                            </div>
                        </div>
                        <div class="hero-image">
                            <div class="hero-card">
                                <img src="${pageContext.request.contextPath}/assets/img/img_student/course.jpg" alt="Học tiếng Nhật" class="hero-img">
                                <div class="floating-elements">
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Features Section -->
                <section class="features-section">
                    <div class="section-header">
                        <h2 class="section-title">Tại sao chọn HIKARI JAPAN?</h2>
                        <p class="section-subtitle">Những ưu điểm vượt trội giúp bạn học tiếng Nhật hiệu quả</p>
                    </div>
                    <div class="features-grid">
                        <div class="feature-card" data-aos="fade-up" data-aos-delay="100">
                            <div class="feature-icon">
                                <i class="fas fa-chalkboard-teacher"></i>
                            </div>
                            <h3 class="feature-title">Giảng viên chuyên nghiệp</h3>
                            <p class="feature-description">Đội ngũ giảng viên người Nhật và Việt Nam có kinh nghiệm giảng dạy lâu năm</p>
                        </div>
                        <div class="feature-card" data-aos="fade-up" data-aos-delay="200">
                            <div class="feature-icon">
                                <i class="fas fa-laptop-code"></i>
                            </div>
                            <h3 class="feature-title">Học online linh hoạt</h3>
                            <p class="feature-description">Học mọi lúc, mọi nơi với nền tảng học trực tuyến hiện đại và thân thiện</p>
                        </div>
                        <div class="feature-card" data-aos="fade-up" data-aos-delay="300">
                            <div class="feature-icon">
                                <i class="fas fa-certificate"></i>
                            </div>
                            <h3 class="feature-title">Chứng chỉ uy tín</h3>
                            <p class="feature-description">Cấp chứng chỉ hoàn thành khóa học được công nhận rộng rãi</p>
                        </div>
                        <div class="feature-card" data-aos="fade-up" data-aos-delay="400">
                            <div class="feature-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <h3 class="feature-title">Cộng đồng học tập</h3>
                            <p class="feature-description">Tham gia cộng đồng học viên năng động, hỗ trợ lẫn nhau trong quá trình học</p>
                        </div>
                        <div class="feature-card" data-aos="fade-up" data-aos-delay="500">
                            <div class="feature-icon">
                                <i class="fas fa-book-reader"></i>
                            </div>
                            <h3 class="feature-title">Tài liệu phong phú</h3>
                            <p class="feature-description">Kho tài liệu học tập đa dạng từ cơ bản đến nâng cao, cập nhật liên tục</p>
                        </div>
                        <div class="feature-card" data-aos="fade-up" data-aos-delay="600">
                            <div class="feature-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <h3 class="feature-title">Theo dõi tiến độ</h3>
                            <p class="feature-description">Hệ thống theo dõi học tập chi tiết giúp bạn nắm rõ tiến độ và kết quả học tập</p>
                        </div>
                    </div>
                </section>

                <!-- Courses Section -->
                <section class="courses-section">
                    <div class="section-header">
                        <h2 class="section-title">Khóa học nổi bật</h2>
                        <p class="section-subtitle">Lựa chọn khóa học phù hợp với trình độ của bạn</p>
                    </div>
                    <div class="courses-grid">
                        <div class="course-card" data-aos="fade-up" data-aos-delay="100">
                            <div class="course-image">
                                <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N5.jpg" alt="Khóa học N5">
                                <div class="course-level">N5</div>
                            </div>
                            <div class="course-content">
                                <h3 class="course-title">Tiếng Nhật cơ bản N5</h3>
                                <p class="course-description">Khóa học dành cho người mới bắt đầu, học từ con số 0</p>
                                <div class="course-meta">
                                    <span class="course-duration"><i class="fas fa-clock"></i> 3 tháng</span>
                                    <span class="course-students"><i class="fas fa-users"></i> 1,234 học viên</span>
                                </div>
                                <div class="course-price">
                                    <span class="price-current">1,500,000đ</span>
                                    <span class="price-old">2,000,000đ</span>
                                </div>
                            </div>
                        </div>
                        <div class="course-card" data-aos="fade-up" data-aos-delay="200">
                            <div class="course-image">
                                <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N4.jpg" alt="Khóa học N4">
                                <div class="course-level">N4</div>
                            </div>
                            <div class="course-content">
                                <h3 class="course-title">Tiếng Nhật trung cấp N4</h3>
                                <p class="course-description">Nâng cao kỹ năng giao tiếp và ngữ pháp tiếng Nhật</p>
                                <div class="course-meta">
                                    <span class="course-duration"><i class="fas fa-clock"></i> 4 tháng</span>
                                    <span class="course-students"><i class="fas fa-users"></i> 856 học viên</span>
                                </div>
                                <div class="course-price">
                                    <span class="price-current">2,000,000đ</span>
                                    <span class="price-old">2,500,000đ</span>
                                </div>
                            </div>
                        </div>
                        <div class="course-card" data-aos="fade-up" data-aos-delay="300">
                            <div class="course-image">
                                <img src="${pageContext.request.contextPath}/assets/img/courses/Japanese-N3.png" alt="Khóa học N3">
                                <div class="course-level">N3</div>
                            </div>
                            <div class="course-content">
                                <h3 class="course-title">Tiếng Nhật nâng cao N3</h3>
                                <p class="course-description">Chuẩn bị cho kỳ thi JLPT N3 với độ chính xác cao</p>
                                <div class="course-meta">
                                    <span class="course-duration"><i class="fas fa-clock"></i> 5 tháng</span>
                                    <span class="course-students"><i class="fas fa-users"></i> 642 học viên</span>
                                </div>
                                <div class="course-price">
                                    <span class="price-current">2,500,000đ</span>
                                    <span class="price-old">3,000,000đ</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="section-footer">
                        <button class="btn-outline" onclick="viewAllCourses()">
                            Xem tất cả khóa học
                            <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </section>

                <!-- Testimonials Section -->
                <section class="testimonials-section">
                    <div class="section-header">
                        <h2 class="section-title">Học viên nói gì về chúng tôi</h2>
                        <p class="section-subtitle">Những phản hồi tích cực từ học viên HIKARI JAPAN</p>
                    </div>
                    <div class="testimonials-grid">
                        <div class="testimonial-card" data-aos="fade-up" data-aos-delay="100">
                            <div class="testimonial-content">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <p class="testimonial-text">"Tôi đã học được rất nhiều từ HIKARI JAPAN. Phương pháp giảng dạy rất dễ hiểu và thực tế. Sau 6 tháng học, tôi đã có thể giao tiếp cơ bản bằng tiếng Nhật."</p>
                            </div>
                            <div class="testimonial-author">
                                <div class="author-avatar">
                                    <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Nguyễn Văn A">
                                </div>
                                <div class="author-info">
                                    <h4 class="author-name">Nguyễn Văn A</h4>
                                    <p class="author-title">Học viên khóa N4</p>
                                </div>
                            </div>
                        </div>
                        <div class="testimonial-card" data-aos="fade-up" data-aos-delay="200">
                            <div class="testimonial-content">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <p class="testimonial-text">"Giảng viên rất nhiệt tình và chuyên nghiệp. Tài liệu học tập phong phú và được cập nhật thường xuyên. Tôi rất hài lòng với chất lượng giảng dạy."</p>
                            </div>
                            <div class="testimonial-author">
                                <div class="author-avatar">
                                    <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Trần Thị B">
                                </div>
                                <div class="author-info">
                                    <h4 class="author-name">Trần Thị B</h4>
                                    <p class="author-title">Học viên khóa N3</p>
                                </div>
                            </div>
                        </div>
                        <div class="testimonial-card" data-aos="fade-up" data-aos-delay="300">
                            <div class="testimonial-content">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <p class="testimonial-text">"Nền tảng học trực tuyến rất tiện lợi, tôi có thể học mọi lúc mọi nơi. Hệ thống bài tập và kiểm tra giúp tôi theo dõi tiến độ học tập một cách hiệu quả."</p>
                            </div>
                            <div class="testimonial-author">
                                <div class="author-avatar">
                                    <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Lê Văn C">
                                </div>
                                <div class="author-info">
                                    <h4 class="author-name">Lê Văn C</h4>
                                    <p class="author-title">Học viên khóa N2</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- CTA Section -->
                <section class="cta-section">
                    <div class="cta-content">
                        <h2 class="cta-title">Sẵn sàng bắt đầu hành trình học tiếng Nhật?</h2>
                        <p class="cta-description">Tham gia cùng hàng nghìn học viên đã thành công với HIKARI JAPAN</p>
                        <div class="cta-buttons">
                            <button class="btn-primary" onclick="registerNow()">
                                <i class="fas fa-rocket"></i>
                                Đăng ký ngay
                            </button>
                            <button class="btn-outline" onclick="contactUs()">
                                <i class="fas fa-phone"></i>
                                Liên hệ tư vấn
                            </button>
                            <button class="btn-secondary" onclick="applyCV()">
                                <i class="fas fa-file-upload"></i>
                                Apply CV
                            </button>
                        </div>
                    </div>
                </section>
            </main>

            <!-- Include Footer -->
            <%@ include file="footer.jsp" %>
        </div>

        <!-- Scripts -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/student_js/home.js"></script>
        <script>
           function applyCV() {
          window.location.href = "${pageContext.request.contextPath}/cv"; 
             }
        </script>
    </body>
</html>
