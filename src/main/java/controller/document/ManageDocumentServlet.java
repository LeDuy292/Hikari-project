package controller.document;

import com.google.gson.Gson;
import dao.ClassDAO;
import dao.DocumentDAO;
import dao.UserAccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.ClassRoom;
import model.Document;
import model.Teacher;
import model.UserAccount;




@WebServlet(urlPatterns = {"/manageDocuments/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ManageDocumentServlet extends HttpServlet {

    private final DocumentDAO dao = new DocumentDAO();
    private final ClassDAO classDao = new ClassDAO();
    private final Gson gson = new Gson();
    private final UserAccountDAO userDAO = new UserAccountDAO();

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    UserAccount currentUser = (UserAccount) request.getSession().getAttribute("user");
    if (currentUser == null || !"Teacher".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
        return;
    }

    Teacher teacher = userDAO.getByUserID(currentUser.getUserID());

    if (teacher == null) {
        response.getWriter().println("Không tìm thấy thông tin giáo viên.");
        return;
    }

    String teacherID = teacher.getTeacherID();
    System.out.println("Teacher ID: " + teacherID);

    String pathInfo = request.getPathInfo();
    String accept = request.getHeader("Accept");

    try {
        // ✅ Nếu là request AJAX lấy danh sách lớp
        if ("/classes".equals(pathInfo)) {
            List<ClassRoom> classes = classDao.getClassByTeacherID(teacherID);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(classes));
            return;
        }

        if (accept != null && accept.contains("application/json")) {
            String classIdStr = request.getParameter("classId");
            String filter = request.getParameter("filter");

            List<Document> documents;
            if (classIdStr != null && !classIdStr.trim().isEmpty()) {
                documents = dao.getDocumentByTeacherAndCLass(teacherID, classIdStr);
            } else {
                documents = dao.getDocumentByTeacher(teacherID);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(documents));
            return;
        }

        // ✅ Nếu là người dùng mở trình duyệt vào /manageDocuments
        request.getRequestDispatcher("/view/teacher/manageDocument.jsp").forward(request, response);

    } catch (ServletException | IOException e) {
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.getWriter().write("{\"error\": \"Lỗi khi xử lý: " + e.getMessage() + "\"}");
    }
}


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserAccount currentUser = (UserAccount) request.getSession().getAttribute("user");
        if (currentUser == null || !"Teacher".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        Teacher teacher = userDAO.getByUserID(currentUser.getUserID());

        if (teacher == null) {
            response.getWriter().println("Không tìm thấy thông tin giáo viên.");
            return;
        }

        String teacherID = teacher.getTeacherID();
        System.out.println("Teacher ID: " + teacherID);

        try {
            String classIDStr = request.getParameter("classID");
            if (classIDStr == null || classIDStr.trim().isEmpty()) {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Vui lòng chọn classID.\"}");
                return;
            }

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            Part filePart = request.getPart("fileUrl");
            Part imgPart = request.getPart("imageUrl");
            if (title == null || title.trim().isEmpty() || filePart == null || filePart.getSize() == 0) {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Thông tin không hợp lệ.\"}");
                return;
            }

            dao.addDocument(new Document(0, 0, classIDStr, title, description, null, null, null, teacherID), filePart, imgPart);
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"message\": \"Tài liệu đã được thêm.\"}");
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"classID không hợp lệ.\"}");
        } catch (SQLException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Lỗi khi thêm tài liệu: " + e.getMessage() + "\"}");
        } catch (ServletException | IOException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi server khi thêm tài liệu: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserAccount currentUser = (UserAccount) request.getSession().getAttribute("user");
        if (currentUser == null || !"Teacher".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        Teacher teacher = userDAO.getByUserID(currentUser.getUserID());

        if (teacher == null) {
            response.getWriter().println("Không tìm thấy thông tin giáo viên.");
            return;
        }

        String teacherID = teacher.getTeacherID();
        System.out.println("Teacher ID: " + teacherID);

        try {
            int documentId = Integer.parseInt(request.getParameter("documentId"));
            String classIDStr = request.getParameter("classID");
            if (classIDStr == null || classIDStr.trim().isEmpty()) {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Vui lòng chọn classID.\"}");
                return;
            }
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            Part imgPart = request.getPart("imageUrl");
            if (title == null || title.trim().isEmpty()) {
                response.setContentType("application/json");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Thông tin không hợp lệ.\"}");
                return;
            }
            Document doc = new Document(documentId, 0, classIDStr, title, description, null, null, null, teacherID);
            dao.updateDocument(doc, imgPart);
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"message\": \"Tài liệu đã được cập nhật.\"}");
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"documentId hoặc classID không hợp lệ.\"}");
        } catch (SQLException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Lỗi khi cập nhật tài liệu: " + e.getMessage() + "\"}");
        } catch (ServletException | IOException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi server khi cập nhật tài liệu: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String documentIDStr = request.getPathInfo();
            int documentID = Integer.parseInt(documentIDStr.replace("/", ""));
            dao.deleteDocument(documentID);
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"message\": \"Tài liệu đã được xóa.\"}");
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"documentId không hợp lệ.\"}");
        } catch (IOException | SQLException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi khi xóa tài liệu: " + e.getMessage() + "\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Document management servlet";
    }
}
