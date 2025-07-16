package dao.admin;

import model.admin.Notification;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class NotificationDAO {
    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());
    private final DBContext dbContext;

    public NotificationDAO() {
        this.dbContext = new DBContext();
    }

    public List<Notification> getAllNotifications() throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT a.*, u.fullName as postedByName FROM Announcement a " +
                    "LEFT JOIN UserAccount u ON a.postedBy = u.userID " +
                    "WHERE a.isActive = TRUE " +
                    "ORDER BY a.postedDate DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Notification notification = mapResultSetToNotification(rs);
                notifications.add(notification);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all notifications", e);
            throw e;
        }
        return notifications;
    }

    public List<Notification> getNotificationsWithFilters(String type, String recipient, String search, 
            String sendDateFrom, String sendDateTo, int offset, int limit) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT a.*, u.fullName as postedByName FROM Announcement a " +
            "LEFT JOIN UserAccount u ON a.postedBy = u.userID " +
            "WHERE a.isActive = TRUE"
        );
        List<Object> params = new ArrayList<>();

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            params.add(type.trim());
        }

        if (recipient != null && !recipient.trim().isEmpty()) {
            sql.append(" AND a.recipient = ?");
            params.add(recipient.trim());
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (a.title LIKE ? OR a.content LIKE ? OR CAST(a.id AS CHAR) LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (sendDateFrom != null && !sendDateFrom.trim().isEmpty()) {
            sql.append(" AND DATE(a.sendDate) >= ?");
            params.add(sendDateFrom);
        }

        if (sendDateTo != null && !sendDateTo.trim().isEmpty()) {
            sql.append(" AND DATE(a.sendDate) <= ?");
            params.add(sendDateTo);
        }

        sql.append(" ORDER BY a.postedDate DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = mapResultSetToNotification(rs);
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications with filters", e);
            throw e;
        }
        return notifications;
    }

    public int countNotificationsWithFilters(String type, String recipient, String search, 
            String sendDateFrom, String sendDateTo) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Announcement a WHERE a.isActive = TRUE");
        List<Object> params = new ArrayList<>();

        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND a.type = ?");
            params.add(type.trim());
        }

        if (recipient != null && !recipient.trim().isEmpty()) {
            sql.append(" AND a.recipient = ?");
            params.add(recipient.trim());
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (a.title LIKE ? OR a.content LIKE ? OR CAST(a.id AS CHAR) LIKE ?)");
            String searchPattern = "%" + search.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (sendDateFrom != null && !sendDateFrom.trim().isEmpty()) {
            sql.append(" AND DATE(a.sendDate) >= ?");
            params.add(sendDateFrom);
        }

        if (sendDateTo != null && !sendDateTo.trim().isEmpty()) {
            sql.append(" AND DATE(a.sendDate) <= ?");
            params.add(sendDateTo);
        }

        int count = 0;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting notifications with filters", e);
            throw e;
        }
        return count;
    }

    public void addNotification(Notification notification) throws SQLException {
        String sql = "INSERT INTO Announcement (title, content, type, recipient, sendDate, postedDate, postedBy, isActive) " +
                    "VALUES (?, ?, ?, ?, ?, NOW(), ?, TRUE)";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, notification.getTitle());
            stmt.setString(2, notification.getContent());
            stmt.setString(3, notification.getType());
            stmt.setString(4, notification.getRecipient());
            
            if (notification.getSendDate() != null) {
                stmt.setDate(5, new java.sql.Date(notification.getSendDate().getTime()));
            } else {
                stmt.setDate(5, new java.sql.Date(System.currentTimeMillis()));
            }
            
            stmt.setString(6, notification.getPostedBy());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Creating notification failed, no rows affected.");
            }

            LOGGER.info("Notification added successfully: " + notification.getTitle());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding notification", e);
            throw e;
        }
    }

    public void updateNotification(Notification notification) throws SQLException {
        String sql = "UPDATE Announcement SET title = ?, content = ?, type = ?, recipient = ? WHERE id = ? AND isActive = TRUE";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, notification.getTitle());
            stmt.setString(2, notification.getContent());
            stmt.setString(3, notification.getType());
            stmt.setString(4, notification.getRecipient());
            stmt.setInt(5, notification.getId());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Updating notification failed, notification not found or inactive.");
            }

            LOGGER.info("Notification updated successfully: " + notification.getId());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating notification", e);
            throw e;
        }
    }

    public void deleteNotification(int id) throws SQLException {
        String sql = "UPDATE Announcement SET isActive = FALSE WHERE id = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Deleting notification failed, notification not found.");
            }

            LOGGER.info("Notification deleted successfully: " + id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting notification", e);
            throw e;
        }
    }

    public Notification getNotificationById(int id) throws SQLException {
        String sql = "SELECT a.*, u.fullName as postedByName FROM Announcement a " +
                    "LEFT JOIN UserAccount u ON a.postedBy = u.userID " +
                    "WHERE a.id = ? AND a.isActive = TRUE";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNotification(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting notification by id", e);
            throw e;
        }
        return null;
    }

    public List<Notification> getNotificationsForUser(String userRole) throws SQLException {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT a.*, u.fullName as postedByName FROM Announcement a " +
                    "LEFT JOIN UserAccount u ON a.postedBy = u.userID " +
                    "WHERE a.isActive = TRUE AND (a.recipient = ? OR a.recipient = 'Tất cả') " +
                    "ORDER BY a.postedDate DESC LIMIT 10";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, userRole);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Notification notification = mapResultSetToNotification(rs);
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications for user role: " + userRole, e);
            throw e;
        }
        return notifications;
    }

    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();
        notification.setId(rs.getInt("id"));
        notification.setTitle(rs.getString("title"));
        notification.setContent(rs.getString("content"));
        notification.setType(rs.getString("type"));
        notification.setRecipient(rs.getString("recipient"));
        notification.setSendDate(rs.getDate("sendDate"));
        notification.setCreatedDate(rs.getTimestamp("postedDate"));
        notification.setPostedBy(rs.getString("postedBy"));
        notification.setActive(rs.getBoolean("isActive"));
        return notification;
    }
}
