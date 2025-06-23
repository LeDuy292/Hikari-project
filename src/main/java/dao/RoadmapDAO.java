package dao;

import model.Roadmap;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class RoadmapDAO {
    
    public List<Roadmap> getRoadmapByCourseId(int courseId) {
        List<Roadmap> roadmaps = new ArrayList<>();
        String sql = "SELECT * FROM roadmap WHERE course_id = ? ORDER BY step_number";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Roadmap roadmap = new Roadmap();
                roadmap.setId(rs.getInt("id"));
                roadmap.setCourseId(rs.getInt("course_id"));
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
