package dao;

import model.TaskReview;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TaskReviewDAO {

    private static final Logger logger = LoggerFactory.getLogger(TaskReviewDAO.class);
    private final DBContext dbContext;

    public TaskReviewDAO() {
        this.dbContext = new DBContext();
    }

    public List<TaskReview> getReviewsByTeacherID(String teacherID) {
        List<TaskReview> reviews = new ArrayList<>();
        String sql = "SELECT r.*, ua.fullName AS reviewerName "
                + "FROM TaskReview r "
                + "JOIN UserAccount ua ON r.reviewerID = ua.userID "
                + "JOIN Task t ON (r.courseID = t.courseID AND t.courseID IS NOT NULL) OR (r.testID = t.testID AND t.testID IS NOT NULL) "
                + "WHERE t.teacherID = ? "
                + "ORDER BY r.reviewDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, teacherID);
            logger.debug("Executing getReviewsByTeacherID for teacherID: {}", teacherID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TaskReview review = mapResultSetToReview(rs);
                    reviews.add(review);
                    logger.debug("Found review: {}", review);
                }
                logger.info("Retrieved {} reviews for teacherID: {}", reviews.size(), teacherID);
            }
        } catch (SQLException e) {
            logger.error("Error getting reviews for teacherID {}: {}", teacherID, e.getMessage(), e);
        }
        return reviews;
    }

    public List<TaskReview> getReviewsByCourseID(String courseID) {
        List<TaskReview> reviews = new ArrayList<>();
        String sql = "SELECT r.*, ua.fullName AS reviewerName "
                + "FROM TaskReview r "
                + "JOIN UserAccount ua ON r.reviewerID = ua.userID "
                + "WHERE r.courseID = ? "
                + "ORDER BY r.reviewDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, courseID);
            logger.debug("Executing getReviewsByCourseID for courseID: {}", courseID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TaskReview review = mapResultSetToReview(rs);
                    reviews.add(review);
                    logger.debug("Found review: {}", review);
                }
                logger.info("Retrieved {} reviews for courseID: {}", reviews.size(), courseID);
            }
        } catch (SQLException e) {
            logger.error("Error getting reviews for courseID {}: {}", courseID, e.getMessage(), e);
        }
        return reviews;
    }

    public boolean addReview(TaskReview review) {
        String sql = "INSERT INTO TaskReview (courseID, testID, entityTitle, reviewerID, rating, reviewText, reviewStatus, reviewDate) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, review.getCourseID());
            ps.setObject(2, review.getTestID(), Types.INTEGER);
            ps.setString(3, review.getEntityTitle());
            ps.setString(4, review.getReviewerID());
            ps.setInt(5, review.getRating());
            ps.setString(6, review.getReviewText());
            ps.setString(7, review.getReviewStatus());
            ps.setTimestamp(8, review.getReviewDate());

            int result = ps.executeUpdate();
            logger.info("Added new review for courseID: {}, testID: {}", review.getCourseID(), review.getTestID());
            return result > 0;
        } catch (SQLException e) {
            logger.error("Error adding review for courseID {}, testID {}: {}", review.getCourseID(), review.getTestID(), e.getMessage(), e);
            return false;
        }
    }

    public boolean updateReview(TaskReview review) {
        String sql = "UPDATE TaskReview SET courseID = ?, testID = ?, entityTitle = ?, reviewerID = ?, rating = ?, "
                + "reviewText = ?, reviewStatus = ?, reviewDate = ? WHERE id = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, review.getCourseID());
            ps.setObject(2, review.getTestID(), Types.INTEGER);
            ps.setString(3, review.getEntityTitle());
            ps.setString(4, review.getReviewerID());
            ps.setInt(5, review.getRating());
            ps.setString(6, review.getReviewText());
            ps.setString(7, review.getReviewStatus());
            ps.setTimestamp(8, review.getReviewDate());
            ps.setInt(9, review.getId());

            int result = ps.executeUpdate();
            logger.info("Updated review with ID: {}", review.getId());
            return result > 0;
        } catch (SQLException e) {
            logger.error("Error updating review {}: {}", review.getId(), e.getMessage(), e);
            return false;
        }
    }

    public boolean updateReviewByEntityID(TaskReview review) {
        String sql = "UPDATE TaskReview SET reviewerID = ?, rating = ?, reviewText = ?, reviewStatus = ?, reviewDate = ? "
                + "WHERE (courseID = ? AND courseID IS NOT NULL) OR (testID = ? AND testID IS NOT NULL)";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, review.getReviewerID());
            ps.setInt(2, review.getRating());
            ps.setString(3, review.getReviewText());
            ps.setString(4, review.getReviewStatus());
            ps.setTimestamp(5, review.getReviewDate());
            ps.setString(6, review.getCourseID());
            ps.setObject(7, review.getTestID(), Types.INTEGER);

            int result = ps.executeUpdate();
            logger.info("Updated {} reviews for courseID: {}, testID: {}", result, review.getCourseID(), review.getTestID());
            return result > 0;
        } catch (SQLException e) {
            logger.error("Error updating reviews for courseID {}, testID {}: {}", review.getCourseID(), review.getTestID(), e.getMessage(), e);
            return false;
        }
    }

    public List<TaskReview> getReviewsByStatus(String status) {
        List<TaskReview> reviews = new ArrayList<>();
        String sql = "SELECT r.*, ua.fullName AS reviewerName "
                + "FROM TaskReview r "
                + "JOIN UserAccount ua ON r.reviewerID = ua.userID "
                + "WHERE r.reviewStatus = ? "
                + "ORDER BY r.reviewDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            logger.debug("Executing getReviewsByStatus for status: {}", status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TaskReview review = mapResultSetToReview(rs);
                    reviews.add(review);
                    logger.debug("Found review: {}", review);
                }
                logger.info("Retrieved {} reviews with status: {}", reviews.size(), status);
            }
        } catch (SQLException e) {
            logger.error("Error getting reviews by status {}: {}", status, e.getMessage(), e);
        }
        return reviews;
    }

    public List<TaskReview> getAllReviews() {
        List<TaskReview> reviews = new ArrayList<>();
        String sql = "SELECT r.*, ua.fullName AS reviewerName "
                + "FROM TaskReview r "
                + "JOIN UserAccount ua ON r.reviewerID = ua.userID "
                + "ORDER BY r.reviewDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            logger.debug("Executing getAllReviews");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TaskReview review = mapResultSetToReview(rs);
                    reviews.add(review);
                    logger.debug("Found review: {}", review);
                }
                logger.info("Retrieved {} total reviews", reviews.size());
            }
        } catch (SQLException e) {
            logger.error("Error getting all reviews: {}", e.getMessage(), e);
        }
        return reviews;
    }

    private TaskReview mapResultSetToReview(ResultSet rs) throws SQLException {
        TaskReview review = new TaskReview();
        review.setId(rs.getInt("id"));
        review.setCourseID(rs.getString("courseID"));
        review.setTestID(rs.getObject("testID") != null ? rs.getInt("testID") : null);
        review.setEntityTitle(rs.getString("entityTitle"));
        review.setReviewerID(rs.getString("reviewerID"));
        review.setRating(rs.getInt("rating"));
        review.setReviewText(rs.getString("reviewText"));
        review.setReviewStatus(rs.getString("reviewStatus"));
        review.setReviewDate(rs.getTimestamp("reviewDate"));
        review.setReviewerName(rs.getString("reviewerName"));
        return review;
    }
}
