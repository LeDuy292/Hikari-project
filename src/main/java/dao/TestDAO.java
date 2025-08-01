package dao;

import model.Test;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestDAO {
    public int insertAndReturnId(Test test) {
        String sql = "INSERT INTO Test (jlptLevel, title, description, duration, totalMarks, totalQuestions, isActive) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, test.getJlptLevel());
            ps.setString(2, test.getTitle());
            ps.setString(3, test.getDescription());
            ps.setInt(4, test.getDuration());
            ps.setDouble(5, test.getTotalMarks());
            ps.setInt(6, test.getTotalQuestions());
            ps.setBoolean(7, test.isActive());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error insertAndReturnId Test: " + e.getMessage());
        }

        return -1;
    }

    public Test getTestById(int testId) {
        String sql = "SELECT * FROM Test WHERE id = ? AND isActive = true";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, testId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Test(
                            rs.getInt("id"),
                            rs.getString("jlptLevel"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getDouble("totalMarks"),
                            rs.getInt("totalQuestions"),
                            rs.getBoolean("isActive"),
                            rs.getInt("duration")
                    );
                }
            }

        } catch (SQLException e) {
            System.out.println("Error getTestById: " + e.getMessage());
        }

        return null;
    }

    public List<Test> getAllActiveTests() {
        List<Test> list = new ArrayList<>();
        String sql = "SELECT * FROM Test where isActive = true ";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Test t = new Test(
                        rs.getInt("id"),
                        rs.getString("jlptLevel"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getDouble("totalMarks"),
                        rs.getInt("totalQuestions"),
                        rs.getBoolean("isActive"),
                        rs.getInt("duration")
                );
                list.add(t);
            }

        } catch (SQLException e) {
            System.out.println("Error getAll Test: " + e.getMessage());
        }

        return list;
    }

    public static void main(String[] args) {
        TestDAO dao = new TestDAO();
//        System.out.println(dao.getAllActiveTests());
        System.out.println(dao.getTestById(1));
    }
    
}
