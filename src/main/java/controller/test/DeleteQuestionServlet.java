package controller.test;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.QuestionDAO;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DeleteQuestionServlet extends HttpServlet {
    
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
       

        try {
            // Đọc JSON data từ request body
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    jsonBuffer.append(line);
                }
            }

            String jsonData = jsonBuffer.toString();
            if (jsonData.trim().isEmpty()) {
                sendErrorResponse(response, "No data provided");
                return;
            }

            // Parse JSON để lấy questionId
            JsonObject jsonObject = gson.fromJson(jsonData, JsonObject.class);
            
            if (!jsonObject.has("questionId")) {
                sendErrorResponse(response, "Question ID is required");
                return;
            }

            int questionId = jsonObject.get("questionId").getAsInt();
            
            if (questionId <= 0) {
                sendErrorResponse(response, "Invalid question ID");
                return;
            }

            // Kiểm tra câu hỏi có tồn tại không
            if (questionDAO.getQuestionById(questionId) == null) {
                sendErrorResponse(response, "Question not found");
                return;
            }

            // Xóa câu hỏi
            questionDAO.deleteQuestion(questionId);

            // Tạo success response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("status", "success");
            responseData.put("message", "Question deleted successfully");
            responseData.put("questionId", questionId);

            response.getWriter().write(gson.toJson(responseData));

        } catch (Exception e) {
            System.out.println("Error in DeleteQuestionServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Error deleting question: " + e.getMessage());
        }
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("status", "error");
        errorResponse.put("message", message);
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write(gson.toJson(errorResponse));
    }
}
