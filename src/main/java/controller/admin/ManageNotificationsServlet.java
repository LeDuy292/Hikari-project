package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Notification;
import model.UserAccount;
import service.NotificationService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/notifications")
public class ManageNotificationsServlet extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();
    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd")
            .create();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            if ("view".equals(action)) {
                handleViewNotification(req, resp);
            } else {
                handleListNotifications(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    private void handleViewNotification(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        Notification notification = notificationService.getNotificationById(id);

        if (notification == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Return JSON response for AJAX
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String jsonResponse = gson.toJson(notification);
        resp.getWriter().write(jsonResponse);
    }

    private void handleListNotifications(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        // Get filter parameters
        String type = req.getParameter("type");
        String recipient = req.getParameter("recipient");
        String search = req.getParameter("search");
        String sendDateFrom = req.getParameter("sendDateFrom");
        String sendDateTo = req.getParameter("sendDateTo");
        String pageStr = req.getParameter("page");

        int page = 1;
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException ignored) {
            }
        }

        int pageSize = 10;
        List<Notification> notifications = notificationService.getNotificationsWithFilters(
                type, recipient, search, sendDateFrom, sendDateTo, page, pageSize);
        int totalNotifications = notificationService.countNotificationsWithFilters(
                type, recipient, search, sendDateFrom, sendDateTo);

        int totalPages = (int) Math.ceil((double) totalNotifications / pageSize);

        req.setAttribute("notifications", notifications);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalNotifications", totalNotifications);
        req.setAttribute("type", type);
        req.setAttribute("recipient", recipient);
        req.setAttribute("search", search);
        req.setAttribute("sendDateFrom", sendDateFrom);
        req.setAttribute("sendDateTo", sendDateTo);

        req.getRequestDispatcher("/view/admin/manageNotifications.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        try {
            switch (action) {
                case "add":
                    handleAddNotification(req, resp, currentUser);
                    break;
                case "edit":
                    handleEditNotification(req, resp);
                    break;
                case "delete":
                    handleDeleteNotification(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/notifications?error=Invalid action");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/notifications?error=" + e.getMessage());
        }
    }

    private void handleAddNotification(HttpServletRequest req, HttpServletResponse resp, UserAccount currentUser)
            throws Exception {
        Notification notification = new Notification();
        notification.setTitle(req.getParameter("title"));
        notification.setContent(req.getParameter("content"));
        notification.setType(req.getParameter("type"));
        notification.setRecipient(req.getParameter("recipient"));

        String sendDateStr = req.getParameter("sendDate");
        if (sendDateStr != null && !sendDateStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            notification.setSendDate(sdf.parse(sendDateStr));
        } else {
            notification.setSendDate(new Date());
        }

        notification.setPostedBy(currentUser.getUserID());

        notificationService.addNotification(notification);
        resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=Thêm thông báo thành công");
    }

    private void handleEditNotification(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("notificationId"));
            Notification notification = new Notification();
            notification.setId(id);
            notification.setTitle(req.getParameter("title"));
            notification.setContent(req.getParameter("content"));
            notification.setType(req.getParameter("type"));
            String recipient = req.getParameter("recipient");
            // Ensure recipient is not empty or null
            notification.setRecipient(recipient != null && !recipient.isEmpty() ? recipient : "Tất cả");

            notificationService.updateNotification(notification);
            resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=Cập nhật thông báo thành công");
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error updating notification", e);
            resp.sendRedirect(req.getContextPath() + "/admin/notifications?error=Có lỗi xảy ra khi cập nhật thông báo: " + e.getMessage());
        }
    }

    private void handleDeleteNotification(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("notificationId"));
        notificationService.deleteNotification(id);
        resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=Xóa thông báo thành công");
    }

    private static final java.util.logging.Logger LOGGER
            = java.util.logging.Logger.getLogger(ManageNotificationsServlet.class.getName());
}
