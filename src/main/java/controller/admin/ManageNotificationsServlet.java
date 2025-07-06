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
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/notifications")
public class ManageNotificationsServlet extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();
    private final Gson gson = new GsonBuilder()
            .setDateFormat("yyyy-MM-dd")
            .create();
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(ManageNotificationsServlet.class.getName());

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
            LOGGER.log(java.util.logging.Level.SEVERE, "Error in doGet", e);
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    private void handleViewNotification(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\": \"ID thông báo không hợp lệ\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            Notification notification = notificationService.getNotificationById(id);

            if (notification == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"error\": \"Không tìm thấy thông báo\"}");
                return;
            }

            // Return JSON response for AJAX
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            String jsonResponse = gson.toJson(notification);
            resp.getWriter().write(jsonResponse);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\": \"ID thông báo không hợp lệ\"}");
        }
    }

    private void handleListNotifications(HttpServletRequest req, HttpServletResponse resp) throws Exception {
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
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/notifications?error=" + URLEncoder.encode("Hành động không hợp lệ", "UTF-8"));
            return;
        }

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
                    resp.sendRedirect(req.getContextPath() + "/admin/notifications?error=" + URLEncoder.encode("Hành động không hợp lệ", "UTF-8"));
            }
        } catch (Exception e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "Error in doPost", e);
            resp.sendRedirect(req.getContextPath() + "/admin/notifications?error=" + URLEncoder.encode("Có lỗi xảy ra: " + e.getMessage(), "UTF-8"));
        }
    }

    private void handleAddNotification(HttpServletRequest req, HttpServletResponse resp, UserAccount currentUser) throws Exception {
        Notification notification = new Notification();
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String type = req.getParameter("type");
        String recipient = req.getParameter("recipient");
        String sendDateStr = req.getParameter("sendDate");

        // Validate inputs
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề không được để trống");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung không được để trống");
        }
        if (type == null || type.trim().isEmpty()) {
            throw new IllegalArgumentException("Loại thông báo không được để trống");
        }

        notification.setTitle(title.trim());
        notification.setContent(content.trim());
        notification.setType(type.trim());
        notification.setRecipient(recipient != null && !recipient.trim().isEmpty() ? recipient.trim() : "Tất cả");

        if (sendDateStr != null && !sendDateStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                notification.setSendDate(sdf.parse(sendDateStr));
            } catch (Exception e) {
                throw new IllegalArgumentException("Ngày gửi không hợp lệ");
            }
        } else {
            notification.setSendDate(new Date());
        }

        notification.setPostedBy(currentUser.getUserID());

        notificationService.addNotification(notification);
        resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=" + URLEncoder.encode("Thêm thông báo thành công", "UTF-8"));
    }

    private void handleEditNotification(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("notificationId");
        String title = req.getParameter("title");
        String content = req.getParameter("content");
        String type = req.getParameter("type");
        String recipient = req.getParameter("recipient");

        // Validate inputs
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID thông báo không hợp lệ");
        }
        if (title == null || title.trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề không được để trống");
        }
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("Nội dung không được để trống");
        }
        if (type == null || type.trim().isEmpty()) {
            throw new IllegalArgumentException("Loại thông báo không được để trống");
        }

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("ID thông báo không hợp lệ");
        }

        Notification notification = new Notification();
        notification.setId(id);
        notification.setTitle(title.trim());
        notification.setContent(content.trim());
        notification.setType(type.trim());
        notification.setRecipient(recipient != null && !recipient.trim().isEmpty() ? recipient.trim() : "Tất cả");

        notificationService.updateNotification(notification);
        resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=" + URLEncoder.encode("Cập nhật thông báo thành công", "UTF-8"));
    }

    private void handleDeleteNotification(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("notificationId");
        if (idStr == null || idStr.trim().isEmpty()) {
            throw new IllegalArgumentException("ID thông báo không hợp lệ");
        }

        try {
            int id = Integer.parseInt(idStr);
            notificationService.deleteNotification(id);
            resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=" + URLEncoder.encode("Xóa thông báo thành công", "UTF-8"));
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("ID thông báo không hợp lệ");
        }
    }
}