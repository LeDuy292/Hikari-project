<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.forum.ForumPost, model.UserAccount, service.ForumPermissionService, java.util.List" %>

<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chỉnh sửa bài viết - JLPT Learning</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/editPost.css" rel="stylesheet" />
    </head>
    <body>
        <%@ include file="forumHeader.jsp" %>

        <div class="container">
            <nav class="breadcrumb fade-in">
                <a href="<%= request.getContextPath()%>/forum">
                    <i class="fas fa-comments"></i>
                    Diễn đàn
                </a>
                <i class="fas fa-chevron-right"></i>
                <span>Chỉnh sửa bài viết</span>
            </nav>

            <%
                ForumPost post = (ForumPost) request.getAttribute("post");
                if (post != null) {
            %>
            <a href="<%= request.getContextPath()%>/forum/post/<%= post.getId()%>" class="back-button fade-in">
                <i class="fas fa-arrow-left"></i>
                Quay lại bài viết
            </a>
            <% } else {%>
            <a href="<%= request.getContextPath()%>/forum" class="back-button fade-in">
                <i class="fas fa-arrow-left"></i>
                Quay lại diễn đàn
            </a>
            <% } %>

            <%
                String message = (String) session.getAttribute("message");
                if (message != null && !message.isEmpty()) {
                    String alertClass = message.contains("thành công") ? "alert-success" : "alert-danger";
            %>
            <div class="alert <%= alertClass%> fade-in">
                <i class="fas fa-<%= message.contains("thành công") ? "check-circle" : "exclamation-triangle"%>"></i>
                <span><%= message%></span>
            </div>
            <%
                    session.removeAttribute("message");
                }
            %>

            <% if (post == null) { %>
            <div class="alert alert-danger fade-in">
                <i class="fas fa-exclamation-triangle"></i>
                <span>Bài viết không tồn tại hoặc bạn không có quyền chỉnh sửa!</span>
            </div>
            <% } else {
                List<String> allowedCategories = (List<String>) request.getAttribute("allowedCategories");
            %>
            <div class="form-container fade-in">
                <div class="form-header">
                    <h1 class="form-title">
                        <i class="fas fa-edit"></i>
                        Chỉnh sửa bài viết
                    </h1>
                    <p class="form-subtitle">Cập nhật nội dung bài viết của bạn</p>
                </div>

                <form action="<%= request.getContextPath()%>/forum/editPost/<%= post.getId()%>" method="post" enctype="multipart/form-data" id="editForm">
                    <input type="hidden" name="postId" value="<%= post.getId()%>">

                    <div class="form-body">
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label" for="postTitle">
                                    <i class="fas fa-heading"></i>
                                    Tiêu đề bài viết
                                </label>
                                <input 
                                    type="text" 
                                    class="form-control" 
                                    id="postTitle" 
                                    name="postTitle" 
                                    value="<%= post.getTitle()%>" 
                                    placeholder="Nhập tiêu đề..." 
                                    required 
                                    maxlength="200"
                                    />
                                <div class="character-counter" id="titleCounter">0/200</div>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="postCategory">
                                    <i class="fas fa-tag"></i>
                                    Danh mục
                                </label>
                                <select class="form-control select" id="postCategory" name="postCategory" required>
                                    <option value="">Chọn danh mục</option>
                                    <% if (allowedCategories != null) {
                                            for (String category : allowedCategories) {%>
                                    <option value="<%= category%>" <%= category.equals(post.getCategory()) ? "selected" : ""%>><%= category%></option>
                                    <% }
                                        }%>
                                </select>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label" for="postContent">
                                <i class="fas fa-align-left"></i>
                                Nội dung bài viết
                            </label>
                            <textarea 
                                class="form-control" 
                                id="postContent" 
                                name="postContent" 
                                placeholder="Chia sẻ suy nghĩ của bạn..." 
                                required
                                maxlength="5000"
                                ><%= post.getContent()%></textarea>
                            <div class="character-counter" id="contentCounter">0/5000</div>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label">
                                <i class="fas fa-image"></i>
                                Hình ảnh
                            </label>

                            <% if (post.getPicture() != null && !post.getPicture().isEmpty()) {%>
                            <div class="current-image-preview">
                                <img src="<%= post.getPicture()%>" alt="Current image" />
                            </div>
                            <% }%>

                            <div class="file-upload-compact" onclick="document.getElementById('imageInput').click()">
                                <input 
                                    type="file" 
                                    id="imageInput" 
                                    name="imageInput" 
                                    accept="image/*" 
                                    onchange="previewImage(event)" 
                                    class="file-upload-input"
                                    />
                                <div class="upload-content">
                                    <div class="upload-icon">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                    </div>
                                    <div>
                                        <div class="upload-text">
                                            <%= post.getPicture() != null && !post.getPicture().isEmpty() ? "Thay đổi hình ảnh" : "Thêm hình ảnh"%>
                                        </div>
                                        <div class="upload-hint">PNG, JPG, GIF (tối đa 10MB)</div>
                                    </div>
                                </div>
                            </div>

                            <div id="imagePreview" class="image-preview" style="display: none;">
                                <img alt="Preview" />
                            </div>
                        </div>
                    </div>

                    <div class="form-footer">
                        <a href="<%= request.getContextPath()%>/forum/post/<%= post.getId()%>" class="btn btn-secondary">
                            <i class="fas fa-times"></i>
                            Hủy
                        </a>
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="fas fa-save"></i>
                            Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>

            <% }%>
        </div>

        <script>
       const forumUserId = "<%= request.getAttribute("userId") != null ? request.getAttribute("userId") : ""%>";
       const forumContextPath = "<%= request.getContextPath()%>";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/forum/editPost.js"></script>
    </body>
</html>
