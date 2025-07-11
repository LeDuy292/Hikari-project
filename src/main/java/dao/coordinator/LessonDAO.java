/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.coordinator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.coordinator.Lesson;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LessonDAO {

    private static final Logger logger = LoggerFactory.getLogger(LessonDAO.class);
    private Connection con;

    public LessonDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            logger.info("LessonDAO: Database connection established successfully.");
        } catch (Exception e) {
            logger.error("LessonDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    public List<Lesson> getAllLessons() {
        String sql = "SELECT * FROM Lesson";
        List<Lesson> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql); ResultSet resultSet = pre.executeQuery()) {
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String teacherID = resultSet.getString("teacherID");
                String topicID = resultSet.getString("topicID");
                String topicName = resultSet.getString("topicName");
                String title = resultSet.getString("title");
                String description = resultSet.getString("description");
                String mediaUrl = resultSet.getString("mediaUrl");
                int duration = resultSet.getInt("duration");
                boolean isCompleted = resultSet.getBoolean("isCompleted");
                boolean isActive = resultSet.getBoolean("isActive");
                list.add(new Lesson(id, teacherID, topicID, topicName, title, description, mediaUrl, duration, isCompleted, isActive));
            }
            logger.debug("LessonDAO: Retrieved {} lessons.", list.size());
        } catch (SQLException e) {
            logger.error("LessonDAO: Error getting all lessons: {}", e.getMessage(), e);
        }
        return list;
    }

    public List<Lesson> getLessonsByCourseID(String courseID) {
        String sql = "SELECT l.* FROM Lesson l JOIN Topic t ON l.topicID = t.topicID WHERE t.courseID = ?";
        List<Lesson> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    String teacherID = resultSet.getString("teacherID");
                    String topicID = resultSet.getString("topicID");
                    String topicName = resultSet.getString("topicName");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    String mediaUrl = resultSet.getString("mediaUrl");
                    int duration = resultSet.getInt("duration");
                    boolean isCompleted = resultSet.getBoolean("isCompleted");
                    boolean isActive = resultSet.getBoolean("isActive");

                    Lesson lesson = new Lesson(id, teacherID, topicID, topicName, title, description, mediaUrl, duration, isCompleted, isActive);
                    list.add(lesson);
                }
                logger.debug("LessonDAO: Retrieved {} lessons for courseID: {}", list.size(), courseID);
            }
        } catch (SQLException e) {
            logger.error("LessonDAO: Error getting lessons by courseID {}: {}", courseID, e.getMessage(), e);
        }
        return list;
    }

    public Lesson getLessonByID(int id) {
        String sql = "SELECT * FROM Lesson WHERE id = ?";
        Lesson lesson = null;
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, id);
            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) {
                    String teacherID = resultSet.getString("teacherID");
                    String topicID = resultSet.getString("topicID");
                    String topicName = resultSet.getString("topicName");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    String mediaUrl = resultSet.getString("mediaUrl");
                    int duration = resultSet.getInt("duration");
                    boolean isCompleted = resultSet.getBoolean("isCompleted");
                    boolean isActive = resultSet.getBoolean("isActive");
                    lesson = new Lesson(id, teacherID, topicID, topicName, title, description, mediaUrl, duration, isCompleted, isActive);
                }
            }
        } catch (SQLException e) {
            logger.error("LessonDAO: Error getting lesson by ID {}: {}", id, e.getMessage(), e);
        }
        return lesson;
    }

    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("LessonDAO: Database connection closed.");
            }
        } catch (SQLException e) {
            logger.error("LessonDAO: Error closing connection: {}", e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        LessonDAO lessonDAO = new LessonDAO();
        List<Lesson> lessons = lessonDAO.getAllLessons();
        System.out.println("--- Kết quả từ getAllLessons ---");
        if (lessons != null && !lessons.isEmpty()) {
            for (Lesson lesson : lessons) {
                System.out.println(lesson);
            }
        } else {
            System.out.println("Không có bài học nào được tìm thấy hoặc xảy ra lỗi.");
        }

        // Đóng kết nối
        lessonDAO.closeConnection();
    }
}
