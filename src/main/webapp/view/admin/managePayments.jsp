<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Thanh Toán - HIKARI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/admin/manaPayments.css" rel="stylesheet" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Include Sidebar -->
                <%@ include file="sidebar.jsp" %>
                <div class="main-content">
                    <div class="content-wrapper">
                        <%                  
                            request.setAttribute("pageTitle", "Quản Lý Thanh Toán");
                            request.setAttribute("showAddButton", false);
                            request.setAttribute("pageIcon", "fa-credit-card");
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
                            <form action="${pageContext.request.contextPath}/admin/payments" method="GET" class="filter-form">
                                <div class="filter-group">
                                    <label for="statusFilter">
                                        <i class="fas fa-toggle-on"></i> Trạng Thái:
                                    </label>
                                    <select class="form-select" id="statusFilter" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="Completed" ${param.status == 'Completed' ? 'selected' : ''}>Thành Công</option>
                                        <option value="Failed" ${param.status == 'Failed' ? 'selected' : ''}>Thất Bại</option>
                                        <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Đang Chờ</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="paymentDateFilter">
                                        <i class="fas fa-calendar-alt"></i> Ngày Thanh Toán:
                                    </label>
                                    <input type="date" class="form-control" id="paymentDateFilter" name="date" value="${param.date}" />
                                </div>
                                <div class="filter-group">
                                    <label for="minAmountFilter">
                                        <i class="fas fa-money-bill"></i> Từ Số Tiền:
                                    </label>
                                    <input type="number" class="form-control" id="minAmountFilter" name="minAmount" placeholder="VND" min="0" value="${param.minAmount}" />
                                </div>
                                <div class="filter-group">
                                    <label for="maxAmountFilter">
                                        <i class="fas fa-money-bill-wave"></i> Đến Số Tiền:
                                    </label>
                                    <input type="number" class="form-control" id="maxAmountFilter" name="maxAmount" placeholder="VND" min="0" value="${param.maxAmount}" />
                                </div>
                                <div class="filter-group">
                                    <label for="searchFilter">
                                        <i class="fas fa-search"></i> Tìm Kiếm:
                                    </label>
                                    <input type="text" class="form-control" id="searchFilter" name="search" placeholder="ID, người thanh toán..." value="${param.search}" />
                                </div>
                                <div class="filter-actions">
                                    <button type="submit" class="btn btn-filter">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/payments" class="btn btn-reset">
                                        <i class="fas fa-refresh"></i> Đặt Lại
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Payments Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-hashtag"></i> ID</th>
                                        <th><i class="fas fa-user"></i> NGƯỜI THANH TOÁN</th>
                                        <th><i class="fas fa-book"></i> KHÓA HỌC</th>
                                        <th><i class="fas fa-money-bill"></i> SỐ TIỀN</th>
                                        <th><i class="fas fa-toggle-on"></i> TRẠNG THÁI</th>
                                        <th><i class="fas fa-calendar-alt"></i> NGÀY THANH TOÁN</th>
                                        <th><i class="fas fa-cogs"></i> HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="payment" items="${payments}">
                                        <tr>
                                            <td><strong>PAY${String.format("%03d", payment.id)}</strong></td>
                                            <td><strong>${payment.studentName}</strong></td>
                                            <td>${payment.courseName}</td>
                                            <td>
                                                <span class="badge" style="background: linear-gradient(135deg, #28a745, #34ce57);">
                                                    <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.paymentStatus.toLowerCase() == 'completed'}">
                                                        <span class="badge badge-active">
                                                            <i class="fas fa-check-circle"></i> Thành Công
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${payment.paymentStatus.toLowerCase() == 'failed'}">
                                                        <span class="badge badge-inactive">
                                                            <i class="fas fa-times-circle"></i> Thất Bại
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge" style="background: linear-gradient(135deg, #f39c12, #ffb347);">
                                                            <i class="fas fa-clock"></i> Đang Chờ
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <button class="btn btn-view btn-sm btn-action" onclick="viewPayment(${payment.id})">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <c:if test="${payment.paymentStatus == 'Pending'}">
                                                    <button class="btn btn-edit btn-sm btn-action" onclick="updatePaymentStatus(${payment.id}, 'Completed')" title="Duyệt thanh toán">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                    <button class="btn btn-delete btn-sm btn-action" onclick="updatePaymentStatus(${payment.id}, 'Failed')" title="Từ chối thanh toán">
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination" id="pagination">
                            <button id="prevPage" ${currentPage <= 1 ? 'disabled' : ''} onclick="goToPage(${currentPage - 1})">
                                <i class="fas fa-chevron-left"></i> Trước
                            </button>
                            <span id="pageInfo">Trang ${currentPage} / ${totalPages}</span>
                            <button id="nextPage" ${currentPage >= totalPages ? 'disabled' : ''} onclick="goToPage(${currentPage + 1})">
                                Sau <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>

                        <!-- View Payment Modal -->
                        <div class="modal fade view-payment-modal" id="viewPaymentModal" tabindex="-1" aria-labelledby="viewPaymentModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="viewPaymentModalLabel"><i class="fas fa-credit-card"></i> Chi Tiết Thanh Toán</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-money-bill"></i> Thông Tin Thanh Toán</h6>
                                            <div class="info-item">
                                                <span class="info-label">ID Thanh Toán:</span>
                                                <span class="info-value" id="viewPaymentId"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Người Thanh Toán:</span>
                                                <span class="info-value" id="viewStudentName"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Số Tiền:</span>
                                                <span class="info-value" id="viewAmount"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Trạng Thái:</span>
                                                <span class="info-value" id="viewStatus"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Phương Thức:</span>
                                                <span class="info-value" id="viewPaymentMethod"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày Thanh Toán:</span>
                                                <span class="info-value" id="viewPaymentDate"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Mã Giao Dịch:</span>
                                                <span class="info-value" id="viewTransactionID"></span>
                                            </div>
                                        </div>
                                        <div class="section">
                                            <h6 class="section-title"><i class="fas fa-book"></i> Thông Tin Khóa Học</h6>
                                            <div class="info-item">
                                                <span class="info-label">Khóa Học:</span>
                                                <span class="info-value" id="viewCourseName"></span>
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
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            function viewPayment(paymentId) {
                fetch('${pageContext.request.contextPath}/admin/payments?action=view&id=' + paymentId)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('viewPaymentId').textContent = 'PAY' + String(data.id).padStart(3, '0');
                        document.getElementById('viewStudentName').textContent = data.studentName;
                        document.getElementById('viewAmount').textContent = new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(data.amount);
                        document.getElementById('viewStatus').innerHTML = '<span class="badge badge-' + data.paymentStatus.toLowerCase() + '">' + data.paymentStatus + '</span>';
                        document.getElementById('viewPaymentMethod').textContent = data.paymentMethod;
                        document.getElementById('viewPaymentDate').textContent = new Date(data.paymentDate).toLocaleDateString('vi-VN');
                        document.getElementById('viewTransactionID').textContent = data.transactionID || 'N/A';
                        document.getElementById('viewCourseName').textContent = data.courseName;

                        var modal = new bootstrap.Modal(document.getElementById('viewPaymentModal'));
                        modal.show();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi tải thông tin thanh toán');
                    });
            }

            function updatePaymentStatus(paymentId, status) {
                if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái thanh toán?')) {
                    const formData = new FormData();
                    formData.append('action', 'updateStatus');
                    formData.append('paymentId', paymentId);
                    formData.append('status', status);

                    fetch('${pageContext.request.contextPath}/admin/payments', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => {
                        if (response.ok) {
                            location.reload();
                        } else {
                            alert('Có lỗi xảy ra khi cập nhật trạng thái');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Có lỗi xảy ra khi cập nhật trạng thái');
                    });
                }
            }

            function goToPage(page) {
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('page', page);
                window.location.href = '${pageContext.request.contextPath}/admin/payments?' + urlParams.toString();
            }

            // Auto-dismiss alerts after 5 seconds
            document.addEventListener('DOMContentLoaded', function() {
                const alerts = document.querySelectorAll(".alert");
                alerts.forEach((alert) => {
                    setTimeout(() => {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }, 5000);
                });
            });
        </script>
    </body>
</html>
