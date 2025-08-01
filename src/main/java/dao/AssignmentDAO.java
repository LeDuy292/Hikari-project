package dao;

import model.Assignment;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Question;

public class AssignmentDAO {

    public int insertAndReturnId(Assignment assignment) {
        String sql = "INSERT INTO Assignment (topicID, title, description, duration, totalMarks, totalQuestions, isComplete) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, assignment.getTopicID());
            ps.setString(2, assignment.getTitle());
            ps.setString(3, assignment.getDescription());
            ps.setInt(4, assignment.getDuration());
            ps.setDouble(5, assignment.getTotalMark());
            ps.setInt(6, assignment.getTotalQuestions());
            ps.setBoolean(7, assignment.isIsComplete());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int id = rs.getInt(1);
                    rs.close();
                    return id;
                }
                rs.close();
            }

        } catch (SQLException e) {
            System.out.println("Error insertAndReturnId: " + e.getMessage());
        }
        return -1;
    }

    public List<Assignment> getAllAssignments() {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT * FROM Assignment";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Assignment a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setTopicID(rs.getString("topicID"));
                a.setTitle(rs.getString("title"));
                a.setDescription(rs.getString("description"));
                a.setDuration(rs.getInt("duration"));
                a.setTotalMark(rs.getDouble("totalMarks"));
                a.setTotalQuestions(rs.getInt("totalQuestions"));
                a.setIsComplete(rs.getBoolean("isComplete"));
                list.add(a);
            }
            rs.close();

        } catch (SQLException e) {
            System.out.println("Error getAllAssignments: " + e.getMessage());
        }

        return list;
    }

    public Assignment getAssignmentById(int id) {
        String sql = "SELECT * FROM Assignment WHERE id = ?";
        Assignment a = null;

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
               a = new Assignment();
                a.setId(rs.getInt("id"));
                a.setTopicID(rs.getString("topicID"));
                a.setTitle(rs.getString("title"));
                a.setDescription(rs.getString("description"));
                a.setDuration(rs.getInt("duration"));
                a.setTotalMark(rs.getDouble("totalMarks"));
                a.setTotalQuestions(rs.getInt("totalQuestions"));
                a.setIsComplete(rs.getBoolean("isComplete"));

                QuestionDAO questionDAO = new QuestionDAO(); 
                try {
                    List<Question> questions = questionDAO.getQuestionsByEntity("assignment", a.getId());
                    a.setQuestions(questions); 
                    System.out.println("DEBUG: Loaded " + questions.size() + " questions for Assignment ID: " + a.getId());
                } catch (SQLException qe) {
                    System.out.println("Error loading questions for Assignment " + a.getId() + ": " + qe.getMessage());
                }
            }
            rs.close();

        } catch (SQLException e) {
            System.out.println("Error getAssignmentById: " + e.getMessage());
        }

        return a;
    }

    public boolean updateAssignment(Assignment assignment) {
        String sql = "UPDATE Assignment SET topicID = ?, title = ?, description = ?, duration = ?, totalMarks = ?, totalQuestions = ?, isComplete = ? WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, assignment.getTopicID());
            ps.setString(2, assignment.getTitle());
            ps.setString(3, assignment.getDescription());
            ps.setInt(4, assignment.getDuration());
            ps.setDouble(5, assignment.getTotalMark());
            ps.setInt(6, assignment.getTotalQuestions());
            ps.setBoolean(7, assignment.isIsComplete());
            ps.setInt(8, assignment.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error updateAssignment: " + e.getMessage());
            return false;
        }
    }

    public boolean deleteAssignment(int id) {
        String sql = "DELETE FROM Assignment WHERE id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("Error deleteAssignment: " + e.getMessage());
            return false;
        }
    }

    public List<Assignment> getAssignmentsByTopicId(String topicID) {
        List<Assignment> list = new ArrayList<>();
        String sql = "SELECT * FROM Assignment  WHERE topicID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            QuestionDAO questionDAO = new QuestionDAO();

            ps.setString(1, topicID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Assignment a = new Assignment();
                    a.setId(rs.getInt("id"));
                    a.setTopicID(rs.getString("topicID"));
                    a.setTitle(rs.getString("title"));
                    a.setDescription(rs.getString("description"));
                    a.setDuration(rs.getInt("duration"));
                    a.setTotalMark(rs.getDouble("totalMarks"));
                    a.setTotalQuestions(rs.getInt("totalQuestions"));
                    a.setIsComplete(rs.getBoolean("isComplete"));
                    list.add(a);
                    List<Question> questions = questionDAO.getQuestionsByEntity("assignment", a.getId());
                    a.setQuestions(questions);
                    System.out.println("Questions for assignment " + a.getId() + ": " + questions.size()); // Debug
                }
            }

        } catch (SQLException e) {
            System.out.println("Error getAssignmentsByTopicId: " + e.getMessage());
        }

        return list;
    }
    public static void main(String[] args) {
        AssignmentDAO edao = new AssignmentDAO();
        System.out.println(edao.getAssignmentById(1));
        System.out.println(edao.getAssignmentsByTopicId("TP001"));
    }
    

}
