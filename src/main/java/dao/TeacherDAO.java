/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Class;
import model.Teacher;
import model.coordinator.Student;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author LENOVO
 */
public class TeacherDAO {

    private static final Logger logger = LoggerFactory.getLogger(TeacherDAO.class);
    Connection con;

    public TeacherDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            System.out.println("KET NOI THANH CONG!");
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    public List<Teacher> getAllTeachers() {
        String sql = "SELECT t.teacherID, t.userID, t.specialization, t.experienceYears, u.fullName "
                + "FROM Teacher t JOIN UserAccount u ON t.userID = u.userID";
        List<Teacher> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql); ResultSet resultSet = pre.executeQuery()) {
            while (resultSet.next()) {
                String teacherID = resultSet.getString("teacherID");
                String userID = resultSet.getString("userID");
                String specialization = resultSet.getString("specialization");
                int experienceYears = resultSet.getInt("experienceYears");
                String fullName = resultSet.getString("fullName");

                Teacher teacher = new Teacher();
                teacher.setTeacherID(teacherID);
                teacher.setUserID(userID);
                teacher.setSpecialization(specialization);
                teacher.setExperienceYears(experienceYears);
                teacher.setFullName(fullName);

                list.add(teacher);
            }
        } catch (Exception e) {
            System.out.println("error getAllTeachers: " + e);
        }
        return list;
    }

    public Teacher getTeacherProfile(String userID) {
        Teacher teacherProfile = new Teacher();
        String query = "SELECT u.userID, u.fullName, u.username, u.email, u.phone, u.birthDate, u.profilePicture, "
                + "t.teacherID, t.specialization, t.experienceYears "
                + "FROM UserAccount u JOIN Teacher t ON u.userID = t.userID WHERE u.userID = ?";

        try (
                PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setString(1, userID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                teacherProfile.setUserID(rs.getString("userID"));
                teacherProfile.setFullName(rs.getString("fullName"));
                teacherProfile.setUsername(rs.getString("username"));
                teacherProfile.setEmail(rs.getString("email"));
                teacherProfile.setPhone(rs.getString("phone"));
                teacherProfile.setBirthDate(rs.getDate("birthDate"));
                teacherProfile.setProfilePicture(rs.getString("profilePicture"));
                teacherProfile.setTeacherID(rs.getString("teacherID"));
                teacherProfile.setSpecialization(rs.getString("specialization"));
                teacherProfile.setExperienceYears(rs.getInt("experienceYears"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return teacherProfile;
    }

    public void addTeacher(Teacher teacher) {
        String sql = "INSERT INTO Teacher (teacherID, userID, specialization, experienceYears) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, teacher.getTeacherID());
            pre.setString(2, teacher.getUserID());
            pre.setString(3, teacher.getSpecialization());
            pre.setInt(4, teacher.getExperienceYears());
            pre.executeUpdate();
            logger.info("TeacherDAO: Added new teacher with ID: {}", teacher.getTeacherID());
        } catch (SQLException e) {
            logger.error("TeacherDAO: Error adding teacher {}: {}", teacher.getTeacherID(), e.getMessage(), e);
        }
    }

    public List<Class> getAllClasses() {
        String sql = "SELECT c.classID, c.courseID, c.name, c.teacherID, c.numberOfStudents, "
                + "co.title, co.startDate, co.endDate, u.fullName as teacherName "
                + "FROM Class c "
                + "JOIN Courses co ON c.courseID = co.courseID "
                + "LEFT JOIN Teacher t ON c.teacherID = t.teacherID "
                + "LEFT JOIN UserAccount u ON t.userID = u.userID";
        List<Class> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql); ResultSet resultSet = pre.executeQuery()) {
            while (resultSet.next()) {
                String classID = resultSet.getString("classID");
                String courseID = resultSet.getString("courseID");
                String name = resultSet.getString("name");
                String teacherID = resultSet.getString("teacherID");
                int numberOfStudents = resultSet.getInt("numberOfStudents");
                String courseTitle = resultSet.getString("title");
                Date startDate = resultSet.getDate("startDate");
                Date endDate = resultSet.getDate("endDate");
                String teacherName = resultSet.getString("teacherName");

                Class classObj = new Class();
                classObj.setClassID(classID);
                classObj.setCourseID(courseID);
                classObj.setName(name);
                classObj.setTeacherID(teacherID);
                classObj.setNumberOfStudents(numberOfStudents);
                classObj.setCourseTitle(courseTitle);
                classObj.setStartDate(startDate);
                classObj.setEndDate(endDate);
                classObj.setTeacherName(teacherName);

                list.add(classObj);
            }
        } catch (Exception e) {
            System.out.println("error getAllClasses: " + e);
        }
        return list;
    }

    public List<Class> getClassesByCourseID(String courseID) {
        String sql = "SELECT c.classID, c.courseID, c.name, c.teacherID, c.numberOfStudents, "
                + "co.title, co.startDate, co.endDate, u.fullName as teacherName "
                + "FROM Class c "
                + "JOIN Courses co ON c.courseID = co.courseID "
                + "LEFT JOIN Teacher t ON c.teacherID = t.teacherID "
                + "LEFT JOIN UserAccount u ON t.userID = u.userID "
                + (courseID != null && !courseID.trim().isEmpty() ? "WHERE c.courseID = ?" : "");
        List<Class> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            if (courseID != null && !courseID.trim().isEmpty()) {
                pre.setString(1, courseID);
            }
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    String classID = resultSet.getString("classID");
                    String resultCourseID = resultSet.getString("courseID");
                    String name = resultSet.getString("name");
                    String teacherID = resultSet.getString("teacherID");
                    int numberOfStudents = resultSet.getInt("numberOfStudents");
                    String courseTitle = resultSet.getString("title");
                    Date startDate = resultSet.getDate("startDate");
                    Date endDate = resultSet.getDate("endDate");
                    String teacherName = resultSet.getString("teacherName");

                    Class classObj = new Class();
                    classObj.setClassID(classID);
                    classObj.setCourseID(resultCourseID);
                    classObj.setName(name);
                    classObj.setTeacherID(teacherID);
                    classObj.setNumberOfStudents(numberOfStudents);
                    classObj.setCourseTitle(courseTitle);
                    classObj.setStartDate(startDate);
                    classObj.setEndDate(endDate);
                    classObj.setTeacherName(teacherName);

                    list.add(classObj);
                }
            }
        } catch (Exception e) {
            System.out.println("error getClassesByCourseID: " + e);
        }
        return list;
    }

    public int countClassesByCourseID(String courseID) {
        String sql = "SELECT COUNT(*) FROM Class WHERE courseID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (Exception e) {
            System.out.println("error countClassesByCourseID: " + e);
        }
        return 0;
    }

    public List<Student> getStudentsByClassID(String classID) {
        String sql = "SELECT s.studentID, s.userID, u.fullName AS studentName, u.email, s.enrollmentDate, u.isActive "
                + "FROM Student s "
                + "JOIN Class_Students cs ON s.studentID = cs.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "WHERE cs.classID = ?";
        List<Student> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, classID);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    String studentID = resultSet.getString("studentID");
                    String userID = resultSet.getString("userID");
                    String studentName = resultSet.getString("studentName");
                    String email = resultSet.getString("email");
                    Date enrollmentDate = resultSet.getDate("enrollmentDate");
                    boolean active = resultSet.getBoolean("isActive");

                    Student student = new Student();
                    student.setStudentID(studentID);
                    student.setUserID(userID);
                    student.setStudentName(studentName);
                    student.setEmail(email);
                    student.setEnrollmentDate(enrollmentDate);
                    student.setActive(active);

                    list.add(student);
                }
            }
        } catch (Exception e) {
            System.out.println("error getStudentsByClassID: " + e);
        }
        return list;
    }

    public boolean assignTeacherToClass(String classID, String teacherID) {
        if (classID == null || teacherID == null || classID.trim().isEmpty() || teacherID.trim().isEmpty()) {
            System.out.println("error assignTeacherToClass: Invalid classID or teacherID");
            return false;
        }

        // Validate teacherID existence
        String checkTeacherSql = "SELECT COUNT(*) FROM Teacher WHERE teacherID = ?";
        try (PreparedStatement checkPre = con.prepareStatement(checkTeacherSql)) {
            checkPre.setString(1, teacherID);
            ResultSet rs = checkPre.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                System.out.println("error assignTeacherToClass: TeacherID " + teacherID + " does not exist");
                return false;
            }
        } catch (Exception e) {
            System.out.println("error assignTeacherToClass check teacher: " + e);
            return false;
        }

        // Validate classID existence
        String checkClassSql = "SELECT COUNT(*) FROM Class WHERE classID = ?";
        try (PreparedStatement checkPre = con.prepareStatement(checkClassSql)) {
            checkPre.setString(1, classID);
            ResultSet rs = checkPre.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                System.out.println("error assignTeacherToClass: ClassID " + classID + " does not exist");
                return false;
            }
        } catch (Exception e) {
            System.out.println("error assignTeacherToClass check class: " + e);
            return false;
        }

        String sql = "UPDATE Class SET teacherID = ? WHERE classID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, teacherID);
            pre.setString(2, classID);
            int rowsAffected = pre.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("error assignTeacherToClass: " + e);
            return false;
        }
    }

    public Teacher getTeacherByID(String id) {
        String sql = "SELECT t.teacherID, t.userID, t.specialization, t.experienceYears, u.fullName "
                + "FROM Teacher t JOIN UserAccount u ON t.userID = u.userID "
                + "WHERE t.teacherID = ?";
        Teacher teacher = new Teacher();
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, id);
            ResultSet resultSet = pre.executeQuery();
            if (resultSet.next()) {
                String teacherID = resultSet.getString("teacherID");
                String userID = resultSet.getString("userID");
                String specialization = resultSet.getString("specialization");
                int experienceYears = resultSet.getInt("experienceYears");
                String fullName = resultSet.getString("fullName");

                teacher.setTeacherID(teacherID);
                teacher.setUserID(userID);
                teacher.setSpecialization(specialization);
                teacher.setExperienceYears(experienceYears);
                teacher.setFullName(fullName);
            }
        } catch (Exception e) {
            System.out.println("error getTeacherByID: " + e);
        }
        return teacher;
    }

    public int countAllTeachers() {
        String sql = "SELECT COUNT(*) FROM Teacher";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql); ResultSet resultSet = pre.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("error countAllTeachers: " + e);
        }
        return count;
    }

    public static void main(String[] args) {
        TeacherDAO dao = new TeacherDAO();
//        List<Teacher> listTeacher = dao.getAllTeachers();
//        System.out.println(listTeacher);
//        System.out.println("Test assign:");
//        boolean success = dao.assignTeacherToClass("CL001", "T002");
//        System.out.println("Assign success: " + success);
//        System.out.println(dao.getClassesByCourseID("CO001"));
        System.out.println(dao.getStudentsByClassID("CL001"));
    }

    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
//                logger.info("TeacherDAO: Database connection closed.");
            }
        } catch (SQLException e) {
//            logger.error("TeacherDAO: Error closing connection: {}", e.getMessage(), e);
        }
    }
}
