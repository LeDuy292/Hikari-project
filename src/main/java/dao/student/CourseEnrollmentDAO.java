package dao.student;

import model.student.CourseEnrollment;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.time.LocalDate; // Import LocalDate for current date
import org.slf4j.Logger; // Import Logger
import org.slf4j.LoggerFactory; // Import LoggerFactory

public class CourseEnrollmentDAO {
  private static final Logger logger = LoggerFactory.getLogger(CourseEnrollmentDAO.class); // Logger instance
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

  // New method to enroll a course, called from CartServlet
  public boolean enrollCourse(String studentID, String courseID) {
      logger.info("Attempting to enroll student {} in course {}", studentID, courseID);
      CourseEnrollment enrollment = new CourseEnrollment();
      enrollment.setStudentID(studentID);
      enrollment.setCourseID(courseID);
      enrollment.setEnrollmentDate(Date.valueOf(LocalDate.now())); // Set current date

      String generatedID = addCourseEnrollment(enrollment);
      if (generatedID != null) {
          logger.info("Successfully enrolled student {} in course {} with enrollmentID {}", studentID, courseID, generatedID);
          return true;
      } else {
          logger.error("Failed to enroll student {} in course {}. addCourseEnrollment returned null.", studentID, courseID);
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
          logger.error("Error in addCourseEnrollment for studentID {} and courseID {}: {}", enrollment.getStudentID(), enrollment.getCourseID(), e.getMessage(), e);
      }
      return null;
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
