<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String userID = (String) session.getAttribute("userID");
    if (userID == null) {
        // response.sendRedirect("login.jsp");
        userID = "U001";
    }
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Nhắn Tin - Nền Tảng Giáo Dục</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@700&display=swap" rel="stylesheet" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/teacher_css/message.css" />
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <%@ include file="/view/teacher/sidebar.jsp" %>
                <!-- Main Content -->
                <main class="main-content">
                    <div class="content-wrapper">
                        <!-- Header -->
                        <%@ include file="/view/teacher/header.jsp" %>
                        <div class="chat-container">
                            <div class="chat-list" id="partnerList">
                                <c:forEach var="conversation" items="${conversations}">
                                    <div class="chat-item ${conversation.active ? 'active' : ''}" data-conversation-id="${conversation.id}">
                                        <img src="${conversation.avatarUrl}" alt="${conversation.name}" class="chat-avatar" />
                                        <div class="chat-info">
                                            <div class="chat-name">${conversation.name}</div>
                                            <div class="chat-preview">${conversation.preview}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="chat-panel">
                                <div class="chat-messages" id="chatMessages">
                                    <!-- Messages populated by JavaScript -->
                                </div>
                                <div class="chat-input">
                                    <textarea rows="2" placeholder="Nhập tin nhắn..." id="messageText"></textarea>
                                    <label for="imageUpload" class="btn btn-secondary">
                                        <i class="fas fa-image"></i>
                                    </label>
                                    <input type="file" id="imageUpload" accept="image/*" style="display: none;" />
                                    <button class="btn" id="sendMessageBtn">Gửi</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <!-- Overlay hiển thị ảnh lớn -->
        <div class="zoom-overlay" id="zoomOverlay" onclick="closeZoom()">
            <img id="zoomedImage" src="" alt="zoomed image">
        </div>

        <script>
    var userID = "<%= userID%>";
    function zoomImage(src) {
        const zoomed = document.getElementById('zoomedImage');
        zoomed.src = src;
        document.getElementById('zoomOverlay').classList.add('show');
    }

    function closeZoom() {
        document.getElementById('zoomOverlay').classList.remove('show');
    }

    document.addEventListener("DOMContentLoaded", function () {
        document.getElementById('chatMessages').addEventListener('click', function (e) {
            if (e.target.tagName === 'IMG') {
                zoomImage(e.target.src);
            }
        });
    });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/teacher_js/manageMessage.js"></script>
    </body>
</html>