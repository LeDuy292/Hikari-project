/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import utils.DBContext;

/**
 *
 * @author LENOVO
 */
public class CourseDAO {

    Connection con;

    public CourseDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            System.out.println("KET NOI THANH CONG!");
        } catch (Exception e) {
            System.out.println("Error: " + e);
        }
    }

    public List<Course> getAll() {
        String sql = "select * from Courses";
        List<Course> list = new ArrayList<>();
        try {
            //Tạo khay chứa câu lệnh
            PreparedStatement pre = con.prepareStatement(sql);
            //Chạy câu lệnh và tạo khay chứa kết quả câu lệnh
            ResultSet resultSet = pre.executeQuery();
            while (resultSet.next()) {
                //lấy value theo từng cột
                
                String courseID = resultSet.getString("CourseID");
                String title = resultSet.getString("title");
                String description = resultSet.getString("description");
                double fee = resultSet.getDouble("fee");
                int duration = resultSet.getInt("duration");
                Date startDate = resultSet.getDate("startDate");
                Date endDate = resultSet.getDate("endDate");
                boolean isActive = resultSet.getBoolean("isActive");

                //tạo model hứng giữ liệu
                Course course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive);

                //thêm vào list
                list.add(course);
            }
        } catch (Exception e) {
            System.out.println("error: " + e);
        }
        return list;
    }

    public void addCourse(Course course) {
        String sql = "INSERT INTO Courses\n"
                + "           (courseID,\n"
                + "            title,\n"
                + "            description,\n"
                + "            fee,\n"
                + "            duration,\n"
                + "            startDate,\n"
                + "            endDate,\n"
                + "            isActive,\n"
                + "            imageUrl)\n"
                + "     VALUES\n"
                + "           (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            //Tạo khay chứa câu lệnh
            PreparedStatement pre = con.prepareStatement(sql);
            //Set gia tri cho dau ?
            pre.setString(1, course.getCourseID());
            pre.setString(2, course.getTitle());
            pre.setString(3, course.getDescription());
            pre.setDouble(4, course.getFee());
            pre.setInt(5, course.getDuration());
            java.util.Date startDateSql = new java.sql.Date(course.getStartDate().getTime());
            pre.setDate(6, (Date) startDateSql);
            java.util.Date endDateSql = new java.sql.Date(course.getEndDate().getTime());
            pre.setDate(7, (Date) endDateSql);
            pre.setBoolean(8, course.isIsActive());
            pre.setString(9, course.getImageUrl());
            //Chạy câu lệnh và tạo khay chứa kết quả câu lệnh
            pre.executeUpdate();

        } catch (Exception e) {
            System.out.println("error: " + e);
        }
    }

    public Course getCourseByID(String id) {
        String sql = "SELECT * FROM Courses WHERE Courses.courseID = ?";
        Course course = new Course();
        try {
            //Tạo khay chứa câu lệnh
            PreparedStatement pre = con.prepareStatement(sql);
            pre.setString(1, id);
            //Chạy câu lệnh và tạo khay chứa kết quả câu lệnh
            ResultSet resultSet = pre.executeQuery();
            while (resultSet.next()) {
                String courseID = resultSet.getString("CourseID");
                String title = resultSet.getString("title");
                String description = resultSet.getString("description");
                double fee = resultSet.getDouble("fee");
                int duration = resultSet.getInt("duration");
                Date startDate = resultSet.getDate("startDate");
                Date endDate = resultSet.getDate("endDate");
                boolean isActive = resultSet.getBoolean("isActive");
                String imageUrl = resultSet.getString("imageUrl");

                //tạo model hứng giữ liệu
                course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);
            }
        } catch (Exception e) {
            System.out.println("error: " + e);
        }
        return course;
    }

    public void editCourse(Course course) {
        String sql = "UPDATE Courses\n"
                + "   SET title = ?,\n"
                + "       description = ?,\n"
                + "       fee = ?,\n"
                + "       duration = ?,\n"
                + "       startDate = ?,\n"
                + "       endDate = ?,\n"
                + "       isActive = ?,\n"
                + "       imageUrl = ?\n"
                + " WHERE courseID = ?";
        try {
            //Tạo khay chứa câu lệnh
            PreparedStatement pre = con.prepareStatement(sql);
            //Set gia tri cho dau ?
            pre.setString(1, course.getTitle());
            pre.setString(2, course.getDescription());
            pre.setDouble(3, course.getFee());
            pre.setInt(4, course.getDuration());
            java.util.Date startDateSql = new java.sql.Date(course.getStartDate().getTime());
            pre.setDate(5, (Date) startDateSql);
            java.util.Date endDateSql = new java.sql.Date(course.getEndDate().getTime());
            pre.setDate(6, (Date) endDateSql);
            pre.setBoolean(7, course.isIsActive());
            //Chạy câu lệnh và tạo khay chứa kết quả câu lệnh
            pre.setString(8, course.getImageUrl());
            pre.setString(9, course.getCourseID());
            pre.executeUpdate();

        } catch (Exception e) {
            System.out.println("error: " + e);
        }
    }

    public int countAllCourses() {
        String sql = "SELECT COUNT(*) FROM Courses";
        int count = 0;
        try {
            // Tạo khay chứa câu lệnh
            PreparedStatement pre = con.prepareStatement(sql);
            // Chạy câu lệnh và tạo khay chứa kết quả
            ResultSet resultSet = pre.executeQuery();
            // Di chuyển con trỏ đến dòng đầu tiên
            if (resultSet.next()) {
                // Lấy giá trị đếm từ cột đầu tiên
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("error: " + e);
        }
        return count;
    }

    public int countAllCoursesActive() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE Courses.isActive = 1";
        int count = 0;
        try {
            // Tạo khay chứa câu lệnh
            PreparedStatement pre = con.prepareStatement(sql);
            // Chạy câu lệnh và tạo khay chứa kết quả
            ResultSet resultSet = pre.executeQuery();
            // Di chuyển con trỏ đến dòng đầu tiên
            if (resultSet.next()) {
                // Lấy giá trị đếm từ cột đầu tiên
                count = resultSet.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("error: " + e);
        }
        return count;
    }

    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();
        List<Course> listCourse = dao.getAll();
        System.out.println(listCourse);
        System.out.println("Test:");
        Course c = dao.getCourseByID("CO001");
        System.out.println(c);
    }
}
