package controller.shopping;

import dao.student.CourseEnrollmentDAO;
import model.UserAccount;
import model.Course;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.List;
import model.student.CourseEnrollment;

@WebServlet("/profile/myCourses")
public class ProfileMyCoursesServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(ProfileMyCoursesServlet.class);
    private CourseEnrollmentDAO courseEnrollmentDAO;

    @Override
    public void init() throws ServletException {
        try {
            courseEnrollmentDAO = new CourseEnrollmentDAO();
            logger.info("ProfileMyCoursesServlet initialized successfully.");
        } catch (Exception e) {
            logger.error("Failed to initialize ProfileMyCoursesServlet: {}", e.getMessage(), e);
            throw new ServletException("Initialization failed due to DAO error.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false); // Don't create session if it doesn't exist
        UserAccount user = session != null ? (UserAccount) session.getAttribute("user") : null;

        if (user == null) {
            logger.warn("ProfileMyCoursesServlet: User not logged in. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        String userID = user.getUserID();
        logger.info("ProfileMyCoursesServlet: Fetching enrolled courses for user: {}", userID);

        try {
            List<Course> enrolledCourses = courseEnrollmentDAO.getEnrolledCoursesByUserID(userID);
            if (enrolledCourses == null) {
                enrolledCourses = List.of(); // Default to empty list to avoid null
            }
            
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("category", "my-courses");
            request.setAttribute("pageTitle", "Khóa học của tôi");
            request.setAttribute("totalCourses", enrolledCourses.size());
            
            logger.info("ProfileMyCoursesServlet: Found {} enrolled courses for user {}", enrolledCourses.size(), userID);
            request.getRequestDispatcher("/view/student/myCourses.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error in ProfileMyCoursesServlet for user {}: {}", userID, e.getMessage(), e);
            request.setAttribute("error", "Không thể tải danh sách khóa học. Vui lòng thử lại.");
            request.getRequestDispatcher("/view/student/myCourses.jsp").forward(request, response);
        }
    }

    @Override
    public void destroy() {
        if (courseEnrollmentDAO != null) {
            try {
                courseEnrollmentDAO.closeConnection();
                logger.info("ProfileMyCoursesServlet connection closed.");
            } catch (Exception e) {
                logger.error("Failed to close connection: {}", e.getMessage(), e);
            }
        }
        logger.info("ProfileMyCoursesServlet destroyed.");
    }
}