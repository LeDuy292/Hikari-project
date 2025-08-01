package controller.teacher;

import dao.TaskDAO;
import dao.TaskReviewDAO;
import dao.TestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.UserAccount;
import model.Teacher;
import model.TaskReview;
import dao.UserAccountDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/teacher/tasks")
public class TeacherTaskServlet extends HttpServlet {
    
    private final TaskDAO taskDAO = new TaskDAO();
    private final TaskReviewDAO reviewDAO = new TaskReviewDAO();
    private final TestDAO testDAO = new TestDAO();
    private final UserAccountDAO userDAO = new UserAccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check authentication
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        UserAccount currentUser = (UserAccount) session.getAttribute("user");
        if (!"Teacher".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        try {
            // Get teacher ID
            Teacher teacher = userDAO.getByUserID(currentUser.getUserID());
            if (teacher == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Teacher profile not found");
                return;
            }

            String teacherID = teacher.getTeacherID();
            
            // Get all tasks for teacher (courses and tests)
            List<Task> allTasks = taskDAO.getTasksByTeacher(teacherID);
            request.setAttribute("allTasks", allTasks);
            
            // Get task statistics
            int[] statistics = taskDAO.getTaskStatistics(teacherID);
            request.setAttribute("statistics", statistics);
            
            // Get reviews for teacher's courses and tests
            List<TaskReview> reviews = reviewDAO.getReviewsByTeacherID(teacherID);
            request.setAttribute("reviews", reviews);
            
            // Forward to JSP
            request.getRequestDispatcher("/view/teacher/task.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            updateTaskStatus(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void updateTaskStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int taskID = Integer.parseInt(request.getParameter("taskID"));
            String newStatus = request.getParameter("status");
            
            boolean success = taskDAO.updateTaskStatus(taskID, newStatus);
            
            if (success) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Task status updated successfully\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update task status\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }
} 