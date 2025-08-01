<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Course, model.student.Roadmap, java.util.List" %>
<%
    Course course = (Course) request.getAttribute("course");
    List<Roadmap> roadmaps = (List<Roadmap>) request.getAttribute("roadmaps");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>HIKARI | <%= course != null ? course.getTitle() + " - Lộ Trình" : "Lộ Trình Khóa Học"%></title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/index.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" /> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/roadmap.css" />
    </head>
    <body class="bg-gradient-to-br from-gray-50 via-blue-50 to-indigo-50 font-sans">
        <div class="flex-container">
            <!-- Sidebar -->
            <jsp:include page="sidebar.jsp" />

            <!-- Main content - Full width như courseInfo.jsp -->
            <main class="flex-1 px-8 py-6 flex flex-col roadmap-container-wrapper" style="margin-left: 320px !important;">
                <!-- Header -->
                <jsp:include page="header.jsp" />

                <!-- Enhanced Hero Banner - Full Width -->
                <div class="hero-banner bg-gradient-to-br from-orange-500 via-orange-400 to-pink-400 rounded-3xl overflow-hidden shadow-2xl mb-8 mt-8 w-full-custom">
                    <div class="absolute inset-0 bg-black bg-opacity-10"></div>
                    <div class="relative z-10 p-8">
                        <div class="flex flex-col lg:flex-row items-center justify-between">
                            <div class="text-white mb-6 lg:mb-0 lg:w-3/5">
                                <div class="flex items-center mb-4">
                                    <div class="bg-white bg-opacity-20 rounded-full p-4 mr-6 float-animate">
                                        <i class="fas fa-map-marked-alt text-3xl text-white"></i>
                                    </div>
                                    <div>
                                        <h1 class="text-4xl lg:text-5xl font-bold mb-3 leading-tight">
                                            <%= course != null ? course.getTitle() : "Lộ Trình Khóa Học"%>
                                        </h1>
                                        <p class="text-white text-opacity-90 text-xl">Hành trình chinh phục kiến thức với lộ trình học tập được thiết kế khoa học và hiệu quả</p>
                                    </div>
                                </div>
                                <div class="flex flex-wrap gap-4 mt-8">
                                    <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                        <i class="fas fa-route mr-2"></i><%= roadmaps != null ? roadmaps.size() : 0%> Giai đoạn
                                    </span>
                                    <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                        <i class="fas fa-clock mr-2"></i>
                                        <% if (course != null) {%>
                                        <%= course.getDuration()%>
                                        <% } else { %>
                                        12 tuần
                                        <% }%>
                                    </span>
                                    <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                        <i class="fas fa-hands-helping mr-2"></i>100% Thực hành
                                    </span>
                                    <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                        <i class="fas fa-users mr-2"></i>Hỗ trợ 24/7
                                    </span>
                                </div>
                            </div>
                            <div class="lg:w-2/5 text-center">
                                <div class="bg-white bg-opacity-15 backdrop-blur-lg rounded-3xl p-8 border border-white border-opacity-20 pulse-animate">
                                    <div class="text-white text-4xl font-bold mb-3">
                                        <% if (course != null && course.getFee() > 0) { %>
                                        <i class="fas fa-money-bill-wave"></i>
                                        <% } else { %>
                                        <i class="fas fa-gift"></i>
                                        <% } %>
                                    </div>
                                    <h3 class="text-2xl font-bold text-white mb-2">
                                        <% if (course != null && course.getFee() > 0) { %>
                                        Đầu tư cho tương lai
                                        <% } else { %>
                                        Miễn phí
                                        <% } %>
                                    </h3>
                                    <p class="text-white text-opacity-90 text-lg">
                                        <% if (course != null && course.getFee() > 0) { %>
                                        Chỉ với <%= course.getFee() %> VNĐ
                                        <% } else { %>
                                        Đăng ký ngay để nhận lộ trình miễn phí
                                        <% } %>
                                    </p>
                                    <div class="mt-6">
                                        <a href="${pageContext.request.contextPath}/registerCourse?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" class="enhanced-button primary w-full">
                                            <i class="fas fa-check mr-2"></i>
                                            <% if (course != null && course.getFee() > 0) { %>
                                            Đăng ký ngay
                                            <% } else { %>
                                            Nhận lộ trình miễn phí
                                            <% } %>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Enhanced Decorative elements - Same as courseInfo -->
                    <div class="absolute top-10 right-10 w-32 h-32 bg-white bg-opacity-10 rounded-full blur-2xl float-animate"></div>
                    <div class="absolute bottom-10 left-10 w-24 h-24 bg-white bg-opacity-10 rounded-full blur-xl float-animate" style="animation-delay: -2s;"></div>
                    <div class="absolute top-1/2 right-1/4 w-16 h-16 bg-white bg-opacity-5 rounded-full blur-lg float-animate" style="animation-delay: -4s;"></div>
                </div>

                <!-- Enhanced Navigation Tabs - Full Width -->
                <div class="flex justify-center mb-10 w-full-custom">
                    <nav class="nav-tabs flex space-x-2">
                        <a href="${pageContext.request.contextPath}/courseInfo?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                           class="nav-tab">
                            <i class="fas fa-info-circle mr-2"></i>Thông tin khóa học
                        </a>
                        <a href="${pageContext.request.contextPath}/roadmap?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                           class="nav-tab active">
                            <i class="fas fa-route mr-2"></i>Lộ trình khóa học
                        </a>
                        <a href="${pageContext.request.contextPath}/commitments?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                           class="nav-tab">
                            <i class="fas fa-handshake mr-2"></i>Cam kết khóa học
                        </a>
                    </nav>
                </div>

                <!-- Enhanced Roadmap Content -->
                <div class="roadmap-wrapper max-w-6xl mx-auto mb-10 w-full-custom">
                    <div class="section-header text-center mb-12">
                        <h2 class="text-4xl font-bold bg-gradient-to-r from-orange-500 via-pink-500 to-red-500 bg-clip-text text-transparent mb-4">
                            Lộ Trình Học Tập Chi Tiết
                        </h2>
                        <p class="text-gray-600 text-lg max-w-2xl mx-auto">
                            Từng bước học tập được thiết kế khoa học, giúp bạn nắm vững kiến thức từ cơ bản đến nâng cao
                        </p>
                    </div>

                    <div class="roadmap-container">
                        <% 
                        if (roadmaps != null && !roadmaps.isEmpty()) {
                            for (int i = 0; i < roadmaps.size(); i++) {
                                Roadmap roadmap = roadmaps.get(i);
                                String positionClass = (i % 2 == 0) ? "roadmap-left" : "roadmap-right";
                        %>
                              <div class="roadmap-item <%= positionClass %>" data-index="<%= i %>">
                                  <div class="roadmap-step-number">
                                      <%= i + 1 %>
                                  </div>
                                  <div class="roadmap-card enhanced-card">
                                      <div class="roadmap-card-header mb-6">
                                          <div class="flex items-center justify-between">
                                              <h3 class="text-2xl font-bold text-gray-800 flex items-center">
                                                  <div class="roadmap-icon-wrapper mr-4">
                                                      <i class="fas fa-<%= getIconForStep(i + 1) %> text-orange-500 text-xl"></i>
                                                  </div>
                                                  <%= roadmap.getTitle() %>
                                              </h3>
                                              <div class="step-badge">
                                                  Bước <%= i + 1 %>
                                              </div>
                                          </div>
                                      </div>
                                      
                                      <div class="roadmap-card-content">
                                          <p class="text-gray-700 leading-relaxed mb-6 text-lg">
                                              <%= roadmap.getDescription() %>
                                          </p>
                                          
                                          <!-- Progress Bar -->
                                          <div class="progress-section mb-6">
                                              <div class="flex justify-between text-sm text-gray-600 mb-2">
                                                  <span>Tiến độ hoàn thành</span>
                                                  <span>0%</span>
                                              </div>
                                              <div class="progress-bar-container">
                                                  <div class="progress-bar" style="width: 0%"></div>
                                              </div>
                                          </div>
                                          
                                          <div class="roadmap-features">
                                              <span class="feature-tag">
                                                  <i class="fas fa-clock mr-2"></i>
                                                  <%= roadmap.getDuration() != null ? roadmap.getDuration() : "Chưa xác định" %>
                                              </span>
                                              <span class="feature-tag">
                                                  <i class="fas fa-star mr-2"></i>
                                                  <%= getDifficultyLevel(i + 1) %>
                                              </span>
                                              <span class="feature-tag">
                                                  <i class="fas fa-certificate mr-2"></i>
                                                  Hoàn thành
                                              </span>
                                              <span class="feature-tag">
                                                  <i class="fas fa-users mr-2"></i>
                                                  Hỗ trợ 24/7
                                              </span>
                                          </div>
                                      </div>
                                      
                                      <div class="roadmap-card-footer mt-8">
                                          <div class="flex flex-col sm:flex-row gap-4">
                                              <button class="enhanced-button primary flex-1">
                                                  <i class="fas fa-play mr-2"></i>
                                                  Bắt đầu học
                                              </button>
                                              <button class="enhanced-button secondary flex-1">
                                                  <i class="fas fa-eye mr-2"></i>
                                                  Xem chi tiết
                                              </button>
                                          </div>
                                      </div>
                                  </div>
                              </div>
                        <%
                            }
                        } else {
                        %>
                            <div class="no-data-state enhanced-card">
                                <div class="no-data-icon mb-8">
                                    <div class="bg-gradient-to-br from-orange-100 to-pink-100 rounded-full w-32 h-32 flex items-center justify-center mx-auto mb-6 float-animate">
                                        <i class="fas fa-route text-6xl text-orange-400"></i>
                                    </div>
                                </div>
                                <h3 class="text-3xl font-semibold text-gray-800 mb-4">Chưa có lộ trình</h3>
                                <p class="text-gray-600 mb-8 text-lg max-w-md mx-auto leading-relaxed">
                                    Lộ trình học tập chi tiết sẽ được cập nhật sớm nhất có thể. 
                                    Đăng ký nhận thông báo để không bỏ lỡ!
                                </p>
                                <div class="flex flex-col sm:flex-row gap-4 justify-center">
                                    <button class="enhanced-button primary">
                                        <i class="fas fa-bell mr-2"></i>Nhận thông báo
                                    </button>
                                    <a href="${pageContext.request.contextPath}/courses" class="enhanced-button secondary">
                                        <i class="fas fa-list mr-2"></i>Xem khóa học khác
                                    </a>
                                </div>
                            </div>
                        <%
                        }
                        %>
                    </div>
                </div>

                <!-- Enhanced Action Buttons - Same as courseInfo -->
                <div class="enhanced-card p-8 max-w-4xl mx-auto mb-10 w-full-custom">
                    <div class="text-center mb-8">
                        <div class="bg-gradient-to-br from-orange-400 to-pink-500 rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-4">
                            <i class="fas fa-rocket text-3xl text-white"></i>
                        </div>
                        <h3 class="text-3xl font-bold text-gray-800 mb-4">Sẵn sàng bắt đầu hành trình?</h3>
                        <p class="text-gray-600 text-lg">Theo dõi lộ trình chi tiết và đạt được mục tiêu của bạn</p>
                    </div>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <button class="enhanced-button primary register-course-btn">
                            <i class="fas fa-play mr-3"></i>Bắt đầu học ngay
                        </button>
                        <a href="${pageContext.request.contextPath}/courses" 
                           class="enhanced-button secondary">
                            <i class="fas fa-list mr-3"></i>Xem khóa học khác
                        </a>
                        <button class="enhanced-button tertiary">
                            <i class="fas fa-download mr-3"></i>Tải lộ trình PDF
                        </button>
                    </div>
                </div>

                <!-- Footer -->
                <jsp:include page="footer.jsp" />
            </main>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/student_js/roadmap.js"></script>
        <script>
        // Enhanced roadmap animations and interactions - Same as courseInfo functionality
            document.addEventListener('DOMContentLoaded', function () {
                // Course registration functionality (same as courseInfo.jsp)
                const courseId = '<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : ""%>';

                if (courseId) {
                    const registerButtons = document.querySelectorAll('.register-course-btn');
                    registerButtons.forEach(button => {
                        button.addEventListener('click', function(e) {
                            e.preventDefault();
                            // Add your registration logic here
                            console.log('Registering for course:', courseId);
                        });
                    });
                }

                // Roadmap animations
                const roadmapItems = document.querySelectorAll('.roadmap-item');
                const observerOptions = {
                    threshold: 0.1,
                    rootMargin: '0px 0px -50px 0px'
                };

                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('animate-in');
                            // Add staggered animation delay
                            const index = entry.target.dataset.index;
                            entry.target.style.animationDelay = `${index * 0.2}s`;
                        }
                    });
                }, observerOptions);

                roadmapItems.forEach(item => observer.observe(item));
            });
        </script>
    </body>
</html>

<%!
// Helper method for step icons
private String getIconForStep(int stepNumber) {
    String[] icons = {"play-circle", "book-open", "code", "project-diagram", "graduation-cap", "certificate", "trophy", "star"};
    if (stepNumber > 0 && stepNumber <= icons.length) {
        return icons[stepNumber - 1];
    }
    return "star";
}

// Helper method for difficulty levels
private String getDifficultyLevel(int stepNumber) {
    if (stepNumber <= 2) return "Cơ bản";
    if (stepNumber <= 4) return "Trung bình";
    if (stepNumber <= 6) return "Nâng cao";
    return "Chuyên sâu";
}
%>


