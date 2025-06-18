<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phê Duyệt Tài Liệu - Coordinator Dashboard</title>
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
                                <div class="fs-5 fw-bold text-dark">8</div>
                                <div class="text-muted small">Tài liệu chờ phê duyệt</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                            <div class="stat-icon bg-success bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                <i class="fas fa-check-circle fa-2x text-success"></i>
                            </div>
                            <div>
                                <div class="fs-5 fw-bold text-dark">25</div>
                                <div class="text-muted small">Tài liệu đã phê duyệt</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-md-4">
                        <div class="card stat-card shadow-sm d-flex flex-row align-items-center p-3 gap-3">
                            <div class="stat-icon bg-danger bg-opacity-25 rounded-circle d-flex align-items-center justify-content-center" style="width:56px;height:56px;">
                                <i class="fas fa-times-circle fa-2x text-danger"></i>
                            </div>
                            <div>
                                <div class="fs-5 fw-bold text-dark">3</div>
                                <div class="text-muted small">Tài liệu bị từ chối</div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Document Approval List -->
                <div class="card p-0">
                    <div class="card-header bg-white border-bottom-0 pb-0">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-6">
                                <h5 class="card-title mb-0">Danh sách tài liệu chờ phê duyệt</h5>
                            </div>
                            <div class="col-md-6">
                                <form class="d-flex gap-2 justify-content-md-end flex-wrap">
                                    <div class="input-group shadow-sm rounded-pill" style="max-width: 260px;">
                                        <span class="input-group-text bg-white border-0 rounded-start-pill"><i class="fas fa-search text-muted"></i></span>
                                        <input type="text" class="form-control border-0 rounded-end-pill" placeholder="Tìm kiếm tài liệu...">
                                    </div>
                                    <select class="form-select shadow-sm rounded-pill" style="max-width: 180px;">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="pending">Chờ phê duyệt</option>
                                        <option value="approved">Đã phê duyệt</option>
                                        <option value="rejected">Từ chối</option>
                                    </select>
                                    <a href="document-approval-history.jsp" class="btn btn-outline-secondary rounded-pill d-flex align-items-center gap-2">
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
                                        <th>Tên tài liệu</th>
                                        <th>Loại tài liệu</th>
                                        <th>Kích thước</th>
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
                                        <td>Giáo trình Ngữ pháp N1</td>
                                        <td>PDF</td>
                                        <td>2.5 MB</td>
                                        <td><span class="badge bg-warning">Chờ phê duyệt</span></td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#previewModal" title="Xem tài liệu">
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

    <!-- Preview Modal -->
    <div class="modal fade" id="previewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xem trước tài liệu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="ratio ratio-16x9">
                        <iframe src="#" allowfullscreen></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 