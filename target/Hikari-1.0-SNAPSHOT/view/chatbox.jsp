<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="chatbox" style="display: none;">
    <div class="chatbox-container">
        <div class="chatbox-header">
            <span>Chat With AI</span>
            <button onclick="toggleChatbox()" class="close-btn">✖</button>
        </div>
        <div class="chatbox-history" id="chatbox-history">
            <%
                List<String[]> chatboxHistory = (List<String[]>) session.getAttribute("chatHistory");
                if (chatboxHistory != null) {
                    for (String[] chat : chatboxHistory) {
            %>
            <div class="chat-message user-message">
                <span class="avatar">👤</span>
                <div class="message-content">
                    <strong>You:</strong> <%= chat[0] %>
                </div>
            </div>
            <div class="chat-message ai-message">
                <span class="avatar">🤖</span>
                <div class="message-content">
                    <strong>AI:</strong> <%= chat[1] %>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
        <div class="chatbox-input">
            <textarea id="userInput" rows="2" placeholder="Nhập câu hỏi..." onkeypress="submitOnEnter(event)"></textarea>
            <button onclick="sendMessage()">Gửi</button>
        </div>
    </div>
</div>
<button id="chatbox-toggle" onclick="toggleChatbox()">💬</button>

<style>
    #chatbox-toggle {
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 60px;
        height: 60px;
        background-color: #1e90ff;
        color: white;
        border: none;
        border-radius: 50%;
        font-size: 30px;
        cursor: pointer;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        z-index: 1001;
        transition: transform 0.2s;
    }
    #chatbox-toggle:hover {
        transform: scale(1.1);
        background-color: #187bcd;
    }
    .chatbox-container {
        position: fixed;
        bottom: 90px;
        right: 20px;
        width: 350px;
        max-height: 500px;
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.2);
        display: flex;
        flex-direction: column;
        z-index: 1000;
        animation: slideIn 0.3s ease-in-out;
    }
    @keyframes slideIn {
        from { transform: translateY(100px); opacity: 0; }
        to { transform: translateY(0); opacity: 1; }
    }
    .chatbox-header {
        background: linear-gradient(135deg, #1e90ff, #00b7eb);
        color: white;
        padding: 12px 15px;
        border-radius: 12px 12px 0 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 600;
    }
    .chatbox-header .close-btn {
        background: none;
        border: none;
        color: white;
        font-size: 18px;
        cursor: pointer;
        transition: transform 0.2s;
    }
    .chatbox-header .close-btn:hover {
        transform: scale(1.2);
    }
    .chatbox-history {
        max-height: 380px;
        overflow-y: auto;
        padding: 15px;
        background-color: #f9f9fb;
        border-bottom: 1px solid #e0e0e0;
    }
    .chat-message {
        display: flex;
        align-items: flex-start;
        margin: 12px 0;
    }
    .chat-message .avatar {
        font-size: 24px;
        margin-right: 10px;
    }
    .chat-message .message-content {
        flex-grow: 1;
    }
    .user-message .message-content {
        background-color: #e3f2fd;
        padding: 10px 14px;
        border-radius: 10px 10px 10px 2px;
        margin-right: 15px;
    }
    .ai-message .message-content {
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        padding: 10px 14px;
        border-radius: 10px 10px 2px 10px;
        margin-left: 15px;
    }
    .chatbox-input {
        display: flex;
        gap: 8px;
        padding: 12px;
        background-color: #fff;
        border-radius: 0 0 12px 12px;
    }
    .chatbox-input textarea {
        flex-grow: 1;
        padding: 10px;
        border: 1px solid #d0d0d0;
        border-radius: 8px;
        resize: none;
        font-size: 14px;
        outline: none;
    }
    .chatbox-input textarea:focus {
        border-color: #1e90ff;
        box-shadow: 0 0 5px rgba(30, 144, 255, 0.3);
    }
    .chatbox-input button {
        padding: 10px 20px;
        background-color: #1e90ff;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
    }
    .chatbox-input button:hover {
        background-color: #187bcd;
    }
</style>

<script>
    function toggleChatbox() {
        var chatbox = document.getElementById("chatbox");
        if (chatbox.style.display === "none") {
            chatbox.style.display = "block";
            scrollToBottom();
        } else {
            chatbox.style.display = "none";
        }
    }

    function submitOnEnter(event) {
        if (event.key === "Enter" && !event.shiftKey) {
            event.preventDefault();
            sendMessage();
        }
    }

    function sendMessage() {
        var userInput = document.getElementById("userInput").value.trim();
        if (!userInput) return;

        // Thêm tin nhắn người dùng vào lịch sử
        var history = document.getElementById("chatbox-history");
        var userMessage = document.createElement("div");
        userMessage.className = "chat-message user-message";
        userMessage.innerHTML = '<span class="avatar">👤</span><div class="message-content"><strong>You:</strong> ' + userInput + '</div>';
        history.appendChild(userMessage);

        // Gửi yêu cầu AJAX
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "gemini", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                var response = JSON.parse(xhr.responseText);
                var aiMessage = document.createElement("div");
                aiMessage.className = "chat-message ai-message";
                aiMessage.innerHTML = '<span class="avatar">🤖</span><div class="message-content"><strong>Gemini:</strong> ' + response.text + '</div>';
                history.appendChild(aiMessage);
                scrollToBottom();
            } else if (xhr.readyState === 4) {
                var aiMessage = document.createElement("div");
                aiMessage.className = "chat-message ai-message";
                aiMessage.innerHTML = '<span class="avatar">🤖</span><div class="message-content"><strong>Gemini:</strong> Error: Could not get response</div>';
                history.appendChild(aiMessage);
                scrollToBottom();
            }
        };
        xhr.send("userInput=" + encodeURIComponent(userInput));

        // Xóa textarea
        document.getElementById("userInput").value = "";
    }

    function scrollToBottom() {
        var history = document.getElementById("chatbox-history");
        history.scrollTop = history.scrollHeight;
    }

    // Cuộn xuống dưới khi tải trang nếu chatbox đang mở
    window.onload = function() {
        if (document.getElementById("chatbox").style.display === "block") {
            scrollToBottom();
        }
    };
</script>