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
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle"></i> ${param.message}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle"></i> ${param.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Enhanced Filter Section -->
                        <div class="filter-section">
                            <form action="${pageContext.request.contextPath}/admin/notifications" method="GET" class="filter-form">
                                <div class="filter-group">
                                    <label for="typeFilter">
                                        <i class="fas fa-tag"></i> Loại Thông Báo:
                                    </label>
                                    <select class="form-select" id="typeFilter" name="type">
                                        <option value="">Tất cả</option>
                                        <option value="Sự kiện" ${param.type == 'Sự kiện' ? 'selected' : ''}>Sự kiện</option>
                                        <option value="Cập nhật khóa học" ${param.type == 'Cập nhật khóa học' ? 'selected' : ''}>Cập nhật khóa học</option>
                                        <option value="Thông báo hệ thống" ${param.type == 'Thông báo hệ thống' ? 'selected' : ''}>Thông báo hệ thống</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="recipientFilter">
                                        <i class="fas fa-users"></i> Đối Tượng:
                                    </label>
                                    <select class="form-select" id="recipientFilter" name="recipient">
                                        <option value="">Tất cả</option>
                                        <option value="Học viên" ${param.recipient == 'Học viên' ? 'selected' : ''}>Học viên</option>
                                        <option value="Giảng viên" ${param.recipient == 'Giảng viên' ? 'selected' : ''}>Giảng viên</option>
                                        <option value="Điều phối viên" ${param.recipient == 'Điều phối viên' ? 'selected' : ''}>Điều phối viên</option>
                                        <option value="Quản trị viên" ${param.recipient == 'Quản trị viên' ? 'selected' : ''}>Quản trị viên</option>
                                    </select>

                                </div>
                                <div class="filter-group">
                                    <label for="sendDateFromFilter">
                                        <i class="fas fa-calendar-alt"></i> Từ Ngày:
                                    </label>
                                    <input type="date" class="form-control" id="sendDateFromFilter" name="sendDateFrom" value="${param.sendDateFrom}" />
                                </div>
                                <div class="filter-group">
                                    <label for="sendDateToFilter">
                                        <i class="fas fa-calendar-check"></i> Đến Ngày:
                                    </label>
                                    <input type="date" class="form-control" id="sendDateToFilter" name="sendDateTo" value="${param.sendDateTo}" />
                                </div>
                                <div class="filter-group">
                                    <label for="searchFilter">
                                        <i class="fas fa-search"></i> Tìm Kiếm:
                                    </label>
                                    <input type="text" class="form-control" id="searchFilter" name="search" placeholder="Tiêu đề, nội dung, ID..." value="${param.search}" />
                                </div>
                                <div class="filter-actions">
                                    <button type="submit" class="btn btn-filter">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/notifications" class="btn btn-reset">
                                        <i class="fas fa-refresh"></i> Đặt Lại
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Notifications Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i> ID</th>
                                        <th><i class="fas fa-heading"></i> TIÊU ĐỀ</th>
                                        <th><i class="fas fa-tag"></i> LOẠI</th>
                                        <th><i class="fas fa-users"></i> ĐỐI TƯỢNG</th>
                                        <th><i class="fas fa-calendar-alt"></i> NGÀY GỬI</th>
                                        <th><i class="fas fa-cogs"></i> HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty notifications}">
                                            <tr>
                                                <td colspan="6" class="text-center">
                                                    <i class="fas fa-inbox"></i> Không có thông báo nào
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="notification" items="${notifications}">
                                                <tr>
                                                    <td><strong>${notification.id}</strong></td>
                                                    <td>
                                                        <strong>${notification.title}</strong>
                                                        <c:if test="${fn:length(notification.content) > 50}">
                                                            <br><small class="text-muted">${fn:substring(notification.content, 0, 50)}...</small>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <span class="badge" style="background: linear-gradient(135deg, #17a2b8, #20c997);">
                                                            ${notification.type}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge" style="background: linear-gradient(135deg, #6f42c1, #e83e8c);">
                                                            ${notification.recipient}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${notification.sendDate}" pattern="dd/MM/yyyy"/>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-view btn-sm btn-action" onclick="viewNotification(${notification.id})">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-edit btn-sm btn-action" onclick="editNotification(${notification.id})">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                        <button class="btn btn-delete btn-sm btn-action" onclick="deleteNotification(${notification.id}, '${fn:escapeXml(notification.title)}')">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination" id="pagination">
                                <c:if test="${currentPage > 1}">
                                    <button onclick="goToPage(${currentPage - 1})">
                                        <i class="fas fa-chevron-left"></i> Trước
                                    </button>
                                </c:if>
                                <span id="pageInfo">Trang ${currentPage} / ${totalPages}</span>
                                <c:if test="${currentPage < totalPages}">
                                    <button onclick="goToPage(${currentPage + 1})">
                                        Sau <i class="fas fa-chevron-right"></i>
                                    </button>
                                </c:if>
                            </div>
                        </c:if>

                        <!-- Create Notification Modal -->
                        <div class="modal fade create-notification-modal" id="createNotificationModal" tabindex="-1" aria-labelledby="createNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="createNotificationModalLabel"><i class="fas fa-plus-circle"></i> Tạo Thông Báo Mới</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-bell"></i> Thông Tin Thông Báo
                                                </h6>
                                                <div class="form-group">
                                                    <label for="createTitle">Tiêu đề <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="createTitle" name="title" placeholder="Nhập tiêu đề thông báo" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="createContent">Nội dung <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" id="createContent" name="content" rows="5" placeholder="Nhập nội dung thông báo" required></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="createType">Loại thông báo</label>
                                                    <select class="form-select" id="createType" name="type">
                                                        <option value="Sự kiện">Sự kiện</option>
                                                        <option value="Cập nhật khóa học">Cập nhật khóa học</option>
                                                        <option value="Thông báo hệ thống">Thông báo hệ thống</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="createRecipient">Đối tượng</label>
                                                    <select class="form-select" id="createRecipient" name="recipient">
                                                        <option value="Tất cả">Tất cả</option>
                                                        <option value="Học viên">Học viên</option>
                                                        <option value="Giảng viên">Giảng viên</option>
                                                        <option value="Điều phối viên">Điều phối viên</option>
                                                        <option value="Quản trị viên">Quản trị viên</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="createSendDate">Ngày gửi</label>
                                                    <input type="date" class="form-control" id="createSendDate" name="sendDate" />
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                            <button type="submit" class="btn btn-submit">
                                                <i class="fas fa-plus"></i> Tạo Thông Báo
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- View Notification Modal -->
                        <div class="modal fade view-notification-modal" id="viewNotificationModal" tabindex="-1" aria-labelledby="viewNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="viewNotificationModalLabel"><i class="fas fa-bell"></i> Chi Tiết Thông Báo</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-info-circle"></i> Thông Tin Thông Báo</h6>
                                            <div class="info-item">
                                                <span class="info-label">ID:</span>
                                                <span class="info-value" id="viewNotificationId"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Tiêu đề:</span>
                                                <span class="info-value" id="viewNotificationTitle"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Loại:</span>
                                                <span class="info-value" id="viewNotificationType"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Đối tượng:</span>
                                                <span class="info-value" id="viewNotificationRecipient"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày gửi:</span>
                                                <span class="info-value" id="viewNotificationSendDate"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Nội dung:</span>
                                                <span class="info-value" id="viewNotificationContent"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Đóng
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Notification Modal -->
                        <div class="modal fade edit-notification-modal" id="editNotificationModal" tabindex="-1" aria-labelledby="editNotificationModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editNotificationModalLabel"><i class="fas fa-edit"></i> Chỉnh Sửa Thông Báo</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editNotificationId" name="notificationId">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-bell"></i> Thông Tin Thông Báo
                                                </h6>
                                                <div class="form-group">
                                                    <label for="editTitle">Tiêu đề <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="editTitle" name="title" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editContent">Nội dung <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" id="editContent" name="content" rows="5" required></textarea>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editType">Loại thông báo</label>
                                                    <select class="form-select" id="editType" name="type">
                                                        <option value="Sự kiện">Sự kiện</option>
                                                        <option value="Cập nhật khóa học">Cập nhật khóa học</option>
                                                        <option value="Thông báo hệ thống">Thông báo hệ thống</option>
                                                    </select>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editRecipient">Đối tượng</label>
                                                    <select class="form-select" id="editRecipient" name="recipient">
                                                        <option value="">Tất cả</option>
                                                        <option value="Học viên" ${param.recipient == 'Học viên' ? 'selected' : ''}>Học viên</option>
                                                        <option value="Giảng viên" ${param.recipient == 'Giảng viên' ? 'selected' : ''}>Giảng viên</option>
                                                        <option value="Điều phối viên" ${param.recipient == 'Điều phối viên' ? 'selected' : ''}>Điều phối viên</option>
                                                        <option value="Quản trị viên" ${param.recipient == 'Quản trị viên' ? 'selected' : ''}>Quản trị viên</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                            <button type="submit" class="btn btn-submit">
                                                <i class="fas fa-save"></i> Cập Nhật
                                            </button>
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
                                        <h5 class="modal-title" id="deleteNotificationModalLabel"><i class="fas fa-trash"></i> Xác Nhận Xóa Thông Báo</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh Báo</h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn xóa thông báo <strong><span id="deleteNotificationTitle"></span></strong> (ID: <strong><span id="deleteNotificationId"></span></strong>)?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này không thể hoàn tác. Thông báo sẽ bị ẩn khỏi hệ thống.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Hủy
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/notifications" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" id="deleteNotificationIdInput" name="notificationId" />
                                            <button type="submit" class="btn btn-confirm-delete">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
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
                                        // Set default send date to today for create modal
                                        document.addEventListener('DOMContentLoaded', function () {
                                            const today = new Date().toISOString().split('T')[0];
                                            document.getElementById('createSendDate').value = today;

                                            // Auto-dismiss alerts after 5 seconds
                                            const alerts = document.querySelectorAll(".alert");
                                            alerts.forEach((alert) => {
                                                setTimeout(() => {
                                                    const bsAlert = new bootstrap.Alert(alert);
                                                    bsAlert.close();
                                                }, 5000);
                                            });
                                        });

                                        // JavaScript functions for modal handling
                                        function viewNotification(id) {
                                            fetch('${pageContext.request.contextPath}/admin/notifications?action=view&id=' + id)
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        document.getElementById('viewNotificationId').textContent = data.id;
                                                        document.getElementById('viewNotificationTitle').textContent = data.title;
                                                        document.getElementById('viewNotificationType').textContent = data.type;
                                                        document.getElementById('viewNotificationRecipient').textContent = data.recipient;
                                                        document.getElementById('viewNotificationSendDate').textContent = formatDate(data.sendDate);
                                                        document.getElementById('viewNotificationContent').textContent = data.content;

                                                        var modal = new bootstrap.Modal(document.getElementById('viewNotificationModal'));
                                                        modal.show();
                                                    })
                                                    .catch(error => {
                                                        console.error('Error:', error);
                                                        alert('Có lỗi xảy ra khi tải thông tin thông báo');
                                                    });
                                        }

                                        function editNotification(id) {
                                            fetch('${pageContext.request.contextPath}/admin/notifications?action=view&id=' + id)
                                                    .then(response => response.json())
                                                    .then(data => {
                                                        document.getElementById('editNotificationId').value = data.id;
                                                        document.getElementById('editTitle').value = data.title;
                                                        document.getElementById('editContent').value = data.content;
                                                        document.getElementById('editType').value = data.type;
                                                        document.getElementById('editRecipient').value = data.targetAudience;

                                                        var modal = new bootstrap.Modal(document.getElementById('editNotificationModal'));
                                                        modal.show();
                                                    })
                                                    .catch(error => {
                                                        console.error('Error:', error);
                                                        alert('Có lỗi xảy ra khi tải thông tin thông báo');
                                                    });
                                        }

                                        function deleteNotification(id, title) {
                                            document.getElementById('deleteNotificationTitle').textContent = title;
                                            document.getElementById('deleteNotificationId').textContent = id;
                                            document.getElementById('deleteNotificationIdInput').value = id;

                                            var modal = new bootstrap.Modal(document.getElementById('deleteNotificationModal'));
                                            modal.show();
                                        }

                                        function goToPage(page) {
                                            const urlParams = new URLSearchParams(window.location.search);
                                            urlParams.set('page', page);
                                            window.location.href = '${pageContext.request.contextPath}/admin/notifications?' + urlParams.toString();
                                        }

                                        function formatDate(dateString) {
                                            if (!dateString)
                                                return 'Chưa cập nhật';
                                            const date = new Date(dateString);
                                            return date.toLocaleDateString('vi-VN');
                                        }
        </script>
    </body>
</html>
