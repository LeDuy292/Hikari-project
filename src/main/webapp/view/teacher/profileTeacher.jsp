<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Hồ Sơ Của Tôi - Nền Tảng Giáo Dục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <!-- Font Awesome -->
        <!-- Google Fonts for Elegant Font -->
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
                <!-- Main Content -->
                        <div class="profile-info">
                            <img src="${user.avatarUrl != null ? user.avatarUrl : 'https://via.placeholder.com/100x100'}" alt="Ảnh đại diện" class="profile-avatar" />
                            <div>
                                <div class="profile-header">
                                    <div>
                                        <div class="user-name">${user.fullName != null ? user.fullName : 'Alerd Rowlies'}</div>
                                        <div class="email">${user.email != null ? user.email : 'clonerenciap@gmail.com'}</div>
                                    </div>
                                </div>
                                <div class="profile-details">
                                    <div>
                                        <div class="label">Username</div>
                                        <div class="value">${user.username != null ? user.username : 'alerdrowlies'}</div>
                                    </div>
                                    <div>
                                        <div class="label">Họ và Tên</div>
                                        <div class="value">${user.fullName != null ? user.fullName : 'Alerd Rowlies'}</div>
                                    </div>
                                    <div>
                                        <div class="label">Số điện thoại</div>
                                        <div class="value">${user.phone != null ? user.phone : '1990'}</div>
                                    </div>
                                    <div>
                                        <div class="label">Năm Sinh</div>
                                        <div class="value">${user.birthYear != null ? user.birthYear : '1990'}</div>
                                    </div>
                                    <div>
                                        <div class="label">Địa Chỉ</div>
                                        <div class="value">${user.address != null ? user.address : 'Hà Nội, Việt Nam'}</div>
                                    </div>
                                    <div>
                                        <div class="label">Email</div>
                                        <div class="email-item" id="emailPrimary">
                                            <span>${user.primaryEmail != null ? user.primaryEmail : 'alexarawles@gmail.com'}</span>
                                            <span class="badge">Primary</span>
                                        </div>
                                    </div>
                                    <div>
                                        <div class="label">Giới Tính</div>
                                        <div class="value">${user.gender != null ? user.gender : 'Nam'}</div>
                                    </div>
                                    <div>
                                        <div class="label">Kinh Nghiệm</div>
                                        <div class="value">${user.experience != null ? user.experience : '5 năm'}</div>
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