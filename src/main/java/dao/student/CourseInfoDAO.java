package dao.student;

import model.student.CourseInfo;

import java.sql.*;
import utils.DBContext;

public class CourseInfoDAO {
    
    public CourseInfo getCourseInfoByCourseId(String courseId) { // Changed parameter type to String
        String sql = "SELECT * FROM course_info WHERE course_id = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseId); // Changed to setString
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                CourseInfo courseInfo = new CourseInfo();
                courseInfo.setId(rs.getInt("id"));
                courseInfo.setCourseId(rs.getString("course_id")); // Changed to getString
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
        String testCourseId = "CO001"; // Changed to String
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
