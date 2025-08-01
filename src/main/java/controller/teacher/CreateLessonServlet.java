package controller.teacher;

import dao.CourseDAO;
import dao.TopicDAO;
import dao.TaskDAO;
import dao.LessonDAO;
import dao.DocumentDAO;
import dao.TeacherDAO;
import dao.ExerciseDAO;
import dao.QuestionDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Course;
import model.Topic;
import model.Lesson;
import model.UserAccount;
import model.Document;
import java.io.IOException;
import java.util.List;
import org.json.JSONObject;
import java.io.PrintWriter;
import java.util.ArrayList;

@WebServlet(name = "CreateLessonServlet", urlPatterns = {"/createLesson"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB: lưu file tạm trong bộ nhớ, lớn hơn thì lưu ra ổ đĩa tạm
        maxFileSize = 1024 * 1024 * 500, // 500MB cho mỗi file
        maxRequestSize = 1024 * 1024 * 600 // 600MB tổng request
)
public class CreateLessonServlet extends HttpServlet {

    private final CourseDAO courseDAO = new CourseDAO();
    private final TopicDAO topicDAO = new TopicDAO();
    private final TaskDAO taskDAO = new TaskDAO();
    private final LessonDAO lessonDAO = new LessonDAO();
    private final ExerciseDAO exerciseDAO = new ExerciseDAO();
    private final QuestionDAO questionDAO = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
            String topicId = request.getParameter("topicId");
            String taskID = request.getParameter("taskID");

            if (topicId == null || topicId.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Topic ID is required");
                return;
            }

            // Get topic information
            Topic topic = topicDAO.getTopicById(topicId);
            if (topic == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Topic not found");
                return;
            }

            // Get course information
            Course course = courseDAO.getCourseByID(topic.getCourseId());
            if (course == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Course not found");
                return;
            }

            // Set attributes for JSP
            request.setAttribute("topic", topic);
            request.setAttribute("course", course);
            if (taskID != null && !taskID.trim().isEmpty()) {
                request.setAttribute("taskID", taskID);
            }

            // Forward to createLesson.jsp
            request.getRequestDispatcher("/view/teacher/createLesson.jsp").forward(request, response);

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading create lesson page");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        try {
            // Kiểm tra xác thực
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Vui lòng đăng nhập.\"}");
                return;
            }
            UserAccount currentUser = (UserAccount) session.getAttribute("user");
            if (!"Teacher".equals(currentUser.getRole())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Chỉ giáo viên mới có quyền tạo bài học.\"}");
                return;
            }

            // Lấy dữ liệu biểu mẫu
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String topicID = request.getParameter("topicId");

            // Xác thực dữ liệu
            if (title == null || title.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Tiêu đề không được để trống.\"}");
                return;
            }

            if (topicID == null || topicID.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Chủ đề không được để trống.\"}");
                return;
            }

            // Kiểm tra topic tồn tại
            Topic topic = topicDAO.getTopicById(topicID);
            if (topic == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Chủ đề không tồn tại.\"}");
                return;
            }

            // Lấy courseId để lưu file
            Course course = courseDAO.getCourseByID(topic.getCourseId());
            if (course == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Khóa học không tồn tại.\"}");
                return;
            }

            // Xử lý file tải lên
            Part mediaFile = request.getPart("mediaFile");
            Part pdfFiles = request.getPart("pdfFiles");

            // Kiểm tra bắt buộc phải có video
            if (mediaFile == null || mediaFile.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Video là bắt buộc cho bài học.\"}");
                return;
            }

            // Lấy teacherID từ userID
            TeacherDAO teacherDAO = new TeacherDAO();
            model.Teacher teacher = teacherDAO.getTeacherProfile(currentUser.getUserID());
            if (teacher == null || teacher.getTeacherID() == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Không tìm thấy thông tin giáo viên.\"}");
                return;
            }

            Lesson lesson = new Lesson();
            lesson.setTitle(title);
            lesson.setDescription(description);
            lesson.setTopicID(topicID);
            lesson.setTeacherID(teacher.getTeacherID());
            lesson.setIsCompleted(true);

            boolean lessonAdded = lessonDAO.addLesson(lesson, mediaFile, course.getCourseID());
            if (!lessonAdded) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi khi lưu bài học hoặc upload video.\"}");
                return;
            }

            List<Lesson> lessons = lessonDAO.getAllLessonsByTopicID(topicID);
            int lessonId = lessons.stream()
                    .filter(l -> l.getTitle().equals(title) && l.getDescription().equals(description))
                    .findFirst()
                    .map(Lesson::getId)
                    .orElse(-1);

            if (lessonId == -1) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Không thể lấy ID bài học vừa tạo.\"}");
                return;
            }

            if (pdfFiles != null && pdfFiles.getSize() > 0) {
                DocumentDAO documentDAO = new DocumentDAO();
                List<String> uploadErrors = new ArrayList<>();
                for (Part pdfPart : request.getParts()) {
                    if ("pdfFiles".equals(pdfPart.getName()) && pdfPart.getSize() > 0) {
                        // Validate file type
                        String contentType = pdfPart.getContentType();
                        if (!"application/pdf".equals(contentType)) {
                            uploadErrors.add("File " + pdfPart.getSubmittedFileName() + " không phải là PDF.");
                            continue;
                        }

                        // Validate file size (50MB)
                        long maxSize = 50 * 1024 * 1024; // 50MB
                        if (pdfPart.getSize() > maxSize) {
                            uploadErrors.add("File " + pdfPart.getSubmittedFileName() + " quá lớn. Kích thước tối đa là 50MB.");
                            continue;
                        }

                        // Create document object for each PDF
                        Document document = new Document();
                        document.setLessonID(lessonId);
                        document.setTitle("Tài liệu PDF cho bài học " + title + " - " + pdfPart.getSubmittedFileName());
                        document.setDescription("Tài liệu PDF kèm theo bài học");
                        document.setUploadedBy(teacher.getTeacherID());

                        try {
                            documentDAO.addDocumentByLesson(document, pdfPart, null);
                            System.out.println("Tài liệu PDF " + pdfPart.getSubmittedFileName() + " đã được lưu thành công.");
                        } catch (Exception e) {
                            System.err.println("Lỗi khi xử lý file PDF " + pdfPart.getSubmittedFileName() + ": " + e.getMessage());
                            uploadErrors.add("Lỗi khi lưu file " + pdfPart.getSubmittedFileName() + ": " + e.getMessage());
                        }
                    }
                }
            }

            // Tạo response JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_OK);

            try (PrintWriter out = response.getWriter()) {
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("status", "success");
                jsonResponse.put("message", "Tạo bài học thành công với ID = " + lessonId);
                jsonResponse.put("lessonId", lessonId);

                // Thêm taskID vào response nếu có
                String taskID = request.getParameter("taskID");
                if (taskID != null && !taskID.trim().isEmpty()) {
                    jsonResponse.put("taskID", taskID);
                }

                out.print(jsonResponse.toString());
                out.flush();
            } catch (Exception e) {
                System.err.println("Lỗi khi gửi response: " + e.getMessage());
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                try (PrintWriter out = response.getWriter()) {
                    out.print("{\"status\":\"error\",\"message\":\"Lỗi khi xử lý yêu cầu\"}");
                    out.flush();
                }
            }

        } catch (IOException e) {
            String errorMessage = "Lỗi xử lý file: " + e.getMessage();
            System.out.println(errorMessage);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + errorMessage + "\"}");
        } catch (Exception e) {
            String errorMessage = "Lỗi khi tạo bài học: " + e.getClass().getName() + ": " + e.getMessage();
            System.out.println(errorMessage);
            e.printStackTrace(); // In stack trace để gỡ lỗi
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + errorMessage + "\"}");
        }
    }
}
