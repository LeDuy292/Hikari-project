package controller.test;

import dao.AnswerDAO;
import dao.QuestionDAO;
import dao.ResultDAO;
import dao.StudentDAO;
import dao.TestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Answer;
import model.Question;
import model.Result;
import model.Test;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "TestServlet", urlPatterns = {"/Test"})
public class TestServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TestServlet.class.getName());
    private final TestDAO testDAO = new TestDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final AnswerDAO answerDAO = new AnswerDAO();
    private final ResultDAO resultDAO = new ResultDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    private void validateTest(Test test, List<Question> questions) throws ServletException {
        LOGGER.log(Level.INFO, "Validating test: test={0}, questionsSize={1}",
                new Object[]{test != null ? test.getId() : null, questions != null ? questions.size() : 0});
        if (test == null) {
            LOGGER.log(Level.SEVERE, "Test validation failed: Test is null");
            throw new ServletException("Test not found");
        }
        if (questions == null || questions.isEmpty()) {
            LOGGER.log(Level.SEVERE, "Test validation failed: No questions found for test");
            throw new ServletException("No questions found for this test");
        }
        if (test.getTotalQuestions() != questions.size()) {
            LOGGER.log(Level.SEVERE, "Test validation failed: Invalid number of questions, expected={0}, actual={1}",
                    new Object[]{test.getTotalQuestions(), questions.size()});
            throw new ServletException("Invalid number of questions");
        }
        if (test.getDuration() <= 0) {
            LOGGER.log(Level.SEVERE, "Test validation failed: Invalid test duration={0}", test.getDuration());
            throw new ServletException("Invalid test duration");
        }
        LOGGER.log(Level.INFO, "Test validation passed for test ID={0}", test.getId());
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) throws IOException {
        try {
            request.setAttribute("errorMessage", errorMessage);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            // If error page is not found, send a simple error response
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(
                "<!DOCTYPE html><html><head><title>Lỗi</title><style>" +
                "body{font-family:Arial,sans-serif;line-height:1.6;margin:0;padding:20px;color:#333;}" +
                ".error-container{max-width:800px;margin:50px auto;padding:20px;border:1px solid #e0e0e0;border-radius:5px;}" +
                "h1{color:#d32f2f;}a{color:#1976d2;text-decoration:none;}" +
                "</style></head><body><div class='error-container'><h1>Đã xảy ra lỗi</h1>" +
                "<p>" + errorMessage + "</p>" +
                "<p><a href='javascript:history.back()'>Quay lại</a> | <a href='" + 
                request.getContextPath() + "/home'>Về trang chủ</a></p>" +
                "</div></body></html>"
            );
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "Processing GET request for TestServlet");
        HttpSession session = request.getSession();
        String userID = (String) session.getAttribute("userId");

        LOGGER.log(Level.INFO, "Checking user authentication, userID={0}", userID);
        String studentId = studentDAO.getStudentIdByUserId(userID);
        if (studentId == null) {
            LOGGER.log(Level.WARNING, "No student profile found for userID={0}", userID);
            handleError(request, response, "Please log in to access the test.");
            return;
        }
        LOGGER.log(Level.INFO, "Student ID={0} found for userID={1}", new Object[]{studentId, userID});
        session.setAttribute("studentId", studentId);

        String action = request.getParameter("action");
        LOGGER.log(Level.INFO, "Action parameter: {0}", action);
        
        if (action == null || action.equals("start")) {
            String testIdStr = request.getParameter("testId");
            String indexStr = request.getParameter("index");
            LOGGER.log(Level.INFO, "Test ID parameter: {0}, Index: {1}", new Object[]{testIdStr, indexStr});
            
            if (testIdStr == null || testIdStr.isEmpty()) {
                LOGGER.log(Level.WARNING, "Test ID is missing or empty");
                handleError(request, response, "Test ID is required.");
                return;
            }

            try {
                int testId = Integer.parseInt(testIdStr);
                int index = 0;
                if (indexStr != null && !indexStr.isEmpty()) {
                    index = Integer.parseInt(indexStr);
                }
                
                LOGGER.log(Level.INFO, "Fetching test with ID={0}", testId);
                Test test = testDAO.getTestById(testId);
                LOGGER.log(Level.INFO, "Fetching questions for test ID={0}", testId);
                List<Question> questions = questionDAO.getQuestionsByEntity("test", testId);
                validateTest(test, questions);

                LOGGER.log(Level.INFO, "Setting session attributes for test ID={0}, index={1}", new Object[]{testId, index});
                
                // Initialize or maintain session attributes
                Test sessionTest = (Test) session.getAttribute("test");
                Long testStartTime = (Long) session.getAttribute("testStartTime");

                if (sessionTest == null || sessionTest.getId() != testId) {
                    // New test or different test - initialize everything
                    session.setAttribute("test", test);
                    session.setAttribute("questions", questions);
                    session.setAttribute("answers", new ArrayList<>(Collections.nCopies(questions.size(), null)));
                    session.setAttribute("markedQuestions", new boolean[questions.size()]);
                    session.setAttribute("selectedQuestions", new ArrayList<Integer>());

                    // Khởi tạo thời gian bắt đầu test
                    long currentTime = System.currentTimeMillis();
                    session.setAttribute("testStartTime", currentTime);
                    session.setAttribute("timeLeft", test.getDuration() * 60);

                    LOGGER.log(Level.INFO, "Initialized new test session - testId={0}, startTime={1}, duration={2} minutes",
                              new Object[]{testId, new java.util.Date(currentTime), test.getDuration()});
                } else {
                    // Same test - calculate actual time left
                    if (testStartTime == null) {
                        // Fallback: reset start time
                        testStartTime = System.currentTimeMillis();
                        session.setAttribute("testStartTime", testStartTime);
                        session.setAttribute("timeLeft", test.getDuration() * 60);
                        LOGGER.log(Level.WARNING, "Missing testStartTime, reset timer for test ID={0}", testId);
                    } else {
                        // Calculate time left based on elapsed time
                        long elapsedSeconds = (System.currentTimeMillis() - testStartTime) / 1000;
                        int calculatedTimeLeft = (int) Math.max(0, test.getDuration() * 60 - elapsedSeconds);
                        session.setAttribute("timeLeft", calculatedTimeLeft);

                        LOGGER.log(Level.INFO, "Calculated timeLeft for test ID={0}: elapsed={1}s, remaining={2}s",
                                  new Object[]{testId, elapsedSeconds, calculatedTimeLeft});

                        // Auto-redirect to result if time is up
                        if (calculatedTimeLeft <= 0) {
                            LOGGER.log(Level.INFO, "Time expired for test ID={0}, redirecting to auto-submit", testId);
                            response.sendRedirect(request.getContextPath() + "/Test?action=autoSubmit&testId=" + testId);
                            return;
                        }
                    }
                }
                
                session.setAttribute("currentQuestionIndex", index);
                session.setAttribute("viewResult", false);

                LOGGER.log(Level.INFO, "Forwarding to test.jsp for test ID={0}, timeLeft={1}", 
                          new Object[]{testId, session.getAttribute("timeLeft")});
                request.getRequestDispatcher("view/student/test.jsp").forward(request, response);
                
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid number format for testId or index", e);
                handleError(request, response, "Invalid Test ID or index format.");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error in doGet", e);
                handleError(request, response, "Database error occurred. Please try again later.");
            } catch (ServletException e) {
                LOGGER.log(Level.SEVERE, "Servlet exception during test validation: {0}", e.getMessage());
                handleError(request, response, e.getMessage());
            }
            
        } else if (action.equals("viewResult")) {
            try {
                int testId = Integer.parseInt(request.getParameter("testId"));
                int index = Integer.parseInt(request.getParameter("index"));
                LOGGER.log(Level.INFO, "Processing viewResult for test ID={0}, question index={1}",
                        new Object[]{testId, index});

                Test test = testDAO.getTestById(testId);
                List<Question> questions = questionDAO.getQuestionsByEntity("test", testId);
                List<Answer> answers = answerDAO.getAnswersByStudentAndTest(studentId, testId);

                if (test == null || questions.isEmpty() || index < 0 || index >= questions.size()) {
                    LOGGER.log(Level.WARNING, "Invalid test or question index: testID={0}, index={1}, questionsSize={2}",
                            new Object[]{testId, index, questions != null ? questions.size() : 0});
                    handleError(request, response, "Invalid test or question index.");
                    return;
                }

                LOGGER.log(Level.INFO, "Setting session attributes for viewing result, test ID={0}", testId);
                session.setAttribute("test", test);
                session.setAttribute("questions", questions);
                session.setAttribute("answers", answers);
                session.setAttribute("currentQuestionIndex", index);
                session.setAttribute("viewResult", true);
                
                LOGGER.log(Level.INFO, "Forwarding to test.jsp for viewing result, test ID={0}", testId);
                request.getRequestDispatcher("view/student/test.jsp").forward(request, response);
                
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid number format in viewResult", e);
                handleError(request, response, "Invalid test ID or index format.");
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error while fetching result data", e);
                handleError(request, response, "Database error occurred. Please try again later.");
            }
        } else {
            LOGGER.log(Level.WARNING, "Invalid action parameter: {0}", action);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.log(Level.INFO, "Processing POST request for TestServlet");
        HttpSession session = request.getSession();
        String studentId = (String) session.getAttribute("studentId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (studentId == null) {
            LOGGER.log(Level.WARNING, "No studentId found in session");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"error\", \"error\": \"Please log in to submit answers.\"}");
            return;
        }
        LOGGER.log(Level.INFO, "Student ID={0} from session", studentId);

        String action = request.getParameter("action");
        LOGGER.log(Level.INFO, "Action parameter: {0}", action);
        
        Test test = (Test) session.getAttribute("test");
        List<Question> questions = (List<Question>) session.getAttribute("questions");
        List<Answer> answers = (List<Answer>) session.getAttribute("answers");
        Integer currentQuestionIndex = (Integer) session.getAttribute("currentQuestionIndex");
        boolean[] markedQuestions = (boolean[]) session.getAttribute("markedQuestions");
        
        @SuppressWarnings("unchecked")
        List<Integer> selectedQuestions = (List<Integer>) session.getAttribute("selectedQuestions");
        
        if (test == null || questions == null || answers == null) {
            LOGGER.log(Level.WARNING, "Session expired: test={0}, questions={1}, answers={2}",
                    new Object[]{test, questions, answers});
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"error\": \"Session expired. Please start the test again.\"}");
            return;
        }
        LOGGER.log(Level.INFO, "Session attributes valid for test ID={0}", test.getId());

        try {
            if (action.equals("submitAnswer")) {
                String studentAnswer = request.getParameter("studentAnswer");
                String indexStr = request.getParameter("index");
                String timeLeftStr = request.getParameter("timeLeft");
                
                if (indexStr == null || studentAnswer == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Missing required parameters.\"}");
                    return;
                }
                
                int index = Integer.parseInt(indexStr);
                
                // Update timeLeft in session
                if (timeLeftStr != null && !timeLeftStr.isEmpty()) {
                    try {
                        int timeLeft = Integer.parseInt(timeLeftStr);
                        session.setAttribute("timeLeft", timeLeft);
                        LOGGER.log(Level.INFO, "Updated session timeLeft to {0}", timeLeft);
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid timeLeft format: {0}", timeLeftStr);
                    }
                }
                
                LOGGER.log(Level.INFO, "Submitting answer for question index={0}, answer={1}",
                        new Object[]{index, studentAnswer});

                if (index < 0 || index >= questions.size()) {
                    LOGGER.log(Level.WARNING, "Invalid question index: {0}", index);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Invalid question index.\"}");
                    return;
                }

                Question currentQuestion = questions.get(index);
                if (currentQuestion == null) {
                    LOGGER.log(Level.WARNING, "Question not found for index: {0}", index);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Question not found.\"}");
                    return;
                }

                boolean isCorrect = studentAnswer.equals(currentQuestion.getCorrectOption());
                Answer answer = new Answer(
                        currentQuestion.getId(),
                        studentId,
                        test.getId(),
                        studentAnswer,
                        currentQuestion.getCorrectOption(),
                        isCorrect ? currentQuestion.getMark() : 0,
                        isCorrect,
                        true // answered
                );
                
                answers.set(index, answer);
                session.setAttribute("answers", answers);
                
                // Save to database
                answerDAO.insertAnswer(answer);
                LOGGER.log(Level.INFO, "Answer saved for question ID={0}, student ID={1}, correct={2}",
                        new Object[]{currentQuestion.getId(), studentId, isCorrect});

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\"}");
                
            } else if (action.equals("updateTime")) {
                // Handle time update requests
                String timeLeftStr = request.getParameter("timeLeft");
                if (timeLeftStr != null && !timeLeftStr.isEmpty()) {
                    try {
                        int timeLeft = Integer.parseInt(timeLeftStr);
                        session.setAttribute("timeLeft", timeLeft);
                        LOGGER.log(Level.INFO, "Time updated in session: {0} seconds", timeLeft);
                        response.setStatus(HttpServletResponse.SC_OK);
                        response.getWriter().write("{\"status\": \"success\"}");
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid timeLeft format in updateTime: {0}", timeLeftStr);
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        response.getWriter().write("{\"status\": \"error\", \"error\": \"Invalid time format.\"}");
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Time parameter missing.\"}");
                }
                
            } else if (action.equals("submitQuiz")) {
                String timeLeftStr = request.getParameter("timeLeft");
                int timeLeft = 0;
                if (timeLeftStr != null && !timeLeftStr.isEmpty()) {
                    try {
                        timeLeft = Integer.parseInt(timeLeftStr);
                    } catch (NumberFormatException e) {
                        LOGGER.log(Level.WARNING, "Invalid timeLeft format in submitQuiz: {0}", timeLeftStr);
                    }
                }
                
                int duration = test.getDuration() * 60;
                double totalScore = 0;

                LOGGER.log(Level.INFO, "Processing quiz submission for test ID={0}, timeLeft={1}",
                        new Object[]{test.getId(), timeLeft});
                
                // Ensure all questions have answers (even if null)
                for (int i = 0; i < questions.size(); i++) {
                    if (answers.get(i) == null) {
                        Question q = questions.get(i);
                        Answer emptyAnswer = new Answer(q.getId(), studentId, test.getId(), null, q.getCorrectOption(), 0, false, false);
                        answers.set(i, emptyAnswer);
                        LOGGER.log(Level.INFO, "No answer provided for question ID={0}, marking as unanswered", q.getId());
                    }
                    totalScore += answers.get(i).getScore();
                }

                LOGGER.log(Level.INFO, "Inserting answers batch for test ID={0}, student ID={1}",
                        new Object[]{test.getId(), studentId});
                answerDAO.insertAnswersBatch(answers);
                
                String timeTaken = formatTime(duration - timeLeft);
                String status = totalScore >= test.getTotalMarks() * 0.5 ? "Pass" : "Fail";
                Result result = new Result(studentId, test.getId(), totalScore, timeTaken, status);
                
                LOGGER.log(Level.INFO, "Adding result for test ID={0}, student ID={1}, score={2}, status={3}",
                        new Object[]{test.getId(), studentId, totalScore, status});
                resultDAO.addResult(result);

                // Set result attributes for display
                session.setAttribute("score", totalScore);
                session.setAttribute("timeTaken", timeTaken);
                session.setAttribute("resultStatus", status);

                LOGGER.log(Level.INFO, "Forwarding to result.jsp for test ID={0}", test.getId());
                request.getRequestDispatcher("view/student/result.jsp").forward(request, response);
                
            } else if (action.equals("markQuestion")) {
                String indexStr = request.getParameter("index");
                if (indexStr == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Index parameter missing.\"}");
                    return;
                }
                
                int index = Integer.parseInt(indexStr);
                if (index >= 0 && index < markedQuestions.length) {
                    markedQuestions[index] = !markedQuestions[index];
                    session.setAttribute("markedQuestions", markedQuestions);
                    LOGGER.log(Level.INFO, "Question {0} marked status: {1}", new Object[]{index, markedQuestions[index]});
                    response.setStatus(HttpServletResponse.SC_OK);
                    response.getWriter().write("{\"status\": \"success\"}");
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Invalid question index.\"}");
                }
                
            } else if (action.equals("selectQuestion")) {
                String indexStr = request.getParameter("index");
                if (indexStr == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Index parameter missing.\"}");
                    return;
                }
                
                int index = Integer.parseInt(indexStr);
                LOGGER.log(Level.INFO, "Selecting question at index={0} for test ID={1}", new Object[]{index, test.getId()});
                
                if (selectedQuestions == null) {
                    selectedQuestions = new ArrayList<>();
                    session.setAttribute("selectedQuestions", selectedQuestions);
                }
                
                if (!selectedQuestions.contains(index)) {
                    selectedQuestions.add(index);
                    session.setAttribute("selectedQuestions", selectedQuestions);
                }
                
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\"}");
                
            } else if (action.equals("syncTime")) {
                // Đồng bộ thời gian với client
                String timeLeftStr = request.getParameter("timeLeft");
                String clientTimeStr = request.getParameter("clientTime");
                
                Long testStartTime = (Long) session.getAttribute("testStartTime");
                if (testStartTime == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"status\": \"error\", \"error\": \"Test not started.\"}");
                    return;
                }
                
                // Tính toán thời gian còn lại từ server
                long currentTime = System.currentTimeMillis();
                long elapsedSeconds = (currentTime - testStartTime) / 1000;
                int serverTimeLeft = (int) Math.max(0, test.getDuration() * 60 - elapsedSeconds);
                
                // Cập nhật session
                session.setAttribute("timeLeft", serverTimeLeft);
                
                LOGGER.log(Level.INFO, "Time sync - server: {0}s, client: {1}s", 
                          new Object[]{serverTimeLeft, timeLeftStr});
                
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\", \"serverTimeLeft\": " + serverTimeLeft + "}");

            } else if (action.equals("autoSubmit")) {
                // Xử lý auto-submit khi hết thời gian
                LOGGER.log(Level.INFO, "Auto-submitting quiz for test ID={0}", test.getId());
                
                // Tương tự logic submitQuiz nhưng đánh dấu là auto-submit
                double totalScore = 0;
                for (int i = 0; i < questions.size(); i++) {
                    if (answers.get(i) == null) {
                        Question q = questions.get(i);
                        Answer emptyAnswer = new Answer(q.getId(), studentId, test.getId(), null, q.getCorrectOption(), 0, false, false);
                        answers.set(i, emptyAnswer);
                    }
                    totalScore += answers.get(i).getScore();
                }
                
                answerDAO.insertAnswersBatch(answers);
                
                String timeTaken = test.getDuration() + ":00"; // Full duration used
                String status = totalScore >= test.getTotalMarks() * 0.5 ? "Pass" : "Fail";
                Result result = new Result(studentId, test.getId(), totalScore, timeTaken, status + " (Auto-submitted)");
                resultDAO.addResult(result);
                
                session.setAttribute("score", totalScore);
                session.setAttribute("timeTaken", timeTaken);
                session.setAttribute("resultStatus", status);
                session.setAttribute("autoSubmitted", true);
                
                request.getRequestDispatcher("view/student/result.jsp").forward(request, response);
            } else {
                LOGGER.log(Level.WARNING, "Invalid action parameter: {0}", action);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\": \"error\", \"error\": \"Invalid action.\"}");
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in doPost", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"error\": \"Database error occurred.\"}");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid number format in doPost", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"error\": \"Invalid number format.\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in doPost", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"error\": \"An unexpected error occurred: " + e.getMessage() + "\"}");
        }
    }

    private String formatTime(int seconds) {
        int minutes = seconds / 60;
        int secs = seconds % 60;
        LOGGER.log(Level.INFO, "Formatting time: {0} seconds to {1}:{2}",
                new Object[]{seconds, minutes, secs});
        return String.format("%d:%02d", minutes, secs);
    }
}
