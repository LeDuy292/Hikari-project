<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hikari Japan Sidebar</title>
        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
        <!-- Google Fonts for Elegant Font -->
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&family=Roboto:wght@400;500;600&display=swap" rel="stylesheet" />
        <%
            // Get the current page name from the request
            String currentPage = request.getRequestURI().substring(request.getRequestURI().lastIndexOf("/") + 1);
        %>
        <style>
            :root {
                --primary-color: #ff9800; /* Orange from JSP */
                --secondary-color: #ffb347; /* Gray from JSP */
                --accent-color: #ffb347; /* Gradient end color from JSP */
                --background-color: #FFF4E5; /* Sidebar background from JSP */
                --text-color: #444; /* Default text color */
                --text-light: #fff; /* White for active states */
                --shadow-color: rgba(255, 145, 0, 0.08); /* Hover shadow */
                --active-shadow-color: rgba(255, 145, 0, 0.12); /* Active shadow */
            }

            .sidebar {
                width: 320px;
                min-height: 100vh;
                background: #FFF4E5;
                padding: 20px;
                position: fixed;
                left: 0;
                top: 0;
                bottom: 0;
                box-shadow: 5px 0 20px rgba(52, 73, 94, 0.3);
                border-right: 2px solid transparent;
                border-image: linear-gradient(45deg, #e5e7eb, #e5e7eb) 1;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
            }

            .sidebar-header {
                display: flex;
                align-items: center;
                margin-left: -20px;
            }

            .sidebar-logo {
                max-width: 200px;
                margin-right: -20px;
            }

            .sidebar-title-container {
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: flex-start;
                height: 100%;
            }

            .sidebar-title {
                color: var(--primary-color);
                font-size: 2rem;
                font-weight: 700;
                font-family: 'Dancing Script', cursive;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
                letter-spacing: 1px;
                line-height: 1.2;
                margin: 0;
            }

            .sidebar-subtitle {
                color: var(--secondary-color);
                font-size: 1.2rem;
                font-weight: 700;
                font-family: 'Dancing Script', cursive;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
                letter-spacing: 1px;
                line-height: 1.2;
                margin: 0;
            }

            .sidebar-nav-item {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                margin: 8px 0;
                color: var(--text-color);
                text-decoration: none;
                font-size: 1rem;
                font-weight: 500;
                font-family: 'Roboto', sans-serif;
                border-radius: 5px;
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.1);
                gap: 10px;
            }

            .sidebar-nav-item i {
                margin-right: 10px;
                font-size: 1.2rem;
                color: var(--secondary-color);
            }

            .sidebar-nav-item:hover {
                background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
                color: var(--text-light);
                transform: translateX(5px);
                box-shadow: 0 0 10px var(--shadow-color);
            }

            .sidebar-nav-item:hover i {
                color: var(--text-light);
            }

            .sidebar-nav-item.active {
                background: linear-gradient(90deg, var(--primary-color), var(--accent-color));
                color: var(--text-light);
                box-shadow: 0 0 10px var(--active-shadow-color);
            }

            .sidebar-nav-item.active i {
                color: var(--text-light);
            }

            .bottom-section {
                width: 100%;
                margin-top: auto;
                margin-bottom: 20px;
            }

            .menu-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 12px 20px;
                font-size: 15px;
                font-weight: 600;
                font-family: 'Roboto', sans-serif;
                color: var(--text-color);
                width: 90%;
                border-radius: 9999px;
                text-decoration: none;
                transition: background 0.3s, color 0.3s, transform 0.3s;
            }

            .menu-item i {
                font-size: 18px;
                color: var(--secondary-color);
                transition: color 0.3s;
            }

            .menu-item:hover {
                background: #fff7ed;
                color: var(--primary-color);
                transform: scale(1.05);
                box-shadow: 0 2px 8px var(--shadow-color);
            }

            .menu-item:hover i {
                color: var(--primary-color);
            }

            .image-placeholder {
                width: 100%;
                height: 120px;
                background: #e0e0e0;
                border-radius: 12px;
                overflow: hidden;
                margin-bottom: 16px;
            }

            .image-placeholder img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <div class="sidebar-top">
                <div class="sidebar-header">
                    <img src="${pageContext.request.contextPath}/assets/img/img_student/logoHikari.png" alt="Hikari Logo" class="sidebar-logo" onerror="this.src='/fallback-logo.png'" />
                    <div class="sidebar-title-container">
                        <span class="sidebar-title">HIKARI</span>
                        <span class="sidebar-subtitle">JAPAN</span>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/view/student/home.jsp" class="sidebar-nav-item <%= currentPage.equals("home.jsp") ? "active" : ""%>" aria-label="Trang chủ">
                    <i class="fa fa-home"></i>
                    <span>Trang chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/view/student/index.jsp" class="sidebar-nav-item <%= currentPage.equals("index.jsp") ? "active" : ""%>" aria-label="Tài liệu">
                    <i class="fa fa-book"></i>
                    <span>Tài liệu</span>
                </a>
                <a href="${pageContext.request.contextPath}/courses?category=paid" class="sidebar-nav-item <%= currentPage.equals("courses") ? "active" : ""%>" aria-label="Khóa học online">
                    <i class="fa fa-play-circle"></i>
                    <span>Khóa học online</span>
                </a>

                <a href="${pageContext.request.contextPath}/dictionary" class="menu-item <%= currentPage.equals("dictionary.jsp") ? "active" : ""%>"><i class="fa fa-book-open"></i>Từ điển</a>

                <a href="${pageContext.request.contextPath}/checkGrammar" class="menu-item <%= currentPage.equals("grammarCheck.jsp") ? "active" : ""%>"><i class="fa fa-book-open"></i>Kiểm tra ngữ pháp</a>

                <a href="${pageContext.request.contextPath}/LoadTest" class="sidebar-nav-item <%= currentPage.equals("test.jsp") ? "active" : ""%>" aria-label="Bài kiểm tra">
                    <i class="fa fa-file-alt"></i>
                    <span>Bài kiểm tra</span>
                </a>
                <a href="${pageContext.request.contextPath}/forum" class="sidebar-nav-item <%= currentPage.equals("forum.jsp") ? "active" : ""%>" aria-label="Diễn đàn">
                    <i class="fa fa-chalkboard"></i>
                    <span>Diễn đàn</span>
                </a>
            </div>
            <div class="bottom-section">
                <div class="image-placeholder">
                    <img src="${pageContext.request.contextPath}/assets/img/img_student/study.jpg" alt="Study Image" onerror="this.src='/fallback-image.png'" />
                </div>
                <a href="${pageContext.request.contextPath}/chat" class="menu-item" aria-label="Chat">
                    <i class="fa fa-comments"></i>Chat
                </a>
            </div>
        </div>
    </body>

</html>