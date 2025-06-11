// Basic JavaScript for interactivity
document.querySelectorAll('.chat-item').forEach(item => {
  item.addEventListener('click', () => {
    document.querySelectorAll('.chat-item').forEach(i => i.classList.remove('active'));
    item.classList.add('active');
    // Add logic to load specific chat conversation here
         var userID = "<%= userID %>";
      var ws;
      var currentPartner = null;

      function connectWebSocket() {
        ws = new WebSocket("ws://localhost:8080/Hikari/controller.message/ChatServerEndPoint?userID=" + encodeURIComponent(userID));

        ws.onopen = function() {
          console.log("WebSocket connected");
          getPartners();
        };

        ws.onmessage = function(event) {
          var data = JSON.parse(event.data);
          console.log("Received WebSocket message:", data);
          if (data.type === "partners") {
              console.log("Partners data:", data.data);
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

        ws.onerror = function(event) {
          console.error("WebSocket error:", event);
        };

        ws.onclose = function() {
          console.log("WebSocket closed");
        };
      }

      function showNewMessageNotification(sender) {
        var partners = document.querySelectorAll('.partner');
        partners.forEach(function(partnerEl) {
            if (partnerEl.dataset.partner === sender) {
                var newMessageSpan = partnerEl.querySelector('.new-message');
                if (newMessageSpan) {
                    newMessageSpan.classList.add('show');
                }
            }
        });
      }

      function getPartners() {
        var msg = {
          type: "getPartners",
          userID: userID
        };
        ws.send(JSON.stringify(msg));
      }

    function renderPartners(partners) {
  const partnerList = document.getElementById("partnerList");
  partnerList.innerHTML = "";

  partners.forEach(function(p) {
    if (p !== userID) {
      const div = document.createElement("div");
      div.classList.add("partner");
      div.dataset.partner = p;

      const avatar = document.createElement("div");
      avatar.classList.add("avatar");
      avatar.textContent = p.charAt(0).toUpperCase();

      const nameSpan = document.createElement("span");
      nameSpan.textContent = p;

      const newMsg = document.createElement("span");
      newMsg.classList.add("new-message");

      div.appendChild(avatar);
      div.appendChild(nameSpan);
      div.appendChild(newMsg);

      div.onclick = function () {
        selectPartner(p, div);
      };

      partnerList.appendChild(div);
    }
  });

  if (partnerList.children.length === 0) {
    partnerList.innerHTML = "No conversations available.";
  }
}


      function selectPartner(partner, divElement) {
        if (currentPartner === partner) return;

        currentPartner = partner;
        document.querySelectorAll(".partner").forEach(function(el) {
          el.classList.remove("selected");
        });
        divElement.classList.add("selected");

        var msg = {
          type: "history",
          sender: userID,
          receiver: partner
        };
        ws.send(JSON.stringify(msg));
      }

      function renderChatHistory(messages) {
        var chatHistory = document.getElementById("chatHistory");
        chatHistory.innerHTML = "";
        messages.forEach(function(m) {
          appendMessage(m);
        });
        chatHistory.scrollTop = chatHistory.scrollHeight;
      }

      function appendMessage(msg) {
        var chatHistory = document.getElementById("chatHistory");
        var div = document.createElement("div");
        var isSender = msg.sender === userID;
        div.classList.add("message", isSender ? "sender" : "receiver");
        div.innerHTML = "<span class='sender'>" + msg.sender + "</span>: " + msg.content;
        chatHistory.appendChild(div);
        chatHistory.scrollTop = chatHistory.scrollHeight;
      }

      function sendMessage() {
        var input = document.getElementById("messageText");
        if (!currentPartner) {
          alert("Vui lòng chọn một người chat!");
          return;
        }
        if (input.value.trim() === "") return;

        var msg = {
          type: "chat",
          sender: userID,
          receiver: currentPartner,
          content: input.value.trim()
        };

        ws.send(JSON.stringify(msg));
        input.value = "";
      }

      window.onload = function() {
        connectWebSocket();
      };

  });
});

document.querySelector('.chat-input .btn').addEventListener('click', () => {
  const textarea = document.querySelector('.chat-input textarea');
  const message = textarea.value.trim();
  if (message) {
    const chatMessages = document.querySelector('.chat-messages');
    const newMessageContainer = document.createElement('div');
    newMessageContainer.classList.add('message-container');
    newMessageContainer.style.justifyContent = 'flex-end';
    const newMessage = document.createElement('div');
    newMessage.classList.add('message', 'sent');
    newMessage.innerHTML = `${message}<div class="message-time">${new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' })}, ${new Date().toLocaleDateString('vi-VN')}</div>`;
    const avatar = document.createElement('img');
    avatar.src = '/assets/images/defaultLogoAdmin.png';
    avatar.alt = 'Giáo viên';
    avatar.classList.add('message-avatar');
    newMessageContainer.appendChild(newMessage);
    newMessageContainer.appendChild(avatar);
    chatMessages.appendChild(newMessageContainer);
    chatMessages.scrollTop = chatMessages.scrollHeight;
    textarea.value = '';
  }
});

document.querySelector('.chat-input textarea').addEventListener('keypress', (e) => {
  if (e.key === 'Enter' && !e.shiftKey) {
    e.preventDefault();
    document.querySelector('.chat-input .btn').click();
  }
});