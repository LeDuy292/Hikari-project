<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

                        <%                            request.setAttribute("pageTitle", "Quản Lý Thông Báo");
                            request.setAttribute("showAddButton", true);
                            request.setAttribute("addButtonText", "Thêm Thông Báo");
                            request.setAttribute("addModalTarget", "createNotificationModal");
                            request.setAttribute("addBtnIcon", "fa-plus");
                            request.setAttribute("pageIcon", "fa-bell");
                            request.setAttribute("showNotification", false);
                        %>
                        <%@ include file="headerAdmin.jsp" %>

                        <!-- Messages -->
                        <c:if test="${not empty message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> ${message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Enhanced Filter Section -->
                        <div class="filter-section">
                            <form action="${pageContext.request.contextPath}/admin/notifications" method="GET" class="row g-3">
                                <div class="col-md-4">
                                    <label for="typeFilter" class="form-label">
                                        <i class="fas fa-tags"></i> Loại Thông Báo:
                                    </label>
                                    <select class="form-select" id="typeFilter" name="type">
                                        <option value="">Tất cả</option>
                                        <option value="Sự kiện" ${param.type == 'Sự kiện' ? 'selected' : ''}>Sự kiện</option>
                                        <option value="Cập nhật khóa học" ${param.type == 'Cập nhật khóa học' ? 'selected' : ''}>Cập nhật khóa học</option>
                                        <option value="Thông báo hệ thống" ${param.type == 'Thông báo hệ thống' ? 'selected' : ''}>Thông báo hệ thống</option>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label for="recipientFilter" class="form-label">
                                        <i class="fas fa-users"></i> Đối Tượng:
                                    </label>
                                    <select class="form-select" id="recipientFilter" name="recipient">
                                        <option value="">Tất cả</option>
                                        <option value="Tất cả học viên" ${param.recipient == 'Tất cả học viên' ? 'selected' : ''}>Tất cả học viên</option>
                                        <option value="Học viên N5" ${param.recipient == 'Học viên N5' ? 'selected' : ''}>Học viên N5</option>
                                        <option value="Học viên N4" ${param.recipient == 'Học viên N4' ? 'selected' : ''}>Học viên N4</option>
                                        <option value="Học viên N3" ${param.recipient == 'Học viên N3' ? 'selected' : ''}>Học viên N3</option>
                                        <option value="Học viên N2" ${param.recipient == 'Học viên N2' ? 'selected' : ''}>Học viên N2</option>
                                        <option value="Học viên N1" ${param.recipient == 'Học viên N1' ? 'selected' : ''}>Học viên N1</option>
                                        <option value="Giảng viên" ${param.recipient == 'Giảng viên' ? 'selected' : ''}>Giảng viên</option>
                                    </select>
                                </div>

                                <div class="col-md-4">
                                    <label for="search" class="form-label">
                                        <i class="fas fa-search"></i> Tìm kiếm:
                                    </label>
                                    <input type="text" class="form-control" id="search" name="search" placeholder="Tiêu đề, nội dung..." value="${param.search}" />
                                </div>

                                <div class="col-md-4">
                                    <label for="sendDateFromFilter" class="form-label">
                                        <i class="fas fa-calendar-alt"></i> Từ ngày:
                                    </label>
                                    <input type="date" class="form-control" id="sendDateFromFilter" name="sendDateFrom" value="${param.sendDateFrom}" />
                                </div>

                                <div class="col-md-4">
                                    <label for="sendDateToFilter" class="form-label">
                                        <i class="fas fa-calendar-check"></i> Đến ngày:
                                    </label>
                                    <input type="date" class="form-control" id="sendDateToFilter" name="sendDateTo" value="${param.sendDateTo}" />
                                </div>

                                <div class="col-md-4 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary me-2">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/notifications" class="btn btn-secondary">
                                        <i class="fas fa-refresh"></i> Đặt lại
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Notification Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-id-card"></i> ID</th>
                                        <th><i class="fas fa-heading"></i> TIÊU ĐỀ</th>
                                        <th><i class="fas fa-tags"></i> LOẠI THÔNG BÁO</th>
                                        <th><i class="fas fa-align-left"></i> NỘI DUNG</th>
                                        <th><i class="fas fa-users"></i> ĐỐI TƯỢNG</th>
                                        <th><i class="fas fa-calendar"></i> NGÀY GỬI</th>
                                        <th><i class="fas fa-cogs"></i> HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody id="notificationTableBody">
                                    <c:forEach var="notification" items="${notifications}">
                                        <tr data-notification-id="${notification.id}">
                                            <td><strong>NOT${String.format("%03d", notification.id)}</strong></td>
                                            <td><strong>${notification.title}</strong></td>
                                            <td>
                                                <span class="badge" style="background: linear-gradient(135deg, #17a2b8, #20c997);">
                                                    ${notification.type}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${fn:length(notification.content) > 50}">
                                                        ${fn:substring(notification.content, 0, 50)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${notification.content}
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge" style="background: linear-gradient(135deg, #6f42c1, #8e6bc1);">
                                                    ${notification.recipient}
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${notification.sendDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <button class="btn btn-view btn-sm btn-action" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#viewNotificationModal"
                                                        data-notification-id="${notification.id}">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-edit btn-sm btn-action" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#editNotificationModal"
                                                        data-notification-id="${notification.id}">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-delete btn-sm btn-action" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#deleteNotificationModal"
                                                        data-notification-id="${notification.id}"
                                                        data-title="${notification.title}">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination" id="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/admin/notifications?page=${currentPage - 1}&search=${param.search}&type=${param.type}" class="btn btn-pagination">
                                    <i class="fas fa-chevron-left"></i> Trước
                                </a>
                            </c:if>
                            <span id="pageInfo">Trang ${currentPage} / ${totalPages}</span>
                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/admin/notifications?page=${currentPage + 1}&search=${param.search}&type=${param.type}" class="btn btn-pagination">
                                    Sau <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
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
                                                <span class="info-label">Đối tượng:</span>
                                                <span class="info-value" id="modalRecipient"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày gửi:</span>
                                                <span class="info-value" id="modalSendDate"></span>
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
                                    <form id="createNotificationForm" action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body">
                                            <div class="form-group">
                                                <label for="createTitle">Tiêu đề <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="createTitle" name="title" placeholder="Nhập tiêu đề thông báo..." required />
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
                                                <input type="date" class="form-control" id="createSendDate" name="sendDate" required />
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
                                    <form id="editNotificationForm" action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editNotificationId" name="notificationId">
                                        <div class="modal-body">
                                            <div class="form-group">
                                                <label for="editTitle">Tiêu đề <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" id="editTitle" name="title" placeholder="Nhập tiêu đề thông báo..." required />
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
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                            <button type="submit" class="btn btn-submit">Cập nhật</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Delete Notification Modal -->
                        <div class="modal fade delete-notification-modal" id="deleteNotificationModal" tabindex="-1" aria-labelledby="deleteNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="deleteNotificationModalLabel"><i class="fas fa-trash"></i> Xác nhận xóa thông báo</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh báo</h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn xóa thông báo 
                                                <strong><span id="deleteNotificationTitle"></span></strong> (ID: <strong><span id="deleteNotificationId"></span></strong>)?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này không thể hoàn tác. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                                        <form action="${pageContext.request.contextPath}/admin/notifications" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" id="deleteNotificationIdInput" name="notificationId">
                                            <button type="submit" class="btn btn-confirm-delete">Xóa</button>
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
        <script>
            // JavaScript functions for modal handling
            function viewNotification(notificationId) {
                fetch('${pageContext.request.contextPath}/admin/notifications?action=view&id=' + notificationId)
                        .then(response => response.json())
                        .then(data => {
                            document.getElementById('modalNotificationId').textContent = 'NOT' + String(data.id).padStart(3, '0');
                            document.getElementById('modalTitle').textContent = data.title;
                            document.getElementById('modalType').textContent = data.type;
                            document.getElementById('modalContent').textContent = data.content;
                            document.getElementById('modalRecipient').textContent = data.recipient;
                            document.getElementById('modalSendDate').textContent = new Date(data.sendDate).toLocaleDateString('vi-VN');

                            var modal = new bootstrap.Modal(document.getElementById('viewNotificationModal'));
                            modal.show();
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi tải thông tin thông báo');
                        });
            }

            function editNotification(notificationId) {
                fetch('${pageContext.request.contextPath}/admin/notifications?action=view&id=' + notificationId)
                        .then(response => response.json())
                        .then(data => {
                            document.getElementById('editNotificationId').value = data.id;
                            document.getElementById('editTitle').value = data.title;
                            document.getElementById('editType').value = data.type;
                            document.getElementById('editContent').value = data.content;
                            document.getElementById('editRecipient').value = data.recipient;

                            var modal = new bootstrap.Modal(document.getElementById('editNotificationModal'));
                            modal.show();
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Có lỗi xảy ra khi tải thông tin thông báo');
                        });
            }

            function deleteNotification(notificationId, title) {
                document.getElementById('deleteNotificationId').textContent = 'NOT' + String(notificationId).padStart(3, '0');
                document.getElementById('deleteNotificationTitle').textContent = title;
                document.getElementById('deleteNotificationIdInput').value = notificationId;

                var modal = new bootstrap.Modal(document.getElementById('deleteNotificationModal'));
                modal.show();
            }

            // Event listeners for modal buttons
            document.addEventListener('click', function (e) {
                if (e.target.closest('.btn-view')) {
                    const notificationId = e.target.closest('.btn-view').getAttribute('data-notification-id');
                    viewNotification(notificationId);
                }

                if (e.target.closest('.btn-edit')) {
                    const notificationId = e.target.closest('.btn-edit').getAttribute('data-notification-id');
                    editNotification(notificationId);
                }

                if (e.target.closest('.btn-delete')) {
                    const button = e.target.closest('.btn-delete');
                    const notificationId = button.getAttribute('data-notification-id');
                    const title = button.getAttribute('data-title');
                    deleteNotification(notificationId, title);
                }
            });

            // Set default send date to today for create modal
            document.addEventListener('DOMContentLoaded', function () {
                document.getElementById('createSendDate').value = new Date().toISOString().split('T')[0];

                // Auto-dismiss alerts after 5 seconds
                const alerts = document.querySelectorAll(".alert");
                alerts.forEach((alert) => {
                    setTimeout(() => {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaNotifications.js"></script>
    </body>
</html>
