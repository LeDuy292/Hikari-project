<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <div class="header">
              <h2 class="header-title">Quản Lý Thanh Toán</h2>
              <div class="header-actions">
                <div class="user-profile">
                  <img src="img/dashborad/defaultLogoAdmin.png" alt="Ảnh Đại Diện Quản Trị" class="avatar" />
                  <div class="user-info">
                    <span class="user-name">Xin Chào, Quản Trị</span>
                    <a href="/LogoutServlet" class="logout-btn">
                      <i class="fas fa-sign-out-alt"></i>
                      Đăng Xuất
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <!-- Filter Section -->
            <div class="filter-section">
              <div class="filter-row">
                <label for="payerFilter">Người Thanh Toán:</label>
                <select class="form-select" id="payerFilter">
                  <option value="">Tất cả</option>
                  <option value="Nguyễn Văn A">Nguyễn Văn A</option>
                  <option value="Lê Văn C">Lê Văn C</option>
                  <option value="Hoàng Văn E">Hoàng Văn E</option>
                </select>
                <label for="courseFilter">Khóa Học:</label>
                <select class="form-select" id="courseFilter">
                  <option value="">Tất cả</option>
                  <option value="Tiếng Nhật Sơ Cấp N5">Tiếng Nhật Sơ Cấp N5</option>
                  <option value="Tiếng Nhật Trung Cấp N3">Tiếng Nhật Trung Cấp N3</option>
                  <option value="Tiếng Nhật Cao Cấp N1">Tiếng Nhật Cao Cấp N1</option>
                  <option value="Kanji Sơ Cấp">Kanji Sơ Cấp</option>
                  <option value="Luyện Thi JLPT N4">Luyện Thi JLPT N4</option>
                  <option value="Hội Thoại Tiếng Nhật">Hội Thoại Tiếng Nhật</option>
                  <option value="Tiếng Nhật Doanh Nghiệp">Tiếng Nhật Doanh Nghiệp</option>
                  <option value="Ngữ Pháp N3">Ngữ Pháp N3</option>
                  <option value="Kanji Cao Cấp">Kanji Cao Cấp</option>
                  <option value="Luyện Thi JLPT N2">Luyện Thi JLPT N2</option>
                </select>
                <label for="statusFilter">Trạng Thái:</label>
                <select class="form-select" id="statusFilter">
                  <option value="">Tất cả</option>
                  <option value="Thành Công">Thành Công</option>
                  <option value="Thất Bại">Thất Bại</option>
                  <option value="Đang Chờ">Đang Chờ</option>
                </select>
                <label for="paymentDateFilter">Ngày Thanh Toán:</label>
                <input type="date" class="form-control" id="paymentDateFilter" />
                <label for="minAmountFilter">Khoảng Tiền (VND):</label>
                <input type="number" class="form-control" id="minAmountFilter" placeholder="Tối thiểu" min="0" />
                <input type="number" class="form-control" id="maxAmountFilter" placeholder="Tối đa" min="0" />
              </div>
              <div class="search-row">
                <label for="search">Tìm Kiếm:</label>
                <input type="text" class="form-control" id="search" placeholder="Tìm theo ID hoặc người thanh toán..." />
              </div>
            </div>
            <!-- Payments Table -->
            <div class="table-responsive">
              <table class="table table-hover">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>AVATAR</th>
                    <th>NGƯỜI THANH TOÁN</th>
                    <th>KHÓA HỌC</th>
                    <th>SỐ TIỀN</th>
                    <th>TRẠNG THÁI</th>
                    <th>NGÀY THANH TOÁN</th>
                    <th>HÀNH ĐỘNG</th>
                  </tr>
                </thead>
                <tbody id="paymentTableBody">
                  <tr>
                    <td>PAY001</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Tiếng Nhật Sơ Cấp N5</td>
                    <td>1,500,000</td>
                    <td><span class="badge badge-success">Thành Công</span></td>
                    <td>2025-05-01</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY001" data-payer="Nguyễn Văn A" data-course="Tiếng Nhật Sơ Cấp N5" 
                              data-amount="1500000" data-status="Thành Công" data-payment-date="2025-05-01" 
                              data-payment-method="Credit Card"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY002</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Lê Văn C</td>
                    <td>Tiếng Nhật Trung Cấp N3</td>
                    <td>2,000,000</td>
                    <td><span class="badge badge-success">Thành Công</span></td>
                    <td>2025-05-02</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY002" data-payer="Lê Văn C" data-course="Tiếng Nhật Trung Cấp N3" 
                              data-amount="2000000" data-status="Thành Công" data-payment-date="2025-05-02" 
                              data-payment-method="Bank Transfer"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY003</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Hoàng Văn E</td>
                    <td>Tiếng Nhật Cao Cấp N1</td>
                    <td>2,500,000</td>
                    <td><span class="badge badge-failed">Thất Bại</span></td>
                    <td>2025-05-03</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY003" data-payer="Hoàng Văn E" data-course="Tiếng Nhật Cao Cấp N1" 
                              data-amount="2500000" data-status="Thất Bại" data-payment-date="2025-05-03" 
                              data-payment-method="Credit Card"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY004</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Kanji Sơ Cấp</td>
                    <td>1,200,000</td>
                    <td><span class="badge badge-success">Thành Công</span></td>
                    <td>2025-05-04</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY004" data-payer="Nguyễn Văn A" data-course="Kanji Sơ Cấp" 
                              data-amount="1200000" data-status="Thành Công" data-payment-date="2025-05-04" 
                              data-payment-method="Bank Transfer"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY005</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Lê Văn C</td>
                    <td>Luyện Thi JLPT N4</td>
                    <td>1,800,000</td>
                    <td><span class="badge badge-pending">Đang Chờ</span></td>
                    <td>2025-05-05</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY005" data-payer="Lê Văn C" data-course="Luyện Thi JLPT N4" 
                              data-amount="1800000" data-status="Đang Chờ" data-payment-date="2025-05-05" 
                              data-payment-method="Credit Card"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY006</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Hoàng Văn E</td>
                    <td>Hội Thoại Tiếng Nhật</td>
                    <td>1,600,000</td>
                    <td><span class="badge badge-success">Thành Công</span></td>
                    <td>2025-05-06</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY006" data-payer="Hoàng Văn E" data-course="Hội Thoại Tiếng Nhật" 
                              data-amount="1600000" data-status="Thành Công" data-payment-date="2025-05-06" 
                              data-payment-method="Bank Transfer"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY007</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Tiếng Nhật Doanh Nghiệp</td>
                    <td>2,200,000</td>
                    <td><span class="badge badge-success">Thành Công</span></td>
                    <td>2025-05-07</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY007" data-payer="Nguyễn Văn A" data-course="Tiếng Nhật Doanh Nghiệp" 
                              data-amount="2200000" data-status="Thành Công" data-payment-date="2025-05-07" 
                              data-payment-method="Credit Card"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY008</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Lê Văn C</td>
                    <td>Ngữ Pháp N3</td>
                    <td>1,900,000</td>
                    <td><span class="badge badge-failed">Thất Bại</span></td>
                    <td>2025-05-08</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY008" data-payer="Lê Văn C" data-course="Ngữ Pháp N3" 
                              data-amount="1900000" data-status="Thất Bại" data-payment-date="2025-05-08" 
                              data-payment-method="Bank Transfer"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY009</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Hoàng Văn E</td>
                    <td>Kanji Cao Cấp</td>
                    <td>2,300,000</td>
                    <td><span class="badge badge-success">Thành Công</span></td>
                    <td>2025-05-09</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY009" data-payer="Hoàng Văn E" data-course="Kanji Cao Cấp" 
                              data-amount="2300000" data-status="Thành Công" data-payment-date="2025-05-09" 
                              data-payment-method="Credit Card"><i class="fas fa-eye"></i></button>
                    </td>
                  </tr>
                  <tr>
                    <td>PAY010</td>
                    <td><img src="img/dashborad/defaultAvatar.png" alt="Avatar" class="table-avatar" /></td>
                    <td>Nguyễn Văn A</td>
                    <td>Luyện Thi JLPT N2</td>
                    <td>2,400,000</td>
                    <td><span class="badge badge-pending">Đang Chờ</span></td>
                    <td>2025-05-10</td>
                    <td class="actions">
                      <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewPaymentModal" 
                              data-payment-id="PAY010" data-payer="Nguyễn Văn A" data-course="Luyện Thi JLPT N2" 
                              data-amount="2400000" data-status="Đang Chờ" data-payment-date="2025-05-10" 
                              data-payment-method="Bank Transfer"><i class="fas fa-eye"></i></button>
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
                        <span class="info-value" id="viewPayer"></span>
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
                    <div class="section">
                      <h6 class="section-title"><i class="fas fa-book"></i> Thông Tin Khóa Học</h6>
                      <div class="info-item">
                        <span class="info-label">Khóa Học:</span>
                        <span class="info-value" id="viewCourse"></span>
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
    <script src="${pageContext.request.contextPath}/js/dashboard/admin/manaPayments.js"></script>

  </body>
</html>
