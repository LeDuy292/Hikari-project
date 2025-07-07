package dao.student;

import model.student.Roadmap;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class RoadmapDAO {
    
    public List<Roadmap> getRoadmapByCourseId(String courseId) { // Changed parameter type to String
        List<Roadmap> roadmaps = new ArrayList<>();
        String sql = "SELECT * FROM roadmap WHERE course_id = ? ORDER BY step_number";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseId); // Changed to setString
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Roadmap roadmap = new Roadmap();
                roadmap.setId(rs.getInt("id"));
                roadmap.setCourseId(rs.getString("course_id")); // Changed to getString
                roadmap.setStepNumber(rs.getInt("step_number"));
                roadmap.setTitle(rs.getString("title"));
                roadmap.setDescription(rs.getString("description"));
                roadmap.setDuration(rs.getString("duration"));
                roadmaps.add(roadmap);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roadmaps;
    }
}
