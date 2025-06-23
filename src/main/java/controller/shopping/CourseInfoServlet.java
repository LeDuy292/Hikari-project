package controller.shopping;

import dao.CourseDAO;
import dao.CourseInfoDAO;
import model.Course;
import model.CourseInfo;
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
        if (idParam == null || idParam.trim().isEmpty()) {
            logger.warn("Missing or empty course ID parameter");
            response.sendRedirect(request.getContextPath() + "/courses?error=invalid_id");
            return;
        }

        try {
            int courseId = Integer.parseInt(idParam);
            logger.debug("Processing courseId: {}", courseId);
            Course course = courseDAO.getCourseById(courseId);
            CourseInfo courseInfo = courseInfoDAO.getCourseInfoByCourseId(courseId);

            logger.debug("Course: {}, CourseInfo: {}", course, courseInfo);
            if (course != null && courseInfo != null) {
                logger.info("Successfully retrieved course and courseInfo for courseId: {}", courseId);
                request.setAttribute("course", course);
                request.setAttribute("courseInfo", courseInfo);
                request.getRequestDispatcher("/view/student/courseInfo.jsp").forward(request, response);
            } else {
                logger.warn("Course or CourseInfo not found for courseId: {}", courseId);
                response.sendRedirect(request.getContextPath() + "/courses?error=no_data");
            }
        } catch (NumberFormatException e) {
            logger.warn("Invalid course ID format: {}", idParam);
            response.sendRedirect(request.getContextPath() + "/courses?error=invalid_id");
        } catch (Exception e) {
            logger.error("Error processing course info for id: {}", idParam, e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving course information");
        }
    }
}