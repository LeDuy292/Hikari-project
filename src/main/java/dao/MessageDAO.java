package dao;

import java.sql.Connection;
import model.Message;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import utils.DBContext;

public class MessageDAO extends DBContext {

    public List<Message> getChatHistory(String user1, String user2) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT sender_id, receiver_id, content, timestamp FROM chat_messages "
                + "WHERE (sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?) "
                + "ORDER BY timestamp ASC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user1);
            pstmt.setString(2, user2);
            pstmt.setString(3, user2);
            pstmt.setString(4, user1);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Date ts = rs.getTimestamp("timestamp");
                    Message message = new Message();
                    message.setSender(rs.getString("sender_id"));
                    message.setReceiver(rs.getString("receiver_id"));
                    message.setContent(rs.getString("content"));
                    message.setTimestamp(ts); // Thêm timestamp
                    messages.add(message);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return messages;
    }

    public List<String> getChatPartners(String userID) {
        List<String> partners = new ArrayList<>();
    String sql = 
    "SELECT DISTINCT " +
    "    CASE " +
    "        WHEN sender_id = ? THEN receiver_id " +
    "        WHEN receiver_id = ? THEN sender_id " +
    "    END AS partner " +
    "FROM chat_messages " +
    "WHERE sender_id = ? OR receiver_id = ?";


        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userID);
            ps.setString(2, userID);
            ps.setString(3, userID);
            ps.setString(4, userID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                partners.add(rs.getString("partner"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return partners;
    }

    public void saveMessage(Message message) {
        String sql = "INSERT INTO chat_messages (sender_id, receiver_id, content, timestamp) VALUES (?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, message.getSender());
            pstmt.setString(2, message.getReceiver());
            pstmt.setString(3, message.getContent());

            // Nếu timestamp null → dùng CURRENT_TIMESTAMP trong DB
            if (message.getTimestamp() != null) {
                pstmt.setTimestamp(4, new java.sql.Timestamp(message.getTimestamp().getTime()));
            } else {
                pstmt.setTimestamp(4, new java.sql.Timestamp(System.currentTimeMillis()));
            }

            pstmt.executeUpdate();
            System.out.println("Message saved to DB.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        MessageDAO dao = new MessageDAO();
        System.out.println(dao.getChatHistory("user1", "userB"));
    }

}
