package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Topic;
import utils.DBContext;

public class TopicDAO {
    public List<Topic> getTopicsByCourseId(String courseId) {
        List<Topic> topicList = new ArrayList<>();
        String sql = "SELECT topicID, topicName, description, orderIndex, isActive, createdDate, courseID "
                   + "FROM Topic WHERE courseID = ? AND isActive = TRUE ORDER BY orderIndex";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    topicList.add(new Topic(
                            rs.getString("topicID"),
                            rs.getString("topicName"),
                            rs.getString("description"),
                            rs.getInt("orderIndex"),
                            rs.getBoolean("isActive"),
                            rs.getDate("createdDate"),
                            rs.getString("courseID")
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi SQL khi lấy danh sách chủ đề theo courseId: " + courseId, e);
        }
        return topicList;
    }

    // Lấy toàn bộ chủ đề đang hoạt động
    public List<Topic> getAllTopics() {
        List<Topic> topicList = new ArrayList<>();
        String sql = "SELECT topicID, topicName, description, orderIndex, isActive, createdDate, courseID "
                   + "FROM Topic WHERE isActive = TRUE ORDER BY courseID, orderIndex";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                topicList.add(new Topic(
                        rs.getString("topicID"),
                        rs.getString("topicName"),
                        rs.getString("description"),
                        rs.getInt("orderIndex"),
                        rs.getBoolean("isActive"),
                        rs.getDate("createdDate"),
                        rs.getString("courseID")
                ));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi SQL khi lấy tất cả chủ đề", e);
        }
        return topicList;
    }

    // Lấy một chủ đề cụ thể theo ID
    public Topic getTopicById(String topicId) {
        Topic topic = null;
        String sql = "SELECT * FROM Topic WHERE topicID = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, topicId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    topic = new Topic(
                            rs.getString("topicID"),
                            rs.getString("topicName"),
                            rs.getString("description"),
                            rs.getInt("orderIndex"),
                            rs.getBoolean("isActive"),
                            rs.getDate("createdDate"),
                            rs.getString("courseID")
                    );
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi SQL khi lấy chủ đề theo ID: " + topicId, e);
        }
        return topic;
    }

    // Demo test
    public static void main(String[] args) {
        TopicDAO dao = new TopicDAO();
        System.out.println(dao.getTopicsByCourseId("CO001"));
    }
    
    // Thêm topic mới
    public boolean addTopic(Topic topic) {
        String sql = "INSERT INTO Topic (topicID, topicName, description, orderIndex, isActive, createdDate, courseID) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, topic.getTopicId());
            pstmt.setString(2, topic.getTopicName());
            pstmt.setString(3, topic.getDescription());
            pstmt.setInt(4, topic.getOrderIndex());
            pstmt.setBoolean(5, topic.isActive());
            pstmt.setDate(6, new java.sql.Date(topic.getCreatedDate().getTime()));
            pstmt.setString(7, topic.getCourseId());
            
            int result = pstmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi SQL khi thêm chủ đề: " + topic.getTopicId(), e);
        }
    }
    
    // Lấy orderIndex lớn nhất cho một course
    public int getMaxOrderIndex(String courseId) {
        String sql = "SELECT MAX(orderIndex) as maxOrder FROM Topic WHERE courseID = ?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, courseId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("maxOrder");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi SQL khi lấy orderIndex lớn nhất cho courseId: " + courseId, e);
        }
        return 0;
    }
}
