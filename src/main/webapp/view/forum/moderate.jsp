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
        <style>
            :root {
                --primary: #4f8cff;
                --secondary: #232946;
                --accent: #f7c873;
                --bg: #f4f6fb;
                --card-bg: #fff;
                --shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.1);
                --radius: 18px;
                --transition: 0.25s cubic-bezier(0.4, 2, 0.6, 1);
            }

            body {
                font-family: "Segoe UI", "Roboto", Arial, sans-serif;
                background: var(--bg);
                min-height: 100vh;
                padding-top: 80px;
                color: var(--secondary);
            }

            .moderation-container {
                max-width: 1000px;
                margin: 0 auto;
                padding: 0 24px;
            }

            .page-header {
                text-align: center;
                margin-bottom: 40px;
                background: linear-gradient(90deg, var(--primary) 60%, var(--accent) 100%);
                padding: 20px;
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                color: #fff;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 16px;
            }

            .page-title {
                font-size: 2rem;
                font-weight: 700;
                margin: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .back-btn {
                padding: 8px 20px;
                border-radius: 15px;
                font-size: 0.95em;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all var(--transition);
                background: #ffffff20;
                border: 1.5px solid #ffffff50;
                color: #fff;
            }

            .back-btn:hover {
                background: #ffffff40;
                border-color: #fff;
                transform: scale(1.05);
            }

            .post-card {
                background: var(--card-bg);
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                border: 1.5px solid #eaf1ff;
                margin-bottom: 28px;
                transition: transform var(--transition), box-shadow var(--transition);
                overflow: hidden;
            }

            .post-card:hover {
                transform: translateY(-4px) scale(1.01);
                box-shadow: 0 12px 36px rgba(79, 140, 255, 0.18);
                border-color: #b8c6ff;
            }

            .post-header {
                padding: 24px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                flex-wrap: wrap;
                gap: 16px;
                border-bottom: 1px solid #f0f2f5;
                background: rgba(255, 255, 255, 0.95);
            }

            .post-header .post-info {
                display: flex;
                flex-direction: column;
                gap: 6px;
            }

            .post-header .post-title {
                font-size: 1.3rem;
                font-weight: 700;
                color: var(--primary);
                margin: 0;
                text-decoration: none;
                transition: color 0.2s;
            }

            .post-header .post-title:hover {
                color: var(--secondary);
                text-decoration: underline;
            }

            .post-header .post-meta {
                display: flex;
                gap: 16px;
                color: #7f8c8d;
                font-size: 0.95em;
                flex-wrap: wrap;
            }

            .post-header .post-status {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            .badge-custom {
                padding: 6px 12px;
                border-radius: 12px;
                font-size: 0.85em;
                font-weight: 600;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                color: #fff;
            }

            .badge-pinned {
                background: var(--accent);
                color: var(--secondary);
            }

            .badge-hidden {
                background: #ef4444;
            }

            .post-body {
                padding: 24px;
                display: flex;
                flex-direction: column;
                gap: 16px;
            }

            .post-body .content-preview {
                font-size: 1.05em;
                line-height: 1.7;
                color: var(--secondary);
                overflow: hidden;
                text-overflow: ellipsis;
                display: -webkit-box;
                -webkit-line-clamp: 3;
                -webkit-box-orient: vertical;
            }

            .post-body .metrics {
                display: flex;
                gap: 16px;
                color: #7f8c8d;
                font-size: 0.95em;
                font-weight: 500;
            }

            .post-actions {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
                justify-content: flex-end;
            }

            .action-btn {
                padding: 8px 20px;
                border-radius: 15px;
                font-size: 0.95em;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all var(--transition);
                border: 1.5px solid transparent;
            }

            .action-btn.view {
                background: linear-gradient(90deg, var(--primary) 60%, var(--accent) 100%);
                color: #fff;
                border: none;
            }

            .action-btn.view:hover {
                background: linear-gradient(90deg, var(--accent) 60%, var(--primary) 100%);
                transform: scale(1.05);
            }

            .action-btn.moderate {
                border-color: var(--primary);
                color: var(--primary);
                background: #f4faff;
            }

            .action-btn.moderate:hover {
                background: var(--primary);
                color: #fff;
                transform: scale(1.05);
            }

            .action-btn.hide {
                border-color: #ef4444;
                color: #ef4444;
                background: #fff1f1;
            }

            .action-btn.hide:hover {
                background: #ef4444;
                color: #fff;
                transform: scale(1.05);
            }

            .action-btn.show {
                border-color: #22c55e;
                color: #22c55e;
                background: #f0fdf4;
            }

            .action-btn.show:hover {
                background: #22c55e;
                color: #fff;
                transform: scale(1.05);
            }

            .action-btn.pin {
                border-color: var(--accent);
                color: var(--accent);
                background: #fff8e1;
            }

            .action-btn.pin:hover {
                background: var(--accent);
                color: var(--secondary);
                transform: scale(1.05);
            }

            .action-btn.unpin {
                border-color: #6b7280;
                color: #6b7280;
                background: #f3f4f6;
            }

            .action-btn.unpin:hover {
                background: #6b7280;
                color: #fff;
                transform: scale(1.05);
            }

            .action-btn.delete {
                border-color: #dc2626;
                color: #dc2626;
                background: #fef2f2;
            }

            .action-btn.delete:hover {
                background: #dc2626;
                color: #fff;
                transform: scale(1.05);
            }

            .no-posts {
                text-align: center;
                padding: 80px 20px;
                background: var(--card-bg);
                border-radius: var(--radius);
                box-shadow: var(--shadow);
                margin: 24px 0;
            }

            .no-posts i {
                font-size: 3.5rem;
                color: var(--primary);
                margin-bottom: 16px;
            }

            .no-posts h5 {
                font-size: 1.5rem;
                color: var(--secondary);
                margin-bottom: 8px;
            }

            .no-posts p {
                font-size: 1rem;
                color: #7f8c8d;
            }

            @media (max-width: 768px) {
                .moderation-container {
                    padding: 0 16px;
                }

                .page-header {
                    padding: 16px;
                    flex-direction: column;
                    align-items: center;
                }

                .page-title {
                    font-size: 1.6rem;
                }

                .post-card {
                    padding: 16px;
                }

                .post-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 12px;
                }

                .post-actions {
                    justify-content: flex-start;
                }
            }

            @media (max-width: 576px) {
                .page-title {
                    font-size: 1.4rem;
                }

                .post-header .post-title {
                    font-size: 1.1rem;
                }

                .post-body .content-preview {
                    -webkit-line-clamp: 2;
                }

                .action-btn {
                    padding: 6px 16px;
                    font-size: 0.9em;
                }

                .back-btn {
                    padding: 6px 16px;
                    font-size: 0.9em;
                }
            }
        </style>
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