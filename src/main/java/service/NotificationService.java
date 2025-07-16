package service;

import dao.admin.NotificationDAO;
import model.admin.Notification;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

public class NotificationService {
    private static final Logger LOGGER = Logger.getLogger(NotificationService.class.getName());
    private final NotificationDAO notificationDAO = new NotificationDAO();

    public List<Notification> getAllNotifications() throws SQLException {
        return notificationDAO.getAllNotifications();
    }

    public List<Notification> getNotificationsForUser(String userRole) throws SQLException {
        return notificationDAO.getNotificationsForUser(userRole);
    }

    public List<Notification> getNotificationsWithFilters(String type, String recipient, String search, String sendDateFrom, String sendDateTo, int page, int pageSize) throws SQLException {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        int offset = (page - 1) * pageSize;
        return notificationDAO.getNotificationsWithFilters(type, recipient, search, sendDateFrom, sendDateTo, offset, pageSize);
    }

    public int countNotificationsWithFilters(String type, String recipient, String search, String sendDateFrom, String sendDateTo) throws SQLException {
        return notificationDAO.countNotificationsWithFilters(type, recipient, search, sendDateFrom, sendDateTo);
    }

    public void addNotification(Notification notification) throws SQLException {
        validateNotification(notification);
        notificationDAO.addNotification(notification);
    }

    public void updateNotification(Notification notification) throws SQLException {
        validateNotification(notification);
        if (notification.getId() <= 0) {
            throw new IllegalArgumentException("ID thông báo không hợp lệ");
        }
        notificationDAO.updateNotification(notification);
    }

    public void deleteNotification(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID thông báo không hợp lệ");
        }
        notificationDAO.deleteNotification(id);
    }

    public Notification getNotificationById(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID thông báo không hợp lệ");
        }
        Notification notification = notificationDAO.getNotificationById(id);
        if (notification == null) {
            throw new IllegalArgumentException("Không tìm thấy thông báo");
        }
        return notification;
    }

    private void validateNotification(Notification notification) {
        if (notification == null) {
            throw new IllegalArgumentException("Dữ liệu thông báo không hợp lệ");
        }
        if (notification.getTitle() == null || notification.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề thông báo không được để trống");
        }
        if (notification.getContent() == null || notification.getContent().trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung thông báo không được để trống");
        }
        if (notification.getType() == null || notification.getType().trim().isEmpty()) {
            throw new IllegalArgumentException("Loại thông báo không được để trống");
        }
        if (notification.getRecipient() == null || notification.getRecipient().trim().isEmpty()) {
            notification.setRecipient("Tất cả");
        }
    }
}
