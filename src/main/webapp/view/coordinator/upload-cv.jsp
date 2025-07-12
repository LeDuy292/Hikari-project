<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nộp CV Giảng viên - JLEARNING</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/upload-cv.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css">
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../student/sidebar.jsp" />

                <!-- Main Content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                    <jsp:include page="../student/header.jsp" />
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Nộp CV Giảng viên</h1>
                    </div>

                    <!-- Thông báo lỗi hoặc thành công -->
                    <c:if test="${param.success == 'upload'}">
                        <div class="alert alert-success">Tải CV lên thành công!</div>
                    </c:if>
                    <c:if test="${param.error == 'please_login'}">
                        <div class="alert alert-warning">Vui lòng <a href="login.jsp">đăng nhập</a> để tiếp tục.</div>
                    </c:if>
                    <c:if test="${param.error == 'invalid_file'}">
                        <div class="alert alert-danger">Vui lòng tải lên tệp PDF!</div>
                    </c:if>
                    <c:if test="${param.error == 'upload_failed'}">
                        <div class="alert alert-danger">Tải CV thất bại, vui lòng thử lại.</div>
                    </c:if>
                    <c:if test="${param.error == 'unauthorized'}">
                        <div class="alert alert-danger">Bạn không có quyền truy cập trang này.</div>
                    </c:if>

                    <!-- Upload CV Form -->
                    <c:if test="${sessionScope.user != null && (sessionScope.user.role == 'Student' || sessionScope.user.role == 'Applicant')}">
                        <div class="card mb-4 shadow-sm">
                            <div class="card-header bg-primary text-white">Tải lên CV</div>
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/cv" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="action" value="upload">
                                    <div class="mb-3">
                                        <label for="fullName" class="form-label">Họ và Tên</label>
                                        <input type="text" class="form-control" id="fullName" value="${sessionScope.user.fullName}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" class="form-control" id="email" value="${sessionScope.user.email}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">Số điện thoại</label>
                                        <input type="text" class="form-control" id="phone" value="${sessionScope.user.phone}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="cvFile" class="form-label">Tệp CV (PDF)</label>
                                        <input type="file" class="form-control" id="cvFile" name="cvFile" accept=".pdf" required>
                                    </div>
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-upload"></i> Tải lên</button>
                                </form>
                            </div>
                        </div>
                    </c:if>

                    <!-- Hiển thị CV của người dùng -->
                    <div class="card mb-4 shadow-sm">
                        <div class="card-header bg-info text-white">CV của bạn</div>
                        <div class="card-body">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Mã CV</th>
                                        <th>Tệp CV</th>
                                        <th>Ngày tải lên</th>
                                        <th>Trạng thái</th>
                                        <th>Nhận xét</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="cv" items="${cvList}">
                                        <c:if test="${cv.userID == sessionScope.user.userID}">
                                            <tr>
                                                <td>${cv.cvID}</td>
                                                <td><a href="${cv.fileUrl}" target="_blank">Xem CV</a></td>
                                                <td>${cv.uploadDate}</td>
                                                <td><span class="badge bg-${cv.status == 'Approved' ? 'success' : cv.status == 'Rejected' ? 'danger' : 'warning'}">${cv.status}</span></td>
                                                <td>${cv.comments != null ? cv.comments : 'Chưa có nhận xét'}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/static/js/main.js"></script>
    </body>
</html>