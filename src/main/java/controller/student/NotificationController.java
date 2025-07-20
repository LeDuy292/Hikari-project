package controller.student;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Notification;
import model.UserAccount;
import service.NotificationService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/student/notifications")
public class NotificationController extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();
    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(NotificationController.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check if user is logged in
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            switch (action != null ? action : "list") {
                case "count":
                    handleGetUnreadCount(req, resp, currentUser);
                    break;
                case "list":
                    handleGetNotifications(req, resp, currentUser);
                    break;
                case "markRead":
                    handleMarkAsRead(req, resp, currentUser);
                    break;
                case "markAllRead":
                    handleMarkAllAsRead(req, resp, currentUser);
                    break;
                default:
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error in NotificationController", e);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Internal server error\"}");
        }
    }

    private void handleGetUnreadCount(HttpServletRequest req, HttpServletResponse resp, UserAccount user) throws Exception {
        // Get notifications for this user's role or "Tất cả"
        String userRole = getUserRoleInVietnamese(user.getRole());
        List<Notification> notifications = notificationService.getNotificationsForUser(userRole);
        
        // Count unread notifications (for demo, we'll consider all as unread)
        // In real implementation, you'd have a user_notifications table to track read status
        int unreadCount = notifications.size();
        
        Map<String, Object> response = new HashMap<>();
        response.put("unreadCount", unreadCount);
        response.put("success", true);
        
        resp.getWriter().write(gson.toJson(response));
    }

    private void handleGetNotifications(HttpServletRequest req, HttpServletResponse resp, UserAccount user) throws Exception {
        String userRole = getUserRoleInVietnamese(user.getRole());
        List<Notification> notifications = notificationService.getNotificationsForUser(userRole);
        
        // Limit to recent 10 notifications
        if (notifications.size() > 10) {
            notifications = notifications.subList(0, 10);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("notifications", notifications);
        response.put("success", true);
        
        resp.getWriter().write(gson.toJson(response));
    }

    private void handleMarkAsRead(HttpServletRequest req, HttpServletResponse resp, UserAccount user) throws Exception {
        String notificationId = req.getParameter("id");
        if (notificationId == null || notificationId.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\": \"Notification ID is required\"}");
            return;
        }

        // In a real implementation, you would update the user_notifications table
        // For now, we'll just return success
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Notification marked as read");
        
        resp.getWriter().write(gson.toJson(response));
    }

    private void handleMarkAllAsRead(HttpServletRequest req, HttpServletResponse resp, UserAccount user) throws Exception {
        // In a real implementation, you would mark all notifications as read for this user
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "All notifications marked as read");
        
        resp.getWriter().write(gson.toJson(response));
    }

    private String getUserRoleInVietnamese(String role) {
        switch (role) {
            case "Student":
                return "Học viên";
            case "Teacher":
                return "Giảng viên";
            case "Coordinator":
                return "Điều phối viên";
            case "Admin":
                return "Quản trị viên";
            default:
                return "Tất cả";
        }
    }
}
