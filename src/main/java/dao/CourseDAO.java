package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import responsitory.CourseReponsitory;
import utils.DBContext;

public class CourseDAO {

    private final CourseReponsitory rep = new CourseReponsitory();

    // Lấy tất cả các khoá học
    public List<Course> getAllCourse() {
        List<Course> courseList = new ArrayList<>();
        String sql = "SELECT * FROM courses";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                courseList.add(new Course(
                        rs.getString("courseID"),
                        rs.getString("title"),
                        rs.getString("description"),
                        rs.getDouble("fee"),
                        rs.getInt("duration"),
                        rs.getTimestamp("startDate"),
                        rs.getTimestamp("endDate"),
                        rs.getBoolean("isActive"),
                        rs.getString("imageUrl")
                ));
            }
        } catch (SQLException e) {
            System.err.println("Error at getAllCourse: " + e.getMessage());
        }

        return courseList;
    }

    // Đếm số lượng sinh viên đăng ký khóa học
    public int studentCount(String courseID) {
        String sql = "SELECT COUNT(*) AS total FROM Course_Enrollments WHERE courseID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error at studentCount: " + e.getMessage());
        }

        return 0;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CourseDAO {

    private static final Logger logger = LoggerFactory.getLogger(CourseDAO.class);
    private Connection con;

    public CourseDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            logger.info("CourseDAO: Database connection established successfully.");
        } catch (Exception e) {
            logger.error("CourseDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    public List<Course> getAll() {
        String sql = "select * from Courses";
        List<Course> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql); ResultSet resultSet = pre.executeQuery()) {
            while (resultSet.next()) {
                String courseID = resultSet.getString("CourseID");
                String title = resultSet.getString("title");
                String description = resultSet.getString("description");
                double fee = resultSet.getDouble("fee");
                int duration = resultSet.getInt("duration");
                Date startDate = resultSet.getDate("startDate");
                Date endDate = resultSet.getDate("endDate");
                boolean isActive = resultSet.getBoolean("isActive");
                String imageUrl = resultSet.getString("imageUrl");

                Course course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);
                list.add(course);
            }
            logger.debug("CourseDAO: Retrieved {} courses.", list.size());
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting all courses: {}", e.getMessage(), e);
        }
        return list;
    }

    public void addCourse(Course course) {
        String sql = "INSERT INTO Courses\n"
                + "           (courseID,\n"
                + "            title,\n"
                + "            description,\n"
                + "            fee,\n"
                + "            duration,\n"
                + "            startDate,\n"
                + "            endDate,\n"
                + "            isActive,\n"
                + "            imageUrl)\n"
                + "     VALUES\n"
                + "           (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, course.getCourseID());
            pre.setString(2, course.getTitle());
            pre.setString(3, course.getDescription());
            pre.setDouble(4, course.getFee());
            pre.setInt(5, course.getDuration());
            java.sql.Date startDateSql = new java.sql.Date(course.getStartDate().getTime());
            pre.setDate(6, startDateSql);
            java.sql.Date endDateSql = new java.sql.Date(course.getEndDate().getTime());
            pre.setDate(7, endDateSql);
            pre.setBoolean(8, course.isIsActive());
            pre.setString(9, course.getImageUrl());
            pre.executeUpdate();
            logger.info("CourseDAO: Added new course with ID: {}", course.getCourseID());

        } catch (SQLException e) {
            logger.error("CourseDAO: Error adding course {}: {}", course.getCourseID(), e.getMessage(), e);
        }
    }

    public Course getCourseByID(String id) { // Changed parameter type to String
        String sql = "SELECT * FROM Courses WHERE Courses.courseID = ?";
        Course course = null; // Initialize to null
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, id);
            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) { // Use if instead of while since courseID is unique
                    String courseID = resultSet.getString("CourseID");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    double fee = resultSet.getDouble("fee");
                    int duration = resultSet.getInt("duration");
                    Date startDate = resultSet.getDate("startDate");
                    Date endDate = resultSet.getDate("endDate");
                    boolean isActive = resultSet.getBoolean("isActive");
                    String imageUrl = resultSet.getString("imageUrl");

                    course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);
                    logger.debug("CourseDAO: Retrieved course with ID {}: {}", id, course);
                } else {
                    logger.warn("CourseDAO: No course found for ID: {}", id);
                }
            }
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting course by ID {}: {}", id, e.getMessage(), e);
        }
        return course;
    }

    // Removed the getCourseById(int id) method to enforce String usage.
    public void editCourse(Course course) {
        String sql = "UPDATE Courses\n"
                + "   SET title = ?,\n"
                + "       description = ?,\n"
                + "       fee = ?,\n"
                + "       duration = ?,\n"
                + "       startDate = ?,\n"
                + "       endDate = ?,\n"
                + "       isActive = ?,\n"
                + "       imageUrl = ?\n"
                + " WHERE courseID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, course.getTitle());
            pre.setString(2, course.getDescription());
            pre.setDouble(3, course.getFee());
            pre.setInt(4, course.getDuration());
            java.sql.Date startDateSql = new java.sql.Date(course.getStartDate().getTime());
            pre.setDate(5, startDateSql);
            java.sql.Date endDateSql = new java.sql.Date(course.getEndDate().getTime());
            pre.setDate(6, endDateSql);
            pre.setBoolean(7, course.isIsActive());
            pre.setString(8, course.getImageUrl());
            pre.setString(9, course.getCourseID());
            pre.executeUpdate();
            logger.info("CourseDAO: Edited course with ID: {}", course.getCourseID());

        } catch (SQLException e) {
            logger.error("CourseDAO: Error editing course {}: {}", course.getCourseID(), e.getMessage(), e);
        }
    }

    public int countAllCourses() {
        String sql = "SELECT COUNT(*) FROM Courses";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql); ResultSet resultSet = pre.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
            logger.debug("CourseDAO: Counted {} total courses.", count);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error counting all courses: {}", e.getMessage(), e);
        }
        return count;
    }

    public int countAllCoursesActive() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE Courses.isActive = 1";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql); ResultSet resultSet = pre.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
            logger.debug("CourseDAO: Counted {} active courses.", count);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error counting active courses: {}", e.getMessage(), e);
        }
        return count;
    }

    public List<Course> searchCourses(String searchKeyword, String category) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE (title LIKE ? OR description LIKE ?) AND category = ? AND isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, "%" + searchKeyword + "%");
            pre.setString(2, "%" + searchKeyword + "%");
            pre.setString(3, category);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    String courseID = resultSet.getString("CourseID");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    double fee = resultSet.getDouble("fee");
                    int duration = resultSet.getInt("duration");
                    Date startDate = resultSet.getDate("startDate");
                    Date endDate = resultSet.getDate("endDate");
                    boolean isActive = resultSet.getBoolean("isActive");
                    String imageUrl = resultSet.getString("imageUrl");
                    courses.add(new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl));
                }
            }
            logger.debug("CourseDAO: Found {} courses for search '{}' in category '{}'.", courses.size(), searchKeyword, category);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error searching courses by category: {}", e.getMessage(), e);
        }
        return courses;
    }

    public List<Course> searchCoursesAllCategories(String searchKeyword) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE (title LIKE ? OR description LIKE ?) AND isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, "%" + searchKeyword + "%");
            pre.setString(2, "%" + searchKeyword + "%");
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    String courseID = resultSet.getString("CourseID");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    double fee = resultSet.getDouble("fee");
                    int duration = resultSet.getInt("duration");
                    Date startDate = resultSet.getDate("startDate");
                    Date endDate = resultSet.getDate("endDate");
                    boolean isActive = resultSet.getBoolean("isActive");
                    String imageUrl = resultSet.getString("imageUrl");
                    courses.add(new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl));
                }
            }
            logger.debug("CourseDAO: Found {} courses for search '{}' across all categories.", courses.size(), searchKeyword);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error searching courses all categories: {}", e.getMessage(), e);
        }
        return courses;
    }

    public List<Course> getAllCoursesByCategory(String category) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE category = ? AND isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, category);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    String courseID = resultSet.getString("CourseID");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    double fee = resultSet.getDouble("fee");
                    int duration = resultSet.getInt("duration");
                    Date startDate = resultSet.getDate("startDate");
                    Date endDate = resultSet.getDate("endDate");
                    boolean isActive = resultSet.getBoolean("isActive");
                    String imageUrl = resultSet.getString("imageUrl");
                    courses.add(new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl));
                }
            }
            logger.debug("CourseDAO: Retrieved {} courses for category '{}'.", courses.size(), category);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting courses by category: {}", e.getMessage(), e);
        }
        return courses;
    }

    //admin từ đây
    //phần trang
    public List<Course> getCoursesWithPaging(int offset, int limit) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses ORDER BY startDate DESC LIMIT ? OFFSET ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, limit);
            pre.setInt(2, offset);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    String courseID = resultSet.getString("CourseID");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    double fee = resultSet.getDouble("fee");
                    int duration = resultSet.getInt("duration");
                    Date startDate = resultSet.getDate("startDate");
                    Date endDate = resultSet.getDate("endDate");
                    boolean isActive = resultSet.getBoolean("isActive");
                    String imageUrl = resultSet.getString("imageUrl");

                    Course course = new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);
                    courses.add(course);
                }
            }
            logger.debug("CourseDAO: Retrieved {} courses with paging (offset {}, limit {}).", courses.size(), offset, limit);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting courses with paging: {}", e.getMessage(), e);
        }
        return courses;
    }

    //lấy khóa học với bộ lọc
    public List<Course> getCoursesWithFilters(String keyword, Boolean isActive, Double feeFrom, Double feeTo, String startDate, int offset, int limit) {
        List<Course> courses = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Courses WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }

        if (isActive != null) {
            sql.append(" AND isActive = ?");
            params.add(isActive);
        }

        if (feeFrom != null) {
            sql.append(" AND fee >= ?");
            params.add(feeFrom);
        }

        if (feeTo != null) {
            sql.append(" AND fee <= ?");
            params.add(feeTo);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND startDate >= ?");
            params.add(startDate);
        }

        sql.append(" ORDER BY startDate DESC LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (PreparedStatement pre = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pre.setObject(i + 1, params.get(i));
            }
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    String courseID = resultSet.getString("CourseID");
                    String title = resultSet.getString("title");
                    String description = resultSet.getString("description");
                    double fee = resultSet.getDouble("fee");
                    int duration = resultSet.getInt("duration");
                    Date sDate = resultSet.getDate("startDate");
                    Date eDate = resultSet.getDate("endDate");
                    boolean active = resultSet.getBoolean("isActive");
                    String imageUrl = resultSet.getString("imageUrl");

                    Course course = new Course(courseID, title, description, fee, duration, sDate, eDate, active, imageUrl);
                    courses.add(course);
                }
            }
            logger.debug("CourseDAO: Retrieved {} courses with filters.", courses.size());
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting courses with filters: {}", e.getMessage(), e);
        }
        return courses;
    }
    
    // Đếm khóa học với bộ lọc
    public int countCoursesWithFilters(String keyword, Boolean isActive, Double feeFrom, Double feeTo, String startDate) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Courses WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR description LIKE ?)");
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }

        if (isActive != null) {
            sql.append(" AND isActive = ?");
            params.add(isActive);
        }

        if (feeFrom != null) {
            sql.append(" AND fee >= ?");
            params.add(feeFrom);
        }

        if (feeTo != null) {
            sql.append(" AND fee <= ?");
            params.add(feeTo);
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND startDate >= ?");
            params.add(startDate);
        }

        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pre.setObject(i + 1, params.get(i));
            }
            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) {
                    count = resultSet.getInt(1);
                }
            }
            logger.debug("CourseDAO: Counted {} courses with filters.", count);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error counting courses with filters: {}", e.getMessage(), e);
        }
        return count;
    }

    //admin tới đây
    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("CourseDAO: Database connection closed.");
            }
        } catch (SQLException e) {
            logger.error("CourseDAO: Error closing connection: {}", e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();
        System.out.println(dao.getAllCourse());
        System.out.println("Số lượng học viên khóa CO001: " + dao.studentCount("CO001"));

        List<Course> listCourse = dao.getAll();
        System.out.println(listCourse);
        System.out.println("Test:");
        Course c = dao.getCourseByID("CO001"); // Changed to String
        System.out.println(c);
        dao.closeConnection();
    }
}
