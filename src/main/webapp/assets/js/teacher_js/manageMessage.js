var ws;
var currentPartner = null;
var userMap = userMap || {};

function connectWebSocket() {
    if (!userID) {
        console.error("userID is not defined or empty");
        alert("Không thể kết nối: Vui lòng đăng nhập lại.");
        return;
    }
    console.log("Connecting WebSocket for user:", userID);
    ws = new WebSocket(wsUrl);

    ws.onopen = function () {
        console.log("WebSocket connected successfully");
        getPartners();
        if (receiverID && receiverID !== userID) {
            selectPartner(receiverID, document.querySelector(`.chat-item[data-partner-id="${receiverID}"]`));
        }
    };

    ws.onmessage = function (event) {
        var data = JSON.parse(event.data);
        console.log("Received WebSocket message:", data);
        if (data.type === "partners") {
            renderPartners(data.data);
        } else if (Array.isArray(data)) {
            renderChatHistory(data);
        } else if (data.type === "chat") {
            appendMessage(data);
            if (data.sender !== currentPartner) {
                showNewMessageNotification(data.sender);
            }
        }
    };

    ws.onerror = function (event) {
        console.error("WebSocket error:", event);
        alert("Lỗi kết nối WebSocket: Vui lòng thử lại.");
    };

    ws.onclose = function (event) {
        console.log("WebSocket closed. Code: " + event.code + ", Reason: " + event.reason);
        setTimeout(connectWebSocket, 2000);
    };
}

function showNewMessageNotification(sender) {
    var chatItems = document.querySelectorAll('.chat-item');
    chatItems.forEach(function (item) {
        if (item.dataset.partnerId === sender) {
            var newMessageSpan = item.querySelector('.new-message');
            if (newMessageSpan) {
                newMessageSpan.textContent = "Tin nhắn chưa đọc";
                newMessageSpan.classList.add('show');
                item.parentNode.insertBefore(item, item.parentNode.firstChild);
            }
        }
    });
}

function getPartners() {
    if (ws && ws.readyState === WebSocket.OPEN) {
        var msg = {
            type: "getPartners",
            userID: userID
        };
        ws.send(JSON.stringify(msg));
        console.log("Requested partners for user:", userID);
    } else {
        console.error("WebSocket is not open. State:", ws ? ws.readyState : "WebSocket not initialized");
    }
}

function fetchUserInfo(userId) {
    return fetch(`/Hikari/message?json=true&receiverID=${encodeURIComponent(userId)}`, {
        headers: {
            "Accept": "application/json"
        }
    })
    .then(response => {
        if (!response.ok) throw new Error("Failed to fetch user info for " + userId);
        return response.json();
    })
    .then(data => {
        if (Array.isArray(data)) {
            const userInfo = data.find(p => p.split('|')[0] === userId);
            if (userInfo) {
                const [partnerId, fullName, profilePicture] = userInfo.split('|');
                userMap[partnerId] = {
                    fullName: fullName || partnerId,
                    profilePicture: profilePicture || "/Hikari/assets/images/profiles/default.jpg"
                };
                return userMap[partnerId];
            }
        }
        throw new Error("User not found in response");
    });
}

