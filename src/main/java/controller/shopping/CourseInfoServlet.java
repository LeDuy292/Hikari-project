package controller.shopping;

import dao.CourseDAO;
import dao.ReviewDAO;
import dao.student.CourseInfoDAO;
import dao.student.CourseEnrollmentDAO;
import model.Course;
import model.Review;
import model.UserAccount;
import model.student.CourseInfo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@WebServlet("/courseInfo")
public class CourseInfoServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(CourseInfoServlet.class);
    private CourseDAO courseDAO;
    private CourseInfoDAO courseInfoDAO;
    private ReviewDAO reviewDAO;
    private CourseEnrollmentDAO enrollmentDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        courseInfoDAO = new CourseInfoDAO();
        reviewDAO = new ReviewDAO();
        enrollmentDAO = new CourseEnrollmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thêm headers để tránh cache
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String idParam = request.getParameter("id");
        logger.info("CourseInfoServlet: Received request for course ID: {} from URL: {}",
                idParam, request.getRequestURL() + "?" + request.getQueryString());

        if (idParam == null || idParam.trim().isEmpty()) {
            logger.warn("CourseInfoServlet: Missing or empty course ID parameter.");
            response.sendRedirect(request.getContextPath() + "/courses?error=invalid_id");
            return;
        }

        try {
            String courseId = idParam.trim();
            logger.debug("CourseInfoServlet: Processing courseId: '{}'", courseId);

            // Validate courseID format
            if (!courseId.matches("^CO\\d{3}$")) {
                logger.warn("CourseInfoServlet: Invalid courseID format: {}", courseId);
                response.sendRedirect(request.getContextPath() + "/courses?error=invalid_format");
                return;
            }

            // Set timeout for long-running operations
            long startTime = System.currentTimeMillis();

            Course course = courseDAO.getCourseByID(courseId);
            logger.debug("Course fetch took: {}ms", System.currentTimeMillis() - startTime);

            if (course != null && course.getCourseID() != null && !course.getCourseID().trim().isEmpty()) {
                logger.info("Course retrieved: ID={}, Title={}", course.getCourseID(), course.getTitle());
            } else {
                logger.warn("Course retrieved is null or has invalid courseID for courseId: {}", courseId);
            }

            CourseInfo courseInfo = courseInfoDAO.getCourseInfoByCourseId(courseId);
            logger.debug("CourseInfo fetch took: {}ms", System.currentTimeMillis() - startTime);

            if (course != null && courseInfo != null) {
                logger.info("CourseInfoServlet: Successfully retrieved course and courseInfo for courseId: {}", courseId);

                // Get reviews with timeout protection
                List<Review> reviews = null;
                double averageRating = 0.0;
                int reviewCount = 0;

                try {
                    long reviewStartTime = System.currentTimeMillis();
                    reviews = reviewDAO.getReviewsByCourseID(courseId);
                    logger.debug("Reviews fetch took: {}ms", System.currentTimeMillis() - reviewStartTime);

                    if (reviews != null && !reviews.isEmpty()) {
                        averageRating = reviewDAO.getAverageRating(courseId);
                        reviewCount = reviews.size(); // Use list size instead of separate query
                    }
                } catch (Exception e) {
                    logger.error("Error fetching reviews for course {}: {}", courseId, e.getMessage());
                    reviews = new ArrayList<>(); // Fallback to empty list
                }

                // Check if current user can review
                HttpSession session = request.getSession();
                UserAccount user = (UserAccount) session.getAttribute("user");
                boolean canReview = false;
                boolean isEnrolled = false;

                if (user != null) {
                    try {
                        isEnrolled = enrollmentDAO.isUserEnrolledInCourse(user.getUserID(), courseId);
                        canReview = reviewDAO.canUserReview(user.getUserID(), courseId);

                        logger.info("User {} enrollment status for course {}: enrolled={}, canReview={}",
                                user.getUserID(), courseId, isEnrolled, canReview);
                    } catch (Exception e) {
                        logger.error("Error checking user enrollment/review status: {}", e.getMessage());
                        // Continue with defaults (false)
                    }
                } else {
                    logger.info("No user in session - guest access for course {}", courseId);
                }

                // Set attributes with null checks
                request.setAttribute("course", course);
                request.setAttribute("courseInfo", courseInfo);
                request.setAttribute("reviews", reviews != null ? reviews : new ArrayList<>());
                request.setAttribute("averageRating", averageRating);
                request.setAttribute("reviewCount", reviewCount);
                request.setAttribute("canReview", canReview);
                request.setAttribute("isEnrolled", isEnrolled);

                logger.debug("Total request processing time: {}ms", System.currentTimeMillis() - startTime);

                request.getRequestDispatcher("/view/student/courseInfo.jsp").forward(request, response);
            } else {
                logger.warn("CourseInfoServlet: Course or CourseInfo not found for courseId: {}. Course: {}, CourseInfo: {}",
                        courseId, course != null, courseInfo != null);
                response.sendRedirect(request.getContextPath() + "/courses?error=course_not_found&id=" + courseId);
            }
        } catch (Exception e) {
            logger.error("CourseInfoServlet: Error processing course info for id: {}. Exception: {}", idParam, e.getMessage(), e);

            // Check if response is already committed
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/courses?error=server_error");
            }
        }
    }

    @Override
    public void destroy() {
        if (courseDAO != null) {
            courseDAO.closeConnection();
        }
        if (reviewDAO != null) {
            reviewDAO.closeConnection();
        }
        if (enrollmentDAO != null) {
            enrollmentDAO.closeConnection();
        }
        logger.info("CourseInfoServlet destroyed. DAO connections closed.");
    }
}
