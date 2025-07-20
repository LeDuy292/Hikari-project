package dao;

import model.Result;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResultDAO {

    private final DBContext dbContext;

    public ResultDAO() {
        this.dbContext = new DBContext();
    }

    // Lấy danh sách kết quả theo testId
    public List<Result> getResultsByTestId(int testId) {
        List<Result> list = new ArrayList<>();
        String sql = "SELECT * FROM Result WHERE testId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, testId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Result result = new Result(
                        rs.getString("studentID"),
                        rs.getInt("testId"),
                        rs.getDouble("score"),
                        rs.getString("timeTaken"),
                        rs.getString("status")
                );
                list.add(result);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getResultsByTestId: " + e.getMessage());
        }
        return list;
    }

    // Lấy kết quả theo studentID và testId
    public Result getResultByStudentAndTest(String studentId, int testId) {
        String sql = "SELECT * FROM Result WHERE studentID = ? AND testId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            ps.setInt(2, testId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Result(
    
                        rs.getString("studentID"),
                        rs.getInt("testId"),
                        rs.getDouble("score"),
                        rs.getString("timeTaken"),
                        rs.getString("status")
                );
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getResultByStudentAndTest: " + e.getMessage());
        }
        return null;
    }

    // Thêm mới kết quả
//    public boolean addResult(Result result) {
//        String sql = "INSERT INTO Result (studentID, studentName, testId, score, timeTaken, status) "
//                + "VALUES (?, ?, ?, ?, ?, ?)";
//        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, result.getStudentID());
//            ps.setInt(2, result.getTestId());
//            ps.setDouble(3, result.getScore());
//            ps.setString(4, result.getTimeTaken());
//            ps.setString(5, result.getStatus());
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            System.out.println("Lỗi addResult: " + e.getMessage());
//            return false;
//        }
//    }
    
    public boolean addResult(Result result) {
        String sql = "INSERT INTO Result (studentID, testId, score, timeTaken, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, result.getStudentID());
            ps.setInt(2, result.getTestId());
            ps.setDouble(3, result.getScore());
            ps.setString(4, result.getTimeTaken());
            ps.setString(5, result.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi addResult: " + e.getMessage());
            return false;
        }
    }
}