function renderPartners(partners) {
    const partnerList = document.getElementById("partnerList");
    partnerList.innerHTML = "";

    // Điền userMap, bao gồm cả userID của người dùng hiện tại
    userMap[userID] = userMap[userID] || { fullName: userID, profilePicture: "/Hikari/assets/images/profiles/default.jpg" };
    partners.forEach(function (p) {
        const partnerInfo = typeof p === 'string' ? p.split('|') : [p.userID, p.fullName, p.profilePicture, 0];
        const partnerId = partnerInfo[0];
        userMap[partnerId] = {
            fullName: partnerInfo[1] || partnerId,
            profilePicture: partnerInfo[2] || "/Hikari/assets/images/profiles/default.jpg"
        };
    });

    partners.sort((a, b) => {
        const aInfo = typeof a === 'string' ? a.split('|') : [a.userID, a.fullName, a.profilePicture, 0];
        const bInfo = typeof b === 'string' ? b.split('|') : [b.userID, b.fullName, b.profilePicture, 0];
        const aUnread = parseInt(aInfo[3] || 0);
        const bUnread = parseInt(bInfo[3] || 0);
        return bUnread - aUnread;
    });

    partners.forEach(function (p) {
        const partnerInfo = typeof p === 'string' ? p.split('|') : [p.userID, p.fullName, p.profilePicture, 0];
        const partnerId = partnerInfo[0];
        const fullName = partnerInfo[1] || partnerId;
        const profilePicture = partnerInfo[2] || "/Hikari/assets/images/profiles/default.jpg";
        const unreadCount = parseInt(partnerInfo[3] || 0);

        if (partnerId !== userID) {
            const div = document.createElement("div");
            div.classList.add("chat-item");
            div.dataset.partnerId = partnerId;

            const img = document.createElement("img");
            img.classList.add("chat-avatar");
            img.src = profilePicture;
            img.alt = fullName;
            

            const infoDiv = document.createElement("div");
            infoDiv.classList.add("chat-info");

            const nameDiv = document.createElement("div");
            nameDiv.classList.add("chat-name");
            nameDiv.textContent = fullName;

            const newMsg = document.createElement("span");
            newMsg.classList.add("new-message");
            if (unreadCount > 0) {
                newMsg.textContent = "Tin nhắn chưa đọc";
                newMsg.classList.add("show");
            }

            infoDiv.appendChild(nameDiv);
            infoDiv.appendChild(newMsg);
            div.appendChild(img);
            div.appendChild(infoDiv);

            div.onclick = function () {
                selectPartner(partnerId, div);
            };

            partnerList.appendChild(div);

            if (receiverID && partnerId === receiverID) {
                selectPartner(partnerId, div);
            }
        }
    });

    if (receiverID && receiverID !== userID && !document.querySelector(`.chat-item[data-partner-id="${receiverID}"]`)) {
        fetchUserInfo(receiverID)
        .then(user => {
            const div = document.createElement("div");
            div.classList.add("chat-item");
            div.dataset.partnerId = receiverID;

            const img = document.createElement("img");
            img.classList.add("chat-avatar");
            img.src = user.profilePicture;
            img.alt = user.fullName;


            const infoDiv = document.createElement("div");
            infoDiv.classList.add("chat-info");

            const nameDiv = document.createElement("div");
            nameDiv.classList.add("chat-name");
            nameDiv.textContent = user.fullName;

            const newMsg = document.createElement("span");
            newMsg.classList.add("new-message");

            infoDiv.appendChild(nameDiv);
            infoDiv.appendChild(newMsg);
            div.appendChild(img);
            div.appendChild(infoDiv);

            div.onclick = function () {
                selectPartner(receiverID, div);
            };

            partnerList.insertBefore(div, partnerList.firstChild);
            selectPartner(receiverID, div);
        })
        .catch(error => {
            console.error("Error fetching receiver info:", error);
            alert("Không thể tải thông tin người nhận.");
        });
    }

    if (partnerList.children.length === 0) {
        partnerList.innerHTML = "<div style='padding: 15px; color: #666;'>Bạn chưa có cuộc trò chuyện nào. Hãy bắt đầu nhắn tin!</div>";
    }
}

function selectPartner(partnerId, divElement) {
    if (currentPartner === partnerId) return;

    currentPartner = partnerId;
    document.querySelectorAll(".chat-item").forEach(function (el) {
        el.classList.remove("active");
    });
    if (divElement) {
        divElement.classList.add("active");
        var newMsgSpan = divElement.querySelector(".new-message");
        if (newMsgSpan) {
            newMsgSpan.classList.remove("show");
            newMsgSpan.textContent = "";
        }
    }

    if (ws && ws.readyState === WebSocket.OPEN) {
        var msg = {
            type: "history",
            sender: userID,
            receiver: partnerId
        };
        ws.send(JSON.stringify(msg));
        
    } else {
        console.error("WebSocket is not open. State:", ws ? ws.readyState : "WebSocket not initialized");
        alert("Không thể tải lịch sử chat: Kết nối WebSocket bị gián đoạn.");
    }
}

