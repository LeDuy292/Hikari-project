<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.UserAccount" %>
<%
    UserAccount user = (UserAccount) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chỉnh sửa hồ sơ cá nhân</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/editUserProfileForum.css" rel="stylesheet" />
    </head>
    <body>
        <%@ include file="forumHeader.jsp" %>
        <div class="edit-profile-container">
            <form class="edit-profile-form" action="<%=request.getContextPath()%>/profile/edit" method="post" enctype="multipart/form-data">
                <h2><i class="fas fa-user-edit"></i> Chỉnh sửa hồ sơ cá nhân</h2>
                <div class="avatar-preview">
                    <!-- Avatar preview -->
                    <img id="avatarImg"
                         src="<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() ? user.getProfilePicture() : (request.getContextPath() + "/assets/img/avatar.png")%>"
                         alt="Avatar" />
                    <label class="upload-btn">
                        <i class="fas fa-camera"></i> Đổi ảnh đại diện
                        <input type="file" name="avatar" accept="image/*" onchange="previewImage(this, 'avatarImg')" />
                    </label>
                </div>
                <div class="cover-preview">
                    <!-- Cover preview -->
                    <img id="coverImg"
                         src="<%= user.getCoverPhoto() != null && !user.getCoverPhoto().isEmpty() ? user.getCoverPhoto() : (request.getContextPath() + "/assets/img/backgroundLogin.png")%>"
                         alt="Cover" />
                    <label class="upload-btn">
                        <i class="fas fa-image"></i> Đổi ảnh bìa
                        <input type="file" name="coverPhoto" accept="image/*" onchange="previewImage(this, 'coverImg')" />
                    </label>
                </div>
                <%
                    String bioValue = user.getBio();
                    if (bioValue == null || bioValue.trim().isEmpty()) {
                        bioValue = "";
                    }
                %>
                <div class="form-group">
                    <label>Tiểu sử</label>
                    <input type="text" name="bio"
                           placeholder="Bạn có thể giới thiệu ngắn gọn về bản thân tại đây..."
                           value="<%= bioValue%>" maxlength="100" />
                </div>       
                <div class="form-group">
                    <label>Họ tên</label>
                    <input type="text" name="fullName" value="<%= user.getFullName()%>" required maxlength="100" />
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="<%= user.getEmail()%>" required maxlength="100" />
                </div>
                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : ""%>" maxlength="20" />
                </div>
                <div class="form-group">
                    <label>Ngày sinh</label>
                    <input type="date" name="birthDate" value="<%= user.getBirthDate() != null ? sdf.format(user.getBirthDate()) : ""%>" />
                </div>
                <input type="hidden" name="userId" value="<%= user.getUserID()%>" />
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Lưu thay đổi</button>
                    <a href="<%=request.getContextPath()%>/profile?userId=<%= user.getUserID()%>" class="btn btn-secondary">Hủy</a>
                </div>
                <% String message = (String) session.getAttribute("message");
                    if (message != null) {%>
                <div class="alert"><%= message%></div>
                <% session.removeAttribute("message");
                    }
                %>
            </form>
        </div>
        <script>
            function previewImage(input, imgId) {
                if (input.files && input.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        document.getElementById(imgId).src = e.target.result;
                    }
                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
    </body>
</html>