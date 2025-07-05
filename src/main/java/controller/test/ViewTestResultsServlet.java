package controller.test;

import com.google.gson.Gson;
import dao.TestDAO;
import dao.ResultDAO;
import dao.UserAccountDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import model.Test;
import model.Result;
import model.UserAccount;

public class ViewTestResultsServlet extends HttpServlet {
    
    private final TestDAO testDAO = new TestDAO();
    private final ResultDAO resultDAO = new ResultDAO();
    private final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // Kiểm tra teacherID trong session
        HttpSession session = request.getSession();
        String teacherID = session != null ? (String) session.getAttribute("teacherID") : null;
        Map<String, Object> responseData = new HashMap<>();
        
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
            // Lấy danh sách kết quả
            List<Result> results = resultDAO.getResultsByTestId(testId);
            int totalStudents = results.size();
            int completedTests = 0;
            int passedTests = 0;
            double totalScore = 0;
            double highestScore = 0;
            double lowestScore = 100;
            UserAccount user;
            for (Result result : results) {
                if ("completed".equals(result.getStatus())) {
                    completedTests++;
                    double score = result.getScore();
                    totalScore += score;
                    user = new UserAccountDAO().getStudentNameById(result.getStudentID());
                    result.setStudentName(user.getFullName());
                    if (score >= 50) {
                        passedTests++;
                    }
                    
                    if (score > highestScore) {
                        highestScore = score;
                    }
                    
                    if (score < lowestScore) {
                        lowestScore = score;
                    }
                }
            }
            System.out.println(results);
            double averageScore = completedTests > 0 ? totalScore / completedTests : 0;
            double passRate = completedTests > 0 ? (double) passedTests / completedTests * 100 : 0;
            responseData.put("test", test);
            responseData.put("results", results);
            responseData.put("totalStudents", totalStudents);
            responseData.put("completedTests", completedTests);
            responseData.put("passedTests", passedTests);
            responseData.put("averageScore", Math.round(averageScore * 100.0) / 100.0);
            responseData.put("highestScore", highestScore);
            responseData.put("lowestScore", completedTests > 0 ? lowestScore : 0);
            responseData.put("passRate", Math.round(passRate * 100.0) / 100.0);
            
            response.getWriter().write(gson.toJson(responseData));
            
        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid test ID format");
        } catch (IOException e) {
            System.out.println("Error in ViewTestResultsServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Error loading test results: " + e.getMessage());
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
