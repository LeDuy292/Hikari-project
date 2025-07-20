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
            request.setAttribute("errorMessage", "Please log in to access the test.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
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
                request.setAttribute("errorMessage", "Test ID is required.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
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
                session.setAttribute("test", test);
                session.setAttribute("questions", questions);
                session.setAttribute("currentQuestionIndex", index);
                if (session.getAttribute("answers") == null) {
                    session.setAttribute("answers", new ArrayList<>(Collections.nCopies(questions.size(), null)));
                }
                if (session.getAttribute("markedQuestions") == null) {
                    session.setAttribute("markedQuestions", new boolean[questions.size()]);
                }
                // CHANGED: Initialize timeLeft based on test duration
                if (session.getAttribute("timeLeft") == null) {
                    session.setAttribute("timeLeft", test.getDuration() * 60);
                }
                // CHANGED: Initialize selectedQuestions if not exists
                if (session.getAttribute("selectedQuestions") == null) {
                    session.setAttribute("selectedQuestions", new ArrayList<Integer>());
                }

                LOGGER.log(Level.INFO, "Forwarding to test.jsp for test ID={0}", testId);
                request.getRequestDispatcher("view/student/test.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid Test ID or index format.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("errorMessage", "Database error occurred. Please try again later.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (ServletException e) {
                LOGGER.log(Level.SEVERE, "Servlet exception during test validation: {0}", e.getMessage());
                request.setAttribute("errorMessage", e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
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
                    request.setAttribute("errorMessage", "Invalid test or question index.");
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }

                LOGGER.log(Level.INFO, "Setting session attributes for viewing result, test ID={0}", testId);
                session.setAttribute("test", test);
                session.setAttribute("questions", questions);
                session.setAttribute("answers", answers);
                session.setAttribute("currentQuestionIndex", index);
                request.setAttribute("viewResult", true);
                LOGGER.log(Level.INFO, "Forwarding to test.jsp for viewing result, test ID={0}", testId);
                request.getRequestDispatcher("view/student/test.jsp").forward(request, response);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Database error while fetching result data", e);
                request.setAttribute("errorMessage", "Database error occurred. Please try again later.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
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
            response.getWriter().write("{\"error\": \"Please log in to submit answers.\"}");
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
        
        if (test == null || questions == null || answers == null || currentQuestionIndex == null) {
            LOGGER.log(Level.WARNING, "Session expired: test={0}, questions={1}, answers={2}, currentQuestionIndex={3}",
                    new Object[]{test, questions, answers, currentQuestionIndex});
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Session expired. Please start the test again.\"}");
            return;
        }
        LOGGER.log(Level.INFO, "Session attributes valid for test ID={0}, currentQuestionIndex={1}",
                new Object[]{test.getId(), currentQuestionIndex});

        try {
            if (action.equals("submitAnswer")) {
                String studentAnswer = request.getParameter("studentAnswer");
                int index = Integer.parseInt(request.getParameter("index"));
                LOGGER.log(Level.INFO, "Submitting answer for question index={0}, answer={1}",
                        new Object[]{index, studentAnswer});

                if (index < 0 || index >= questions.size()) {
                    LOGGER.log(Level.WARNING, "Invalid question index: {0}", index);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid question index.\"}");
                    return;
                }

                Question currentQuestion = questions.get(index);
                if (currentQuestion == null) {
                    LOGGER.log(Level.WARNING, "Question not found for index: {0}", index);
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Question not found.\"}");
                    return;
                }

                Answer answer = new Answer(
                        currentQuestion.getId(),
                        studentId,
                        test.getId(),
                        studentAnswer,
                        currentQuestion.getCorrectOption(),
                        studentAnswer != null && studentAnswer.equals(currentQuestion.getCorrectOption()) ? currentQuestion.getMark() : 0,
                        studentAnswer != null && studentAnswer.equals(currentQuestion.getCorrectOption()),
                        studentAnswer != null
                );
                answers.set(index, answer);
                session.setAttribute("answers", answers);
                answerDAO.insertAnswer(answer);
                LOGGER.log(Level.INFO, "Answer saved for question ID={0}, student ID={1}",
                        new Object[]{currentQuestion.getId(), studentId});

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\"}");
            } else if (action.equals("submitQuiz")) {
                int timeLeft = Integer.parseInt(request.getParameter("timeLeft"));
                int duration = test.getDuration() * 60;
                double totalScore = 0;

                LOGGER.log(Level.INFO, "Processing quiz submission for test ID={0}, timeLeft={1}",
                        new Object[]{test.getId(), timeLeft});
                for (int i = 0; i < questions.size(); i++) {
                    if (answers.get(i) == null) {
                        Question q = questions.get(i);
                        answers.set(i, new Answer(q.getId(), studentId, test.getId(), null, q.getCorrectOption(), 0, false, false));
                        LOGGER.log(Level.INFO, "No answer provided for question ID={0}, marking as incorrect", q.getId());
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

                session.setAttribute("score", totalScore);
                session.setAttribute("timeTaken", timeTaken);
                session.setAttribute("test", test);
                session.setAttribute("questions", questions);
                session.setAttribute("answers", answers);

                LOGGER.log(Level.INFO, "Forwarding to result.jsp for test ID={0}", test.getId());
                request.getRequestDispatcher("view/student/result.jsp").forward(request, response);
            } else if (action.equals("markQuestion")) {
                int index = Integer.parseInt(request.getParameter("index"));
                markedQuestions[index] = !markedQuestions[index];
                session.setAttribute("markedQuestions", markedQuestions);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\"}");
            } else if (action.equals("selectQuestion")) { // CHANGED: Handle selectQuestion action
                int index = Integer.parseInt(request.getParameter("index"));
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
            } else {
                LOGGER.log(Level.WARNING, "Invalid action parameter: {0}", action);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action.\"}");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in doPost", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error occurred.\"}");
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid index or timeLeft format", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid index or timeLeft format.\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in doPost", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"An unexpected error occurred: " + e.getMessage() + "\"}");
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
