<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử Phê Duyệt Video - Coordinator Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/course-approval.css" rel="stylesheet"> <%-- Reuse existing CSS --%>
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
                <div class="card p-0">
                    <div class="card-header bg-white border-bottom-0 pb-0">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-6">
                                <h5 class="card-title mb-0">Lịch sử phê duyệt video</h5>
                            </div>
                            <div class="col-md-6">
                                <%-- Add search/filter for history if needed --%>
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
                                        <th>Phân loại</th> <%-- Keep column for history view --%>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%-- Example Approved Row --%>
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
                                         <td>Nghe</td> <%-- Example classification for history --%>
                                        <td><span class="badge bg-success">Đã phê duyệt</span></td>
                                        <td>
                                             <div class="btn-group gap-1">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal" title="Xem video">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#quizModal" title="Xem bài kiểm tra">
                                                    <i class="fas fa-question-circle"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <%-- Example Rejected Row --%>
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
                                         <td>Đọc</td> <%-- Example classification for history --%>
                                        <td><span class="badge bg-danger">Từ chối</span></td>
                                         <td>
                                             <div class="btn-group gap-1">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#videoModal" title="Xem video">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-success" data-bs-toggle="modal" data-bs-target="#quizModal" title="Xem bài kiểm tra">
                                                    <i class="fas fa-question-circle"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <%-- Add more rows for other history data --%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Include Video Modal from course-approval.jsp if needed for history view --%>
    <%-- You might want a separate modal or reuse the existing one --%>
    <%-- For simplicity, reusing the video modal structure here --%>
     <div class="modal fade" id="videoModal" tabindex="-1" aria-labelledby="videoModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="videoModalLabel">Xem video giảng dạy</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="video-container mb-4">
                        <video class="w-100 rounded-3 bg-dark" controls>
                            <source src="assets/videos/sample-lesson.mp4" type="video/mp4">
                            Trình duyệt của bạn không hỗ trợ video.
                        </video>
                    </div>
                     <%-- Evaluation details for history if stored --%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Quiz Modal for History -->
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
                                        <input class="form-check-input" type="radio" name="q1" id="q1a1" disabled>
                                        <label class="form-check-label" for="q1a1">Đáp án A</label>
                                    </div>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="q1" id="q1a2" disabled>
                                        <label class="form-check-label" for="q1a2">Đáp án B</label>
                                    </div>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="q1" id="q1a3" disabled>
                                        <label class="form-check-label" for="q1a3">Đáp án C</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="q1" id="q1a4" disabled>
                                        <label class="form-check-label" for="q1a4">Đáp án D</label>
                                    </div>
                                </div>
                            </div>
                            <!-- Add more questions and selected answers as needed for history -->
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <%-- No save changes button in history modal --%>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 