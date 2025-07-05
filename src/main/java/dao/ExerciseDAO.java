package dao;

import model.Exercise;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExerciseDAO {

    public int insertAndReturnId(Exercise e) {
        String sql = "INSERT INTO Exercise (lessonID, title, description,  isActive) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, e.getLessonID());
            ps.setString(2, e.getTitle());
            ps.setString(3, e.getDescription());
            ps.setBoolean(4, e.isActive());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }

        } catch (SQLException ex) {
            System.out.println("Error insertAndReturnId Exercise: " + ex.getMessage());
        }

        return -1;
    }
public List<Exercise> getExercisesByLessonID(int lessonID) {
    List<Exercise> list = new ArrayList<>();
    String sql = "SELECT * FROM Exercise WHERE lessonID = ?";
    try (Connection con = new DBContext().getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, lessonID);
        ResultSet rs = ps.executeQuery();
        QuestionDAO questionDAO = new QuestionDAO();
        while (rs.next()) {
            Exercise e = new Exercise();
            e.setId(rs.getInt("id"));
            e.setTitle(rs.getString("title"));
            e.setDescription(rs.getString("description"));
            e.setLessonID(lessonID);
            e.setQuestions(questionDAO.getQuestionsByEntity("exercise", e.getId())); 
            list.add(e);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}

    public List<Exercise> getAll() {
        List<Exercise> list = new ArrayList<>();
        String sql = "SELECT * FROM Exercise";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Exercise e = new Exercise(
                        rs.getInt("id"),
                        rs.getInt("lessonID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getBoolean("isActive")
                );
                list.add(e);
            }
        } catch (SQLException ex) {
            System.out.println("Error getAll Exercise: " + ex.getMessage());
        }

        return list;
    }
}
