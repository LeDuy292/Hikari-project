package controller.classes;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.AssignmentDAO;
import dao.ClassDAO;
import dao.TestDAO;
import dao.UserAccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.ClassInfo;
import model.Teacher;
import model.UserAccount;

/**
 *
 * @author ADMIN
 */
public class ClassManagementServlet extends HttpServlet {

    private final ClassDAO classDAO = new ClassDAO();
    private final Gson gson = new Gson();
    private final UserAccountDAO userDAO = new UserAccountDAO();
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ClassManagementServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ClassManagementServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

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
        try {
            List<ClassInfo> classes;

                classes = classDAO.getClassesByTeacher(teacherID);
            
    
            request.setAttribute("classes", classes);
            request.setAttribute("totalClasses", classes.size());
            request.getRequestDispatcher("/view/teacher/manageClasses.jsp").forward(request, response);
        } catch (ServletException | IOException e) {
            request.setAttribute("errorMessage", "Không thể tải danh sách lớp học: " + e.getMessage());
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
