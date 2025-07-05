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
                        <%
                            request.setAttribute("pageTitle", "Quản Lý Thông Báo");
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
                                                        <strong>${fn:escapeXml(notification.title)}</strong>
                                                        <c:if test="${fn:length(notification.content) > 50}">
                                                            <br><small class="text-muted">${fn:escapeXml(fn:substring(notification.content, 0, 50))}...</small>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <span class="badge" style="background: linear-gradient(135deg, #17a2b8, #20c997);">
                                                            ${fn:escapeXml(notification.type)}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge" style="background: linear-gradient(135deg, #6f42c1, #e83e8c);">
                                                            ${fn:escapeXml(notification.recipient)}
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
                                    <form id="createNotificationForm" action="${pageContext.request.contextPath}/admin/notifications" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-bell"></i> Thông Tin Thông Báo
                                                </h6>
                                                <div class="form-group">
                                                    <label for="createTitle">Tiêu đề <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="createTitle" name="title" placeholder="Nhập tiêu đề thông báo" required />
                                                    <div class="invalid-feedback">Tiêu đề không được để trống.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="createContent">Nội dung <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" id="createContent" name="content" rows="5" placeholder="Nhập nội dung thông báo" required maxlength="1000"></textarea>
                                                    <small class="text-muted" style="float: right;">0/1000 ký tự</small>
                                                    <div class="invalid-feedback">Nội dung không được để trống.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="createType">Loại thông báo <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="createType" name="type" required>
                                                        <option value="" disabled selected>Chọn loại thông báo</option>
                                                        <option value="Sự kiện">Sự kiện</option>
                                                        <option value="Cập nhật khóa học">Cập nhật khóa học</option>
                                                        <option value="Thông báo hệ thống">Thông báo hệ thống</option>
                                                    </select>
                                                    <div class="invalid-feedback">Vui lòng chọn loại thông báo.</div>
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
                                                    <div class="invalid-feedback">Ngày gửi không thể là ngày trong quá khứ.</div>
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
                                    <form id="editNotificationForm" action="${pageContext.request.contextPath}/admin/notifications" method="POST">
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
                                                    <div class="invalid-feedback">Tiêu đề không được để trống.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editContent">Nội dung <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" id="editContent" name="content" rows="5" required maxlength="1000"></textarea>
                                                    <small class="text-muted" style="float: right;">0/1000 ký tự</small>
                                                    <div class="invalid-feedback">Nội dung không được để trống.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editType">Loại thông báo <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="editType" name="type" required>
                                                        <option value="" disabled>Chọn loại thông báo</option>
                                                        <option value="Sự kiện">Sự kiện</option>
                                                        <option value="Cập nhật khóa học">Cập nhật khóa học</option>
                                                        <option value="Thông báo hệ thống">Thông báo hệ thống</option>
                                                    </select>
                                                    <div class="invalid-feedback">Vui lòng chọn loại thông báo.</div>
                                                </div>
                                                <div class="form-group">
                                                    <label for="editRecipient">Đối tượng</label>
                                                    <select class="form-select" id="editRecipient" name="recipient">
                                                        <option value="Tất cả">Tất cả</option>
                                                        <option value="Học viên">Học viên</option>
                                                        <option value="Giảng viên">Giảng viên</option>
                                                        <option value="Điều phối viên">Điều phối viên</option>
                                                        <option value="Quản trị viên">Quản trị viên</option>
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

                // Form validation for Create and Edit Notification Forms
                const forms = document.querySelectorAll("#createNotificationForm, #editNotificationForm");
                forms.forEach((form) => {
                    form.addEventListener("submit", (e) => {
                        let isValid = true;
                        const title = form.querySelector('input[name="title"]');
                        const content = form.querySelector('textarea[name="content"]');
                        const type = form.querySelector('select[name="type"]');

                        // Reset validation states
                        [title, content, type].forEach(field => {
                            field.classList.remove('is-invalid');
                        });

                        // Title validation
                        if (!title.value.trim()) {
                            title.classList.add('is-invalid');
                            isValid = false;
                        }

                        // Content validation
                        if (!content.value.trim()) {
                            content.classList.add('is-invalid');
                            isValid = false;
                        }

                        // Type validation
                        if (!type.value.trim()) {
                            type.classList.add('is-invalid');
                            isValid = false;
                        }

                        if (!isValid) {
                            e.preventDefault();
                            alert('Vui lòng điền đầy đủ thông tin bắt buộc.');
                        }
                    });
                });

                // Character count for content textarea
                const contentTextareas = document.querySelectorAll('textarea[name="content"]');
                contentTextareas.forEach((textarea) => {
                    const maxLength = 1000;
                    const counter = textarea.nextElementSibling;
                    function updateCounter() {
                        const remaining = maxLength - textarea.value.length;
                        counter.textContent = `${textarea.value.length}/${maxLength} ký tự`;
                        if (remaining < 50) {
                            counter.className = "text-warning";
                        } else if (remaining < 0) {
                            counter.className = "text-danger";
                        } else {
                            counter.className = "text-muted";
                        }
                    }
                    textarea.addEventListener("input", updateCounter);
                    updateCounter(); // Initial count
                });

                // Date validation for send date
                const sendDateInputs = document.querySelectorAll('input[name="sendDate"]');
                sendDateInputs.forEach((input) => {
                    const today = new Date().toISOString().split("T")[0];
                    input.min = today;
                    input.addEventListener("change", function () {
                        if (this.value && this.value < today) {
                            this.classList.add('is-invalid');
                            alert("Ngày gửi không thể là ngày trong quá khứ");
                            this.value = today;
                        } else {
                            this.classList.remove('is-invalid');
                        }
                    });
                });

                // Auto-resize textareas
                const textareas = document.querySelectorAll("textarea");
                textareas.forEach((textarea) => {
                    textarea.addEventListener("input", function () {
                        this.style.height = "auto";
                        this.style.height = this.scrollHeight + "px";
                    });
                });

                // Modal cleanup
                document.addEventListener("hidden.bs.modal", (event) => {
                    const backdrops = document.querySelectorAll(".modal-backdrop");
                    backdrops.forEach((backdrop) => backdrop.remove());
                    document.body.classList.remove("modal-open");
                    document.body.style.paddingRight = "";
                    document.body.style.overflow = "";
                    // Reset form validation states
                    const form = event.target.querySelector('form');
                    if (form) {
                        form.querySelectorAll('.is-invalid').forEach(field => field.classList.remove('is-invalid'));
                    }
                });

                // Focus on first input in modal
                document.addEventListener("shown.bs.modal", (event) => {
                    const modal = event.target;
                    const firstInput = modal.querySelector('input:not([type="hidden"]), textarea, select');
                    if (firstInput) {
                        setTimeout(() => firstInput.focus(), 100);
                    }
                });
            });

            // JavaScript functions for modal handling
            function viewNotification(id) {
                fetch('${pageContext.request.contextPath}/admin/notifications?action=view&id=' + encodeURIComponent(id))
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Lỗi khi tải thông tin thông báo');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.error) {
                            throw new Error(data.error);
                        }
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
                        alert('Có lỗi xảy ra khi tải thông tin thông báo: ' + error.message);
                    });
            }

            function editNotification(id) {
                fetch('${pageContext.request.contextPath}/admin/notifications?action=view&id=' + encodeURIComponent(id))
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Lỗi khi tải thông tin thông báo');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.error) {
                            throw new Error(data.error);
                        }
                        document.getElementById('editNotificationId').value = data.id;
                        document.getElementById('editTitle').value = data.title;
                        document.getElementById('editContent').value = data.content;
                        document.getElementById('editType').value = data.type;
                        document.getElementById('editRecipient').value = data.recipient || 'Tất cả';

                        var modal = new bootstrap.Modal(document.getElementById('editNotificationModal'));
                        modal.show();

                        // Update character counter for editContent
                        const editContent = document.getElementById('editContent');
                        editContent.dispatchEvent(new Event('input'));
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi tải thông tin thông báo: ' + error.message);
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
                if (!dateString) return 'Chưa cập nhật';
                const date = new Date(dateString);
                return date.toLocaleDateString('vi-VN');
            }
        </script>
    </body>
</html>