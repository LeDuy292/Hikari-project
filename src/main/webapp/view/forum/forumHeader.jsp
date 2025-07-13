<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%> <%@ page import="model.UserAccount" %>
<%
    UserAccount currentUser = (UserAccount) request.getAttribute("user");
    if (currentUser == null) {
        currentUser = (UserAccount) session.getAttribute("user");
    }
%>
<link href="${pageContext.request.contextPath}/assets/css/forum_css/forumHeader.css" rel="stylesheet" />

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
        <%
            String homeUrl = request.getContextPath() + "/view/student/home.jsp"; // default
            if (currentUser != null) {
                String role = currentUser.getRole();
                switch (role) {
                    case "Admin":
                        homeUrl = request.getContextPath() + "/admin/dashboard";
                        break;
                    case "Coordinator":
                        homeUrl = request.getContextPath() + "/LoadDashboard";
                        break;
                    case "Teacher":
                        homeUrl = request.getContextPath() + "/view/teacher/manageCourse.jsp";
                        break;
                    case "Student":
                    default:
                        homeUrl = request.getContextPath() + "/view/student/home.jsp";
                        break;
                }
            }
        %>
        <a href="<%= homeUrl%>">
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
                    if (currentUser == null) {
                        currentUser = (UserAccount) session.getAttribute("user");
                    }
                    String avatarUrl = null;
                    if (currentUser
                            != null) {
                        avatarUrl = currentUser.getProfilePicture();
                    }
                    if (avatarUrl
                            == null || avatarUrl.isEmpty()) {
                        avatarUrl = request.getContextPath()
                                + "/assets/img/avatar.png";
                    } else if (!avatarUrl.matches("^https?://.*")) {
                avatarUrl = request.getContextPath() + "/" + avatarUrl;
            }%>
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
                    <a href="<%= request.getContextPath()%>/profile/edit">
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
