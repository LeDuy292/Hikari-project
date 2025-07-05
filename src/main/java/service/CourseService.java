package service;

import dao.CourseDAO;
import model.Course;

import java.sql.SQLException;
import java.util.List;

public class CourseService {
    private final CourseDAO courseDAO = new CourseDAO();

    public List<Course> getAllCourses() throws SQLException {
        return courseDAO.getAll();
    }

    public Course getCourseById(String courseId) throws SQLException {
        if (courseId == null || courseId.trim().isEmpty()) {
            throw new IllegalArgumentException("ID khóa học không hợp lệ");
        }
        Course c = courseDAO.getCourseByID(courseId);
        if (c == null) {
            throw new IllegalArgumentException("Không tìm thấy khóa học");
        }
        return c;
    }

    public void addCourse(Course c) throws SQLException {
        validateCourse(c, false);
        if (courseDAO.getCourseByID(c.getCourseID()) != null) {
            throw new IllegalArgumentException("ID khóa học đã tồn tại");
        }
        courseDAO.addCourse(c);
    }

    public void editCourse(Course c) throws SQLException {
        validateCourse(c, true);
        if (courseDAO.getCourseByID(c.getCourseID()) == null) {
            throw new IllegalArgumentException("Không tìm thấy khóa học để cập nhật");
        }
        courseDAO.editCourse(c);
    }

    public List<Course> searchCourses(String keyword) throws SQLException {
        if (keyword == null) keyword = "";
        return courseDAO.searchCoursesAllCategories(keyword.trim());
    }

    public List<Course> searchCoursesByCategory(String keyword, String category) throws SQLException {
        if (keyword == null) keyword = "";
        if (category == null || category.trim().isEmpty()) {
            throw new IllegalArgumentException("Category không hợp lệ");
        }
        return courseDAO.searchCourses(keyword.trim(), category.trim());
    }

    public List<Course> getCoursesByCategory(String category) throws SQLException {
        if (category == null || category.trim().isEmpty()) {
            throw new IllegalArgumentException("Category không hợp lệ");
        }
        return courseDAO.getAllCoursesByCategory(category.trim());
    }

    public List<Course> getCoursesWithPaging(int page, int pageSize) throws SQLException {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        int offset = (page - 1) * pageSize;
        return courseDAO.getCoursesWithPaging(offset, pageSize);
    }

    public List<Course> getCoursesWithFilters(String keyword, Boolean isActive, Double feeFrom, Double feeTo, String startDate, int page, int pageSize) throws SQLException {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        int offset = (page - 1) * pageSize;
        return courseDAO.getCoursesWithFilters(keyword, isActive, feeFrom, feeTo, startDate, offset, pageSize);
    }

    public int countCoursesWithFilters(String keyword, Boolean isActive, Double feeFrom, Double feeTo, String startDate) throws SQLException {
        return courseDAO.countCoursesWithFilters(keyword, isActive, feeFrom, feeTo, startDate);
    }

    public int countAllCourses() throws SQLException {
        return courseDAO.countAllCourses();
    }

    public int countAllCoursesActive() throws SQLException {
        return courseDAO.countAllCoursesActive();
    }

    private void validateCourse(Course c, boolean isUpdate) {
        if (c == null) {
            throw new IllegalArgumentException("Dữ liệu khóa học không hợp lệ");
        }
        if (!isUpdate && (c.getCourseID() == null || c.getCourseID().trim().isEmpty())) {
            throw new IllegalArgumentException("ID khóa học không được để trống");
        }
        if (c.getCourseID() != null && !c.getCourseID().matches("^CO[0-9]{3}$")) {
            throw new IllegalArgumentException("ID khóa học phải có định dạng COxxx (ví dụ: CO001)");
        }
        if (c.getTitle() == null || c.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên khóa học không được để trống");
        }
        if (c.getFee() < 0) {
            throw new IllegalArgumentException("Học phí không hợp lệ");
        }
        if (c.getDuration() < 0) {
            throw new IllegalArgumentException("Thời lượng không hợp lệ");
        }
        if (c.getStartDate() != null && c.getEndDate() != null && c.getEndDate().before(c.getStartDate())) {
            throw new IllegalArgumentException("Ngày kết thúc phải sau ngày bắt đầu");
        }
    }
}