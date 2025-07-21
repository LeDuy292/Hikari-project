package dao.student;

import model.Course;
import model.student.CourseEnrollment;
import utils.DBContext;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CourseEnrollmentDAO {

    private static final Logger logger = LoggerFactory.getLogger(CourseEnrollmentDAO.class);
    private final DBContext dbContext;

    public CourseEnrollmentDAO() {
        this.dbContext = new DBContext();
        logger.info("CourseEnrollmentDAO: Connection initialized!");
    }

    public boolean isCourseEnrolled(String studentID, String courseID) {
        String sql = "SELECT COUNT(*) FROM Course_Enrollments WHERE studentID = ? AND courseID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
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

    public boolean enrollCourse(String userID, String courseID, Connection conn) throws SQLException {
        logger.info("Attempting to enroll user {} in course {}", userID, courseID);

        // Get studentID from userID
        String getStudentSQL = "SELECT studentID FROM Student WHERE userID = ?";
        String studentID;
        try (PreparedStatement pre = conn.prepareStatement(getStudentSQL)) {
            pre.setString(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    studentID = rs.getString("studentID");
                } else {
                    logger.error("No student found for userID: {}", userID);
                    return false;
                }
            }
        }

        // Check for duplicate enrollment
        if (isCourseEnrolled(studentID, courseID)) {
            logger.warn("Student {} is already enrolled in course {}", studentID, courseID);
            return false;
        }

        CourseEnrollment enrollment = new CourseEnrollment();
        enrollment.setStudentID(studentID);
        enrollment.setCourseID(courseID);
        enrollment.setEnrollmentDate(Date.valueOf(LocalDate.now()));

        String generatedID = addCourseEnrollment(enrollment, conn);
        if (generatedID != null) {
            logger.info("Successfully enrolled student {} in course {} with enrollmentID {}", studentID, courseID, generatedID);
            return true;
        } else {
            logger.error("Failed to enroll student {} in course {}. addCourseEnrollment returned null.", studentID, courseID);
            return false;
        }
    }

    public boolean enrollCourse(String userID, String courseID) {
        logger.info("Attempting to enroll user {} in course {}", userID, courseID);

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false); // Start transaction
            boolean success = enrollCourse(userID, courseID, conn);
            if (success) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            logger.error("Error in enrollCourse for userID {} and courseID {}: {}", userID, courseID, e.getMessage(), e);
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                logger.error("Rollback failed: {}", rollbackEx.getMessage(), rollbackEx);
            }
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                logger.error("Error closing connection: {}", e.getMessage(), e);
            }
        }
    }

    public String enrollCourseAndGetID(String userID, String courseID) throws SQLException {
        logger.info("Attempting to enroll user {} in course {} and return enrollment ID", userID, courseID);

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Get studentID from userID
            String getStudentSQL = "SELECT studentID FROM Student WHERE userID = ?";
            String studentID;
            try (PreparedStatement pre = conn.prepareStatement(getStudentSQL)) {
                pre.setString(1, userID);
                try (ResultSet rs = pre.executeQuery()) {
                    if (rs.next()) {
                        studentID = rs.getString("studentID");
                    } else {
                        logger.error("No student found for userID: {}", userID);
                        return null;
                    }
                }
            }

            // Check for duplicate enrollment
            if (isCourseEnrolled(studentID, courseID)) {
                logger.warn("Student {} is already enrolled in course {}", studentID, courseID);
                return null;
            }

            CourseEnrollment enrollment = new CourseEnrollment();
            enrollment.setStudentID(studentID);
            enrollment.setCourseID(courseID);
            enrollment.setEnrollmentDate(Date.valueOf(LocalDate.now()));

            String generatedID = addCourseEnrollment(enrollment, conn);
            if (generatedID != null) {
                conn.commit();
                logger.info("Successfully enrolled student {} in course {} with enrollmentID {}", studentID, courseID, generatedID);
                return generatedID;
            } else {
                conn.rollback();
                logger.error("Failed to enroll student {} in course {}. addCourseEnrollment returned null.", studentID, courseID);
                return null;
            }
        } catch (SQLException e) {
            logger.error("Error in enrollCourseAndGetID for userID {} and courseID {}: {}", userID, courseID, e.getMessage(), e);
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                logger.error("Rollback failed: {}", rollbackEx.getMessage(), rollbackEx);
            }
            throw e; // Re-throw SQLException to be handled by caller
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                logger.error("Error closing connection: {}", e.getMessage(), e);
            }
        }
    }

    public List<Course> getEnrolledCoursesByUserID(String userID) {
        List<Course> enrolledCourses = new ArrayList<>();
        String sql = "SELECT c.courseID, c.title, c.description, c.fee, c.duration, c.imageUrl, c.startDate, c.endDate, c.isActive "
                + "FROM Course_Enrollments ce "
                + "JOIN Courses c ON ce.courseID = c.courseID "
                + "JOIN Student s ON ce.studentID = s.studentID "
                + "WHERE s.userID = ? "
                + "ORDER BY ce.enrollmentDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course(
                            rs.getString("courseID"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getDouble("fee"),
                            rs.getObject("duration") != null ? rs.getInt("duration") : null,
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
        String sql = "SELECT COUNT(*) FROM Course_Enrollments ce "
                + "JOIN Student s ON ce.studentID = s.studentID "
                + "WHERE s.userID = ? AND ce.courseID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
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

    private String addCourseEnrollment(CourseEnrollment enrollment, Connection conn) throws SQLException {
        String sql = "INSERT INTO Course_Enrollments (enrollmentID, studentID, courseID, enrollmentDate) VALUES (?, ?, ?, ?)";
        String generatedEnrollmentID = generateNextEnrollmentID(conn);

        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, generatedEnrollmentID);
            pre.setString(2, enrollment.getStudentID());
            pre.setString(3, enrollment.getCourseID());
            pre.setDate(4, enrollment.getEnrollmentDate());

            int affectedRows = pre.executeUpdate();
            if (affectedRows > 0) {
                return generatedEnrollmentID;
            }
            return null;
        }
    }

    private String generateNextEnrollmentID(Connection conn) throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(enrollmentID, 2) AS UNSIGNED)) AS maxID FROM Course_Enrollments";
        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            int maxID = 0;
            if (rs.next()) {
                maxID = rs.getInt("maxID");
            }
            return String.format("E%03d", maxID + 1);
        }
    }

    public int getEnrollmentCount(String courseID) {
        String sql = "SELECT COUNT(*) FROM Course_Enrollments WHERE courseID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, courseID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    logger.debug("CourseEnrollmentDAO: Enrollment count for courseID {}: {}", courseID, count);
                    return count;
                }
            }
        } catch (SQLException e) {
            logger.error("CourseEnrollmentDAO: Error in getEnrollmentCount for courseID {}: {}", courseID, e.getMessage(), e);
        }
        return 0;
    }

    public void closeConnection() {
        dbContext.closeConnection();
        logger.info("CourseEnrollmentDAO: Connection closed!");
    }
}