<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ForumPost, model.User" %>
<%!
    public String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chỉnh sửa bài viết - JLPT Forum</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/forum/editPost.css" rel="stylesheet" />
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="<%= request.getContextPath() %>/" class="logo">
                <div class="logo-icon">
                    <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo" />
                </div>
                <span>JLPT Forum</span>
            </a>

            <nav class="nav">
                <a href="<%= request.getContextPath() %>/" class="nav-link">
                    <i class="fas fa-home"></i>
                    <span>Trang chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/forum" class="nav-link active">
                    <i class="fas fa-comments"></i>
                    <span>Diễn đàn</span>
                </a>
                <a href="<%= request.getContextPath() %>/contact" class="nav-link">
                    <i class="fas fa-envelope"></i>
                    <span>Liên hệ</span>
                </a>
            </nav>
        </div>
    </header>

    <!-- Main Container -->
    <div class="container">
        <!-- Breadcrumb -->
        <nav class="breadcrumb">
            <a href="<%= request.getContextPath() %>/forum">
                <i class="fas fa-comments"></i>
                Diễn đàn
            </a>
            <i class="fas fa-chevron-right"></i>
            <span>Chỉnh sửa bài viết</span>
        </nav>

        <!-- Back Button -->
        <% 
            ForumPost post = (ForumPost) request.getAttribute("post");
            if (post != null) {
        %>
        <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Quay lại bài viết
        </a>
        <% } else { %>
        <a href="<%= request.getContextPath() %>/forum" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Quay lại diễn đàn
        </a>
        <% } %>

        <!-- Alert -->
        <% 
            String message = (String) session.getAttribute("message");
            if (message != null && !message.isEmpty()) {
                String alertClass = message.contains("thành công") ? "alert-success" : "alert-danger";
        %>
            <div class="alert <%= alertClass %>">
                <i class="fas fa-<%= message.contains("thành công") ? "check-circle" : "exclamation-triangle" %>"></i>
                <%= escapeHtml(message) %>
            </div>
            <% 
                session.removeAttribute("message");
            }
        %>

        <% if (post == null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle"></i>
                Bài viết không tồn tại hoặc bạn không có quyền chỉnh sửa!
            </div>
        <% } else { %>

        <!-- Form Container -->
        <div class="form-container">
            <div class="form-header">
                <h1 class="form-title">
                    <i class="fas fa-edit"></i>
                    Chỉnh sửa bài viết
                </h1>
                <p class="form-subtitle">Cập nhật nội dung bài viết của bạn</p>
            </div>

            <form action="<%= request.getContextPath() %>/forum/editPost/<%= post.getId() %>" method="post" enctype="multipart/form-data" id="editForm">
                <input type="hidden" name="postId" value="<%= post.getId() %>">
                
                <div class="form-body">
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
                            value="<%= escapeHtml(post.getTitle()) %>" 
                            placeholder="Nhập tiêu đề bài viết..." 
                            required 
                            maxlength="200"
                        />
                        <div class="character-counter" id="titleCounter">0/200 ký tự</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="postCategory">
                            <i class="fas fa-tag"></i>
                            Danh mục
                        </label>
                        <select class="form-control select" id="postCategory" name="postCategory" required>
                            <option value="">Chọn danh mục</option>
                            <option value="N5" <%= "N5".equals(post.getCategory()) ? "selected" : "" %>>JLPT N5</option>
                            <option value="N4" <%= "N4".equals(post.getCategory()) ? "selected" : "" %>>JLPT N4</option>
                            <option value="N3" <%= "N3".equals(post.getCategory()) ? "selected" : "" %>>JLPT N3</option>
                            <option value="N2" <%= "N2".equals(post.getCategory()) ? "selected" : "" %>>JLPT N2</option>
                            <option value="N1" <%= "N1".equals(post.getCategory()) ? "selected" : "" %>>JLPT N1</option>
                            <option value="Ngữ pháp" <%= "Ngữ pháp".equals(post.getCategory()) ? "selected" : "" %>>Ngữ pháp</option>
                            <option value="Kinh nghiệm thi" <%= "Kinh nghiệm thi".equals(post.getCategory()) ? "selected" : "" %>>Kinh nghiệm thi</option>
                            <option value="Tài liệu" <%= "Tài liệu".equals(post.getCategory()) ? "selected" : "" %>>Tài liệu</option>
                            <option value="Công cụ" <%= "Công cụ".equals(post.getCategory()) ? "selected" : "" %>>Công cụ</option>
                        </select>
                    </div>

                    <div class="form-group">
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
                        ><%= escapeHtml(post.getContent()) %></textarea>
                        <div class="character-counter" id="contentCounter">0/5000 ký tự</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-image"></i>
                            Hình ảnh
                        </label>
                        
                        <% if (post.getPicture() != null && !post.getPicture().isEmpty()) { %>
                            <div class="current-image">
                                <span class="current-image-label">Hình ảnh hiện tại:</span>
                                <img src="<%= request.getContextPath() %>/<%= escapeHtml(post.getPicture()) %>" alt="Current image" />
                            </div>
                        <% } %>
                        
                        <div class="file-upload-area" onclick="document.getElementById('imageInput').click()">
                            <input 
                                type="file" 
                                id="imageInput" 
                                name="imageInput" 
                                accept="image/*" 
                                onchange="previewImage(event)" 
                                class="file-upload-input"
                            />
                            <div class="upload-icon">
                                <i class="fas fa-cloud-upload-alt"></i>
                            </div>
                            <div class="upload-text">
                                <%= post.getPicture() != null && !post.getPicture().isEmpty() ? "Thay đổi hình ảnh" : "Thêm hình ảnh" %>
                            </div>
                            <div class="upload-hint">Nhấp để chọn hình ảnh mới hoặc kéo thả vào đây (PNG, JPG, GIF tối đa 10MB)</div>
                        </div>
                        
                        <div id="imagePreview" class="image-preview" style="display: none;">
                            <img alt="Preview" />
                        </div>
                    </div>
                </div>

                <div class="form-footer">
                    <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="btn btn-secondary">
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

        <% } %>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/forum/mainForum.js"></script>
    
</body>
</html>