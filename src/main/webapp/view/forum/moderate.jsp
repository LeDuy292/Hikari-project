<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kiểm duyệt bài viết</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/mainForum.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/forum_css/mainmoderation.css" rel="stylesheet">
        
    </head>
    <body>
        <div class="moderation-container">
            <div class="page-header">
                <h2 class="page-title">
                    <i class="fas fa-shield-alt"></i> Quản lý & Kiểm duyệt Bài Viết
                </h2>
                <a href="${pageContext.request.contextPath}/forum" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Quay về Diễn đàn
                </a>
            </div>

            <c:if test="${empty moderationPosts}">
                <div class="no-posts">
                    <i class="fas fa-inbox"></i>
                    <h5>Không có bài viết nào cần kiểm duyệt</h5>
                    <p>Hiện tại không có bài viết nào đang chờ xử lý. Hãy kiểm tra lại sau!</p>
                </div>
            </c:if>

            <c:forEach var="post" items="${moderationPosts}">
                <div class="post-card">
                    <div class="post-header">
                        <div class="post-info">
                            <a href="${pageContext.request.contextPath}/forum/post/${post.id}" class="post-title">${post.title}</a>
                            <div class="post-meta">
                                <span><i class="fas fa-user"></i> ${post.postedBy}</span>
                                <span><i class="fas fa-folder"></i> ${post.category}</span>
                                <span><i class="fas fa-clock"></i> <fmt:formatDate value="${post.createdDate}" pattern="dd/MM/yyyy HH:mm"/></span>
                            </div>
                        </div>
                        <div class="post-status">
                            <c:if test="${post.pinned}">
                                <span class="badge-custom badge-pinned">
                                    <i class="fas fa-thumbtack"></i> Đã ghim
                                </span>
                            </c:if>
                            <c:if test="${post.hidden}">
                                <span class="badge-custom badge-hidden">
                                    <i class="fas fa-eye-slash"></i> Đã ẩn
                                </span>
                            </c:if>
                        </div>
                    </div>
                    <div class="post-body">
                        <p class="content-preview">${post.content}</p>
                        <div class="metrics">
                            <span><i class="fas fa-eye"></i> ${post.viewCount} lượt xem</span>
                            <span><i class="fas fa-thumbs-up"></i> ${post.voteCount} bình chọn</span>
                        </div>
                        <div class="post-actions">
                            <a href="${pageContext.request.contextPath}/forum/post/${post.id}" class="action-btn view">
                                <i class="fas fa-eye"></i> Xem bài
                            </a>
                            <form action="${pageContext.request.contextPath}/forum/moderate" method="post" style="display: inline;">
                                <input type="hidden" name="postId" value="${post.id}">
                                <c:if test="${!post.hidden}">
                                    <button type="submit" name="action" value="hide" class="action-btn hide">
                                        <i class="fas fa-eye-slash"></i> Ẩn bài
                                    </button>
                                </c:if>
                                <c:if test="${post.hidden}">
                                    <button type="submit" name="action" value="show" class="action-btn show">
                                        <i class="fas fa-eye"></i> Hiện bài
                                    </button>
                                </c:if>
                            </form>
                            <form action="${pageContext.request.contextPath}/forum/moderate" method="post" style="display: inline;">
                                <input type="hidden" name="postId" value="${post.id}">
                                <c:if test="${!post.pinned}">
                                    <button type="submit" name="action" value="pin" class="action-btn pin">
                                        <i class="fas fa-thumbtack"></i> Ghim bài
                                    </button>
                                </c:if>
                                <c:if test="${post.pinned}">
                                    <button type="submit" name="action" value="unpin" class="action-btn unpin">
                                        <i class="fas fa-thumbtack"></i> Bỏ ghim
                                    </button>
                                </c:if>
                            </form>
                            <form action="${pageContext.request.contextPath}/forum/moderate" method="post" style="display: inline;">
                                <input type="hidden" name="postId" value="${post.id}">
                                <button type="submit" name="action" value="delete" class="action-btn delete" onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?');">
                                    <i class="fas fa-trash"></i> Xóa bài
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </body>
</html>