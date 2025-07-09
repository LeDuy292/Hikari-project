<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phê Duyệt Video Giảng Dạy - Coordinator Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/course-approval.css" rel="stylesheet">
</head>
<body>
    <div class="d-flex bg-light min-vh-100">
        <!-- Sidebar -->
        <jsp:include page="sidebarCoordinator.jsp" />
        <!-- Main Content -->
        <div class="main-content flex-grow-1">
            <!-- Header -->
            <jsp:include page="headerCoordinator.jsp" />
            <!-- Content -->
            <div class="content-wrapper">
                <!-- Statistics Overview (Optional - may need adjustment for video count) -->
                <div class="row g-3 mb-4">
                    <div class="col-12 col-md-4">
                        <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                            <div class="stat-icon bg-warning bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                <i class="fas fa-clock fa-2x text-warning"></i>
                            </div>
                            <div>
                                <div class="fs-5 fw-bold text-dark">5</div>
                                <div class="text-muted small">Video chờ phê duyệt</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                            <div class="stat-icon bg-success bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                <i class="fas fa-check-circle fa-2x text-success"></i>
                            </div>
                            <div>
                                <div class="fs-5 fw-bold text-dark">20</div>
                                <div class="text-muted small">Video đã phê duyệt</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                            <div class="stat-icon bg-danger bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                <i class="fas fa-times-circle fa-2x text-danger"></i>
                            </div>
                            <div>
                                <div class="fs-5 fw-bold text-dark">2</div>
                                <div class="text-muted small">Video bị từ chối</div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Video Approval List -->
                <div class="card p-0">
                    <div class="card-header bg-white border-bottom-0 pb-0">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-6">
                                <h5 class="card-title mb-0">Danh sách video chờ phê duyệt</h5>
                            </div>
                            <div class="col-md-6">
                                <form class="d-flex gap-2 justify-content-md-end flex-wrap">
                                    <div class="input-group shadow-sm rounded-pill" style="max-width: 260px;">
                                        <span class="input-group-text bg-white border-0 rounded-start-pill"><i class="fas fa-search text-muted"></i></span>
                                        <input type="text" class="form-control border-0 rounded-end-pill" placeholder="Tìm kiếm video...">
                                    </div>
                                    <select class="form-select shadow-sm rounded-pill" style="max-width: 180px;">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="pending">Chờ phê duyệt</option>
                                        <option value="approved">Đã phê duyệt</option>
                                        <option value="rejected">Từ chối</option>
                                    </select>
                                    <a href="course-approval-history.jsp" class="btn btn-outline-secondary rounded-pill d-flex align-items-center gap-2">
                                        <i class="fas fa-history"></i>
                                        <span>Xem lịch sử phê duyệt</span>
                                    </a>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th>Khóa học</th>
                                        <th>Giảng viên</th>
                                        <th>Tiêu đề video</th>
                                        <th>Thời lượng</th>
                                        <th>Phân loại</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- Example Row (replace with dynamic data) --%>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="course-icon bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                                    <i class="fas fa-book text-primary"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">JLPT N1</div>
                                                    <div class="text-muted small">Cấp độ cao cấp</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="assets/images/avatar.jpg" class="rounded-circle border" width="32" height="32" alt="Avatar">
                                                <span class="fw-medium">Nguyễn Văn A</span>
                                            </div>
                                        </td>
                                        <td>Giới thiệu Bảng chữ cái Hiragana</td>
                                        <td>15:30</td>
                                        <td>
                                            <span>Nghe</span>
                                        </td>
                                        <td><span class="badge bg-warning">Chờ phê duyệt</span></td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal">
                                                    <i class="fas fa-play"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#quizModal">
                                                    <i class="fas fa-question-circle"></i>
                                                </button>
                                                <button class="btn btn-sm btn-success">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <%-- Add more rows for other videos --%>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="course-icon bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                                    <i class="fas fa-book text-success"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">JLPT N2</div>
                                                    <div class="text-muted small">Cấp độ trung cao</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="assets/images/avatar.jpg" class="rounded-circle border" width="32" height="32" alt="Avatar">
                                                <span class="fw-medium">Trần Thị B</span>
                                            </div>
                                        </td>
                                        <td>Bài 1: Ngữ pháp N2 - はじめに</td>
                                        <td>20:10</td>
                                        <td><span>Nghe</span></td>
                                        <td><span class="badge bg-warning">Chờ phê duyệt</span></td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal">
                                                    <i class="fas fa-play"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#quizModal">
                                                    <i class="fas fa-question-circle"></i>
                                                </button>
                                                <button class="btn btn-sm btn-success">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="course-icon bg-danger bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                                    <i class="fas fa-book text-danger"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">JLPT N3</div>
                                                    <div class="text-muted small">Cấp độ trung cấp</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="assets/images/avatar.jpg" class="rounded-circle border" width="32" height="32" alt="Avatar">
                                                <span class="fw-medium">Lê Văn C</span>
                                            </div>
                                        </td>
                                        <td>Kanji bài 5 - Giáo trình Minna no Nihongo</td>
                                        <td>18:45</td>
                                        <td><span>Đọc</span></td>
                                        <td><span class="badge bg-warning">Chờ phê duyệt</span></td>
                                         <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal">
                                                    <i class="fas fa-play"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#quizModal">
                                                    <i class="fas fa-question-circle"></i>
                                                </button>
                                                <button class="btn btn-sm btn-success">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="course-icon bg-warning bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                                    <i class="fas fa-book text-warning"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">JLPT N4</div>
                                                    <div class="text-muted small">Cấp độ sơ trung cấp</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="assets/images/avatar.jpg" class="rounded-circle border" width="32" height="32" alt="Avatar">
                                                <span class="fw-medium">Nguyễn Văn D</span>
                                            </div>
                                        </td>
                                        <td>Bài 1: Ngữ pháp N4 - Thể Te</td>
                                        <td>22:00</td>
                                        <td>
                                            <span>Đọc</span>
                                        </td>
                                        <td><span class="badge bg-warning">Chờ phê duyệt</span></td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal">
                                                    <i class="fas fa-play"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#quizModal">
                                                    <i class="fas fa-question-circle"></i>
                                                </button>
                                                <button class="btn btn-sm btn-success">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <div class="course-icon bg-info bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                                    <i class="fas fa-book text-info"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">JLPT N5</div>
                                                    <div class="text-muted small">Cấp độ sơ cấp</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <img src="assets/images/avatar.jpg" class="rounded-circle border" width="32" height="32" alt="Avatar">
                                                <span class="fw-medium">Trần Thị E</span>
                                            </div>
                                        </td>
                                        <td>Bài 1: Bảng chữ cái Katakana</td>
                                        <td>19:00</td>
                                        <td>
                                            <span>Viết</span>
                                        </td>
                                        <td><span class="badge bg-warning">Chờ phê duyệt</span></td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal">
                                                    <i class="fas fa-play"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#quizModal">
                                                    <i class="fas fa-question-circle"></i>
                                                </button>
                                                <button class="btn btn-sm btn-success">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Video Review Modal -->
            <div class="modal fade" id="videoModal" tabindex="-1" aria-labelledby="videoModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="videoModalLabel">Đánh giá video giảng dạy</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="video-container mb-4">
                                <video class="w-100 rounded-3 bg-dark" controls>
                                    <source src="assets/videos/sample-lesson.mp4" type="video/mp4">
                                    Trình duyệt của bạn không hỗ trợ video.
                                </video>
                            </div>
                            <%-- Evaluation form (optional, keep if needed for review comments) --%>
                            <form class="evaluation-form">
                                <h6 class="mb-3">Đánh giá chi tiết</h6>
                                <div class="mb-3">
                                    <label class="form-label">Chất lượng video:</label>
                                    <div class="rating">
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="far fa-star text-warning"></i>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Nội dung phù hợp:</label>
                                    <div class="rating">
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="fas fa-star text-warning"></i>
                                        <i class="fas fa-star text-warning"></i>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="adminComments" class="form-label">Nhận xét của Admin:</label>
                                    <textarea class="form-control" id="adminComments" rows="3" placeholder="Nhập nhận xét tại đây..."></textarea>
                                </div>
                                <%-- Add submit button for evaluation if needed --%>
                                <%-- <button type="submit" class="btn btn-primary">Gửi đánh giá</button> --%>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <%-- Add action buttons for modal if needed, e.g., Approve/Reject from modal --%>
                            <%-- <button type="button" class="btn btn-success"><i class="fas fa-check me-1"></i> Phê duyệt</button> --%>
                            <%-- <button type="button" class="btn btn-danger"><i class="fas fa-times me-1"></i> Từ chối</button> --%>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quiz Modal -->
            <div class="modal fade" id="quizModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Bài kiểm tra</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="quiz-container">
                                <div class="quiz-header mb-4">
                                    <h6 class="mb-2">Tiêu đề bài kiểm tra</h6>
                                    <p class="text-muted mb-0">Thời gian: 15 phút</p>
                                </div>
                                <div class="quiz-questions">
                                    <div class="question mb-4">
                                        <h6 class="mb-3">Câu 1: Câu hỏi mẫu?</h6>
                                        <div class="options">
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="radio" name="q1" id="q1a1">
                                                <label class="form-check-label" for="q1a1">Đáp án A</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="radio" name="q1" id="q1a2">
                                                <label class="form-check-label" for="q1a2">Đáp án B</label>
                                            </div>
                                            <div class="form-check mb-2">
                                                <input class="form-check-input" type="radio" name="q1" id="q1a3">
                                                <label class="form-check-label" for="q1a3">Đáp án C</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="q1" id="q1a4">
                                                <label class="form-check-label" for="q1a4">Đáp án D</label>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Add more questions as needed -->
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="button" class="btn btn-primary">Lưu thay đổi</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 