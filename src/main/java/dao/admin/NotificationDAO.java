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
                        "ORDER BY a.postedDate DESC";

            try (Connection conn = dbContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {
                    Notification notification = new Notification();
                    notification.setId(rs.getInt("id"));
                    notification.setTitle(rs.getString("title"));
                    notification.setContent(rs.getString("content"));
                    notification.setCreatedDate(rs.getTimestamp("postedDate"));
                    notification.setPostedBy(rs.getString("postedBy"));
                    notifications.add(notification);
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error getting all notifications", e);
                throw e;
            }
            return notifications;
        }

        public void addNotification(Notification notification) throws SQLException {
            String sql = "INSERT INTO Announcement (title, content, postedDate, postedBy) VALUES (?, ?, NOW(), ?)";

            try (Connection conn = dbContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, notification.getTitle());
                stmt.setString(2, notification.getContent());
                stmt.setString(3, notification.getPostedBy());

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
            String sql = "UPDATE Announcement SET title = ?, content = ? WHERE id = ?";

            try (Connection conn = dbContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, notification.getTitle());
                stmt.setString(2, notification.getContent());
                stmt.setInt(3, notification.getId());

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Updating notification failed, no rows affected.");
                }

                LOGGER.info("Notification updated successfully: " + notification.getId());
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error updating notification", e);
                throw e;
            }
        }

        public void deleteNotification(int id) throws SQLException {
            String sql = "DELETE FROM Announcement WHERE id = ?";

            try (Connection conn = dbContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, id);

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Deleting notification failed, no rows affected.");
                }

                LOGGER.info("Notification deleted successfully: " + id);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error deleting notification", e);
                throw e;
            }
        }

        public Notification getNotificationById(int id) throws SQLException {
            String sql = "SELECT * FROM Announcement WHERE id = ?";

            try (Connection conn = dbContext.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, id);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        Notification notification = new Notification();
                        notification.setId(rs.getInt("id"));
                        notification.setTitle(rs.getString("title"));
                        notification.setContent(rs.getString("content"));
                        notification.setCreatedDate(rs.getTimestamp("postedDate"));
                        notification.setPostedBy(rs.getString("postedBy"));
                        return notification;
                    }
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error getting notification by id", e);
                throw e;
            }
            return null;
        }
    }
