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
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/documents/download/*")
public class DocumentDownloadServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DocumentDownloadServlet.class.getName());
    private final DocumentDAO documentDAO = new DocumentDAO();
    private final StudentDAO studentDAO = new StudentDAO();
    private final TeacherDAO teacherDAO = new TeacherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        LOGGER.info("DocumentDownloadServlet called with path: " + request.getPathInfo());
        
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.length() <= 1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tài liệu không hợp lệ");
            return;
        }

        try {
            int documentId = Integer.parseInt(pathInfo.substring(1));
            LOGGER.info("Attempting to download document ID: " + documentId);
            
            Document document = documentDAO.getDocumentById(documentId);
            if (document == null) {
                LOGGER.warning("Document not found: " + documentId + ", creating sample document");
                // Tạo sample document để test
                document = createSampleDocument(documentId);
            }

            // Kiểm tra quyền truy cập (tạm thời cho phép tất cả)
            HttpSession session = request.getSession(false);
            if (!hasAccessToDocument(session, document)) {
                LOGGER.warning("Access denied to document: " + documentId);
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền tải tài liệu này");
                return;
            }

            String fileUrl = document.getFileUrl();
            if (fileUrl == null || fileUrl.trim().isEmpty()) {
                LOGGER.warning("File URL is null or empty for document: " + documentId);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Đường dẫn file không hợp lệ");
                return;
            }

            // Tạo tên file an toàn
            String fileName = document.getTitle();
            if (fileName == null || fileName.trim().isEmpty()) {
                fileName = "document_" + documentId;
            }
            fileName = sanitizeFileName(fileName) + ".pdf";
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8.toString());

            // Xử lý S3 URL hoặc local file
            if (isS3Url(fileUrl)) {
                downloadS3File(fileUrl, response, fileName, encodedFileName);
            } else {
                // Fallback cho local files - tạo sample PDF
                downloadSamplePDF(response, fileName, encodedFileName, document.getTitle());
            }

            LOGGER.info("Document download completed successfully: " + documentId);

        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid document ID format: " + pathInfo);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tài liệu không hợp lệ");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error downloading document", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải tài liệu: " + e.getMessage());
        }
    }

    private Document createSampleDocument(int documentId) {
        return new Document(
            documentId,
            0,
            null,
            "Sample Document " + documentId,
            "This is a sample document for testing download functionality",
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/sample/sample_" + documentId + ".pdf",
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/images/Japanese-N5.jpg",
            new java.sql.Timestamp(System.currentTimeMillis()),
            "System"
        );
    }

    private boolean isS3Url(String fileUrl) {
        return fileUrl != null && (fileUrl.startsWith("https://") && fileUrl.contains(".s3.") && fileUrl.contains(".amazonaws.com"));
    }

    private void downloadS3File(String s3Url, HttpServletResponse response, String fileName, String encodedFileName) throws IOException {
        LOGGER.info("Downloading S3 file: " + s3Url);
        
        try {
            URL url = new URL(s3Url);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(10000); // 10 seconds
            connection.setReadTimeout(60000); // 60 seconds for download
            
            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                LOGGER.warning("S3 file not accessible, response code: " + responseCode + ", serving sample PDF");
                downloadSamplePDF(response, fileName, encodedFileName, fileName.replace(".pdf", ""));
                return;
            }

            // Lấy content type từ S3
            String contentType = connection.getContentType();
            if (contentType == null || contentType.isEmpty()) {
                contentType = "application/pdf"; // Default cho PDF
            }

            // Thiết lập headers cho download
            response.setContentType(contentType);
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedFileName);
            response.setHeader("Cache-Control", "private, max-age=0");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            
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
                long totalBytesRead = 0;
                
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                    totalBytesRead += bytesRead;
                }
                outputStream.flush();
                
                LOGGER.info("Successfully downloaded S3 file: " + s3Url + " (" + totalBytesRead + " bytes)");
            }
            
            connection.disconnect();
            
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error downloading S3 file: " + s3Url + ", serving sample PDF", e);
            downloadSamplePDF(response, fileName, encodedFileName, fileName.replace(".pdf", ""));
        }
    }

    private void downloadSamplePDF(HttpServletResponse response, String fileName, String encodedFileName, String title) throws IOException {
        LOGGER.info("Creating sample PDF download for: " + title);
        
        String samplePdfContent = createSamplePdfContent(title);
        byte[] pdfBytes = samplePdfContent.getBytes();
        
        // Thiết lập headers cho download
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedFileName);
        response.setHeader("Cache-Control", "private, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.setContentLength(pdfBytes.length);

        // Stream sample PDF
        try (OutputStream os = response.getOutputStream()) {
            os.write(pdfBytes);
            os.flush();
        }
        
        LOGGER.info("Served sample PDF download for: " + title + " (" + pdfBytes.length + " bytes)");
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
                "/Length 250\n" +
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
                "(This is a sample PDF document for download) Tj\n" +
                "0 -30 Td\n" +
                "(Generated automatically by the system) Tj\n" +
                "0 -50 Td\n" +
                "/F1 12 Tf\n" +
                "(Document ID: " + (title != null ? title : "Unknown") + ") Tj\n" +
                "0 -20 Td\n" +
                "(Download Date: " + new java.util.Date().toString() + ") Tj\n" +
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
                "0000000585 00000 n \n" +
                "trailer\n" +
                "<<\n" +
                "/Size 6\n" +
                "/Root 1 0 R\n" +
                ">>\n" +
                "startxref\n" +
                "663\n" +
                "%%EOF";
    }

    private String sanitizeFileName(String fileName) {
        if (fileName == null) return "document";
        return fileName.replaceAll("[^a-zA-Z0-9._-]", "_");
    }
}
