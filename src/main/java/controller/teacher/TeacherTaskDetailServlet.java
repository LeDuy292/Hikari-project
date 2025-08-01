package controller.teacher;

import dao.TaskDAO;
import dao.UserAccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.UserAccount;
import model.Teacher;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.annotation.WebServlet;

@WebServlet("/teacher/tasks/detail/*")
public class TeacherTaskDetailServlet extends HttpServlet {
    
    private final TaskDAO taskDAO = new TaskDAO();
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
            // Extract task ID from URL path
            String pathInfo = request.getPathInfo();
            
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Task ID is required");
                return;
            }
            
            String taskIdStr = pathInfo.substring(1); // Remove leading slash
            int taskID = Integer.parseInt(taskIdStr);
            
                               // Get task details
                   Task task = taskDAO.getTaskById(taskID);
                   if (task == null) {
                       response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found");
                       return;
                   }
                   
                   // Debug: Print task details
                   System.out.println("=== TASK DEBUG INFO ===");
                   System.out.println("Task ID: " + task.getTaskID());
                   System.out.println("Course ID: " + task.getCourseID());
                   System.out.println("Test ID: " + task.getTestID());
                   System.out.println("Status: " + task.getStatus());
                   System.out.println("Course Name: " + task.getCourseName());
                   System.out.println("=======================");
            
            // Verify task belongs to current teacher
            Teacher teacher = userDAO.getByUserID(currentUser.getUserID());
            if (teacher == null || !teacher.getTeacherID().equals(task.getTeacherID())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
            
                        request.setAttribute("task", task);
            

            
            // Always show task detail page
            request.getRequestDispatcher("/view/teacher/taskdetail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid task ID format");
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