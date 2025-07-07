package controller.shopping;

import dao.CourseDAO;
import dao.student.CourseInfoDAO;
import model.Course;
import model.student.CourseInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet("/courseInfo")
public class CourseInfoServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CourseInfoServlet.class);
    private CourseDAO courseDAO;
    private CourseInfoDAO courseInfoDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        courseInfoDAO = new CourseInfoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        logger.info("CourseInfoServlet: Received request for course ID: {}", idParam);

        if (idParam == null || idParam.trim().isEmpty()) {
            logger.warn("CourseInfoServlet: Missing or empty course ID parameter.");
            response.sendRedirect(request.getContextPath() + "/courses?error=invalid_id");
            return;
        }

        try {
            String courseId = idParam; // Use String directly, no parsing
            logger.debug("CourseInfoServlet: Attempting to retrieve Course and CourseInfo for courseId: {}", courseId);
            
            Course course = courseDAO.getCourseByID(courseId); // Pass String directly
            CourseInfo courseInfo = courseInfoDAO.getCourseInfoByCourseId(courseId); // Pass String directly

            if (course != null && courseInfo != null) {
                logger.info("CourseInfoServlet: Successfully retrieved course and courseInfo for courseId: {}", courseId);
                request.setAttribute("course", course);
                request.setAttribute("courseInfo", courseInfo);
                request.getRequestDispatcher("/view/student/courseInfo.jsp").forward(request, response);
            } else {
                logger.warn("CourseInfoServlet: Course or CourseInfo not found for courseId: {}. Course: {}, CourseInfo: {}", courseId, course, courseInfo);
                response.sendRedirect(request.getContextPath() + "/courses?error=no_data");
            }
        } catch (Exception e) { // Catch generic Exception for robustness
            logger.error("CourseInfoServlet: Error processing course info for id: {}. Exception: {}", idParam, e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving course information");
        }
    }
    
    @Override
    public void destroy() {
        if (courseDAO != null) courseDAO.closeConnection();
        // CourseInfoDAO does not manage its own connection, it gets it from DBContext().getConnection()
        logger.info("CourseInfoServlet destroyed. CourseDAO connection closed.");
    }
}
