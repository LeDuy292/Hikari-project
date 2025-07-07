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
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.Question;

public class AddQuestionServlet extends HttpServlet {
    
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
            if (question.getQuestionText() == null || question.getQuestionText().trim().isEmpty()) {
                sendErrorResponse(response, "Question text is required");
                return;
            }

            if (question.getCorrectOption() == null || 
                !question.getCorrectOption().matches("[ABCD]")) {
                sendErrorResponse(response, "Valid correct option (A, B, C, or D) is required");
                return;
            }

            if (question.getEntityID() <= 0) {
                sendErrorResponse(response, "Valid test ID is required");
                return;
            }

            // Set default values
            if (question.getMark() <= 0) {
                question.setMark(1.0);
            }
            
            if (question.getEntityType() == null) {
                question.setEntityType("test");
            }

            // Thêm câu hỏi mới
            questionDAO.insertQuestion(question);

            // Tạo success response
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("status", "success");
            responseData.put("message", "Question added successfully");
            responseData.put("questionId", question.getId()); 

            response.getWriter().write(gson.toJson(responseData));

        } catch (JsonSyntaxException | IOException | SQLException e) {
            System.out.println("Error in AddQuestionServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Error adding question: " + e.getMessage());
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
