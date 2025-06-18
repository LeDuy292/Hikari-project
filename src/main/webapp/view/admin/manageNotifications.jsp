<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Thông Báo - HIKARI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/admin/manaNotifications.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Include Sidebar -->
                <%@ include file="sidebar.jsp" %>
                <div class="main-content">
                    <div class="content-wrapper">
                        <div class="header">
                            <h2 class="header-title">Quản Lý Thông Báo</h2>
                            <div class="header-actions">
                                <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#createNotificationModal">
                                    <i class="fas fa-plus"></i> Thêm Thông Báo
                                </button>
                                <div class="user-profile">
                                    <img src="img/dashborad/defaultLogoAdmin.png" alt="Ảnh đại diện" class="avatar" />
                                    <div class="user-info">
                                        <span class="user-name">Xin chào, Quản lý</span>
                                        <a href="/LogoutServlet" class="logout-btn">
                                            <i class="fas fa-sign-out-alt"></i>
                                            Đăng xuất
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Filter Section -->
                        <div class="filter-section">
                            <div class="filter-row">
                                <label for="typeFilter">Loại thông báo:</label>
                                <select class="form-select" id="typeFilter">
                                    <option value="">Tất cả</option>
                                    <option value="Sự kiện">Sự kiện</option>
                                    <option value="Cập nhật khóa học">Cập nhật khóa học</option>
                                    <option value="Thông báo hệ thống">Thông báo hệ thống</option>
                                </select>
                                <label for="sendDateFilter">Ngày gửi:</label>
                                <input type="date" class="form-control" id="sendDateFilter"></input>
                                <label for="search">Tìm kiếm:</label>
                                <input type="text" class="form-control" id="search" placeholder="Tìm theo tiêu đề hoặc nội dung..."></input>
                            </div>
                        </div>
                        <!-- Notification Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>TIÊU ĐỀ</th>
                                        <th>LOẠI THÔNG BÁO</th>
                                        <th>NỘI DUNG</th>
                                        <th>NGÀY GỬI</th>
                                        <th>HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody id="notificationTableBody">
                                    <tr data-notification-id="NOT001">
                                        <td>NOT001</td>
                                        <td>Khóa học N5 mới</td>
                                        <td>Cập nhật khóa học</td>
                                        <td>Khóa học Tiếng Nhật Sơ cấp N5 mới sẽ bắt đầu vào 01/06/2025...</td>
                                        <td>2025-05-01</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT001"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT001"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT001" data-title="Khóa học N5 mới"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT002">
                                        <td>NOT002</td>
                                        <td>Đăng ký JLPT N3</td>
                                        <td>Sự kiện</td>
                                        <td>Hạn đăng ký thi JLPT N3 là 30/06/2025. Đăng ký ngay tại J-Learning...</td>
                                        <td>2025-05-02</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT002"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT002"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT002" data-title="Đăng ký JLPT N3"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT003">
                                        <td>NOT003</td>
                                        <td>Lễ hội Hanami 2025</td>
                                        <td>Sự kiện</td>
                                        <td>Tham gia lớp học làm bánh Mochi tại lễ hội Hanami vào 15/06/2025...</td>
                                        <td>2025-05-03</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT003"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT003"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT003" data-title="Lễ hội Hanami 2025"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT004">
                                        <td>NOT004</td>
                                        <td>Bảo trì hệ thống</td>
                                        <td>Thông báo hệ thống</td>
                                        <td>Hệ thống J-Learning sẽ bảo trì từ 00:00 đến 02:00 ngày 10/05/2025...</td>
                                        <td>2025-05-04</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT004"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT004"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT004" data-title="Bảo trì hệ thống"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT005">
                                        <td>NOT005</td>
                                        <td>Lớp học Trà đạo</td>
                                        <td>Sự kiện</td>
                                        <td>Tham gia lớp học Trà đạo Nhật Bản vào 20/06/2025 tại HIKARI...</td>
                                        <td>2025-05-05</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT005"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT005"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT005" data-title="Lớp học Trà đạo"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT006">
                                        <td>NOT006</td>
                                        <td>Khóa học Kanji N4</td>
                                        <td>Cập nhật khóa học</td>
                                        <td>Khóa học Kanji N4 mới đã được cập nhật với tài liệu mới...</td>
                                        <td>2025-05-06</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT006"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT006"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT006" data-title="Khóa học Kanji N4"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT007">
                                        <td>NOT007</td>
                                        <td>Hội thảo JLPT N2</td>
                                        <td>Sự kiện</td>
                                        <td>Hội thảo ôn thi JLPT N2 sẽ diễn ra vào 25/06/2025...</td>
                                        <td>2025-05-07</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT007"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT007"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT007" data-title="Hội thảo JLPT N2"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT008">
                                        <td>NOT008</td>
                                        <td>Cập nhật ứng dụng</td>
                                        <td>Thông báo hệ thống</td>
                                        <td>Ứng dụng J-Learning đã được cập nhật phiên bản 2.1.0...</td>
                                        <td>2025-05-08</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT008"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT008"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT008" data-title="Cập nhật ứng dụng"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT009">
                                        <td>NOT009</td>
                                        <td>Lớp hội thoại N3</td>
                                        <td>Cập nhật khóa học</td>
                                        <td>Lớp hội thoại N3 mới sẽ khai giảng vào 01/07/2025...</td>
                                        <td>2025-05-09</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT009"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT009"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT009" data-title="Lớp hội thoại N3"><i class="fas fa-lock"></i></button>
                                        </td>
                                    </tr>
                                    <tr data-notification-id="NOT010">
                                        <td>NOT010</td>
                                        <td>Cuộc thi Kanji 2025</td>
                                        <td>Sự kiện</td>
                                        <td>Đăng ký cuộc thi Kanji toàn quốc 2025 tại HIKARI...</td>
                                        <td>2025-05-10</td>
                                        <td>
                                            <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewNotificationModal" data-notification-id="NOT010"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editNotificationModal" data-notification-id="NOT010"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockNotificationModal" data-notification-id="NOT010" data-title="Cuộc thi Kanji 2025"><i class="fas fa-lock"></i></button>
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
                        <!-- View Notification Modal -->
                        <div class="modal fade view-notification-modal" id="viewNotificationModal" tabindex="-1" aria-labelledby="viewNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="viewNotificationModalLabel"><i class="fas fa-bell"></i> Chi tiết thông báo</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông tin thông báo</h6>
                                            <div class="info-item">
                                                <span class="info-label">ID:</span>
                                                <span class="info-value" id="modalNotificationId"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Tiêu đề:</span>
                                                <span class="info-value" id="modalTitle"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Loại thông báo:</span>
                                                <span class="info-value" id="modalType"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Nội dung:</span>
                                                <span class="info-value" id="modalContent"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày gửi:</span>
                                                <span class="info-value" id="modalSendDate"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Đối tượng:</span>
                                                <span class="info-value" id="modalRecipient"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Create Notification Modal -->
                        <div class="modal fade create-notification-modal" id="createNotificationModal" tabindex="-1" aria-labelledby="createNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="createNotificationModalLabel"><i class="fas fa-plus"></i> Tạo thông báo mới</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form id="createNotificationForm">
                                        <div class="modal-body">
                                            <div class="form-group">
                                                <label for="createTitle">Tiêu đề <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="createTitle" name="title" placeholder="Nhập tiêu đề thông báo..." required></input>
                                            </div>
                                            <div class="form-group">
                                                <label for="createType">Loại thông báo <span class="text-danger">*</span></label>
                                                <select class="form-select" id="createType" name="type" required>
                                                    <option value="" disabled selected>Chọn loại thông báo</option>
                                                    <option value="Sự kiện">Sự kiện</option>
                                                    <option value="Cập nhật khóa học">Cập nhật khóa học</option>
                                                    <option value="Thông báo hệ thống">Thông báo hệ thống</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="createContent">Nội dung <span class="text-danger">*</span></label>
                                                <textarea class="form-control" id="createContent" name="content" placeholder="Nhập nội dung thông báo..." required></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label for="createRecipient">Đối tượng <span class="text-danger">*</span></label>
                                                <select class="form-select" id="createRecipient" name="recipient" required>
                                                    <option value="" disabled selected>Chọn đối tượng</option>
                                                    <option value="Tất cả học viên">Tất cả học viên</option>
                                                    <option value="Học viên N5">Học viên N5</option>
                                                    <option value="Học viên N4">Học viên N4</option>
                                                    <option value="Học viên N3">Học viên N3</option>
                                                    <option value="Học viên N2">Học viên N2</option>
                                                    <option value="Học viên N1">Học viên N1</option>
                                                    <option value="Giảng viên">Giảng viên</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="createSendDate">Ngày gửi <span class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="createSendDate" name="sendDate" required></input>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-submit">Tạo</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Edit Notification Modal -->
                        <div class="modal fade edit-notification-modal" id="editNotificationModal" tabindex="-1" aria-labelledby="editNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editNotificationModalLabel"><i class="fas fa-edit"></i> Chỉnh sửa thông báo</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="/EditNotificationServlet" method="POST">
                                        <div class="modal-body">
                                            <input type="hidden" id="editNotificationId" name="notificationId"></input>
                                            <div class="form-group">
                                                <label for="editTitle">Tiêu đề <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="editTitle" name="title" placeholder="Nhập tiêu đề thông báo..." required></input>
                                            </div>
                                            <div class="form-group">
                                                <label for="editType">Loại thông báo <span class="text-danger">*</span></label>
                                                <select class="form-select" id="editType" name="type" required>
                                                    <option value="" disabled>Chọn loại thông báo</option>
                                                    <option value="Sự kiện">Sự kiện</option>
                                                    <option value="Cập nhật khóa học">Cập nhật khóa học</option>
                                                    <option value="Thông báo hệ thống">Thông báo hệ thống</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="editContent">Nội dung <span class="text-danger">*</span></label>
                                                <textarea class="form-control" id="editContent" name="content" placeholder="Nhập nội dung thông báo..." required></textarea>
                                            </div>
                                            <div class="form-group">
                                                <label for="editRecipient">Đối tượng <span class="text-danger">*</span></label>
                                                <select class="form-select" id="editRecipient" name="recipient" required>
                                                    <option value="" disabled>Chọn đối tượng</option>
                                                    <option value="Tất cả học viên">Tất cả học viên</option>
                                                    <option value="Học viên N5">Học viên N5</option>
                                                    <option value="Học viên N4">Học viên N4</option>
                                                    <option value="Học viên N3">Học viên N3</option>
                                                    <option value="Học viên N2">Học viên N2</option>
                                                    <option value="Học viên N1">Học viên N1</option>
                                                    <option value="Giảng viên">Giảng viên</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="editSendDate">Ngày gửi <span class="text-danger">*</span></label>
                                                <input type="date" class="form-control" id="editSendDate" name="sendDate" required></input>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-submit">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <!-- Block Notification Modal -->
                        <div class="modal fade block-notification-modal" id="blockNotificationModal" tabindex="-1" aria-labelledby="blockNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="blockNotificationModalLabel"><i class="fas fa-lock"></i> Xác nhận khóa thông báo</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh báo</h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn khóa thông báo <span id="blockNotificationId"></span> với tiêu đề "<span id="blockTitle"></span>"?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này sẽ tạm thời vô hiệu hóa thông báo. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                        <form action="/BlockNotificationServlet" method="POST">
                                            <input type="hidden" id="blockNotificationIdInput" name="notificationId"></input>
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
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaNotifications.js"></script>
    </body>
</html>