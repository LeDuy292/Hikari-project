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
    <title>Diễn Đàn Luyện Thi JLPT</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <link href="${pageContext.request.contextPath}/assets/css/forum/mainForum.css" rel="stylesheet" />
</head>
<body>
    <div class="topbar">
        <div class="logo">
            <div class="logo-icon">
                <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo" class="logo-img" />
            </div>
            Diễn Đàn Luyện Thi JLPT
        </div>
        <nav class="nav">
            <a href="<%= request.getContextPath() %>/"><i class="fas fa-home"></i> Trang Chủ</a>
            <a href="<%= request.getContextPath() %>/contact"><i class="fas fa-phone"></i> Liên Hệ</a>
            <div class="account-dropdown" id="accountDropdown">
                <button class="account-btn" onclick="toggleDropdown(event)">
                    <div class="avatar sm">
                        <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                    </div>
                    <%= escapeHtml((String) request.getAttribute("username")) %> <i class="fas fa-caret-down"></i>
                </button>
                <div class="dropdown-menu">
                    <% 
                        String username = (String) request.getAttribute("username");
                        if ("Guest".equals(username)) {
                    %>
                        <a href="<%= request.getContextPath() %>/login"><i class="fas fa-sign-in-alt"></i> Đăng Nhập</a>
                    <% 
                        } else {
                    %>
                        <a href="<%= request.getContextPath() %>/profile"><i class="fas fa-user"></i> Hồ Sơ Cá Nhân</a>
                        <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
                    <% 
                        }
                    %>
                </div>
            </div>
        </nav>
    </div>
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
        </aside>
        <main class="main-content">
            <% 
                String message = (String) session.getAttribute("message");
                if (message != null && !message.isEmpty()) {
            %>
                <div class="alert alert-success">
                    <%= escapeHtml(message) %>
                </div>
                <% 
                    session.removeAttribute("message");
                }
            %>
            <div class="forum-toolbar">
    <h1>Bài Viết Mới Nhất</h1>
    <div class="toolbar-actions">
        <div class="search-container" style="position: relative;">
            <input type="text" id="searchInput" placeholder="Tìm kiếm bài viết..." value="<%= request.getParameter("search") != null ? escapeHtml(request.getParameter("search")) : "" %>">
            <div id="suggestionList" style="display: none; position: absolute; top: 100%; left: 0; right: 0; background: #fff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); z-index: 100; max-height: 200px; overflow-y: auto;"></div>
        </div>
        <button class="btn btn-primary" onclick="handleSearch()"><i class="fas fa-search"></i> Tìm</button>
        <button class="btn btn-primary" onclick="openPostModal()">
            <i class="fas fa-plus"></i> Tạo Bài Viết Mới
        </button>
        <div class="filters">
            <select id="sortSelect" onchange="handleSortChange()">
                <option value="newest" <%= "newest".equals(request.getAttribute("sort")) ? "selected" : "" %>>Mới Nhất</option>
                <option value="popular" <%= "popular".equals(request.getAttribute("sort")) ? "selected" : "" %>>Phổ Biến</option>
                <option value="most-liked" <%= "most-liked".equals(request.getAttribute("sort")) ? "selected" : "" %>>Được Thích Nhiều</option>
            </select>
            <select id="filterSelect" onchange="handleFilterChange()">
                <option value="all" <%= "all".equals(request.getAttribute("filter")) ? "selected" : "" %>>Tất Cả</option>
                <option value="with-replies" <%= "with-replies".equals(request.getAttribute("filter")) ? "selected" : "" %>>Có Phản Hồi</option>
                <option value="no-replies" <%= "no-replies".equals(request.getAttribute("filter")) ? "selected" : "" %>>Chưa Có Phản Hồi</option>
            </select>
        </div>
    </div>