function renderChatHistory(messages) {
    var chatMessages = document.getElementById("chatMessages");
    chatMessages.innerHTML = "";

    messages.forEach(function (m) {
        if (!userMap[m.sender]) {
            fetchUserInfo(m.sender).catch(error => {
                console.error("Failed to fetch user info for", m.sender, error);
                userMap[m.sender] = {
                    fullName: m.sender,
                    profilePicture: "/Hikari/assets/images/profiles/default.jpg"
                };
            });
        }
        appendMessage(m);
    });
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

function appendMessage(msg) {
    console.log("Appending message:", msg);
    console.log("userMap for sender:", userMap[msg.sender]);

    var chatMessages = document.getElementById("chatMessages");
    var container = document.createElement("div");
    container.classList.add("message-container");
    var isSender = msg.sender === userID;

    if (!isSender) {
        var avatar = document.createElement("img");
        avatar.classList.add("message-avatar");
        avatar.src = userMap[msg.sender]?.profilePicture || "/Hikari/assets/images/profiles/default.jpg";
        avatar.alt = userMap[msg.sender]?.fullName || msg.sender;

        container.appendChild(avatar);
    }

    var messageDiv = document.createElement("div");
    messageDiv.classList.add("message", isSender ? "sent" : "received");

    var contentSpan = document.createElement("div");
    contentSpan.classList.add("content");

    if (msg.content) {
        var textSpan = document.createElement("span");
        textSpan.textContent = msg.content;
        contentSpan.appendChild(textSpan);
    }

    if (msg.imageUrl) {
        var img = document.createElement("img");
        img.src = msg.imageUrl;
        img.alt = "Attached image";
        img.style.maxWidth = "200px";
        img.style.maxHeight = "200px";
        img.style.marginTop = "5px";
        img.style.borderRadius = "5px";
        contentSpan.appendChild(img);
    }

    messageDiv.appendChild(contentSpan);

    if (msg.timestamp) {
        var timeSpan = document.createElement("div");
        timeSpan.classList.add("message-time");
        timeSpan.textContent = new Date(msg.timestamp).toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
        messageDiv.appendChild(timeSpan);
    }

    container.appendChild(messageDiv);

    if (isSender) {
        var avatar = document.createElement("img");
        avatar.classList.add("message-avatar");
        avatar.src = userMap[msg.sender]?.profilePicture || "/Hikari/assets/images/profiles/default.jpg";
        avatar.alt = userMap[msg.sender]?.fullName || msg.sender;

        container.appendChild(avatar);
    }

    chatMessages.appendChild(container);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

function uploadImage(file, callback) {
    var formData = new FormData();
    formData.append("image", file);

    fetch("/Hikari/UploadImageServlet", {
        method: "POST",
        body: formData
    })
    .then(response => {
        console.log("Image upload response status:", response.status);
        if (!response.ok) throw new Error("Image upload failed");
        return response.json();
    })
    .then(data => {
        console.log("Image upload response data:", data);
        if (data.success && data.imageUrl) {
            callback(null, data.imageUrl);
        } else {
            callback(new Error(data.message || "Image upload failed"));
        }
    })
    .catch(error => {
        console.error("Image upload error:", error);
        callback(error);
    });
}

function sendMessage() {
    var input = document.getElementById("messageText");
    var imageInput = document.getElementById("imageUpload");
    var content = input.value.trim();

    if (!currentPartner) {
        alert("Vui lòng chọn một người chat!");
        console.error("No partner selected");
        return;
    }

    if (!userID || userID === currentPartner) {
        alert("Lỗi: Người gửi hoặc người nhận không hợp lệ.");
        console.error("Invalid sender or receiver", { userID, currentPartner });
        return;
    }

    if (content === "" && !imageInput.files[0]) {
        console.warn("Empty message or no image selected");
        return;
    }

    var msg = {
        type: "chat",
        sender: userID,
        receiver: currentPartner,
        content: content || "",
        timestamp: new Date().toISOString()
    };

    if (imageInput.files[0]) {
        uploadImage(imageInput.files[0], function (error, imageUrl) {
            if (error) {
                alert("Lỗi tải ảnh: " + error.message);
                console.error("Image upload failed:", error);
                return;
            }
            msg.imageUrl = imageUrl;
            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify(msg));
                console.log("Sent message with image:", msg);
            } else {
                alert("Không thể gửi tin nhắn: Kết nối WebSocket bị gián đoạn.");
                console.error("WebSocket is not open. State:", ws ? ws.readyState : "WebSocket not initialized");
            }
            input.value = "";
            imageInput.value = "";
        });
    } else {
        if (ws && ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify(msg));
            console.log("Sent message:", msg);
        } else {
            alert("Không thể gửi tin nhắn: Kết nối WebSocket bị gián đoạn.");
            console.error("WebSocket is not open. State:", ws ? ws.readyState : "WebSocket not initialized");
        }
        input.value = "";
    }
}

window.onload = function () {
    if (!userID) {
        console.error("userID is not defined");
        alert("Không thể tải trang nhắn tin: Vui lòng đăng nhập lại.");
        return;
    }

    connectWebSocket();

    const sendButton = document.getElementById("sendMessageBtn");
    if (sendButton) {
        sendButton.addEventListener("click", function () {
            console.log("Send button clicked");
            sendMessage();
        });
    } else {
        console.error("Send button not found");
    }

    const messageText = document.querySelector('.chat-input textarea');
    if (messageText) {
        messageText.addEventListener('keypress', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                console.log("Enter key pressed");
                sendMessage();
            }
        });
    } else {
        console.error("Message textarea not found");
    }

    const imageInput = document.getElementById("imageUpload");
    if (imageInput) {
        imageInput.addEventListener("change", function () {
            if (this.files[0]) {
                console.log("Image selected");
                sendMessage();
            }
        });
    } else {
        console.error("Image input not found");
    }
};