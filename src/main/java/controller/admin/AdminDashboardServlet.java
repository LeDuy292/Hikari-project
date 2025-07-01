package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserAccount;
import service.AdminDashboardService;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final AdminDashboardService dashboardService = new AdminDashboardService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Kiểm tra quyền admin
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy thống kê tổng quan
            Map<String, Object> dashboardData = dashboardService.getDashboardStatistics();
            
            // Set attributes cho JSP
            req.setAttribute("totalUsers", dashboardData.get("totalUsers"));
            req.setAttribute("totalCourses", dashboardData.get("totalCourses"));
            req.setAttribute("totalPayments", dashboardData.get("totalPayments"));
            req.setAttribute("totalReviews", dashboardData.get("totalReviews"));
            req.setAttribute("totalNotifications", dashboardData.get("totalNotifications"));
            
            req.setAttribute("recentUsers", dashboardData.get("recentUsers"));
            req.setAttribute("recentCourses", dashboardData.get("recentCourses"));
            req.setAttribute("recentPayments", dashboardData.get("recentPayments"));
            req.setAttribute("recentReviews", dashboardData.get("recentReviews"));
            req.setAttribute("recentNotifications", dashboardData.get("recentNotifications"));
            
            // Serialize Map objects to JSON strings
            req.setAttribute("monthlyStats", gson.toJson(dashboardData.get("monthlyStats")));
            req.setAttribute("paymentStats", gson.toJson(dashboardData.get("paymentStats")));
            req.setAttribute("courseStats", gson.toJson(dashboardData.get("courseStats")));
            
            req.getRequestDispatcher("/view/admin/dashboard.jsp").forward(req, resp);
            
        } catch (Exception e) {
            req.setAttribute("error", "Lỗi khi tải dashboard: " + e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }
}
