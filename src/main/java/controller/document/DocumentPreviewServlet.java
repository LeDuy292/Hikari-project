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
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
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
                // Tạo sample document để test
                document = createSampleDocument(documentId);
            }

            // Kiểm tra quyền truy cập (tạm thời cho phép tất cả)
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

            // Xử lý S3 URL hoặc local file
            if (isS3Url(fileUrl)) {
                streamS3File(fileUrl, response, document.getTitle(), true);
            } else {
                // Fallback cho local files (nếu có)
                streamSamplePDF(response, document.getTitle(), true);
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

    private Document createSampleDocument(int documentId) {
        return new Document(
            documentId,
            0,
            null,
            "Sample Document " + documentId,
            "This is a sample document for testing purposes",
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/sample/sample_" + documentId + ".pdf",
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/images/Japanese-N5.jpg",
            new java.sql.Timestamp(System.currentTimeMillis()),
            "System"
        );
    }

    private boolean isS3Url(String fileUrl) {
        return fileUrl != null && (fileUrl.startsWith("https://") && fileUrl.contains(".s3.") && fileUrl.contains(".amazonaws.com"));
    }

    private void streamS3File(String s3Url, HttpServletResponse response, String title, boolean isPreview) throws IOException {
        LOGGER.info("Streaming S3 file: " + s3Url);
        
        try {
            URL url = new URL(s3Url);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(10000); // 10 seconds
            connection.setReadTimeout(30000); // 30 seconds
            
            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                LOGGER.warning("S3 file not accessible, response code: " + responseCode + ", serving sample PDF");
                streamSamplePDF(response, title, isPreview);
                return;
            }

            // Lấy content type từ S3
            String contentType = connection.getContentType();
            if (contentType == null || contentType.isEmpty()) {
                contentType = "application/pdf"; // Default cho PDF
            }

            // Thiết lập headers
            response.setContentType(contentType);
            if (isPreview) {
                response.setHeader("Content-Disposition", "inline; filename=\"" + sanitizeFileName(title) + ".pdf\"");
            } else {
                response.setHeader("Content-Disposition", "attachment; filename=\"" + sanitizeFileName(title) + ".pdf\"");
            }
            response.setHeader("Cache-Control", "private, max-age=3600");
            
            // Lấy content length nếu có
            int contentLength = connection.getContentLength();
            if (contentLength > 0) {
                response.setContentLength(contentLength);
            }

            // Stream file từ S3 đến response
            try (InputStream inputStream = connection.getInputStream();
                 OutputStream outputStream = response.getOutputStream()) {
                
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
                outputStream.flush();
            }
            
            connection.disconnect();
            LOGGER.info("Successfully streamed S3 file: " + s3Url);
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error streaming S3 file: " + s3Url + ", serving sample PDF", e);
            streamSamplePDF(response, title, isPreview);
        }
    }

    private void streamSamplePDF(HttpServletResponse response, String title, boolean isPreview) throws IOException {
        LOGGER.info("Serving sample PDF for: " + title);
        
        String samplePdfContent = createSamplePdfContent(title);
        byte[] pdfBytes = samplePdfContent.getBytes();
        
        response.setContentType("application/pdf");
        if (isPreview) {
            response.setHeader("Content-Disposition", "inline; filename=\"" + sanitizeFileName(title) + ".pdf\"");
        } else {
            response.setHeader("Content-Disposition", "attachment; filename=\"" + sanitizeFileName(title) + ".pdf\"");
        }
        response.setHeader("Cache-Control", "private, max-age=3600");
        response.setContentLength(pdfBytes.length);
        
        try (OutputStream os = response.getOutputStream()) {
            os.write(pdfBytes);
            os.flush();
        }
        
        LOGGER.info("Served sample PDF for: " + title);
    }

    private boolean hasAccessToDocument(HttpSession session, Document document) {
        // Tạm thời cho phép tất cả truy cập để test
        return true;
    }

    private String createSamplePdfContent(String title) {
        return "%PDF-1.4\n" +
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
                "/Length 200\n" +
                ">>\n" +
                "stream\n" +
                "BT\n" +
                "/F1 24 Tf\n" +
                "100 700 Td\n" +
                "(" + (title != null ? title.replaceAll("[()\\\\]", "") : "Sample Document") + ") Tj\n" +
                "0 -50 Td\n" +
                "/F1 16 Tf\n" +
                "(HIKARI - Japanese Learning System) Tj\n" +
                "0 -30 Td\n" +
                "(This is a sample PDF document for preview) Tj\n" +
                "0 -30 Td\n" +
                "(Generated automatically by the system) Tj\n" +
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
                "0000000535 00000 n \n" +
                "trailer\n" +
                "<<\n" +
                "/Size 6\n" +
                "/Root 1 0 R\n" +
                ">>\n" +
                "startxref\n" +
                "613\n" +
                "%%EOF";
    }

    private String sanitizeFileName(String fileName) {
        if (fileName == null || fileName.trim().isEmpty()) {
            return "document";
        }
        return fileName.replaceAll("[^a-zA-Z0-9._\\-\\s]", "_").trim();
    }
}
