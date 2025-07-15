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
        String sql = "SELECT l.id, l.topicID, l.title, l.description, l.mediaUrl, l.isCompleted "
                   + "FROM Lesson l join Lesson_Reviews lr WHERE l.topicID = ? AND lr.reviewStatus = Approved";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, topicID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    lessonList.add(new Lesson(
                            rs.getInt("id"),
                            rs.getString("topicID"),
                            rs.getString("title"),
                            rs.getString("description"),
                            rs.getString("mediaUrl"),
                            rs.getBoolean("isCompleted")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error at getAllLessonsByTopicID: " + e.getMessage());
        }

        return lessonList;
    }

    public List<Lesson> getAllLessons() {
        List<Lesson> lessonList = new ArrayList<>();
        String sql = "SELECT id, topicID, title, description, mediaUrl,  isCompleted "
                   + "FROM Lesson";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                lessonList.add(new Lesson(
                        rs.getInt("id"),
                        rs.getString("topicID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getString("mediaUrl"),
                        rs.getBoolean("isCompleted")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error at getAllLessons: " + e.getMessage());
        }

        return lessonList;
    }
 // Thêm bài học mới
    public boolean addLesson(Lesson lesson, Part videoPart, String courseId) {
        String sql = "INSERT INTO Lesson (topicID, title, description, mediaUrl,  isCompleted ) "
                   + "VALUES (?, ?, ?, ?, ?)";

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
            pstmt.setString(2, lesson.getTitle());
            pstmt.setString(3, lesson.getDescription());
            pstmt.setString(4, mediaUrl);
            pstmt.setBoolean(5, lesson.isIsCompleted());

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
