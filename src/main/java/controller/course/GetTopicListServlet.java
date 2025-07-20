package controller.course;

import com.google.gson.Gson;
import dao.AssignmentDAO;
import dao.CourseEnrollmentDAO;
import dao.DocumentDAO;
import dao.ExerciseDAO;
import dao.LessonDAO;
import dao.ProgressDAO;
import dao.TopicDAO;
import dao.UserAccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Assignment;
import model.CourseEntrollment;
import model.Document;
import model.Exercise;
import model.Lesson;
import model.Progress;
import model.Topic;
import model.UserAccount;

public class GetTopicListServlet extends HttpServlet {

    private final DocumentDAO documentDAO = new DocumentDAO();
    private final ExerciseDAO exerciseDAO = new ExerciseDAO();
    private final LessonDAO lessonDAO = new LessonDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final TopicDAO topicDAO = new TopicDAO();
    private final Gson gson = new Gson();
    private final CourseEnrollmentDAO enrollmentDAO = new CourseEnrollmentDAO(); // Khởi tạo DAO
    private final UserAccountDAO userDAO = new UserAccountDAO();
        private final ProgressDAO progressDAO = new ProgressDAO(); // Khởi tạo ProgressDAO

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserAccount currentUser = (UserAccount) request.getSession().getAttribute("user");
        if (currentUser == null || !"Student".equals(currentUser.getRole())) {

            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }
        String userID = currentUser.getUserID();        
        String studentId = userDAO.getStudentByUserID(userID).getStudentID();
        String courseID = request.getParameter("courseID");
        String lessonIdStr = request.getParameter("lessonId");
        String assignmentIdStr = request.getParameter("assignmentId");
        String fetchType = request.getParameter("fetchType");
        CourseEntrollment currentEnrollment = enrollmentDAO.getEnrollmentByStudentAndCourse(studentId, courseID);
        if (currentEnrollment != null) {
            request.setAttribute("currentEnrollment", currentEnrollment);
            System.out.println("Enrollment ID from Servlet: " + currentEnrollment.getEnrollmentID()); // Để debug
        } else {
            System.out.println("Enrollment not found for student: " + studentId + ", course: " + courseID);
            return;
        }
        request.setAttribute("courseID", courseID);
        request.setAttribute("currentStudentId", studentId);
        if ("details".equals(fetchType)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            String jsonResponse;

            try {
                if (lessonIdStr != null && !lessonIdStr.isEmpty()) {
                    try {
                        int lessonId = Integer.parseInt(lessonIdStr);
                        Lesson currentLesson = lessonDAO.getLessonById(lessonId);
                        if (currentLesson != null) {
                            try {
                                List<Document> documents = documentDAO.getDocumentsByLessonId(lessonId);
                                currentLesson.setDocuments(documents);
                            } catch (SQLException ex) {
                                System.out.println(ex);
                            }
                            List<Exercise> exercises = exerciseDAO.getExercisesByLessonID(lessonId);
                            currentLesson.setExercises(exercises);
                            jsonResponse = gson.toJson(currentLesson);
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                            jsonResponse = gson.toJson(new ErrorResponse("Lesson not found."));
                        }
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        jsonResponse = gson.toJson(new ErrorResponse("Invalid Lesson ID format."));
                    }
                } else if (assignmentIdStr != null && !assignmentIdStr.isEmpty()) {
                    try {
                        int assignmentId = Integer.parseInt(assignmentIdStr);
                        Assignment currentAssignment = assignmentDAO.getAssignmentById(assignmentId);
                        if (currentAssignment != null) {
                            jsonResponse = gson.toJson(currentAssignment);
                        } else {
                            response.setStatus(HttpServletResponse.SC_NOT_FOUND); // 404 Not Found
                            jsonResponse = gson.toJson(new ErrorResponse("Assignment not found."));
                        }
                    } catch (NumberFormatException e) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
                        jsonResponse = gson.toJson(new ErrorResponse("Invalid Assignment ID format."));
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
                    jsonResponse = gson.toJson(new ErrorResponse("Missing lessonId or assignmentId for detail fetch."));
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
                jsonResponse = gson.toJson(new ErrorResponse("An unexpected server error occurred: " + e.getMessage()));
                System.err.println("Error fetching details: " + e.getMessage()); // Log the error for debugging
            }
            out.print(jsonResponse);
            out.flush();
            return;
        }

        if (courseID == null || courseID.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Course ID is required to view topics.");
            return;
        }
        Map<Integer, Boolean> completedLessonsMap = new HashMap<>();
        Map<Integer, Boolean> completedAssignmentsMap = new HashMap<>();

        try {
            List<Progress> studentProgressList = progressDAO.getProgressByStudent(studentId);
            for (Progress p : studentProgressList) {
                if ("complete".equals(p.getCompletionStatus())) {
                    if (p.getLessonID() != 0) { // Nếu là progress của bài học
                        completedLessonsMap.put(p.getLessonID(), true);
                    }
                    if (p.getAssignmentID() != 0) { // Nếu là progress của bài tập
                        completedAssignmentsMap.put(p.getAssignmentID(), true);
                    }
                }
            }
        } catch (Exception e) { // Bắt Exception chung để xử lý lỗi DAO
            e.printStackTrace();
            System.err.println("Lỗi khi lấy tiến độ của sinh viên: " + e.getMessage());
            // Bạn có thể xử lý lỗi này một cách khác nếu muốn, ví dụ: truyền map rỗng
        }

        // Đặt các bản đồ vào request attribute để JSP có thể truy cập
        request.setAttribute("completedLessonsMap", completedLessonsMap);
        request.setAttribute("completedAssignmentsMap", completedAssignmentsMap);
        List<Topic> topicList = null;
        int totalItems = 0;

        try {
            topicList = topicDAO.getTopicsByCourseId(courseID);
            for (Topic topic : topicList) {
                List<Assignment> assignmentList = assignmentDAO.getAssignmentsByTopicId(topic.getTopicId());
                totalItems += assignmentList.size();
                topic.setAssignments(assignmentList);

                List<Lesson> lessonList = lessonDAO.getAllLessonsByTopicID(topic.getTopicId());
                totalItems += lessonList.size();
                topic.setLessons(lessonList);
            }
            request.setAttribute("count", totalItems);
            request.setAttribute("topics", topicList);
            request.setAttribute("courseID", courseID);
            request.getRequestDispatcher("view/student/coursedetail.jsp").forward(request, response);
        } catch (RuntimeException e) {
            request.setAttribute("errorMessage", "Error retrieving topics: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    private static class ErrorResponse {

        String error; // Changed field name to 'error' to match JS error handling

        public ErrorResponse(String message) {
            this.error = message;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Often doPost just calls doGet for read-only operations
    }

    @Override
    public String getServletInfo() {
        return "Servlet for fetching course topics, lessons, and assignments.";
    }
}
