package dao.student;

import model.Course;
import utils.DBContext;
import jakarta.servlet.ServletException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;
import model.student.CourseEnrollment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CourseEnrollmentDAO {
    private static final Logger logger = LoggerFactory.getLogger(CourseEnrollmentDAO.class);
    private Connection con;

    public CourseEnrollmentDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            logger.info("CourseEnrollmentDAO: KET NOI THANH CONG!");
        } catch (Exception e) {
            logger.error("CourseEnrollmentDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    public boolean isCourseEnrolled(String studentID, String courseID) {
        String sql = "SELECT COUNT(*) FROM Course_Enrollments WHERE studentID = ? AND courseID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, studentID);
            pre.setString(2, courseID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error in isCourseEnrolled for studentID {} and courseID {}: {}", studentID, courseID, e.getMessage(), e);
        }
        return false;
    }

    // Method to enroll a course, called from CartServlet after successful payment
    public boolean enrollCourse(String userID, String courseID) {
        logger.info("Attempting to enroll user {} in course {}", userID, courseID);
        
        // First get studentID from userID
        String getStudentSQL = "SELECT studentID FROM Student WHERE userID = ?";
        String studentID = null;
        
        try (PreparedStatement pre = con.prepareStatement(getStudentSQL)) {
            pre.setString(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    studentID = rs.getString("studentID");
                } else {
                    logger.error("No student found for userID: {}", userID);
                    return false;
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting studentID for userID {}: {}", userID, e.getMessage(), e);
            return false;
        }

        CourseEnrollment enrollment = new CourseEnrollment();
        enrollment.setStudentID(studentID);
        enrollment.setCourseID(courseID);
        enrollment.setEnrollmentDate(Date.valueOf(LocalDate.now()));

        String generatedID = addCourseEnrollment(enrollment);
        if (generatedID != null) {
            logger.info("Successfully enrolled user {} (student {}) in course {} with enrollmentID {}", 
                       userID, studentID, courseID, generatedID);
            return true;
        } else {
            logger.error("Failed to enroll user {} in course {}. addCourseEnrollment returned null.", userID, courseID);
            return false;
        }
    }

    public String addCourseEnrollment(CourseEnrollment enrollment) {
        String sql = "INSERT INTO Course_Enrollments (enrollmentID, studentID, courseID, enrollmentDate) VALUES (?, ?, ?, ?)";
        String generatedEnrollmentID = null;
        try {
            generatedEnrollmentID = generateNextEnrollmentID();
            
            try (PreparedStatement pre = con.prepareStatement(sql)) {
                pre.setString(1, generatedEnrollmentID);
                pre.setString(2, enrollment.getStudentID());
                pre.setString(3, enrollment.getCourseID());
                pre.setDate(4, enrollment.getEnrollmentDate());
                
                int affectedRows = pre.executeUpdate();
                if (affectedRows > 0) {
                    return generatedEnrollmentID;
                }
            }
        } catch (SQLException e) {
            logger.error("Error in addCourseEnrollment for studentID {} and courseID {}: {}", 
                        enrollment.getStudentID(), enrollment.getCourseID(), e.getMessage(), e);
        }
        return null;
    }

    public String enrollCourseAndGetID(String userID, String courseID) {
        logger.info("Attempting to enroll user {} in course {} and return enrollment ID", userID, courseID);
        
        // First get studentID from userID
        String getStudentSQL = "SELECT studentID FROM Student WHERE userID = ?";
        String studentID = null;
        
        try (PreparedStatement pre = con.prepareStatement(getStudentSQL)) {
            pre.setString(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    studentID = rs.getString("studentID");
                } else {
                    logger.error("No student found for userID: {}", userID);
                    return null;
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting studentID for userID {}: {}", userID, e.getMessage(), e);
            return null;
        }

        CourseEnrollment enrollment = new CourseEnrollment();
        enrollment.setStudentID(studentID);
        enrollment.setCourseID(courseID);
        enrollment.setEnrollmentDate(Date.valueOf(LocalDate.now()));

        String generatedID = addCourseEnrollment(enrollment);
        if (generatedID != null) {
            logger.info("Successfully enrolled user {} (student {}) in course {} with enrollmentID {}", 
                       userID, studentID, courseID, generatedID);
            return generatedID;
        } else {
            logger.error("Failed to enroll user {} in course {}. addCourseEnrollment returned null.", userID, courseID);
            return null;
        }
    }

    // Sửa lại: Lấy danh sách khóa học trực tiếp dưới dạng List<Course>
    public List<Course> getEnrolledCoursesByUserID(String userID) {
        List<Course> enrolledCourses = new ArrayList<>();
        String sql = "SELECT c.courseID, c.title, c.description, c.fee, c.duration, c.imageUrl, c.startDate, c.endDate, c.isActive " +
                     "FROM Course_Enrollments ce " +
                     "JOIN Courses c ON ce.courseID = c.courseID " +
                     "JOIN Student s ON ce.studentID = s.studentID " +
                     "WHERE s.userID = ? " +
                     "ORDER BY ce.enrollmentDate DESC";
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course(
                        rs.getString("courseID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getDouble("fee"),
                        rs.getObject("duration") != null ? rs.getInt("duration") : null, // Xử lý NULL cho duration
                        rs.getDate("startDate"),
                        rs.getDate("endDate"),
                        rs.getBoolean("isActive"),
                        rs.getString("imageUrl")
                    );
                    enrolledCourses.add(course);
                }
            }
        } catch (SQLException e) {
            logger.error("Error in getEnrolledCoursesByUserID for userID {}: {}", userID, e.getMessage(), e);
        }
        
        return enrolledCourses;
    }

    public boolean isUserEnrolledInCourse(String userID, String courseID) {
        String sql = "SELECT COUNT(*) FROM Course_Enrollments ce " +
                    "JOIN Student s ON ce.studentID = s.studentID " +
                    "WHERE s.userID = ? AND ce.courseID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, userID);
            pre.setString(2, courseID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error in isUserEnrolledInCourse for userID {} and courseID {}: {}", userID, courseID, e.getMessage(), e);
        }
        return false;
    }

    private String generateNextEnrollmentID() throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(enrollmentID, 2) AS UNSIGNED)) AS maxID FROM Course_Enrollments";
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            int maxID = 0;
            if (rs.next()) {
                maxID = rs.getInt("maxID");
            }
            return String.format("E%03d", maxID + 1);
        }
    }

    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("CourseEnrollmentDAO: KET NOI DA DONG!");
            }
        } catch (SQLException e) {
            logger.error("Error closing connection in CourseEnrollmentDAO: {}", e.getMessage(), e);
        }
    }
}