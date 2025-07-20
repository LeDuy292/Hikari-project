<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="chatbox" style="display: none;">
    <div class="chatbox-container">
        <div class="chatbox-header">
            <div class="chatbox-title">
                <i class="fas fa-robot"></i>
                <span>HIKARI AI</span>
                <span class="status-indicator" id="status-indicator">
                    <i class="fas fa-circle" style="color: #10b981; font-size: 8px;"></i>
                    <span style="font-size: 10px; margin-left: 4px;">Enhanced</span>
                </span>
            </div>
            <button onclick="toggleChatbox()" class="chatbox-close">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div class="chatbox-history" id="chatbox-history">
            <%
                List<String[]> chatboxHistory = (List<String[]>) session.getAttribute("chatHistory");
                if (chatboxHistory != null) {
                    for (String[] chat : chatboxHistory) {
            %>
            <div class="chat-message user-message">
                <div class="message-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <div class="message-content">
                    <div class="message-text"><%= chat[0]%></div>
                </div>
            </div>
            <div class="chat-message ai-message">
                <div class="message-avatar">
                    <i class="fas fa-robot"></i>
                </div>
                <div class="message-content">
                    <div class="message-text"><%= chat[1]%></div>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <div class="welcome-message">
                <div class="welcome-icon">
                    <i class="fas fa-robot"></i>
                </div>
                <h3>Chào Mừng Bạn Đến Với HIKARI AI! 👋</h3>
                <p>là trợ lý thông minh, sẵn sàng giải đáp mọi thắc mắc và hỗ trợ bạn 24/7!</p>
                <div class="feature-highlight">
                    <div class="feature-item">
                        <i class="fas fa-search"></i>
                        <span>Tìm kiếm thông minh, hiểu ý bạn ngay</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-database"></i>
                        <span>Kiến thức sâu rộng, giải đáp chi tiết</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-brain"></i>
                        <span>AI tiên tiến, luôn sẵn sàng hỗ trợ</span>
                    </div>
                </div>
                <p><strong>Hãy thử những câu hỏi phổ biến:</strong></p>
                <ul class="suggested-questions" id="suggested-questions">
                    <!-- Suggested questions will be populated by JavaScript -->
                </ul>
            </div>
            <%
                }
            %>
        </div>
        <div class="chatbox-input">
            <div class="input-wrapper">
                <textarea 
                    id="userInput" 
                    rows="1" 
                    placeholder="Nhập câu hỏi của bạn (VD: Học phí các khóa học như thế nào?)..." 
                    onkeypress="submitOnEnter(event)"
                    ></textarea>
                <button onclick="sendMessage()" class="send-btn" id="send-btn">
                    <i class="fas fa-paper-plane"></i>
                </button>
            </div>
            <div class="quick-actions">
                <button onclick="loadSuggestions()" class="quick-btn">
                    <i class="fas fa-lightbulb"></i> Gợi ý
                </button>
                <button onclick="clearChat()" class="quick-btn">
                    <i class="fas fa-trash"></i> Xóa
                </button>
            </div>
        </div>
    </div>
</div>

<button id="chatbox-toggle" onclick="toggleChatbox()">
    <i class="fas fa-comments"></i>
    <span class="toggle-text">AI Chat</span>
    <span class="notification-badge" id="notification-badge" style="display: none;">1</span>
</button>

<style>
    /* Enhanced styles for debugging */
    .feature-highlight {
        margin: 15px 0;
        padding: 10px;
        background: #f8fafc;
        border-radius: 8px;
        border-left: 4px solid #3b82f6;
    }

    .feature-item {
        display: flex;
        align-items: center;
        gap: 8px;
        margin: 5px 0;
        font-size: 0.8rem;
        color: #64748b;
    }

    .feature-item i {
        color: #3b82f6;
        width: 16px;
    }

    .test-btn {
        background: #f59e0b !important;
        color: white !important;
    }

    .test-btn:hover {
        background: #d97706 !important;
    }

    .debug-info {
        position: fixed;
        top: 10px;
        right: 10px;
        background: rgba(0,0,0,0.8);
        color: white;
        padding: 10px;
        border-radius: 5px;
        font-size: 12px;
        z-index: 9999;
        display: none;
    }

    /* All existing styles remain the same */
    .status-indicator {
        display: flex;
        align-items: center;
        margin-left: 10px;
    }

    .feature-list {
        list-style: none;
        padding: 0;
        margin: 10px 0;
    }

    .feature-list li {
        padding: 5px 0;
        font-size: 0.875rem;
        color: #64748b;
    }

    .database-info {
        margin-top: 15px;
        padding: 8px 12px;
        background: #f1f5f9;
        border-radius: 8px;
        font-size: 0.75rem;
        color: #64748b;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .quick-actions {
        display: flex;
        gap: 8px;
        margin-top: 8px;
    }

    .quick-btn {
        flex: 1;
        padding: 6px 12px;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 6px;
        font-size: 0.75rem;
        cursor: pointer;
        transition: all 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 4px;
    }

    .quick-btn:hover {
        background: #f1f5f9;
        border-color: #cbd5e1;
    }

    .notification-badge {
        position: absolute;
        top: -5px;
        right: -5px;
        background: #ef4444;
        color: white;
        border-radius: 50%;
        width: 18px;
        height: 18px;
        font-size: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }

    #chatbox-toggle {
        position: fixed;
        bottom: 2rem;
        right: 2rem;
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        border-radius: 50px;
        padding: 1rem 1.5rem;
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        box-shadow: 0 10px 25px rgba(59, 130, 246, 0.3);
        z-index: 1001;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        min-width: 60px;
        justify-content: center;
    }

    #chatbox-toggle:hover {
        transform: translateY(-2px);
        box-shadow: 0 15px 35px rgba(59, 130, 246, 0.4);
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
    }

    .chatbox-container {
        position: fixed;
        bottom: 6rem;
        right: 2rem;
        width: 420px;
        max-height: 700px;
        background: white;
        border-radius: 1rem;
        box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
        display: flex;
        flex-direction: column;
        z-index: 1000;
        animation: slideUp 0.3s ease-out;
        border: 1px solid #e2e8f0;
        overflow: hidden;
    }

    .chatbox-header {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        padding: 1rem 1.5rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-radius: 1rem 1rem 0 0;
    }

    .chatbox-title {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        font-weight: 600;
        font-size: 1rem;
    }

    .chatbox-history {
        flex: 1;
        max-height: 500px;
        overflow-y: auto;
        padding: 1.5rem;
        background: #f8fafc;
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .welcome-message {
        text-align: center;
        padding: 1rem;
        color: #64748b;
    }

    .welcome-icon {
        font-size: 3rem;
        color: #3b82f6;
        margin-bottom: 1rem;
    }

    .suggested-questions {
        list-style: none;
        padding: 0;
        margin: 1rem 0 0;
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .suggested-questions li {
        background: #ffffff;
        padding: 0.75rem;
        border-radius: 0.5rem;
        cursor: pointer;
        transition: all 0.2s;
        border: 1px solid #e2e8f0;
        font-size: 0.875rem;
        text-align: left;
    }

    .suggested-questions li:hover {
        background: #f1f5f9;
        transform: translateY(-2px);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }

    .chat-message {
        display: flex;
        gap: 0.75rem;
        align-items: flex-start;
        animation: messageSlide 0.3s ease-out;
    }

    .message-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.875rem;
        flex-shrink: 0;
        margin-top: 0.25rem;
    }

    .user-message .message-avatar {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        order: 2;
    }

    .ai-message .message-avatar {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
    }

    .message-content {
        flex: 1;
        max-width: calc(100% - 48px);
    }

    .user-message .message-content {
        order: 1;
    }

    .message-text {
        background: white;
        padding: 0.75rem 1rem;
        border-radius: 1rem;
        font-size: 0.875rem;
        line-height: 1.5;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        border: 1px solid #e2e8f0;
        word-wrap: break-word;
        white-space: pre-wrap;
    }

    .user-message .message-text {
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        margin-left: auto;
        border-radius: 1rem 1rem 0.25rem 1rem;
    }

    .ai-message .message-text {
        border-radius: 1rem 1rem 1rem 0.25rem;
    }

    .chatbox-input {
        padding: 1rem 1.5rem;
        background: white;
        border-top: 1px solid #e2e8f0;
    }

    .input-wrapper {
        display: flex;
        gap: 0.75rem;
        align-items: flex-end;
    }

    .input-wrapper textarea {
        flex: 1;
        padding: 0.75rem 1rem;
        border: 1px solid #e2e8f0;
        border-radius: 1rem;
        resize: none;
        font-size: 0.875rem;
        font-family: inherit;
        outline: none;
        transition: all 0.2s;
        max-height: 100px;
        min-height: 40px;
        line-height: 1.5;
    }

    .input-wrapper textarea:focus {
        border-color: #3b82f6;
        box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }

    .send-btn {
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, #3b82f6, #2563eb);
        color: white;
        border: none;
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        flex-shrink: 0;
    }

    .send-btn:hover {
        transform: scale(1.1);
        box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
    }

    .chatbox-close {
        position: absolute;
        top: 10px;
        right: 10px;
        background-color: #ff4d4d;  /* màu đỏ */
        color: white;
        border: none;
        border-radius: 50%;
        width: 32px;
        height: 32px;
        font-size: 16px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        transition: background-color 0.2s, transform 0.2s;
        z-index: 1000;
    }

    .chatbox-close:hover {
        background-color: #e60000;
        transform: scale(1.1);
    }
</style>

<div id="debug-info" class="debug-info"></div>

<script>
    let isTyping = false;
    let qaCount = 0;
    let debugMode = true; // Enable debug mode

    function debugLog(message) {
        if (debugMode) {
            console.log('🔍 HIKARI DEBUG:', message);
            const debugDiv = document.getElementById('debug-info');
            if (debugDiv) {
                debugDiv.innerHTML = message;
                debugDiv.style.display = 'block';
                setTimeout(() => {
                    debugDiv.style.display = 'none';
                }, 3000);
            }
        }
    }


    // Load database statistics
    function loadDatabaseStats() {
        fetch('chat?action=stats')
                .then(response => response.json())
                .then(data => {
                    qaCount = data.totalQA || 0;
                    document.getElementById('qa-count').textContent = qaCount.toLocaleString();
                    debugLog('Loaded ' + qaCount + ' Q&A pairs');
                })
                .catch(error => {
                    console.error('Error loading database stats:', error);
                    document.getElementById('qa-count').textContent = 'N/A';
                });
    }

    // Load suggested questions
    function loadSuggestions() {
        fetch('chat?action=suggestions')
                .then(response => response.json())
                .then(data => {
                    const suggestedList = document.getElementById("suggested-questions");
                    suggestedList.innerHTML = "";

                    if (data.suggestions && data.suggestions.length > 0) {
                        data.suggestions.forEach(question => {
                            const li = document.createElement("li");
                            li.textContent = question;
                            li.onclick = () => sendSuggestedMessage(question);
                            suggestedList.appendChild(li);
                        });
                    } else {
                        populateDefaultSuggestions();
                    }
                })
                .catch(error => {
                    console.error('Error loading suggestions:', error);
                    populateDefaultSuggestions();
                });
    }

    function populateDefaultSuggestions() {
        const defaultSuggestions = [
            "Học phí các khóa học như thế nào?",
            "Hikari có những khóa học nào?",
            "JLPT là gì?",
            "Cách đăng ký khóa học trên Hikari?",
            "Có mã giảm giá không?"
        ];

        const suggestedList = document.getElementById("suggested-questions");
        suggestedList.innerHTML = "";

        defaultSuggestions.forEach(question => {
            const li = document.createElement("li");
            li.textContent = question;
            li.onclick = () => sendSuggestedMessage(question);
            suggestedList.appendChild(li);
        });
    }

    function toggleChatbox() {
        var chatbox = document.getElementById("chatbox");
        var toggle = document.getElementById("chatbox-toggle");
        var badge = document.getElementById("notification-badge");

        if (chatbox.style.display === "none") {
            chatbox.style.display = "block";
            toggle.innerHTML = '<i class="fas fa-times"></i>';
            badge.style.display = "none";
            scrollToBottom();
            autoResizeTextarea();

            if (document.querySelector('.welcome-message')) {
                loadSuggestions();
                loadDatabaseStats();
            }
        } else {
            chatbox.style.display = "none";
            toggle.innerHTML = '<i class="fas fa-comments"></i><span class="toggle-text">AI Chat</span>';
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
        if (!userInput || isTyping)
            return;

        debugLog('Sending message: ' + userInput);

        // Add user message
        addMessage(userInput, 'user');

        // Clear input
        document.getElementById("userInput").value = "";
        autoResizeTextarea();

        // Show typing indicator
        showTypingIndicator();

        // Send AJAX request
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "chat", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                hideTypingIndicator();

                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        debugLog('Response source: ' + response.source);
                        addMessage(response.text, 'ai', response.source);
                    } catch (e) {
                        debugLog('Error parsing response: ' + e.message);
                        addMessage("Xin lỗi, có lỗi xảy ra khi xử lý phản hồi.", 'ai');
                    }
                } else {
                    debugLog('HTTP Error: ' + xhr.status);
                    addMessage("Xin lỗi, không thể kết nối đến server. Vui lòng thử lại sau.", 'ai');
                }
            }
        };
        xhr.send("userInput=" + encodeURIComponent(userInput));
    }

    function sendSuggestedMessage(question) {
        document.getElementById("userInput").value = question;
        sendMessage();
    }

    function addMessage(text, type, source) {
        var history = document.getElementById("chatbox-history");

        // Remove welcome message if exists
        var welcomeMsg = history.querySelector('.welcome-message');
        if (welcomeMsg) {
            welcomeMsg.remove();
        }

        var messageDiv = document.createElement("div");
        messageDiv.className = "chat-message " + type + "-message";

        var avatarDiv = document.createElement("div");
        avatarDiv.className = "message-avatar";
        avatarDiv.innerHTML = type === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';

        var contentDiv = document.createElement("div");
        contentDiv.className = "message-content";

        var textDiv = document.createElement("div");
        textDiv.className = "message-text";
        textDiv.innerHTML = text.replace(/\n/g, '<br>');

        contentDiv.appendChild(textDiv);
        messageDiv.appendChild(avatarDiv);
        messageDiv.appendChild(contentDiv);

        history.appendChild(messageDiv);
        scrollToBottom();
    }

    function showTypingIndicator() {
        if (isTyping)
            return;
        isTyping = true;

        var history = document.getElementById("chatbox-history");
        var typingDiv = document.createElement("div");
        typingDiv.className = "chat-message ai-message";
        typingDiv.id = "typing-indicator";

        typingDiv.innerHTML = `
            <div class="message-avatar">
                <i class="fas fa-robot"></i>
            </div>
        
            <div class="message-content">
                <div class="message-text">
                    <span class="typing-text">AI đang suy nghĩ...</span>
                </div>
            </div>
        `;

        history.appendChild(typingDiv);
        scrollToBottom();
    }

    function hideTypingIndicator() {
        isTyping = false;
        var typingIndicator = document.getElementById("typing-indicator");
        if (typingIndicator) {
            typingIndicator.remove();
        }
    }

    function clearChat() {
        if (confirm("Bạn có chắc muốn xóa toàn bộ lịch sử chat?")) {
            var history = document.getElementById("chatbox-history");
            history.innerHTML = `
                <div class="welcome-message">
                    <div class="welcome-icon">
                        <i class="fas fa-robot"></i>
                    </div>
                    <h3>Xin chào! 👋</h3>
                    <p>Tôi là AI HIKARI phiên bản nâng cấp với khả năng tìm kiếm thông minh!</p>
                    <div class="feature-highlight">
                        <div class="feature-item">
                            <i class="fas fa-search"></i>
                            <span>Tìm kiếm thông minh với từ đồng nghĩa</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-database"></i>
                            <span>1500+ câu hỏi-đáp án chuyên sâu</span>
                        </div>
                        <div class="feature-item">
                            <i class="fas fa-brain"></i>
                            <span>AI backup khi cần thiết</span>
                        </div>
                    </div>
                    <p><strong>Hãy thử những câu hỏi phổ biến:</strong></p>
                    <ul class="suggested-questions" id="suggested-questions">
                    </ul>
                    <div class="database-info">
                        <i class="fas fa-database"></i>
                        <span>Cơ sở dữ liệu: <span id="qa-count">${qaCount.toLocaleString()}</span> câu hỏi</span>
                    </div>
                </div>
            `;
            loadSuggestions();

            // Clear server session
            fetch('chat', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'action=clear'
            });
        }
    }

    function scrollToBottom() {
        var history = document.getElementById("chatbox-history");
        setTimeout(() => {
            history.scrollTop = history.scrollHeight;
        }, 100);
    }

    function autoResizeTextarea() {
        var textarea = document.getElementById("userInput");
        textarea.style.height = 'auto';
        textarea.style.height = Math.min(textarea.scrollHeight, 100) + 'px';
    }

    // Auto-resize textarea on input
    document.getElementById("userInput").addEventListener('input', autoResizeTextarea);

    // Initialize
    window.onload = function () {
        loadDatabaseStats();
        if (document.getElementById("chatbox").style.display === "block") {
            scrollToBottom();
        }
        if (document.querySelector('.welcome-message')) {
            loadSuggestions();
        }
        debugLog('Chatbox initialized with enhanced search');
    };
</script>
