package dao;

import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ProgressDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProgressDAO.class);
    private Connection con;

    public ProgressDAO() {
        DBContext dbContext = new DBContext();
        try {
            con = dbContext.getConnection();
            logger.info("ProgressDAO: Database connection established successfully!");
        } catch (Exception e) {
            logger.error("ProgressDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    public int getTotalLessonsByCourseId(String courseID) {
        String sql = "SELECT COUNT(*) AS totalLessons " +
                     "FROM Topic t JOIN Lesson l ON t.topicID = l.topicID " +
                     "WHERE t.courseID = ? AND l.isActive = TRUE AND t.isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("totalLessons");
                }
            }
        } catch (SQLException e) {
            logger.error("Error in getTotalLessonsByCourseId for courseID {}: {}", courseID, e.getMessage(), e);
        }
        return 0;
    }

    public int getCompletedLessonsByEnrollmentId(String enrollmentID) {
        String sql = "SELECT COUNT(*) AS completedLessons " +
                     "FROM Progress p JOIN Lesson l ON p.lessonID = l.id " +
                     "JOIN Topic t ON l.topicID = t.topicID " +
                     "WHERE p.enrollmentID = ? AND p.completionStatus = 'complete' " +
                     "AND l.isActive = TRUE AND t.isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, enrollmentID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("completedLessons");
                }
            }
        } catch (SQLException e) {
            logger.error("Error in getCompletedLessonsByEnrollmentId for enrollmentID {}: {}", enrollmentID, e.getMessage(), e);
        }
        return 0;
    }

    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("ProgressDAO: Connection closed successfully!");
            }
        } catch (SQLException e) {
            logger.error("Error closing connection in ProgressDAO: {}", e.getMessage(), e);
        }
    }
}