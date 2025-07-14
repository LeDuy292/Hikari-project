<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phê duyệt CV Giảng viên - JLEARNING</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/coordinator_css/teacher-cv-review.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="sidebarCoordinator.jsp" />

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <jsp:include page="headerCoordinator.jsp" />
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Phê duyệt CV Giảng viên</h1>
                </div>

                <!-- Thông báo lỗi hoặc thành công -->
                <c:if test="${param.success == 'review'}">
                    <div class="alert alert-success">Phê duyệt CV thành công!</div>
                </c:if>
                <c:if test="${param.error == 'please_login'}">
                    <div class="alert alert-warning">Vui lòng <a href="login.jsp">đăng nhập</a> để tiếp tục.</div>
                </c:if>
                <c:if test="${param.error == 'unauthorized'}">
                    <div class="alert alert-danger">Bạn không có quyền truy cập trang này.</div>
                </c:if>

                <!-- CV List (chỉ hiển thị cho Coordinator) -->
                <c:if test="${sessionScope.user.role == 'Coordinator'}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped">
                            <thead class="table-dark">
                                <tr>
                                    <th>Mã CV</th>
                                    <th>Họ và Tên</th>
                                    <th>UserID</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Tệp CV</th>
                                    <th>Ngày tải lên</th>
                                    <th>Trạng thái</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cv" items="${cvList}">
                                    <tr>
                                        <td>${cv.cvID}</td>
                                        <td>${cv.fullName}</td>
                                        <td>${cv.userID}</td>
                                        <td>${cv.email}</td>
                                        <td>${cv.phone}</td>
                                        <td><a href="${cv.fileUrl}" target="_blank">Xem CV</a></td>
                                        <td>${cv.uploadDate}</td>
                                        <td><span class="badge bg-${cv.status == 'Approved' ? 'success' : cv.status == 'Rejected' ? 'danger' : 'warning'}">${cv.status}</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#reviewCVModal${cv.cvID}">
                                                <i class="fas fa-eye"></i> Xem & Phê duyệt
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <!-- Review CV Modal (chỉ cho Coordinator) -->
                <c:if test="${sessionScope.user.role == 'Coordinator'}">
                    <c:forEach var="cv" items="${cvList}">
                        <div class="modal fade" id="reviewCVModal${cv.cvID}" tabindex="-1" aria-labelledby="reviewCVModalLabel${cv.cvID}" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="reviewCVModalLabel${cv.cvID}">Phê duyệt CV - ${cv.fullName}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <h5>Thông tin cá nhân</h5>
                                                <p><strong>Họ và Tên:</strong> ${cv.fullName}</p>
                                                <p><strong>UserID:</strong> ${cv.userID}</p>
                                                <p><strong>Email:</strong> ${cv.email}</p>
                                                <p><strong>Số điện thoại:</strong> ${cv.phone}</p>
                                            </div>
                                            <div class="col-md-6">
                                                <h5>Tệp CV</h5>
                                                <embed src="${cv.fileUrl}" type="application/pdf" width="100%" height="500px">
                                            </div>
                                        </div>
                                        <hr>
                                        <form action="${pageContext.request.contextPath}/cv" method="post">
                                            <input type="hidden" name="action" value="review">
                                            <input type="hidden" name="cvID" value="${cv.cvID}">
                                            <input type="hidden" name="reviewerID" value="${sessionScope.user.userID}">
                                            <div class="mb-3">
                                                <label for="status${cv.cvID}" class="form-label">Trạng thái</label>
                                                <select class="form-select" id="status${cv.cvID}" name="status" required>
                                                    <option value="Pending" ${cv.status == 'Pending' ? 'selected' : ''}>Chờ duyệt</option>
                                                    <option value="Approved" ${cv.status == 'Approved' ? 'selected' : ''}>Phê duyệt</option>
                                                    <option value="Rejected" ${cv.status == 'Rejected' ? 'selected' : ''}>Từ chối</option>
                                                </select>
                                            </div>
                                            <div class="mb-3">
                                                <label for="comments${cv.cvID}" class="form-label">Nhận xét</label>
                                                <textarea class="form-control" id="comments${cv.cvID}" name="comments" rows="4">${cv.comments}</textarea>
                                            </div>
                                            <button type="submit" class="btn btn-primary">Lưu</button>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/main.js"></script>
</body>
</html>