package controller.teacher;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import dao.AssignmentDAO;
import dao.ExerciseDAO;
import dao.QuestionDAO;
import dao.TaskDAO;
import dao.TestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Assignment;
import model.Exercise;
import model.Question;
import model.Task;
import model.Test;
import model.UserAccount;

@MultipartConfig
public class TaskTestServlet extends HttpServlet {

    private final Gson gson = new Gson();
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final TestDAO testDAO = new TestDAO();
    private final TaskDAO taskDAO = new TaskDAO();
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


            String taskIDStr = request.getParameter("taskID");
            int taskID = Integer.parseInt(taskIDStr);
            Task task;
        try {
            task = taskDAO.getTaskById(taskID);
            request.setAttribute("jlptLevel",task.getJlptLevel());
        request.getRequestDispatcher("/view/teacher/taskTest.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(TaskTestServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Lấy dữ liệu từ form
            String type = request.getParameter("type");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String durationStr = request.getParameter("duration");
            String jlptLevel = request.getParameter("jlptLevel");
            String questionsDataJson = request.getParameter("questionsData");
            String taskIDStr = request.getParameter("taskID");
            int taskID = -1;
            
            if (taskIDStr != null && !taskIDStr.trim().isEmpty()) {
                try {
                    taskID = Integer.parseInt(taskIDStr);
                } catch (NumberFormatException e) {
                    sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Task ID không hợp lệ.");
                    return;
                }
            }

            // --- Validation cơ bản ---
            if (title == null || title.trim().isEmpty()) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Tiêu đề không được để trống.");
                return;
            }
            if (questionsDataJson == null || questionsDataJson.trim().isEmpty()) {
                sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Không có dữ liệu câu hỏi. Vui lòng thêm ít nhất một câu hỏi.");
                return;
            }
            if (type == null || !List.of("test").contains(type)) { // Chỉ xử lý "test" cho đơn giản, có thể mở rộng
                 sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Loại entity không hợp lệ.");
                return;
            }

            // Parse JSON câu hỏi
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
            
            // Tính toán tổng điểm và tổng câu hỏi
            int totalQuestions = questions.size();
            double totalMarks = questions.stream().mapToDouble(q -> q.getMark() > 0 ? q.getMark() : 1.0).sum();

            // Xử lý lưu vào DB
            int entityId = -1;
            switch (type) {
                case "test":
                    if (durationStr == null || !durationStr.matches("\\d+") || Integer.parseInt(durationStr) <= 0) {
                        sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Thời lượng phải là số nguyên dương.");
                        return;
                    }
                    if (jlptLevel == null || jlptLevel.trim().isEmpty()) {
                        sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "JLPT Level không được để trống.");
                        return;
                    }
                    
                    Test test = new Test();
                    test.setJlptLevel(jlptLevel);
                    test.setTitle(title);
                    test.setDescription(description);
                    test.setDuration(Integer.parseInt(durationStr));
                    test.setTotalMarks(totalMarks);
                    test.setTotalQuestions(totalQuestions);
                    test.setActive(true);
                    
                    entityId = testDAO.insertAndReturnId(test);
                    
                    for (Question q : questions) {
                        q.setEntityID(entityId);
                        q.setEntityType("test");
                        questionDAO.insertQuestion(q);
                    }
                    break;
                default:
                    sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Loại không được hỗ trợ: " + type);
                    return;
            }

            request.getSession().removeAttribute("uploadedQuestions");

            // Cập nhật task status thành "Submitted" nếu có taskID
            if (taskID > 0) {
                try {
                    boolean updateSuccess = taskDAO.updateTaskStatus(taskID, "Submitted");
                    if (updateSuccess) {
                        log("Đã cập nhật task status thành 'Submitted' cho taskID: " + taskID);
                    } else {
                        log("Không thể cập nhật task status cho taskID: " + taskID);
                    }
                } catch (SQLException e) {
                    log("Lỗi khi cập nhật task status: " + e.getMessage(), e);
                    // Không throw exception vì test đã tạo thành công
                }
            }

            sendSuccessResponse(response, "Tạo bài test thành công!", entityId);

        } catch (SQLException e) {
            log("Lỗi SQL khi lưu bài test: " + e.getMessage(), e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu khi tạo bài test.");
        } catch (Exception e) {
            log("Lỗi không xác định khi tạo bài test: " + e.getMessage(), e);
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã có lỗi không mong muốn xảy ra.");
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

    @Override
    public String getServletInfo() {
        return "Servlet thống nhất để tạo bài test/bài tập từ dữ liệu thủ công hoặc Excel.";
    }
}