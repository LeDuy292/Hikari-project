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
import utils.ImprovedQADatabase;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONObject;

@WebServlet(name = "FixedGeminiServlet", urlPatterns = {"/chat"})
public class FixedGeminiServlet extends HttpServlet {
    private static final String GEMINI_API_KEY = "AIzaSyD6GHN1RcJlxyBpEOlr3JkE_j7lAvD6aV0";
    private static final String GEMINI_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";
    private ImprovedQADatabase qaDatabase;
    
    @Override
    public void init() throws ServletException {
        super.init();
        qaDatabase = ImprovedQADatabase.getInstance();
        System.out.println("Fixed Gemini Servlet initialized with " + qaDatabase.getQACount() + " Q&A pairs");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userInput = request.getParameter("userInput");
        String responseText = request.getParameter("responseText");
        String action = request.getParameter("action");

        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        JSONObject jsonResponse = new JSONObject();
        
        // Handle clear action
        if ("clear".equals(action)) {
            session.removeAttribute("chatHistory");
            jsonResponse.put("status", "cleared");
            response.getWriter().write(jsonResponse.toString());
            return;
        }
        
        if (userInput != null && !userInput.trim().isEmpty()) {
            try {
                String textResponse;
                boolean fromDatabase = false;
                
                if (responseText != null && !responseText.trim().isEmpty()) {
                    textResponse = responseText;
                    fromDatabase = true;
                } else {
                    // Enhanced database search
                    String dbAnswer = qaDatabase.findAnswer(userInput);
                    
                    if (dbAnswer != null && !dbAnswer.trim().isEmpty()) {
                        textResponse = dbAnswer;
                        fromDatabase = true;
                        System.out.println("✅ Answer found in database for: " + userInput);
                    } else {
                        System.out.println("❌ No database match, using Gemini API for: " + userInput);
                        textResponse = getGeminiResponse(userInput);
                        fromDatabase = false;
                    }
                }

                // Store in session history
                List<String[]> chatHistory = (List<String[]>) session.getAttribute("chatHistory");
                if (chatHistory == null) {
                    chatHistory = new ArrayList<>();
                }
                
                // Add source indicator
                String responseWithSource = textResponse;
                
                chatHistory.add(new String[]{userInput, responseWithSource});
                session.setAttribute("chatHistory", chatHistory);

                jsonResponse.put("text", responseWithSource);
                jsonResponse.put("source", fromDatabase ? "database" : "api");
                
            } catch (Exception ex) {
                Logger.getLogger(FixedGeminiServlet.class.getName()).log(Level.SEVERE, null, ex);
                jsonResponse.put("text", "Xin lỗi, có lỗi xảy ra khi xử lý câu hỏi của bạn. Vui lòng thử lại sau.");
                jsonResponse.put("source", "error");
            }
        } else {
            jsonResponse.put("text", "Vui lòng nhập câu hỏi của bạn.");
            jsonResponse.put("source", "error");
        }

        response.getWriter().write(jsonResponse.toString());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        JSONObject jsonResponse = new JSONObject();
        
        if ("suggestions".equals(action)) {
            List<String> suggestions = qaDatabase.getSuggestedQuestions(5);
            jsonResponse.put("suggestions", suggestions);
        } else if ("stats".equals(action)) {
            jsonResponse.put("totalQA", qaDatabase.getQACount());
            jsonResponse.put("status", "active");
        }
        
        response.getWriter().write(jsonResponse.toString());
    }
    
    private String getGeminiResponse(String userInput) throws Exception {
    // Bối cảnh trò chuyện để giúp Gemini hiểu đúng hệ thống Hikari
    String contextualPrompt = "Bạn là AI Assistant của hệ thống học tiếng Nhật HIKARI. " +
            "HIKARI là nền tảng học tiếng Nhật trực tuyến với các khóa học từ N5 đến N1. " +
            "Học phí các khóa học: N5 (2 triệu), N4 (2.5 triệu), N3 (3 triệu), N2 (3.5 triệu), N1 (4 triệu), " +
            "Kanji Mastery (1.8 triệu), Hội thoại Thực tế (2.2 triệu), Văn hóa Nhật (1.5 triệu), " +
            "Tiếng Nhật Thương mại (3.2 triệu), Luyện nghe N3-N2 (1.9 triệu). " +
            "Hãy trả lời câu hỏi sau một cách hữu ích và chính xác. " +
            "Nếu không biết chắc chắn, hãy gợi ý liên hệ support@hikari.edu.vn. " +
            "Câu hỏi: " + userInput;

    // Tạo JSON payload
    JSONObject payload = new JSONObject();
    JSONObject part = new JSONObject();
    part.put("text", contextualPrompt);

    JSONObject content = new JSONObject();
    content.put("parts", List.of(part));

    payload.put("contents", List.of(content));

    // Tạo yêu cầu HTTP
    HttpClient client = HttpClient.newHttpClient();
    HttpRequest apiRequest = HttpRequest.newBuilder()
            .uri(URI.create(GEMINI_ENDPOINT + "?key=" + GEMINI_API_KEY))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(payload.toString()))
            .build();

    HttpResponse<String> apiResponse = client.send(apiRequest, HttpResponse.BodyHandlers.ofString());

    // In log phản hồi để debug
    System.out.println("➡️ Gemini Request Payload: " + payload.toString(2));
    System.out.println("⬅️ Gemini Response Code: " + apiResponse.statusCode());
    System.out.println("⬅️ Gemini Response Body: " + apiResponse.body());

    try {
        JSONObject json = new JSONObject(apiResponse.body());

        // Nếu có lỗi từ API
        if (json.has("error")) {
            JSONObject error = json.getJSONObject("error");
            System.err.println("❌ Gemini API Error: " + error.toString(2));
            return "Lỗi từ Gemini API: " + error.optString("message", "Không rõ nguyên nhân.");
        }

        // Lấy nội dung trả lời
        if (json.has("candidates")) {
            return json.getJSONArray("candidates")
                    .getJSONObject(0)
                    .getJSONObject("content")
                    .getJSONArray("parts")
                    .getJSONObject(0)
                    .getString("text");
        } else {
            System.err.println("❌ Không tìm thấy 'candidates' trong phản hồi từ Gemini.");
            return "Xin lỗi, tôi không thể xử lý câu hỏi này lúc này. Vui lòng thử lại sau hoặc liên hệ support@hikari.edu.vn.";
        }
    } catch (Exception e) {
        System.err.println("❌ Lỗi khi phân tích phản hồi Gemini: " + e.getMessage());
        return "Xin lỗi, tôi không thể xử lý câu hỏi này lúc này. Vui lòng thử lại sau hoặc liên hệ support@hikari.edu.vn.";
    }
}

}