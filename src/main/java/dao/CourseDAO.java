/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import utils.DBContext;

/**
 * Data Access Object (DAO) for managing Course entities in the database.
 *
 * @author LENOVO
 */
public class CourseDAO {

    private Connection con;

    public CourseDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            System.out.println("KET NOI THANH CONG!");
        } catch (Exception e) {
            System.err.println("Error: " + e);
        }
    }

    public List<Course> getAll() {
        String sql = "SELECT * FROM Courses";
        List<Course> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet resultSet = pre.executeQuery()) {
            while (resultSet.next()) {
                Course course = new Course();
                course.setCourseNum(resultSet.getInt("courseNum"));
                course.setCourseID(resultSet.getString("courseID"));
                course.setTitle(resultSet.getString("title"));
                course.setDescription(resultSet.getString("description"));
                course.setFee(resultSet.getBigDecimal("fee"));
                course.setDuration(resultSet.getInt("duration"));
                course.setStartDate(resultSet.getDate("startDate"));
                course.setEndDate(resultSet.getDate("endDate"));
                course.setActive(resultSet.getBoolean("isActive"));
                course.setImageUrl(resultSet.getString("imageUrl"));
                course.setProgress(resultSet.getBigDecimal("progress") != null ? resultSet.getBigDecimal("progress") : BigDecimal.ZERO);
                course.setInstructor(resultSet.getString("instructorID")); // Adjusted to match database schema
                course.setCategory(resultSet.getString("category"));
                course.setCreatedDate(resultSet.getTimestamp("createdDate")); // Adjusted to match database schema
                list.add(course);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll: " + e);
        }
        return list;
    }

    public void addCourse(Course course) {
        String sql = "INSERT INTO Courses (courseNum, courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl, progress, instructorID, category, createdDate) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, course.getCourseNum());
            pre.setString(2, course.getCourseID());
            pre.setString(3, course.getTitle());
            pre.setString(4, course.getDescription());
            pre.setBigDecimal(5, course.getFee());
            pre.setInt(6, course.getDuration());
            pre.setDate(7, course.getStartDate());
            pre.setDate(8, course.getEndDate());
            pre.setBoolean(9, course.isActive());
            pre.setString(10, course.getImageUrl());
            pre.setBigDecimal(11, course.getProgress());
            pre.setString(12, course.getInstructor()); // Adjusted to match database schema
            pre.setString(13, course.getCategory());
            pre.setTimestamp(14, course.getCreatedDate());
            pre.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error in addCourse: " + e);
        }
    }

    public Course getCourseByID(int id) {
        String sql = "SELECT * FROM Courses WHERE courseNum = ?";
        Course course = null;
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, id);
            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) {
                    course = new Course();
                    course.setCourseNum(resultSet.getInt("courseNum"));
                    course.setCourseID(resultSet.getString("courseID"));
                    course.setTitle(resultSet.getString("title"));
                    course.setDescription(resultSet.getString("description"));
                    course.setFee(resultSet.getBigDecimal("fee"));
                    course.setDuration(resultSet.getInt("duration"));
                    course.setStartDate(resultSet.getDate("startDate"));
                    course.setEndDate(resultSet.getDate("endDate"));
                    course.setActive(resultSet.getBoolean("isActive"));
                    course.setImageUrl(resultSet.getString("imageUrl"));
                    course.setProgress(resultSet.getBigDecimal("progress") != null ? resultSet.getBigDecimal("progress") : BigDecimal.ZERO);
                    course.setInstructor(resultSet.getString("instructorID")); // Adjusted to match database schema
                    course.setCategory(resultSet.getString("category"));
                    course.setCreatedDate(resultSet.getTimestamp("createdDate")); // Adjusted to match database schema
                }
            }
        } catch (Exception e) {
            System.err.println("Error in getCourseByID: " + e);
        }
        return course;
    }

    public void editCourse(Course course) {
        String sql = "UPDATE Courses SET title = ?, description = ?, fee = ?, duration = ?, startDate = ?, endDate = ?, isActive = ?, imageUrl = ?, progress = ?, instructorID = ?, category = ?, createdDate = ? WHERE courseNum = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, course.getTitle());
            pre.setString(2, course.getDescription());
            pre.setBigDecimal(3, course.getFee());
            pre.setInt(4, course.getDuration());
            pre.setDate(5, course.getStartDate());
            pre.setDate(6, course.getEndDate());
            pre.setBoolean(7, course.isActive());
            pre.setString(8, course.getImageUrl());
            pre.setBigDecimal(9, course.getProgress());
            pre.setString(10, course.getInstructor()); // Adjusted to match database schema
            pre.setString(11, course.getCategory());
            pre.setTimestamp(12, course.getCreatedDate());
            pre.setInt(13, course.getCourseNum());
            pre.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error in editCourse: " + e);
        }
    }

    public int countAllCourses() {
        String sql = "SELECT COUNT(*) FROM Courses";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet resultSet = pre.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error in countAllCourses: " + e);
        }
        return count;
    }

    public int countAllCoursesActive() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE isActive = 1";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet resultSet = pre.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error in countAllCoursesActive: " + e);
        }
        return count;
    }

    public List<Course> getAllCoursesByCategory(String category) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE category = ? AND isActive = 1 ORDER BY createdDate DESC";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, category);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseNum(rs.getInt("courseNum"));
                    course.setCourseID(rs.getString("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setFee(rs.getBigDecimal("fee"));
                    course.setDuration(rs.getInt("duration"));
                    course.setStartDate(rs.getDate("startDate"));
                    course.setEndDate(rs.getDate("endDate"));
                    course.setActive(rs.getBoolean("isActive"));
                    course.setImageUrl(rs.getString("imageUrl"));
                    course.setProgress(rs.getBigDecimal("progress") != null ? rs.getBigDecimal("progress") : BigDecimal.ZERO);
                    course.setInstructor(rs.getString("instructorID")); // Adjusted to match database schema
                    course.setCategory(rs.getString("category"));
                    course.setCreatedDate(rs.getTimestamp("createdDate")); // Adjusted to match database schema
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllCoursesByCategory: " + e.getMessage());
        }
        return courses;
    }

    public Course getCourseById(int id) {
        String sql = "SELECT * FROM Courses WHERE courseNum = ? AND isActive = 1";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setCourseNum(rs.getInt("courseNum"));
                    course.setCourseID(rs.getString("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setFee(rs.getBigDecimal("fee"));
                    course.setDuration(rs.getInt("duration"));
                    course.setStartDate(rs.getDate("startDate"));
                    course.setEndDate(rs.getDate("endDate"));
                    course.setActive(rs.getBoolean("isActive"));
                    course.setImageUrl(rs.getString("imageUrl"));
                    course.setProgress(rs.getBigDecimal("progress") != null ? rs.getBigDecimal("progress") : BigDecimal.ZERO);
                    course.setInstructor(rs.getString("instructorID")); // Adjusted to match database schema
                    course.setCategory(rs.getString("category"));
                    course.setCreatedDate(rs.getTimestamp("createdDate")); // Adjusted to match database schema
                    return course;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getCourseById: " + e.getMessage());
        }
        return null;
    }
     public List<Course> searchCoursesAllCategories(String keyword) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE (title LIKE ? OR description LIKE ?) AND isActive = 1 ORDER BY createdDate DESC";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseNum(rs.getInt("courseNum"));
                    course.setCourseID(rs.getString("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setFee(rs.getBigDecimal("fee"));
                    course.setDuration(rs.getInt("duration"));
                    course.setStartDate(rs.getDate("startDate"));
                    course.setEndDate(rs.getDate("endDate"));
                    course.setActive(rs.getBoolean("isActive"));
                    course.setImageUrl(rs.getString("imageUrl"));
                    course.setProgress(rs.getBigDecimal("progress") != null ? rs.getBigDecimal("progress") : BigDecimal.ZERO);
                    course.setInstructor(rs.getString("instructorID"));
                    course.setCategory(rs.getString("category"));
                    course.setCreatedDate(rs.getTimestamp("createdDate"));
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in searchCoursesAllCategories: " + e.getMessage());
        }
        return courses;
    }


    public List<Course> searchCourses(String keyword, String category) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE (title LIKE ? OR description LIKE ?) AND category = ? AND isActive = 1 ORDER BY createdDate DESC";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, category);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseNum(rs.getInt("courseNum"));
                    course.setCourseID(rs.getString("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setFee(rs.getBigDecimal("fee"));
                    course.setDuration(rs.getInt("duration"));
                    course.setStartDate(rs.getDate("startDate"));
                    course.setEndDate(rs.getDate("endDate"));
                    course.setActive(rs.getBoolean("isActive"));
                    course.setImageUrl(rs.getString("imageUrl"));
                    course.setProgress(rs.getBigDecimal("progress") != null ? rs.getBigDecimal("progress") : BigDecimal.ZERO);
                    course.setInstructor(rs.getString("instructorID")); // Adjusted to match database schema
                    course.setCategory(rs.getString("category"));
                    course.setCreatedDate(rs.getTimestamp("createdDate")); // Adjusted to match database schema
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in searchCourses: " + e.getMessage());
        }
        return courses;
    }

    // Phương thức đóng kết nối
    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("KET NOI DA DONG!");
            }
        } catch (Exception e) {
            System.err.println("Error closing connection: " + e);
        }
    }

    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();
        try {
            // Test getAll method
            System.out.println("=== All Courses ===");
            List<Course> courses = dao.getAll();
            if (courses.isEmpty()) {
                System.out.println("No courses found.");
            } else {
                System.out.printf("%-5s %-10s %-30s %-15s %-10s %-12s %-12s %-10s %-15s %-20s%n",
                        "Num", "CourseID", "Title", "Fee", "Duration", "Start Date", "End Date", "Active", "Category", "Created Date");
                System.out.println("-".repeat(100));
                for (Course course : courses) {
                    System.out.printf("%-5d %-10s %-30s %-15.2f %-10d %-12s %-12s %-10b %-15s %-20s%n",
                            course.getCourseNum(),
                            course.getCourseID(),
                            course.getTitle().length() > 30 ? course.getTitle().substring(0, 27) + "..." : course.getTitle(),
                            course.getFee(),
                            course.getDuration(),
                            course.getStartDate() != null ? course.getStartDate() : "N/A",
                            course.getEndDate() != null ? course.getEndDate() : "N/A",
                            course.isActive(),
                            course.getCategory() != null ? course.getCategory() : "N/A",
                            course.getCreatedDate() != null ? course.getCreatedDate() : "N/A");
                }
            }

            // Test getCourseById method
            System.out.println("\n=== Test getCourseById (ID = 1) ===");
            Course course = dao.getCourseById(1);
            if (course != null) {
                System.out.println("Course Number: " + course.getCourseNum());
                System.out.println("Course ID: " + course.getCourseID());
                System.out.println("Title: " + course.getTitle());
                System.out.println("Description: " + (course.getDescription() != null ? course.getDescription() : "N/A"));
                System.out.println("Fee: " + course.getFee());
                System.out.println("Duration: " + course.getDuration() + " hours");
                System.out.println("Start Date: " + (course.getStartDate() != null ? course.getStartDate() : "N/A"));
                System.out.println("End Date: " + (course.getEndDate() != null ? course.getEndDate() : "N/A"));
                System.out.println("Active: " + course.isActive());
                System.out.println("Image URL: " + (course.getImageUrl() != null ? course.getImageUrl() : "N/A"));
                System.out.println("Progress: " + course.getProgress());
                System.out.println("Instructor: " + (course.getInstructor() != null ? course.getInstructor() : "N/A"));
                System.out.println("Category: " + (course.getCategory() != null ? course.getCategory() : "N/A"));
                System.out.println("Created Date: " + (course.getCreatedDate() != null ? course.getCreatedDate() : "N/A"));
            } else {
                System.out.println("No course found with ID 1.");
            }

            // Test searchCourses method
            System.out.println("\n=== Test searchCourses (Keyword = 'N5', Category = 'paid') ===");
            List<Course> searchResults = dao.searchCourses("N5", "paid");
            if (searchResults.isEmpty()) {
                System.out.println("No courses found for keyword 'N5' in category 'paid'.");
            } else {
                System.out.printf("%-5s %-10s %-30s %-15s %-10s %-12s %-12s %-10s %-15s %-20s%n",
                        "Num", "CourseID", "Title", "Fee", "Duration", "Start Date", "End Date", "Active", "Category", "Created Date");
                System.out.println("-".repeat(100));
                for (Course c : searchResults) {
                    System.out.printf("%-5d %-10s %-30s %-15.2f %-10d %-12s %-12s %-10b %-15s %-20s%n",
                            c.getCourseNum(),
                            c.getCourseID(),
                            c.getTitle().length() > 30 ? c.getTitle().substring(0, 27) + "..." : c.getTitle(),
                            c.getFee(),
                            c.getDuration(),
                            c.getStartDate() != null ? c.getStartDate() : "N/A",
                            c.getEndDate() != null ? c.getEndDate() : "N/A",
                            c.isActive(),
                            c.getCategory() != null ? c.getCategory() : "N/A",
                            c.getCreatedDate() != null ? c.getCreatedDate() : "N/A");
                }
            }

            // Test countAllCourses and countAllCoursesActive
            System.out.println("\n=== Course Counts ===");
            System.out.println("Total Courses: " + dao.countAllCourses());
            System.out.println("Active Courses: " + dao.countAllCoursesActive());

        } finally {
            dao.closeConnection();
        }
    }
}