package service;

import dao.admin.ReviewDAO;
import model.admin.Review;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

public class ReviewService {
    private static final Logger LOGGER = Logger.getLogger(ReviewService.class.getName());
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public List<Review> getAllReviews() throws SQLException {
        return reviewDAO.getAllReviews();
    }

    public Review getReviewById(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
        Review review = reviewDAO.getReviewById(id);
        if (review == null) {
            throw new IllegalArgumentException("Không tìm thấy đánh giá");
        }
        return review;
    }

    public void updateReview(Review review) throws SQLException {
        validateReview(review);
        reviewDAO.updateReview(review);
    }

    public void blockReview(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
        reviewDAO.blockReview(id);
    }

    public void unblockReview(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
        reviewDAO.unblockReview(id);
    }

    public List<Review> getReviewsByCourse(String courseID) throws SQLException {
        if (courseID == null || courseID.trim().isEmpty()) {
            throw new IllegalArgumentException("ID khóa học không hợp lệ");
        }
        return reviewDAO.getReviewsByCourse(courseID);
    }

    public List<Review> getReviewsWithFilters(String courseID, String rating, String search, 
            String reviewDateFrom, String reviewDateTo, String status, int page, int pageSize) throws SQLException {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        int offset = (page - 1) * pageSize;
        return reviewDAO.getReviewsWithFilters(courseID, rating, search, reviewDateFrom, reviewDateTo, status, offset, pageSize);
    }

    public int countReviewsWithFilters(String courseID, String rating, String search, 
            String reviewDateFrom, String reviewDateTo, String status) throws SQLException {
        return reviewDAO.countReviewsWithFilters(courseID, rating, search, reviewDateFrom, reviewDateTo, status);
    }

    private void validateReview(Review review) {
        if (review == null) {
            throw new IllegalArgumentException("Dữ liệu đánh giá không hợp lệ");
        }
        if (review.getId() <= 0) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
        if (review.getRating() < 1 || review.getRating() > 5) {
            throw new IllegalArgumentException("Điểm đánh giá phải từ 1 đến 5");
        }
        if (review.getReviewText() == null || review.getReviewText().trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung đánh giá không được để trống");
        }
    }
}