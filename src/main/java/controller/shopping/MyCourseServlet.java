package controller.shopping;

import dao.student.CourseEnrollmentDAO;
import model.Course;
import model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet("/myCourses")
public class MyCourseServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(MyCourseServlet.class);
    private CourseEnrollmentDAO courseEnrollmentDAO;

    @Override
    public void init() throws ServletException {
        courseEnrollmentDAO = new CourseEnrollmentDAO();
        logger.info("MyCourseServlet initialized.");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user == null) {
            logger.warn("MyCourseServlet: User not logged in. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        String userID = user.getUserID();
        logger.info("MyCourseServlet: Fetching enrolled courses for user: {}", userID);

        try {
            // Lấy danh sách khóa học đã đăng ký
            List<Course> enrolledCourses = courseEnrollmentDAO.getEnrolledCoursesByUserID(userID);
            
            // Set attributes cho JSP
            request.setAttribute("courses", enrolledCourses);
            request.setAttribute("category", "my-courses");
            request.setAttribute("pageTitle", "Khóa học của tôi");
            request.setAttribute("totalCourses", enrolledCourses.size());
            
            logger.info("MyCourseServlet: Found {} enrolled courses for user {}", enrolledCourses.size(), userID);
            
            // Forward đến trang online.jsp
            request.getRequestDispatcher("/view/student/online.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error in MyCourseServlet for user {}: {}", userID, e.getMessage(), e);
            request.setAttribute("error", "Không thể tải danh sách khóa học. Vui lòng thử lại.");
            request.getRequestDispatcher("/view/student/online.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (courseEnrollmentDAO != null) {
            courseEnrollmentDAO.closeConnection();
        }
        logger.info("MyCourseServlet destroyed.");
    }
}
