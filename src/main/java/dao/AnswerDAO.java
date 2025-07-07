package dao;

import model.Answer;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnswerDAO {
    private final DBContext dbContext;

    public AnswerDAO() {
        this.dbContext = new DBContext();
    }

    public List<Answer> getAnswersByStudentAndTest(String studentID,int testId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM Answer WHERE studentID = ? AND testId = ? ";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentID);
                        ps.setInt(2, testId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Answer answer = new Answer(
                        rs.getInt("questionId"),
                        rs.getString("studentID"),
                        rs.getInt("testId"),
                        rs.getString("studentAnswer"),
                        rs.getString("correctAnswer"),
                        rs.getDouble("score"),
                        rs.getBoolean("correct"),
                        rs.getBoolean("answered")
                );
                list.add(answer);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAnswersByStudentAndTest: " + e.getMessage());
        }
        return list;
    }

    // Lấy câu trả lời theo questionId
    public Answer getAnswerByQuestionId(int questionId) {
        String sql = "SELECT * FROM Answer WHERE questionId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Answer(
                        rs.getInt("questionId"),
                         rs.getString("studentID"),
                        rs.getInt("testId"),
                        rs.getString("studentAnswer"),
                        rs.getString("correctAnswer"),
                        rs.getDouble("score"),
                        rs.getBoolean("correct"),
                        rs.getBoolean("answered")
                );
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAnswerByQuestionId: " + e.getMessage());
        }
        return null;
    }

}