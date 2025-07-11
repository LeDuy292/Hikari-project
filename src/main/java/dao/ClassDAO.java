package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ClassRoom;
import utils.DBContext;

public class ClassDAO {

    // Lấy danh sách lớp theo teacherID
    public List<ClassRoom> getClassByTeacherID(String teacherID) {
        List<ClassRoom> classes = new ArrayList<>();
        String sql = "SELECT * FROM Class WHERE teacherID = ?";

        try (Connection connection = new DBContext().getConnection();
             PreparedStatement pstmt = connection.prepareStatement(sql)) {

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

    public static void main(String[] args) {
        ClassDAO dao = new ClassDAO();
        System.out.println(dao.getClassByTeacherID("T002"));
    }
}
