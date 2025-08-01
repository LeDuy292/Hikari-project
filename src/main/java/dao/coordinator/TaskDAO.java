package dao.coordinator;




import model.coordinator.TaskReview;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.coordinator.Task;

public class TaskDAO {
    
    private Connection con;
    
    public TaskDAO() {
        DBContext dbContext = new DBContext();
        try {
            con = dbContext.getConnection();
            System.out.println("TaskDAO: Database connection established successfully.");
        } catch (Exception e) {
            System.out.println("TaskDAO: Error connecting to database: " + e.getMessage());
        }
    }
    
    public Map<String, Integer> getTaskStatistics(String coordinatorID) {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT \n" +
"                SUM(CASE WHEN status IN ('Assigned', 'In Progress') THEN 1 ELSE 0 END) as pending,\n" +
"                SUM(CASE WHEN status = 'Reviewed' THEN 1 ELSE 0 END) as completed,\n" +
"                SUM(CASE WHEN status = 'Submitted' THEN 1 ELSE 0 END) as submitted,\n" +
"                SUM(CASE WHEN deadline < CURDATE() AND status NOT IN ('Reviewed') THEN 1 ELSE 0 END) as overdue\n" +
"            FROM Task \n" +
"            WHERE coordinatorID = ?";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, coordinatorID);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                stats.put("pending", rs.getInt("pending"));
                stats.put("completed", rs.getInt("completed"));
                stats.put("submitted", rs.getInt("submitted"));
                stats.put("overdue", rs.getInt("overdue"));
            }
        } catch (SQLException e) {
            System.out.println("Error getTaskStatistics: " + e.getMessage());
        }
        
        return stats;
    }
    
    public List<Task> getAllTasks(String coordinatorID) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT t.*, \n" +
