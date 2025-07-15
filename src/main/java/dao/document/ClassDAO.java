package dao.document;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ClassRoom;
import utils.DBContext;


/**
 *
 * @author ADMIN
 */
public class ClassDAO extends DBContext {

    public List<ClassRoom> getClassByTeacherID(String teacherID) {
        List<ClassRoom> classes = new ArrayList<>();
        String sql = "SELECT * FROM Class WHERE teacherID = ?";
        try (Connection connection = new DBContext().getConnection(); PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, teacherID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                classes.add(new ClassRoom(
                        rs.getString("classID"),
                        rs.getString("courseID"),
                        rs.getString("name"),
                        rs.getString("teacherID"),
                        rs.getInt("numberOfStudents")));
            }
        } catch (Exception e) {
            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, "Lỗi khi lấy lớp học cho teacherID: " + teacherID, e);
        }
        return classes;
    }

    public List<ClassRoom> getClassByStudentID(String studentID) {
        List<ClassRoom> classes = new ArrayList<>();
        String sql = "SELECT c.* FROM Class c JOIN Class_Students cs ON c.classID = cs.classID WHERE cs.studentID = ?";
        try (Connection connection = new DBContext().getConnection(); PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                classes.add(new ClassRoom(
                        rs.getString("classID"),
                        rs.getString("courseID"),
                        rs.getString("name"),
                        rs.getString("teacherID"),
                        rs.getInt("numberOfStudents")));
            }
        } catch (Exception e) {
            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, "Lỗi khi lấy lớp học cho studentID: " + studentID, e);
        }
        return classes;
    }

    public ClassRoom getClassById(String classId) {
        String sql = "SELECT * FROM Class WHERE classID = ?";
        try (Connection connection = new DBContext().getConnection(); PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, classId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return new ClassRoom(
                        rs.getString("classID"),
                        rs.getString("courseID"),
                        rs.getString("name"),
                        rs.getString("teacherID"),
                        rs.getInt("numberOfStudents"));
            }
        } catch (Exception e) {
            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, "Lỗi khi lấy lớp học với classID: " + classId, e);
        }
        return null;
    }

    public boolean isStudentInClass(String studentID, String classId) {
        String sql = "SELECT COUNT(*) FROM Class_Students WHERE studentID = ? AND classID = ?";
        try (Connection connection = new DBContext().getConnection(); PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            pstmt.setString(2, classId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, "Lỗi khi kiểm tra studentID: " + studentID + " trong classID: " + classId, e);
        }
        return false;
    }

    public List<ClassRoom> getAllClasses() {
        List<ClassRoom> classes = new ArrayList<>();
        String sql = "SELECT * FROM Class";
        try (Connection connection = new DBContext().getConnection(); PreparedStatement pstmt = connection.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                classes.add(new ClassRoom(
                        rs.getString("classID"),
                        rs.getString("courseID"),
                        rs.getString("name"),
                        rs.getString("teacherID"),
                        rs.getInt("numberOfStudents")));
            }
        } catch (Exception e) {
            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, "Lỗi khi lấy tất cả lớp học", e);
        }
        return classes;
    }

    public List<ClassRoom> searchClassesByName(String searchTerm) {
        List<ClassRoom> classes = new ArrayList<>();
        if (searchTerm == null || searchTerm.trim().isEmpty()) {
            return classes;
        }
        String sql = "SELECT * FROM Class WHERE name LIKE ? OR courseID LIKE ?";
        try (Connection connection = new DBContext().getConnection(); PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, "%" + searchTerm.trim() + "%");
            pstmt.setString(2, "%" + searchTerm.trim() + "%");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                classes.add(new ClassRoom(
                        rs.getString("classID"),
                        rs.getString("courseID"),
                        rs.getString("name"),
                        rs.getString("teacherID"),
                        rs.getInt("numberOfStudents")));
            }
        } catch (Exception e) {
            Logger.getLogger(ClassDAO.class.getName()).log(Level.SEVERE, "Lỗi khi tìm kiếm lớp học: " + e.getMessage(), e);
        }
        return classes;
    }

    public static void main(String[] args) {
        ClassDAO dao = new ClassDAO();
        System.out.println(dao.getClassByTeacherID("T002"));
        System.out.println(dao.getClassByStudentID("S001"));
        System.out.println(dao.getClassById("CL001"));
    }
}
