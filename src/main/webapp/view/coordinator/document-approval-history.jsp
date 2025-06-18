<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử Phê Duyệt Tài Liệu - Coordinator Dashboard</title>
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
                <div class="card p-0">
                    <div class="card-header bg-white border-bottom-0 pb-0">
                        <div class="row g-2 align-items-center">
                            <div class="col-md-6">
                                <h5 class="card-title mb-0">Lịch sử phê duyệt tài liệu</h5>
                            </div>
                            <div class="col-md-6">
                                <form class="d-flex gap-2 justify-content-md-end flex-wrap">
                                    <div class="input-group shadow-sm rounded-pill" style="max-width: 260px;">
                                        <span class="input-group-text bg-white border-0 rounded-start-pill"><i class="fas fa-search text-muted"></i></span>
                                        <input type="text" class="form-control border-0 rounded-end-pill" placeholder="Tìm kiếm tài liệu...">
                                    </div>
                                    <select class="form-select shadow-sm rounded-pill" style="max-width: 180px;">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="approved">Đã phê duyệt</option>
                                        <option value="rejected">Từ chối</option>
                                    </select>
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
                                    <!-- Example Approved Row -->
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
                                        <td>Giáo trình Ngữ pháp N2</td>
                                        <td>PDF</td>
                                        <td>3.2 MB</td>
                                        <td><span class="badge bg-success">Đã phê duyệt</span></td>
                                        <td>
                                            <div class="btn-group gap-1">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#previewModal" title="Xem tài liệu">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary" title="Tải xuống">
                                                    <i class="fas fa-download"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- Example Rejected Row -->
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
                                        <td>Bài tập Kanji N3</td>
                                        <td>DOCX</td>
                                        <td>1.8 MB</td>
                                        <td><span class="badge bg-danger">Từ chối</span></td>
                                        <td>
                                            <div class="btn-group gap-1">
                                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#previewModal" title="Xem tài liệu">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-secondary" title="Tải xuống">
                                                    <i class="fas fa-download"></i>
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
                    <h5 class="modal-title">Xem tài liệu</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="ratio ratio-16x9">
                        <iframe src="#" allowfullscreen></iframe>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 