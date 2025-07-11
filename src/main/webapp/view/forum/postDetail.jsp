<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List, java.util.Set, dao.UserDAO, model.forum.ForumPost, model.forum.ForumComment, model.forum.UserActivityScore, model.UserAccount, java.text.SimpleDateFormat, java.sql.Timestamp, dao.forum.ForumPostDAO, service.ForumPermissionService, constant.ForumPermissions" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Chi Tiết Bài Viết - Diễn Đàn HIKARI</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/postDetail.css" rel="stylesheet" />
    </head>
    <body>
        <%@ include file="forumHeader.jsp" %>
        <%
            ForumPost post = (ForumPost) request.getAttribute("postDetail");
            UserAccount author = post != null ? new UserDAO().getUserById(post.getPostedBy()) : null;
            UserActivityScore authorScore = null;
            List<UserActivityScore> allScores = (List<UserActivityScore>) request.getAttribute("topUsers");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String userId = (String) request.getAttribute("userId");
            if (author != null && allScores != null) {
                for (UserActivityScore s : allScores) {
                    if (s.getUserId().equals(author.getUserID())) {
                        authorScore = s;
                        break;
                    }
                }
            }
        %>
        <div class="container">
            <div class="content-wrapper">
                <aside class="sidebar-left">
                    <div class="widget user-card">
                        <div class="widget-title">
                            <i class="fas fa-user-circle"></i>
                            Thông tin tác giả
                        </div>
                        <% if (author != null) {%>
                        <div class="avatar">
                            <a href="<%= request.getContextPath() %>/profile?userId=<%= author.getUserID() %>">
                                <%
                                    String authorAvatar = author.getProfilePicture();
                                    if (authorAvatar == null || authorAvatar.isEmpty()) {
                                        authorAvatar = request.getContextPath() + "/assets/img/avatar.png";
                                    } else if (!authorAvatar.startsWith("http")) {
                                        authorAvatar = request.getContextPath() + "/" + authorAvatar;
                                    }
                                %>
                                <img src="<%= authorAvatar %>" alt="Avatar" />
                            </a>
                        </div>
                        <div class="username">
                            <%= author.getUsername()%>
                        </div>
                        <div class="role">
                            <%= ForumPermissionService.getRoleDisplayName(author.getRole())%>
                            <% if (author.getRole() != null && author.getRole().toLowerCase().contains("admin")) { %>
                            <span class="role-badge admin">Admin</span>
                            <% } else if (author.getRole().toLowerCase().contains("coordinator")) { %>
                            <span class="role-badge coordinator">Coordinator</span>
                            <% } else if (author.getRole().toLowerCase().contains("teacher")) { %>
                            <span class="role-badge teacher">Teacher</span>
                            <% } else { %>
                            <span class="role-badge student">Student</span>
                            <% } %>
                        </div>
                        <div class="user-stats">
                            <div class="stat-item">
                                <span class="value"><%= authorScore != null ? authorScore.getTotalComments() : 0%></span>
                                <span class="label">Bình luận</span>
                            </div>
                            <div class="stat-item">
                                <span class="value"><%= authorScore != null ? authorScore.getTotalVotes() : 0%></span>
                                <span class="label">Lượt thích</span>
                            </div>
                        </div>
                        <% } else { %>
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="fas fa-user-slash"></i>
                            </div>
                            <h3 class="empty-title">Không tìm thấy tác giả</h3>
                        </div>
                        <% } %>
                    </div>
                    
                    <section class="related-posts">
                        <div class="related-header">
                            <h2 class="related-title">
                                <i class="fas fa-newspaper"></i>
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
                            <a href="<%= request.getContextPath()%>/forum/post/<%= relatedPost.getId()%>" class="related-item">
                                <div class="related-image">
                                    <img src="<%= relatedPicture != null && !relatedPicture.isEmpty() 
    ? (relatedPicture.startsWith("http") ? relatedPicture : (request.getContextPath() + "/" + relatedPicture))
    : (request.getContextPath() + "/assets/img/learning.jpg") %>" alt="Related post" />
                                </div>
                                <div class="related-content">
                                    <h3 class="related-post-title">
                                        <%= relatedPost.getTitle()%>
                                    </h3>
                                    <div class="related-meta">
                                        <span>
                                            <i class="fas fa-calendar-alt"></i>
                                            <%= formattedRelatedDate%>
                                        </span>
                                        <span>
                                            <i class="fas fa-comment"></i>
                                            <%= relatedPost.getCommentCount()%>
                                        </span>
                                        <span>
                                            <i class="fas fa-eye"></i>
                                            <%= relatedPost.getViewCount()%>
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
                                    <i class="fas fa-newspaper"></i>
                                </div>
                                <h3 class="empty-title">Không có bài viết liên quan</h3>
                                <p>Hiện tại chưa có bài viết nào cùng danh mục.</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </section>
                </aside>
                <div class="main-content">
                    <nav class="breadcrumb">
                        <a href="<%= request.getContextPath()%>/forum">
                            <i class="fas fa-comments"></i>
                            Diễn đàn
                        </a>
                        <i class="fas fa-chevron-right"></i>
                        <span>Chi tiết bài viết</span>
                    </nav>
                    <a href="<%= request.getContextPath()%>/forum" class="back-button">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại diễn đàn
                    </a>
                    <%
                        String message = (String) session.getAttribute("message");
                        if (message != null && !message.isEmpty()) {
                    %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <%= message%>
                    </div>
                    <%
                            session.removeAttribute("message");
                        }
                    %>
                    <%
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
                        String postPicture = post.getPicture() != null ? post.getPicture() : "";
                        Timestamp createdDate = post.getCreatedDate();
                        String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                        boolean hasLiked = userId != null && postDAO.hasUserLikedPost(post.getId(), userId);
                        boolean canEditPost = currentUser != null && ForumPermissionService.canEditPost(currentUser, post);
                        boolean canDeletePost = currentUser != null && ForumPermissionService.canDeletePost(currentUser, post);
                        boolean canModeratePost = currentUser != null && ForumPermissionService.canModerateCategory(currentUser, post.getCategory());
                        boolean isPinned = "PINNED".equals(post.getStatus());
                        boolean isHidden = "HIDDEN".equals(post.getStatus());
                    %>
                    <article class="post-container">
                        <header class="post-header">
                            <div class="post-meta">
                                <div class="author-info">
                                    <div class="author-avatar">
                                        <a href="<%= request.getContextPath() %>/profile?userId=<%= author.getUserID() %>">
                                            <img src="<%= author.getProfilePicture() != null && !author.getProfilePicture().isEmpty() ? author.getProfilePicture() : (request.getContextPath() + "/assets/img/avatar.png") %>" alt="Avatar" />
                                        </a>
                                    </div>
                                    <div class="author-details">
                                        <h3>
                                            <a href="<%= request.getContextPath()%>/profile?userId=<%= author != null ? author.getUserID() : ""%>" style="color: inherit; text-decoration: none;">
                                                <%= author != null ? author.getUsername() : "Unknown"%>
                                                <span class="role-badge <%= author != null ? author.getRole().toLowerCase() : "student"%>">
                                                    <%= author != null ? ForumPermissionService.getRoleDisplayName(author.getRole()) : "Student"%>
                                                </span>
                                            </a>
                                        </h3>
                                        <p>
                                            <i class="fas fa-clock"></i>
                                            <%= formattedDate%>
                                            <span style="margin-left: 1rem;">
                                                <i class="fas fa-eye"></i>
                                                <%= post.getViewCount()%> lượt xem
                                            </span>
                                        </p>
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
                                    <% } %>
                                </div>
                            </div>
                            <h1 class="post-title"><%= post.getTitle()%></h1>
                            <div class="post-category">
                                <i class="fas fa-tag"></i>
                                <%= post.getCategory()%>
                            </div>
                        </header>
                        <div class="post-content">
                            <div class="post-text">
                                <%= post.getContent().replace("\n", "<br>")%>
                            </div>
                            <% if (postPicture != null && !postPicture.isEmpty()) { %>
                            <div class="post-image">
                                <img src="<%= postPicture.startsWith("http") ? postPicture : (request.getContextPath() + "/" + postPicture) %>" alt="Post image" />
                            </div>
                            <% } %>
                        </div>
                        <div class="post-stats">
                            <div class="stats-row">
                                <button class="interaction-btn like-btn <%= hasLiked ? "liked" : ""%>" onclick="toggleLike(<%= post.getId()%>, this)">
                                    <i class="fas fa-thumbs-up"></i>
                                    <span class="like-count"><%= post.getVoteCount()%> Thích</span>
                                </button>
                                <button class="interaction-btn comment-btn" onclick="focusCommentForm()">
                                    <i class="fas fa-comment"></i>
                                    <span><%= post.getCommentCount()%> Bình luận</span>
                                </button>
                                <button class="interaction-btn" onclick="sharePost()">
                                    <i class="fas fa-share"></i>
                                    Chia sẻ
                                </button>
                            </div>
                        </div>
                        <% if (canModeratePost) { %>
                        <div class="moderation-section center">
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
                        <% if (currentUser != null && !canEditPost && !canDeletePost && post.getPostedBy().equals(currentUser.getUserID())) { %>
                        <div class="permission-info">
                            <i class="fas fa-info-circle"></i>
                            Bạn không thể chỉnh sửa hoặc xóa bài viết này do hạn chế quyền hạn.
                        </div>
                        <% }%>
                        <section class="comments-section" id="comments">
                            <div class="comments-header">
                                <h2 class="comments-title">
                                    <i class="fas fa-comments"></i>
                                    Bình luận (<%= post.getCommentCount()%>)
                                </h2>
                            </div>
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
                                <div class="comment-item">
                                    <div class="comment-header">
                                        <div class="comment-avatar">
                                            <a href="<%= request.getContextPath() %>/profile?userId=<%= comment.getCommentedBy() %>">
                                                <img src="<%= commentAuthor != null && commentAuthor.getProfilePicture() != null && !commentAuthor.getProfilePicture().isEmpty()
                                                    ? (commentAuthor.getProfilePicture().startsWith("http") ? commentAuthor.getProfilePicture() : (request.getContextPath() + "/" + commentAuthor.getProfilePicture()))
                                                    : (request.getContextPath() + "/assets/img/avatar.png") %>" alt="Avatar" />
                                            </a>
                                        </div>
                                        <a href="<%= request.getContextPath()%>/profile?userId=<%= comment.getCommentedBy()%>" class="comment-author">
                                            <%= commentAuthorUsername%>
                                            <span class="role-badge <%= commentAuthorRole.toLowerCase()%>">
                                                <%= ForumPermissionService.getRoleDisplayName(commentAuthorRole)%>
                                            </span>
                                        </a>
                                        <span class="comment-date">
                                            <i class="fas fa-clock"></i>
                                            <%= commentDate%>
                                        </span>
                                    </div>
                                    <div class="comment-content">
                                        <%= comment.getCommentText().replace("\n", "<br>")%>
                                    </div>
                                    <div class="comment-actions">
                                        <button class="comment-action" onclick="toggleCommentLike(<%= comment.getId()%>, this)">
                                            <i class="fas fa-thumbs-up"></i>
                                            <%= comment.getVoteCount()%>
                                        </button>
                                        <button class="comment-action" onclick="replyToComment(<%= comment.getId()%>)">
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
                            <% if (currentUser != null && ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_COMMENT)) {%>
                            <form action="<%= request.getContextPath() %>/forum/createComment" method="post" class="comment-form">
                                <input type="hidden" name="postId" value="<%= post.getId() %>"/>
                                <textarea class="form-control" name="commentText" id="commentText" placeholder="Viết bình luận..." required maxlength="1000"></textarea>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Gửi</button>
                            </form>
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
                        </section>
                    </article>
                    <% }%>
                </div>
                <aside class="sidebar-right">
                <!-- User Card -->
                <div class="widget" style="padding:0;overflow:hidden;">
                    <div style="background:linear-gradient(135deg,#6a85f1 0%,#b8c6ff 100%);height:90px;position:relative;">
                        <img src="<%= request.getContextPath()%>/assets/img/backgroundLogin.png" alt="Cover" style="width:100%;height:100%;object-fit:cover;opacity:0.7;position:absolute;top:0;left:0;">
                    </div>
                    <div style="display:flex;flex-direction:column;align-items:center;padding:0 0 18px 0;position:relative;top:-40px;">
                        <div style="width:80px;height:80px;border-radius:50%;overflow:hidden;border:4px solid #fff;box-shadow:0 2px 8px rgba(0,0,0,0.08);background:#fff;">
                            <%
                                String sidebarAvatar = null;
                                if (currentUser != null && currentUser.getProfilePicture() != null && !currentUser.getProfilePicture().isEmpty()) {
                                    sidebarAvatar = currentUser.getProfilePicture();
                                    if (!sidebarAvatar.matches("^https?://.*")) {
                                        sidebarAvatar = request.getContextPath() + "/" + sidebarAvatar;
                                    }
                                } else {
                                    sidebarAvatar = request.getContextPath() + "/assets/img/avatar.png";
                                }
                            %>
                            <img src="<%= sidebarAvatar%>" alt="Avatar" style="width:100%;height:100%;object-fit:cover;">
                        </div>
                        <div style="margin-top:10px;text-align:center;">
                            <div style="color:#888;font-size:1em;">Welcome back,</div>
                            <div style="font-weight:700;font-size:1.2em;">
                                <%= currentUser != null ? (currentUser.getUsername()) : "Guest"%>
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

                <%-- Leaderboard --%>
                <div class="widget" style="padding-top:18px;">
                    <div style="font-size:1.15em;font-weight:700;color:#232946;margin-bottom:18px;display:flex;align-items:center;gap:10px;">
                        <i class="fas fa-trophy" style="color:#f7c873;"></i> Leaderboard
                    </div>
                    <div style="display:flex;gap:8px;margin-bottom:18px;">
                        <!-- ...các nút lọc leaderboard... -->
                    </div>
                    <div style="display:flex;align-items:flex-end;justify-content:center;gap:18px;margin-bottom:18px;">
                        <%
                            List<UserActivityScore> topUsers = (List<UserActivityScore>) request.getAttribute("topUsers");
                            if (topUsers == null) {
                        %>
                        <div style="color: red;">Không có dữ liệu Leaderboard - Kiểm tra Servlet hoặc DAO</div>
                        <%
                            }
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
                        <% if (second != null) {
                                String secondAvatar = second.getUser().getProfilePicture();
                                if (secondAvatar == null || secondAvatar.isEmpty()) {
                                    secondAvatar = request.getContextPath() + "/assets/img/avatar.png";
                                } else if (!secondAvatar.matches("^https?://.*")) {
                                    secondAvatar = request.getContextPath() + "/" + secondAvatar;
                                }
                        %>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <a href="<%= request.getContextPath()%>/profile?userId=<%= second.getUser().getUserID()%>">
                                <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                    <img src="<%= secondAvatar%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                            </a>
                            <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= second.getUser().getUsername()%></div>
                            <div style="color:#888;font-size:0.95em;"><%= second.getTotalScore()%></div>
                        </div>
                        <% } %>
                        <% if (first != null) {
                                String firstAvatar = first.getUser().getProfilePicture();
                                if (firstAvatar == null || firstAvatar.isEmpty()) {
                                    firstAvatar = request.getContextPath() + "/assets/img/avatar.png";
                                } else if (!firstAvatar.matches("^https?://.*")) {
                                    firstAvatar = request.getContextPath() + "/" + firstAvatar;
                                }
                        %>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <a href="<%= request.getContextPath()%>/profile?userId=<%= first.getUser().getUserID()%>">
                                <div style="width:60px;height:60px;border-radius:50%;overflow:hidden;border:3px solid #f7c873;box-shadow:0 2px 8px #f7c87344;">
                                    <img src="<%= firstAvatar%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                            </a>
                            <div style="font-size:1.05em;font-weight:700;margin-top:4px;color:#f7c873;"><%= first.getUser().getUsername()%></div>
                            <div style="color:#232946;font-size:1.05em;font-weight:700;"><%= first.getTotalScore()%></div>
                        </div>
                        <% } %>
                        <% if (third != null) {
                                String thirdAvatar = third.getUser().getProfilePicture();
                                if (thirdAvatar == null || thirdAvatar.isEmpty()) {
                                    thirdAvatar = request.getContextPath() + "/assets/img/avatar.png";
                                } else if (!thirdAvatar.matches("^https?://.*")) {
                                    thirdAvatar = request.getContextPath() + "/" + thirdAvatar;
                                }
                        %>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <a href="<%= request.getContextPath()%>/profile?userId=<%= third.getUser().getUserID()%>">
                                <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                    <img src="<%= thirdAvatar%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                            </a>
                            <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= third.getUser().getUsername()%></div>
                            <div style="color:#888;font-size:0.95em;"><%= third.getTotalScore()%></div>
                        </div>
                        <% } %>
                    </div>

                    <div>
                        <%
                            int rank = 4;
                            if (topUsers != null && topUsers.size() > 3) {
                                for (int i = 3; i < Math.min(topUsers.size(), 10); i++) {
                                    UserActivityScore score = topUsers.get(i);
                                    UserAccount user = score.getUser();
                                    String userAvatar = user.getProfilePicture();
                                    if (userAvatar == null || userAvatar.isEmpty()) {
                                        userAvatar = request.getContextPath() + "/assets/img/avatar.png";
                                    } else if (!userAvatar.matches("^https?://.*")) {
                                        userAvatar = request.getContextPath() + "/" + userAvatar;
                                    }
                        %>
                        <div style="display:flex;align-items:center;gap:10px;padding:7px 0 7px 0;border-radius:8px;<%= i == 4 ? "background:#f4f6fb;" : ""%>">
                            <div style="width:28px;text-align:center;font-weight:600;color:#232946;font-size:1.08em;"><%= rank%></div>
                            <div style="width:32px;height:32px;border-radius:50%;overflow:hidden;">
                                <a href="<%= request.getContextPath()%>/profile?userId=<%= user.getUserID()%>">
                                    <img src="<%= userAvatar%>" style="width:100%;height:100%;object-fit:cover;">
                                </a>
                            </div>
                            <div style="flex:1;">
                                <div style="font-weight:600;font-size:1em;color:#232946;"><%= user.getUsername()%></div>
                            </div>
                            <div style="color:#888;font-size:1em;font-weight:500;"><%= score.getTotalScore()%></div>
                        </div>
                        <%
                                    rank++;
                                }
                            }
                        %>
                    </div>
            </aside>
            </div>
        </div>
        <div class="modal-overlay" id="deleteModal">
            <div class="modal">
                <div class="modal-header">
                    <h3 class="modal-title">
                        <i class="fas fa-exclamation-triangle" style="color: #dc2626;"></i>
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
        <script>
            let postIdToDelete = null;
            function toggleLike(postId, button) {
                const userId = "<%= userId != null ? userId : ""%>";
                if (!userId) {
                    alert("Vui lòng đăng nhập để thích bài viết!");
                    window.location.href = "<%= request.getContextPath()%>/view/login.jsp";
                    return;
                }
                const isLiked = button.classList.contains("liked");
                const url = "<%= request.getContextPath()%>/forum/toggleLike";
                button.disabled = true;
                fetch(url, {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            button.querySelector(".like-count").textContent = `${data.voteCount} Thích`;
                            button.classList.toggle("liked");
                        } else {
                            alert(data.message || "Có lỗi xảy ra!");
                        }
                    })
                    .catch(error => {
                        console.error("Error:", error);
                        alert("Có lỗi xảy ra!");
                    })
                    .finally(() => {
                        button.disabled = false;
                    });
            }
            function toggleCommentLike(commentId, button) {
                const userId = "<%= userId != null ? userId : ""%>";
                if (!userId) {
                    alert("Vui lòng đăng nhập để thích bình luận!");
                    window.location.href = "<%= request.getContextPath()%>/view/login.jsp";
                    return;
                }
                const url = "<%= request.getContextPath()%>/forum/toggleCommentLike";
                fetch(url, {
                    method: "POST",
                    headers: {"Content-Type": "application/x-www-form-urlencoded"},
                    body: "commentId=" + commentId
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            button.innerHTML = `<i class="fas fa-thumbs-up"></i> ${data.voteCount}`;
                        } else {
                            alert(data.message || "Có lỗi xảy ra khi thích bình luận!");
                        }
                    })
                    .catch(error => {
                        console.error("Error:", error);
                        alert("Có lỗi xảy ra khi thích bình luận!");
                    });
            }
            function focusCommentForm() {
                const commentText = document.getElementById('commentText');
                commentText.focus();
                commentText.scrollIntoView({behavior: 'smooth', block: 'center'});
            }
            function replyToComment(commentId) {
                const commentText = document.getElementById('commentText');
                commentText.value = `@comment-${commentId} `;
                commentText.focus();
                commentText.scrollIntoView({behavior: 'smooth', block: 'center'});
            }
            function sharePost() {
                if (navigator.share) {
                    navigator.share({title: document.title, url: window.location.href});
                } else {
                    navigator.clipboard.writeText(window.location.href).then(() => {
                        alert('Đã sao chép liên kết vào clipboard!');
                    });
                }
            }
            function moderatePost(postId, action) {
                let confirmMessage = "";
                switch (action) {
                    case 'hide': confirmMessage = "Bạn có chắc chắn muốn ẩn bài viết này?"; break;
                    case 'show': confirmMessage = "Bạn có chắc chắn muốn hiện bài viết này?"; break;
                    case 'pin': confirmMessage = "Bạn có chắc chắn muốn ghim bài viết này?"; break;
                    case 'unpin': confirmMessage = "Bạn có chắc chắn muốn bỏ ghim bài viết này?"; break;
                    default: confirmMessage = "Bạn có chắc chắn muốn thực hiện hành động này?";
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
                postIdToDelete = postId;
                document.getElementById('deleteModal').classList.add('active');
                document.body.style.overflow = 'hidden';
            }
            function closeDeleteModal() {
                document.getElementById('deleteModal').classList.remove('active');
                document.body.style.overflow = '';
                postIdToDelete = null;
            }
            function deletePost() {
                if (postIdToDelete) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '<%= request.getContextPath()%>/forum/deletePost';
                    const postIdInput = document.createElement('input');
                    postIdInput.type = 'hidden';
                    postIdInput.name = 'postId';
                    postIdInput.value = postIdToDelete;
                    form.appendChild(postIdInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            }
            document.getElementById('deleteModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeDeleteModal();
                }
            });
            document.getElementById('commentText')?.addEventListener('input', function () {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
        </script>
        <%@include file="chatbox.jsp" %>
    </body>
</html>