"                   u.fullName as teacherName,\n" +
"                   c.title as courseName,\n" +
"                   test.jlptLevel\n" +
"            FROM Task t\n" +
"            LEFT JOIN Teacher teach ON t.teacherID = teach.teacherID\n" +
"            LEFT JOIN UserAccount u ON teach.userID = u.userID\n" +
"            LEFT JOIN Courses c ON t.courseID = c.courseID\n" +
"            LEFT JOIN Test test ON t.testID = test.id\n" +
"            WHERE t.coordinatorID = ?\n" +
"            ORDER BY t.assignedDate DESC";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, coordinatorID);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Task task = new Task();
                task.setId(rs.getInt("id"));
                task.setCoordinatorID(rs.getString("coordinatorID"));
                task.setTeacherID(rs.getString("teacherID"));
                task.setTeacherName(rs.getString("teacherName"));
                task.setCourseID(rs.getString("courseID"));
                task.setCourseName(rs.getString("courseName"));
                task.setTestID(rs.getObject("testID", Integer.class));
                task.setJlptLevel(rs.getString("jlptLevel"));
                task.setAssignedDate(rs.getTimestamp("assignedDate"));
                task.setDeadline(rs.getDate("deadline"));
                task.setDescription(rs.getString("description"));
                task.setStatus(rs.getString("status"));
                
                tasks.add(task);
            }
        } catch (SQLException e) {
            System.out.println("Error getAllTasks: " + e.getMessage());
        }
        
        return tasks;
    }
    
    public boolean createTask(Task task) {
        String sql = "INSERT INTO Task (coordinatorID, teacherID, courseID, testID, assignedDate, deadline, description, status)\n" +
"            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, task.getCoordinatorID());
            stmt.setString(2, task.getTeacherID());
            stmt.setString(3, task.getCourseID());
            if (task.getTestID() != null) {
                stmt.setInt(4, task.getTestID());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }
            stmt.setTimestamp(5, task.getAssignedDate());
            stmt.setDate(6, task.getDeadline());
            stmt.setString(7, task.getDescription());
            stmt.setString(8, task.getStatus());
            
            int result = stmt.executeUpdate();
            
            // Nếu là nhiệm vụ khóa học, set isActive = FALSE
            if (result > 0 && task.getCourseID() != null) {
                updateCourseActiveStatus(task.getCourseID(), false);
            }
            
            return result > 0;
            
        } catch (SQLException e) {
            System.out.println("Error createTask: " + e.getMessage());
            return false;
        }
    }
    
    public boolean approveTask(int taskId) {
        try {
            con.setAutoCommit(false);
            
            // Lấy thông tin task
            Task task = getTaskById(taskId);
            if (task == null) return false;
            
            // Cập nhật trạng thái task
            String updateTaskSql = "UPDATE Task SET status = 'Reviewed' WHERE id = ?";
            try (PreparedStatement stmt = con.prepareStatement(updateTaskSql)) {
                stmt.setInt(1, taskId);
                stmt.executeUpdate();
            }
            
            // Kích hoạt khóa học hoặc bài test
            if (task.getCourseID() != null) {
                updateCourseActiveStatus(task.getCourseID(), true);
            } else if (task.getTestID() != null) {
                updateTestActiveStatus(task.getTestID(), true);
            }
            
            con.commit();
            return true;
            
        } catch (SQLException e) {
            try {
                con.rollback();
            } catch (SQLException ex) {
                System.out.println("Error rollback: " + ex.getMessage());
            }
            System.out.println("Error approveTask: " + e.getMessage());
            return false;
        } finally {
            try {
                con.setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println("Error setAutoCommit: " + e.getMessage());
            }
        }
    }
    
    public boolean rejectTask(int taskId, String reason) {
        String sql = "UPDATE Task SET status = 'Rejected' WHERE id = ?";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error rejectTask: " + e.getMessage());
            return false;
        }
    }
    
    public Task getTaskById(int taskId) {
        String sql = "SELECT t.*, \n" +
"                   u.fullName as teacherName,\n" +
"                   c.title as courseName,\n" +
"                   test.jlptLevel\n" +
"            FROM Task t\n" +
"            LEFT JOIN Teacher teach ON t.teacherID = teach.teacherID\n" +
"            LEFT JOIN UserAccount u ON teach.userID = u.userID\n" +
"            LEFT JOIN Courses c ON t.courseID = c.courseID\n" +
"            LEFT JOIN Test test ON t.testID = test.id\n" +
"            WHERE t.id = ?";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Task task = new Task();
                task.setId(rs.getInt("id"));
                task.setCoordinatorID(rs.getString("coordinatorID"));
                task.setTeacherID(rs.getString("teacherID"));
                task.setTeacherName(rs.getString("teacherName"));
                task.setCourseID(rs.getString("courseID"));
                task.setCourseName(rs.getString("courseName"));
                task.setTestID(rs.getObject("testID", Integer.class));
                task.setJlptLevel(rs.getString("jlptLevel"));
                task.setAssignedDate(rs.getTimestamp("assignedDate"));
                task.setDeadline(rs.getDate("deadline"));
                task.setDescription(rs.getString("description"));
                task.setStatus(rs.getString("status"));
                
                return task;
            }
        } catch (SQLException e) {
            System.out.println("Error getTaskById: " + e.getMessage());
        }
        
        return null;
    }
    
    public List<TaskReview> getTaskReviews() {
        List<TaskReview> reviews = new ArrayList<>();
        String sql = "SELECT tr.*, u.fullName as reviewerName,\n" +
"                   COALESCE(c.title, CONCAT('JLPT ', test.jlptLevel, ' Test')) as entityTitle\n" +
"            FROM TaskReview tr\n" +
"            LEFT JOIN UserAccount u ON tr.reviewerID = u.userID\n" +
"            LEFT JOIN Courses c ON tr.courseID = c.courseID\n" +
"            LEFT JOIN Test test ON tr.testID = test.id\n" +
"            ORDER BY tr.reviewDate DESC";
        
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TaskReview review = new TaskReview();
                review.setId(rs.getInt("id"));
                review.setCourseID(rs.getString("courseID"));
                review.setTestID(rs.getObject("testID", Integer.class));
                review.setEntityTitle(rs.getString("entityTitle"));
                review.setReviewerID(rs.getString("reviewerID"));
                review.setReviewerName(rs.getString("reviewerName"));
                review.setRating(rs.getInt("rating"));
                review.setReviewText(rs.getString("reviewText"));
                review.setReviewStatus(rs.getString("reviewStatus"));
                review.setReviewDate(rs.getTimestamp("reviewDate"));
                
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Error getTaskReviews: " + e.getMessage());
        }
        
        return reviews;
    }
    
    private void updateCourseActiveStatus(String courseID, boolean isActive) throws SQLException {
        String sql = "UPDATE Courses SET isActive = ? WHERE courseID = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setBoolean(1, isActive);
            stmt.setString(2, courseID);
            stmt.executeUpdate();
        }
    }
    
    private void updateTestActiveStatus(int testID, boolean isActive) throws SQLException {
        String sql = "UPDATE Test SET isActive = ? WHERE id = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setBoolean(1, isActive);
            stmt.setInt(2, testID);
            stmt.executeUpdate();
        }
    }
    
    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("TaskDAO: Database connection closed.");
            }
        } catch (SQLException e) {
            System.out.println("TaskDAO: Error closing connection: " + e.getMessage());
        }
    }
}
