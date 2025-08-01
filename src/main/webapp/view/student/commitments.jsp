<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Course, model.student.Commitment, java.util.List" %>
<%
Course course = (Course) request.getAttribute("course");
List<Commitment> commitments = (List<Commitment>) request.getAttribute("commitments");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>HIKARI | <%= course != null ? course.getTitle() + " - Cam Kết" : "Cam Kết Khóa Học" %></title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" />
  <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/index.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/commitments.css" />
</head>
<body class="bg-gradient-to-br from-gray-50 via-blue-50 to-indigo-50 font-sans">
  <div class="flex-container">
      <!-- Sidebar -->
      <jsp:include page="sidebar.jsp" />

      <!-- Main content - Same structure as courseInfo.jsp -->
      <main class="flex-1 px-8 py-6 flex flex-col commitments-container-wrapper" style="margin-left: 320px !important;">
          <!-- Header -->
          <jsp:include page="header.jsp" />

          <!-- Enhanced Hero Banner - Same style as courseInfo -->
          <div class="hero-banner bg-gradient-to-br from-green-400 via-blue-500 to-purple-600 rounded-3xl overflow-hidden shadow-2xl mb-8 mt-8 w-full-custom">
              <div class="absolute inset-0 bg-opacity-10"></div>
              <div class="relative z-10 p-8">
                  <div class="flex flex-col lg:flex-row items-center justify-between">
                      <div class="text-white mb-6 lg:mb-0 lg:w-3/5">
                          <div class="flex items-center mb-4">
                              <div class="bg-white bg-opacity-20 rounded-full p-4 mr-6 float-animate">
                                  <i class="fas fa-handshake text-3xl text-white"></i>
                              </div>
                              <div>
                                  <h1 class="text-4xl font-bold mb-2">
                                      <%= course != null ? course.getTitle() : "Cam Kết Khóa Học" %>
                                  </h1>
                                  <p class="text-lg opacity-90">Những cam kết chất lượng và dịch vụ đẳng cấp</p>
                              </div>
                          </div>
                          <div class="flex flex-wrap gap-4 mt-8">
                              <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                  <i class="fas fa-shield-alt mr-2"></i>Đảm bảo chất lượng
                              </span>
                              <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                  <i class="fas fa-medal mr-2"></i>Cam kết kết quả
                              </span>
                              <span class="bg-white bg-opacity-20 px-6 py-3 rounded-full text-sm font-medium backdrop-blur-sm border border-white border-opacity-20">
                                  <i class="fas fa-headset mr-2"></i>Hỗ trợ 24/7
                              </span>
                          </div>
                      </div>
                      <div class="lg:w-2/5 text-center">
                          <div class="bg-white bg-opacity-15 backdrop-blur-lg rounded-3xl p-8 border border-white border-opacity-20 pulse-animate">
                              <div class="text-6xl mb-4">🤝</div>
                              <h3 class="text-2xl font-bold mb-2">Cam Kết Chất Lượng</h3>
                              <p class="text-lg opacity-90">Đảm bảo trải nghiệm tốt nhất</p>
                          </div>
                      </div>
                  </div>
              </div>
              <!-- Enhanced Decorative elements - Same as courseInfo -->
              <div class="absolute top-10 right-10 w-32 h-32 bg-white bg-opacity-10 rounded-full blur-2xl float-animate"></div>
              <div class="absolute bottom-10 left-10 w-24 h-24 bg-white bg-opacity-10 rounded-full blur-xl float-animate" style="animation-delay: -2s;"></div>
              <div class="absolute top-1/2 right-1/4 w-16 h-16 bg-white bg-opacity-5 rounded-full blur-lg float-animate" style="animation-delay: -4s;"></div>
          </div>

          <!-- Enhanced Navigation Tabs - Same as courseInfo -->
          <div class="flex justify-center mb-10 w-full-custom">
              <nav class="nav-tabs flex space-x-2">
                  <a href="${pageContext.request.contextPath}/courseInfo?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                     class="nav-tab">
                     <i class="fas fa-info-circle"></i>
                     <span>Thông tin khóa học</span>
                  </a>
                  <a href="${pageContext.request.contextPath}/roadmap?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                     class="nav-tab">
                     <i class="fas fa-route"></i>
                     <span>Lộ trình khóa học</span>
                  </a>
                  <a href="${pageContext.request.contextPath}/commitments?id=<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "CO001" %>" 
                     class="nav-tab active">
                     <i class="fas fa-handshake"></i>
                     <span>Cam kết khóa học</span>
                  </a>
              </nav>
          </div>

          <!-- Enhanced Commitments Content -->
          <div class="commitments-wrapper max-w-6xl mx-auto mb-10 w-full-custom">
              <div class="section-header text-center mb-12">
                  <h2 class="text-4xl font-bold bg-gradient-to-r from-green-500 via-blue-500 to-purple-600 bg-clip-text text-transparent mb-4">
                      Cam Kết Của Chúng Tôi
                  </h2>
                  <p class="text-gray-600 text-lg max-w-2xl mx-auto">
                      Những lời cam kết thiết thực và có trách nhiệm để đảm bảo trải nghiệm học tập tốt nhất cho bạn
                  </p>
              </div>

              <div class="commitments-grid">
                  <% 
                  if (commitments != null && !commitments.isEmpty()) {
                      for (int i = 0; i < commitments.size(); i++) {
                          Commitment commitment = commitments.get(i);
                  %>
                        <div class="commitment-card enhanced-card" data-index="<%= i %>">
                            <div class="commitment-content p-8">
                                <div class="commitment-header">
                                    <div class="commitment-icon-badge">
                                        <i class="fas fa-<%= commitment.getIcon()%>"></i>
                                    </div>
                                    <div class="commitment-number">
                                        <%= String.format("%02d", i + 1)%>
                                    </div>
                                </div>
                                <h3 class="commitment-title"><%= commitment.getTitle()%></h3>
                                <p class="commitment-description"><%= commitment.getDescription()%></p>
                                <div class="commitment-features">
                                    <span class="feature-badge">
                                        <i class="fas fa-check"></i>
                                        Đảm bảo
                                    </span>
                                    <span class="feature-badge">
                                        <i class="fas fa-check"></i>
                                        Chất lượng
                                    </span>
                                </div>
                            </div>
                        </div>
                  <%
                      }
                  } else {
                  %>
                      <div class="no-data-state text-center enhanced-card p-16">
                          <div class="no-data-icon mb-8">
                              <i class="fas fa-handshake text-6xl text-gray-300"></i>
                          </div>
                          <h3 class="text-2xl font-semibold text-gray-600 mb-2">Chưa có cam kết</h3>
                          <p class="text-gray-500 mb-6">Thông tin cam kết sẽ được cập nhật sớm nhất có thể.</p>
                          <button class="enhanced-button secondary">
                              <i class="fas fa-bell mr-2"></i>Nhận thông báo
                          </button>
                      </div>
                  <%
                  }
                  %>
              </div>
          </div>

          <!-- Enhanced Guarantee Section - Same card style as courseInfo -->
          <div class="enhanced-card p-8 max-w-4xl mx-auto mb-10 w-full-custom">
              <div class="text-center mb-8">
                  <div class="bg-gradient-to-br from-green-400 to-blue-500 rounded-full w-20 h-20 flex items-center justify-center mx-auto mb-4">
                      <i class="fas fa-shield-alt text-3xl text-white"></i>
                  </div>
                  <h3 class="text-3xl font-bold text-gray-800 mb-4">Đảm Bảo 100% Hoàn Tiền</h3>
                  <p class="text-gray-600 text-lg">Nếu không hài lòng với chất lượng khóa học trong 30 ngày đầu</p>
              </div>
              <div class="guarantee-features grid grid-cols-1 md:grid-cols-3 gap-6">
                  <div class="guarantee-item text-center">
                      <div class="item-icon mb-3">
                          <i class="fas fa-clock text-2xl text-green-500"></i>
                      </div>
                      <h4 class="font-semibold text-gray-800 mb-2">30 ngày đầu</h4>
                      <p class="text-gray-600 text-sm">Thời gian thử nghiệm miễn phí</p>
                  </div>
                  <div class="guarantee-item text-center">
                      <div class="item-icon mb-3">
                          <i class="fas fa-money-bill-wave text-2xl text-blue-500"></i>
                      </div>
                      <h4 class="font-semibold text-gray-800 mb-2">100% hoàn tiền</h4>
                      <p class="text-gray-600 text-sm">Không hài lòng, hoàn tiền ngay</p>
                  </div>
                  <div class="guarantee-item text-center">
                      <div class="item-icon mb-3">
                          <i class="fas fa-headset text-2xl text-purple-500"></i>
                      </div>
                      <h4 class="font-semibold text-gray-800 mb-2">Hỗ trợ 24/7</h4>
                      <p class="text-gray-600 text-sm">Đội ngũ tư vấn luôn sẵn sàng</p>
                  </div>
              </div>
          </div>

          <!-- Enhanced Action Buttons -->
          <div class="action-buttons-section bg-white rounded-3xl p-8 shadow-xl max-w-4xl mx-auto mb-10">
              <div class="text-center mb-8">
                  <h3 class="text-3xl font-bold text-gray-800 mb-4">Tin tưởng và Đăng ký ngay!</h3>
                  <p class="text-gray-600 text-xl">Tham gia cùng hàng nghìn học viên đã thành công với HIKARI</p>
              </div>
              <div class="action-buttons-grid grid grid-cols-1 md:grid-cols-3 gap-6">
                  <button class="enhanced-button primary register-course-btn">
                      <i class="fas fa-rocket mr-3"></i>Đăng ký ngay
                  </button>
                  <a href="${pageContext.request.contextPath}/courses" 
                     class="enhanced-button secondary">
                      <i class="fas fa-list mr-3"></i>Xem khóa học khác
                  </a>
                  <button class="enhanced-button tertiary">
                      <i class="fas fa-phone mr-3"></i>Tư vấn miễn phí
                  </button>
              </div>
          </div>

          <!-- Footer -->
          <jsp:include page="footer.jsp" />
      </main>
  </div>

  <script src="${pageContext.request.contextPath}/assets/js/scripts.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/student_js/commitments.js"></script>
  <script>
  // Enhanced commitments interactions
  document.addEventListener('DOMContentLoaded', function() {
      // Course registration functionality (same as courseInfo.jsp)
      const courseId = '<%= (course != null && course.getCourseID() != null) ? course.getCourseID() : "" %>';
      
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
      
      // Commitment card animations
      const commitmentCards = document.querySelectorAll('.commitment-card');
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
                  entry.target.style.animationDelay = `${index * 0.15}s`;
              }
          });
      }, observerOptions);
      
      commitmentCards.forEach(card => observer.observe(card));
      
      // Learn more button interactions
      const learnMoreButtons = document.querySelectorAll('.commitment-learn-more');
      learnMoreButtons.forEach(button => {
          button.addEventListener('click', function(e) {
              e.preventDefault();
              // Add modal or expand functionality here
              console.log('Learn more clicked');
          });
      });
  });
  </script>
</body>
</html>
