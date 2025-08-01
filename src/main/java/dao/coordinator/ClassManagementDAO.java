/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.coordinator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Class;
import model.Teacher;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ClassManagementDAO {
    private static final Logger logger = LoggerFactory.getLogger(ClassManagementDAO.class);
    private Connection con;

    public ClassManagementDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            logger.info("ClassManagementDAO: Database connection established successfully.");
        } catch (Exception e) {
            logger.error("ClassManagementDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    /**
     * Lấy danh sách tất cả lớp học theo courseID
     */
    public List<Class> getClassesByCourseID(String courseID) {
        String sql = "SELECT c.classID, c.courseID, c.name, c.teacherID, c.numberOfStudents, " +
                    "u.fullName as teacherName " +
                    "FROM Class c " +
                    "LEFT JOIN Teacher t ON c.teacherID = t.teacherID " +
                    "LEFT JOIN UserAccount u ON t.userID = u.userID " +
                    "WHERE c.courseID = ? " +
                    "ORDER BY c.classID";
        
        List<Class> classList = new ArrayList<>();
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    Class classObj = new Class();
                    classObj.setClassID(rs.getString("classID"));
                    classObj.setCourseID(rs.getString("courseID"));
                    classObj.setName(rs.getString("name"));
                    classObj.setTeacherID(rs.getString("teacherID"));
                    classObj.setNumberOfStudents(rs.getInt("numberOfStudents"));
                    classObj.setTeacherName(rs.getString("teacherName"));
                    classList.add(classObj);
                }
            }
            logger.debug("Retrieved {} classes for course {}", classList.size(), courseID);
        } catch (SQLException e) {
            logger.error("Error getting classes by courseID {}: {}", courseID, e.getMessage(), e);
        }
        
        return classList;
    }

    /**
     * Lấy danh sách tất cả giảng viên
     */
    public List<Teacher> getAllTeachers() {
        String sql = "SELECT t.teacherID, t.userID, t.specialization, t.experienceYears, u.fullName " +
                    "FROM Teacher t JOIN UserAccount u ON t.userID = u.userID " +
                    "ORDER BY u.fullName";
        
        List<Teacher> teacherList = new ArrayList<>();
        
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            
            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setTeacherID(rs.getString("teacherID"));
                teacher.setUserID(rs.getString("userID"));
                teacher.setSpecialization(rs.getString("specialization"));
                teacher.setExperienceYears(rs.getInt("experienceYears"));
                teacher.setFullName(rs.getString("fullName"));
                teacherList.add(teacher);
            }
            logger.debug("Retrieved {} teachers", teacherList.size());
        } catch (SQLException e) {
            logger.error("Error getting all teachers: {}", e.getMessage(), e);
        }
        
        return teacherList;
    }

    /**
     * Tự động tạo ClassID mới
     */
    public String generateNewClassID() {
        String sql = "SELECT MAX(CAST(SUBSTRING(classID, 3) AS UNSIGNED)) as maxNum FROM Class WHERE classID REGEXP '^CL[0-9]{3}$'";
        
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            
            if (rs.next()) {
                int maxNum = rs.getInt("maxNum");
                int newNum = maxNum + 1;
                return String.format("CL%03d", newNum);
            } else {
                return "CL001"; // Nếu chưa có lớp nào
            }
        } catch (SQLException e) {
            logger.error("Error generating new ClassID: {}", e.getMessage(), e);
            return "CL001"; // Fallback
        }
    }

    /**
     * Thêm lớp học mới
     */
    public boolean addClass(Class classObj) {
        String sql = "INSERT INTO Class (classID, courseID, name, teacherID, numberOfStudents) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, classObj.getClassID());
            pre.setString(2, classObj.getCourseID());
            pre.setString(3, classObj.getName());
            pre.setString(4, classObj.getTeacherID());
            pre.setInt(5, classObj.getNumberOfStudents());
            
            int rowsAffected = pre.executeUpdate();
            if (rowsAffected > 0) {
                logger.info("Successfully added class: {}", classObj.getClassID());
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error adding class {}: {}", classObj.getClassID(), e.getMessage(), e);
        }
        
        return false;
    }

    /**
     * Cập nhật thông tin lớp học
     */
    public boolean updateClass(Class classObj) {
        String sql = "UPDATE Class SET name = ?, teacherID = ? WHERE classID = ?";
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, classObj.getName());
            pre.setString(2, classObj.getTeacherID());
            pre.setString(3, classObj.getClassID());
            
            int rowsAffected = pre.executeUpdate();
            if (rowsAffected > 0) {
                logger.info("Successfully updated class: {}", classObj.getClassID());
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error updating class {}: {}", classObj.getClassID(), e.getMessage(), e);
        }
        
        return false;
    }

    /**
     * Xóa lớp học
     */
    public boolean deleteClass(String classID) {
        String sql = "DELETE FROM Class WHERE classID = ?";
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, classID);
            
            int rowsAffected = pre.executeUpdate();
            if (rowsAffected > 0) {
                logger.info("Successfully deleted class: {}", classID);
                return true;
            }
        } catch (SQLException e) {
            logger.error("Error deleting class {}: {}", classID, e.getMessage(), e);
        }
        
        return false;
    }

    /**
     * Kiểm tra xem tên lớp đã tồn tại trong khóa học chưa
     */
    public boolean isClassNameExists(String courseID, String className, String excludeClassID) {
        String sql = "SELECT COUNT(*) FROM Class WHERE courseID = ? AND name = ? AND classID != ?";
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            pre.setString(2, className);
            pre.setString(3, excludeClassID != null ? excludeClassID : "");
            
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error checking class name existence: {}", e.getMessage(), e);
        }
        
        return false;
    }

    /**
     * Lấy thông tin lớp học theo ID
     */
    public Class getClassByID(String classID) {
        String sql = "SELECT c.classID, c.courseID, c.name, c.teacherID, c.numberOfStudents, " +
                    "u.fullName as teacherName " +
                    "FROM Class c " +
                    "LEFT JOIN Teacher t ON c.teacherID = t.teacherID " +
                    "LEFT JOIN UserAccount u ON t.userID = u.userID " +
                    "WHERE c.classID = ?";
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, classID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    Class classObj = new Class();
                    classObj.setClassID(rs.getString("classID"));
                    classObj.setCourseID(rs.getString("courseID"));
                    classObj.setName(rs.getString("name"));
                    classObj.setTeacherID(rs.getString("teacherID"));
                    classObj.setNumberOfStudents(rs.getInt("numberOfStudents"));
                    classObj.setTeacherName(rs.getString("teacherName"));
                    return classObj;
                }
            }
        } catch (SQLException e) {
            logger.error("Error getting class by ID {}: {}", classID, e.getMessage(), e);
        }
        
        return null;
    }

    /**
     * Kiểm tra giảng viên có tồn tại không
     */
    public boolean isTeacherExists(String teacherID) {
        String sql = "SELECT COUNT(*) FROM Teacher WHERE teacherID = ?";
        
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, teacherID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error checking teacher existence: {}", e.getMessage(), e);
        }
        
        return false;
    }

    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("ClassManagementDAO: Database connection closed.");
            }
        } catch (SQLException e) {
            logger.error("ClassManagementDAO: Error closing connection: {}", e.getMessage(), e);
        }
    }
}
