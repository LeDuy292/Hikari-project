<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                        <%                            
                            request.setAttribute("pageTitle", "Quản Lý Tài Khoản");
                            request.setAttribute("showAddButton", true);
                            request.setAttribute("addButtonText", "Thêm Tài Khoản");
                            request.setAttribute("addModalTarget", "addUserModal");
                            request.setAttribute("addBtnIcon", "fa-user-plus");
                            request.setAttribute("pageIcon", "fa-users");
                            request.setAttribute("showNotification", true);
                            request.setAttribute("notificationCount", 5);
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
                            <form action="${pageContext.request.contextPath}/admin/users" method="GET" class="filter-form">
                                <input type="hidden" name="action" value="filter">
                                <div class="filter-group">
                                    <label for="roleFilter">
                                        <i class="fas fa-user-tag"></i> Vai Trò:
                                    </label>
                                    <select class="form-select" id="roleFilter" name="role">
                                        <option value="">Tất cả</option>
                                        <option value="Student" ${selectedRole == 'Student' ? 'selected' : ''}>Học Viên</option>
                                        <option value="Teacher" ${selectedRole == 'Teacher' ? 'selected' : ''}>Giảng Viên</option>
                                        <option value="Admin" ${selectedRole == 'Admin' ? 'selected' : ''}>Quản Trị</option>
                                        <option value="Coordinator" ${selectedRole == 'Coordinator' ? 'selected' : ''}>Điều Phối</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="statusFilter">
                                        <i class="fas fa-toggle-on"></i> Trạng Thái:
                                    </label>
                                    <select class="form-select" id="statusFilter" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="true" ${selectedStatus == 'true' ? 'selected' : ''}>Hoạt Động</option>
                                        <option value="false" ${selectedStatus == 'false' ? 'selected' : ''}>Không Hoạt Động</option>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="dateFromFilter">
                                        <i class="fas fa-calendar-alt"></i> Từ Ngày:
                                    </label>
                                    <input type="date" class="form-control" id="dateFromFilter" name="dateFrom" value="${selectedDateFrom}" />
                                </div>
                                <div class="filter-group">
                                    <label for="dateToFilter">
                                        <i class="fas fa-calendar-check"></i> Đến Ngày:
                                    </label>
                                    <input type="date" class="form-control" id="dateToFilter" name="dateTo" value="${selectedDateTo}" />
                                </div>
                                <div class="filter-group">
                                    <label for="courseFilter">
                                        <i class="fas fa-graduation-cap"></i> Số Khóa Học Tối Thiểu:
                                    </label>
                                    <input type="number" class="form-control" id="courseFilter" name="minCourses" min="0" value="${selectedMinCourses}" />
                                </div>
                                <div class="filter-group">
                                    <label for="nameSearch">
                                        <i class="fas fa-search"></i> Tìm Kiếm:
                                    </label>
                                    <input type="text" class="form-control" id="nameSearch" name="nameSearch" placeholder="Tên, username, email..." value="${selectedNameSearch}" />
                                </div>
                                <div class="filter-actions">
                                    <button type="submit" class="btn btn-filter">
                                        <i class="fas fa-filter"></i> Lọc
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-reset">
                                        <i class="fas fa-refresh"></i> Đặt Lại
                                    </a>
                                </div>
                            </form>
                        </div>

                        <!-- Users Table -->
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th><i class="fas fa-id-card"></i> ID</th>
                                        <th><i class="fas fa-user-circle"></i> AVATAR</th>
                                        <th><i class="fas fa-user"></i> HỌ TÊN</th>
                                        <th><i class="fas fa-at"></i> USERNAME</th>
                                        <th><i class="fas fa-envelope"></i> EMAIL</th>
                                        <th><i class="fas fa-user-tag"></i> VAI TRÒ</th>
                                        <th><i class="fas fa-toggle-on"></i> TRẠNG THÁI</th>
                                        <th><i class="fas fa-graduation-cap"></i> SỐ KHÓA HỌC</th>
                                        <th><i class="fas fa-calendar-plus"></i> NGÀY TẠO</th>
                                        <th><i class="fas fa-cogs"></i> HÀNH ĐỘNG</th>
                                    </tr>
                                </thead>
                                <tbody id="userTableBody">
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td><strong>${user.userID}</strong></td>
                                            <td>
                                                <img src="${pageContext.request.contextPath}/assets/img/dashborad/defaultAvatar.jpg" alt="Avatar" />
                                            </td>
                                            <td><strong>${user.fullName}</strong></td>
                                            <td>${user.username}</td>
                                            <td>${user.email}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${user.role == 'Admin'}">
                                                        <span class="badge" style="background: linear-gradient(135deg, #dc3545, #e85d75);">
                                                            <i class="fas fa-crown"></i> ${user.role}
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'Teacher'}">
                                                        <span class="badge" style="background: linear-gradient(135deg, #f39c12, #ffb347);">
                                                            <i class="fas fa-chalkboard-teacher"></i> ${user.role}
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'Coordinator'}">
                                                        <span class="badge" style="background: linear-gradient(135deg, #6f42c1, #8e6bc1);">
                                                            <i class="fas fa-user-tie"></i> ${user.role}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge" style="background: linear-gradient(135deg, #4a90e2, #5ba0f2);">
                                                            <i class="fas fa-user-graduate"></i> ${user.role}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    
                                                    <c:when test="${user.isActive}">
                                                        
                                                        <span class="badge badge-active">
                                                            <i class="fas fa-check-circle"></i> Hoạt Động
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-inactive">
                                                            <i class="fas fa-times-circle"></i> Không Hoạt Động
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="badge" style="background: linear-gradient(135deg, #28a745, #34ce57);">
                                                    ${user.courseCount != null ? user.courseCount : 0}
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${user.registrationDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>
                                                <button class="btn btn-view btn-sm btn-action" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#viewUserModal"
                                                        data-user-id="${user.userID}"
                                                        data-full-name="${user.fullName}"
                                                        data-username="${user.username}"
                                                        data-email="${user.email}"
                                                        data-role="${user.role}"
                                                        data-phone="${user.phone}"
                                                        data-birth-date="<fmt:formatDate value='${user.birthDate}' pattern='dd/MM/yyyy'/>"
                                                        data-courses="${user.courseCount != null ? user.courseCount : 0}"
                                                        data-created-date="<fmt:formatDate value='${user.registrationDate}' pattern='dd/MM/yyyy'/>"
                                                        data-status="${not empty user.isActive and user.isActive ? 'Hoạt Động' : 'Không Hoạt Động'}">
                                                    <i class="fas fa-eye"></i>
                                                </button>
                                                <button class="btn btn-edit btn-sm btn-action" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#editUserModal"
                                                        data-user-id="${user.userID}"
                                                        data-full-name="${user.fullName}"
                                                        data-username="${user.username}"
                                                        data-email="${user.email}"
                                                        data-role="${user.role}"
                                                        data-phone="${user.phone}"
                                                        data-birth-date="<fmt:formatDate value='${user.birthDate}' pattern='yyyy-MM-dd'/>">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-block btn-sm btn-action" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#blockUserModal"
                                                        data-user-id="${user.userID}"
                                                        data-full-name="${user.fullName}"
                                                        data-status="${not empty user.isActive and user.isActive ? 'Hoạt Động' : 'Không Hoạt Động'}"
                                                        data-is-active="${user.isActive}">
                                                    <c:choose>
                                                        <c:when test="${not empty user.isActive and user.isActive}">
                                                            <i class="fas fa-lock"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-unlock"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination" id="pagination">
                            <button id="prevPage" disabled>
                                <i class="fas fa-chevron-left"></i> Trước
                            </button>
                            <span id="pageInfo"></span>
                            <button id="nextPage">
                                Sau <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>

                        <!-- Add User Modal -->
                        <div class="modal fade add-user-modal" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="addUserModalLabel">
                                            <i class="fas fa-plus-circle"></i> Thêm Tài Khoản
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                                        <input type="hidden" name="action" value="add">
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-user"></i> Thông Tin Cá Nhân
                                                </h6>
                                                <div class="form-group">
                                                    <label for="fullName">Họ Tên <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Nhập họ tên đầy đủ" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="phone">Số Điện Thoại</label>
                                                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="Nhập số điện thoại" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="birthDate">Ngày Sinh</label>
                                                    <input type="date" class="form-control" id="birthDate" name="birthDate" />
                                                </div>
                                            </div>
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-user-shield"></i> Thông Tin Tài Khoản
                                                </h6>
                                                <div class="form-group">
                                                    <label for="username">Username <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="email">Email <span class="text-danger">*</span></label>
                                                    <input type="email" class="form-control" id="email" name="email" placeholder="Nhập địa chỉ email" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="password">Mật Khẩu <span class="text-danger">*</span></label>
                                                    <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="confirmPassword">Xác Nhận Mật Khẩu <span class="text-danger">*</span></label>
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="role">Vai Trò <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="role" name="role" required>
                                                        <option value="" disabled selected>Chọn vai trò</option>
                                                        <option value="Student">Học Viên</option>
                                                        <option value="Teacher">Giảng Viên</option>
                                                        <option value="Admin">Quản Trị</option>
                                                        <option value="Coordinator">Điều Phối</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                            <button type="submit" class="btn btn-submit">
                                                <i class="fas fa-plus"></i> Thêm
                                            </button>
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
                                        <h5 class="modal-title" id="viewUserModalLabel">
                                            <i class="fas fa-user"></i> Chi Tiết Tài Khoản
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="section">
                                            <h6 class="section-title">
                                                <i class="fas fa-user"></i> Thông Tin Cá Nhân
                                            </h6>
                                            <div class="info-item">
                                                <span class="info-label">ID Tài Khoản:</span>
                                                <span class="info-value" id="viewUserId"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Họ Tên:</span>
                                                <span class="info-value" id="viewFullName"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Số Điện Thoại:</span>
                                                <span class="info-value" id="viewPhone"></span>
                                            </div>
                                            <div class="info-item">
                                                <span class="info-label">Ngày Sinh:</span>
                                                <span class="info-value" id="viewBirthDate"></span>
                                            </div>
                                        </div>
                                        <div class="section">
                                            <h6 class="section-title">
                                                <i class="fas fa-user-shield"></i> Thông Tin Tài Khoản
                                            </h6>
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
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Đóng
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Edit User Modal -->
                        <div class="modal fade edit-user-modal" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="editUserModalLabel">
                                            <i class="fas fa-edit"></i> Chỉnh Sửa Tài Khoản
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/admin/users" method="POST">
                                        <input type="hidden" name="action" value="edit">
                                        <input type="hidden" id="editUserId" name="userId" />
                                        <div class="modal-body">
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-user"></i> Thông Tin Cá Nhân
                                                </h6>
                                                <div class="form-group">
                                                    <label for="editFullName">Họ Tên <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="editFullName" name="fullName" placeholder="Nhập họ tên" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editPhone">Số Điện Thoại</label>
                                                    <input type="tel" class="form-control" id="editPhone" name="phone" placeholder="Nhập số điện thoại" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editBirthDate">Ngày Sinh</label>
                                                    <input type="date" class="form-control" id="editBirthDate" name="birthDate" />
                                                </div>
                                            </div>
                                            <div class="section">
                                                <h6 class="section-title">
                                                    <i class="fas fa-user-shield"></i> Thông Tin Tài Khoản
                                                </h6>
                                                <div class="form-group">
                                                    <label for="editUsername">Username <span class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" id="editUsername" name="username" placeholder="Nhập username" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editEmail">Email <span class="text-danger">*</span></label>
                                                    <input type="email" class="form-control" id="editEmail" name="email" placeholder="Nhập email" required />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editPassword">
                                                        Mật Khẩu 
                                                        <span class="optional-label">(Để trống nếu không đổi)</span>
                                                    </label>
                                                    <input type="password" class="form-control" id="editPassword" name="password" placeholder="Nhập mật khẩu mới" />
                                                </div>
                                                <div class="form-group">
                                                    <label for="editRole">Vai Trò <span class="text-danger">*</span></label>
                                                    <select class="form-select" id="editRole" name="role" required>
                                                        <option value="" disabled>Chọn vai trò</option>
                                                        <option value="Student">Học Viên</option>
                                                        <option value="Teacher">Giảng Viên</option>
                                                        <option value="Admin">Quản Trị</option>
                                                        <option value="Coordinator">Điều Phối</option>
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

                        <!-- Block User Modal -->
                        <div class="modal fade block-user-modal" id="blockUserModal" tabindex="-1" aria-labelledby="blockUserModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="blockUserModalLabel">
                                            <i class="fas fa-lock"></i> Xác Nhận Khóa/Mở Khóa Tài Khoản
                                        </h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="warning-section">
                                            <h6 class="warning-title">
                                                <i class="fas fa-exclamation-triangle"></i> Cảnh Báo
                                            </h6>
                                            <div class="info-item">
                                                Bạn có chắc chắn muốn <span id="blockAction">khóa</span> tài khoản 
                                                <strong><span id="blockFullName"></span></strong> (ID: <strong><span id="blockUserId"></span></strong>)?
                                            </div>
                                            <div class="warning-text">
                                                Hành động này sẽ thay đổi trạng thái tài khoản. Vui lòng xác nhận.
                                            </div>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">
                                            <i class="fas fa-times"></i> Hủy
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="POST" style="display: inline;">
                                            <input type="hidden" name="action" value="block">
                                            <input type="hidden" id="blockUserIdInput" name="userId" />
                                            <input type="hidden" id="blockStatusInput" name="isActive" />
                                            <button type="submit" class="btn btn-confirm-block">
                                                <i class="fas fa-lock"></i> Xác Nhận
                                            </button>
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
                                        <h5 class="modal-title" id="notificationModalLabel">
                                            <i class="fas fa-bell"></i> Thông Báo
                                        </h5>
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
                                            </div>
                                            <div class="notification-item">
                                                <h6 class="notification-title">Yêu cầu tạo tài khoản Giảng Viên</h6>
                                                <p><strong>Tên:</strong> Lê Thị Z</p>
                                                <p><strong>Email:</strong> lez@example.com</p>
                                                <p><strong>Coordinator:</strong> Phạm Văn W</p>
                                                <p><strong>Đánh giá:</strong> Đạt yêu cầu làm Giảng Viên</p>
                                                <p><strong>Hồ sơ (CV):</strong> <a href="/path/to/cv2.pdf" target="_blank">Xem CV</a></p>
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
        <script src="${pageContext.request.contextPath}/assets/js/admin/manaUser.js"></script>
    </body>
</html>