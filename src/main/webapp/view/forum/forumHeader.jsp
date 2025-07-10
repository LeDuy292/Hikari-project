<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ page import="model.UserAccount" %>

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
        --like-color: #4f8cff;
        --comment-color: #9b59b6;
        --share-color: #1abc9c;
    }

    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: "Segoe UI", "Roboto", Arial, sans-serif;
        background: var(--bg);
        min-height: 100vh;
        overflow-x: hidden;
    }

    .topbar {
        width: 100%;
        background: linear-gradient(90deg, var(--primary) 60%, var(--accent) 100%);
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 32px;
        height: 62px;
        box-shadow: 0 2px 12px rgba(79, 140, 255, 0.07);
        position: sticky;
        top: 0;
        z-index: 9999;
    }

    .topbar .logo {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 1.3rem;
        font-weight: 700;
        letter-spacing: 1px;
    }

    .topbar .logo-icon {
        width: 48px;
        height: 48px;
        border-radius: 8px;
        overflow: hidden;
    }

    .logo-icon .logo-img {
        width: 100%;
        height: 100%;
        object-fit: contain;
    }

    .topbar .nav {
        display: flex;
        gap: 24px;
        align-items: center;
        padding: 0.5rem 4rem 0.5rem 2rem;
    }

    .topbar .nav a {
        color: #fff;
        text-decoration: none;
        font-weight: 500;
        font-size: 1rem;
        padding: 8px 14px;
        border-radius: 8px;
        transition: background 0.2s;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .topbar .nav a.active,
    .topbar .nav a:hover {
        background: rgba(255, 255, 255, 0.13);
    }
    .topbar .account-btn {
        background: none;
        border: none;
        color: #fff;
        font-size: 1rem;
        font-weight: 500;
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        padding: 8px 14px;
        border-radius: 8px;
        transition: background 0.2s;
    }
    .topbar .account-btn:hover {
        background: rgba(255, 255, 255, 0.13);
    }

    .avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .dropdown {
        position: absolute;
        top: 110%;
        right: 0;
        background: #fff;
        border: 1px solid #e5e7eb;
        border-radius: 12px;
        box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.08);
        min-width: 220px;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.2s;
        z-index: 50;
    }
    .dropdown.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }
    .dropdown-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 1rem 1.5rem;
        color: #222b45;
        text-decoration: none;
        transition: all 0.2s;
        border-bottom: 1px solid #f1f5f9;
        font-size: 0.95rem;
    }
    .dropdown-item:last-child {
        border-bottom: none;
    }
    .dropdown-item:hover {
        background: #f1f5f9;
        color: var(--primary);
    }

    .dropdown-content {
        display: none;
        position: absolute;
        right: 0;
        top: 100%;
        background: white;
        min-width: 200px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        border-radius: 12px;
        padding: 8px 0;
        z-index: 1000;
        margin-top: 8px;
    }

    .dropdown-content.show {
        display: block;
    }

    .dropdown-content a {
        color: var(--secondary) !important;
        padding: 12px 20px !important;
        text-decoration: none;
        display: block;
        font-weight: 500;
        transition: background 0.2s;
        border-radius: 0 !important;
    }

    .dropdown-content a:hover {
        background: var(--bg) !important;
    }

    .layout {
        display: flex;
        width: 100%;
        min-height: calc(100vh - 62px);
    }

    /* Mobile responsive */
    @media (max-width: 768px) {
        .topbar {
            padding: 0 16px;
        }

        .topbar .logo {
            font-size: 1.1rem;
        }

        .topbar .nav {
            gap: 12px;
        }

        .topbar .nav a {
            padding: 6px 10px;
            font-size: 0.9rem;
        }

        .topbar .nav a span {
            display: none;
        }
    }
</style>

<div class="topbar">
    <div class="logo">
        <div class="logo-icon">
            <img
                src="<%= request.getContextPath()%>/assets/img/logo.png"
                alt="Logo"
                class="logo-img"
                />
        </div>
        Diễn Đàn HIKARI
    </div>
    <nav class="nav">
        <a href="<%= request.getContextPath()%>/view/student/home.jsp">
            <i class="fas fa-home"></i>
            <span>Trang Chủ</span>
        </a>
        <a href="<%= request.getContextPath()%>/contact">
            <i class="fas fa-phone"></i>
            <span>Liên Hệ</span>
        </a>
        <% String currentUserId = (String) request.getAttribute("userId");
            if (currentUserId == null) {
                currentUserId = (String) session.getAttribute("userId");
            }
            if (currentUserId != null) {%>
        <a
            href="<%= request.getContextPath()%>/profile?userId=<%= currentUserId%>"
            class="nav-link"
            >
            <i class="fas fa-user"></i>
            <span>Hồ sơ</span>
        </a>
        <% } %>

        <div class="account-dropdown">
            <div class="avatar" onclick="toggleDropdown()">
                <%
                    UserAccount currentUser = (UserAccount) request.getAttribute("user");
                    if (currentUser == null) {
                        currentUser = (UserAccount) session.getAttribute("user");
                    }
                    String avatarUrl = null;
                    if (currentUser != null) {
                        avatarUrl = currentUser.getProfilePicture();
                    }
                    if (avatarUrl == null || avatarUrl.isEmpty()) {
                        avatarUrl = request.getContextPath() + "/assets/img/avatar.png";
                    } else if (!avatarUrl.matches("^https?://.*")) {
                        avatarUrl = request.getContextPath() + "/" + avatarUrl;
                    }
                %>
                <img src="<%= avatarUrl%>" alt="Avatar" />
            </div>
            <div class="dropdown-content" id="userDropdown">
                <% if (currentUser != null) {%>
                <a
                    href="<%= request.getContextPath()%>/profile?userId=<%= currentUser.getUserID()%>"
                    >
                    <i class="fas fa-user"></i> Hồ sơ của tôi
                </a>
                <a
                    href="<%= request.getContextPath()%>/view/forum/editUserProfileForum.jsp"
                    >
                    <i class="fas fa-cog"></i> Cài đặt tài khoản
                </a>
                <% }%>
                <a href="<%= request.getContextPath()%>/logout">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>
</div>

<script>
    function toggleDropdown() {
        const dropdown = document.getElementById("userDropdown");
        dropdown.classList.toggle("show");
    }

    // Close dropdown when clicking outside
    document.addEventListener("click", function (event) {
        const dropdown = document.getElementById("userDropdown");
        const avatar = document.querySelector(".account-dropdown .avatar");

        if (!avatar.contains(event.target)) {
            dropdown.classList.remove("show");
        }
    });

    // Close dropdown when pressing Escape key
    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            document.getElementById("userDropdown").classList.remove("show");
        }
    });
</script>
