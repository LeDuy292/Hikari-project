var ws;
var currentPartner = null;
var userMap = userMap || {};


function connectWebSocket() {
    ws = new WebSocket("ws://localhost:8080/Hikari/controller.message/ChatServerEndPoint?userID=" + encodeURIComponent(userID));
    console.log("Current user:", userID);

    ws.onopen = function () {
        console.log("WebSocket connected");
        getPartners();
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
    };

    ws.onclose = function () {
        console.log("WebSocket closed");
        setTimeout(connectWebSocket, 5000); // Thử kết nối lại sau 5 giây
    };
}

function showNewMessageNotification(sender) {
    var chatItems = document.querySelectorAll('.chat-item');
    chatItems.forEach(function (item) {
        if (item.dataset.partnerId === sender) {
            var newMessageSpan = item.querySelector('.new-message');
            if (newMessageSpan) {
                newMessageSpan.classList.add('show');
            }
        }
    });
}

function getPartners() {
    if (ws.readyState === WebSocket.OPEN) {
        var msg = {
            type: "getPartners",
            userID: userID
        };
        ws.send(JSON.stringify(msg));
    } else {
        console.error("WebSocket is not open. State:", ws.readyState);
    }
}

function renderPartners(partners) {
    const partnerList = document.getElementById("partnerList");
    partnerList.innerHTML = "";

    partners.forEach(function (p) {
        const partnerInfo = typeof p === 'string' ? p.split('|') : [p.userID, p.fullName, p.profilePicture];
        const partnerId = partnerInfo[0];
        const fullName = partnerInfo[1] || partnerId;
        const profilePicture = partnerInfo[2] || "/Hikari/assets/images/profiles/default.jpg";

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

            infoDiv.appendChild(nameDiv);
            infoDiv.appendChild(newMsg);
            div.appendChild(img);
            div.appendChild(infoDiv);

            div.onclick = function () {
                selectPartner(partnerId, div);
            };

            partnerList.appendChild(div);
        }
    });

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
    divElement.classList.add("active");

    var newMsgSpan = divElement.querySelector(".new-message");
    if (newMsgSpan) newMsgSpan.classList.remove("show");

    if (ws.readyState === WebSocket.OPEN) {
        var msg = {
            type: "history",
            sender: userID,
            receiver: partnerId // Chỉ gửi partnerId, không phải toàn bộ chuỗi
        };
        ws.send(JSON.stringify(msg));
    } else {
        console.error("WebSocket is not open. State:", ws.readyState);
    }
}

function renderChatHistory(messages) {
    var chatMessages = document.getElementById("chatMessages");
    chatMessages.innerHTML = "";

    messages.forEach(function (m) {
        appendMessage(m);
    });
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

function appendMessage(msg) {
    var chatMessages = document.getElementById("chatMessages");
    var container = document.createElement("div");
    container.classList.add("message-container");
    var isSender = msg.sender === userID;

    if (!isSender) {
        var avatar = document.createElement("img");
        avatar.classList.add("message-avatar");
        avatar.src = userMap[msg.sender]?.profilePicture || "/Hikari/assets/img/profile/default.jpg";
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
        avatar.src = userMap[msg.sender]?.profilePicture || "/Hikari/assets/img/profile/default.jpg";
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
        console.log("Fetch response status:", response.status);
        return response.json();
    })
    .then(data => {
        console.log("Fetch response data:", data);
        if (data.success && data.imageUrl) {
            callback(null, data.imageUrl);
        } else {
            callback(new Error(data.message || "Image upload failed"));
        }
    })
    .catch(error => {
        console.error("Fetch error:", error);
        callback(error);
    });
}

function sendMessage() {
    var input = document.getElementById("messageText");
    var imageInput = document.getElementById("imageUpload");
    var content = input.value.trim();

    if (!currentPartner) {
        alert("Vui lòng chọn một người chat!");
        return;
    }

    if (content === "" && !imageInput.files[0]) {
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
                return;
            }
            msg.imageUrl = imageUrl;
            if (ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify(msg));
            } else {
                console.error("WebSocket is not open. State:", ws.readyState);
            }
            input.value = "";
            imageInput.value = "";
        });
    } else {
        if (ws.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify(msg));
        } else {
            console.error("WebSocket is not open. State:", ws.readyState);
        }
        input.value = "";
    }
}

window.onload = function () {
    connectWebSocket();

    document.getElementById("imageUpload").addEventListener("change", function () {
        if (this.files[0]) {
            sendMessage();
        }
    });

    // Loại bỏ event listener trùng lặp
    document.querySelector('.chat-input .btn').addEventListener('click', function () {
        sendMessage();
    });

    document.querySelector('.chat-input textarea').addEventListener('keypress', function (e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });
};
