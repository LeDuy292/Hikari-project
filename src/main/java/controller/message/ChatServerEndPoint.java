package controller.message;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import dao.MessageDAO;
import jakarta.websocket.CloseReason;
import jakarta.websocket.EndpointConfig;
import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import model.Message;

@ServerEndpoint(value = "/controller.message/ChatServerEndPoint", configurator = ChatServerConfigurator.class)

public class ChatServerEndPoint {

    private static final Map<String, Session> userSessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        String userID = (String) config.getUserProperties().get("userID");
        System.out.println("User connected: " + userID);

        if (userID == null) {
            try {
                session.close(new CloseReason(CloseReason.CloseCodes.CANNOT_ACCEPT, "userID is null"));
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        userSessions.put(userID, session);

    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JsonObject json = gson.fromJson(message, JsonObject.class);
            String type = json.get("type").getAsString();
                 System.out.println("Received message type: " + type + ", content: " + message); // Ghi log

            switch (type) {
                case "chat": {
                    Message chat = gson.fromJson(message, Message.class);
                    String sessionUser = (String) session.getUserProperties().get("userID");
                    if (!chat.getSender().equals(sessionUser)) {
                        session.getBasicRemote().sendText("{\"error\":\"Sender authentication failed\"}");
                        return;
                    }

                    new MessageDAO().saveMessage(chat);

                    // Gửi tin nhắn đến người nhận nếu đang online
                    Session receiverSession = userSessions.get(chat.getReceiver());
                    if (receiverSession != null && receiverSession.isOpen()) {
                        receiverSession.getBasicRemote().sendText(message);
                    }

                    // Gửi tin nhắn lại cho chính người gửi (nếu muốn hiện luôn tin nhắn của chính mình)
                    if (!chat.getSender().equals(chat.getReceiver())) { // tránh gửi 2 lần nếu gửi cho chính mình
                        session.getBasicRemote().sendText(message);
                    }

                    break;
                }
                case "history": {
                    String sender = json.get("sender").getAsString();
                    String receiver = json.get("receiver").getAsString();
                    
                    List<Message> messages = new MessageDAO().getChatHistory(sender, receiver);

                    String response = gson.toJson(messages);
                    session.getBasicRemote().sendText(response);
                    break;
                }

                case "getPartners": {
                    String userID = json.get("userID").getAsString();
                    List<String> partners = new MessageDAO().getChatPartners(userID);
                    // Đóng gói thành object để client dễ phân biệt
                    JsonObject response = new JsonObject();
                    response.addProperty("type", "partners");
                    response.add("data", gson.toJsonTree(partners));
                    session.getBasicRemote().sendText(response.toString());
                    break;
                }

                default:
                    session.getBasicRemote().sendText("{\"error\":\"Unknown type\"}");
            }
        } catch (JsonSyntaxException | IOException e) {
            try {
                session.getBasicRemote().sendText("{\"error\":\"" + e.getMessage() + "\"}");
            } catch (IOException ioException) {
            }
        }
    }

    @OnClose
    public void onClose(Session session) {
        String userID = null;
        for (Map.Entry<String, Session> entry : userSessions.entrySet()) {
            if (entry.getValue().equals(session)) {
                userID = entry.getKey();
                break;
            }
        }
        userSessions.remove(userID);
        System.out.println("Disconnected: " + userID);

    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error: " + throwable.getMessage());
    }
}
