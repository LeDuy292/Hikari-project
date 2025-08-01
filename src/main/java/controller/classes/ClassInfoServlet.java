/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.classes;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.ClassDAO;
import dao.UserAccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ClassInfo;
import model.Teacher;
import model.UserAccount;

/**
 *
 * @author ADMIN
 */
public class ClassInfoServlet extends HttpServlet {
    private ClassDAO classDAO = new ClassDAO();
    private Gson gson = new Gson();
    private final UserAccountDAO userDAO = new UserAccountDAO();

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
         UserAccount currentUser = (UserAccount) request.getSession().getAttribute("user");
        if (currentUser == null || !"Teacher".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/loginPage");
            return;
        }

        Teacher teacher = userDAO.getByUserID(currentUser.getUserID());

        if (teacher == null) {
            response.getWriter().println("Không tìm thấy thông tin giáo viên.");
            return;
        }

        String teacherID = teacher.getTeacherID();
        System.out.println("Teacher ID: " + teacherID);


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            String classId = request.getParameter("classId");
            
            if (classId == null || classId.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Class ID is required");
                out.print(gson.toJson(errorResponse));
                return;
            }

            // Get class info
            ClassInfo classInfo = classDAO.getClassInfoById(classId);
            
            if (classInfo == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Class not found");
                out.print(gson.toJson(errorResponse));
                return;
            }

            // Verify teacher owns this class
            if (!teacherID.equals(classInfo.getTeacherID())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Access denied");
                out.print(gson.toJson(errorResponse));
                return;
            }

            out.print(gson.toJson(classInfo));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Không thể tải thông tin lớp học: " + e.getMessage());
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        }
    }
}
