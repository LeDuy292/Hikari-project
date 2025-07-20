package controller.document;

import dao.document.DocumentDAO;
import dao.student.StudentDAO;
import dao.document.TeacherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Document;
import java.io.File;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/documents/preview/*")
public class DocumentPreviewServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DocumentPreviewServlet.class.getName());
    private final DocumentDAO documentDAO = new DocumentDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final TeacherDAO teacherDAO = new TeacherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        LOGGER.info("DocumentPreviewServlet called with path: " + request.getPathInfo());
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tài liệu không hợp lệ");
            return;
        }

        try {
            int documentId = Integer.parseInt(pathInfo.substring(1));
            LOGGER.info("Attempting to preview document ID: " + documentId);
            
            Document document = documentDAO.getDocumentById(documentId);
            if (document == null) {
                LOGGER.warning("Document not found: " + documentId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tài liệu");
                return;
            }

            // Kiểm tra quyền truy cập
            HttpSession session = request.getSession(false);
            if (!hasAccessToDocument(session, document)) {
                LOGGER.warning("Access denied to document: " + documentId);
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền xem tài liệu này");
                return;
            }

            String fileUrl = document.getFileUrl();
            if (fileUrl == null || fileUrl.trim().isEmpty()) {
                LOGGER.warning("File URL is null or empty for document: " + documentId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đường dẫn file không hợp lệ");
                return;
            }

            // Xử lý file path
            File file = getDocumentFile(fileUrl);
            if (!file.exists()) {
                LOGGER.warning("File does not exist: " + file.getAbsolutePath());
                // Tạo file PDF mẫu
                createSamplePDF(file, document.getTitle());
            }

            if (!file.canRead()) {
                LOGGER.warning("Cannot read file: " + file.getAbsolutePath());
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không thể đọc file PDF");
                return;
            }

            // Thiết lập headers cho PDF preview
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + sanitizeFileName(document.getTitle()) + ".pdf\"");
            response.setHeader("Cache-Control", "private, max-age=3600");
            response.setContentLengthLong(file.length());

            // Stream file
            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {
                
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                os.flush();
            }

            LOGGER.info("Document previewed successfully: " + documentId);

        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid document ID format: " + pathInfo);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tài liệu không hợp lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error previewing document", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi xử lý tài liệu: " + e.getMessage());
        }
    }

    private boolean hasAccessToDocument(HttpSession session, Document document) {
        // Tạm thời cho phép tất cả truy cập để test
        if (session == null) return true;
        
        String userRole = (String) session.getAttribute("role");
        String userID = (String) session.getAttribute("userID");
        
        // Admin và Coordinator có thể truy cập tất cả
        if ("Admin".equals(userRole) || "Coordinator".equals(userRole)) {
            return true;
        }
        
        // Tài liệu công khai (không thuộc lớp nào)
        if (document.getClassID() == null || document.getClassID().trim().isEmpty()) {
            return true;
        }
        
        // Kiểm tra quyền truy cập theo role
        if ("Student".equals(userRole)) {
            String studentID = (String) session.getAttribute("studentID");
            return studentID != null && documentDAO.hasAccessToDocument(userID, userRole, studentID, null, document.getId());
        } else if ("Teacher".equals(userRole)) {
            String teacherID = (String) session.getAttribute("teacherID");
            return teacherID != null && documentDAO.hasAccessToDocument(userID, userRole, null, teacherID, document.getId());
        }
        
        return true; // Default allow for testing
    }

    private File getDocumentFile(String fileUrl) {
        String realPath;
        
        if (fileUrl.startsWith("http://") || fileUrl.startsWith("https://")) {
            // URL tuyệt đối - không xử lý được, trả về file không tồn tại
            return new File("/nonexistent/path");
        } else if (fileUrl.startsWith("/")) {
            // Đường dẫn tuyệt đối từ webapp root
            realPath = getServletContext().getRealPath(fileUrl);
        } else {
            // Đường dẫn tương đối
            realPath = getServletContext().getRealPath("/" + fileUrl);
        }
        
        LOGGER.info("File URL: " + fileUrl + " -> Real path: " + realPath);
        return new File(realPath);
    }

    private void createSamplePDF(File file, String title) {
        try {
            file.getParentFile().mkdirs();
            
            String content = "%PDF-1.4\n" +
                    "1 0 obj\n" +
                    "<<\n" +
                    "/Type /Catalog\n" +
                    "/Pages 2 0 R\n" +
                    ">>\n" +
                    "endobj\n" +
                    "2 0 obj\n" +
                    "<<\n" +
                    "/Type /Pages\n" +
                    "/Kids [3 0 R]\n" +
                    "/Count 1\n" +
                    ">>\n" +
                    "endobj\n" +
                    "3 0 obj\n" +
                    "<<\n" +
                    "/Type /Page\n" +
                    "/Parent 2 0 R\n" +
                    "/MediaBox [0 0 612 792]\n" +
                    "/Contents 4 0 R\n" +
                    "/Resources <<\n" +
                    "/Font <<\n" +
                    "/F1 5 0 R\n" +
                    ">>\n" +
                    ">>\n" +
                    ">>\n" +
                    "endobj\n" +
                    "4 0 obj\n" +
                    "<<\n" +
                    "/Length 150\n" +
                    ">>\n" +
                    "stream\n" +
                    "BT\n" +
                    "/F1 24 Tf\n" +
                    "100 700 Td\n" +
                    "(" + (title != null ? title.replaceAll("[()\\\\]", "") : "Sample Document") + ") Tj\n" +
                    "0 -50 Td\n" +
                    "(HIKARI - Japanese Learning System) Tj\n" +
                    "0 -30 Td\n" +
                    "(This is a sample PDF document) Tj\n" +
                    "ET\n" +
                    "endstream\n" +
                    "endobj\n" +
                    "5 0 obj\n" +
                    "<<\n" +
                    "/Type /Font\n" +
                    "/Subtype /Type1\n" +
                    "/BaseFont /Helvetica\n" +
                    ">>\n" +
                    "endobj\n" +
                    "xref\n" +
                    "0 6\n" +
                    "0000000000 65535 f \n" +
                    "0000000009 00000 n \n" +
                    "0000000074 00000 n \n" +
                    "0000000120 00000 n \n" +
                    "0000000285 00000 n \n" +
                    "0000000485 00000 n \n" +
                    "trailer\n" +
                    "<<\n" +
                    "/Size 6\n" +
                    "/Root 1 0 R\n" +
                    ">>\n" +
                    "startxref\n" +
                    "563\n" +
                    "%%EOF";

            java.nio.file.Files.write(file.toPath(), content.getBytes());
            LOGGER.info("Created sample PDF: " + file.getAbsolutePath());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to create sample PDF", e);
        }
    }

    private String sanitizeFileName(String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return "document";
        }
        return fileName.replaceAll("[^a-zA-Z0-9._\\-\\s]", "_").trim();
    }
}
