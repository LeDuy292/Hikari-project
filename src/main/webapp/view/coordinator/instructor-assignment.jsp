<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
                <!-- Messages -->
                <c:if test="${not empty message}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

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
                                <c:if test="${empty listTeacher}">
                                    <div class="alert alert-warning text-center">
                                        Không có giáo viên nào được tìm thấy.
                                    </div>
                                </c:if>
                                <c:forEach var="teacher" items="${listTeacher}">
                                    <div class="instructor-card">
                                        <img src="${pageContext.request.contextPath}/assets/images/avatar.jpg" alt="Avatar" class="instructor-avatar">
                                        <div class="instructor-info">
                                            <h6 class="instructor-name">${teacher.fullName}</h6>
                                            <span class="instructor-specialty">${teacher.specialization}</span>
                                        </div>
                                    </div>
                                </c:forEach>
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
                                                <th>Số HV</th>
                                                <th>Trạng thái</th>
                                                <th>Hành động</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="classObj" items="${listClass}">
                                                <tr>
                                                    <td>${classObj.name}</td>
                                                    <td>${classObj.courseTitle}</td>
                                                    <td>
                                                        <form action="${pageContext.request.contextPath}/TeacherAssignment" method="POST" onsubmit="return validateForm(this)">
                                                            <input type="hidden" name="action" value="assign">
                                                            <input type="hidden" name="classID" value="${classObj.classID}">
                                                            <select name="teacherID" class="form-select form-select-sm teacher-select" data-class-id="${classObj.classID}">
                                                                <option value="">Chọn giảng viên</option>
                                                                <c:forEach var="teacher" items="${listTeacher}">
                                                                    <option value="${teacher.teacherID}" ${teacher.teacherID == classObj.teacherID ? 'selected' : ''}>${teacher.fullName}</option>
                                                                </c:forEach>
                                                            </select>
                                                    </td>
                                                    <td><fmt:formatDate value="${classObj.startDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td><fmt:formatDate value="${classObj.endDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td>${classObj.numberOfStudents}</td>
                                                    <td>
                                                        <span class="badge ${not empty classObj.teacherID ? 'bg-success' : 'bg-warning'}">
                                                            ${not empty classObj.teacherID ? 'Đã phân công' : 'Chờ phân công'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                            <button type="submit" class="btn btn-sm btn-primary assign-btn">
                                                                <i class="fas fa-user-plus me-1"></i> Phân công
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
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
    <script>
        // Validate form submission
        function validateForm(form) {
            const teacherID = form.querySelector('select[name="teacherID"]').value;
            if (!teacherID) {
                alert('Vui lòng chọn giảng viên!');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>