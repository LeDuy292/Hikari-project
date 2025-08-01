package controller.teacher;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import dao.AssignmentDAO;
import dao.QuestionDAO;
import dao.TaskDAO;
import dao.TopicDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Assignment;
import model.Question;
import model.Task;
import model.Topic;
import model.UserAccount;

@MultipartConfig
@WebServlet(name = "CreateAssignmentServlet", urlPatterns = {"/createAssignment"})
public class CreateAssignmentServlet extends HttpServlet {

    private final Gson gson = new Gson();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final TaskDAO taskDAO = new TaskDAO();
    private final TopicDAO topicDAO = new TopicDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage");
            return;
        }

        UserAccount currentUser = (UserAccount) session.getAttribute("user");
        if (!"Teacher".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/loginPage");
            return;
        }

        try {
            String taskIDStr = request.getParameter("taskID");
            String topicId = request.getParameter("topicId");

            if (taskIDStr == null || taskIDStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required.");
                return;
            }
            if (topicId == null || topicId.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Topic ID is required");
                return;
            }

            int taskID = Integer.parseInt(taskIDStr);
            Task task = taskDAO.getTaskById(taskID);
            if (task == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found.");
                return;
            }

            Topic topic = topicDAO.getTopicById(topicId);
            if (topic == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Topic not found");
                return;
            }

            request.setAttribute("topic", topic);
            request.setAttribute("task", task);
            request.getRequestDispatcher("/view/teacher/createAssignment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            Logger.getLogger(CreateAssignmentServlet.class.getName()).log(Level.SEVERE, "Invalid Task ID format: {0}", e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Task ID format.");
        } catch (SQLException e) {
            Logger.getLogger(CreateAssignmentServlet.class.getName()).log(Level.SEVERE, "Error loading page: {0}", e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading the page.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String type = request.getParameter("type");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String taskIDStr = request.getParameter("taskID");
            String topicId = request.getParameter("topicId");
            String questionsDataJson = request.getParameter("questionsData");

            Logger.getLogger(CreateAssignmentServlet.class.getName()).log(Level.INFO,
                "Nhận dữ liệu: type={0}, title={1}, description={2}, taskID={3}, topicId={4}, questionsData={5}",
                new Object[]{type, title, description, taskIDStr, topicId, questionsDataJson});

            if (title == null || title.trim().isEmpty()) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Tiêu đề không được để trống.");
                return;
            }
            if (taskIDStr == null || taskIDStr.trim().isEmpty()) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Không tìm thấy Task ID.");
                return;
            }
            if (topicId == null || topicId.trim().isEmpty()) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Không tìm thấy Topic ID.");
                return;
            }
            if (questionsDataJson == null || questionsDataJson.trim().isEmpty() || "[]".equals(questionsDataJson)) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Vui lòng thêm ít nhất một câu hỏi.");
                return;
            }
            if (type == null || !type.equals("assignment")) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Loại entity không hợp lệ.");
                return;
            }

            int taskID = Integer.parseInt(taskIDStr);
            List<Question> questions;
            try {
                questions = gson.fromJson(questionsDataJson, new TypeToken<List<Question>>(){}.getType());
            } catch (JsonSyntaxException e) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu câu hỏi không đúng định dạng JSON.");
                return;
            }

            if (questions == null || questions.isEmpty()) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Danh sách câu hỏi rỗng.");
                return;
            }

            for (Question q : questions) {
                if (q.getQuestionText() == null || q.getOptionA() == null || q.getOptionB() == null ||
                    q.getOptionC() == null || q.getOptionD() == null || q.getCorrectOption() == null) {
                    sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Câu hỏi không đầy đủ thông tin.");
                    return;
                }
            }

            Task task = taskDAO.getTaskById(taskID);
            if (task == null) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Task không tồn tại.");
                return;
            }

            Topic topic = topicDAO.getTopicById(topicId);
            if (topic == null) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Topic ID không hợp lệ.");
                return;
            }

            Assignment assignment = new Assignment();
            assignment.setTitle(title);
            assignment.setDescription(description);
            assignment.setTopicID(topicId);
            assignment.setTotalQuestions(questions.size());
            assignment.setTotalMark(questions.stream().mapToDouble(Question::getMark).sum());
            assignment.setIsComplete(true);
            assignment.setDuration(0); // Không bắt buộc trong Assignment

            int assignmentId;
            assignmentId = assignmentDAO.insertAndReturnId(assignment);

            if (assignmentId > 0) {
                for (Question q : questions) {
                    q.setEntityID(assignmentId);
                    q.setEntityType("assignment");
                    try {
                        questionDAO.insertQuestion(q);
                    } catch (SQLException e) {
                        Logger.getLogger(CreateAssignmentServlet.class.getName()).log(Level.SEVERE, "Lỗi khi lưu Question: {0}", e.getMessage());
                        sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lưu câu hỏi: " + e.getMessage());
                        return;
                    }
                }

                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.removeAttribute("uploadedQuestions");
                }

                sendSuccessResponse(response, "Tạo bài tập thành công!", assignmentId);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tạo bài tập trong cơ sở dữ liệu.");
            }

        } catch (NumberFormatException e) {
            Logger.getLogger(CreateAssignmentServlet.class.getName()).log(Level.SEVERE, "Task ID không hợp lệ: {0}", e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Task ID không hợp lệ.");
        } catch (Exception e) {
            Logger.getLogger(CreateAssignmentServlet.class.getName()).log(Level.SEVERE, "Lỗi server: {0}", e.getMessage());
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã có lỗi xảy ra phía máy chủ: " + e.getMessage());
        }
    }

    private void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("status", "error");
        errorResponse.put("message", message);
        response.getWriter().write(gson.toJson(errorResponse));
    }

    private void sendSuccessResponse(HttpServletResponse response, String message, int id) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        Map<String, Object> successResponse = new HashMap<>();
        successResponse.put("status", "success");
        successResponse.put("message", message);
        successResponse.put("id", id);
        response.getWriter().write(gson.toJson(successResponse));
    }
}