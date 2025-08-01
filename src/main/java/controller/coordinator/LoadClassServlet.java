/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.coordinator;

import dao.coordinator.ClassManagementDAO;
import dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Class;
import model.Course;
import model.Teacher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "LoadClassServlet", urlPatterns = {"/LoadClass"})
public class LoadClassServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LoadClassServlet.class);
    
    private ClassManagementDAO classDAO;
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        classDAO = new ClassManagementDAO();
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseID = request.getParameter("courseID");
        
        // Validate courseID parameter
        if (courseID == null || courseID.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn một khóa học để xem danh sách lớp học.");
            request.getRequestDispatcher(request.getContextPath()+"/LoadCourse").forward(request, response);
            return;
        }

        try {
            // Get course information
            Course course = courseDAO.getCourseByID(courseID);
            if (course == null) {
                request.setAttribute("error", "Không tìm thấy khóa học với ID: " + courseID);
                request.getRequestDispatcher(request.getContextPath()+"/LoadCourse").forward(request, response);
                return;
            }

            // Get classes for the course
            List<Class> classList = classDAO.getClassesByCourseID(courseID);
            
            // Get all teachers for dropdown
            List<Teacher> teacherList = classDAO.getAllTeachers();
            
            // Set attributes for JSP
            request.setAttribute("currentCourse", course);
            request.setAttribute("classList", classList);
            request.setAttribute("teacherList", teacherList);
            request.setAttribute("courseID", courseID);
            
            // Generate new ClassID for add form
            String newClassID = classDAO.generateNewClassID();
            request.setAttribute("newClassID", newClassID);
            
            logger.info("Loaded {} classes for course {}", classList.size(), courseID);
            
            // Forward to JSP
            request.getRequestDispatcher("view/coordinator/course-classes.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading classes for course {}: {}", courseID, e.getMessage(), e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách lớp học: " + e.getMessage());
            request.getRequestDispatcher(request.getContextPath()+"/LoadCourse").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public void destroy() {
        if (classDAO != null) {
            classDAO.closeConnection();
        }
        if (courseDAO != null) {
            courseDAO.closeConnection();
        }
    }
}
