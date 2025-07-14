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
        return getReviewsWithFilters(null, null, null, null, null, null, 0, Integer.MAX_VALUE);
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
                    review.setStatus(rs.getString("status"));
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

    public void blockReview(int id) throws SQLException {
        String sql = "UPDATE Course_Reviews SET status = 'blocked' WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Blocking review failed, no rows affected.");
            }
            
            LOGGER.info("Review blocked successfully: " + id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error blocking review", e);
            throw e;
        }
    }

    public void unblockReview(int id) throws SQLException {
        String sql = "UPDATE Course_Reviews SET status = 'active' WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Unblocking review failed, no rows affected.");
            }
            
            LOGGER.info("Review unblocked successfully: " + id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unblocking review", e);
            throw e;
        }
    }

    public List<Review> getReviewsByCourse(String courseID) throws SQLException {
        return getReviewsWithFilters(courseID, null, null, null, null, "active", 0, Integer.MAX_VALUE);
    }

    public List<Review> getReviewsWithFilters(String courseID, String rating, String search, 
            String reviewDateFrom, String reviewDateTo, String status, int offset, int limit) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT cr.*, u.fullName as reviewerName, c.title as courseName " +
            "FROM Course_Reviews cr " +
            "JOIN UserAccount u ON cr.userID = u.userID " +
            "JOIN Courses c ON cr.courseID = c.courseID " +
            "WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (courseID != null && !courseID.trim().isEmpty()) {
            sql.append(" AND cr.courseID = ?");
            params.add(courseID.trim());
        }

        if (rating != null && !rating.trim().isEmpty()) {
            sql.append(" AND cr.rating = ?");
            params.add(Integer.parseInt(rating.trim()));
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (u.fullName LIKE ? OR CAST(cr.id AS CHAR) LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (reviewDateFrom != null && !reviewDateFrom.trim().isEmpty()) {
            sql.append(" AND DATE(cr.reviewDate) >= ?");
            params.add(reviewDateFrom);
        }

        if (reviewDateTo != null && !reviewDateTo.trim().isEmpty()) {
            sql.append(" AND DATE(cr.reviewDate) <= ?");
            params.add(reviewDateTo);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND cr.status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY cr.reviewDate DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setCourseID(rs.getString("courseID"));
                    review.setUserID(rs.getString("userID"));
                    review.setRating(rs.getInt("rating"));
                    review.setReviewText(rs.getString("reviewText"));
                    review.setReviewDate(rs.getDate("reviewDate"));
                    review.setStatus(rs.getString("status"));
                    review.setReviewerName(rs.getString("reviewerName"));
                    review.setCourseName(rs.getString("courseName"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting reviews with filters", e);
            throw e;
        }
        return reviews;
    }

    public int countReviewsWithFilters(String courseID, String rating, String search, 
            String reviewDateFrom, String reviewDateTo, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM Course_Reviews cr " +
            "JOIN UserAccount u ON cr.userID = u.userID " +
            "JOIN Courses c ON cr.courseID = c.courseID " +
            "WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (courseID != null && !courseID.trim().isEmpty()) {
            sql.append(" AND cr.courseID = ?");
            params.add(courseID.trim());
        }

        if (rating != null && !rating.trim().isEmpty()) {
            sql.append(" AND cr.rating = ?");
            params.add(Integer.parseInt(rating.trim()));
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (u.fullName LIKE ? OR CAST(cr.id AS CHAR) LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (reviewDateFrom != null && !reviewDateFrom.trim().isEmpty()) {
            sql.append(" AND DATE(cr.reviewDate) >= ?");
            params.add(reviewDateFrom);
        }

        if (reviewDateTo != null && !reviewDateTo.trim().isEmpty()) {
            sql.append(" AND DATE(cr.reviewDate) <= ?");
            params.add(reviewDateTo);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND cr.status = ?");
            params.add(status.trim());
        }

        int count = 0;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting reviews with filters", e);
            throw e;
        }
        return count;
    }
}
