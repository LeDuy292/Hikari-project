<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phê Duyệt Bài Test - Coordinator Dashboard</title>
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
                <!-- Statistics Overview -->
                <div class="row g-3 mb-4">
                    <div class="col-12 col-md-4">
                        <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                            <div class="stat-icon bg-warning bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                <i class="fas fa-clock fa-2x text-warning"></i>
                            </div>
                            <div>
                                <div class="fs-5 fw-bold text-dark">6</div>
                                <div class="text-muted small">Bài test chờ phê duyệt</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                            <div class="stat-icon bg-success bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                <i class="fas fa-check-circle fa-2x text-success"></i>
                            </div>
                            <div>
                                <div class="fs-5 fw-bold text-dark">18</div>
                                <div class="text-muted small">Bài test đã phê duyệt</div>
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
                                <div class="text-muted small">Bài test bị từ chối</div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Test Approval List -->
                <div class="card p-0">
                    <div class="card-header bg-white border-bottom-0 pb-0">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-6">
                                <h5 class="card-title mb-0">Danh sách bài test chờ phê duyệt</h5>
                            </div>
                            <div class="col-md-6">
                                <form class="d-flex gap-2 justify-content-md-end flex-wrap">
                                    <div class="input-group shadow-sm rounded-pill" style="max-width: 260px;">
                                        <span class="input-group-text bg-white border-0 rounded-start-pill"><i class="fas fa-search text-muted"></i></span>
                                        <input type="text" class="form-control border-0 rounded-end-pill" placeholder="Tìm kiếm bài test...">
                                    </div>
                                    <select class="form-select shadow-sm rounded-pill" style="max-width: 180px;">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="pending">Chờ phê duyệt</option>
                                        <option value="approved">Đã phê duyệt</option>
                                        <option value="rejected">Từ chối</option>
                                    </select>
                                    <a href="test-approval-history.jsp" class="btn btn-outline-secondary rounded-pill d-flex align-items-center gap-2">
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
                                        <th>Tên bài test</th>
                                        <th>Số câu hỏi</th>
                                        <th>Thời gian</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
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
                                        <td>Kiểm tra Ngữ pháp N1 - Bài 1</td>
                                        <td>20 câu</td>
                                        <td>30 phút</td>
                                        <td><span class="badge bg-warning">Chờ phê duyệt</span></td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#previewTestModal" title="Xem bài test">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary" title="Tải xuống">
                                                    <i class="fas fa-download"></i>
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
        </div>
    </div>

    <!-- Preview Test Modal -->
    <div class="modal fade" id="previewTestModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xem trước bài test</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="test-preview">
                        <div class="question mb-4">
                            <h6 class="mb-3">Câu 1: Chọn đáp án đúng</h6>
                            <p class="mb-3">Điền từ thích hợp vào chỗ trống: 彼は＿＿＿日本語が上手です。</p>
                            <div class="options">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="q1" id="q1a">
                                    <label class="form-check-label" for="q1a">とても</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="q1" id="q1b">
                                    <label class="form-check-label" for="q1b">たくさん</label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="q1" id="q1c">
                                    <label class="form-check-label" for="q1c">いつも</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="q1" id="q1d">
                                    <label class="form-check-label" for="q1d">ぜんぶ</label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 