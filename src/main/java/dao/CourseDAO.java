package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import responsitory.CourseReponsitory;
import utils.DBContext;

public class CourseDAO {

    private final CourseReponsitory rep = new CourseReponsitory();

    // Lấy tất cả các khoá học
    public List<Course> getAllCourse() {
        List<Course> courseList = new ArrayList<>();
        String sql = "SELECT * FROM courses";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                courseList.add(new Course(
                        rs.getString("courseID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getDouble("fee"),
                        rs.getInt("duration"),
                        rs.getTimestamp("startDate"),
                        rs.getTimestamp("endDate"),
                        rs.getBoolean("isActive"),
                        rs.getString("imageUrl")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error at getAllCourse: " + e.getMessage());
        }

        return courseList;
    }

    // Đếm số lượng sinh viên đăng ký khóa học
    public int studentCount(String courseID) {
        String sql = "SELECT COUNT(*) AS total FROM Course_Enrollments WHERE courseID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error at studentCount: " + e.getMessage());
        }

        return 0;
    }

    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();
        System.out.println(dao.getAllCourse());
        System.out.println("Số lượng học viên khóa CO001: " + dao.studentCount("CO001"));
    }
}
