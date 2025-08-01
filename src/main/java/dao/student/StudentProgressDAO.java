package dao.student;

import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * DAO để tính toán tiến độ học tập của sinh viên dựa trên bảng Progress
 */
public class StudentProgressDAO {
    
    private static final Logger logger = LoggerFactory.getLogger(StudentProgressDAO.class);
    private final DBContext dbContext;

    public StudentProgressDAO() {
        this.dbContext = new DBContext();
        logger.info("StudentProgressDAO initialized successfully.");
    }

    /**
     * Tính toán tiến độ của sinh viên cho một khóa học cụ thể
     * @param userID ID của user
     * @param courseID ID của khóa học
     * @return phần trăm tiến độ (0-100)
     */
    public double getCourseProgressByUser(String userID, String courseID) {
        String sql = "SELECT " +
                    "COUNT(DISTINCT CASE " +
                    "    WHEN p.lessonID IS NOT NULL THEN l.id " +
                    "    WHEN p.assignmentID IS NOT NULL THEN a.id " +
                    "    ELSE NULL " +
                    "END) as totalActivities, " +
                    "COUNT(DISTINCT CASE " +
                    "    WHEN p.completionStatus = 'complete' AND p.lessonID IS NOT NULL THEN l.id " +
                    "    WHEN p.completionStatus = 'complete' AND p.assignmentID IS NOT NULL THEN a.id " +
                    "    ELSE NULL " +
                    "END) as completedActivities " +
                    "FROM Course_Enrollments ce " +
                    "JOIN Student s ON ce.studentID = s.studentID " +
                    "LEFT JOIN Progress p ON ce.enrollmentID = p.enrollmentID " +
                    "LEFT JOIN Lesson l ON p.lessonID = l.id " +
                    "LEFT JOIN Assignment a ON p.assignmentID = a.id " +
                    "WHERE s.userID = ? AND ce.courseID = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            stmt.setString(2, courseID);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int totalActivities = rs.getInt("totalActivities");
                    int completedActivities = rs.getInt("completedActivities");
                    
                    if (totalActivities > 0) {
                        double progress = ((double) completedActivities / totalActivities) * 100;
                        logger.debug("Course progress for user {} in course {}: {}/{} = {}%", 
                                   userID, courseID, completedActivities, totalActivities, progress);
                        return Math.round(progress * 100.0) / 100.0; // Round to 2 decimal places
                    }
                }
            }
        } catch (SQLException e) {
            logger.error("Error calculating course progress for user {} and course {}: {}", 
                        userID, courseID, e.getMessage(), e);
        }
        
        return 0.0;
    }

    /**
     * Lấy tiến độ của tất cả khóa học mà sinh viên đã đăng ký
     * @param userID ID của user
     * @return Map với key là courseID và value là phần trăm tiến độ
     */
    public Map<String, Double> getAllCourseProgressByUser(String userID) {
        Map<String, Double> progressMap = new HashMap<>();
        
        String sql = "SELECT " +
                    "ce.courseID, " +
                    "COUNT(DISTINCT CASE " +
                    "    WHEN p.lessonID IS NOT NULL THEN l.id " +
                    "    WHEN p.assignmentID IS NOT NULL THEN a.id " +
                    "    ELSE NULL " +
                    "END) as totalActivities, " +
                    "COUNT(DISTINCT CASE " +
                    "    WHEN p.completionStatus = 'complete' AND p.lessonID IS NOT NULL THEN l.id " +
                    "    WHEN p.completionStatus = 'complete' AND p.assignmentID IS NOT NULL THEN a.id " +
                    "    ELSE NULL " +
                    "END) as completedActivities " +
                    "FROM Course_Enrollments ce " +
                    "JOIN Student s ON ce.studentID = s.studentID " +
                    "LEFT JOIN Progress p ON ce.enrollmentID = p.enrollmentID " +
                    "LEFT JOIN Lesson l ON p.lessonID = l.id " +
                    "LEFT JOIN Assignment a ON p.assignmentID = a.id " +
                    "WHERE s.userID = ? " +
                    "GROUP BY ce.courseID";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String courseID = rs.getString("courseID");
                    int totalActivities = rs.getInt("totalActivities");
                    int completedActivities = rs.getInt("completedActivities");
                    
                    double progress = 0.0;
                    if (totalActivities > 0) {
                        progress = ((double) completedActivities / totalActivities) * 100;
                        progress = Math.round(progress * 100.0) / 100.0; // Round to 2 decimal places
                    }
                    
                    progressMap.put(courseID, progress);
                    logger.debug("Progress for course {}: {}/{} = {}%", 
                               courseID, completedActivities, totalActivities, progress);
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting all course progress for user {}: {}", userID, e.getMessage(), e);
        }
        
        return progressMap;
    }

    /**
     * Tính toán thống kê tổng quan cho sinh viên
     * @param userID ID của user
     * @return Map chứa các thống kê: totalCourses, completedCourses, averageProgress, totalHours
     */
    public Map<String, Object> getStudentStats(String userID) {
        Map<String, Object> stats = new HashMap<>();
        
        // Lấy danh sách khóa học và tiến độ
        Map<String, Double> progressMap = getAllCourseProgressByUser(userID);
        int totalCourses = progressMap.size();
        int completedCourses = 0;
        double totalProgress = 0.0;
        
        for (Double progress : progressMap.values()) {
            if (progress >= 100.0) {
                completedCourses++;
            }
            totalProgress += progress;
        }
        
        double averageProgress = totalCourses > 0 ? totalProgress / totalCourses : 0.0;
        
        // Lấy tổng số giờ học từ các khóa học đã đăng ký
        double totalHours = getTotalHoursByUser(userID);
        
        stats.put("totalCourses", totalCourses);
        stats.put("completedCourses", completedCourses);
        stats.put("averageProgress", Math.round(averageProgress * 100.0) / 100.0);
        stats.put("totalHours", totalHours);
        
        // Thêm map tiến độ từng khóa học để sử dụng trong JSP
        for (Map.Entry<String, Double> entry : progressMap.entrySet()) {
            stats.put(entry.getKey(), entry.getValue());
        }
        
        logger.info("Student stats for user {}: {} courses, {} completed, {}% average progress, {} hours", 
                   userID, totalCourses, completedCourses, averageProgress, totalHours);
        
        return stats;
    }

    /**
     * Tính tổng số giờ học từ các khóa học đã đăng ký
     * @param userID ID của user
     * @return tổng số giờ
     */
    private double getTotalHoursByUser(String userID) {
        String sql = "SELECT COALESCE(SUM(c.duration), 0) as totalHours " +
                    "FROM Course_Enrollments ce " +
                    "JOIN Student s ON ce.studentID = s.studentID " +
                    "JOIN Courses c ON ce.courseID = c.courseID " +
                    "WHERE s.userID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("totalHours");
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting total hours for user {}: {}", userID, e.getMessage(), e);
        }
        
        return 0.0;
    }

    /**
     * Lấy số lượng bài học và assignment đã hoàn thành và tổng số
     * @param userID ID của user
     * @param courseID ID của khóa học
     * @return Map chứa completedLessons, totalLessons, completedAssignments, totalAssignments
     */
    public Map<String, Integer> getDetailedProgressByUserAndCourse(String userID, String courseID) {
        Map<String, Integer> details = new HashMap<>();
        
        String sql = "SELECT " +
                    "COUNT(DISTINCT l.id) as totalLessons, " +
                    "COUNT(DISTINCT a.id) as totalAssignments, " +
                    "COUNT(DISTINCT CASE WHEN p.completionStatus = 'complete' AND p.lessonID IS NOT NULL THEN l.id END) as completedLessons, " +
                    "COUNT(DISTINCT CASE WHEN p.completionStatus = 'complete' AND p.assignmentID IS NOT NULL THEN a.id END) as completedAssignments " +
                    "FROM Course_Enrollments ce " +
                    "JOIN Student s ON ce.studentID = s.studentID " +
                    "LEFT JOIN Progress p ON ce.enrollmentID = p.enrollmentID " +
                    "LEFT JOIN Lesson l ON p.lessonID = l.id " +
                    "LEFT JOIN Assignment a ON p.assignmentID = a.id " +
                    "WHERE s.userID = ? AND ce.courseID = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            stmt.setString(2, courseID);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    details.put("totalLessons", rs.getInt("totalLessons"));
                    details.put("totalAssignments", rs.getInt("totalAssignments"));
                    details.put("completedLessons", rs.getInt("completedLessons"));
                    details.put("completedAssignments", rs.getInt("completedAssignments"));
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting detailed progress for user {} and course {}: {}", 
                        userID, courseID, e.getMessage(), e);
        }
        
        return details;
    }

    public void closeConnection() {
        if (dbContext != null) {
            dbContext.closeConnection();
        }
        logger.info("StudentProgressDAO connection closed.");
    }
}
