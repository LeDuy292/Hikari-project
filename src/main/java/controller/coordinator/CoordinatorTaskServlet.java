package controller.coordinator;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


import dao.*;
import dao.coordinator.TaskDAO;
import model.coordinator.Task;
import model.coordinator.TaskReview;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CoordinatorTaskServlet", urlPatterns = {"/CoordinatorTask"})
public class CoordinatorTaskServlet extends HttpServlet {
    
    private TaskDAO taskDAO;
    private TeacherDAO teacherDAO;
    private CourseDAO courseDAO;
    private TestDAO testDAO;
    
    @Override
    public void init() throws ServletException {
        taskDAO = new TaskDAO();
        teacherDAO = new TeacherDAO();
        courseDAO = new CourseDAO();
        testDAO = new TestDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String coordinatorID = (String) session.getAttribute("userId");
        String userRole = (String) session.getAttribute("role");
        
        // Kiểm tra quyền truy cập
        if (coordinatorID == null || !"Coordinator".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/loginPage");
            return;
        }
        
        // Lấy thống kê
        Map<String, Integer> statistics = taskDAO.getTaskStatistics(coordinatorID);
        request.setAttribute("statistics", statistics);
        
        // Lấy danh sách nhiệm vụ
        List<Task> allTasks = taskDAO.getAllTasks(coordinatorID);
        request.setAttribute("allTasks", allTasks);
        
        // Lấy danh sách đánh giá
        List<TaskReview> reviews = taskDAO.getTaskReviews();
        request.setAttribute("reviews", reviews);
        
        // Lấy dữ liệu cho form tạo nhiệm vụ
        request.setAttribute("teachers", teacherDAO.getAllTeachers());
        request.setAttribute("courses", courseDAO.getAll());
        request.setAttribute("tests", testDAO.getAllActiveTests());
        
        request.getRequestDispatcher("/view/coordinator/task-management.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        String coordinatorID = (String) session.getAttribute("userId");
        
        if ("create".equals(action)) {
            handleCreateTask(request, response, coordinatorID);
        } else if ("approve".equals(action)) {
            handleApproveTask(request, response);
        } else if ("reject".equals(action)) {
            handleRejectTask(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
        }
    }
    
    private void handleCreateTask(HttpServletRequest request, HttpServletResponse response, 
                                String coordinatorID) throws IOException, ServletException {
        // Set character encoding for request
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Get form parameters
        String teacherID = request.getParameter("teacherID");
        String taskType = request.getParameter("taskType");
        String description = request.getParameter("description");
        String deadlineStr = request.getParameter("deadline");
        
        // Validate required fields
        if (teacherID == null || teacherID.trim().isEmpty() || 
            taskType == null || taskType.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            deadlineStr == null || deadlineStr.trim().isEmpty()) {
            
            request.getSession().setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc!");
            response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
            return;
        }
        
        try {
            // Parse and validate deadline
            Date deadline = Date.valueOf(deadlineStr);
            Date currentDate = new Date(System.currentTimeMillis());
            
            if (deadline.before(currentDate)) {
                request.getSession().setAttribute("errorMessage", "Thời hạn phải lớn hơn ngày hiện tại!");
                response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
                return;
            }
            
            // Process task type specific fields
            String courseID = null;
            Integer testID = null;
            
            if ("course".equals(taskType)) {
                courseID = request.getParameter("courseID");
                if (courseID == null || courseID.trim().isEmpty()) {
                    request.getSession().setAttribute("errorMessage", "Vui lòng chọn khóa học!");
                    response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
                    return;
                }
            } else if ("test".equals(taskType)) {
                try {
                    testID = Integer.parseInt(request.getParameter("testID"));
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("errorMessage", "ID bài test không hợp lệ!");
                    response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
                    return;
                }
            } else {
                request.getSession().setAttribute("errorMessage", "Loại nhiệm vụ không hợp lệ!");
                response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
                return;
            }
            
            // Create and save the task
            Task task = new Task(coordinatorID, teacherID, courseID, testID, deadline, description.trim());
            
            if (taskDAO.createTask(task)) {
                request.getSession().setAttribute("successMessage", "Tạo nhiệm vụ thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi tạo nhiệm vụ. Vui lòng thử lại!");
            }
            
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Ngày tháng không hợp lệ. Vui lòng kiểm tra lại!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
    }
    
    private void handleApproveTask(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            
            if (taskDAO.approveTask(taskId)) {
                request.getSession().setAttribute("successMessage", "Phê duyệt nhiệm vụ thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi phê duyệt!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
        
        response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
    }
    
    private void handleRejectTask(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String reason = request.getParameter("rejectReason");
            
            if (taskDAO.rejectTask(taskId, reason)) {
                request.getSession().setAttribute("successMessage", "Từ chối nhiệm vụ thành công!");
            } else {
                request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi từ chối!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Dữ liệu không hợp lệ!");
        }
        
        response.sendRedirect(request.getContextPath() + "/CoordinatorTask");
    }
    
    @Override
    public void destroy() {
        if (taskDAO != null) {
            taskDAO.closeConnection();
        }
        if (teacherDAO != null) {
            teacherDAO.closeConnection();
        }
        if (courseDAO != null) {
            courseDAO.closeConnection();
        }
    }
}

