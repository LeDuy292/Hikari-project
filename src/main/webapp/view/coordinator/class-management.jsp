<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Lớp Học - Coordinator Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/dashboard.css" rel="stylesheet"> <%-- Reuse existing CSS --%>
        <%-- Consider adding specific CSS for class management if needed --%>
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
                    <div class="card p-0">
                        <div class="card-header bg-white border-bottom-0 pb-0">
                            <div class="row g-2 align-items-center">
                                <div class="col-md-6">
                                    <h5 class="card-title mb-0">Danh sách lớp học</h5>
                                </div>
                                <div class="col-md-6">
                                    <%-- Add search/filter for classes if needed --%>
                                </div>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="bg-light">
                                        <tr>
                                            <th>STT</th>
                                            <th>Tên</th>
                                            <th>Mã Học Sinh</th>
                                            <th>tmp</th>
                                            <th>tmp</th>
                                            <th>tmp</th>
                                            <th>tmp</th>
                                                <%-- Add Thao tác column if needed for viewing class details, etc. --%>
                                        </tr>
                                    </thead>
                                    <tbody>
                                         <c:if test="${empty requestScope.listStudentOfClass}">
                                            <div class="alert alert-warning text-center">
                                                Không có giáo viên nào được tìm thấy.
                                            </div>
                                        </c:if>
                                    <c:forEach var="student" items="${requestScope.listStudentOfClass}">
                                        <tr>
                                            <td></td>
                                            <td>${student.studentID}</td>
                                            <td>${student.studentName}</td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td><span class="badge bg-success">Đang diễn ra</span></td>
                                            <td>
                                                <button>
                                                    <a href="#">Xem Chi tiết</a>
                                                </button>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 