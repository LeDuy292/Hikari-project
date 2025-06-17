<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.UserDAO, model.ForumPost, model.ForumComment, model.UserActivityScore, model.User, java.text.SimpleDateFormat, java.sql.Timestamp, dao.ForumPostDAO" %>
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
    <title>Chi tiết bài viết - JLPT Forum</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/forum/postDetail.css" rel="stylesheet" />
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
                <a href="<%= request.getContextPath() %>/forum" class="nav-link">
                    <i class="fas fa-comments"></i>
                    <span>Diễn đàn</span>
                </a>
                <a href="<%= request.getContextPath() %>/contact" class="nav-link">
                    <i class="fas fa-envelope"></i>
                    <span>Liên hệ</span>
                </a>

                <div class="user-menu">
                    <button class="user-btn" onclick="toggleUserMenu()">
                        <div class="avatar">
                            <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                        </div>
                        <span><%= escapeHtml((String) request.getAttribute("username")) %></span>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <div class="dropdown" id="userDropdown">
                        <% 
                            String username = (String) request.getAttribute("username");
                            if ("Guest".equals(username)) {
                        %>
                            <a href="<%= request.getContextPath() %>/login" class="dropdown-item">
                                <i class="fas fa-sign-in-alt"></i>
                                Đăng nhập
                            </a>
                        <% 
                            } else {
                        %>
                            <a href="<%= request.getContextPath() %>/profile" class="dropdown-item">
                                <i class="fas fa-user"></i>
                                Hồ sơ cá nhân
                            </a>
                            <a href="<%= request.getContextPath() %>/settings" class="dropdown-item">
                                <i class="fas fa-cog"></i>
                                Cài đặt
                            </a>
                            <a href="<%= request.getContextPath() %>/logout" class="dropdown-item">
                                <i class="fas fa-sign-out-alt"></i>
                                Đăng xuất
                            </a>
                        <% 
                            }
                        %>
                    </div>
                </div>
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
            <span>Chi tiết bài viết</span>
        </nav>

        <!-- Back Button -->
        <a href="<%= request.getContextPath() %>/forum" class="back-button">
            <i class="fas fa-arrow-left"></i>
            Quay lại diễn đàn
        </a>

        <!-- Alert -->
        <% 
            String message = (String) session.getAttribute("message");
            if (message != null && !message.isEmpty()) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= escapeHtml(message) %>
            </div>
            <% 
                session.removeAttribute("message");
            }
        %>

        <% 
            ForumPost post = (ForumPost) request.getAttribute("postDetail");
            String currentUserId = (String) request.getSession().getAttribute("userId");
            if (post == null) {
        %>
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <h3 class="empty-title">Bài viết không tồn tại</h3>
                <p>Bài viết này có thể đã bị xóa hoặc bạn không có quyền truy cập.</p>
            </div>
        <% 
            } else {
                ForumPostDAO postDAO = new ForumPostDAO();
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                String postPicture = post.getPicture() != null ? post.getPicture() : "";
                Timestamp createdDate = post.getCreatedDate();
                String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                boolean hasLiked = currentUserId != null && postDAO.hasUserLikedPost(post.getId(), currentUserId);
                boolean isAuthor = currentUserId != null && post.getPostedBy().equals(currentUserId);
        %>

        <!-- Post Container -->
        <article class="post-container">
            <!-- Post Header -->
            <header class="post-header">
                <div class="post-meta">
                    <div class="author-info">
                        <div class="author-avatar">
                            <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                        </div>
                        <div class="author-details">
                            <h3>
                                <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(post.getPostedBy()) %>" style="color: inherit; text-decoration: none;">
                                    <%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy())) %>
                                </a>
                            </h3>
                            <p>
                                <i class="fas fa-clock"></i>
                                <%= formattedDate %>
                            </p>
                        </div>
                    </div>
                    <% if (isAuthor) { %>
                    <div class="post-actions">
                        <button class="actions-btn" onclick="toggleActionsMenu()">
                            <i class="fas fa-ellipsis-v"></i>
                        </button>
                        <div class="actions-menu" id="actionsMenu">
                            <a href="<%= request.getContextPath() %>/forum/editPost/<%= post.getId() %>">
                                <i class="fas fa-edit"></i>
                                Chỉnh sửa
                            </a>
                            <button class="delete-btn" onclick="confirmDelete(<%= post.getId() %>)">
                                <i class="fas fa-trash"></i>
                                Xóa bài viết
                            </button>
                        </div>
                    </div>
                    <% } %>
                </div>
                <h1 class="post-title"><%= escapeHtml(post.getTitle()) %></h1>
                <div class="post-category">
                    <i class="fas fa-tag"></i>
                    <%= escapeHtml(post.getCategory()) %>
                </div>
            </header>

            <!-- Post Content -->
            <div class="post-content">
                <% if (postPicture != null && !postPicture.isEmpty()) { %>
                    <div class="post-image">
                        <img src="<%= request.getContextPath() %>/<%= escapeHtml(postPicture) %>" alt="Post image" />
                    </div>
                <% } %>
                <div class="post-text">
                    <%= escapeHtml(post.getContent()).replace("\n", "<br>") %>
                </div>
            </div>

            <!-- Post Stats -->
            <div class="post-stats">
                <div class="stats-row">
                    <div class="stats-info">
                        <div class="stat-item">
                            <i class="fas fa-thumbs-up"></i>
                            <span><%= post.getVoteCount() %> lượt thích</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-comment"></i>
                            <span><%= post.getCommentCount() %> bình luận</span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-eye"></i>
                            <span><%= post.getViewCount() %> lượt xem</span>
                        </div>
                    </div>
                    <div class="interaction-buttons">
                        <button class="interaction-btn <%= hasLiked ? "liked" : "" %>" onclick="toggleLike(<%= post.getId() %>, this)">
                            <i class="fas fa-thumbs-up"></i>
                            <span class="like-count"><%= post.getVoteCount() %></span>
                        </button>
                        <button class="interaction-btn" onclick="focusCommentForm()">
                            <i class="fas fa-comment"></i>
                            Bình luận
                        </button>
                        <button class="interaction-btn" onclick="sharePost()">
                            <i class="fas fa-share"></i>
                            Chia sẻ
                        </button>
                    </div>
                </div>
            </div>
        </article>

        <!-- Comments Section -->
        <section class="comments-section">
            <div class="comments-header">
                <h2 class="comments-title">
                    <i class="fas fa-comments"></i>
                    Bình luận (<%= post.getCommentCount() %>)
                </h2>
            </div>

            <div class="comments-list">
                <% 
                    List<ForumComment> comments = post.getComments();
                    if (comments != null && !comments.isEmpty()) {
                        for (ForumComment comment : comments) {
                            Timestamp commentDate = comment.getCommentedDate();
                            String formattedCommentDate = commentDate != null ? sdf.format(commentDate) : "";
                %>
                    <div class="comment-item">
                        <div class="comment-header">
                            <div class="comment-avatar">
                                <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                            </div>
                            <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(comment.getCommentedBy()) %>" class="comment-author">
                                <%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy())) %>
                            </a>
                            <span class="comment-date">
                                <i class="fas fa-clock"></i>
                                <%= formattedCommentDate %>
                            </span>
                        </div>
                        <div class="comment-content">
                            <%= escapeHtml(comment.getCommentText()).replace("\n", "<br>") %>
                        </div>
                        <div class="comment-actions">
                            <button class="comment-action">
                                <i class="fas fa-thumbs-up"></i>
                                <%= comment.getVoteCount() %>
                            </button>
                            <button class="comment-action" onclick="replyToComment(<%= comment.getId() %>)">
                                <i class="fas fa-reply"></i>
                                Phản hồi
                            </button>
                        </div>
                    </div>
                <% 
                        }
                    } else {
                %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-comment-slash"></i>
                        </div>
                        <h3 class="empty-title">Chưa có bình luận nào</h3>
                        <p>Hãy là người đầu tiên bình luận cho bài viết này!</p>
                    </div>
                <% 
                    }
                %>
            </div>

            <!-- Comment Form -->
            <form action="<%= request.getContextPath() %>/forum/createComment" method="post" class="comment-form" id="commentForm">
                <input type="hidden" name="postId" value="<%= post.getId() %>">
                <div class="form-group">
                    <textarea class="form-control" name="commentText" id="commentText" placeholder="Viết bình luận của bạn..." required></textarea>
                </div>
                <div class="form-footer">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                        Gửi bình luận
                    </button>
                </div>
            </form>
        </section>

        <!-- Related Posts -->
        <section class="related-posts">
            <div class="related-header">
                <h2 class="related-title">
                    <i class="fas fa-link"></i>
                    Bài viết liên quan
                </h2>
            </div>
            <div class="related-list">
                <% 
                    List<ForumPost> relatedPosts = (List<ForumPost>) request.getAttribute("relatedPosts");
                    if (relatedPosts != null && !relatedPosts.isEmpty()) {
                        for (ForumPost relatedPost : relatedPosts) {
                            String relatedPicture = relatedPost.getPicture() != null ? relatedPost.getPicture() : "";
                            Timestamp relatedDate = relatedPost.getCreatedDate();
                            String formattedRelatedDate = relatedDate != null ? sdf.format(relatedDate) : "";
                %>
                    <a href="<%= request.getContextPath() %>/forum/post/<%= relatedPost.getId() %>" class="related-item">
                        <div class="related-image">
                            <img src="<%= request.getContextPath() %>/<%= relatedPicture != null && !relatedPicture.isEmpty() ? escapeHtml(relatedPicture) : "assets/img/learning.jpg" %>" alt="Related post" />
                        </div>
                        <div class="related-content">
                            <h3 class="related-post-title">
                                <%= escapeHtml(relatedPost.getTitle()) %>
                            </h3>
                            <div class="related-meta">
                                <span>
                                    <i class="fas fa-clock"></i>
                                    <%= formattedRelatedDate %>
                                </span>
                                <span>
                                    <i class="fas fa-comment"></i>
                                    <%= relatedPost.getCommentCount() %> bình luận
                                </span>
                                <span>
                                    <i class="fas fa-eye"></i>
                                    <%= relatedPost.getViewCount() %> lượt xem
                                </span>
                            </div>
                        </div>
                    </a>
                <% 
                        }
                    } else {
                %>
                    <div class="empty-state">
                        <div class="empty-icon">
                            <i class="fas fa-link"></i>
                        </div>
                        <h3 class="empty-title">Không có bài viết liên quan</h3>
                        <p>Hiện tại chưa có bài viết nào cùng danh mục.</p>
                    </div>
                <% 
                    }
                %>
            </div>
        </section>

        <% } %>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">
                    <i class="fas fa-exclamation-triangle" style="color: var(--danger);"></i>
                    Xác nhận xóa
                </h3>
                <p class="modal-text">Bạn có chắc chắn muốn xóa bài viết này? Hành động này không thể hoàn tác.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                <button class="btn btn-danger" onclick="deletePost()">Xóa bài viết</button>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/forum/postDetail.js"></script>
    <%@include file="chatbox.jsp" %>
</body>
</html>
