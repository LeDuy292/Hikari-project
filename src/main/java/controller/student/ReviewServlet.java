package controller.student;

import dao.ReviewDAO;
import dao.student.CourseEnrollmentDAO;
import model.Review;
import model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.gson.JsonObject;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private static final Logger logger = LoggerFactory.getLogger(ReviewServlet.class);
    private ReviewDAO reviewDAO;
    private CourseEnrollmentDAO enrollmentDAO;

    @Override
    public void init() throws ServletException {
        reviewDAO = new ReviewDAO();
        enrollmentDAO = new CourseEnrollmentDAO();
        logger.info("ReviewServlet initialized successfully");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject jsonResponse = new JsonObject();

        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user == null) {
            logger.warn("Unauthorized review request - user not logged in");
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Bạn cần đăng nhập để thực hiện hành động này");
            out.print(jsonResponse.toString());
            return;
        }

        String action = request.getParameter("action");
        String courseID = request.getParameter("courseID");
        // Always default to CO001 if missing or invalid
        if (courseID == null || !courseID.matches("^CO\\d{3}$")) {
            courseID = "CO001";
        }

        logger.debug("Received parameters: action={}, courseID={}", action, courseID);

        // Fix: Null check for action to avoid NullPointerException
        if (action == null || action.trim().isEmpty()) {
            logger.warn("Missing or empty action parameter in review request from user {}", user.getUserID());
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Thiếu thông tin hành động. Vui lòng thử lại.");
            out.print(jsonResponse.toString());
            return;
        }

        switch (action) {
            case "checkEligibility":
                handleCheckEligibility(user.getUserID(), courseID, jsonResponse);
                break;
            case "submitReview":
                handleSubmitReview(request, user.getUserID(), courseID, jsonResponse);
                break;
            case "updateReview":
                handleUpdateReview(request, user.getUserID(), courseID, jsonResponse);
                break;
            case "deleteReview":
                handleDeleteReview(user.getUserID(), courseID, jsonResponse);
                break;
            default:
                logger.warn("Unknown action '{}' in review request from user {}", action, user.getUserID());
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Hành động không hợp lệ");
        }

        out.print(jsonResponse.toString());
    }

    private void handleCheckEligibility(String userID, String courseID, JsonObject jsonResponse) {
        logger.info("Checking review eligibility for user {} and course {}", userID, courseID);

        try {
            // Check if user is enrolled
            boolean isEnrolled = enrollmentDAO.isUserEnrolledInCourse(userID, courseID);
            logger.debug("User {} enrollment status for course {}: {}", userID, courseID, isEnrolled);

            if (!isEnrolled) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("canReview", false);
                jsonResponse.addProperty("message", "Bạn cần đăng ký khóa học trước khi có thể đánh giá");
                jsonResponse.addProperty("completedLessons", 0);
                return;
            }

            // Check if user already reviewed
            Review existingReview = reviewDAO.getReviewByUserAndCourse(userID, courseID);
            if (existingReview != null) {
                logger.info("User {} already has a review for course {} with rating {}", userID, courseID, existingReview.getRating());
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("canReview", false);
                jsonResponse.addProperty("message", "Bạn đã đánh giá khóa học này rồi");
                jsonResponse.addProperty("completedLessons", -1); // Special value for already reviewed
                return;
            }

            // Get detailed progress information
            String progressDetails = reviewDAO.getProgressDetails(userID, courseID);
            logger.debug("Progress details for user {} and course {}: {}", userID, courseID, progressDetails);

            // Check completed lessons count
            int completedLessons = reviewDAO.getCompletedLessonsCount(userID, courseID);
            logger.debug("User {} completed {} lessons in course {}", userID, completedLessons, courseID);

            jsonResponse.addProperty("completedLessons", completedLessons);
            jsonResponse.addProperty("progressDetails", progressDetails); // For debugging

            if (completedLessons < 2) {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("canReview", false);
                jsonResponse.addProperty("message", String.format("Bạn cần hoàn thành ít nhất 2 bài học để có thể đánh giá khóa học này. Hiện tại bạn đã hoàn thành %d bài học.", completedLessons));
            } else {
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("canReview", true);
                jsonResponse.addProperty("message", String.format("Bạn có thể đánh giá khóa học này. Bạn đã hoàn thành %d bài học.", completedLessons));
            }

        } catch (Exception e) {
            logger.error("Error checking eligibility for user {} and course {}: {}", userID, courseID, e.getMessage(), e);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra khi kiểm tra điều kiện đánh giá");
        }
    }

    private void handleSubmitReview(HttpServletRequest request, String userID, String courseID, JsonObject jsonResponse) {
        logger.info("Processing new review submission from user {} for course {}", userID, courseID);

        try {
            // Check enrollment
            boolean isEnrolled = enrollmentDAO.isUserEnrolledInCourse(userID, courseID);
            if (!isEnrolled) {
                logger.warn("User {} is not enrolled in course {}", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn cần đăng ký khóa học trước khi có thể đánh giá");
                return;
            }

            // Check if user already reviewed
            Review existingReview = reviewDAO.getReviewByUserAndCourse(userID, courseID);
            if (existingReview != null) {
                logger.warn("User {} tried to submit duplicate review for course {}", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn đã đánh giá khóa học này rồi. Hãy sử dụng chức năng chỉnh sửa nếu muốn thay đổi.");
                return;
            }

            // Check completed lessons
            int completedLessons = reviewDAO.getCompletedLessonsCount(userID, courseID);
            if (completedLessons < 2) {
                logger.warn("User {} has not completed enough lessons for course {}: {}", userID, courseID, completedLessons);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", String.format("Bạn cần hoàn thành ít nhất 2 bài học để có thể đánh giá. Hiện tại bạn đã hoàn thành %d bài học.", completedLessons));
                return;
            }

            // Validate input parameters
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (ratingStr == null || ratingStr.trim().isEmpty()) {
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng chọn số sao đánh giá");
                return;
            }

            int rating;
            try {
                rating = Integer.parseInt(ratingStr);
            } catch (NumberFormatException e) {
                logger.warn("Invalid rating format from user {}: {}", userID, ratingStr);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Đánh giá không hợp lệ");
                return;
            }

            if (rating < 1 || rating > 5) {
                logger.warn("Invalid rating value from user {}: {}", userID, rating);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Đánh giá phải từ 1 đến 5 sao");
                return;
            }

            if (comment != null && comment.length() > 1000) {
                logger.warn("Comment too long from user {}: {} characters", userID, comment.length());
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Nhận xét không được vượt quá 1000 ký tự");
                return;
            }

            // Create and save review
            Review review = new Review(userID, courseID, rating, comment != null ? comment.trim() : "");
            boolean success = reviewDAO.addReview(review);

            if (success) {
                logger.info("Review successfully submitted by user {} for course {} with rating {}", userID, courseID, rating);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Cám ơn bạn đã đánh giá khóa học! Đánh giá của bạn sẽ giúp cải thiện chất lượng khóa học.");
            } else {
                logger.error("Failed to save review from user {} for course {}", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra khi lưu đánh giá. Vui lòng thử lại sau.");
            }

        } catch (Exception e) {
            logger.error("Error submitting review from user {} for course {}: {}", userID, courseID, e.getMessage(), e);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại sau.");
        }
    }

    private void handleUpdateReview(HttpServletRequest request, String userID, String courseID, JsonObject jsonResponse) {
        logger.info("Processing review update from user {} for course {}", userID, courseID);

        try {
            // Check enrollment
            boolean isEnrolled = enrollmentDAO.isUserEnrolledInCourse(userID, courseID);
            if (!isEnrolled) {
                logger.warn("User {} is not enrolled in course {}", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Bạn cần đăng ký khóa học trước khi có thể chỉnh sửa đánh giá");
                return;
            }

            // Check if user has existing review
            Review existingReview = reviewDAO.getReviewByUserAndCourse(userID, courseID);
            if (existingReview == null) {
                logger.warn("User {} tried to update non-existent review for course {}", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy đánh giá để cập nhật. Bạn có thể tạo đánh giá mới.");
                return;
            }

            // Validate input parameters
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");

            if (ratingStr == null || ratingStr.trim().isEmpty()) {
                logger.warn("Missing rating parameter in update request from user {}", userID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Vui lòng chọn số sao đánh giá");
                return;
            }

            int rating;
            try {
                rating = Integer.parseInt(ratingStr);
            } catch (NumberFormatException e) {
                logger.warn("Invalid rating format in update from user {}: {}", userID, ratingStr);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Đánh giá không hợp lệ");
                return;
            }

            if (rating < 1 || rating > 5) {
                logger.warn("Invalid rating value in update from user {}: {}", userID, rating);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Đánh giá phải từ 1 đến 5 sao");
                return;
            }

            if (comment != null && comment.length() > 1000) {
                logger.warn("Comment too long in update from user {}: {} characters", userID, comment.length());
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Nhận xét không được vượt quá 1000 ký tự");
                return;
            }

            // Update review
            Review updatedReview = new Review(userID, courseID, rating, comment != null ? comment.trim() : "");
            boolean success = reviewDAO.updateReview(updatedReview);

            if (success) {
                logger.info("Review successfully updated by user {} for course {} - old rating: {}, new rating: {}", userID, courseID, existingReview.getRating(), rating);
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đánh giá của bạn đã được cập nhật thành công!");
            } else {
                logger.error("Failed to update review from user {} for course {} in database", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra khi cập nhật đánh giá. Vui lòng thử lại sau.");
            }

        } catch (Exception e) {
            logger.error("Exception in handleUpdateReview for user {} and course {}: {}", userID, courseID, e.getMessage(), e);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra khi cập nhật đánh giá. Vui lòng thử lại sau.");
        }
    }

    private void handleDeleteReview(String userID, String courseID, JsonObject jsonResponse) {
        logger.info("Processing review deletion from user {} for course {}", userID, courseID);

        try {
            // Validate inputs
            if (userID == null || userID.trim().isEmpty()) {
                logger.warn("Invalid userID for review deletion: userID is null or empty");
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Thông tin người dùng không hợp lệ");
                return;
            }

            // Security check: Verify user owns this review
            Review existingReview = reviewDAO.getReviewByUserAndCourse(userID, courseID);
            if (existingReview == null) {
                logger.warn("User {} tried to delete non-existent review for course {}", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Không tìm thấy đánh giá để xóa");
                return;
            }

            boolean success = reviewDAO.deleteReview(userID, courseID);

            if (success) {
                logger.info("Review successfully deleted by user {} for course {} - was rated {} stars", userID, courseID, existingReview.getRating());
                jsonResponse.addProperty("success", true);
                jsonResponse.addProperty("message", "Đánh giá của bạn đã được xóa thành công!");
            } else {
                logger.error("Failed to delete review from user {} for course {} in database", userID, courseID);
                jsonResponse.addProperty("success", false);
                jsonResponse.addProperty("message", "Có lỗi xảy ra khi xóa đánh giá. Vui lòng thử lại sau.");
            }

        } catch (Exception e) {
            logger.error("Exception in handleDeleteReview for user {} and course {}: {}", userID, courseID, e.getMessage(), e);
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Có lỗi xảy ra khi xóa đánh giá: " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        if (reviewDAO != null) {
            reviewDAO.closeConnection();
        }
        if (enrollmentDAO != null) {
            enrollmentDAO.closeConnection();
        }
        logger.info("ReviewServlet destroyed - connections closed");
    }
}