</div>
            <div class="post-list">
                <% 
                    List<ForumPost> posts = (List<ForumPost>) request.getAttribute("posts");
                    String userId = (String) request.getSession().getAttribute("userId");
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
                %>
                    <div class="post-card" data-tags="<%= escapeHtml(post.getCategory()) %>">
                        <div class="post-content">
                            <div class="post-header">
                                <div class="avatar">
                                    <img src="<%= request.getContextPath() %>/assets/images/avatar<%= escapeHtml(post.getPostedBy()) %>.png" alt="Avatar" />
                                </div>
                                <div class="author-info">
                                    <span class="author-name"><%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy())) %></span>
                                    <div class="post-meta">
                                        <span><i class="fas fa-clock"></i> <%= formattedDate %></span>
                                        <span><i class="fas fa-eye"></i> <%= post.getViewCount() %></span>
                                        <span><i class="fas fa-comment"></i> <%= post.getCommentCount() %></span>
                                    </div>
                                </div>
                                <div class="post-tags">
                                    <span class="tag"><%= escapeHtml(post.getCategory()) %></span>
                                </div>
                            </div>
                            <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="post-title"><%= escapeHtml(post.getTitle()) %></a>
                            <div class="post-body">
                                <p><%= escapeHtml(post.getContent()) %></p>
                            </div>
                            <% if (!postPicture.isEmpty()) { %>
                                <div class="post-image">
                                    <img src="<%= request.getContextPath() %>/<%= escapeHtml(postPicture) %>" alt="Post image" />
                                </div>
                            <% } %>
                            <div class="post-actions">
                                <button class="action-btn like-btn <%= hasLiked ? "liked" : "" %>" onclick="toggleLike(<%= post.getId() %>, this)">
                                    <i class="fas fa-thumbs-up"></i> <span class="like-count"><%= post.getVoteCount() %></span>
                                </button>
                                <a href="<%= request.getContextPath() %>/forum/post/<%= post.getId() %>" class="action-btn comment-btn">
                                    <i class="fas fa-comment"></i> <%= post.getCommentCount() %>
                                </a>
                            </div>
                            <div class="comment-section" id="comment-section-<%= post.getId() %>" style="display:none;">
                                <% 
                                    List<ForumComment> comments = post.getComments();
                                    if (comments != null) {
                                        for (ForumComment comment : comments) {
                                            Timestamp commentDate = comment.getCommentedDate();
                                            String formattedCommentDate = commentDate != null ? sdf.format(commentDate) : "";
                                %>
                                    <div class="comment">
                                        <div class="avatar sm">
                                            <img src="<%= request.getContextPath() %>/assets/images/avatar.png" alt="Avatar" />
                                        </div>
                                        <div class="comment-content">
                                            <span class="author-name"><%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy())) %></span>
                                            <p><%= escapeHtml(comment.getCommentText()) %></p>
                                            <span class="comment-time"><i class="fas fa-clock"></i> <%= formattedCommentDate %></span>
                                            <button class="action-btn">
                                                <i class="fas fa-thumbs-up"></i> <%= comment.getVoteCount() %>
                                            </button>
                                        </div>
                                    </div>
                                <% 
                                        }
                                    }
                                %>
                                <form action="<%= request.getContextPath() %>/forum/createComment" method="post" class="comment-form">
                                    <input type="hidden" name="postId" value="<%= post.getId() %>">
                                    <textarea name="commentText" placeholder="Viết bình luận..." required></textarea>
                                    <button type="submit" class="btn btn-primary">Gửi</button>
                                </form>
                            </div>
                        </div>
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
                    <a href="<%= request.getContextPath() %>/forum?sort=<%= escapeHtml(sort) %>&filter=<%= escapeHtml(filter) %>&search=<%= escapeHtml(search) %>&page=<%= pageNum - 1 %>">« Trang Trước</a>
                <% 
                    }
                    if (posts != null && !posts.isEmpty()) {
                %>
                    <a href="<%= request.getContextPath() %>/forum?sort=<%= escapeHtml(sort) %>&filter=<%= escapeHtml(filter) %>&search=<%= escapeHtml(search) %>&page=<%= pageNum != null ? pageNum + 1 : 2 %>">Trang Sau »</a>
                <% 
                    }
                %>
            </div>
        </main>
        <aside class="sidebar-right">
            <div class="widget">
                <h3 class="widget-title"><i class="fas fa-trophy"></i> Top Tương Tác</h3>
                <ul class="top-users">
                    <% 
                        List<UserActivityScore> topUsers = (List<UserActivityScore>) request.getAttribute("topUsers");
                        if (topUsers != null) {
                            int rank = 1;
                            for (UserActivityScore score : topUsers) {
                                User user = score.getUser();
                                if (user != null) {
                                    String profilePicture = user.getProfilePicture() != null ? user.getProfilePicture() : "";
                    %>
                    <li class="top-user">
                        <div class="rank"><%= rank++ %></div>
                        <div class="avatar">
                            <img src="<%= request.getContextPath() %>/<%= profilePicture != null && !profilePicture.isEmpty() ? escapeHtml(profilePicture) : "assets/img/avatar.jpg" %>" alt="Avatar" />
                        </div>
                        <div class="user-info">
                            <div class="user-name"><%= escapeHtml(user.getUsername()) %></div>
                            <div class="user-role"><%= escapeHtml(user.getRole()) %></div>
                            <div class="user-points"><%= score.getTotalComments() %> bình luận, <%= score.getTotalVotes() %> lượt thích</div>
                        </div>
                    </li>
                    <% 
                                }
                            }
                        }
                    %>
                </ul>
            </div>
            <div class="widget">
                <h3 class="widget-title"><i class="fas fa-link"></i> Liên Kết Nhanh</h3>
                <button class="btn btn-blue btn-block"><i class="fas fa-book"></i> Từ Vựng Hôm Nay</button>
                <button class="btn btn-yellow btn-block"><i class="fas fa-language"></i> Ngữ Pháp Cơ Bản</button>
                <button class="btn btn-primary btn-block"><i class="fas fa-check"></i> Kiểm Tra Trình Độ</button>
            </div>
            <div class="widget">
                <div class="widget-image">
                    <img src="<%= request.getContextPath() %>/assets/img/backgroundLogin.png" alt="Image" />
                </div>
            </div>
        </aside>
    </div>
    <div class="modal-overlay" id="createPostModal">
        <div class="modal">
            <div class="modal-header">
                <h2 class="modal-title">Tạo Bài Viết Mới</h2>
                <button class="btn" onclick="closePostModal()"><i class="fas fa-times"></i></button>
            </div>
            <div class="modal-body">
                <form id="createPostForm" action="<%= request.getContextPath() %>/forum/createPost" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label class="form-label" for="postTitle">Tiêu đề</label>
                        <input type="text" class="form-control" id="postTitle" name="postTitle" placeholder="Nhập tiêu đề bài viết..." required maxlength="200" />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="postCategory">Chủ đề</label>
                        <select class="form-control" id="postCategory" name="postCategory" required>
                            <option value="">Chọn chủ đề</option>
                            <option value="N5">JLPT N5</option>
                            <option value="N4">JLPT N4</option>
                            <option value="N3">JLPT N3</option>
                            <option value="N2">JLPT N2</option>
                            <option value="N1">JLPT N1</option>
                            <option value="Ngữ pháp">Ngữ Pháp</option>
                            <option value="Kinh nghiệm thi">Kinh Nghiệm Thi</option>
                            <option value="Tài liệu">Tài Liệu</option>
                            <option value="Công cụ">Công Cụ</option>
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
      <script src="${pageContext.request.contextPath}/assets/js/admin/mainDashboard.js"></script>
    <%@include file="chatbox.jsp" %>
</body>
</html>