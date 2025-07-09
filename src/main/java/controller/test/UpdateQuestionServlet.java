package controller.test;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import dao.QuestionDAO;
import java.io.IOException;
import java.io.BufferedReader;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.Question;

public class UpdateQuestionServlet extends HttpServlet {
    
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
      

        try {
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

            // Parse JSON thành Question object
            Question question = gson.fromJson(jsonData, Question.class);
            
            // Validation
            if (question.getId() <= 0) {
                sendErrorResponse(response, "Invalid question ID");
                return;
            }

            if (question.getQuestionText() == null || question.getQuestionText().trim().isEmpty()) {
                sendErrorResponse(response, "Question text is required");
                return;
            }

            if (question.getCorrectOption() == null || 
                !question.getCorrectOption().matches("[ABCD]")) {
                sendErrorResponse(response, "Valid correct option (A, B, C, or D) is required");
                return;
            }

            // Set default mark if not provided
            if (question.getMark() <= 0) {
                question.setMark(1.0);
            }

            // Cập nhật câu hỏi
            questionDAO.updateQuestion(question);

            // Tạo success response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("status", "success");
            responseData.put("message", "Question updated successfully");
            responseData.put("question", question);

            response.getWriter().write(gson.toJson(responseData));

        } catch (JsonSyntaxException | IOException | SQLException e) {
            System.out.println("Error in UpdateQuestionServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Error updating question: " + e.getMessage());
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
