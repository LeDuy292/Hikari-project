package controller.document;

import com.google.gson.Gson;
import dao.document.DocumentDAO;
import model.Document;
import model.UserAccount;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DocumentServletSt", urlPatterns = {"/api/documents", "/api/documents/*"})
public class DocumentServletSt extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DocumentServletSt.class.getName());
    private final DocumentDAO documentDAO = new DocumentDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("DocumentServletSt API called with URI: " + request.getRequestURI());

        // Set CORS headers first
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

        // Kiểm tra session (nhưng không redirect nếu không có)
        HttpSession session = request.getSession(false);
        UserAccount currentUser = (session != null) ? (UserAccount) session.getAttribute("user") : null;
        
        String userID = null;
        String userRole = "Guest"; // Default role
        String studentID = null;
        String teacherID = null;

        if (currentUser != null) {
            userID = currentUser.getUserID();
            userRole = currentUser.getRole();
            if (session != null) {
                studentID = (String) session.getAttribute("studentID");
                teacherID = (String) session.getAttribute("teacherID");
            }
            LOGGER.info("User authenticated: " + userID + " with role: " + userRole);
        } else {
            LOGGER.info("No authenticated user, serving public documents");
        }

        try {
            // Lấy danh sách tài liệu
            List<Document> documents = getDocuments(request, userID, userRole, studentID, teacherID);

            // Luôn trả JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Validate và filter documents
            List<Document> validDocuments = new ArrayList<>();
            for (Document doc : documents) {
                if (doc != null && doc.getFileUrl() != null && !doc.getFileUrl().trim().isEmpty()) {
                    validDocuments.add(doc);
                }
            }

            LOGGER.info("Returning " + validDocuments.size() + " valid documents");

            String json = gson.toJson(validDocuments);
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DocumentServletSt", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            String errorJson = "{\"error\":\"Lỗi tải tài liệu: " + e.getMessage().replace("\"", "\\\"") + "\"}";
            response.getWriter().write(errorJson);
        }
    }

    private List<Document> getDocuments(HttpServletRequest request, String userID, String userRole, String studentID, String teacherID) {
        String classIdParam = request.getParameter("classId");
        List<Document> documents = new ArrayList<>();

        LOGGER.info("Getting documents - userID: " + userID + ", role: " + userRole + ", classId: " + classIdParam);

        try {
            if (classIdParam != null && !classIdParam.trim().isEmpty()) {
                // Lấy documents theo class
                documents = documentDAO.getDocumentByClassID(classIdParam);
                LOGGER.info("Found " + documents.size() + " documents for class: " + classIdParam);
            } else if ("Student".equalsIgnoreCase(userRole) && studentID != null) {
                // Lấy documents cho student
                documents = documentDAO.getDocumentByStudent(studentID);
                LOGGER.info("Found " + documents.size() + " documents for student: " + studentID);
            } else if ("Teacher".equalsIgnoreCase(userRole) && teacherID != null) {
                // Lấy documents cho teacher
                documents = documentDAO.getDocumentByTeacher(teacherID);
                LOGGER.info("Found " + documents.size() + " documents for teacher: " + teacherID);
            } else {
                // Lấy tất cả documents (cho guest hoặc admin)
                documents = documentDAO.getAllDocuments();
                LOGGER.info("Found " + documents.size() + " total documents");
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error fetching documents from database, using sample data", e);
            documents = createSampleDocuments();
        }

        return documents;
    }

    private List<Document> createSampleDocuments() {
        List<Document> sampleDocs = new ArrayList<>();
        
        sampleDocs.add(new Document(1, 0, "CL001", "Hiragana cơ bản", 
            "Tài liệu học bảng chữ cái Hiragana với các bài tập thực hành", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/sample/hiragana_basic.pdf", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/images/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));
            
        sampleDocs.add(new Document(2, 0, "CL001", "Katakana nâng cao", 
            "Tài liệu học bảng chữ cái Katakana với từ vựng ngoại lai", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/sample/katakana_advanced.pdf", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/images/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));
            
        sampleDocs.add(new Document(3, 0, null, "Số đếm tiếng Nhật", 
            "Học cách đếm số từ 1-100 và ứng dụng thực tế", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/sample/numbers_basic.pdf", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/images/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));
            
        sampleDocs.add(new Document(4, 0, "CL003", "Ngữ pháp N4", 
            "Các cấu trúc ngữ pháp cơ bản của trình độ N4", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/sample/grammar_n4.pdf", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/images/Japanese-N4.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T002"));
            
        sampleDocs.add(new Document(5, 0, null, "Kanji N5", 
            "50 chữ Kanji đầu tiên dành cho người mới học", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/documents/sample/kanji_n5.pdf", 
            "https://projectswp1.s3.ap-southeast-2.amazonaws.com/images/Japanese-N5.jpg", 
            new java.sql.Timestamp(System.currentTimeMillis()), "T001"));

        LOGGER.info("Created " + sampleDocs.size() + " sample documents");
        return sampleDocs;
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    @Override
    public String getServletInfo() {
        return "Document API Servlet for handling document requests";
    }
}
