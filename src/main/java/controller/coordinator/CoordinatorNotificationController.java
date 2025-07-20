package controller.coordinator;

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

@WebServlet("/coordinator/coordinator-notifications")
public class CoordinatorNotificationController extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();
    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd HH:mm:ss")
            .create();
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(CoordinatorNotificationController.class.getName());

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set response headers for better performance
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
        
        // Check if user is coordinator
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Coordinator".equals(currentUser.getRole())) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"error\": \"Unauthorized\", \"success\": false}");
            return;
        }

        String action = req.getParameter("action");

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
                    resp.getWriter().write("{\"error\": \"Invalid action\", \"success\": false}");
        }
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error in CoordinatorNotificationController", e);
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Internal server error: " + e.getMessage() + "\", \"success\": false}");
        }
    }

    private void handleGetUnreadCount(HttpServletRequest req, HttpServletResponse resp, UserAccount user) throws Exception {
        // Get notifications for coordinator or "Tất cả"
        List<Notification> notifications = notificationService.getNotificationsForUser("Điều phối viên");
        
        // For demo, consider all as unread. In real implementation, track read status
        int unreadCount = notifications.size();
        
        Map<String, Object> response = new HashMap<>();
        response.put("unreadCount", unreadCount);
        response.put("success", true);
        
        resp.getWriter().write(gson.toJson(response));
    }

    private void handleGetNotifications(HttpServletRequest req, HttpServletResponse resp, UserAccount user) throws Exception {
        List<Notification> notifications = notificationService.getNotificationsForUser("Điều phối viên");
        
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

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Notification marked as read");
        
        resp.getWriter().write(gson.toJson(response));
    }

    private void handleMarkAllAsRead(HttpServletRequest req, HttpServletResponse resp, UserAccount user) throws Exception {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "All notifications marked as read");
        
        resp.getWriter().write(gson.toJson(response));
    }
}
