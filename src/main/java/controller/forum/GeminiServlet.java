package controller.forum;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONObject;

@WebServlet(name = "GeminiServlet", urlPatterns = {"/gemini"})
public class GeminiServlet extends HttpServlet {
    private static final String GEMINI_API_KEY = "AIzaSyD6GHN1RcJlxyBpEOlr3JkE_j7lAvD6aV0"; // Replace with your API Key
    private static final String GEMINI_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userInput = request.getParameter("userInput");
        String responseText = request.getParameter("responseText");

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        JSONObject jsonResponse = new JSONObject();
        if (userInput != null && !userInput.trim().isEmpty()) {
            try {
                String textResponse;
                if (responseText != null && !responseText.trim().isEmpty()) {
                    // Use provided responseText for predefined answers
                    textResponse = responseText;
                } else {
                    // Send request to Gemini API
                    String jsonPayload = "{\"contents\":[{\"parts\":[{\"text\":\"" + userInput + "\"}]}]}";
                    HttpClient client = HttpClient.newHttpClient();
                    HttpRequest apiRequest = HttpRequest.newBuilder()
                            .uri(URI.create(GEMINI_ENDPOINT + "?key=" + GEMINI_API_KEY))
                            .header("Content-Type", "application/json")
                            .POST(HttpRequest.BodyPublishers.ofString(jsonPayload))
                            .build();
                    HttpResponse<String> apiResponse = client.send(apiRequest, HttpResponse.BodyHandlers.ofString());

                    // Parse JSON to get text
                    try {
                        JSONObject json = new JSONObject(apiResponse.body());
                        textResponse = json.getJSONArray("candidates")
                                .getJSONObject(0)
                                .getJSONObject("content")
                                .getJSONArray("parts")
                                .getJSONObject(0)
                                .getString("text");
                    } catch (Exception e) {
                        textResponse = "Error: Could not parse response";
                        e.printStackTrace();
                    }
                }

                // Store in session history
                List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
                if (chatHistory == null) {
                    chatHistory = new ArrayList<>();
                }
                chatHistory.add(new String[]{userInput, textResponse});
                session.setAttribute("chatHistory", chatHistory);

                // Return JSON response
                jsonResponse.put("text", textResponse);
            } catch (InterruptedException ex) {
                Logger.getLogger(GeminiServlet.class.getName()).log(Level.SEVERE, null, ex);
                jsonResponse.put("text", "Error: Server error");
            }
        } else {
            jsonResponse.put("text", "Error: Empty input");
        }

        // Send JSON to client
        response.getWriter().write(jsonResponse.toString());
    }
}