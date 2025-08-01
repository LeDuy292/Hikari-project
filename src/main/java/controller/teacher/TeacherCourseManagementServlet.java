package controller.teacher;

import dao.CourseDAO;
import dao.TopicDAO;
import dao.LessonDAO;
import dao.AssignmentDAO;
import dao.TaskDAO;
import dao.UserAccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Course;
import model.Topic;
import model.Lesson;
import model.Assignment;
import model.UserAccount;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Task;
import java.util.ArrayList;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 100,
        maxRequestSize = 1024 * 1024 * 200
)
public class TeacherCourseManagementServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final TopicDAO topicDAO = new TopicDAO();
    private final LessonDAO lessonDAO = new LessonDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final TaskDAO taskDAO = new TaskDAO();
    private final UserAccountDAO userDAO = new UserAccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("đăng nhập vào trang taskCourse thành công ");
        // Check authentication
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
            Integer taskID = null;
            if (taskIDStr != null && !taskIDStr.isEmpty()) {
                taskID = Integer.valueOf(taskIDStr);
            }
            System.out.println("taskID" + taskID);
            String courseID;
            try {
                Task task = taskDAO.getTaskById(taskID);
                if (task == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found");
                    return;
                }
                
                courseID = task.getCourseID();
                Course course = courseDAO.getCourseByID(courseID);
                if (course == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found");
                    return;
                }
                System.out.println("courseID" + courseID);
                
                // Lấy tất cả topics cho course
                List<Topic> allTopics = topicDAO.getTopicsByCourseId(courseID);
                
                // Load lessons và assignments cho mỗi topic
                int totalLessons = 0;
                int totalAssignments = 0;
                
                for (Topic topic : allTopics) {
                    List<Lesson> lessons = lessonDAO.getAllLessonsByTopicID(topic.getTopicId());
                    List<Assignment> assignments = assignmentDAO.getAssignmentsByTopicId(topic.getTopicId());
                    topic.setLessons(lessons);
                    topic.setAssignments(assignments);
                    
                    // Tính tổng
                    totalLessons += lessons != null ? lessons.size() : 0;
                    totalAssignments += assignments != null ? assignments.size() : 0;
                }
                
                System.out.println("topic" + allTopics);
                request.setAttribute("task", task);
                request.setAttribute("course", course);
                request.setAttribute("topics", allTopics);
                request.setAttribute("totalTopics", allTopics.size());
                request.setAttribute("totalLessons", totalLessons);
                request.setAttribute("totalAssignments", totalAssignments);
                if (taskID != null) {
                    request.setAttribute("taskID", taskID);
                }

                request.getRequestDispatcher("/view/teacher/taskCourse.jsp").forward(request, response);

            } catch (SQLException ex) {
                Logger.getLogger(TeacherCourseManagementServlet.class.getName()).log(Level.SEVERE, null, ex);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid course ID format");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (null == action) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        } else {
            switch (action) {
                case "addTopic":
                    addTopic(request, response);
                    break;

                case "addExercise":
                    addExercise(request, response);
                    break;
                case "updateTaskStatus":
                    updateTaskStatus(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                    break;
            }
        }
    }

    private void addTopic(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String courseID = request.getParameter("courseID");
            String topicName = request.getParameter("topicName");
            String description = request.getParameter("description");

            if (courseID == null || courseID.trim().isEmpty() || 
                topicName == null || topicName.trim().isEmpty()) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng điền đầy đủ thông tin\"}");
                return;
            }

            String topicID = generateTopicID(courseID);
            
            int nextOrderIndex = topicDAO.getMaxOrderIndex(courseID) + 1;

            Topic topic = new Topic(topicID, topicName, description, nextOrderIndex, true, new java.util.Date(), courseID);

            boolean success = topicDAO.addTopic(topic);
            
            if (success) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Thêm topic thành công\", \"topicId\": \"" + topicID + "\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Không thể thêm topic\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
    }

    private String generateTopicID(String courseID) {
        try {
            // Lấy tất cả topics của course này
            List<Topic> existingTopics = topicDAO.getTopicsByCourseId(courseID);
            
            // Tìm topicID lớn nhất hiện có
            int maxNumber = 0;
            for (Topic topic : existingTopics) {
                String topicId = topic.getTopicId();
                if (topicId.startsWith("TP")) {
                    try {
                        int number = Integer.parseInt(topicId.substring(2));
                        if (number > maxNumber) {
                            maxNumber = number;
                        }
                    } catch (NumberFormatException e) {
                        // Bỏ qua nếu không parse được số
                    }
                }
            }
            
            // Tạo topicID tiếp theo
            int nextNumber = maxNumber + 1;
            return String.format("TP%03d", nextNumber);
            
        } catch (Exception e) {
            // Fallback nếu có lỗi
            return "TP001";
        }
    }



    private void addExercise(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String topicID = request.getParameter("topicID");
            String question = request.getParameter("question");
            String optionA = request.getParameter("optionA");
            String optionB = request.getParameter("optionB");
            String optionC = request.getParameter("optionC");
            String optionD = request.getParameter("optionD");
            String correctAnswer = request.getParameter("correctAnswer");

            // Add exercise logic here
            boolean success = true; // Placeholder

            if (success) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Exercise added successfully\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to add exercise\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private void updateTaskStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int taskID = Integer.parseInt(request.getParameter("taskID"));
            String newStatus = request.getParameter("status");

            boolean success = taskDAO.updateTaskStatus(taskID, newStatus);

            if (success) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Task status updated successfully\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update task status\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }

    private String saveFile(Part filePart, String folder) throws IOException {
        // File saving logic here
        return "uploads/" + folder + "/" + filePart.getSubmittedFileName();
    }
}
