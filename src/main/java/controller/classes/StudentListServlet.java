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
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Progress;
import model.StudentInfo;
import model.Teacher;
import model.UserAccount;

/**
 *
 * @author ADMIN
 */
public class StudentListServlet extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/loginPage");
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
            String classId = request.getParameter("classId");
            String search = request.getParameter("search");
            
            if (classId == null || classId.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                JsonObject errorResponse = new JsonObject();
                errorResponse.addProperty("success", false);
                errorResponse.addProperty("message", "Class ID is required");
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

            // Get all students (no server-side pagination)
            List<StudentInfo> students;
            if (search != null && !search.trim().isEmpty()) {
                students = studentDAO.searchStudentsByClass(classId, search.trim());
            } else {
                students = studentDAO.getStudentsByClass(classId);
            }

            // Enhance student data with progress info
            for (StudentInfo student : students) {
                // Get progress data
                List<Progress> progressList = progressDAO.getProgressByStudentAndClass(student.getStudentID(), classId);
                student.setProgress(progressList);
                
                // Calculate progress statistics
                long completedLessons = progressList.stream()
                    .filter(p -> "complete".equals(p.getCompletionStatus()))
                    .count();
                student.setCompletedLessons((int) completedLessons);
                student.setTotalLessons(progressList.size());
                
                // Calculate progress percentage
                if (progressList.size() > 0) {
                    student.setProgressPercentage((double) completedLessons / progressList.size() * 100);
                } else {
                    student.setProgressPercentage(0.0);
                }
                
                // Calculate average score
                double averageScore = progressDAO.getAverageScoreByStudent(student.getStudentID());
                student.setAverageScore(averageScore);
            }

            // Create response JSON
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.add("students", gson.toJsonTree(students));
            jsonResponse.addProperty("success", true);

            out.print(gson.toJson(jsonResponse));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            
            JsonObject errorResponse = new JsonObject();
            errorResponse.addProperty("success", false);
            errorResponse.addProperty("message", "Không thể tải danh sách học sinh: " + e.getMessage());
            
            try (PrintWriter out = response.getWriter()) {
                out.print(gson.toJson(errorResponse));
            }
        }
    }
}
