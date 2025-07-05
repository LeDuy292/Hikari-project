package controller.test;

import com.google.gson.Gson;
import dao.TestDAO;
import dao.QuestionDAO;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.Test;
import model.Question;

public class GetTestDetailsServlet extends HttpServlet {
    
    private final TestDAO testDAO = new TestDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra teacherID trong session
        HttpSession session = request.getSession();
        String teacherID = session != null ? (String) session.getAttribute("teacherID") : null;

        if (teacherID == null) {
            teacherID = "T002"; // Default for testing
            session.setAttribute("teacherID", teacherID);
        }

        try {
            String testIdParam = request.getParameter("testId");
            if (testIdParam == null || testIdParam.trim().isEmpty()) {
                sendErrorResponse(response, "Test ID is required");
                return;
            }

            int testId = Integer.parseInt(testIdParam);
            
            // Lấy thông tin bài test
            Test test = testDAO.getTestById(testId);
            if (test == null) {
                sendErrorResponse(response, "Test not found");
                return;
            }

            // Lấy danh sách câu hỏi
            List<Question> questions = questionDAO.getQuestionsByEntity("test", testId);
            System.out.println(questions);
            // Tạo response object
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("test", test);
            responseData.put("questions", questions);
            responseData.put("status", "success");
            System.out.println(responseData);
            response.getWriter().write(gson.toJson(responseData));

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid test ID format");
        } catch (IOException | SQLException e) {
            System.out.println("Error in GetTestDetailsServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Error loading test details: " + e.getMessage());
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
