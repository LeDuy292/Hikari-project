package service;

import dao.admin.AdminDashboardDAO;
import model.UserAccount;
import model.Course;
import model.admin.Payment;
import model.admin.Review;
import java.util.*;

public class AdminDashboardService {
    private final AdminDashboardDAO dashboardDAO = new AdminDashboardDAO();

    public Map<String, Object> getDashboardStatistics() {
        Map<String, Object> result = new HashMap<>();
        
        try {
            // Lấy thống kê tổng quan
            result.put("totalUsers", dashboardDAO.getTotalUsers());
            result.put("totalCourses", dashboardDAO.getTotalCourses());
            result.put("totalPayments", dashboardDAO.getTotalPayments());
            result.put("totalReviews", dashboardDAO.getTotalReviews());
            result.put("totalNotifications", dashboardDAO.getTotalNotifications());
            
            // Lấy dữ liệu gần đây
            result.put("recentUsers", dashboardDAO.getRecentUsers(5));
            result.put("recentCourses", dashboardDAO.getRecentCourses(5));
            result.put("recentPayments", dashboardDAO.getRecentPayments(5));
            result.put("recentReviews", dashboardDAO.getRecentReviews(5));
            
            // Lấy thống kê theo tháng
            Map<String, Object> monthlyStatsRaw = dashboardDAO.getMonthlyStatistics();
            
            // Process user registrations (monthlyStats)
            Map<String, Integer> monthlyStats = new HashMap<>();
            for (int i = 1; i <= 12; i++) {
                monthlyStats.put(String.valueOf(i), 0);
            }
            List<Map<String, Object>> userRegistrations = (List<Map<String, Object>>) monthlyStatsRaw.get("userRegistrations");
            for (Map<String, Object> entry : userRegistrations) {
                int month = (Integer) entry.get("month");
                int count = ((Number) entry.get("count")).intValue();
                monthlyStats.put(String.valueOf(month), count);
            }
            result.put("monthlyStats", monthlyStats);
            
            // Process payment stats (monthly revenue)
            Map<String, Double> paymentStats = new HashMap<>();
            for (int i = 1; i <= 12; i++) {
                paymentStats.put(String.valueOf(i), 0.0);
            }
            List<Map<String, Object>> monthlyPayments = (List<Map<String, Object>>) monthlyStatsRaw.get("monthlyPayments");
            for (Map<String, Object> entry : monthlyPayments) {
                int month = (Integer) entry.get("month");
                double total = ((Number) entry.get("total")).doubleValue();
                paymentStats.put(String.valueOf(month), total);
            }
            result.put("paymentStats", paymentStats);
            
            // Lấy thống kê khóa học
            result.put("courseStats", dashboardDAO.getCourseStatistics());
            
        } catch (Exception e) {
            System.err.println("Error in AdminDashboardService: " + e.getMessage());
            e.printStackTrace();
            
            // Trả về dữ liệu mặc định nếu có lỗi
            result.put("totalUsers", 0);
            result.put("totalCourses", 0);
            result.put("totalPayments", 0);
            result.put("totalReviews", 0);
            result.put("totalNotifications", 0);
            result.put("recentUsers", new ArrayList<>());
            result.put("recentCourses", new ArrayList<>());
            result.put("recentPayments", new ArrayList<>());
            result.put("recentReviews", new ArrayList<>());
            result.put("monthlyStats", new HashMap<>());
            result.put("paymentStats", new HashMap<>());
            result.put("courseStats", new HashMap<>());
        }
        
        return result;
    }
}