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
        return reviewDAO.getReviewById(id);
    }

    public void updateReview(Review review) throws SQLException {
        if (review == null || review.getId() <= 0) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
        if (review.getRating() < 1 || review.getRating() > 5) {
            throw new IllegalArgumentException("Điểm đánh giá phải từ 1 đến 5");
        }
        reviewDAO.updateReview(review);
    }

    public void deleteReview(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID đánh giá không hợp lệ");
        }
        reviewDAO.deleteReview(id);
    }

    public List<Review> getReviewsByCourse(String courseID) throws SQLException {
        if (courseID == null || courseID.trim().isEmpty()) {
            throw new IllegalArgumentException("ID khóa học không hợp lệ");
        }
        return reviewDAO.getReviewsByCourse(courseID);
    }
}
