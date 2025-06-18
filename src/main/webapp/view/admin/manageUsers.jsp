    <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Quản Lý Tài Khoản - HIKARI</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/admin/manaUser.css" rel="stylesheet" />
      </head>
      <body>
        <div class="container-fluid">
          <div class="row">
        <%@ include file="sidebar.jsp" %>
            <div class="main-content">
              <div class="content-wrapper">
                <div class="header">
                  <h2 class="header-title">Quản Lý Tài Khoản</h2>
                  <div class="header-actions">
                    <button class="btn-add-user" data-bs-toggle="modal" data-bs-target="#addUserModal">
                      <i class="fas fa-plus"></i> Thêm
                    </button>
                    <div class="notification">
                      <button class="btn-notification" data-bs-toggle="modal" data-bs-target="#notificationModal">
                        <i class="fas fa-bell"></i>
                        <span class="notification-count" id="notificationCount">2</span>
                      </button>
                    </div>
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
                  <label for="roleFilter">Vai Trò:</label>
                  <select class="form-select" id="roleFilter">
                    <option value="">Tất cả</option>
                    <option value="Học Viên">Học Viên</option>
                    <option value="Giảng Viên">Giảng Viên</option>
                    <option value="Quản Trị">Quản Trị</option>
                  </select>
                  <label for="statusFilter">Trạng Thái:</label>
                  <select class="form-select" id="statusFilter">
                    <option value="">Tất cả</option>
                    <option value="Hoạt Động">Hoạt Động</option>
                    <option value="Khóa">Khóa</option>
                  </select>
                  <label for="createdDateFilter">Ngày Tạo:</label>
                  <input type="date" class="form-control" id="createdDateFilter" />
                  <label for="courseFilter">Số Khóa Học:</label>
                  <input type="number" class="form-control" id="courseFilter" min="0" value="0" />
                  <label for="nameSearch">Tìm Tên:</label>
                  <input type="text" class="form-control" id="nameSearch" placeholder="Tìm theo tên..." />
                </div>
                <!-- Users Table -->
                <div class="table-responsive">
                  <table class="table table-hover">
                    <thead>
                      <tr>
                        <th>ID</th>
                        <th>AVATAR</th>
                        <th>HỌ TÊN</th>
                        <th>USERNAME</th>
                        <th>EMAIL</th>
                        <th>VAI TRÒ</th>
                        <th>TRẠNG THÁI</th>
                        <th>SỐ KHÓA HỌC</th>
                        <th>NGÀY TẠO</th>
                        <th>HÀNH ĐỘNG</th>
                      </tr>
                    </thead>
                    <tbody id="userTableBody">
                      <tr>
                        <td>USR001</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Nguyễn Văn A</td>
                        <td>nguyenvana</td>
                        <td>nguyenvana@example.com</td>
                        <td>Học Viên</td>
                        <td><span class="badge badge-active">Hoạt Động</span></td>
                        <td>3</td>
                        <td>2025-05-01</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR001" data-full-name="Nguyễn Văn A" data-username="nguyenvana" 
                                  data-email="nguyenvana@example.com" data-role="Học Viên" data-status="Hoạt Động" 
                                  data-courses="3" data-created-date="2025-05-01"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR001" data-full-name="Nguyễn Văn A" data-username="nguyenvana" 
                                  data-email="nguyenvana@example.com" data-role="Học Viên" data-status="Hoạt Động"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR001" data-full-name="Nguyễn Văn A" data-status="Hoạt Động"><i class="fas fa-lock"></i></button>
                        </td>
                      </tr>
                      <!-- Repeat similar updates for other table rows -->
                      <tr>
                        <td>USR002</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Trần Thị B</td>
                        <td>tranb</td>
                        <td>tranb@example.com</td>
                        <td>Giảng Viên</td>
                        <td><span class="badge badge-active">Hoạt Động</span></td>
                        <td>2</td>
                        <td>2025-05-02</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR002" data-full-name="Trần Thị B" data-username="tranb" 
                                  data-email="tranb@example.com" data-role="Giảng Viên" data-status="Hoạt Động" 
                                  data-courses="2" data-created-date="2025-05-02"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR002" data-full-name="Trần Thị B" data-username="tranb" 
                                  data-email="tranb@example.com" data-role="Giảng Viên" data-status="Hoạt Động"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR002" data-full-name="Trần Thị B" data-status="Hoạt Động"><i class="fas fa-lock"></i></button>
                        </td>
                      </tr>
                      <tr>
                        <td>USR003</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Lê Văn C</td>
                        <td>levanc</td>
                        <td>levanc@example.com</td>
                        <td>Học Viên</td>
                        <td><span class="badge badge-inactive">Khóa</span></td>
                        <td>1</td>
                        <td>2025-05-03</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR003" data-full-name="Lê Văn C" data-username="levanc" 
                                  data-email="levanc@example.com" data-role="Học Viên" data-status="Khóa" 
                                  data-courses="1" data-created-date="2025-05-03"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR003" data-full-name="Lê Văn C" data-username="levanc" 
                                  data-email="levanc@example.com" data-role="Học Viên" data-status="Khóa"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR003" data-full-name="Lê Văn C" data-status="Khóa"><i class="fas fa-unlock"></i></button>
                        </td>
                      </tr>
                      <!-- Add similar updates for remaining rows -->
                      <tr>
                        <td>USR004</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Phạm Thị D</td>
                        <td>phamd</td>
                        <td>phamd@example.com</td>
                        <td>Quản Trị</td>
                        <td><span class="badge badge-active">Hoạt Động</span></td>
                        <td>0</td>
                        <td>2025-05-04</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR004" data-full-name="Phạm Thị D" data-username="phamd" 
                                  data-email="phamd@example.com" data-role="Quản Trị" data-status="Hoạt Động" 
                                  data-courses="0" data-created-date="2025-05-04"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR004" data-full-name="Phạm Thị D" data-username="phamd" 
                                  data-email="phamd@example.com" data-role="Quản Trị" data-status="Hoạt Động"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR004" data-full-name="Phạm Thị D" data-status="Hoạt Động"><i class="fas fa-lock"></i></button>
                        </td>
                      </tr>
                      <tr>
                        <td>USR005</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Hoàng Văn E</td>
                        <td>hoange</td>
                        <td>hoange@example.com</td>
                        <td>Học Viên</td>
                        <td><span class="badge badge-active">Hoạt Động</span></td>
                        <td>4</td>
                        <td>2025-05-05</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR005" data-full-name="Hoàng Văn E" data-username="hoange" 
                                  data-email="hoange@example.com" data-role="Học Viên" data-status="Hoạt Động" 
                                  data-courses="4" data-created-date="2025-05-05"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR005" data-full-name="Hoàng Văn E" data-username="hoange" 
                                  data-email="hoange@example.com" data-role="Học Viên" data-status="Hoạt Động"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR005" data-full-name="Hoàng Văn E" data-status="Hoạt Động"><i class="fas fa-lock"></i></button>
                        </td>
                      </tr>
                      <tr>
                        <td>USR006</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Đỗ Thị F</td>
                        <td>dof1</td>
                        <td>dof1@example.com</td>
                        <td>Giảng Viên</td>
                        <td><span class="badge badge-inactive">Khóa</span></td>
                        <td>1</td>
                        <td>2025-05-06</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR006" data-full-name="Đỗ Thị F" data-username="dof1" 
                                  data-email="dof1@example.com" data-role="Giảng Viên" data-status="Khóa" 
                                  data-courses="1" data-created-date="2025-05-06"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR006" data-full-name="Đỗ Thị F" data-username="dof1" 
                                  data-email="dof1@example.com" data-role="Giảng Viên" data-status="Khóa"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR006" data-full-name="Đỗ Thị F" data-status="Khóa"><i class="fas fa-unlock"></i></button>
                        </td>
                      </tr>
                      <tr>
                        <td>USR007</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Ngô Văn G</td>
                        <td>ngog</td>
                        <td>ngog@example.com</td>
                        <td>Học Viên</td>
                        <td><span class="badge badge-active">Hoạt Động</span></td>
                        <td>5</td>
                        <td>2025-05-07</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR007" data-full-name="Ngô Văn G" data-username="ngog" 
                                  data-email="ngog@example.com" data-role="Học Viên" data-status="Hoạt Động" 
                                  data-courses="5" data-created-date="2025-05-07"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR007" data-full-name="Ngô Văn G" data-username="ngog" 
                                  data-email="ngog@example.com" data-role="Học Viên" data-status="Hoạt Động"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR007" data-full-name="Ngô Văn G" data-status="Hoạt Động"><i class="fas fa-lock"></i></button>
                            
                        </td>
                      </tr>
                      <tr>
                        <td>USR008</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Vũ Thị H</td>
                        <td>vuh</td>
                        <td>vuh@example.com</td>
                        <td>Giảng Viên</td>
                        <td><span class="badge badge-active">Hoạt Động</span></td>
                        <td>2</td>
                        <td>2025-05-08</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR008" data-full-name="Vũ Thị H" data-username="vuh" 
                                  data-email="vuh@example.com" data-role="Giảng Viên" data-status="Hoạt Động" 
                                  data-courses="2" data-created-date="2025-05-08"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR008" data-full-name="Vũ Thị H" data-username="vuh" 
                                  data-email="vuh@example.com" data-role="Giảng Viên" data-status="Hoạt Động"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR008" data-full-name="Vũ Thị H" data-status="Hoạt Động"><i class="fas fa-lock"></i></button>
                        </td>
                      </tr>
                      <tr>
                        <td>USR009</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Bùi Văn I</td>
                        <td>buii</td>
                        <td>buii@example.com</td>
                        <td>Học Viên</td>
                        <td><span class="badge badge-inactive">Khóa</span></td>
                        <td>1</td>
                        <td>2025-05-09</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR009" data-full-name="Bùi Văn I" data-username="buii" 
                                  data-email="buii@example.com" data-role="Học Viên" data-status="Khóa" 
                                  data-courses="1" data-created-date="2025-05-09"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR009" data-full-name="Bùi Văn I" data-username="buii" 
                                  data-email="buii@example.com" data-role="Học Viên" data-status="Khóa"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR009" data-full-name="Bùi Văn I" data-status="Khóa"><i class="fas fa-unlock"></i></button>
                        </td>
                      </tr>
                      <tr>
                        <td>USR010</td>
                        <td><img src="img/dashborad/defaultAvatar.jpg" alt="Avatar" /></td>
                        <td>Lý Thị K</td>
                        <td>lyk</td>
                        <td>lyk@example.com</td>
                        <td>Quản Trị</td>
                        <td><span class="badge badge-active">Hoạt Động</span></td>
                        <td>0</td>
                        <td>2025-05-10</td>
                        <td>
                          <button class="btn btn-view btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#viewUserModal" 
                                  data-user-id="USR010" data-full-name="Lý Thị K" data-username="lyk" 
                                  data-email="lyk@example.com" data-role="Quản Trị" data-status="Hoạt Động" 
                                  data-courses="0" data-created-date="2025-05-10"><i class="fas fa-eye"></i></button>
                          <button class="btn btn-edit btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#editUserModal" 
                                  data-user-id="USR010" data-full-name="Lý Thị K" data-username="lyk" 
                                  data-email="lyk@example.com" data-role="Quản Trị" data-status="Hoạt Động"><i class="fas fa-edit"></i></button>
                          <button class="btn btn-delete btn-sm btn-action" data-bs-toggle="modal" data-bs-target="#blockUserModal" 
                                  data-user-id="USR010" data-full-name="Lý Thị K" data-status="Hoạt Động"><i class="fas fa-lock"></i></button>
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
                <!-- Add User Modal -->
                <div class="modal fade add-user-modal" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title" id="addUserModalLabel"><i class="fas fa-plus-circle"></i> Thêm Tài Khoản</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <form action="/AddUserServlet" method="POST">
                        <div class="modal-body">
                          <div class="section">
                            <h6 class="section-title"><i class="fas fa-user"></i> Thông Tin Cá Nhân</h6>
                            <div class="form-group">
                              <label for="fullName">Họ Tên <span class="text-danger">*</span></label>
                              <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Nhập họ tên" required />
                            </div>
                          </div>
                          <div class="section">
                            <h6 class="section-title"><i class="fas fa-user-shield"></i> Thông Tin Tài Khoản</h6>
                            <div class="form-group">
                              <label for="username">Username <span class="text-danger">*</span></label>
                              <input type="text" class="form-control" id="username" name="username" placeholder="Nhập username" required />
                            </div>
                            <div class="form-group">
                              <label for="email">Email <span class="text-danger">*</span></label>
                              <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email" required />
                            </div>
                            <div class="form-group">
                              <label for="password">Mật Khẩu <span class="text-danger">*</span></label>
                              <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required />
                            </div>
                            <div class="form-group">
                              <label for="role">Vai Trò <span class="text-danger">*</span></label>
                              <select class="form-select" id="role" name="role" required>
                                <option value="" disabled selected>Chọn vai trò</option>
                                <option value="Học Viên">Học Viên</option>
                                <option value="Giảng Viên">Giảng Viên</option>
                                <option value="Quản Trị">Quản Trị</option>
                              </select>
                            </div>
                            <div class="form-group">
                              <label for="status">Trạng Thái <span class="text-danger">*</span></label>
                              <select class="form-select" id="status" name="status" required>
                                <option value="" disabled selected>Chọn trạng thái</option>
                                <option value="Hoạt Động">Hoạt Động</option>
                                <option value="Khóa">Khóa</option>
                              </select>
                            </div>
                          </div>
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                          <button type="submit" class="btn btn-submit">Thêm</button>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>
                <!-- View User Modal -->
                <div class="modal fade view-user-modal" id="viewUserModal" tabindex="-1" aria-labelledby="viewUserModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title" id="viewUserModalLabel"><i class="fas fa-user"></i> Chi Tiết Tài Khoản</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <div class="modal-body">
                        <div class="section">
                          <h6 class="section-title"><i class="fas fa-user"></i> Thông Tin Cá Nhân</h6>
                          <div class="info-item">
                            <span class="info-label">ID Tài Khoản:</span>
                            <span class="info-value" id="viewUserId"></span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">Họ Tên:</span>
                            <span class="info-value" id="viewFullName"></span>
                          </div>
                        </div>
                        <div class="section">
                          <h6 class="section-title"><i class="fas fa-user-shield"></i> Thông Tin Tài Khoản</h6>
                          <div class="info-item">
                            <span class="info-label">Username:</span>
                            <span class="info-value" id="viewUsername"></span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">Email:</span>
                            <span class="info-value" id="viewEmail"></span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">Vai Trò:</span>
                            <span class="info-value" id="viewRole"></span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">Trạng Thái:</span>
                            <span class="info-value" id="viewStatus"></span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">Số Khóa Học:</span>
                            <span class="info-value" id="viewCourses"></span>
                          </div>
                          <div class="info-item">
                            <span class="info-label">Ngày Tạo:</span>
                            <span class="info-value" id="viewCreatedDate"></span>
                          </div>
                        </div>
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Đóng</button>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- Edit User Modal -->
                <div class="modal fade edit-user-modal" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title" id="editUserModalLabel"><i class="fas fa-edit"></i> Chỉnh Sửa Tài Khoản</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <form action="/EditUserServlet" method="POST">
                        <div class="modal-body">
                          <input type="hidden" id="editUserId" name="userId" />
                          <div class="section">
                            <h6 class="section-title"><i class="fas fa-user"></i> Thông Tin Cá Nhân</h6>
                            <div class="form-group">
                              <label for="editFullName">Họ Tên <span class="text-danger">*</span></label>
                              <input type="text" class="form-control" id="editFullName" name="fullName" placeholder="Nhập họ tên" required />
                            </div>
                          </div>
                          <div class="section">
                            <h6 class="section-title"><i class="fas fa-user-shield"></i> Thông Tin Tài Khoản</h6>
                            <div class="form-group">
                              <label for="editUsername">Username <span class="text-danger">*</span></label>
                              <input type="text" class="form-control" id="editUsername" name="username" placeholder="Nhập username" required />
                            </div>
                            <div class="form-group">
                              <label for="editEmail">Email <span class="text-danger">*</span></label>
                              <input type="email" class="form-control" id="editEmail" name="email" placeholder="Nhập email" required />
                            </div>
                            <div class="form-group">
                              <label for="editPassword">Mật Khẩu <span class="optional-label">(Tùy chọn)</span></label>
                              <input type="password" class="form-control" id="editPassword" name="password" placeholder="Nhập mật khẩu mới (nếu muốn thay đổi)" />
                            </div>
                            <div class="form-group">
                              <label for="editRole">Vai Trò <span class="text-danger">*</span></label>
                              <select class="form-select" id="editRole" name="role" required>
                                <option value="" disabled>Chọn vai trò</option>
                                <option value="Học Viên">Học Viên</option>
                                <option value="Giảng Viên">Giảng Viên</option>
                                <option value="Quản Trị">Quản Trị</option>
                              </select>
                            </div>
                            <div class="form-group">
                              <label for="editStatus">Trạng Thái <span class="text-danger">*</span></label>
                              <select class="form-select" id="editStatus" name="status" required>
                                <option value="" disabled>Chọn trạng thái</option>
                                <option value="Hoạt Động">Hoạt Động</option>
                                <option value="Khóa">Khóa</option>
                              </select>
                            </div>
                          </div>
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                          <button type="submit" class="btn btn-submit">Cập Nhật</button>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>
                <!-- Block User Modal -->
                <div class="modal fade block-user-modal" id="blockUserModal" tabindex="-1" aria-labelledby="blockUserModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title" id="blockUserModalLabel"><i class="fas fa-lock"></i> Xác Nhận Khóa/Mở Khóa Tài Khoản</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <div class="modal-body">
                        <div class="warning-section">
                          <h6 class="warning-title"><i class="fas fa-exclamation-triangle"></i> Cảnh Báo</h6>
                          <div class="info-item">
                            Bạn có chắc chắn muốn <span id="blockAction"></span> tài khoản <span id="blockFullName"></span> (ID: <span id="blockUserId"></span>)?
                          </div>
                          <div class="warning-text">
                            Hành động này sẽ thay đổi trạng thái tài khoản. Vui lòng xác nhận.
                          </div>
                        </div>
                      </div>
                      <div class="modal-footer">
                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">Hủy</button>
                        <form action="/BlockUserServlet" method="POST">
                          <input type="hidden" id="blockUserIdInput" name="userId" />
                          <input type="hidden" id="blockStatusInput" name="status" />
                          <button type="submit" class="btn btn-confirm-block">Xác Nhận</button>
                        </form>
                      </div>
                    </div>
                  </div>
                </div>
                <!-- Notification Modal -->
                <div class="modal fade notification-modal" id="notificationModal" tabindex="-1" aria-labelledby="notificationModalLabel" aria-hidden="true">
                  <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h5 class="modal-title" id="notificationModalLabel"><i class="fas fa-bell"></i> Thông Báo</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <div class="modal-body">
                        <div class="notification-list">
                          <div class="notification-item">
                            <h6 class="notification-title">Yêu cầu tạo tài khoản Giảng Viên</h6>
                            <p><strong>Tên:</strong> Nguyễn Văn X</p>
                            <p><strong>Email:</strong> nguyenx@example.com</p>
                            <p><strong>Coordinator:</strong> Trần Thị Y</p>
                            <p><strong>Đánh giá:</strong> Đạt yêu cầu làm Giảng Viên</p>
                            <p><strong>Hồ sơ (CV):</strong> <a href="/path/to/cv1.pdf" target="_blank">Xem CV</a></p>
                            <div class="notification-actions">
                              <button class="btn btn-approve" data-notification-id="NOT001">Phê duyệt</button>
                              <button class="btn btn-reject" data-notification-id="NOT001">Từ chối</button>
                            </div>
                          </div>
                          <div class="notification-item">
                            <h6 class="notification-title">Yêu cầu tạo tài khoản Giảng Viên</h6>
                            <p><strong>Tên:</strong> Lê Thị Z</p>
                            <p><strong>Email:</strong> lez@example.com</p>
                            <p><strong>Coordinator:</strong> Phạm Văn W</p>
                            <p><strong>Đánh giá:</strong> Đạt yêu cầu làm Giảng Viên</p>
                            <p><strong>Hồ sơ (CV):</strong> <a href="/path/to/cv2.pdf" target="_blank">Xem CV</a></p>
                            <div class="notification-actions">
                              <button class="btn btn-approve" data-notification-id="NOT002">Phê duyệt</button>
                              <button class="btn btn-reject" data-notification-id="NOT002">Từ chối</button>
                            </div>
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
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaUser.js"></script>
      </body>
    </html>