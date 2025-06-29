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
                            request.setAttribute("showAddButton", true);
                            request.setAttribute("addBtnIcon", "fa-plus");
                            request.setAttribute("pageIcon", "fa-bell");
                            request.setAttribute("showNotification", false);
                        %>
                        <%@ include file="headerAdmin.jsp" %>F

                        <!-- Filter Section -->
                        <div class="filter-section">
                            <div class="filter-row">
                                <label for="statusFilter">Trạng Thái:</label>
                                <select class="form-select" id="statusFilter" onchange="filterPayments()">
                                    <option value="">Tất cả</option>
                                    <option value="Completed">Thành Công</option>
                                    <option value="Failed">Thất Bại</option>
                                    <option value="Pending">Đang Chờ</option>
                                </select>
                                <label for="paymentDateFilter">Ngày Thanh Toán:</label>
                                <input type="date" class="form-control" id="paymentDateFilter" onchange="filterPayments()" />
                                <label for="minAmountFilter">Khoảng Tiền (VND):</label>
                                <input type="number" class="form-control" id="minAmountFilter" placeholder="Tối thiểu" min="0" onchange="filterPayments()" />
                                <input type="number" class="form-control" id="maxAmountFilter" placeholder="Tối đa" min="0" onchange="filterPayments()" />
                            </div>
                            <div class="search-row">
                                <label for="search">Tìm Kiếm:</label>
                                <input type="text" class="form-control" id="search" placeholder="Tìm theo ID hoặc người thanh toán..." onkeyup="filterPayments()" />
                            </div>
                        </div>

                        <!-- Payments Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>NGƯỜI THANH TOÁN</th>
                                        <th>KHÓA HỌC</th>
                                        <th>SỐ TIỀN</th>
                                        <th>TRẠNG THÁI</th>
                                        <th>NGÀY THANH TOÁN</th>
                                        <th>HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody id="paymentTableBody">
                                    <c:forEach var="payment" items="${payments}">
                                        <tr>
                                            <td>PAY${String.format("%03d", payment.id)}</td>
                                            <td>${payment.studentName}</td>
                                            <td>${payment.courseName}</td>
                                            <td><fmt:formatNumber value="${payment.amount}" type="currency" currencySymbol="₫"/></td>
                                            <td>
                                                <span class="badge badge-${payment.paymentStatus.toLowerCase() == 'completed' ? 'success' : (payment.paymentStatus.toLowerCase() == 'failed' ? 'failed' : 'pending')}">
                                                    ${payment.paymentStatus}
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${payment.paymentDate}" pattern="dd/MM/yyyy"/></td>
                                            <td class="actions">
                                                <button class="btn btn-view btn-sm btn-action" onclick="viewPayment(${payment.id})">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <c:if test="${payment.paymentStatus == 'Pending'}">
                                                    <button class="btn btn-edit btn-sm btn-action" onclick="updatePaymentStatus(${payment.id}, 'Completed')">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                    <button class="btn btn-delete btn-sm btn-action" onclick="updatePaymentStatus(${payment.id}, 'Failed')">
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
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}" class="btn btn-outline-primary">Trước</a>
                            </c:if>
                            <span>Trang ${currentPage} / ${totalPages}</span>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}" class="btn btn-outline-primary">Sau</a>
                            </c:if>
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
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Đóng</button>
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

                                  function filterPayments() {
                                      // Client-side filtering logic can be implemented here
                                      // For now, we'll reload the page with filter parameters
                                      const status = document.getElementById('statusFilter').value;
                                      const date = document.getElementById('paymentDateFilter').value;
                                      const minAmount = document.getElementById('minAmountFilter').value;
                                      const maxAmount = document.getElementById('maxAmountFilter').value;
                                      const search = document.getElementById('search').value;

                                      let url = '${pageContext.request.contextPath}/admin/payments?';
                                      if (status)
                                          url += 'status=' + encodeURIComponent(status) + '&';
                                      if (date)
                                          url += 'date=' + encodeURIComponent(date) + '&';
                                      if (minAmount)
                                          url += 'minAmount=' + encodeURIComponent(minAmount) + '&';
                                      if (maxAmount)
                                          url += 'maxAmount=' + encodeURIComponent(maxAmount) + '&';
                                      if (search)
                                          url += 'search=' + encodeURIComponent(search) + '&';

                                      window.location.href = url;
                                  }
        </script>
    </body>
</html>
