<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="contextPath" content="${pageContext.request.contextPath}" />
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
                                        <option value="Complete" ${param.status == 'Complete' ? 'selected' : ''}>Thành Công</option>
                                        <option value="Cancel" ${param.status == 'Cancel' ? 'selected' : ''}>Đã Hủy</option>
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
                                    <input type="text" class="form-control" id="searchFilter" name="search" placeholder="ID, người thanh toán, khóa học..." value="${param.search}" />
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

                        <!-- Bulk Actions -->
                        <div id="bulkActionsBar" class="bulk-actions-bar" style="display: none;">
                            <div class="d-flex align-items-center gap-3">
                                <span class="bulk-info">
                                    <i class="fas fa-check-square me-1"></i>
                                    <span id="selectedCount">0</span> mục đã chọn
                                </span>
                                <button type="button" class="btn btn-primary btn-sm" onclick="exportSelected()">
                                    <i class="fas fa-download me-1"></i>Xuất Dữ Liệu
                                </button>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="clearSelection()">
                                    <i class="fas fa-times me-1"></i>Hủy Chọn
                                </button>
                            </div>
                        </div>

                        <!-- Payments Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><input type="checkbox" id="selectAll" class="form-check-input"></th>
                                        <th class="sortable" data-sort="id">ID <i class="fas fa-sort"></i></th>
                                        <th>Học Viên</th>
                                        <th>Khóa Học</th>
                                        <th class="sortable" data-sort="amount">Số Tiền <i class="fas fa-sort"></i></th>
                                        <th>Phương Thức</th>
                                        <th>Trạng Thái</th>
                                        <th class="sortable" data-sort="date">Ngày Thanh Toán <i class="fas fa-sort"></i></th>
                                        <th>Hành Động</th>
                                    </tr>
                                </thead>
                                <tbody id="paymentTableBody">
                                    <c:forEach var="payment" items="${payments}">
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="selectedPayments" value="${payment.id}" class="form-check-input payment-checkbox">
                                            </td>
                                            <td>#${payment.id}</td>
                                            <td>
                                                <div class="student-info">
                                                    <strong>${payment.studentName}</strong>
                                                    <br><small class="text-muted">${payment.studentID}</small>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="course-info">
                                                    <c:choose>
                                                        <c:when test="${not empty payment.courseNames}">
                                                            ${payment.courseNames}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa có khóa học</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="payment-amount">
                                                    <fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="payment-method">
                                                    <c:choose>
                                                        <c:when test="${payment.paymentMethod == 'Credit Card'}">
                                                            <i class="fas fa-credit-card text-primary"></i> Thẻ tín dụng
                                                        </c:when>
                                                        <c:when test="${payment.paymentMethod == 'Bank Transfer'}">
                                                            <i class="fas fa-university text-info"></i> Chuyển khoản
                                                        </c:when>
                                                        <c:when test="${payment.paymentMethod == 'E-Wallet'}">
                                                            <i class="fas fa-wallet text-success"></i> Ví điện tử
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-money-bill text-secondary"></i> ${payment.paymentMethod}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${payment.paymentStatus == 'Complete'}">
                                                        <span class="badge bg-success">
                                                            <i class="fas fa-check"></i> Hoàn thành
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${payment.paymentStatus == 'Cancel'}">
                                                        <span class="badge bg-danger">
                                                            <i class="fas fa-times"></i> Đã hủy
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning">
                                                            <i class="fas fa-clock"></i> Đang xử lý
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <div class="btn-group" role="group">
                                                    <button class="btn btn-view btn-sm btn-action" onclick="viewPayment(${payment.id})" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button class="btn btn-secondary btn-sm btn-action" onclick="exportPayment(${payment.id})" title="Xuất hóa đơn">
                                                        <i class="fas fa-download"></i>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            
                            <!-- No data message -->
                            <c:if test="${empty payments}">
                                <div class="text-center py-5">
                                    <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Không có thanh toán nào</h5>
                                    <p class="text-muted">Không tìm thấy thanh toán phù hợp với tiêu chí lọc.</p>
                                </div>
                            </c:if>
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
                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="viewPaymentModalLabel">
                                            <i class="fas fa-credit-card"></i> Chi Tiết Thanh Toán
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="section">
                                                    <h6 class="section-title">
                                                        <i class="fas fa-money-bill"></i> Thông Tin Thanh Toán
                                                    </h6>
                                                    <div class="info-item">
                                                        <span class="info-label">ID Thanh Toán:</span>
                                                        <span class="info-value" id="viewPaymentId"></span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Mã Giao Dịch:</span>
                                                        <span class="info-value" id="viewTransactionID"></span>
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
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="section">
                                                    <h6 class="section-title">
                                                        <i class="fas fa-user"></i> Thông Tin Học Viên
                                                    </h6>
                                                    <div class="info-item">
                                                        <span class="info-label">Tên Học Viên:</span>
                                                        <span class="info-value" id="viewStudentName"></span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Mã Học Viên:</span>
                                                        <span class="info-value" id="viewStudentID"></span>
                                                    </div>
                                                </div>
                                                <div class="section">
                                                    <h6 class="section-title">
                                                        <i class="fas fa-book"></i> Thông Tin Khóa Học
                                                    </h6>
                                                    <div class="info-item">
                                                        <span class="info-label">Khóa Học:</span>
                                                        <span class="info-value" id="viewCourseName"></span>
                                                    </div>
                                                    <div class="info-item">
                                                        <span class="info-label">Mã Khóa Học:</span>
                                                        <span class="info-value" id="viewCourseIDs"></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="section mt-3">
                                            <h6 class="section-title">
                                                <i class="fas fa-info-circle"></i> Thông Tin Bổ Sung
                                            </h6>
                                            <div class="info-item">
                                                <span class="info-label">Ghi Chú:</span>
                                                <span class="info-value" id="viewNote">Không có ghi chú</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" onclick="downloadPaymentInvoice()">
                                            <i class="fas fa-download"></i> Tải Hóa Đơn
                                        </button>
                                        <button type="button" class="btn btn-primary" onclick="printPaymentDetails()">
                                            <i class="fas fa-print"></i> In Chi Tiết
                                        </button>
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
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaPayments.js"></script>
    </body>
</html>