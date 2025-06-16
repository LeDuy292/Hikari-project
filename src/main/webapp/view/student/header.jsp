<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.UserAccount" %>
<div class="main-header" style="justify-content:space-between; padding:32px 0 0 0; width:100%; max-width:1100px;">
    <div style="display:flex; align-items:center; gap:12px;">
        <span style="font-size:26px; font-weight:bold; color:#000000; letter-spacing:1px; transition: color 0.3s ease;"></span>
    </div>
    <div style="display:flex; align-items:center; gap:12px;">
        <button class="icon-btn" onclick="window.location.href='shopping_cart.jsp'" style="transition: transform 0.3s ease;"><i class="fa fa-shopping-cart"></i></button>
        <button class="icon-btn" style="transition: transform 0.3s ease;"><i class="fa fa-bell"></i></button>
        <% 
            UserAccount user = (UserAccount) session.getAttribute("user");
            if (user != null) { 
                String profilePic = (user.getProfilePicture() != null && !user.getProfilePicture().isEmpty()) 
                    ? (request.getContextPath() + user.getProfilePicture()) 
                    : (request.getContextPath() + "/assets/img/default-avatar.png"); // Ảnh mặc định
        %>
            <div class="user-info" style="display:flex; align-items:center; gap:15px; padding:5px 10px; background-color:#f8f9fa; border-radius:5px;">
                <a href="${pageContext.request.contextPath}/view/profile.jsp" style="text-decoration:none;">
                    <img src="<%= profilePic %>?t=<%= java.lang.System.currentTimeMillis() %>" alt="Avatar" style="width:40px; height:40px; border-radius:50%; object-fit:cover; transition: transform 0.3s ease;">
                </a>
                <span style="font-weight:bold; color:#333; transition: color 0.3s ease;"><%= user.getUsername() != null ? user.getUsername() : user.getFullName() %></span>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="margin:0;">
                    <button type="submit" style="padding:8px 16px; background:linear-gradient(90deg,#ff9800 60%,#ffb347 100%); color:#fff; border:none; border-radius:8px; font-weight:bold; cursor:pointer; transition: all 0.3s ease;">Đăng xuất</button>
                </form>
            </div>
        <% } else { %>
            <button style="background:linear-gradient(90deg,#ff9800 60%,#ffb347 100%);color:#fff;font-weight:bold;padding:8px 28px;border:none;border-radius:8px;font-size:16px;cursor:pointer; transition: transform 0.3s ease; box-shadow: 0 2px 4px rgba(0,0,0,0.1);" onclick="window.location.href='${pageContext.request.contextPath}/view/login.jsp'">Đăng nhập</button>
        <% } %>
    </div>
</div>
<script>
    function confirmLogout(logoutUrl) {
        if (confirm("Bạn có chắc muốn đăng xuất?")) {
            window.location.href = logoutUrl;
        }
    }
</script>
<style>
    .main-header:hover .icon-btn,
    .main-header:hover img,
    .main-header:hover span,
    .main-header:hover a,
    .main-header:hover button {
        transition: all 0.3s ease;
    }
    .main-header .icon-btn:hover {
        transform: scale(1.1);
        color: #ff9800;
    }
    .main-header img:hover {
        transform: scale(1.1);
    }
    .main-header span:hover {
        color: #ff9800;
    }
    .main-header a:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        color: #ff6600;
    }
    .main-header button:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
    }
    /* Thêm style cho user-info */
    .user-info a {
        text-decoration: none;
    }
    .user-info button:hover {
        background: linear-gradient(90deg, #e06e4c 60%, #ffaa66 100%);
    }
</style>