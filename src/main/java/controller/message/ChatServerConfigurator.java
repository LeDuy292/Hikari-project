package controller.message;


import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.*;
import java.util.List;
import java.util.Map;

public class ChatServerConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig sec, HandshakeRequest request, HandshakeResponse response) {
        Map<String, List<String>> params = request.getParameterMap();
        if (params.containsKey("userID")) {
            String userID = params.get("userID").get(0);
            System.out.println(">>> userID in handshake: " + userID); // thêm log để debug
            sec.getUserProperties().put("userID", userID);
        }
    }

}
