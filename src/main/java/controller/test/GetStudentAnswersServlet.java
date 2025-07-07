package controller.test;

import com.google.gson.Gson;
import dao.TestDAO;
import dao.ResultDAO;
import dao.AnswerDAO;
import dao.QuestionDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.Test;
import model.Result;
import model.Answer;
import model.Question;

public class GetStudentAnswersServlet extends HttpServlet {
    
    private final TestDAO testDAO = new TestDAO();
    private final ResultDAO resultDAO = new ResultDAO();
    private final AnswerDAO answerDAO = new AnswerDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String testIdParam = request.getParameter("testId");
            String studentId = request.getParameter("studentID");
            System.out.println("testID: " + testIdParam);
            System.out.println("studentID: " + studentId);

            if (testIdParam == null || testIdParam.trim().isEmpty()) {
                sendErrorResponse(response, "Test ID is required");
                return;
            }
            
            if (studentId == null || studentId.trim().isEmpty()) {
                sendErrorResponse(response, "Student ID is required");
                return;
            }

            int testId = Integer.parseInt(testIdParam);
            
            Test test = testDAO.getTestById(testId);
            if (test == null) {
                sendErrorResponse(response, "Test not found");
                return;
            }

            // Lấy kết quả của học sinh
            Result studentResult = resultDAO.getResultByStudentAndTest(studentId, testId);
            if (studentResult == null) {
                sendErrorResponse(response, "Student result not found");
                return;
            }

            List<Answer> studentAnswers = answerDAO.getAnswersByStudentAndTest(studentId, testId);
            List<Question> questions = questionDAO.getQuestionsByEntity("test", testId);

            studentAnswers = (studentAnswers != null) ? studentAnswers : new ArrayList<>();
            questions = (questions != null) ? questions : new ArrayList<>();

            System.out.println("studentAnswers: " + studentAnswers);
            System.out.println("questions: " + questions);

            Map<String, Object> answerStats = calculateAnswerStatistics(studentAnswers, questions);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("status", "success");
            responseData.put("test", test);
            responseData.put("studentResult", studentResult);
            responseData.put("studentAnswers", studentAnswers);
            responseData.put("questions", questions);
            responseData.put("answerStats", answerStats);

            response.getWriter().write(gson.toJson(responseData));

        } catch (NumberFormatException e) {
            sendErrorResponse(response, "Invalid test ID format");
        } catch (SQLException e) {
            System.err.println("SQL Error in GetStudentAnswersServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Database error: " + e.getMessage());
        } catch (IOException e) {
            System.err.println("Error in GetStudentAnswersServlet: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Error loading student answers: " + e.getMessage());
        }
    }

    private Map<String, Object> calculateAnswerStatistics(List<Answer> answers, List<Question> questions) {
        Map<String, Object> stats = new HashMap<>();
        int correctCount = 0;
        int wrongCount = 0;
        int unansweredCount = questions.size(); // Mặc định tất cả câu hỏi chưa trả lời

        if (answers != null) {
            for (Answer answer : answers) {
                if (answer.isAnswered()) {
                    unansweredCount--; // Giảm số câu chưa trả lời
                    if (answer.isCorrect()) {
                        correctCount++;
                    } else {
                        wrongCount++;
                    }
                }
            }
        }

        stats.put("correctCount", correctCount);
        stats.put("wrongCount", wrongCount);
        stats.put("unansweredCount", unansweredCount);
        stats.put("totalQuestions", questions.size());

        return stats;
    }

    private void sendErrorResponse(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("status", "error");
        errorResponse.put("message", message);
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        response.getWriter().write(gson.toJson(errorResponse));
    }
}