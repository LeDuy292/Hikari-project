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
        String sql = "SELECT sender_id, receiver_id, content, imageUrl, timestamp FROM chat_messages "
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
                    message.setImageUrl(rs.getString("imageUrl")); // Retrieve imageUrl
                    message.setTimestamp(ts);
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
        String sql
                = "SELECT DISTINCT "
                + "    CASE "
                + "        WHEN cm.sender_id = ? THEN cm.receiver_id "
                + "        WHEN cm.receiver_id = ? THEN cm.sender_id "
                + "    END AS partner_id, "
                + "    ua.fullName, "
                + "    ua.profilePicture "
                + "FROM chat_messages cm "
                + "JOIN UserAccount ua ON "
                + "    CASE "
                + "        WHEN cm.sender_id = ? THEN cm.receiver_id "
                + "        WHEN cm.receiver_id = ? THEN cm.sender_id "
                + "    END = ua.userID "
                + "WHERE cm.sender_id = ? OR cm.receiver_id = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userID);
            ps.setString(2, userID);
            ps.setString(3, userID);
            ps.setString(4, userID);
            ps.setString(5, userID);
            ps.setString(6, userID);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String partnerID = rs.getString("partner_id"); // Sửa từ "partner" thành "partner_id"
                String fullName = rs.getString("fullName");
                String profilePicture = rs.getString("profilePicture");
                String partnerInfo = partnerID + "|"
                        + (fullName != null ? fullName : "") + "|"
                        + (profilePicture != null ? profilePicture : "");
                partners.add(partnerInfo);
                System.out.println("Found partner: " + partnerInfo); // Ghi log

            }
            System.out.println("Total partners for user " + userID + ": " + partners.size()); // Ghi log
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return partners;
    }

    public void saveMessage(Message message) {
        String sql = "INSERT INTO chat_messages (sender_id, receiver_id, content, imageUrl, timestamp) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, message.getSender());
            pstmt.setString(2, message.getReceiver());
            pstmt.setString(3, message.getContent());
            pstmt.setString(4, message.getImageUrl()); // Set imageUrl (can be null)
            if (message.getTimestamp() != null) {
                pstmt.setTimestamp(5, new java.sql.Timestamp(message.getTimestamp().getTime()));
            } else {
                pstmt.setTimestamp(5, new java.sql.Timestamp(System.currentTimeMillis()));
            }

            pstmt.executeUpdate();
            System.out.println("Message saved to DB.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean isValidUser(String userID) {
        String sql = "SELECT COUNT(*) FROM UserAccount WHERE userID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getUserFullName(String userID) {
        String sql = "SELECT fullName FROM UserAccount WHERE userID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("fullName");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getUserProfilePicture(String userID) {
        String sql = "SELECT profilePicture FROM UserAccount WHERE userID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("profilePicture");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        MessageDAO dao = new MessageDAO();
        System.out.println(dao.getChatHistory("U001", "U002"));
    }

}
