/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.classes;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.ClassDAO;
import dao.ProgressDAO;
import dao.StudentDAO;
import dao.UserAccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Progress;
import model.StudentInfo;
import model.StudentProfile;
import model.Teacher;
import model.UserAccount;

/**
 *
 * @author ADMIN
 */
public class StudentProfileServlet extends HttpServlet {
    private ClassDAO classDAO = new ClassDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private ProgressDAO progressDAO = new ProgressDAO();
    private Gson gson = new Gson();
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

        String teacherId = teacher.getTeacherID();
        System.out.println("Teacher ID: " + teacherId);


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            String studentId = request.getParameter("studentId");
            String classId = request.getParameter("classId");
            
            if (studentId == null || classId == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Student ID and Class ID are required");
                out.print(gson.toJson(errorResponse));
                return;
            }

            // Verify teacher owns this class
            if (!classDAO.isTeacherOfClass(teacherId, classId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Access denied");
                out.print(gson.toJson(errorResponse));
                return;
            }

            // Get student profile
            StudentProfile profile = new StudentProfile();
            
            // Basic student info
            StudentInfo studentInfo = studentDAO.getStudentById(studentId);
            if (studentInfo == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Student not found");
                out.print(gson.toJson(errorResponse));
                return;
            }
            
            profile.setStudentID(studentInfo.getStudentID());
            profile.setFullName(studentInfo.getFullName());
            profile.setEmail(studentInfo.getEmail());
            profile.setPhone(studentInfo.getPhone());
            profile.setProfilePicture(studentInfo.getProfilePicture());
            profile.setEnrollmentDate(studentInfo.getEnrollmentDate());

            // Progress data
            List<Progress> progressList = progressDAO.getProgressByStudent(studentId);
            profile.setProgress(progressList);
            
            // Calculate progress statistics
            long completedLessons = progressList.stream()
                .filter(p -> "complete".equals(p.getCompletionStatus()))
                .count();
            profile.setCompletedLessons((int) completedLessons);
            profile.setTotalLessons(progressList.size());
            out.print(gson.toJson(profile));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Không thể tải thông tin học sinh: " + e.getMessage());
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        }
    }
}
