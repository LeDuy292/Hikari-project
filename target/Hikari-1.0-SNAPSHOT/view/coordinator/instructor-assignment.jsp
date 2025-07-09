<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Phân Công Giảng Viên - Coordinator Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/instructor-assignment.css" rel="stylesheet">
    </head>
    <body>
        <div class="d-flex">
            <!-- Sidebar -->
            <jsp:include page="sidebarCoordinator.jsp" />

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <jsp:include page="headerCoordinator.jsp" />

                <!-- Content -->
                <div class="content-wrapper">
                    <div class="row g-4">
                        <!-- Instructor List -->
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="card-title mb-0">Danh sách giảng viên</h5>
                                    <button class="btn btn-primary btn-sm">
                                        <i class="fas fa-plus me-1"></i>Thêm mới
                                    </button>
                                </div>
                                <div class="card-body">
                                    <div class="input-group mb-3">
                                        <input type="text" class="form-control" placeholder="Tìm kiếm giảng viên...">
                                        <button class="btn btn-outline-primary">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                    
                                        <c:if test="${empty requestScope.listTeacher}">
                                            <div class="alert alert-warning text-center">
                                                Không có giáo viên nào được tìm thấy.
                                            </div>
                                        </c:if>
                                        <c:forEach var="teacher" items="${requestScope.listTeacher}">
                                            <div class="instructor-list">
                                             <!-- Instructor Item -->
                                        <div class="instructor-card active">
                                            <img src="assets/images/avatar.jpg" alt="Avatar" class="instructor-avatar">
                                            <div class="instructor-info">
                                                <h6 class="instructor-name">${teacher.fullName}</h6>
                                                <span class="instructor-specialty">${teacher.specialization}</span>
                                            </div>
                                            <div class="assigned-classes mt-2">
                                                <p class="mb-1 fw-semibold">Đã phân công:</p>
                                                <span class="badge bg-secondary me-1">Lớp N1 - 01</span>
                                                <span class="badge bg-secondary">Lớp N3 - 01</span>
                                            </div>
                                        </div>
                                            </div>
                                        </c:forEach>
                                        <!-- Instructor Item -->
<!--                                        <div class="instructor-card">
                                            <img src="assets/images/avatar.jpg" alt="Avatar" class="instructor-avatar">
                                            <div class="instructor-info">
                                                <h6 class="instructor-name">Trần Thị B</h6>
                                                <span class="instructor-specialty">Japanese Language (N3-N5)</span>
                                            </div>
                                            <div class="assigned-classes mt-2">
                                                <p class="mb-1 fw-semibold">Đã phân công:</p>
                                                <span class="badge bg-secondary me-1">Lớp N3 - 01</span>
                                                <%-- Add more assigned classes as needed --%>
                                            </div>
                                        </div>-->
                                        <!-- Instructor Item -->
<!--                                        <div class="instructor-card">
                                            <img src="assets/images/avatar.jpg" alt="Avatar" class="instructor-avatar">
                                            <div class="instructor-info">
                                                <h6 class="instructor-name">Lê Văn C</h6>
                                                <span class="instructor-specialty">Business Japanese</span>
                                            </div>
                                            <div class="assigned-classes mt-2">
                                                <p class="mb-1 fw-semibold">Đã phân công:</p>
                                                <span class="badge bg-secondary me-1">Lớp N2 - 01</span>
                                                <%-- Add more assigned classes as needed --%>
                                            </div>
                                        </div>-->
                                </div>
                            </div>
                        </div>

                        <!-- Assignment List -->
                        <div class="col-md-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Phân công lớp học</h5>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Tên lớp học</th>
                                                    <th>Tên khóa học</th>
                                                    <th>Giáo viên</th>
                                                    <th>Ngày bắt đầu</th>
                                                    <th>Ngày kết thúc</th>
                                                    <th>Lịch học</th>
                                                    <th>Số HV / Tối đa</th>
                                                    <th>Trạng thái</th>
                                                    <th>Hành động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%-- Class Assignment Item - Example --%>
                                                <tr>
                                                    <td>Lớp N1 - 01</td>
                                                    <td>JLPT N1</td>
                                                    <td>Nguyễn Văn A</td>
                                                    <td>01/09/2023</td>
                                                    <td>24/02/2024</td>
                                                    <td>Thứ 2, 4, 6 (19:00 - 21:00)</td>
                                                    <td>25 / 30</td>
                                                    <td><span class="badge bg-success">Đã phân công</span></td>
                                                    <td>
                                                        <div class="btn-group gap-1">
                                                            <button class="btn btn-sm btn-outline-primary" title="Chỉnh sửa"><i class="fas fa-edit"></i></button>
                                                            <button class="btn btn-sm btn-outline-danger" title="Hủy phân công"><i class="fas fa-times"></i></button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Lớp N2 - 01</td>
                                                    <td>JLPT N2</td>
                                                    <td>
                                                        <select class="form-select form-select-sm">
                                                            <option value="">Chọn giảng viên</option>
                                                            <option value="gv_nguyen_van_a">Nguyễn Văn A</option>
                                                            <option value="gv_tran_thi_b">Trần Thị B</option>
                                                            <option value="gv_le_van_c">Lê Văn C</option>
                                                            <%-- Add more instructor options dynamically from the list on the left in a real application --%>
                                                        </select>
                                                    </td>
                                                    <td>01/10/2023</td>
                                                    <td>24/04/2024</td>
                                                    <td>Thứ 3, 5, 7 (19:30 - 21:30)</td>
                                                    <td>20 / 25</td>
                                                    <td><span class="badge bg-warning">Chờ phân công</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-primary"><i class="fas fa-user-plus me-1"></i> Phân công</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Lớp N3 - 01</td>
                                                    <td>JLPT N3</td>
                                                    <td>Trần Thị B</td>
                                                    <td>05/10/2023</td>
                                                    <td>28/04/2024</td>
                                                    <td>Thứ 3, 5, 7 (18:00 - 20:00)</td>
                                                    <td>22 / 25</td>
                                                    <td><span class="badge bg-success">Đã phân công</span></td>
                                                    <td>
                                                        <div class="btn-group gap-1">
                                                            <button class="btn btn-sm btn-outline-primary" title="Chỉnh sửa"><i class="fas fa-edit"></i></button>
                                                            <button class="btn btn-sm btn-outline-danger" title="Hủy phân công"><i class="fas fa-times"></i></button>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Lớp N4 - 01</td>
                                                    <td>JLPT N4</td>
                                                    <td>
                                                        <select class="form-select form-select-sm">
                                                            <option value="">Chọn giảng viên</option>
                                                            <option value="gv_nguyen_van_a">Nguyễn Văn A</option>
                                                            <option value="gv_tran_thi_b">Trần Thị B</option>
                                                            <option value="gv_le_van_c">Lê Văn C</option>
                                                            <%-- Add more instructor options dynamically from the list on the left in a real application --%>
                                                        </select>
                                                    </td>
                                                    <td>10/10/2023</td>
                                                    <td>03/05/2024</td>
                                                    <td>Thứ 2, 4, 6 (20:00 - 22:00)</td>
                                                    <td>18 / 20</td>
                                                    <td><span class="badge bg-warning">Chờ phân công</span></td>
                                                    <td>
                                                        <button class="btn btn-sm btn-primary"><i class="fas fa-user-plus me-1"></i> Phân công</button>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 