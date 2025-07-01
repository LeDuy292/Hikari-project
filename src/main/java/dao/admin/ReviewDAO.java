package dao.admin;

import model.admin.Review;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class ReviewDAO {
    private static final Logger LOGGER = Logger.getLogger(ReviewDAO.class.getName());
    private final DBContext dbContext;

    public ReviewDAO() {
        this.dbContext = new DBContext();
    }

    public List<Review> getAllReviews() throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT cr.*, u.fullName as reviewerName, c.title as courseName " +
                    "FROM Course_Reviews cr " +
                    "JOIN UserAccount u ON cr.userID = u.userID " +
                    "JOIN Courses c ON cr.courseID = c.courseID " +
                    "ORDER BY cr.reviewDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Review review = new Review();
                review.setId(rs.getInt("id"));
                review.setCourseID(rs.getString("courseID"));
                review.setUserID(rs.getString("userID"));
                review.setRating(rs.getInt("rating"));
                review.setReviewText(rs.getString("reviewText"));
                review.setReviewDate(rs.getDate("reviewDate"));
                review.setReviewerName(rs.getString("reviewerName"));
                review.setCourseName(rs.getString("courseName"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all reviews", e);
            throw e;
        }
        return reviews;
    }

    public Review getReviewById(int id) throws SQLException {
        String sql = "SELECT cr.*, u.fullName as reviewerName, c.title as courseName " +
                    "FROM Course_Reviews cr " +
                    "JOIN UserAccount u ON cr.userID = u.userID " +
                    "JOIN Courses c ON cr.courseID = c.courseID " +
                    "WHERE cr.id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setCourseID(rs.getString("courseID"));
                    review.setUserID(rs.getString("userID"));
                    review.setRating(rs.getInt("rating"));
                    review.setReviewText(rs.getString("reviewText"));
                    review.setReviewDate(rs.getDate("reviewDate"));
                    review.setReviewerName(rs.getString("reviewerName"));
                    review.setCourseName(rs.getString("courseName"));
                    return review;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting review by id", e);
            throw e;
        }
        return null;
    }

    public void updateReview(Review review) throws SQLException {
        String sql = "UPDATE Course_Reviews SET rating = ?, reviewText = ? WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getReviewText());
            stmt.setInt(3, review.getId());
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Updating review failed, no rows affected.");
            }
            
            LOGGER.info("Review updated successfully: " + review.getId());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating review", e);
            throw e;
        }
    }

    public void deleteReview(int id) throws SQLException {
        String sql = "DELETE FROM Course_Reviews WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Deleting review failed, no rows affected.");
            }
            
            LOGGER.info("Review deleted successfully: " + id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting review", e);
            throw e;
        }
    }

    public List<Review> getReviewsByCourse(String courseID) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT cr.*, u.fullName as reviewerName, c.title as courseName " +
                    "FROM Course_Reviews cr " +
                    "JOIN UserAccount u ON cr.userID = u.userID " +
                    "JOIN Courses c ON cr.courseID = c.courseID " +
                    "WHERE cr.courseID = ? " +
                    "ORDER BY cr.reviewDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseID);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setCourseID(rs.getString("courseID"));
                    review.setUserID(rs.getString("userID"));
                    review.setRating(rs.getInt("rating"));
                    review.setReviewText(rs.getString("reviewText"));
                    review.setReviewDate(rs.getDate("reviewDate"));
                    review.setReviewerName(rs.getString("reviewerName"));
                    review.setCourseName(rs.getString("courseName"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting reviews by course", e);
            throw e;
        }
        return reviews;
    }
}
