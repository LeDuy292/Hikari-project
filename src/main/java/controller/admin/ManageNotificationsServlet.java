package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Notification;
import model.UserAccount;
import service.NotificationService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/notifications")
public class ManageNotificationsServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            if ("view".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Notification notification = notificationService.getNotificationById(id);
                req.setAttribute("notification", notification);
                req.getRequestDispatcher("/view/admin/viewNotification.jsp").forward(req, resp);
            } else {
                List<Notification> notifications = notificationService.getAllNotifications();
                req.setAttribute("notifications", notifications);
                req.getRequestDispatcher("/view/admin/manageNotifications.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }
}
