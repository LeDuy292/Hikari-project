package dao;

import model.StudentInfo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class StudentDAO {
    
    // Get all students in a class
    public List<StudentInfo> getStudentsByClass(String classID) {
        List<StudentInfo> students = new ArrayList<>();
        String sql = " SELECT s.studentID, s.userID, u.fullName, u.email, u.phone, u.profilePicture,\n" +
"                   s.enrollmentDate\n" +
"            FROM Student s\n" +
"            INNER JOIN Class_Students cs ON s.studentID = cs.studentID\n" +
"            INNER JOIN UserAccount u ON s.userID = u.userID\n" +
"            WHERE cs.classID = ? \n" +
"            ORDER BY u.fullName"
           
        ;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, classID);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                StudentInfo student = mapResultSetToStudentInfo(rs);
                students.add(student);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    // Search students in a class
    public List<StudentInfo> searchStudentsByClass(String classID, String searchTerm) {
        List<StudentInfo> students = new ArrayList<>();
        String sql = "SELECT s.studentID, s.userID, u.fullName, u.email, u.phone, u.profilePicture,\n" +
"                   s.enrollmentDate\n" +
"            FROM Student s\n" +
"            INNER JOIN Class_Students cs ON s.studentID = cs.studentID\n" +
"            INNER JOIN UserAccount u ON s.userID = u.userID\n" +
"            WHERE cs.classID = ? \n" +
"            AND (LOWER(u.fullName) LIKE LOWER(?) \n" +
"                 OR LOWER(u.email) LIKE LOWER(?) \n" +
"                 OR LOWER(s.studentID) LIKE LOWER(?))\n" +
"            ORDER BY u.fullName"
            
        ;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, classID);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                StudentInfo student = mapResultSetToStudentInfo(rs);
                students.add(student);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    // Get student by ID
    public StudentInfo getStudentById(String studentID) {
        String sql = " SELECT s.studentID, s.userID, u.fullName, u.email, u.phone, u.profilePicture,\n" +
"                   s.enrollmentDate\n" +
"            FROM Student s\n" +
"            INNER JOIN UserAccount u ON s.userID = u.userID\n" +
"            WHERE s.studentID = ?"
           
        ;
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, studentID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToStudentInfo(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Helper method to map ResultSet to StudentInfo
    private StudentInfo mapResultSetToStudentInfo(ResultSet rs) throws SQLException {
        StudentInfo student = new StudentInfo();
        
        student.setStudentID(rs.getString("studentID"));
        student.setUserID(rs.getString("userID"));
        student.setFullName(rs.getString("fullName"));
        student.setEmail(rs.getString("email"));
        student.setPhone(rs.getString("phone"));
        student.setProfilePicture(rs.getString("profilePicture"));
        student.setEnrollmentDate(rs.getDate("enrollmentDate"));
        
        return student;
    }
    
     public String getStudentIdByUserId(String userID) {
        if (userID == null || userID.trim().isEmpty()) {
            return null;
        }
        
        String sql = "SELECT studentID FROM Student WHERE userID = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, userID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getString("studentID");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
     
    public static void main(String[] args) {
        StudentDAO dao = new StudentDAO();
        System.out.println(dao.getStudentsByClass("CL001"));
        System.out.println(dao.getStudentById("S003"));
        System.out.println(dao.getStudentIdByUserId("U003"));
    }
}
