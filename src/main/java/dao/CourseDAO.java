package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Course;
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

    // Lấy tất cả khóa học
    public List<Course> getAll() {
        String sql = "SELECT * FROM Courses";
        List<Course> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet resultSet = pre.executeQuery()) {
            while (resultSet.next()) {
                list.add(mapResultSetToCourse(resultSet));
            }
            logger.debug("CourseDAO: Retrieved {} courses.", list.size());
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting all courses: {}", e.getMessage(), e);
        }
        return list;
    }

    // Thêm mới khóa học
    public void addCourse(Course course) {
        String sql = "INSERT INTO Courses (courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, course.getCourseID());
            pre.setString(2, course.getTitle());
            pre.setString(3, course.getDescription());
            pre.setDouble(4, course.getFee());
            pre.setInt(5, course.getDuration());
            pre.setDate(6, new java.sql.Date(course.getStartDate().getTime()));
            pre.setDate(7, new java.sql.Date(course.getEndDate().getTime()));
            pre.setBoolean(8, course.isIsActive());
            pre.setString(9, course.getImageUrl());
            pre.executeUpdate();
            logger.info("CourseDAO: Added new course with ID: {}", course.getCourseID());
        } catch (SQLException e) {
            logger.error("CourseDAO: Error adding course {}: {}", course.getCourseID(), e.getMessage(), e);
        }
    }

    // Lấy khóa học theo ID
    public Course getCourseByID(String id) {
        String sql = "SELECT * FROM Courses WHERE courseID = ?";
        Course course = null;
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, id);
            try (ResultSet resultSet = pre.executeQuery()) {
                if (resultSet.next()) {
                    course = mapResultSetToCourse(resultSet);
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

    // Sửa thông tin khóa học
    public void editCourse(Course course) {
        String sql = "UPDATE Courses SET title = ?, description = ?, fee = ?, duration = ?, startDate = ?, endDate = ?, isActive = ?, imageUrl = ? WHERE courseID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, course.getTitle());
            pre.setString(2, course.getDescription());
            pre.setDouble(3, course.getFee());
            pre.setInt(4, course.getDuration());
            pre.setDate(5, new java.sql.Date(course.getStartDate().getTime()));
            pre.setDate(6, new java.sql.Date(course.getEndDate().getTime()));
            pre.setBoolean(7, course.isIsActive());
            pre.setString(8, course.getImageUrl());
            pre.setString(9, course.getCourseID());
            pre.executeUpdate();
            logger.info("CourseDAO: Edited course with ID: {}", course.getCourseID());
        } catch (SQLException e) {
            logger.error("CourseDAO: Error editing course {}: {}", course.getCourseID(), e.getMessage(), e);
        }
    }

    // Xóa khóa học
    public void deleteCourse(String courseID) {
        String sql = "DELETE FROM Courses WHERE courseID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            pre.executeUpdate();
            logger.info("CourseDAO: Deleted course with ID: {}", courseID);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error deleting course {}: {}", courseID, e.getMessage(), e);
        }
    }

    // Đếm tổng số khóa học
    public int countAllCourses() {
        String sql = "SELECT COUNT(*) FROM Courses";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet resultSet = pre.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
            logger.debug("CourseDAO: Counted {} total courses.", count);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error counting all courses: {}", e.getMessage(), e);
        }
        return count;
    }

    // Đếm số khóa học đang hoạt động
    public int countAllCoursesActive() {
        String sql = "SELECT COUNT(*) FROM Courses WHERE isActive = 1";
        int count = 0;
        try (PreparedStatement pre = con.prepareStatement(sql);
             ResultSet resultSet = pre.executeQuery()) {
            if (resultSet.next()) {
                count = resultSet.getInt(1);
            }
            logger.debug("CourseDAO: Counted {} active courses.", count);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error counting active courses: {}", e.getMessage(), e);
        }
        return count;
    }

    // Tìm kiếm khóa học theo từ khóa và category
    public List<Course> searchCourses(String searchKeyword, String category) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE (title LIKE ? OR description LIKE ?) AND category = ? AND isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, "%" + searchKeyword + "%");
            pre.setString(2, "%" + searchKeyword + "%");
            pre.setString(3, category);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    courses.add(mapResultSetToCourse(resultSet));
                }
            }
            logger.debug("CourseDAO: Found {} courses for search '{}' in category '{}'.", courses.size(), searchKeyword, category);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error searching courses by category: {}", e.getMessage(), e);
        }
        return courses;
    }

    // Tìm kiếm khóa học theo từ khóa tất cả category
    public List<Course> searchCoursesAllCategories(String searchKeyword) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE (title LIKE ? OR description LIKE ?) AND isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, "%" + searchKeyword + "%");
            pre.setString(2, "%" + searchKeyword + "%");
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    courses.add(mapResultSetToCourse(resultSet));
                }
            }
            logger.debug("CourseDAO: Found {} courses for search '{}' across all categories.", courses.size(), searchKeyword);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error searching courses all categories: {}", e.getMessage(), e);
        }
        return courses;
    }

    // Lấy tất cả khóa học theo category
    public List<Course> getAllCoursesByCategory(String category) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses WHERE category = ? AND isActive = TRUE";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, category);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    courses.add(mapResultSetToCourse(resultSet));
                }
            }
            logger.debug("CourseDAO: Retrieved {} courses for category '{}'.", courses.size(), category);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting courses by category: {}", e.getMessage(), e);
        }
        return courses;
    }

    // Phân trang danh sách khóa học
    public List<Course> getCoursesWithPaging(int offset, int limit) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM Courses ORDER BY startDate DESC LIMIT ? OFFSET ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, limit);
            pre.setInt(2, offset);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    courses.add(mapResultSetToCourse(resultSet));
                }
            }
            logger.debug("CourseDAO: Retrieved {} courses with paging (offset {}, limit {}).", courses.size(), offset, limit);
        } catch (SQLException e) {
            logger.error("CourseDAO: Error getting courses with paging: {}", e.getMessage(), e);
        }
        return courses;
    }

    // Đóng kết nối
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

    // Hàm tiện ích chuyển đổi ResultSet sang Course
    private Course mapResultSetToCourse(ResultSet resultSet) throws SQLException {
        String courseID = resultSet.getString("CourseID");
        String title = resultSet.getString("title");
        String description = resultSet.getString("description");
        double fee = resultSet.getDouble("fee");
        int duration = resultSet.getInt("duration");
        Date startDate = resultSet.getDate("startDate");
        Date endDate = resultSet.getDate("endDate");
        boolean isActive = resultSet.getBoolean("isActive");
        String imageUrl = resultSet.getString("imageUrl");
        // Có thể bổ sung các trường khác nếu cần
        return new Course(courseID, title, description, fee, duration, startDate, endDate, isActive, imageUrl);
    }

    // Main test
    public static void main(String[] args) {
        CourseDAO dao = new CourseDAO();
        List<Course> listCourse = dao.getAll();
        System.out.println(listCourse);
        System.out.println("Test:");
        Course c = dao.getCourseByID("CO001");
        System.out.println(c);
        dao.closeConnection();
    }
}
