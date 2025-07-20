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

    public List<Answer> getAnswersByStudentAndTest(String studentID, int testId) {
        List<Answer> list = new ArrayList<>();
        String sql = "SELECT * FROM Answer WHERE studentID = ? AND testId = ? ";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

    // ✅ Added method to insert a single answer
    public void insertAnswer(Answer answer) throws SQLException {
        String sql = "INSERT INTO Answer (questionId, studentID, testId, studentAnswer, correctAnswer, score, correct, answered) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE studentAnswer = VALUES(studentAnswer), correctAnswer = VALUES(correctAnswer), "
                + "score = VALUES(score), correct = VALUES(correct), answered = VALUES(answered)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, answer.getQuestionId());
            ps.setString(2, answer.getStudentID());
            ps.setInt(3, answer.getTestId());
            ps.setString(4, answer.getStudentAnswer());
            ps.setString(5, answer.getCorrectAnswer());
            ps.setDouble(6, answer.getScore());
            ps.setBoolean(7, answer.isCorrect());
            ps.setBoolean(8, answer.isAnswered());
            ps.executeUpdate();
        }
    }

    // ✅ Added method to insert multiple answers in batch
    public void insertAnswersBatch(List<Answer> answers) throws SQLException {
        String sql = "INSERT INTO Answer (questionId, studentID, testId, studentAnswer, correctAnswer, score, correct, answered) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE studentAnswer = VALUES(studentAnswer), correctAnswer = VALUES(correctAnswer), "
                + "score = VALUES(score), correct = VALUES(correct), answered = VALUES(answered)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            for (Answer answer : answers) {
                ps.setInt(1, answer.getQuestionId());
                ps.setString(2, answer.getStudentID());
                ps.setInt(3, answer.getTestId());
                ps.setString(4, answer.getStudentAnswer());
                ps.setString(5, answer.getCorrectAnswer());
                ps.setDouble(6, answer.getScore());
                ps.setBoolean(7, answer.isCorrect());
                ps.setBoolean(8, answer.isAnswered());
                ps.addBatch();
            }
            ps.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            throw e;
        }
    }
}
