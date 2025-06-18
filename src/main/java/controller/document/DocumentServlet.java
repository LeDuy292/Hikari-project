package controller.document;

import com.google.gson.Gson;
import dao.ClassDAO;
import dao.DocumentDAO;
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

@WebServlet(urlPatterns = {"/api/documents/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class DocumentServlet extends HttpServlet {

    private final DocumentDAO dao = new DocumentDAO();
    private final ClassDAO classDao = new ClassDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String teacherID = (String) request.getSession().getAttribute("teacherID");
        if (teacherID == null) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Vui lòng đăng nhập.\"}");
            return;
        }

        try {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String pathInfo = request.getPathInfo();
            if (pathInfo != null && pathInfo.equals("/classes")) {
                List<ClassRoom> classes = classDao.getClassByTeacherID(teacherID);
                System.out.println("Classes fetched for teacherID " + teacherID + ": " + classes);
                response.getWriter().write(gson.toJson(classes));
            } else {
                String classIdStr = request.getParameter("classId");
                String filter = request.getParameter("filter");
                List<Document> documents;
                if (classIdStr != null && !classIdStr.trim().isEmpty()) {
                    documents = dao.getDocumentByTeacherAndCLass(teacherID, classIdStr);
                } else {
                    documents = dao.getDocumentByTeacher(teacherID); // Modified to filter by teacherID
                }
                System.out.println("Documents fetched for teacherID " + teacherID + ", classId: " + classIdStr + ", filter: " + filter + ": " + documents);
                response.getWriter().write(gson.toJson(documents));
            }
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"classId không hợp lệ.\"}");
        } catch (IOException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi khi xử lý yêu cầu: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String teacherID = (String) request.getSession().getAttribute("teacherID");
        if (teacherID == null) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Vui lòng đăng nhập.\"}");
            return;
        }
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
            Part imgPart = request.getPart("imgUrl");
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
        String teacherID = (String) request.getSession().getAttribute("teacherID");
        if (teacherID == null) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Vui lòng đăng nhập.\"}");
            return;
        }
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
            Part imgPart = request.getPart("imgUrl");
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
        String teacherID = (String) request.getSession().getAttribute("teacherID");
        if (teacherID == null) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Vui lòng đăng nhập.\"}");
            return;
        }
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
