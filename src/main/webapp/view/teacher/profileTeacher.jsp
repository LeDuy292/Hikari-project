<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hồ Sơ Giáo Viên - JLEARNING</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/profileTeacher.css" />
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>
            <!-- Main Content -->
            <main class="main-content">
                <div class="content-wrapper">
                    <!-- Header -->
                    <%@ include file="header.jsp" %>
                    <!-- Profile Content -->
                    <div class="profile-info">
                        <img src="${teacher.profilePicture != null ? teacher.profilePicture : 'https://via.placeholder.com/100x100'}" alt="Ảnh đại diện" class="profile-avatar" />
                        <div>
                            <div class="profile-header">
                                <div>
                                    <div class="user-name">${teacher.fullName != null ? teacher.fullName : 'Chưa cập nhật'}</div>
                                    <div class="email">${teacher.email != null ? teacher.email : 'Chưa cập nhật'}</div>
                                </div>
                            </div>
                            <div class="profile-details">
                                <div>
                                    <div class="label">Username</div>
                                    <div class="value">${teacher.username != null ? teacher.username : 'Chưa cập nhật'}</div>
                                </div>
                                <div>
                                    <div class="label">Họ và Tên</div>
                                    <div class="value">${teacher.fullName != null ? teacher.fullName : 'Chưa cập nhật'}</div>
                                </div>
                                <div>
                                    <div class="label">Số điện thoại</div>
                                    <div class="value">${teacher.phone != null ? teacher.phone : 'Chưa cập nhật'}</div>
                                </div>
                                <div>
                                    <div class="label">Năm Sinh</div>
                                    <div class="value">
                                        <c:choose>
                                            <c:when test="${teacher.birthDate != null}">
                                                <fmt:formatDate value="${teacher.birthDate}" pattern="dd/MM/yyyy" />
                                            </c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div>
                                    <div class="label">Chuyên môn</div>
                                    <div class="value">${teacher.specialization != null ? teacher.specialization : 'Chưa cập nhật'}</div>
                                </div>
                                <div>
                                    <div class="label">Email</div>
                                    <div class="email-item" id="emailPrimary">
                                        <span>${teacher.email != null ? teacher.email : 'Chưa cập nhật'}</span>
                                        <span class="badge">Primary</span>
                                    </div>
                                </div>
                                <div>
                                    <div class="label">Kinh nghiệm</div>
                                    <div class="value">${teacher.experienceYears > 0 ? teacher.experienceYears : 'Chưa cập nhật'} năm</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="button-group" id="buttonGroup">
                        <button class="btn btn-save" id="saveBtn">Save</button>
                        <button class="btn btn-cancel" id="cancelBtn">Cancel</button>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/teacher_js/profileTeacher.js"></script>
</body>
</html>