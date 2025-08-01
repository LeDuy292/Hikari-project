package dao;

import model.Review;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ReviewDAO {
    private static final Logger logger = LoggerFactory.getLogger(ReviewDAO.class);
    private final DBContext dbContext;

    public ReviewDAO() {
        this.dbContext = new DBContext();
    }

    public boolean addReview(Review review) {
        String sql = "INSERT INTO Course_Reviews (courseID, userID, rating, reviewText, reviewDate) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, review.getCourseID());
            stmt.setString(2, review.getUserID());
            stmt.setInt(3, review.getRating());
            stmt.setString(4, review.getReviewText());
            // Fix: Use setDate for DATE column
            stmt.setDate(5, new java.sql.Date(review.getReviewDate().getTime()));
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                logger.info("Review added successfully for user {} and course {} with rating {}", 
                           review.getUserID(), review.getCourseID(), review.getRating());
                return true;
            }
            
        } catch (SQLException e) {
            logger.error("Error adding review for user {} and course {}: {}", 
                        review.getUserID(), review.getCourseID(), e.getMessage(), e);
        }
        return false;
    }

    public boolean updateReview(Review review) {
        String sql = "UPDATE Course_Reviews SET rating = ?, reviewText = ?, reviewDate = ? WHERE userID = ? AND courseID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            logger.info("Attempting to update review for user {} and course {} with rating {}",
                       review.getUserID(), review.getCourseID(), review.getRating());

            stmt.setInt(1, review.getRating());
            stmt.setString(2, review.getReviewText());
            // Fix: Use setDate for DATE column
            stmt.setDate(3, new java.sql.Date(review.getReviewDate() != null ? review.getReviewDate().getTime() : System.currentTimeMillis()));
            stmt.setString(4, review.getUserID());
            stmt.setString(5, review.getCourseID());

            int result = stmt.executeUpdate();
            logger.info("Update result: {} rows affected for user {} and course {}",
                       result, review.getUserID(), review.getCourseID());

            return result > 0;
        } catch (SQLException e) {
            logger.error("SQL Error updating review for user {} and course {}: {}",
                        review.getUserID(), review.getCourseID(), e.getMessage(), e);
        }
        return false;
    }

    public boolean deleteReview(String userID, String courseID) {
        String sql = "DELETE FROM Course_Reviews WHERE userID = ? AND courseID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            logger.info("Attempting to delete review for user {} and course {}", userID, courseID);

            stmt.setString(1, userID);
            stmt.setString(2, courseID);

            int result = stmt.executeUpdate();
            logger.info("Delete result: {} rows affected for user {} and course {}",
                       result, userID, courseID);

            return result > 0;
        } catch (SQLException e) {
            logger.error("SQL Error deleting review for user {} and course {}: {}",
                        userID, courseID, e.getMessage(), e);
        }
        return false;
    }

    public List<Review> getReviewsByCourseID(String courseID) {
        List<Review> reviews = new ArrayList<>();
        // Bỏ điều kiện status vì data không có status = 'active'
        String sql = "SELECT cr.courseID, cr.userID, cr.rating, cr.reviewText, cr.reviewDate, " +
                    "u.username, u.fullName, u.profilePicture " +
                    "FROM Course_Reviews cr " +
                    "JOIN UserAccount u ON cr.userID = u.userID " +
                    "WHERE cr.courseID = ? " +
                    "ORDER BY cr.reviewDate DESC";
        
        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            if (conn == null) {
                logger.error("Failed to get database connection for courseID: {}", courseID);
                return reviews;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, courseID);
                logger.debug("Executing query for courseID: {}", courseID);
                
                ResultSet rs = stmt.executeQuery();
                
                while (rs.next()) {
                    try {
                        Review review = mapResultSetToReview(rs);
                        reviews.add(review);
                        logger.debug("Added review from user: {}", review.getUserID());
                    } catch (SQLException e) {
                        logger.error("Error mapping review result set: {}", e.getMessage());
                    }
                }
                logger.info("Retrieved {} reviews for course {}", reviews.size(), courseID);
            }
            
        } catch (SQLException e) {
            logger.error("Error getting reviews for course {}: {}", courseID, e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    logger.error("Error closing connection: {}", e.getMessage());
                }
            }
        }
        return reviews;
    }

    public Review getReviewByUserAndCourse(String userID, String courseID) {
        String sql = "SELECT cr.courseID, cr.userID, cr.rating, cr.reviewText, cr.reviewDate, " +
                    "u.username, u.fullName, u.profilePicture " +
                    "FROM Course_Reviews cr " +
                    "JOIN UserAccount u ON cr.userID = u.userID " +
                    "WHERE cr.userID = ? AND cr.courseID = ?";
        
        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            if (conn == null) {
                logger.error("Failed to get database connection for user {} and course {}", userID, courseID);
                return null;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, userID);
                stmt.setString(2, courseID);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    Review review = mapResultSetToReview(rs);
                    logger.debug("Found existing review for user {} and course {} with rating {}", 
                               userID, courseID, review.getRating());
                    return review;
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error getting review for user {} and course {}: {}", userID, courseID, e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    logger.error("Error closing connection: {}", e.getMessage());
                }
            }
        }
        return null;
    }

    public boolean canUserReview(String userID, String courseID) {
        // Check if user already reviewed
        Review existingReview = getReviewByUserAndCourse(userID, courseID);
        if (existingReview != null) {
            logger.debug("User {} already reviewed course {}", userID, courseID);
            return false;
        }
        // Check if user has completed at least 2 lessons
        int completedLessons = getCompletedLessonsCount(userID, courseID);
        boolean canReview = completedLessons >= 2;
        logger.info("User {} review eligibility for course {}: {} lessons completed, can review: {}", 
                   userID, courseID, completedLessons, canReview);
        return canReview;
    }

    public double getAverageRating(String courseID) {
        String sql = "SELECT AVG(CAST(rating AS DECIMAL(3,2))) as avgRating FROM Course_Reviews WHERE courseID = ?";
        
        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            if (conn == null) {
                logger.error("Failed to get database connection for courseID: {}", courseID);
                return 0.0;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, courseID);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    double avgRating = rs.getDouble("avgRating");
                    logger.debug("Average rating for course {}: {}", courseID, avgRating);
                    return avgRating;
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error getting average rating for course {}: {}", courseID, e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    logger.error("Error closing connection: {}", e.getMessage());
                }
            }
        }
        return 0.0;
    }

    public int getReviewCount(String courseID) {
        String sql = "SELECT COUNT(*) as reviewCount FROM Course_Reviews WHERE courseID = ?";
        
        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            if (conn == null) {
                logger.error("Failed to get database connection for courseID: {}", courseID);
                return 0;
            }
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, courseID);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    int count = rs.getInt("reviewCount");
                    logger.debug("Review count for course {}: {}", courseID, count);
                    return count;
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error getting review count for course {}: {}", courseID, e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    logger.error("Error closing connection: {}", e.getMessage());
                }
            }
        }
        return 0;
    }

    public int getCompletedLessonsCount(String userID, String courseID) {
        String sql = "SELECT COUNT(DISTINCT p.lessonID) as completedLessons, " +
                    "GROUP_CONCAT(DISTINCT p.lessonID ORDER BY p.lessonID SEPARATOR ', ') as lessonIDs " +
                    "FROM Course_Enrollments ce " +
                    "JOIN Student s ON ce.studentID = s.studentID " +
                    "JOIN Progress p ON ce.enrollmentID = p.enrollmentID " +
                    "WHERE s.userID = ? AND ce.courseID = ? " +
                    "AND p.completionStatus = 'complete' " +
                    "AND p.lessonID IS NOT NULL";
                    
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            stmt.setString(2, courseID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int completedLessons = rs.getInt("completedLessons");
                String lessonIDs = rs.getString("lessonIDs");
                logger.info("User {} completed {} lessons in course {}: [{}]", 
                           userID, completedLessons, courseID, lessonIDs != null ? lessonIDs : "none");
                return completedLessons;
            }
        } catch (SQLException e) {
            logger.error("Error getting completed lessons count for user {} and course {}: {}", 
                        userID, courseID, e.getMessage(), e);
        }   
        return 0;
    }

    // Method to check enrollment and progress details for debugging
    public String getProgressDetails(String userID, String courseID) {
        StringBuilder details = new StringBuilder();
        // Check enrollment
        String enrollmentSQL = "SELECT ce.enrollmentID, ce.enrollmentDate " +
                              "FROM Course_Enrollments ce " +
                              "JOIN Student s ON ce.studentID = s.studentID " +
                              "WHERE s.userID = ? AND ce.courseID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(enrollmentSQL)) {
            
            stmt.setString(1, userID);
            stmt.setString(2, courseID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String enrollmentID = rs.getString("enrollmentID");
                details.append("Enrolled with ID: ").append(enrollmentID).append("; ");
                
                // Check progress
                String progressSQL = "SELECT COUNT(*) as totalProgress, " +
                                   "SUM(CASE WHEN completionStatus = 'complete' AND lessonID IS NOT NULL THEN 1 ELSE 0 END) as completedLessons " +
                                   "FROM Progress WHERE enrollmentID = ?";
                try (PreparedStatement progressStmt = conn.prepareStatement(progressSQL)) {
                    progressStmt.setString(1, enrollmentID);
                    ResultSet progressRs = progressStmt.executeQuery();
                    if (progressRs.next()) {
                        int totalProgress = progressRs.getInt("totalProgress");
                        int completedLessons = progressRs.getInt("completedLessons");
                        details.append("Total progress records: ").append(totalProgress)
                               .append(", Completed lessons: ").append(completedLessons);
                    }
                }
            } else {
                details.append("Not enrolled");
            }
        } catch (SQLException e) {
            details.append("Error checking progress: ").append(e.getMessage());
            logger.error("Error getting progress details for user {} and course {}: {}", 
                        userID, courseID, e.getMessage(), e);
        }   
        return details.toString();
    }

    // Debug method to check if review exists
    public boolean reviewExists(String userID, String courseID) {
        String sql = "SELECT COUNT(*) as count FROM Course_Reviews WHERE userID = ? AND courseID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            stmt.setString(2, courseID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt("count");
                logger.info("Review exists check for user {} and course {}: {} records found", 
                           userID, courseID, count);
                return count > 0;
            }
            
        } catch (SQLException e) {
            logger.error("Error checking if review exists for user {} and course {}: {}", 
                        userID, courseID, e.getMessage(), e);
        }
        
        return false;
    }

    // Enhanced security method to verify review ownership
    public boolean isReviewOwnedByUser(String userID, String courseID) {
        String sql = "SELECT COUNT(*) FROM Course_Reviews WHERE userID = ? AND courseID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            stmt.setString(2, courseID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                logger.debug("Review ownership check for user {} and course {}: {} reviews found", 
                            userID, courseID, count);
                return count > 0;
            }
            
        } catch (SQLException e) {
            logger.error("Error checking review ownership for user {} and course {}: {}", 
                        userID, courseID, e.getMessage(), e);
        }
        return false;
    }

    private Review mapResultSetToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setCourseID(rs.getString("courseID"));
        review.setUserID(rs.getString("userID"));
        review.setRating(rs.getInt("rating"));
        review.setReviewText(rs.getString("reviewText"));
        review.setReviewDate(rs.getTimestamp("reviewDate"));
        review.setActive(true);
        
        // Set display fields
        review.setUsername(rs.getString("username"));
        review.setFullName(rs.getString("fullName"));
        review.setProfilePicture(rs.getString("profilePicture"));
        
        return review;
    }

    public void closeConnection() {
        dbContext.closeConnection();
    }
}


