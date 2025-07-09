package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Announcement;
import model.ClassProgress;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DashboardDAO {
    private static final Logger logger = LoggerFactory.getLogger(DashboardDAO.class);
    private Connection con;

    public DashboardDAO() {
        DBContext dbContext = new DBContext();
        try {
            con = dbContext.getConnection();
            logger.info("DashboardDAO: Database connection established successfully.");
        } catch (Exception e) {
            logger.error("DashboardDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    // Đếm tổng số lớp học
    public int countAllClasses() {
        String sql = "SELECT COUNT(*) FROM Class";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
            logger.debug("DashboardDAO: Counted {} total classes.", count);
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error counting all classes: {}", e.getMessage(), e);
        }
        return count;
    }

    // Đếm số lớp chưa đủ học viên (giả sử < 25 học viên)
    public int countClassesLowEnrollment() {
        String sql = "SELECT COUNT(*) FROM Class WHERE numberOfStudents < 25";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
            logger.debug("DashboardDAO: Counted {} classes with low enrollment.", count);
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error counting classes with low enrollment: {}", e.getMessage(), e);
        }
        return count;
    }

    // Đếm số giảng viên đang giảng dạy (có lớp trong Class)
    public int countTeachingTeachers() {
        String sql = "SELECT COUNT(DISTINCT teacherID) FROM Class";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
            logger.debug("DashboardDAO: Counted {} teaching teachers.", count);
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error counting teaching teachers: {}", e.getMessage(), e);
        }
        return count;
    }

    // Đếm số lớp sắp kết thúc (endDate trong 30 ngày tới)
    public int countClassesEndingSoon() {
        String sql = "SELECT COUNT(*) FROM Class c JOIN Courses co ON c.courseID = co.courseID " +
                     "WHERE co.endDate BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY)";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
            logger.debug("DashboardDAO: Counted {} classes ending soon.", count);
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error counting classes ending soon: {}", e.getMessage(), e);
        }
        return count;
    }

    // Lấy danh sách tiêu đề khóa học
    public List<String> getCourseTitles() {
        String sql = "SELECT title FROM Courses WHERE isActive = TRUE";
        List<String> titles = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                titles.add(rs.getString("title"));
            }
            logger.debug("DashboardDAO: Retrieved {} course titles.", titles.size());
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error retrieving course titles: {}", e.getMessage(), e);
        }
        return titles;
    }
    
    public List<String> getPaginatedCourseTitles(int page, int itemsPerPage) {
    List<String> titles = new ArrayList<>();
    String sql = "SELECT title FROM Courses WHERE isActive = TRUE ORDER BY title LIMIT ? OFFSET ?";

    try (PreparedStatement pre = con.prepareStatement(sql)) {
        int offset = (page - 1) * itemsPerPage;
        pre.setInt(1, itemsPerPage);
        pre.setInt(2, offset);
        try (ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                titles.add(rs.getString("title"));
            }
        }
        logger.debug("DashboardDAO: Retrieved {} course titles for page {}.", titles.size(), page);
    } catch (SQLException e) {
        logger.error("DashboardDAO: Error retrieving paginated course titles for page {}: {}", page, e.getMessage(), e);
    }
    return titles;
}

  
 public int countCourseTitles() {
    String sql = "SELECT COUNT(*) FROM Courses WHERE isActive = TRUE";

    int count = 0;
    try (PreparedStatement pre = con.prepareStatement(sql);
         ResultSet rs = pre.executeQuery()) {
        if (rs.next()) {
            count = rs.getInt(1);
        }
        logger.debug("DashboardDAO: Counted {} course titles.", count);
    } catch (SQLException e) {
        logger.error("DashboardDAO: Error counting course titles: {}", e.getMessage(), e);
    }
    return count;
}
    
    // Lấy tiến độ lớp học theo courseID
    public List<ClassProgress> getClassProgressByCourse(String courseID) {
        String sql = "SELECT c.classID, c.name, COUNT(p.id) as completedLessons, COUNT(l.id) as totalLessons, " +
                     "(COUNT(p.id) * 100.0 / NULLIF(COUNT(l.id), 0)) as completionPercentage " +
                     "FROM Class c " +
                     "LEFT JOIN Course_Enrollments ce ON c.courseID = ce.courseID " +
                     "LEFT JOIN Progress p ON ce.enrollmentID = p.enrollmentID AND p.completionStatus = 'complete' " +
                     "LEFT JOIN Lesson l ON l.topicID IN (SELECT topicID FROM Topic WHERE courseID = c.courseID) " +
                     "WHERE c.courseID = ? " +
                     "GROUP BY c.classID, c.name";
        List<ClassProgress> progressList = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    ClassProgress progress = new ClassProgress();
                    progress.setClassID(rs.getString("classID"));
                    progress.setClassName(rs.getString("name"));
                    progress.setCompletedLessons(rs.getInt("completedLessons"));
                    progress.setTotalLessons(rs.getInt("totalLessons"));
                    progress.setCompletionPercentage(rs.getDouble("completionPercentage"));
                    progressList.add(progress);
                }
            }
            logger.debug("DashboardDAO: Retrieved {} class progress entries for courseID {}.", progressList.size(), courseID);
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error retrieving class progress for courseID {}: {}", courseID, e.getMessage(), e);
        }
        return progressList;
    }

    // Lấy hoạt động gần đây (từ bảng Announcement)
    public List<Announcement> getRecentActivities() {
        String sql = "SELECT id, title, content, postedDate, postedBy FROM Announcement " +
                     "ORDER BY postedDate DESC LIMIT 5";
        List<Announcement> activities = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                Announcement activity = new Announcement();
                activity.setId(rs.getInt("id"));
                activity.setTitle(rs.getString("title"));
                activity.setContent(rs.getString("content"));
                activity.setPostedDate(rs.getTimestamp("postedDate"));
                activity.setPostedBy(rs.getString("postedBy"));
                activities.add(activity);
            }
            logger.debug("DashboardDAO: Retrieved {} recent activities.", activities.size());
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error retrieving recent activities: {}", e.getMessage(), e);
        }
        return activities;
    }
    
    // Lấy courseID dựa trên courseTitle
    public String getCourseIDByTitle(String courseTitle) {
        String sql = "SELECT courseID FROM Courses WHERE title = ? AND isActive = TRUE";
        String courseID = null;
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseTitle);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    courseID = rs.getString("courseID");
                }
                logger.debug("DashboardDAO: Retrieved courseID {} for title {}.", courseID, courseTitle);
            }
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error retrieving courseID for title {}: {}", courseTitle, e.getMessage(), e);
        }
        return courseID;
    }


    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("DashboardDAO: Database connection closed.");
            }
        } catch (SQLException e) {
            logger.error("DashboardDAO: Error closing connection: {}", e.getMessage(), e);
        }
    }    
}