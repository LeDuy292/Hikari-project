package dao;

import model.Task;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TaskDAO {

    private static final Logger logger = LoggerFactory.getLogger(TaskDAO.class);
    private final DBContext dbContext;

    public TaskDAO() {
        this.dbContext = new DBContext();
    }

    private Connection getConnection() throws SQLException {
        return dbContext.getConnection();
    }

    public List<Task> getTasksByTeacher(String teacherID) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "       u.fullName AS coordinatorName, "
                + "       c.title AS courseName, "
                + "       ts.jlptLevel "
                + "FROM Task t "
                + "LEFT JOIN UserAccount u ON t.coordinatorID = u.userID "
                + "LEFT JOIN Courses c ON t.courseID = c.courseID "
                + "LEFT JOIN Test ts ON t.testID = ts.id "
                + "WHERE t.teacherID = ? "
                + "ORDER BY t.assignedDate DESC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, teacherID);
            logger.debug("Executing getTasksByTeacher for teacherID: {}", teacherID);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setTaskID(rs.getInt("id"));
                    task.setCoordinatorID(rs.getString("coordinatorID"));
                    task.setTeacherID(rs.getString("teacherID"));
                    task.setCourseID(rs.getString("courseID"));
                    task.setTestID(rs.getObject("testID") != null ? rs.getInt("testID") : null);
                    task.setAssignedDate(rs.getTimestamp("assignedDate"));
                    task.setDeadline(rs.getDate("deadline"));
                    task.setStatus(rs.getString("status"));
                    task.setCoordinatorName(rs.getString("coordinatorName"));
                    task.setCourseName(rs.getString("courseName"));
                    task.setJlptLevel(rs.getString("jlptLevel"));
                    task.setDescription(rs.getString("description"));
                    tasks.add(task);
                    logger.debug("Found task: {}", task);
                }
                logger.info("Retrieved {} tasks for teacherID: {}", tasks.size(), teacherID);
            }
        } catch (SQLException e) {
            logger.error("SQL error in getTasksByTeacher for teacherID {}: {}", teacherID, e.getMessage(), e);
            throw e;
        }

        return tasks;
    }

    public Task getTaskById(int taskID) throws SQLException {
        String sql = "SELECT t.*, "
                + "u.fullName AS coordinatorName, c.title AS courseName , ts.jlptLevel "
                + "FROM Task t "
                + "LEFT JOIN UserAccount u ON t.coordinatorID = u.userID "
                + "LEFT JOIN Courses c ON t.courseID = c.courseID "
                + "LEFT JOIN Test ts ON t.testID = ts.id "
                + "WHERE t.id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, taskID);
            logger.debug("Executing getTaskById for taskID: {}", taskID);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Task task = new Task();
                    task.setTaskID(rs.getInt("id"));
                    task.setCoordinatorID(rs.getString("coordinatorID"));
                    task.setTeacherID(rs.getString("teacherID"));
                    task.setCourseID(rs.getString("courseID"));
                    task.setTestID(rs.getObject("testID") != null ? rs.getInt("testID") : null);
                    task.setAssignedDate(rs.getTimestamp("assignedDate"));
                    task.setDeadline(rs.getDate("deadline"));
                    task.setStatus(rs.getString("status"));
                    task.setCoordinatorName(rs.getString("coordinatorName"));
                    task.setCourseName(rs.getString("courseName"));
                    task.setJlptLevel(rs.getString("jlptLevel"));
                    task.setDescription(rs.getString("description"));
                    logger.debug("Found task: {}", task);
                    return task;
                }
            }
        } catch (SQLException e) {
            logger.error("SQL error in getTaskById for taskID {}: {}", taskID, e.getMessage(), e);
            throw e;
        }

        return null;
    }

    public List<Task> getTasksByStatus(String teacherID, String status) throws SQLException {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, "
                + "       u.fullName AS coordinatorName, "
                + "       c.title AS courseName, "
                + "       ts.jlptLevel "
                + "FROM Task t "
                + "LEFT JOIN UserAccount u ON t.coordinatorID = u.userID "
                + "LEFT JOIN Courses c ON t.courseID = c.courseID "
                + "LEFT JOIN Test ts ON t.testID = ts.id "
                + "WHERE t.teacherID = ? AND t.status = ? "
                + "ORDER BY t.assignedDate DESC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, teacherID);
            stmt.setString(2, status);
            logger.debug("Executing getTasksByStatus for teacherID: {}, status: {}", teacherID, status);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Task task = new Task();
                    task.setTaskID(rs.getInt("id"));
                    task.setCoordinatorID(rs.getString("coordinatorID"));
                    task.setTeacherID(rs.getString("teacherID"));
                    task.setCourseID(rs.getString("courseID"));
                    task.setTestID(rs.getObject("testID") != null ? rs.getInt("testID") : null);
                    task.setAssignedDate(rs.getTimestamp("assignedDate"));
                    task.setDeadline(rs.getDate("deadline"));
                    task.setStatus(rs.getString("status"));
                    task.setCoordinatorName(rs.getString("coordinatorName"));
                    task.setCourseName(rs.getString("courseName"));
                    task.setJlptLevel(rs.getString("jlptLevel"));
                    task.setDescription(rs.getString("description"));
                    tasks.add(task);
                    logger.debug("Found task: {}", task);
                }
                logger.info("Retrieved {} tasks for teacherID: {}, status: {}", tasks.size(), teacherID, status);
            }
        } catch (SQLException e) {
            logger.error("SQL error in getTasksByStatus for teacherID {}, status {}: {}", teacherID, status, e.getMessage(), e);
            throw e;
        }

        return tasks;
    }

    public int[] getTaskStatistics(String teacherID) throws SQLException {
        int[] stats = new int[3]; // [incomplete, completed, submitted]

        String sql = "SELECT "
                + "    SUM(CASE WHEN status IN ('Assigned', 'In Progress') THEN 1 ELSE 0 END) AS incomplete, "
                + "    SUM(CASE WHEN status IN ('Submitted', 'Reviewed') THEN 1 ELSE 0 END) AS completed, "
                + "    SUM(CASE WHEN status = 'Submitted' THEN 1 ELSE 0 END) AS submitted "
                + "FROM Task "
                + "WHERE teacherID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, teacherID);
            logger.debug("Executing getTaskStatistics for teacherID: {}", teacherID);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats[0] = rs.getInt("incomplete");
                    stats[1] = rs.getInt("completed");
                    stats[2] = rs.getInt("submitted");
                }
            }
        } catch (SQLException e) {
            logger.error("SQL error in getTaskStatistics for teacherID {}: {}", teacherID, e.getMessage(), e);
            throw e;
        }

        logger.info("Task statistics for teacherID {}: incomplete={}, completed={}, submitted={}",
                teacherID, stats[0], stats[1], stats[2]);
        return stats;
    }

    public boolean updateTaskStatus(int taskID, String status) throws SQLException {
        String sql = "UPDATE Task SET status = ? WHERE id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, taskID);
            logger.debug("Executing updateTaskStatus for taskID: {}, status: {}", taskID, status);

            int result = stmt.executeUpdate();
            logger.info("Updated task status for taskID: {}, status: {}, result: {}", taskID, status, result);
            return result > 0;
        } catch (SQLException e) {
            logger.error("SQL error in updateTaskStatus for taskID {}, status {}: {}", taskID, status, e.getMessage(), e);
            throw e;
        }
    }

    public static void main(String[] args) {
        TaskDAO dao = new TaskDAO();
        try {
            System.out.println(dao.getTaskById(1));
        } catch (SQLException ex) {
            java.util.logging.Logger.getLogger(TaskDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
