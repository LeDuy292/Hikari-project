package dao;

import model.CourseEntrollment; 
import utils.DBContext; 

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date; 
import java.util.ArrayList;
import java.util.List;

public class CourseEnrollmentDAO {

    public boolean insertEnrollment(CourseEntrollment enrollment) {
        String sql = "INSERT INTO Course_Enrollments (enrollmentID, studentID, courseID, enrollmentDate, completionDate) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, enrollment.getEnrollmentID());
            stmt.setString(2, enrollment.getStudentID());
            stmt.setString(3, enrollment.getCourseID());
            stmt.setDate(4, new Date(enrollment.getEnrollmentDate().getTime())); 
            
            if (enrollment.getCompleteDate() != null) {
                stmt.setDate(5, new Date(enrollment.getCompleteDate().getTime()));
            } else {
                stmt.setNull(5, java.sql.Types.DATE);
            }

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error inserting enrollment: " + e.getMessage());
        }
        return false;
    }

    public CourseEntrollment getEnrollmentByID(String enrollmentID) {
        String sql = "SELECT enrollmentID, studentID, courseID, enrollmentDate, completionDate FROM Course_Enrollments WHERE enrollmentID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, enrollmentID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCourseEnrollment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting enrollment by ID: " + e.getMessage());
        }
        return null;
    }


    public CourseEntrollment getEnrollmentByStudentAndCourse(String studentID, String courseID) {
        String sql = "SELECT enrollmentID, studentID, courseID, enrollmentDate, completionDate FROM Course_Enrollments WHERE studentID = ? AND courseID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentID);
            stmt.setString(2, courseID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToCourseEnrollment(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting enrollment by student and course: " + e.getMessage());
        }
        return null;
    }

    public List<CourseEntrollment> getAllEnrollments() {
        List<CourseEntrollment> enrollmentList = new ArrayList<>();
        String sql = "SELECT enrollmentID, studentID, courseID, enrollmentDate, completionDate FROM Course_Enrollments";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                enrollmentList.add(mapResultSetToCourseEnrollment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting all enrollments: " + e.getMessage());
        }
        return enrollmentList;
    }


    public boolean updateEnrollment(CourseEntrollment enrollment) {
        String sql = "UPDATE Course_Enrollments SET studentID = ?, courseID = ?, enrollmentDate = ?, completionDate = ? WHERE enrollmentID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, enrollment.getStudentID());
            stmt.setString(2, enrollment.getCourseID());
            stmt.setDate(3, new Date(enrollment.getEnrollmentDate().getTime()));
            
            if (enrollment.getCompleteDate() != null) {
                stmt.setDate(4, new Date(enrollment.getCompleteDate().getTime()));
            } else {
                stmt.setNull(4, java.sql.Types.DATE);
            }
            stmt.setString(5, enrollment.getEnrollmentID());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error updating enrollment: " + e.getMessage());
        }
        return false;
    }


    public boolean deleteEnrollment(String enrollmentID) {
        String sql = "DELETE FROM Course_Enrollments WHERE enrollmentID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, enrollmentID);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error deleting enrollment: " + e.getMessage());
        }
        return false;
    }


    private CourseEntrollment mapResultSetToCourseEnrollment(ResultSet rs) throws SQLException {
        CourseEntrollment enrollment = new CourseEntrollment();
        enrollment.setEnrollmentID(rs.getString("enrollmentID"));
        enrollment.setStudentID(rs.getString("studentID"));
        enrollment.setCourseID(rs.getString("courseID"));
        enrollment.setEnrollmentDate(rs.getDate("enrollmentDate"));
        enrollment.setCompleteDate(rs.getDate("completionDate"));
        return enrollment;
    }
    public static void main(String[] args) {
        CourseEnrollmentDAO dao  = new CourseEnrollmentDAO();
        System.out.println(dao.getEnrollmentByStudentAndCourse("S002", "CO001"));
    }
}