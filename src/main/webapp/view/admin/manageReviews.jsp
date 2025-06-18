<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản Lý Đánh Giá - HIKARI</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/admin/manaReviews.css" rel="stylesheet" />
  </head>
  <body>
    <div class="container-fluid">
      <div class="row">
        <!-- Include Sidebar -->
        <%@ include file="sidebar.jsp" %>
        <div class="main-content">
          <div class="content-wrapper">
            <!-- Include Header -->
            <div class="header">
              <h2 class="header-title">Quản Lý Đánh Giá</h2>
              <div class="header-actions">
                <div class="user-profile">
                  <img src="../img/dashborad/defaultAvatar.jpg" alt="Ảnh Đại Diện Quản Trị" class="avatar" />
                  <div class="user-info">
                    <span class="user-name">Xin Chào, Quản Trị</span>
                    <a href="/LogoutServlet" class="logout-btn">
                      <i class="fas fa-sign-out-alt"></i>
                      Đăng Xuất
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <div class="filter-section">
              <div class="filter-row">
                <label for="reviewerFilter">Người Đánh Giá:</label>
                <select class="form-select" id="reviewerFilter">
                  <option value="">Tất cả</option>
                  <option value="Nguyễn Văn A">Nguyễn Văn A</option>
                  <option value="Lê Văn C">Lê Văn C</option>
                  <option value="Hoàng Văn E">Hoàng Văn E</option>
                </select>
                <label for="instructorFilter">Giảng Viên:</label>
                <select class="form-select" id="instructorFilter">
                  <option value="">Tất cả</option>
                  <option value="Trần Thị B">Trần Thị B</option>
                  <option value="Phạm Văn D">Phạm Văn D</option>
                  <option value="Nguyễn Thị F">Nguyễn Thị F</option>
                </select>
                <label for="courseFilter">Khóa Học:</label>
                <select class="form-select" id="courseFilter">
                  <option value="">Tất cả</option>
                  <option value="Tiếng Nhật Sơ Cấp N5">Tiếng Nhật Sơ Cấp N5</option>
                  <option value="Tiếng Nhật Trung Cấp N3">Tiếng Nhật Trung Cấp N3</option>
                  <option value="Tiếng Nhật Cao Cấp N1">Tiếng Nhật Cao Cấp N1</option>
                  <option value="Kanji Sơ Cấp">Kanji Sơ Cấp</option>
                  <option value="Luyện Thi JLPT N4">Luyện Thi JLPT N4</option>
                  <option value="Hội Thoại Tiếng Nhật">Hội Thoại Tiếng Nhật</option>
                  <option value="Tiếng Nhật Doanh Nghiệp">Tiếng Nhật Doanh Nghiệp</option>
                  <option value="Ngữ Pháp N3">Ngữ Pháp N3</option>
                  <option value="Kanji Cao Cấp">Kanji Cao Cấp</option>
                  <option value="Luyện Thi JLPT N2">Luyện Thi JLPT N2</option>
                </select>
                <label for="ratingFilter">Điểm Đánh Giá:</label>
                <select class="form-select" id="ratingFilter">
                  <option value="">Tất cả</option>
                  <option value="5">5 Sao</option>
                  <option value="4">4 Sao</option>
                  <option value="3">3 Sao</option>
                  <option value="2">2 Sao</option>
                  <option value="1">1 Sao</option>
                </select>
                <label for="reviewDateFilter">Ngày Đánh Giá:</label>
                <input type="date" class="form-control" id="reviewDateFilter" />
              </div>
              <div class="search-row">
                <label for="search">Tìm Kiếm:</label>
                <input type="text" class="form-control" id="search" placeholder="Tìm theo ID hoặc người đánh giá..." />
              </div>
            </div>
            <!-- Reviews Table -->
            <div class="table-responsive">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>AVATAR</th>
                    <th>NGƯỜI ĐÁNH GIÁ</th>
                    <th>GIẢNG VIÊN</th>
                    <th>KHÓA HỌC</th>
                    <th>ĐIỂM ĐÁNH GIÁ</th>
                    <th>NGÀY ĐÁNH GIÁ</th>
                    <th>HÀNH ĐỘNG</th>
                  </tr>
                </thead>
                <tbody id="reviewTableBody">
                  <tr data-review-id="REV001">
                    <td>REV001</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Trần Thị B</td>
                    <td>Tiếng Nhật Sơ Cấp N5</td>
                    <td><span class="rating-stars">★★★★★</span> (5)</td>
                    <td>2025-05-01</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV001"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV001"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV001" data-reviewer="Nguyễn Văn A"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV002">
                    <td>REV002</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Lê Văn C</td>
                    <td>Phạm Văn D</td>
                    <td>Tiếng Nhật Trung Cấp N3</td>
                    <td><span class="rating-stars">★★★★☆</span> (4)</td>
                    <td>2025-05-02</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV002"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV002"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV002" data-reviewer="Lê Văn C"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV003">
                    <td>REV003</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Hoàng Văn E</td>
                    <td>Nguyễn Thị F</td>
                    <td>Tiếng Nhật Cao Cấp N1</td>
                    <td><span class="rating-stars">★★★☆☆</span> (3)</td>
                    <td>2025-05-03</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV003"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV003"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV003" data-reviewer="Hoàng Văn E"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV004">
                    <td>REV004</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Trần Thị B</td>
                    <td>Kanji Sơ Cấp</td>
                    <td><span class="rating-stars">★★★★★</span> (5)</td>
                    <td>2025-05-04</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV004"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV004"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV004" data-reviewer="Nguyễn Văn A"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV005">
                    <td>REV005</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Lê Văn C</td>
                    <td>Phạm Văn D</td>
                    <td>Luyện Thi JLPT N4</td>
                    <td><span class="rating-stars">★★★★☆</span> (4)</td>
                    <td>2025-05-05</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV005"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV005"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV005" data-reviewer="Lê Văn C"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV006">
                    <td>REV006</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Hoàng Văn E</td>
                    <td>Nguyễn Thị F</td>
                    <td>Hội Thoại Tiếng Nhật</td>
                    <td><span class="rating-stars">★★★☆☆</span> (3)</td>
                    <td>2025-05-06</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV006"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV006"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV006" data-reviewer="Hoàng Văn E"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV007">
                    <td>REV007</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Trần Thị B</td>
                    <td>Tiếng Nhật Doanh Nghiệp</td>
                    <td><span class="rating-stars">★★★★★</span> (5)</td>
                    <td>2025-05-07</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV007"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV007"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV007" data-reviewer="Nguyễn Văn A"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV008">
                    <td>REV008</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Lê Văn C</td>
                    <td>Phạm Văn D</td>
                    <td>Ngữ Pháp N3</td>
                    <td><span class="rating-stars">★★☆☆☆</span> (2)</td>
                    <td>2025-05-08</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV008"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV008"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV008" data-reviewer="Lê Văn C"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV009">
                    <td>REV009</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Hoàng Văn E</td>
                    <td>Nguyễn Thị F</td>
                    <td>Kanji Cao Cấp</td>
                    <td><span class="rating-stars">★★★★☆</span> (4)</td>
                    <td>2025-05-09</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV009"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV009"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV009" data-reviewer="Hoàng Văn E"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                  <tr data-review-id="REV010">
                    <td>REV010</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Trần Thị B</td>
                    <td>Luyện Thi JLPT N2</td>
                    <td><span class="rating-stars">★★★★★</span> (5)</td>
                    <td>2025-05-10</td>
                    <td>
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewReviewModal" data-review-id="REV010"><i class="fas fa-eye"></i></button>
                      <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="REV010"><i class="fas fa-edit"></i></button>
                      <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockReviewModal" data-review-id="REV010" data-reviewer="Nguyễn Văn A"><i class="fas fa-lock"></i></button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <!-- Pagination -->
            <div class="pagination" id="pagination">
              <button id="prevPage" disabled>Trước</button>
              <span id="pageInfo"></span>
              <button id="nextPage">Sau</button>
            </div>
            <!-- View Review Modal -->
            <div class="modal fade view-review-modal" id="viewReviewModal" tabindex="-1" aria-labelledby="viewReviewModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-lg">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="viewReviewModalLabel"><i class="fas fa-star"></i> Chi Tiết Đánh Giá</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <div class="section">
                      <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Đánh Giá</h6>
                      <div class="reviewer-info">
                        <img id="modalReviewerAvatar" src="img/dashborad/defaultAvatar.png" alt="Reviewer Avatar" class="reviewer-avatar" />
                        <div>
                          <div class="info-item">
                            <span class="info-label">ID:</span>
                            <span class="info-value" id="modalReviewId"></span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">Người Đánh Giá:</span>
                            <span class="info-value" id="modalReviewer"></span>
                          </div>
                        </div>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Giảng Viên:</span>
                        <span class="info-value" id="modalInstructor"></span>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Khóa Học:</span>
                        <span class="info-value" id="modalCourse"></span>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Điểm Đánh Giá:</span>
                        <span class="info-value" id="modalRating"></span>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Ngày Đánh Giá:</span>
                        <span class="info-value" id="modalReviewDate"></span>
                      </div>
                    </div>
                    <div class="section">
                      <h6 class="section-title"><i class="fas fa-comment"></i> Lời Nhận Xét</h6>
                      <div class="info-item">
                        <span class="info-label">Ưu Điểm:</span>
                        <ul id="modalPros"></ul>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Nhược Điểm:</span>
                        <ul id="modalCons"></ul>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Gợi Ý Cải Thiện:</span>
                        <ul id="modalSuggestions"></ul>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Phản Hồi từ Giảng Viên:</span>
                        <span class="info-value" id="modalInstructorResponse"></span>
                      </div>
                    </div>
                    <div class="section">
                      <h6 class="section-title"><i class="fas fa-chart-bar"></i> Ý Nghĩa Đánh Giá</h6>
                      <p id="modalSignificance"></p>
                    </div>
                    <div class="section">
                      <h6 class="section-title"><i class="fas fa-graduation-cap"></i> Thông Tin Bổ Sung</h6>
                      <div class="info-item">
                        <span class="info-label">Thời Gian Hoàn Thành Khóa Học:</span>
                        <span class="info-value" id="modalCompletionDate"></span>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Thời Lượng Khóa Học:</span>
                        <span class="info-value" id="modalCourseDuration"></span>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Tiến Độ Hoàn Thành:</span>
                        <div class="progress">
                          <div id="modalProgressBar" class="progress-bar" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                      </div>
                    </div>
                    <div class="section">
                      <h6 class="section-title"><i class="fas fa-user-graduate"></i> Chi Tiết Học Viên</h6>
                      <div class="info-item">
                        <span class="info-label">Ngày Tham Gia Nền Tảng:</span>
                        <span class="info-value" id="modalEnrollmentDate"></span>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Tổng Số Khóa Học Đã Tham Gia:</span>
                        <span class="info-value" id="modalTotalCourses"></span>
                      </div>
                    </div>
                    <div class="section">
                      <h6 class="section-title"><i class="fas fa-chalkboard-teacher"></i> Chi Tiết Giảng Viên</h6>
                      <div class="info-item">
                        <span class="info-label">Tổng Số Khóa Học Đã Giảng Dạy:</span>
                        <span class="info-value" id="modalCoursesTaught"></span>
                      </div>
                      <div class="info-item">
                        <span class="info-label">Đánh Giá Trung Bình:</span>
                        <span class="info-value" id="modalOverallRating"></span>
                      </div>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Đóng</button>
                  </div>
                </div>
              </div>
            </div>
            <!-- Edit Review Modal -->
            <div class="modal fade edit-review-modal" id="editReviewModal" tabindex="-1" aria-labelledby="editReviewModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="editReviewModalLabel"><i class="fas fa-edit"></i> Chỉnh Sửa Đánh Giá</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <form action="/EditReviewServlet" method="POST">
                    <div class="modal-body">
                      <input type="hidden" id="editReviewId" name="reviewId" />
                      <div class="section">
                        <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Đánh Giá</h6>
                        <div class="form-group">
                          <label for="editReviewer">Người Đánh Giá <span class="text-danger">*</span></label>
                          <select class="form-select" id="editReviewer" name="reviewer" required>
                            <option value="" disabled>Chọn người đánh giá</option>
                            <option value="Nguyễn Văn A">Nguyễn Văn A</option>
                            <option value="Lê Văn C">Lê Văn C</option>
                            <option value="Hoàng Văn E">Hoàng Văn E</option>
                          </select>
                        </div>
                        <div class="form-group">
                          <label for="editInstructor">Giảng Viên <span class="text-danger">*</span></label>
                          <select class="form-select" id="editInstructor" name="instructor" required>
                            <option value="" disabled>Chọn giảng viên</option>
                            <option value="Trần Thị B">Trần Thị B</option>
                            <option value="Phạm Văn D">Phạm Văn D</option>
                            <option value="Nguyễn Thị F">Nguyễn Thị F</option>
                          </select>
                        </div>
                        <div class="form-group">
                          <label for="editCourse">Khóa Học <span class="text-danger">*</span></label>
                          <select class="form-select" id="editCourse" name="course" required>
                            <option value="" disabled>Chọn khóa học</option>
                            <option value="Tiếng Nhật Sơ Cấp N5">Tiếng Nhật Sơ Cấp N5</option>
                            <option value="Tiếng Nhật Trung Cấp N3">Tiếng Nhật Trung Cấp N3</option>
                            <option value="Tiếng Nhật Cao Cấp N1">Tiếng Nhật Cao Cấp N1</option>
                            <option value="Kanji Sơ Cấp">Kanji Sơ Cấp</option>
                            <option value="Luyện Thi JLPT N4">Luyện Thi JLPT N4</option>
                            <option value="Hội Thoại Tiếng Nhật">Hội Thoại Tiếng Nhật</option>
                            <option value="Tiếng Nhật Doanh Nghiệp">Tiếng Nhật Doanh Nghiệp</option>
                            <option value="Ngữ Pháp N3">Ngữ Pháp N3</option>
                            <option value="Kanji Cao Cấp">Kanji Cao Cấp</option>
                            <option value="Luyện Thi JLPT N2">Luyện Thi JLPT N2</option>
                          </select>
                        </div>
                        <div class="form-group">
                          <label for="editRating">Điểm Đánh Giá <span class="text-danger">*</span></label>
                          <select class="form-select" id="editRating" name="rating" required>
                            <option value="" disabled>Chọn điểm</option>
                            <option value="5">5 Sao</option>
                            <option value="4">4 Sao</option>
                            <option value="3">3 Sao</option>
                            <option value="2">2 Sao</option>
                            <option value="1">1 Sao</option>
                          </select>
                        </div>
                        <div class="form-group">
                          <label for="editReviewDate">Ngày Đánh Giá <span class="text-danger">*</span></label>
                          <input type="date" class="form-control" id="editReviewDate" name="reviewDate" required />
                        </div>
                      </div>
                      <div class="section">
                        <h6 class="section-title"><i class="fas fa-comment"></i> Lời Nhận Xét</h6>
                        <div class="form-group">
                          <label for="editPros">Ưu Điểm</label>
                          <textarea class="form-control" id="editPros" name="pros" placeholder="Nhập ưu điểm, mỗi dòng một ý"></textarea>
                        </div>
                        <div class="form-group">
                          <label for="editCons">Nhược Điểm</label>
                          <textarea class="form-control" id="editCons" name="cons" placeholder="Nhập nhược điểm, mỗi dòng một ý"></textarea>
                        </div>
                        <div class="form-group">
                          <label for="editSuggestions">Gợi Ý Cải Thiện</label>
                          <textarea class="form-control" id="editSuggestions" name="suggestions" placeholder="Nhập gợi ý, mỗi dòng một ý"></textarea>
                        </div>
                        <div class="form-group">
                          <label for="editInstructorResponse">Phản Hồi từ Giảng Viên</label>
                          <textarea class="form-control" id="editInstructorResponse" name="instructorResponse" placeholder="Nhập phản hồi từ giảng viên"></textarea>
                        </div>
                      </div>
                    </div>
                    <div class="modal-footer">
                      <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                      <button type="submit" class="btn btn-submit">Cập Nhật</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
            <!-- Block Review Modal -->
            <div class="modal fade block-review-modal" id="blockReviewModal" tabindex="-1" aria-labelledby="blockReviewModalLabel" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="blockReviewModalLabel"><i class="fas fa-lock"></i> Xác Nhận Khóa Đánh Giá</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                  </div>
                  <div class="modal-body">
                    <div class="warning-section">
                      <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh Báo</h6>
                      <div class="info-item">
                        Bạn có chắc chắn muốn khóa đánh giá <span id="blockReviewId"></span> của <span id="blockReviewer"></span>?
                      </div>
                      <div class="warning-text">
                        Hành động này sẽ tạm thời vô hiệu hóa đánh giá. Vui lòng xác nhận.
                      </div>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                    <form action="/BlockReviewServlet" method="POST">
                      <input type="hidden" id="blockReviewIdInput" name="reviewId" />
                      <button type="submit" class="btn btn-confirm-block">Khóa</button>
                    </form>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/manaReviews.js"></script>
  </body>
</html>