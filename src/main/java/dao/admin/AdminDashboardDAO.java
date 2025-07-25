package dao.admin;

import model.UserAccount;
import model.Course;
import model.admin.Payment;
import model.admin.Review;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

public class AdminDashboardDAO {

    private static final Logger LOGGER = Logger.getLogger(AdminDashboardDAO.class.getName());
    private final DBContext dbContext;

    public AdminDashboardDAO() {
        this.dbContext = new DBContext();
    }

    // Thống kê tổng quan
    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM UserAccount";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total users", e);
            throw e;
        }
        return 0;
    }

    public int getTotalCourses() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Courses";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total courses", e);
            throw e;
        }
        return 0;
    }

    public int getTotalPayments() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Payment";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total payments", e);
            throw e;
        }
        return 0;
    }

    public int getTotalReviews() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Course_Reviews";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total reviews", e);
            throw e;
        }
        return 0;
    }

    public int getTotalNotifications() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Announcement";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total notifications", e);
            throw e;
        }
        return 0;
    }

    // Thống kê tổng quan cho biểu đồ
    public Map<String, Object> getOverviewStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        try (Connection conn = dbContext.getConnection()) {
            // Thống kê người dùng theo role
            String userSql = "SELECT role, COUNT(*) as count FROM UserAccount GROUP BY role";
            Map<String, Integer> userStats = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement(userSql); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    userStats.put(rs.getString("role"), rs.getInt("count"));
                }
            }
            stats.put("usersByRole", userStats);

            // Thống kê khóa học theo trạng thái
            String courseSql = "SELECT "
                    + "SUM(CASE WHEN isActive = 1 THEN 1 ELSE 0 END) as active, "
                    + "SUM(CASE WHEN isActive = 0 THEN 1 ELSE 0 END) as inactive "
                    + "FROM Courses";
            Map<String, Integer> courseStats = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement(courseSql); ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    courseStats.put("active", rs.getInt("active"));
                    courseStats.put("inactive", rs.getInt("inactive"));
                }
            }
            stats.put("coursesByStatus", courseStats);

            // Thống kê thanh toán theo trạng thái
            String paymentSql = "SELECT paymentStatus, COUNT(*) as count, SUM(amount) as total "
                    + "FROM Payment GROUP BY paymentStatus";
            Map<String, Map<String, Double>> paymentStats = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement(paymentSql); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Double> statusData = new HashMap<>();
                    statusData.put("count", (double) rs.getInt("count"));
                    statusData.put("total", rs.getDouble("total"));
                    paymentStats.put(rs.getString("paymentStatus"), statusData);
                }
            }
            stats.put("paymentsByStatus", paymentStats);

            // Thống kê đánh giá theo rating
            String reviewSql = "SELECT rating, COUNT(*) as count FROM Course_Reviews GROUP BY rating ORDER BY rating";
            Map<String, Integer> reviewStats = new HashMap<>();
            try (PreparedStatement stmt = conn.prepareStatement(reviewSql); ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reviewStats.put(rs.getString("rating") + " sao", rs.getInt("count"));
                }
            }
            stats.put("reviewsByRating", reviewStats);

            // Tổng doanh thu
            String revenueSql = "SELECT SUM(amount) as totalRevenue FROM Payment WHERE paymentStatus = 'Complete'";
            try (PreparedStatement stmt = conn.prepareStatement(revenueSql); ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalRevenue", rs.getDouble("totalRevenue"));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting overview statistics", e);
            throw e;
        }

        return stats;
    }

    // Dữ liệu gần đây
    public List<UserAccount> getRecentUsers(int limit) throws SQLException {
        List<UserAccount> users = new ArrayList<>();
        String sql = "SELECT * FROM UserAccount ORDER BY registrationDate DESC LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    UserAccount user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getDate("registrationDate"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent users", e);
            throw e;
        }
        return users;
    }

    public List<Course> getRecentCourses(int limit) throws SQLException {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses ORDER BY startDate DESC LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getString("courseID"));
                    course.setTitle(rs.getString("title"));
                    course.setDescription(rs.getString("description"));
                    course.setFee(rs.getDouble("fee"));
                    course.setDuration(rs.getInt("duration"));
                    course.setStartDate(rs.getDate("startDate"));
                    course.setEndDate(rs.getDate("endDate"));
                    course.setIsActive(rs.getBoolean("isActive"));
                    course.setImageUrl(rs.getString("imageUrl"));
                    courses.add(course);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent courses", e);
            throw e;
        }
        return courses;
    }

    public List<Payment> getRecentPayments(int limit) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, "
                + "GROUP_CONCAT(c.title SEPARATOR ', ') as courseName "
                + "FROM Payment p "
                + "LEFT JOIN Student s ON p.studentID = s.studentID "
                + "LEFT JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "GROUP BY p.id "
                + "ORDER BY p.paymentDate DESC LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setId(rs.getInt("id"));
                    payment.setStudentID(rs.getString("studentID"));
                    payment.setCartID(rs.getInt("cartID")); // Thay đổi từ enrollmentID
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentMethod(rs.getString("paymentMethod"));
                    payment.setPaymentStatus(rs.getString("paymentStatus"));
                    payment.setPaymentDate(rs.getTimestamp("paymentDate"));
                    payment.setTransactionID(rs.getString("transactionID"));
                    payment.setStudentName(rs.getString("studentName"));
                    payment.setCourseName(rs.getString("courseName"));
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent payments", e);
            throw e;
        }
        return payments;
    }

    public List<Review> getRecentReviews(int limit) throws SQLException {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT cr.*, u.fullName as reviewerName, c.title as courseName "
                + "FROM Course_Reviews cr "
                + "LEFT JOIN UserAccount u ON cr.userID = u.userID "
                + "LEFT JOIN Courses c ON cr.courseID = c.courseID "
                + "ORDER BY cr.reviewDate DESC LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setCourseID(rs.getString("courseID"));
                    review.setUserID(rs.getString("userID"));
                    review.setRating(rs.getInt("rating"));
                    review.setReviewText(rs.getString("reviewText"));
                    review.setReviewDate(rs.getDate("reviewDate"));
                    review.setReviewerName(rs.getString("reviewerName"));
                    review.setCourseName(rs.getString("courseName"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent reviews", e);
            throw e;
        }
        return reviews;
    }

    // Thống kê theo tháng
    public Map<String, Object> getMonthlyStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        // Thống kê người dùng đăng ký theo tháng
        String userSql = "SELECT MONTH(registrationDate) as month, COUNT(*) as count "
                + "FROM UserAccount WHERE YEAR(registrationDate) = YEAR(CURDATE()) "
                + "GROUP BY MONTH(registrationDate) ORDER BY month";

        List<Map<String, Object>> userStats = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(userSql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("month", rs.getInt("month"));
                monthData.put("count", rs.getInt("count"));
                userStats.add(monthData);
            }
        }
        stats.put("userRegistrations", userStats);

        // Thống kê thanh toán theo tháng
        String paymentSql = "SELECT MONTH(paymentDate) as month, COUNT(*) as count, SUM(amount) as total "
                + "FROM Payment WHERE YEAR(paymentDate) = YEAR(CURDATE()) AND paymentStatus = 'Complete' "
                + "GROUP BY MONTH(paymentDate) ORDER BY month";

        List<Map<String, Object>> paymentStats = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(paymentSql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> monthData = new HashMap<>();
                monthData.put("month", rs.getInt("month"));
                monthData.put("count", rs.getInt("count"));
                monthData.put("total", rs.getDouble("total"));
                paymentStats.add(monthData);
            }
        }
        stats.put("monthlyPayments", paymentStats);

        return stats;
    }

    public Map<String, Object> getCourseStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        // Khóa học phổ biến nhất
        String popularSql = "SELECT c.courseID, c.title, COUNT(ce.enrollmentID) as enrollments "
                + "FROM Courses c LEFT JOIN Course_Enrollments ce ON c.courseID = ce.courseID "
                + "GROUP BY c.courseID, c.title ORDER BY enrollments DESC LIMIT 5";

        List<Map<String, Object>> popularCourses = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(popularSql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> courseData = new HashMap<>();
                courseData.put("courseID", rs.getString("courseID"));
                courseData.put("title", rs.getString("title"));
                courseData.put("enrollments", rs.getInt("enrollments"));
                popularCourses.add(courseData);
            }
        }
        stats.put("popularCourses", popularCourses);

        // Thống kê trạng thái khóa học
        String statusSql = "SELECT isActive, COUNT(*) as count FROM Courses GROUP BY isActive";
        Map<String, Integer> statusStats = new HashMap<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(statusSql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String status = rs.getBoolean("isActive") ? "active" : "inactive";
                statusStats.put(status, rs.getInt("count"));
            }
        }
        stats.put("courseStatus", statusStats);

        return stats;
    }

    public Map<String, Object> getPaymentStatistics() throws SQLException {
        Map<String, Object> stats = new HashMap<>();

        // Thống kê theo trạng thái thanh toán
        String statusSql = "SELECT paymentStatus, COUNT(*) as count, SUM(amount) as total "
                + "FROM Payment GROUP BY paymentStatus";

        List<Map<String, Object>> statusStats = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(statusSql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> statusData = new HashMap<>();
                statusData.put("status", rs.getString("paymentStatus"));
                statusData.put("count", rs.getInt("count"));
                statusData.put("total", rs.getDouble("total"));
                statusStats.add(statusData);
            }
        }
        stats.put("paymentStatus", statusStats);

        // Thống kê theo phương thức thanh toán
        String methodSql = "SELECT paymentMethod, COUNT(*) as count, SUM(amount) as total "
                + "FROM Payment GROUP BY paymentMethod";

        List<Map<String, Object>> methodStats = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(methodSql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> methodData = new HashMap<>();
                methodData.put("method", rs.getString("paymentMethod"));
                methodData.put("count", rs.getInt("count"));
                methodData.put("total", rs.getDouble("total"));
                methodStats.add(methodData);
            }
        }
        stats.put("paymentMethods", methodStats);

        return stats;
    }

    public List<Map<String, Object>> recentNotifications(int limit) throws SQLException {
        List<Map<String, Object>> notifications = new ArrayList<>();
        String sql = "SELECT a.id, a.title, a.content, a.postedDate, u.fullName AS postedByName "
                + "FROM Announcement a "
                + "LEFT JOIN UserAccount u ON a.postedBy = u.userID "
                + "ORDER BY a.postedDate DESC LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> notification = new HashMap<>();
                    notification.put("id", rs.getInt("id"));
                    notification.put("title", rs.getString("title"));
                    notification.put("content", rs.getString("content"));
                    notification.put("postedDate", rs.getTimestamp("postedDate"));
                    notification.put("postedByName", rs.getString("postedByName"));
                    notifications.add(notification);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting recent notifications", e);
            throw e;
        }
        return notifications;
    }
}
