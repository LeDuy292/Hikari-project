package controller.document;

import com.google.gson.Gson;
import dao.document.ClassDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ClassRoom;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


@WebServlet(urlPatterns = {"/api/classes", "/documents/class/*"})
public class ClassServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ClassServlet.class.getName());
    private final ClassDAO classDAO = new ClassDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        String requestURI = request.getRequestURI();

        try {
            if (requestURI.contains("/api/classes")) {
                handleClassAPI(request, response);
            } else if ("search".equals(action)) {
                handleSearch(request, response);
            } else if (pathInfo != null && pathInfo.startsWith("/class/")) {
                handleClassDocuments(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Endpoint not found");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi xử lý yêu cầu: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }

    private void handleClassAPI(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");
        String userID = (String) session.getAttribute("userID");

        List<ClassRoom> classes;
        if (userID == null) {
            classes = classDAO.getAllClasses(); // Fallback nếu không có session
        } else if ("Student".equals(userRole)) {
            String studentID = (String) session.getAttribute("studentID");
            classes = (studentID != null) ? classDAO.getClassByStudentID(studentID) : classDAO.getAllClasses();
        } else if ("Teacher".equals(userRole)) {
            String teacherID = (String) session.getAttribute("teacherID");
            classes = (teacherID != null) ? classDAO.getClassByTeacherID(teacherID) : classDAO.getAllClasses();
        } else {
            classes = classDAO.getAllClasses();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(classes));
    }

    private void handleClassDocuments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String classId = pathInfo.substring("/class/".length());

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");
        String userID = (String) session.getAttribute("userID");

        ClassRoom classRoom = classDAO.getClassById(classId);
        if (classRoom == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy lớp học");
            return;
        }

        boolean hasAccess = false;
        if (userID == null) {
            hasAccess = true; // Cho phép truy cập công khai nếu không đăng nhập
        } else if ("Admin".equals(userRole) || "Coordinator".equals(userRole)) {
            hasAccess = true;
        } else if ("Teacher".equals(userRole)) {
            String teacherID = (String) session.getAttribute("teacherID");
            hasAccess = (teacherID != null && classRoom.getTeacherID() != null && classRoom.getTeacherID().equals(teacherID));
        } else if ("Student".equals(userRole)) {
            String studentID = (String) session.getAttribute("studentID");
            hasAccess = (studentID != null && classDAO.isStudentInClass(studentID, classId));
        }

        if (!hasAccess) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập lớp này");
            return;
        }

        request.setAttribute("classRoom", classRoom);
        request.getRequestDispatcher("/view/student/index.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String searchTerm = request.getParameter("q");
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role");

        List<ClassRoom> searchResults = classDAO.searchClassesByName(searchTerm.trim());
        if (searchResults == null) {
            searchResults = new ArrayList<>(); // Đảm bảo không trả về null
        }

        if (userRole != null) {
            List<ClassRoom> accessibleClasses = new ArrayList<>();
            if ("Student".equals(userRole)) {
                String studentID = (String) session.getAttribute("studentID");
                if (studentID != null) {
                    accessibleClasses.addAll(classDAO.getClassByStudentID(studentID));
                }
            } else if ("Teacher".equals(userRole)) {
                String teacherID = (String) session.getAttribute("teacherID");
                if (teacherID != null) {
                    accessibleClasses.addAll(classDAO.getClassByTeacherID(teacherID));
                }
            }
            // Lọc kết quả dựa trên lớp có thể truy cập
            searchResults.retainAll(accessibleClasses.isEmpty() ? new ArrayList<>() : accessibleClasses);
        }

        response.getWriter().write(gson.toJson(searchResults));
    }
}
