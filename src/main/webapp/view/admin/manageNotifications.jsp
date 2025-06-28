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
                        <!-- Replace the header section with: -->
                        <jsp:include page="headerAdmin.jsp">
                            <jsp:param name="pageTitle" value="Quản Lý Thông Báo"/>
                            <jsp:param name="showAddButton" value="true"/>
                            <jsp:param name="addButtonText" value="Thêm Thông Báo"/>
                            <jsp:param name="addModalTarget" value="createNotificationModal"/>
                            <jsp:param name="showNotification" value="false"/>
                        </jsp:include>
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
                                <!-- Update table to use JSTL -->
                                <tbody id="notificationTableBody">
                                    <c:forEach var="notification" items="${notifications}">
                                        <tr data-notification-id="${notification.id}">
                                            <td>NOT${String.format("%03d", notification.id)}</td>
                                            <td>${notification.title}</td>
                                            <td>${notification.type}</td>
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
                                            <td><fmt:formatDate value="${notification.sendDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <button class="btn btn-view btn-sm btn-action" 
                                                        onclick="viewNotification(${notification.id})">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-edit btn-sm btn-action" 
                                                        onclick="editNotification(${notification.id})">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-delete btn-sm btn-action" 
                                                        onclick="deleteNotification(${notification.id})">
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
                                    <!-- Update form actions -->
                                    <form id="createNotificationForm" action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                        <input type="hidden" name="action" value="add">
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
                                    <form id="editNotificationForm" action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editNotificationId" name="notificationId">
                                        <div class="modal-body">
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
                                        <form action="${pageContext.request.contextPath}/admin/notifications" method="POST">
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
            document.getElementById('modalSendDate').textContent = new Date(data.sendDate).toLocaleDateString('vi-VN');
            document.getElementById('modalRecipient').textContent = data.recipient;
            
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

function deleteNotification(notificationId) {
    fetch('${pageContext.request.contextPath}/admin/notifications?action=view&id=' + notificationId)
        .then(response => response.json())
        .then(data => {
            document.getElementById('blockNotificationId').textContent = 'NOT' + String(data.id).padStart(3, '0');
            document.getElementById('blockTitle').textContent = data.title;
            document.getElementById('deleteNotificationIdInput').value = data.id;
            
            var modal = new bootstrap.Modal(document.getElementById('blockNotificationModal'));
            modal.show();
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi tải thông tin thông báo');
        });
}
</script>
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaNotifications.js"></script>
    </body>
</html>
