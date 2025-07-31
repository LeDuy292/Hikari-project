package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ClassInfo;
import model.ClassRoom;
import utils.DBContext;

public class ClassDAO {

    // Lấy danh sách lớp theo teacherID
    public List<ClassRoom> getClassByTeacherID(String teacherID) {
        List<ClassRoom> classes = new ArrayList<>();
        String sql = "SELECT * FROM Class WHERE teacherID = ?";

        try (Connection connection = new DBContext().getConnection(); PreparedStatement pstmt = connection.prepareStatement(sql)) {

            pstmt.setString(1, teacherID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    classes.add(new ClassRoom(
                            rs.getString("classID"),
                            rs.getString("courseID"),
                            rs.getString("name"),
                            rs.getString("teacherID"),
                            rs.getInt("numberOfStudents")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error at getClassByTeacherID: " + e.getMessage());
        }

        return classes;
    }
    // Get all classes by teacher ID

    public List<ClassInfo> getClassesByTeacher(String teacherID) {
        List<ClassInfo> classes = new ArrayList<>();
        String sql = "SELECT c.classID, c.courseID, c.name, c.teacherID,\n"
                + "       co.title AS courseTitle, co.description AS courseDescription,\n"
                + "       co.duration AS courseDuration, co.startDate, co.endDate,\n"
                + "       u.fullName AS teacherName, t.specialization AS teacherSpecialization,\n"
                + "       u.email AS teacherEmail,\n"
                + "       c.numberOfStudents\n"
                + "FROM Class c\n"
                + "LEFT JOIN Courses co ON c.courseID = co.courseID\n"
                + "LEFT JOIN Teacher t ON c.teacherID = t.teacherID\n"
                + "LEFT JOIN UserAccount u ON t.userID = u.userID\n"
                + "WHERE c.teacherID = ?\n"
                + "GROUP BY c.classID, c.courseID, c.name, c.teacherID,\n"
                + "         co.title, co.description, co.duration, co.startDate, co.endDate,\n"
                + "         u.fullName, t.specialization, u.email, c.numberOfStudents\n"
                + "ORDER BY c.name";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, teacherID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ClassInfo classInfo = mapResultSetToClassInfo(rs);
                classes.add(classInfo);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classes;
    }

    // Get classes with search functionality
    public List<ClassInfo> searchClassesByTeacher(String teacherID, String searchTerm) {
        List<ClassInfo> classes = new ArrayList<>();
        String sql
                = " SELECT c.classID, c.courseID, c.name, c.teacherID,\n"
                + "       co.title AS courseTitle, co.description AS courseDescription,\n"
                + "       co.duration AS courseDuration,\n"
                + "       u.fullName AS teacherName, t.specialization AS teacherSpecialization,\n"
                + "       u.email AS teacherEmail,\n"
                + "       COUNT(cs.studentID) AS numberOfStudents\n"
                + "FROM Class c\n"
                + "LEFT JOIN Courses co ON c.courseID = co.courseID\n"
                + "LEFT JOIN Teacher t ON c.teacherID = t.teacherID\n"
                + "LEFT JOIN UserAccount u ON t.userID = u.userID\n"
                + "LEFT JOIN Class_Students cs ON c.classID = cs.classID\n"
                + "WHERE c.classID = ?\n"
                + "GROUP BY c.classID, c.courseID, c.name, c.teacherID,\n"
                + "         co.title, co.description, co.duration,\n"
                + "         u.fullName, t.specialization, u.email";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, teacherID);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ClassInfo classInfo = mapResultSetToClassInfo(rs);
                classes.add(classInfo);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classes;
    }

    // Get class info by ID
    public ClassInfo getClassInfoById(String classID) {
        String sql = "SELECT c.classID, c.courseID, c.name, c.teacherID,\n"
                + "       co.title AS courseTitle, co.description AS courseDescription,\n"
                + "       co.duration AS courseDuration,\n"
                + "       u.fullName AS teacherName, t.specialization AS teacherSpecialization,\n"
                + "       u.email AS teacherEmail,\n"
                + "       COUNT(cs.studentID) AS numberOfStudents\n"
                + "FROM Class c\n"
                + "LEFT JOIN Courses co ON c.courseID = co.courseID\n"
                + "LEFT JOIN Teacher t ON c.teacherID = t.teacherID\n"
                + "LEFT JOIN UserAccount u ON t.userID = u.userID\n"
                + "LEFT JOIN Class_Students cs ON c.classID = cs.classID\n"
                + "WHERE c.classID = ?\n"
                + "GROUP BY c.classID, c.courseID, c.name, c.teacherID,\n"
                + "         co.title, co.description, co.duration,\n"
                + "         u.fullName, t.specialization, u.email";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, classID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToClassInfo(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Check if teacher owns the class
    public boolean isTeacherOfClass(String teacherID, String classID) {
        String sql = "SELECT COUNT(*) FROM Class WHERE classID = ? AND teacherID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, classID);
            stmt.setString(2, teacherID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    public boolean addClass(ClassRoom classRoom) {
        String sql = "INSERT INTO Class (classID, courseID, name, teacherID, numberOfStudents) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, classRoom.getClassID());
            pstmt.setString(2, classRoom.getCourseID());
            pstmt.setString(3, classRoom.getName());
            pstmt.setString(4, classRoom.getTeacherID());
            pstmt.setInt(5, classRoom.getNumberOfStudents());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding class: " + e.getMessage());
            return false;
        }
    }
    
    
    public boolean updateClass(ClassRoom classRoom) {
        String sql = "UPDATE Class SET courseID = ?, name = ?, teacherID = ?, numberOfStudents = ? WHERE classID = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, classRoom.getCourseID());
            pstmt.setString(2, classRoom.getName());
            pstmt.setString(3, classRoom.getTeacherID());
            pstmt.setInt(4, classRoom.getNumberOfStudents());
            pstmt.setString(5, classRoom.getClassID());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating class: " + e.getMessage());
            return false;
        }
    }
    

    public boolean deleteClass(String classID) {
        String sql = "DELETE FROM Class WHERE classID = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, classID);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting class: " + e.getMessage());
            return false;
        }
    }
    
    // Helper method to map ResultSet to ClassInfo
    private ClassInfo mapResultSetToClassInfo(ResultSet rs) throws SQLException {
        ClassInfo classInfo = new ClassInfo();

        classInfo.setClassID(rs.getString("classID"));
        classInfo.setCourseID(rs.getString("courseID"));
        classInfo.setName(rs.getString("name"));
        classInfo.setTeacherID(rs.getString("teacherID"));
        classInfo.setCourseTitle(rs.getString("courseTitle"));
        classInfo.setCourseDescription(rs.getString("courseDescription"));
        classInfo.setCourseDuration(rs.getInt("courseDuration"));
        classInfo.setTeacherName(rs.getString("teacherName"));
        classInfo.setTeacherSpecialization(rs.getString("teacherSpecialization"));
        classInfo.setTeacherEmail(rs.getString("teacherEmail"));
        classInfo.setNumberOfStudents(rs.getInt("numberOfStudents"));

        return classInfo;
    }

 
    public static String findAvailableClass(Connection conn, String courseId) throws SQLException {
        String sql = "SELECT classID, numberOfStudents "
                + "FROM Class "
                + "WHERE courseID = ?"
                + "ORDER BY numberOfStudents ASC "
                + "LIMIT 1 FOR UPDATE"; // Lock the row for update to prevent race conditions

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, courseId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("classID");
                }
            }
        }
        return null;
    }

 
    public static boolean enrollStudentInClass(Connection conn, String classId, String studentId) throws SQLException {
        // First, check if student is already in the class
        String checkSql = "SELECT 1 FROM Class_Students WHERE classID = ? AND studentID = ?";
        try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            checkStmt.setString(1, classId);
            checkStmt.setString(2, studentId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    // Student already in class
                    return true;
                }
            }
        }

        // Add student to class
        String enrollSql = "INSERT INTO Class_Students (classID, studentID, joinDate) VALUES (?, ?, CURRENT_DATE)";
        try (PreparedStatement enrollStmt = conn.prepareStatement(enrollSql)) {
            enrollStmt.setString(1, classId);
            enrollStmt.setString(2, studentId);
            int rowsAffected = enrollStmt.executeUpdate();

            if (rowsAffected > 0) {
                // Update student count in Class table
                String updateSql = "UPDATE Class SET numberOfStudents = numberOfStudents + 1 WHERE classID = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setString(1, classId);
                    return updateStmt.executeUpdate() > 0;
                }
            }
        }
        return false;
    }
    

    public static void main(String[] args) throws SQLException {
        ClassDAO dao = new ClassDAO();
//        System.out.println(dao.getClassByTeacherID("T001"));
//        System.out.println(dao.getClassesByTeacher("T002"));

        // Test find available class
        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                String classId = dao.findAvailableClass(conn, "CO013");
                System.out.println("Available class: " + classId);
                conn.rollback(); // Don't commit test transaction
            } catch (SQLException e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        DBContext db = new DBContext();
        Connection con = db.getConnection();
        boolean assigned = ClassDAO.enrollStudentInClass(con, "CL005", "S015");
    }
}
