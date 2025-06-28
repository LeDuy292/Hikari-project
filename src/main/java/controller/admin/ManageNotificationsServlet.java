package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.admin.Notification;
import model.UserAccount;
import service.NotificationService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin/notifications")
public class ManageNotificationsServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();

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
                int id = Integer.parseInt(req.getParameter("id"));
                Notification notification = notificationService.getNotificationById(id);
                
                if (notification == null) {
                    resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                
                // Return JSON response for AJAX
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"id\":").append(notification.getId()).append(",");
                json.append("\"title\":\"").append(notification.getTitle()).append("\",");
                json.append("\"type\":\"").append(notification.getType()).append("\",");
                json.append("\"content\":\"").append(notification.getContent().replace("\"", "\\\"")).append("\",");
                json.append("\"recipient\":\"").append(notification.getRecipient()).append("\",");
                json.append("\"sendDate\":\"").append(notification.getSendDate()).append("\"");
                json.append("}");
                
                resp.getWriter().write(json.toString());
                return;
            } else {
                // Get filter parameters
                String type = req.getParameter("type");
                String search = req.getParameter("search");
                String pageStr = req.getParameter("page");
                
                int page = 1;
                if (pageStr != null) {
                    try { 
                        page = Integer.parseInt(pageStr); 
                        if (page < 1) page = 1;
                    } catch (NumberFormatException ignored) {}
                }
                
                List<Notification> notifications = notificationService.getAllNotifications();
                
                // Apply type filter if provided
                if (type != null && !type.trim().isEmpty()) {
                    notifications = notifications.stream()
                        .filter(n -> n.getType().equals(type))
                        .collect(java.util.stream.Collectors.toList());
                }
                
                // Apply search filter if provided
                if (search != null && !search.trim().isEmpty()) {
                    notifications = notifications.stream()
                        .filter(n -> n.getTitle().toLowerCase().contains(search.toLowerCase()) ||
                                   n.getContent().toLowerCase().contains(search.toLowerCase()) ||
                                   String.valueOf(n.getId()).contains(search))
                        .collect(java.util.stream.Collectors.toList());
                }
                
                // Pagination
                int pageSize = 10;
                int totalNotifications = notifications.size();
                int totalPages = (int) Math.ceil((double) totalNotifications / pageSize);
                
                int startIndex = (page - 1) * pageSize;
                int endIndex = Math.min(startIndex + pageSize, totalNotifications);
                
                if (startIndex < totalNotifications) {
                    notifications = notifications.subList(startIndex, endIndex);
                } else {
                    notifications = new ArrayList<>();
                }
                
                req.setAttribute("notifications", notifications);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("totalNotifications", totalNotifications);
                req.setAttribute("type", type);
                req.setAttribute("search", search);
                
                req.getRequestDispatcher("/view/admin/manageNotifications.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
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
            if ("add".equals(action)) {
                Notification notification = new Notification();
                notification.setTitle(req.getParameter("title"));
                notification.setContent(req.getParameter("content"));
                notification.setType(req.getParameter("type"));
                notification.setRecipient(req.getParameter("recipient"));
                
                String sendDateStr = req.getParameter("sendDate");
                if (sendDateStr != null && !sendDateStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    notification.setSendDate(sdf.parse(sendDateStr));
                }
                
                notification.setPostedBy(currentUser.getUserID());
                
                notificationService.addNotification(notification);
                resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=Thêm thành công");
                
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(req.getParameter("notificationId"));
                Notification notification = new Notification();
                notification.setId(id);
                notification.setTitle(req.getParameter("title"));
                notification.setContent(req.getParameter("content"));
                notification.setType(req.getParameter("type"));
                notification.setRecipient(req.getParameter("recipient"));
                
                notificationService.updateNotification(notification);
                resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=Cập nhật thành công");
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("notificationId"));
                notificationService.deleteNotification(id);
                resp.sendRedirect(req.getContextPath() + "/admin/notifications?message=Xóa thành công");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/notifications?error=" + e.getMessage());
        }
    }
}
