<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.List, java.util.Set, dao.UserDAO, model.forum.ForumPost, model.forum.ForumComment, model.forum.UserActivityScore, model.UserAccount, java.text.SimpleDateFormat, java.sql.Timestamp, dao.forum.ForumPostDAO, service.ForumPermissionService, constant.ForumPermissions" %>
<%!
    public String escapeHtml(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Diễn Đàn Luyện Thi HIKARI</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/mainForum.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/moderationForum.css" rel="stylesheet" />

    </head>
    <body>
        <%@ include file="forumHeader.jsp" %>
        <div class="layout">
            <aside class="sidebar-left">
                <div class="topics">
                    <div class="topics-title">Chủ Đề Thảo Luận</div>
                    <ul class="topic-list">
                        <li><a href="#" data-filter="all" class="active"><i class="fas fa-star"></i> Tất Cả</a></li>
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
                    <%= escapeHtml(message)%>
                </div>
                <%
                        session.removeAttribute("message");
                    }
                %>
                <div class="forum-toolbar">
                    <h1>Bài Viết Mới Nhất</h1>
                    <div class="toolbar-actions">
                        <div class="search-container" style="position: relative;">
                            <input type="text" id="searchInput" placeholder="Tìm kiếm bài viết..." value="<%= request.getParameter("search") != null ? escapeHtml(request.getParameter("search")) : ""%>">
                            <div id="suggestionList" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: #fff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); z-index: 100; max-height: 200px; overflow-y: auto;"></div>
                        </div>
                        <button class="btn btn-primary" onclick="handleSearch()"><i class="fas fa-search"></i> Tìm</button>

                        <% if (currentUser != null && ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_CREATE_POSTS)) { %>
                        <button class="btn btn-primary" onclick="openPostModal()">
                            <i class="fas fa-plus"></i> Tạo Bài Viết Mới
                        </button>
                        <% }%>

                        <div class="filters">
                            <select id="sortSelect" onchange="handleSortChange()">
                                <option value="newest" <%= "newest".equals(request.getAttribute("sort")) ? "selected" : ""%>>Mới Nhất</option>
                                <option value="popular" <%= "popular".equals(request.getAttribute("sort")) ? "selected" : ""%>>Phổ Biến</option>
                                <option value="most-liked" <%= "most-liked".equals(request.getAttribute("sort")) ? "selected" : ""%>>Được Thích Nhiều</option>
                            </select>
                            <select id="filterSelect" onchange="handleFilterChange()">
                                <option value="all" <%= "all".equals(request.getAttribute("filter")) ? "selected" : ""%>>Tất Cả</option>
                                <option value="with-replies" <%= "with-replies".equals(request.getAttribute("filter")) ? "selected" : ""%>>Có Phản Hồi</option>
                                <option value="no-replies" <%= "no-replies".equals(request.getAttribute("filter")) ? "selected" : ""%>>Chưa Có Phản Hồi</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="post-list">
                    <%
                        List<ForumPost> posts = (List<ForumPost>) request.getAttribute("posts");
                        Set<Integer> viewedPostIds = (Set<Integer>) request.getAttribute("viewedPostIds");
                        String userId = (String) request.getAttribute("userId");
                        ForumPostDAO postDAO = new ForumPostDAO();
                        if (posts == null || posts.isEmpty()) {
                    %>
                    <p>Chưa có bài viết nào.</p>
                    <%
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        for (ForumPost post : posts) {
                            String postPicture = post.getPicture() != null ? post.getPicture() : "";
                            Timestamp createdDate = post.getCreatedDate();
                            String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                            boolean hasLiked = userId != null && postDAO.hasUserLikedPost(post.getId(), userId);
                            boolean isRead = viewedPostIds != null && viewedPostIds.contains(post.getId());

                            // Get post author info
                            UserAccount postAuthor = new UserDAO().getUserById(post.getPostedBy());
                            String authorRole = postAuthor != null ? postAuthor.getRole() : "Student";
                            String authorUsername = postAuthor != null ? postAuthor.getFullName() : "Unknown";

                            // Check moderation permissions for current post
                            boolean canModeratePost = currentUser != null && ForumPermissionService.canModerateCategory(currentUser, post.getCategory());
                            boolean canEditPost = currentUser != null && ForumPermissionService.canEditPost(currentUser, post);
                            boolean canDeletePost = currentUser != null && ForumPermissionService.canDeletePost(currentUser, post);

                            // Check post status
                            boolean isPinned = post.isPinned();
                            boolean isHidden = post.isHidden();
                    %>
                    <div class="post-card <%= isRead ? "read" : "unread"%>" data-tags="<%= escapeHtml(post.getCategory())%>">
                        <div class="post-header">
                            <a href="<%= request.getContextPath()%>/profile?userId=<%= post.getPostedBy()%>">
                                <img src="<%= postAuthor != null && postAuthor.getProfilePicture() != null && !postAuthor.getProfilePicture().isEmpty()
                                        ? (postAuthor.getProfilePicture().startsWith("http") ? postAuthor.getProfilePicture() : (request.getContextPath() + "/" + postAuthor.getProfilePicture()))
                                        : (request.getContextPath() + "/assets/img/avatar.png")%>" alt="Avatar" />
                            </a>
                            <div class="author-info">
                                <span class="author-name">
                                    <%= escapeHtml(authorUsername)%>
                                    <span class="role-badge <%= authorRole.toLowerCase()%>">
                                        <%= ForumPermissionService.getRoleDisplayName(authorRole)%>
                                    </span>
                                </span>
                                <div class="post-meta">
                                    <span><i class="fas fa-clock"></i> <%= formattedDate%></span>
                                    <span><i class="fas fa-eye"></i> <%= post.getViewCount()%></span>
                                    <span><i class="fas fa-comment"></i> <%= post.getCommentCount()%></span>
                                </div>
                            </div>
                            <div class="post-tags">
                                <span class="tag"><%= escapeHtml(post.getCategory())%></span>

                                <% if (isPinned) { %>
                                <span class="post-status pinned">
                                    <i class="fas fa-thumbtack"></i>
                                    Ghim
                                </span>
                                <% } %>

                                <% if (isHidden) { %>
                                <span class="post-status hidden">
                                    <i class="fas fa-eye-slash"></i>
                                    Ẩn
                                </span>
                                <% } %>

                                <% if (isRead) { %>
                                <span class="read-indicator">
                                    <i class="fas fa-check"></i>
                                    Đã đọc
                                </span>
                                <% } else { %>
                                <span class="unread-indicator">
                                    <i class="fas fa-circle"></i>
                                    Mới
                                </span>
                                <% }%>
                            </div>
                        </div>
                        <a href="<%= request.getContextPath()%>/forum/post/<%= post.getId()%>" class="post-title"><%= escapeHtml(post.getTitle())%></a>
                        <div class="post-body">
                            <p><%= escapeHtml(post.getContent().length() > 200 ? post.getContent().substring(0, 200) + "..." : post.getContent())%></p>
                        </div>
                        <% if (!postPicture.isEmpty()) {%>
                        <div class="post-image">
                            <img src="<%= escapeHtml(postPicture)%>" alt="Post image" />
                        </div>
                        <% }%>
                        <div class="post-actions">
                            <button class="action-btn like-btn <%= hasLiked ? "liked" : ""%>" onclick="toggleLike(<%= post.getId()%>, this)">
                                <i class="fas fa-thumbs-up"></i> <span class="like-count"><%= post.getVoteCount()%></span>
                            </button>
                            <a href="<%= request.getContextPath()%>/forum/post/<%= post.getId()%>" class="action-btn comment-btn">
                                <i class="fas fa-comment"></i> <%= post.getCommentCount()%>
                            </a>

                            <% if (canEditPost) {%>
                            <a href="<%= request.getContextPath()%>/forum/editPost/<%= post.getId()%>" class="action-btn edit-btn">
                                <i class="fas fa-edit"></i> Sửa
                            </a>
                            <% } %>

                            <% if (canModeratePost) {%>
                            <button class="action-btn mod-btn" onclick="toggleModerationControls(<%= post.getId()%>)">
                                <i class="fas fa-shield-alt"></i> Kiểm duyệt
                            </button>
                            <% } %>
                        </div>

                        <% if (canModeratePost) {%>
                        <div class="moderation-controls" id="mod-controls-<%= post.getId()%>">
                            <% if (!isHidden) {%>
                            <button class="mod-btn hide" onclick="moderatePost(<%= post.getId()%>, 'hide')">
                                <i class="fas fa-eye-slash"></i> Ẩn
                            </button>
                            <% } else {%>
                            <button class="mod-btn show" onclick="moderatePost(<%= post.getId()%>, 'show')">
                                <i class="fas fa-eye"></i> Hiện
                            </button>
                            <% } %>

                            <% if (ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_FULL_ADMIN)) { %>
                            <% if (!isPinned) {%>
                            <button class="mod-btn pin" onclick="moderatePost(<%= post.getId()%>, 'pin')">
                                <i class="fas fa-thumbtack"></i> Ghim
                            </button>
                            <% } else {%>
                            <button class="mod-btn unpin" onclick="moderatePost(<%= post.getId()%>, 'unpin')">
                                <i class="fas fa-times"></i> Bỏ ghim
                            </button>
                            <% } %>
                            <% } %>

                            <% if (canDeletePost) {%>
                            <button class="mod-btn delete" onclick="confirmDeletePost(<%= post.getId()%>)">
                                <i class="fas fa-trash"></i> Xóa
                            </button>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
                <div class="pagination">
                    <%
                        Integer pageNum = (Integer) request.getAttribute("page");
                        String sort = (String) request.getAttribute("sort");
                        String filter = (String) request.getAttribute("filter");
                        String search = request.getParameter("search") != null ? request.getParameter("search") : "";
                        if (pageNum != null && pageNum > 1) {
                    %>
                    <a href="<%= request.getContextPath()%>/forum?sort=<%= escapeHtml(sort)%>&filter=<%= escapeHtml(filter)%>&search=<%= escapeHtml(search)%>&page=<%= pageNum - 1%>">« Trang Trước</a>
                    <%
                        }
                        if (posts != null && !posts.isEmpty()) {
                    %>
                    <a href="<%= request.getContextPath()%>/forum?sort=<%= escapeHtml(sort)%>&filter=<%= escapeHtml(filter)%>&search=<%= escapeHtml(search)%>&page=<%= pageNum != null ? pageNum + 1 : 2%>">Trang Sau »</a>
                    <%
                        }
                    %>
                </div>
            </main>
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
                                <%= currentUser != null ? escapeHtml(currentUser.getFullName()) : "Guest"%>
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
                        <div style="color: red;">Không có dữ liệu Leaderboard</div>
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
                                String[] nameParts = second.getUser().getFullName().trim().split("\\s+");
                                String secondName = nameParts[nameParts.length - 1];
                        %>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <a href="<%= request.getContextPath()%>/profile?userId=<%= second.getUser().getUserID()%>">
                                <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                    <img src="<%= secondAvatar%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                            </a>
                            <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= escapeHtml(secondName)%></div>
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
                                String[] nameParts = first.getUser().getFullName().trim().split("\\s+");
                                String firstName = nameParts[nameParts.length - 1];
                        %>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <a href="<%= request.getContextPath()%>/profile?userId=<%= first.getUser().getUserID()%>">
                                <div style="width:60px;height:60px;border-radius:50%;overflow:hidden;border:3px solid #f7c873;box-shadow:0 2px 8px #f7c87344;">
                                    <img src="<%= firstAvatar%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                            </a>
                            <div style="font-size:1.05em;font-weight:700;margin-top:4px;color:#f7c873;"><%= escapeHtml(firstName)%></div>
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
                                String[] nameParts = third.getUser().getFullName().trim().split("\\s+");
                                String thirdName = nameParts[nameParts.length - 1];
                        %>
                        <div style="display:flex;flex-direction:column;align-items:center;">
                            <a href="<%= request.getContextPath()%>/profile?userId=<%= third.getUser().getUserID()%>">
                                <div style="width:48px;height:48px;border-radius:50%;overflow:hidden;border:3px solid #b8c6ff;">
                                    <img src="<%= thirdAvatar%>" style="width:100%;height:100%;object-fit:cover;">
                                </div>
                            </a>
                            <div style="font-size:0.95em;font-weight:600;margin-top:4px;"><%= escapeHtml(thirdName)%></div>
                            <div style="color:#888;font-size:0.95em;"><%= third.getTotalScore()%></div>
                        </div>
                        <% } %>
                    </div>
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
                            <div style="font-weight:600;font-size:1em;color:#232946;"><%= escapeHtml(user.getFullName())%></div>
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

        <% if (currentUser != null && ForumPermissionService.hasPermission(currentUser, ForumPermissions.PERM_CREATE_POSTS)) {%>
        <div class="modal-overlay" id="createPostModal">
            <div class="modal">
                <div class="modal-header">
                    <h2 class="modal-title">Tạo Bài Viết Mới</h2>
                    <button class="btn" onclick="closePostModal()"><i class="fas fa-times"></i></button>
                </div>
                <div class="modal-body">
                    <form id="createPostForm" action="<%= request.getContextPath()%>/forum/createPost" method="post" enctype="multipart/form-data">
                        <div class="form-group">
                            <label class="form-label" for="postTitle">Tiêu đề</label>
                            <input type="text" class="form-control" id="postTitle" name="postTitle" placeholder="Nhập tiêu đề bài viết..." required maxlength="200" />
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="postCategory">Chủ đề</label>
                            <select class="form-control" id="postCategory" name="postCategory" required>
                                <option value="">Chọn chủ đề</option>
                                <%
                                    List<String> allowedCategories = ForumPermissionService.getAllowedCategories(currentUser);
                                    for (String category : allowedCategories) {
                                %>
                                <option value="<%= escapeHtml(category)%>"><%= escapeHtml(category)%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="postContent">Nội Dung</label>
                            <textarea class="form-control" id="postContent" name="postContent" rows="6" placeholder="Nhập nội dung bài viết..." required maxlength="5000"></textarea>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Hình Ảnh</label>
                            <div class="image-upload" onclick="document.getElementById('imageInput').click()">
                                <input type="file" id="imageInput" name="imageInput" accept="image/*" onchange="previewImage(event)" />
                                <i class="fas fa-cloud-upload-alt" style="font-size: 2em; margin-bottom: 10px"></i>
                                <p>Nhấp để chọn hình ảnh hoặc kéo thả vào đây</p>
                                <img id="imagePreview" class="image-preview" style="display:none;" alt="Preview" />
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" onclick="document.getElementById('createPostForm').submit()">Đăng Bài</button>
                    <button class="btn" onclick="closePostModal()">Đóng</button>
                </div>
            </div>
        </div>
        <% }%>

        <script>
            const forumUserId = "<%= request.getAttribute("userId") != null ? request.getAttribute("userId") : ""%>";
            const forumContextPath = "<%= request.getContextPath()%>";
        </script>
        <script src="${pageContext.request.contextPath}/assets/js/forum/mainForum.js"></script>
        <%@include file="chatbox.jsp" %>
    </body>
</html>
