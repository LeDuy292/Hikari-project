package dao;

import model.Question;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    public void insertQuestion(Question q) throws SQLException {
        String sql = "INSERT INTO Question (" +
                     "questionText, optionA, optionB, optionC, optionD, correctOption, mark, " +
                     "entityType, entityID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, q.getQuestionText());
            ps.setString(2, q.getOptionA());
            ps.setString(3, q.getOptionB());
            ps.setString(4, q.getOptionC());
            ps.setString(5, q.getOptionD());
            ps.setString(6, q.getCorrectOption());
            ps.setDouble(7, q.getMark());
            ps.setString(8, q.getEntityType());
            ps.setInt(9, q.getEntityID());

            ps.executeUpdate();
        }
    }

    public void updateQuestion(Question q) throws SQLException {
        String sql = "UPDATE Question SET " +
                     "questionText = ?, optionA = ?, optionB = ?, optionC = ?, optionD = ?, " +
                     "correctOption = ?, mark = ?, entityType = ?, entityID = ? " +
                     "WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, q.getQuestionText());
            ps.setString(2, q.getOptionA());
            ps.setString(3, q.getOptionB());
            ps.setString(4, q.getOptionC());
            ps.setString(5, q.getOptionD());
            ps.setString(6, q.getCorrectOption());
            ps.setDouble(7, q.getMark());
            ps.setString(8, q.getEntityType());
            ps.setInt(9, q.getEntityID());
            ps.setInt(10, q.getId());

            ps.executeUpdate();
        }
    }

    // ✅ Xoá câu hỏi
    public void deleteQuestion(int id) throws SQLException {
        String sql = "DELETE FROM Question WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // ✅ Lấy tất cả câu hỏi
    public List<Question> getAllQuestions() throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Question q = new Question(
                        rs.getInt("id"),
                        rs.getString("questionText"),
                        rs.getString("optionA"),
                        rs.getString("optionB"),
                        rs.getString("optionC"),
                        rs.getString("optionD"),
                        rs.getString("correctOption"),
                        rs.getDouble("mark"),
                        rs.getString("entityType"),
                        rs.getInt("entityID")
                );
                list.add(q);
            }
        }
        return list;
    }

    // ✅ Tìm câu hỏi theo ID
    public Question getQuestionById(int id) throws SQLException {
        String sql = "SELECT * FROM Question WHERE id = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Question(
                            rs.getInt("id"),
                            rs.getString("questionText"),
                            rs.getString("optionA"),
                            rs.getString("optionB"),
                            rs.getString("optionC"),
                            rs.getString("optionD"),
                            rs.getString("correctOption"),
                            rs.getDouble("mark"),
                            rs.getString("entityType"),
                            rs.getInt("entityID")
                    );
                }
            }
        }
        return null;
    }

    // ✅ Lấy tất cả câu hỏi theo entity
    public List<Question> getQuestionsByEntity(String entityType, int entityID) throws SQLException {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT * FROM Question WHERE entityType = ? AND entityID = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, entityType);
            ps.setInt(2, entityID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = new Question(
                            rs.getInt("id"),
                            rs.getString("questionText"),
                            rs.getString("optionA"),
                            rs.getString("optionB"),
                            rs.getString("optionC"),
                            rs.getString("optionD"),
                            rs.getString("correctOption"),
                            rs.getDouble("mark"),
                            rs.getString("entityType"),
                            rs.getInt("entityID")
                    );
                    list.add(q);
                }
            }
        }
        return list;
    }
}
