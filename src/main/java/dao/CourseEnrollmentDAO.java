package dao;

import model.CourseEnrollment;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;

public class CourseEnrollmentDAO {
  private Connection con;

  public CourseEnrollmentDAO() {
      DBContext dBContext = new DBContext();
      try {
          con = dBContext.getConnection();
          System.out.println("CourseEnrollmentDAO: KET NOI THANH CONG!");
      } catch (Exception e) {
          System.err.println("CourseEnrollmentDAO: Error connecting to database: " + e);
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
          System.err.println("Error in isCourseEnrolled: " + e.getMessage());
      }
      return false;
  }

  public String addCourseEnrollment(CourseEnrollment enrollment) {
      String sql = "INSERT INTO Course_Enrollments (enrollmentID, studentID, courseID, enrollmentDate) VALUES (?, ?, ?, ?)";
      String generatedEnrollmentID = null;
      try {
          // Generate a unique enrollmentID (e.g., E001, E002...)
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
          System.err.println("Error in addCourseEnrollment: " + e.getMessage());
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
              System.out.println("CourseEnrollmentDAO: KET NOI DA DONG!");
          }
      } catch (SQLException e) {
          System.err.println("Error closing connection in CourseEnrollmentDAO: " + e);
      }
  }

    public String addCourseEnrollment(CourseEnrollment enrollment, Connection conn) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
