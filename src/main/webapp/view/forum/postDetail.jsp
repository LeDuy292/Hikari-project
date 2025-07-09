<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List, java.util.Set, dao.UserDAO, model.forum.ForumPost, model.forum.ForumComment, model.forum.UserActivityScore, model.UserAccount, java.text.SimpleDateFormat, java.sql.Timestamp, dao.forum.ForumPostDAO, service.ForumPermissionService, constant.ForumPermissions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chi Tiết Bài Viết - Diễn Đàn HIKARI</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/postDetail.css" rel="stylesheet" />
        <style>
            /* Role-based styling */
            .role-badge {
                display: inline-block;
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 0.75em;
                font-weight: 600;
                margin-left: 8px;
            }

            .role-badge.admin {
                background: linear-gradient(90deg, #dc2626, #ef4444);
                color: white;
            }

            .role-badge.coordinator {
                background: linear-gradient(90deg, #f59e0b, #fbbf24);
                color: white;
            }

            .role-badge.teacher {
                background: linear-gradient(90deg, #059669, #10b981);
                color: white;
            }

            .role-badge.student {
                background: linear-gradient(90deg, #2563eb, #3b82f6);
                color: white;
            }

            /* Post status indicators */
            .post-status {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                padding: 4px 12px;
                border-radius: 16px;
                font-size: 0.85em;
                font-weight: 500;
                margin-left: 12px;
            }

            .post-status.pinned {
                background: #fbbf24;
                color: #92400e;
            }

            .post-status.hidden {
                background: #ef4444;
                color: white;
            }

            /* Moderation controls */
            .moderation-section {
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                padding: 16px;
                margin: 20px 0;
            }

            .moderation-title {
                font-weight: 600;
                color: #495057;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .moderation-actions {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            .mod-btn {
                padding: 6px 12px;
                border: none;
                border-radius: 6px;
                font-size: 0.85em;
                cursor: pointer;
                transition: all 0.2s;
                display: flex;
                align-items: center;
                gap: 4px;
            }

            .mod-btn.hide {
                background: #ef4444;
                color: white;
            }

            .mod-btn.show {
                background: #10b981;
                color: white;
            }

            .mod-btn.pin {
                background: #f59e0b;
                color: white;
            }

            .mod-btn.unpin {
                background: #6b7280;
                color: white;
            }

            .mod-btn.delete {
                background: #dc2626;
                color: white;
            }

            .mod-btn:hover {
                opacity: 0.8;
                transform: translateY(-1px);
            }

            /* Permission indicators */
            .permission-info {
                background: #e3f2fd;
                border-left: 4px solid #2196f3;
                padding: 12px;
                margin: 16px 0;
                border-radius: 4px;
                font-size: 0.9em;
                color: #1565c0;
            }

            .permission-info i {
                margin-right: 8px;
            }
        </style>
    </head>
    <body>
        <%@ include file="forumHeader.jsp" %>
        <div class="layout">
            <aside class="sidebar-left">
                <div class="topics">
                    <div class="topics-title">Chủ Đề Thảo Luận</div>
                    <ul class="topic-list">
                        <li><a href="<%= request.getContextPath()%>/forum" class="active"><i class="fas fa-arrow-left"></i> Quay Lại Diễn Đàn</a></li>
                        <li><a href="#" data-filter="N5"><span>5</span> JLPT N5</a></li>
                        <li><a href="#" data-filter="N4"><span>4</span> JLPT N4</a></li>
                        <li><a href="#" data-filter="N3"><span>3</span> JLPT N3</a></li>
                        <li><a href="#" data-filter="N2"><span>2</span> JLPT N2</a></li>
                        <li><a href="#" data-filter="N1"><span>1</span> JLPT N1</a></li>
                        <li><a href="#" data-filter="Ngữ pháp"><i class="fas fa-language"></i> Ngữ Pháp</a></li>
                        <li><a href="#" data-filter="Kinh nghiệm thi"><i class="fas fa-lightbulb"></i> Kinh Nghiệm Thi</a></li>
                        <li><a href="#" data-filter="Tài liệu"><i class="fas fa-book"></i> Tài Liệu</a></li>
                        <li><a href="#" data-filter="Công cụ"><i class="fas fa-tools"></i> Công Cụ</a></li>
                    </ul>
                </div>

                <%
                    boolean canModerate = currentUser != null && ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_MODERATE_CONTENT);
                    if (canModerate) {
                %>
                <div class="topics" style="margin-top: 20px;">
                    <div class="topics-title">Quản Lý</div>
                    <ul class="topic-list">
                        <li><a href="<%= request.getContextPath()%>/forum/moderate"><i class="fas fa-shield-alt"></i> Kiểm Duyệt</a></li>
                            <% if (ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_MANAGE_USERS)) {%>
                        <li><a href="<%= request.getContextPath()%>/admin/users"><i class="fas fa-users"></i> Quản Lý User</a></li>
                            <% } %>
                    </ul>
                </div>
                <% } %>
            </aside>
            <main class="main-content">
                <%
                    String message = (String) session.getAttribute("message");
                    if (message != null && !message.isEmpty()) {
                %>
                <div class="alert alert-success">
                    <%= message%>
                </div>
                <%
                        session.removeAttribute("message");
                    }
                %>
                <%
                    ForumPost post = (ForumPost) request.getAttribute("postDetail");
                    String userId = (String) request.getAttribute("userId");
                    if (post != null) {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        String formattedDate = post.getCreatedDate() != null ? sdf.format(post.getCreatedDate()) : "";
                        ForumPostDAO postDAO = new ForumPostDAO();
                        boolean hasLiked = userId != null && postDAO.hasUserLikedPost(post.getId(), userId);

                        // Get post author info
                        UserAccount postAuthor = new UserDAO().getUserById(post.getPostedBy());
                        String authorRole = postAuthor != null ? postAuthor.getRole() : "Student";
                        String authorUsername = postAuthor != null ? postAuthor.getUsername() : "Unknown";

                        // Check permissions for current user
                        boolean canEditPost = currentUser != null && ForumPermissionService.canEditPost(currentUser, post);
                        boolean canDeletePost = currentUser != null && ForumPermissionService.canDeletePost(currentUser, post);
                        boolean canModeratePost = currentUser != null && ForumPermissionService.canModerateCategory(currentUser, post.getCategory());
                        
                        // Check post status
                        boolean isPinned = "PINNED".equals(post.getStatus());
                        boolean isHidden = "HIDDEN".equals(post.getStatus());
                %>
                <div class="post-detail">
                    <div class="post-header">
                        <div class="post-meta">
                            <div class="author-info">
                                <a href="<%= request.getContextPath()%>/profile?userId=<%= postAuthor != null ? postAuthor.getUserID() : ""%>" class="avatar">
                                    <img src="<%= request.getContextPath()%>/<%= postAuthor != null && postAuthor.getProfilePicture() != null && !postAuthor.getProfilePicture().isEmpty() ? postAuthor.getProfilePicture() : "assets/img/avatar.png"%>" alt="Avatar" />
                                </a>
                                <div class="author-details">
                                    <span class="author-name">
                                        <%= authorUsername%>
                                        <span class="role-badge <%= authorRole.toLowerCase()%>">
                                            <%= ForumPermissionService.getRoleDisplayName(authorRole)%>
                                        </span>
                                    </span>
                                    <div class="post-info">
                                        <span><i class="fas fa-clock"></i> <%= formattedDate%></span>
                                        <span><i class="fas fa-eye"></i> <%= post.getViewCount()%> lượt xem</span>
                                        <span><i class="fas fa-tag"></i> <%= post.getCategory()%></span>
                                    </div>
                                </div>
                            </div>
                            <div class="post-status-container">
                                <% if (isPinned) { %>
                                <span class="post-status pinned">
                                    <i class="fas fa-thumbtack"></i>
                                    Bài viết được ghim
                                </span>
                                <% } %>

                                <% if (isHidden) { %>
                                <span class="post-status hidden">
                                    <i class="fas fa-eye-slash"></i>
                                    Bài viết bị ẩn
                                </span>
                                <% }%>
                            </div>
                        </div>
                        <h1 class="post-title"><%= post.getTitle()%></h1>
                    </div>
                    <div class="post-content">
                        <div class="post-body">
                            <p><%= post.getContent().replace("\n", "<br>")%></p>
                        </div>
                        <% if (post.getPicture() != null && !post.getPicture().isEmpty()) {%>
                        <div class="post-image">
                            <img src="<%= post.getPicture()%>" alt="Post image" />
                        </div>
                        <% }%>
                    </div>
                    <div class="post-actions">
                        <button class="action-btn like-btn <%= hasLiked ? "liked" : ""%>" onclick="toggleLike(<%= post.getId()%>, this)">
                            <i class="fas fa-thumbs-up"></i> <span class="like-count"><%= post.getVoteCount()%></span>
                        </button>
                        <button class="action-btn comment-btn" onclick="scrollToComments()">
                            <i class="fas fa-comment"></i> <%= post.getCommentCount()%> bình luận
                        </button>

                        <% if (canEditPost) {%>
                        <a href="<%= request.getContextPath()%>/forum/editPost/<%= post.getId()%>" class="action-btn edit-btn">
                            <i class="fas fa-edit"></i> Chỉnh sửa
                        </a>
                        <% } %>

                        <% if (canDeletePost) {%>
                        <button class="action-btn delete-btn" onclick="confirmDeletePost(<%= post.getId()%>)">
                            <i class="fas fa-trash"></i> Xóa
                        </button>
                        <% } %>
                    </div>

                    <!-- Moderation Section -->
                    <% if (canModeratePost) { %>
                    <div class="moderation-section">
                        <div class="moderation-title">
                            <i class="fas fa-shield-alt"></i>
                            Công cụ kiểm duyệt
                        </div>
                        <div class="moderation-actions">
                            <% if (!isHidden) {%>
                            <button class="mod-btn hide" onclick="moderatePost(<%= post.getId()%>, 'hide')">
                                <i class="fas fa-eye-slash"></i>
                                Ẩn bài viết
                            </button>
                            <% } else {%>
                            <button class="mod-btn show" onclick="moderatePost(<%= post.getId()%>, 'show')">
                                <i class="fas fa-eye"></i>
                                Hiện bài viết
                            </button>
                            <% } %>

                            <% if (ForumPermissionService.canPinPost(currentUser)) { %>
                            <% if (!isPinned) {%>
                            <button class="mod-btn pin" onclick="moderatePost(<%= post.getId()%>, 'pin')">
                                <i class="fas fa-thumbtack"></i>
                                Ghim bài viết
                            </button>
                            <% } else {%>
                            <button class="mod-btn unpin" onclick="moderatePost(<%= post.getId()%>, 'unpin')">
                                <i class="fas fa-times"></i>
                                Bỏ ghim
                            </button>
                            <% } %>
                            <% } %>

                            <% if (canDeletePost) {%>
                            <button class="mod-btn delete" onclick="confirmDeletePost(<%= post.getId()%>)">
                                <i class="fas fa-trash"></i>
                                Xóa bài viết
                            </button>
                            <% } %>
                        </div>
                    </div>
                    <% } %>

                    <!-- Permission Info for Users -->
                    <% if (currentUser != null && !canEditPost && !canDeletePost && post.getPostedBy().equals(currentUser.getUserID())) { %>
                    <div class="permission-info">
                        <i class="fas fa-info-circle"></i>
                        Bạn không thể chỉnh sửa hoặc xóa bài viết này do hạn chế quyền hạn.
                    </div>
                    <% }%>
                </div>

                <!-- Comments Section -->
                <div class="comments-section" id="comments">
                    <div class="comments-header">
                        <h3><i class="fas fa-comments"></i> Bình luận (<%= post.getCommentCount()%>)</h3>
                    </div>

                    <% if (currentUser != null && ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_COMMENT)) {%>
                    <div class="comment-form">
                        <form action="<%= request.getContextPath()%>/forum/comment" method="post">
                            <input type="hidden" name="postId" value="<%= post.getId()%>" />
                            <div class="comment-input-group">
                                <img src="<%= request.getContextPath()%>/<%= currentUser.getProfilePicture() != null && !currentUser.getProfilePicture().isEmpty() ? currentUser.getProfilePicture() : "assets/img/avatar.png"%>" alt="Your avatar" class="comment-avatar" />
                                <textarea name="commentText" placeholder="Viết bình luận của bạn..." required maxlength="1000"></textarea>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane"></i> Gửi
                                </button>
                            </div>
                        </form>
                    </div>
                    <% } else if (currentUser == null) {%>
                    <div class="permission-info">
                        <i class="fas fa-sign-in-alt"></i>
                        <a href="<%= request.getContextPath()%>/view/login.jsp">Đăng nhập</a> để bình luận.
                    </div>
                    <% } else { %>
                    <div class="permission-info">
                        <i class="fas fa-ban"></i>
                        Bạn không có quyền bình luận.
                    </div>
                    <% } %>

                    <div class="comments-list">
                        <%
                            List<ForumComment> comments = post.getComments();
                            if (comments != null && !comments.isEmpty()) {
                                for (ForumComment comment : comments) {
                                    UserAccount commentAuthor = new UserDAO().getUserById(comment.getCommentedBy());
                                    String commentAuthorRole = commentAuthor != null ? commentAuthor.getRole() : "Student";
                                    String commentAuthorUsername = commentAuthor != null ? commentAuthor.getUsername() : "Unknown";
                                    String commentDate = comment.getCommentedDate() != null ? sdf.format(comment.getCommentedDate()) : "";
                        %>
                        <div class="comment">
                            <div class="comment-header">
                                <a href="<%= request.getContextPath()%>/profile?userId=<%= comment.getCommentedBy()%>" class="comment-avatar">
                                    <img src="<%= request.getContextPath()%>/<%= commentAuthor != null && commentAuthor.getProfilePicture() != null && !commentAuthor.getProfilePicture().isEmpty() ? commentAuthor.getProfilePicture() : "assets/img/avatar.png"%>" alt="Avatar" />
                                </a>
                                <div class="comment-info">
                                    <span class="comment-author">
                                        <%= commentAuthorUsername%>
                                        <span class="role-badge <%= commentAuthorRole.toLowerCase()%>">
                                            <%= ForumPermissionService.getRoleDisplayName(commentAuthorRole)%>
                                        </span>
                                    </span>
                                    <span class="comment-date"><i class="fas fa-clock"></i> <%= commentDate%></span>
                                </div>
                            </div>
                            <div class="comment-content">
                                <p><%= comment.getCommentText().replace("\n", "<br>")%></p>
                            </div>
                            <div class="comment-actions">
                                <button class="comment-action-btn">
                                    <i class="fas fa-thumbs-up"></i> <%= comment.getVoteCount()%>
                                </button>
                                <button class="comment-action-btn">
                                    <i class="fas fa-reply"></i> Trả lời
                                </button>
                            </div>
                        </div>
                        <%
                            }
                        } else {
                        %>
                        <div class="no-comments">
                            <i class="fas fa-comment-slash"></i>
                            <p>Chưa có bình luận nào. Hãy là người đầu tiên bình luận!</p>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <%
                } else {
                %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                    Bài viết không tồn tại hoặc đã bị xóa.
                </div>
                <%
                    }
                %>
            </main>
            <aside class="sidebar-right">
                <!-- User Card -->
                <div class="widget" style="padding:0;overflow:hidden;">
                    <div style="background:linear-gradient(135deg,#6a85f1 0%,#b8c6ff 100%);height:90px;position:relative;">
                        <img src="<%= request.getContextPath()%>/assets/img/backgroundLogin.png" alt="Cover" style="width:100%;height:100%;object-fit:cover;opacity:0.7;position:absolute;top:0;left:0;">
                    </div>
                    <div style="display:flex;flex-direction:column;align-items:center;padding:0 0 18px 0;position:relative;top:-40px;">
                        <div style="width:80px;height:80px;border-radius:50%;overflow:hidden;border:4px solid #fff;box-shadow:0 2px 8px rgba(0,0,0,0.08);background:#fff;">
                            <img src="<%= request.getContextPath()%>/<%= currentUser != null && currentUser.getProfilePicture() != null && !currentUser.getProfilePicture().isEmpty() ? currentUser.getProfilePicture() : "assets/img/avatar.png"%>" alt="Avatar" style="width:100%;height:100%;object-fit:cover;">
                        </div>
                        <div style="margin-top:10px;text-align:center;">
                            <div style="color:#888;font-size:1em;">Welcome back,</div>
                            <div style="font-weight:700;font-size:1.2em;">
                                <%= currentUser != null ? currentUser.getUsername() : "Guest"%>
                            </div>
                            <div style="color:#888;font-size:0.98em;">
                                <%= currentUser != null ? ForumPermissionService.getRoleDisplayName(currentUser.getRole()) : "Khách"%>
                            </div>
                            <% if (currentUser != null && ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_FULL_ADMIN)) { %>
                            <span style="display:inline-block;margin-top:7px;padding:2px 14px;font-size:0.95em;background:linear-gradient(90deg,#a18cd1 0%,#fbc2eb 100%);color:#5a189a;border-radius:12px;font-weight:600;">Admin</span>
                            <% }%>
                        </div>
                    </div>
                </div>

                <!-- Related Posts -->
                <%
                    List<ForumPost> relatedPosts = (List<ForumPost>) request.getAttribute("relatedPosts");
                    if (relatedPosts != null && !relatedPosts.isEmpty()) {
                %>
                <div class="widget">
                    <div class="widget-title">
                        <i class="fas fa-newspaper"></i> Bài Viết Liên Quan
                    </div>
                    <div class="related-posts">
                        <%
                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                            for (ForumPost relatedPost : relatedPosts) {
                                String relatedDate = relatedPost.getCreatedDate() != null ? sdf.format(relatedPost.getCreatedDate()) : "";
                        %>
                        <div class="related-post">
                            <a href="<%= request.getContextPath()%>/forum/post/<%= relatedPost.getId()%>" class="related-post-title">
                                <%= relatedPost.getTitle().length() > 60 ? relatedPost.getTitle().substring(0, 60) + "..." : relatedPost.getTitle()%>
                            </a>
                            <div class="related-post-meta">
                                <span><i class="fas fa-eye"></i> <%= relatedPost.getViewCount()%></span>
                                <span><i class="fas fa-comment"></i> <%= relatedPost.getCommentCount()%></span>
                                <span><i class="fas fa-clock"></i> <%= relatedDate%></span>
                            </div>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
                <% }%>

                <!-- Leaderboard -->
                <div class="widget" style="padding-top:18px;">
                    <div style="font-size:1.15em;font-weight:700;color:#232946;margin-bottom:18px;display:flex;align-items:center;gap:10px;">
                        <i class="fas fa-trophy" style="color:#f7c873;"></i> Leaderboard
                    </div>
                    <div style="display:flex;gap:8px;margin-bottom:18px;">
                        <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "weekly".equals(request.getAttribute("timeFrame")) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum?sort=weekly'">This Week</button>
                        <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "monthly".equals(request.getAttribute("timeFrame")) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum?sort=monthly'">This Month</button>
                        <button style="flex:1;padding:7px 0;border:none;border-radius:8px;<%= "alltime".equals(request.getAttribute("timeFrame")) ? "background:#f4f6fb;color:#232946;" : "background:transparent;color:#888;"%>font-weight:600;cursor:pointer;" onclick="window.location.href = '<%= request.getContextPath()%>/forum?sort=alltime'">All Time</button>
                    </div>
                    <div style="display:flex;align-items:flex-end;justify-content:center;gap:18px;margin-bottom:18px;">
                        <%
                            List<UserActivityScore> topUsers = (List<UserActivityScore>) request.getAttribute("topUsers");
                            UserActivityScore first = null, second = null, third = null;
                            if (topUsers != null && topUsers.size() > 0) {
                                first = topUsers.get(0);
                            }
                            if (topUsers != null && topUsers.size() > 1) {
                                second = topUsers.get(1);
                            }
                            if (topUsers != null && topUsers.size() > 2) {
                                third = topUsers.get(2);
                            }
                        %>
                        <% if (second != null) {%>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                <img src="<%= request.getContextPath()%>/<%= second.getUser().getProfilePicture() != null && !second.getUser().getProfilePicture().isEmpty() ? second.getUser().getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                            </div>
                            <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= second.getUser().getUsername()%></div>
                            <div style="color:#888;font-size:0.95em;"><%= second.getTotalScore()%></div>
                        </div>
                        <% } %>
                        <% if (first != null) {%>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <div style="width:60px;height:60px;border-radius:50%;overflow:hidden;border:3px solid #f7c873;box-shadow:0 2px 8px #f7c87344;">
                                <img src="<%= request.getContextPath()%>/<%= first.getUser().getProfilePicture() != null && !first.getUser().getProfilePicture().isEmpty() ? first.getUser().getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                            </div>
                            <div style="font-size:1.05em;font-weight:700;margin-top:4px;color:#f7c873;"><%= first.getUser().getUsername()%></div>
                            <div style="color:#232946;font-size:1.05em;font-weight:700;"><%= first.getTotalScore()%></div>
                        </div>
                        <% } %>
                        <% if (third != null) {%>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                <img src="<%= request.getContextPath()%>/<%= third.getUser().getProfilePicture() != null && !third.getUser().getProfilePicture().isEmpty() ? third.getUser().getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                            </div>
                            <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= third.getUser().getUsername()%></div>
                            <div style="color:#888;font-size:0.95em;"><%= third.getTotalScore()%></div>
                        </div>
                        <% } %>
                    </div>
                    <div>
                        <%
                            int rank = 4;
                            if (topUsers != null && topUsers.size() > 3) {
                                for (int i = 3; i < Math.min(topUsers.size(), 9); i++) {
                                    UserActivityScore score = topUsers.get(i);
                                    UserAccount user = score.getUser();
                        %>
                        <div style="display:flex;align-items:center;gap:10px;padding:7px 0 7px 0;border-radius:8px;<%= i == 4 ? "background:#f4f6fb;" : ""%>">
                            <div style="width:28px;text-align:center;font-weight:600;color:#232946;font-size:1.08em;"><%= rank%></div>
                            <div style="width:32px;height:32px;border-radius:50%;overflow:hidden;">
                                <img src="<%= request.getContextPath()%>/<%= user.getProfilePicture() != null && !user.getProfilePicture().isEmpty() ? user.getProfilePicture() : "assets/img/avatar.png"%>" style="width:100%;height:100%;object-fit:cover;">
                            </div>
                            <div style="flex:1;">
                                <div style="font-weight:600;font-size:1em;color:#232946;"><%= user.getUsername()%></div>
                            </div>
                            <div style="color:#888;font-size:1em;font-weight:500;"><%= score.getTotalScore()%></div>
                        </div>
                        <%      rank++;
                                }
                            }
                        %>
                    </div>
                </div>
            </aside>
        </div>

        <script>
            function toggleLike(postId, button) {
                const userId = "<%= request.getAttribute("userId") != null ? request.getAttribute("userId") : ""%>";
                if (!userId) {
                    alert("Vui lòng đăng nhập để thích bài viết!");
                    window.location.href = "<%= request.getContextPath()%>/view/login.jsp";
                    return;
                }
                const isLiked = button.classList.contains("liked");
                const url = "<%= request.getContextPath()%>/forum/toggleLike";
                fetch(url, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
                })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                const likeCountSpan = button.querySelector(".like-count");
                                likeCountSpan.textContent = data.voteCount;
                                if (isLiked) {
                                    button.classList.remove("liked");
                                } else {
                                    button.classList.add("liked");
                                }
                            } else {
                                alert(data.message || "Có lỗi xảy ra khi thích bài viết!");
                            }
                        })
                        .catch(error => {
                            console.error("Error:", error);
                            alert("Có lỗi xảy ra khi thích bài viết!");
                        });
            }

            function scrollToComments() {
                document.getElementById('comments').scrollIntoView({behavior: 'smooth'});
            }

            function moderatePost(postId, action) {
                let confirmMessage = "";
                switch (action) {
                    case 'hide':
                        confirmMessage = "Bạn có chắc chắn muốn ẩn bài viết này?";
                        break;
                    case 'show':
                        confirmMessage = "Bạn có chắc chắn muốn hiện bài viết này?";
                        break;
                    case 'pin':
                        confirmMessage = "Bạn có chắc chắn muốn ghim bài viết này?";
                        break;
                    case 'unpin':
                        confirmMessage = "Bạn có chắc chắn muốn bỏ ghim bài viết này?";
                        break;
                    default:
                        confirmMessage = "Bạn có chắc chắn muốn thực hiện hành động này?";
                }

                if (confirm(confirmMessage)) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '<%= request.getContextPath()%>/forum/moderate';

                    const postIdInput = document.createElement('input');
                    postIdInput.type = 'hidden';
                    postIdInput.name = 'postId';
                    postIdInput.value = postId;
                    form.appendChild(postIdInput);

                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = action;
                    form.appendChild(actionInput);

                    document.body.appendChild(form);
                    form.submit();
                }
            }

            function confirmDeletePost(postId) {
                if (confirm("Bạn có chắc chắn muốn xóa bài viết này? Hành động này không thể hoàn tác.")) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '<%= request.getContextPath()%>/forum/deletePost';

                    const postIdInput = document.createElement('input');
                    postIdInput.type = 'hidden';
                    postIdInput.name = 'postId';
                    postIdInput.value = postId;
                    form.appendChild(postIdInput);

                    document.body.appendChild(form);
                    form.submit();
                }
            }
        </script>
        <%@include file="chatbox.jsp" %>
    </body>
</html>
