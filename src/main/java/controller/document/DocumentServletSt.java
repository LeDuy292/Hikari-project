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

@WebServlet(name = "DocumentServlet", urlPatterns = {"/api/documents"})
public class DocumentServletSt extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DocumentServletSt.class.getName());
    private final DocumentDAO documentDAO = new DocumentDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        LOGGER.info("DocumentServlet API called");

        // Kiểm tra trạng thái đăng nhập
        HttpSession session = request.getSession(false); // Không tạo session mới
        UserAccount currentUser = (UserAccount) (session != null ? session.getAttribute("user") : null);
        if (currentUser == null) {
            LOGGER.info("User not logged in, redirecting to login.jsp");
            response.sendRedirect(request.getContextPath() + "/loginPage");
            return;
        }

        String userID = currentUser.getUserID();
        String userRole = currentUser.getRole(); // Giả sử UserAccount có phương thức getRole()
        if (userID == null || userID.isEmpty()) {
            LOGGER.warning("Invalid userID for currentUser: " + currentUser);
            response.sendRedirect(request.getContextPath() + "/loginPage");
            return;
        }

        // Kiểm tra loại yêu cầu (JSON hay giao diện)
        String acceptHeader = request.getHeader("Accept");
        String jsonParam = request.getParameter("json");
        boolean isJsonRequest = (acceptHeader != null && acceptHeader.contains("application/json"))
                || "true".equalsIgnoreCase(jsonParam);

        try {
            // Lấy danh sách tài liệu
            List<Document> documents = getDocuments(request, session, userID, userRole);

            if (isJsonRequest) {
                // Trả JSON cho yêu cầu API
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                // Set CORS headers
                response.setHeader("Access-Control-Allow-Origin", "*");
                response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
                response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

                // Validate documents
                List<Document> validDocuments = new ArrayList<>();
                for (Document doc : documents) {
                    if (doc != null && doc.getFileUrl() != null && !doc.getFileUrl().trim().isEmpty()) {
                        validDocuments.add(doc);
                    }
                }

                String json = gson.toJson(validDocuments);
                PrintWriter out = response.getWriter();
                out.print(json);
                out.flush();

                LOGGER.info("Successfully returned " + validDocuments.size() + " valid documents as JSON");
            } else {
                request.setAttribute("documents", documents);
                request.setAttribute("userID", userID);
                request.getRequestDispatcher("/documents").forward(request, response);
                LOGGER.info("Forwarded to documents.jsp for user: " + userID);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in DocumentServlet", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            if (isJsonRequest) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write("{\"error\":\"Lỗi tải tài liệu: " + e.getMessage().replace("\"", "\\\"") + "\"}");
            } else {
                request.setAttribute("error", "Lỗi tải tài liệu: " + e.getMessage());
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            }
        }
    }

    private List<Document> getDocuments(HttpServletRequest request, HttpSession session, String userID, String userRole) {
        String classIdParam = request.getParameter("classId");
        List<Document> documents = new ArrayList<>();

        LOGGER.info("Getting documents for user: " + userID + ", role: " + userRole + ", classId: " + classIdParam);

        // Lấy documents theo điều kiện
        if (classIdParam != null && !classIdParam.trim().isEmpty()) {
            documents = documentDAO.getDocumentByClassID(classIdParam);
            LOGGER.info("Found " + documents.size() + " documents for class: " + classIdParam);
        } else if ("Student".equalsIgnoreCase(userRole)) {
            String studentID = (String) session.getAttribute("studentID");
            if (studentID != null) {
                documents = documentDAO.getDocumentByStudent(studentID);
            } else {
                documents = documentDAO.getAllDocuments();
            }
            LOGGER.info("Found " + documents.size() + " documents for student");
        } else if ("Teacher".equalsIgnoreCase(userRole)) {
            String teacherID = (String) session.getAttribute("teacherID");
            if (teacherID != null) {
                documents = documentDAO.getDocumentByTeacher(teacherID);
            } else {
                documents = documentDAO.getAllDocuments();
            }
            LOGGER.info("Found " + documents.size() + " documents for teacher");
        } else {
            documents = documentDAO.getAllDocuments();
            LOGGER.info("Found " + documents.size() + " total documents");
        }

        return documents;
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
        return "Document Servlet for handling document requests";
    }
}