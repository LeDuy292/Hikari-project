package controller.course;

import com.google.gson.Gson;
import dao.AssignmentDAO;
import dao.CourseDAO;
import dao.DocumentDAO;
import dao.LessonDAO;
import dao.TopicDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import model.Assignment;
import model.Document;
import model.Lesson;
import model.Topic;

/**
 *
 * @author ADMIN
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 100, maxRequestSize = 1024 * 1024 * 200)
public class LessonManagementServlet extends HttpServlet {

    private LessonDAO lessonDAO = new LessonDAO();
    private final TopicDAO topicDao = new TopicDAO();
    private final LessonDAO lessonDao = new LessonDAO();
    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String courseId = request.getParameter("courseId");
        String teacherID = request.getParameter("teacherID");
        String lessonId = request.getParameter("lessonId");
        Map<String, Object> result = new HashMap<>();

        System.out.println("Processing GET request: action=" + action + ", courseId=" + courseId + ", teacherID=" + teacherID);

        if ("getTopics".equals(action)) {
            List<Topic> topicList;
            try {
                topicList = (courseId != null && !courseId.isEmpty())
                        ? topicDao.getTopicsByCourseId(courseId)
                        : topicDao.getAllTopics();
                System.out.println("Retrieved " + topicList.size() + " topics for courseId=" + courseId);
            } catch (Exception e) {
                System.err.println("Error fetching topics for courseId: " + courseId + ", teacherID: " + teacherID);
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Lỗi khi lấy danh sách chủ đề.\"}");
                return;
            }

            // Định dạng topics
            List<Map<String, Object>> topics = topicList.stream()
                    .map(topic -> {
                        Map<String, Object> topicData = new HashMap<>();
                        topicData.put("id", topic.getTopicId());
                        topicData.put("name", topic.getTopicName());
                        topicData.put("orderIndex", topic.getOrderIndex());
                        return topicData;
                    })
                    .collect(Collectors.toList());
            result.put("topics", topics);
            System.out.println("Topics: " + gson.toJson(topics));

            // Lấy và định dạng lessons và assignments
            List<Map<String, Object>> lessonsAndExams = new ArrayList<>();
            for (Topic topic : topicList) {
                List<Lesson> lessons;
                List<Assignment> assignments;
                try {
                    lessons = lessonDao.getAllLessonsByTopicID(topic.getTopicId());
                    assignments = assignmentDAO.getAssignmentsByTopicId(topic.getTopicId());
                    System.out.println("Topic " + topic.getTopicId() + ": " + lessons.size() + " lessons, " + assignments.size() + " assignments");
                } catch (Exception e) {
                    System.err.println("Error fetching lessons or assignments for topicId: " + topic.getTopicId());
                    e.printStackTrace();
                    continue;
                }
                for (Lesson lesson : lessons) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", lesson.getId());
                    item.put("type", "lesson");
                    item.put("title", lesson.getTitle());
                    item.put("video", lesson.getMediaUrl() != null ? lesson.getMediaUrl() : "");
                    item.put("topicId", lesson.getTopicID());
                    item.put("topicName", topic.getTopicName());
                    item.put("description", lesson.getDescription() != null ? lesson.getDescription() : "");
                    item.put("isCompleted", lesson.isIsCompleted());
                    lessonsAndExams.add(item);
                    System.out.println("Lesson ID: " + lesson.getId() + ", mediaUrl: " + lesson.getMediaUrl()); // Log mediaUrl
                }
                for (Assignment assignment : assignments) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("id", assignment.getId());
                    item.put("type", "assignment");
                    item.put("title", assignment.getTitle());
                    item.put("topicId", topic.getTopicId());
                    item.put("topicName", topic.getTopicName());
                    item.put("totalMark", assignment.getTotalMark());
                    item.put("totalQuestions", assignment.getTotalQuestions());
                    item.put("duration", assignment.getDuration());
                    List<Map<String, Object>> questions = assignment.getQuestions().stream()
                            .map(q -> {
                                Map<String, Object> questionData = new HashMap<>();
                                questionData.put("id", q.getId());
                                questionData.put("questionText", q.getQuestionText());
                                questionData.put("optionA", q.getOptionA());
                                questionData.put("optionB", q.getOptionB());
                                questionData.put("optionC", q.getOptionC());
                                questionData.put("optionD", q.getOptionD());
                                questionData.put("correctOption", q.getCorrectOption());
                                questionData.put("mark", q.getMark());
                                return questionData;
                            })
                            .collect(Collectors.toList());
                    item.put("questions", questions);
                    System.out.println("Assignment " + assignment.getId() + " has " + questions.size() + " questions");
                    lessonsAndExams.add(item);
                }
            }
            result.put("data", lessonsAndExams);
            System.out.println("Lessons and exams for courseId " + courseId + ": " + gson.toJson(lessonsAndExams));
            result.put("status", "success");
            System.out.println("Final response JSON: " + gson.toJson(result));
        }
        if ("getDocument".equals(action)) {
            // Kiểm tra lessonId
            if (lessonId == null || lessonId.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Vui lòng cung cấp lessonId.\"}");
                return;
            }

            DocumentDAO documentDao = new DocumentDAO();
            List<Document> documents;
            try {
                documents = documentDao.getDocumentsByLessonId(Integer.parseInt(lessonId));
                System.out.println("Retrieved " + documents.size() + " documents for lessonId=" + lessonId);
                List<Map<String, Object>> documentList = documents.stream()
                        .map(doc -> {
                            Map<String, Object> docData = new HashMap<>();
                            docData.put("id", doc.getId());
                            docData.put("lessonID", doc.getLessonID());
                            docData.put("title", doc.getTitle());
                            docData.put("description", doc.getDescription());
                            docData.put("fileUrl", doc.getFileUrl());
                            docData.put("uploadDate", doc.getUploadDate().toString());
                            docData.put("uploadedBy", doc.getUploadedBy());
                            return docData;
                        })
                        .collect(Collectors.toList());
                result.put("data", documentList);
                result.put("status", "success");
                // Debug: Log danh sách tài liệu
                System.out.println("Documents for lessonId " + lessonId + ": " + gson.toJson(documentList));

            } catch (SQLException ex) {
                Logger.getLogger(LessonManagementServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        response.getWriter().write(gson.toJson(result));

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thêm xử lý POST nếu cần (ví dụ: thêm lesson/assignment)
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache");

        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        if ("addLesson".equals(action)) {
            try {
                String courseId = request.getParameter("courseId");
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String topicId = request.getParameter("topicId");
                String topicName = request.getParameter("topicName");
                String durationStr = request.getParameter("duration");
                Part videoPart = request.getPart("video");

                // Validation
                if (title == null || title.trim().isEmpty() || topicId == null || topicId.trim().isEmpty() || durationStr == null || courseId == null) {
                    out.println("{\"status\": \"error\", \"message\": \"Thiếu thông tin bắt buộc\"}");
                    return;
                }

                int duration;
                try {
                    duration = Integer.parseInt(durationStr);
                } catch (NumberFormatException e) {
                    out.println("{\"status\": \"error\", \"message\": \"Thời lượng phải là số nguyên\"}");
                    return;
                }

                // Tạo đối tượng Lesson
                Lesson lesson = new Lesson();
                lesson.setTopicID(topicId);
                lesson.setTopic(topicName != null ? topicName : "");
                lesson.setTitle(title);
                lesson.setDescription(description != null ? description : "");
                lesson.setDuration(duration);
                lesson.setIsCompleted(false);
                lesson.setActive(true);

                // Log videoPart
                System.out.println("videoPart: " + (videoPart != null ? videoPart.getSubmittedFileName() : "null"));

                // Lưu bài học qua LessonDAO
                boolean success = lessonDAO.addLesson(lesson, videoPart, courseId);
                if (success) {
                    System.out.println("Lesson added successfully, mediaUrl: " + lesson.getMediaUrl());
                    out.println("{\"status\": \"success\", \"message\": \"Thêm bài học thành công\"}");
                } else {
                    out.println("{\"status\": \"error\", \"message\": \"Lỗi khi lưu bài học\"}");
                }
            } catch (Exception e) {
                System.out.println("Lỗi khi thêm bài học: " + e.getMessage());
                e.printStackTrace();
                out.println("{\"status\": \"error\", \"message\": \"Lỗi server: " + e.getMessage() + "\"}");
            }
        }
        if ("addDocument".equals(action)) {
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache");
            try {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                Part filePart = request.getPart("file");
                String lessonId = request.getParameter("lessonId");

                HttpSession session = request.getSession(false);
                String uploadedBy = session != null ? (String) session.getAttribute("teacherID") : null;

                // Kiểm tra dữ liệu đầu vào
                if (title == null || title.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("{\"status\":\"error\",\"message\":\"Tiêu đề không được để trống\"}");
                    return;
                }
                if (filePart == null || filePart.getSize() == 0) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("{\"status\":\"error\",\"message\":\"File tài liệu không hợp lệ\"}");
                    return;
                }
                if (lessonId == null || lessonId.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.write("{\"status\":\"error\",\"message\":\"Vui lòng chọn một bài học\"}");
                    return;
                }
                if (uploadedBy == null) {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    out.write("{\"status\":\"error\",\"message\":\"Không tìm thấy thông tin giáo viên\"}");
                    return;
                }

                // Tạo document
                Document document = new Document();
                document.setTitle(title);
                document.setDescription(description);
                document.setLessonID(Integer.parseInt(lessonId));
                document.setUploadedBy(uploadedBy);

                // Gọi DAO để lưu tài liệu
                DocumentDAO dao = new DocumentDAO();
                dao.addDocumentByLesson(document, filePart, null);

                // Trả về JSON thành công
                response.setStatus(HttpServletResponse.SC_OK);
                out.write("{\"status\":\"success\",\"message\":\"Thêm tài liệu thành công\"}");

            } catch (ServletException | IOException | NumberFormatException | SQLException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                String errorMessage = e.getMessage() != null ? e.getMessage().replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n") : "Lỗi không xác định";
                System.err.println("Lỗi khi xử lý yêu cầu: " + errorMessage);
                out.write("{\"status\":\"error\",\"message\":\"" + errorMessage + "\"}");
            } finally {
                out.flush();
                out.close();
            }
        }

    }

    @Override
    public String getServletInfo() {
        return "Lesson Management Servlet";
    }
}
