package dao;

import model.CourseInfo;

import java.sql.*;
import utils.DBContext;

public class CourseInfoDAO {
    
    public CourseInfo getCourseInfoByCourseId(int courseId) {
        String sql = "SELECT * FROM course_info WHERE course_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                CourseInfo courseInfo = new CourseInfo();
                courseInfo.setId(rs.getInt("id"));
                courseInfo.setCourseId(rs.getInt("course_id"));
                courseInfo.setOverview(rs.getString("overview"));
                courseInfo.setObjectives(rs.getString("objectives"));
                courseInfo.setLevelDescription(rs.getString("level_description"));
                courseInfo.setTuitionInfo(rs.getString("tuition_info"));
                courseInfo.setDuration(rs.getString("duration"));
                return courseInfo;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public static void main(String[] args) {
        CourseInfoDAO dao = new CourseInfoDAO();
        int testCourseId = 13;
        CourseInfo info = dao.getCourseInfoByCourseId(testCourseId);
        if (info != null) {
            System.out.println("Course Info:");
            System.out.println("ID: " + info.getId());
            System.out.println("Course ID: " + info.getCourseId());
            System.out.println("Overview: " + info.getOverview());
            System.out.println("Objectives: " + info.getObjectives());
            System.out.println("Level Description: " + info.getLevelDescription());
            System.out.println("Tuition Info: " + info.getTuitionInfo());
            System.out.println("Duration: " + info.getDuration());
        } else {
            System.out.println("No course info found for course ID: " + testCourseId);
        }
    }
}
