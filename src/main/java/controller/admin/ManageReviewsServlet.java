package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Review;
import model.UserAccount;
import service.ReviewService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet("/admin/reviews")
public class ManageReviewsServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();
    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd")
            .create();
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(ManageReviewsServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("view".equals(action)) {
                handleViewReview(req, resp);
            } else if ("byCourse".equals(action)) {
                handleReviewsByCourse(req, resp);
            } else {
                handleListReviews(req, resp);
            }
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error in doGet", e);
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    private void handleViewReview(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\": \"ID đánh giá không hợp lệ\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Review review = reviewService.getReviewById(id);

            if (review == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\": \"Không tìm thấy đánh giá\"}");
                return;
            }

            // Return JSON response for AJAX
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            String jsonResponse = gson.toJson(review);
            resp.getWriter().write(jsonResponse);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\": \"ID đánh giá không hợp lệ\"}");
        }
    }

    private void handleReviewsByCourse(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String courseID = req.getParameter("courseID");
        if (courseID == null || courseID.trim().isEmpty()) {
            throw new IllegalArgumentException("ID khóa học không hợp lệ");
        }
        List<Review> reviews = reviewService.getReviewsByCourse(courseID);
        req.setAttribute("reviews", reviews);
        req.setAttribute("courseID", courseID);
        req.getRequestDispatcher("/view/admin/manageReviews.jsp").forward(req, resp);
    }

    private void handleListReviews(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        // Get filter parameters
        String courseID = req.getParameter("courseID");
        String rating = req.getParameter("rating");
        String search = req.getParameter("search");
        String reviewDateFrom = req.getParameter("reviewDateFrom");
        String reviewDateTo = req.getParameter("reviewDateTo");
        String status = req.getParameter("status");
        String pageStr = req.getParameter("page");

        int page = 1;
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        int pageSize = 10;
        List<Review> reviews = reviewService.getReviewsWithFilters(
                courseID, rating, search, reviewDateFrom, reviewDateTo, status, page, pageSize);
        int totalReviews = reviewService.countReviewsWithFilters(
                courseID, rating, search, reviewDateFrom, reviewDateTo, status);

        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        req.setAttribute("reviews", reviews);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalReviews", totalReviews);
        req.setAttribute("courseID", courseID);
        req.setAttribute("rating", rating);
        req.setAttribute("search", search);
        req.setAttribute("reviewDateFrom", reviewDateFrom);
        req.setAttribute("reviewDateTo", reviewDateTo);
        req.setAttribute("status", status);

        // Assuming courses list is available from another service
        // req.setAttribute("courses", courseService.getAllCourses());

        req.getRequestDispatcher("/view/admin/manageReviews.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/reviews?error=" + URLEncoder.encode("Hành động không hợp lệ", "UTF-8"));
            return;
        }

        try {
            switch (action) {
                case "edit":
                    handleEditReview(req, resp);
                    break;
                case "block":
                    handleBlockReview(req, resp);
                    break;
                case "unblock":
                    handleUnblockReview(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/reviews?error=" + URLEncoder.encode("Hành động không hợp lệ", "UTF-8"));
            }
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error in doPost", e);
            resp.sendRedirect(req.getContextPath() + "/admin/reviews?error=" + URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }

    private void handleEditReview(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("reviewId");
        String ratingStr = req.getParameter("rating");
        String reviewText = req.getParameter("reviewText");

        // Validate inputs
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
        if (ratingStr == null || ratingStr.trim().isEmpty()) {
            throw new IllegalArgumentException("Điểm đánh giá không được để trống");
        }
        if (reviewText == null || reviewText.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung đánh giá không được để trống");
        }

        int id;
        int rating;
        try {
            id = Integer.parseInt(idStr);
            rating = Integer.parseInt(ratingStr);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("ID hoặc điểm đánh giá không hợp lệ");
        }

        Review review = new Review();
        review.setId(id);
        review.setRating(rating);
        review.setReviewText(reviewText.trim());

        reviewService.updateReview(review);
        resp.sendRedirect(req.getContextPath() + "/admin/reviews?message=" + URLEncoder.encode("Cập nhật đánh giá thành công", "UTF-8"));
    }

    private void handleBlockReview(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("reviewId");
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }

        try {
            int id = Integer.parseInt(idStr);
            reviewService.blockReview(id);
            resp.sendRedirect(req.getContextPath() + "/admin/reviews?message=" + URLEncoder.encode("Chặn đánh giá thành công", "UTF-8"));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
    }

    private void handleUnblockReview(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("reviewId");
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }

        try {
            int id = Integer.parseInt(idStr);
            reviewService.unblockReview(id);
            resp.sendRedirect(req.getContextPath() + "/admin/reviews?message=" + URLEncoder.encode("Bỏ chặn đánh giá thành công", "UTF-8"));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
    }
}