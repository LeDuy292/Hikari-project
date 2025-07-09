package dao;

import jakarta.servlet.http.Part;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Lesson;
import responsitory.CourseReponsitory;
import utils.DBContext;

public class LessonDAO {
    private CourseReponsitory res = new CourseReponsitory();
    // Lấy tất cả bài học theo topicID
    public List<Lesson> getAllLessonsByTopicID(String topicID) {
        List<Lesson> lessonList = new ArrayList<>();
        String sql = "SELECT id, topicID, topicName, title, description, mediaUrl, duration, isCompleted, isActive "
                   + "FROM Lesson WHERE topicID = ? AND isActive = TRUE";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, topicID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    lessonList.add(new Lesson(
                            rs.getInt("id"),
                            rs.getString("topicID"),
                            rs.getString("topicName"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getString("mediaUrl"),
                            rs.getInt("duration"),
                            rs.getBoolean("isCompleted"),
                            rs.getBoolean("isActive")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error at getAllLessonsByTopicID: " + e.getMessage());
        }

        return lessonList;
    }

    // Lấy tất cả bài học (kể cả không active)
    public List<Lesson> getAllLessons() {
        List<Lesson> lessonList = new ArrayList<>();
        String sql = "SELECT id, topicID, topicName, title, description, mediaUrl, duration, isCompleted, isActive "
                   + "FROM Lesson";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                lessonList.add(new Lesson(
                        rs.getInt("id"),
                        rs.getString("topicID"),
                        rs.getString("topicName"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("mediaUrl"),
                        rs.getInt("duration"),
                        rs.getBoolean("isCompleted"),
                        rs.getBoolean("isActive")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error at getAllLessons: " + e.getMessage());
        }

        return lessonList;
    }
 // Thêm bài học mới
    public boolean addLesson(Lesson lesson, Part videoPart, String courseId) {
        String sql = "INSERT INTO Lesson (topicID, topicName, title, description, mediaUrl, duration, isCompleted, isActive) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        String mediaUrl = lesson.getMediaUrl();
        if (videoPart != null && videoPart.getSize() > 0) {
            // Tải lên S3
            mediaUrl = res.saveFile(videoPart, "videos/" + courseId);
            if (mediaUrl == null) {
                System.out.println("Failed to upload video to S3");
                return false;
            }
        } else if (mediaUrl == null || mediaUrl.trim().isEmpty()) {
            System.out.println("No video file or URL provided");
            return false;
        }

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, lesson.getTopicID());
            pstmt.setString(2, lesson.getTopic());
            pstmt.setString(3, lesson.getTitle());
            pstmt.setString(4, lesson.getDescription());
            pstmt.setString(5, mediaUrl);
            pstmt.setInt(6, lesson.getDuration());
            pstmt.setBoolean(7, lesson.isIsCompleted());
            pstmt.setBoolean(8, lesson.isActive());

            int rowsAffected = pstmt.executeUpdate();
            System.out.println("Lesson added successfully with mediaUrl: " + mediaUrl);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Error at addLesson: " + e.getMessage());
            return false;
        }
    }
    // Demo
    public static void main(String[] args) {
        LessonDAO dao = new LessonDAO();
        System.out.println(dao.getAllLessonsByTopicID("TP001"));
    }
}
