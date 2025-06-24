package dao.student;

import model.student.Commitment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class CommitmentDAO {
    
    public List<Commitment> getCommitmentsByCourseId(String courseId) { // Changed parameter type to String
        List<Commitment> commitments = new ArrayList<>();
        String sql = "SELECT * FROM commitments WHERE course_id = ? ORDER BY display_order";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseId); // Changed to setString
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Commitment commitment = new Commitment();
                commitment.setId(rs.getInt("id"));
                commitment.setCourseId(rs.getString("course_id")); // Changed to getString
                commitment.setTitle(rs.getString("title"));
                commitment.setDescription(rs.getString("description"));
                commitment.setIcon(rs.getString("icon"));
                commitment.setImageUrl(rs.getString("image_url"));
                commitment.setDisplayOrder(rs.getInt("display_order"));
                commitments.add(commitment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return commitments;
    }
}
