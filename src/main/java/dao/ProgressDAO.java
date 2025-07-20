package dao;

import model.Progress;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class ProgressDAO {

    public List<Progress> getProgressByStudent(String studentID) {
        List<Progress> progressList = new ArrayList<>();
        String sql = "SELECT p.id, p.studentID, p.enrollmentID, p.lessonID, p.assignmentID, "
                + "                   p.completionStatus, p.startDate, p.endDate, p.score, "
                + "                   a.title AS assignmentTitle, a.description AS assignmentDescription, a.duration, " // Added a.description here if available
                + "                   l.title AS lessonTitle, l.description AS lessonDescription, "
                + "                   t.topicID, t.topicName "
                + "            FROM Progress p "
                + "            LEFT JOIN Assignment a ON p.assignmentID = a.id " // Thay đổi từ INNER JOIN sang LEFT JOIN
                + "            LEFT JOIN Lesson l ON p.lessonID = l.id " // Thay đổi từ INNER JOIN sang LEFT JOIN
                + "            LEFT JOIN Topic t ON l.topicID = t.topicID " // Topic vẫn LEFT JOIN với Lesson
                + "            WHERE p.studentID = ? "
                + "            ORDER BY p.startDate DESC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Progress progress = mapResultSetToProgress(rs);
                progressList.add(progress);
            }

        } catch (SQLException e) {
        }

        return progressList;
    }
  public Progress getProgressByStudentAndLesson(String studentID, int lessonID) {
        String sql = "SELECT id, studentID, enrollmentID, lessonID, assignmentID, completionStatus, startDate, endDate, score FROM Progress WHERE studentID = ? AND lessonID = ?";
        try (Connection conn = new utils.DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentID);
            stmt.setInt(2, lessonID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error getting progress by student and lesson: " + e.getMessage());
        }
        return null;
    }
    public Progress getProgressByLesson(String enrollmentID, int lessonID) {
        String sql = "SELECT id, studentID, enrollmentID, lessonID, assignmentID, completionStatus, startDate, endDate, score FROM Progress WHERE enrollmentID = ? AND lessonID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, enrollmentID);
            stmt.setInt(2, lessonID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting progress by enrollment and lesson: " + e.getMessage());
        }
        return null;
    }
     public Progress getProgressByAssignment(String enrollmentID, int assignmentID) {
        String sql = "SELECT id, studentID, enrollmentID, lessonID, assignmentID, completionStatus, startDate, endDate, score FROM Progress WHERE enrollmentID = ? AND assignmentID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, enrollmentID);
            stmt.setInt(2, assignmentID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error getting progress by enrollment and assignment: " + e.getMessage());
        }
        return null;
    }
   public Progress getProgressByStudentAndAssignment(String studentID, int assignmentID) {
        String sql = "SELECT id, studentID, enrollmentID, lessonID, assignmentID, completionStatus, startDate, endDate, score FROM Progress WHERE studentID = ? AND assignmentID = ?";
        try (Connection conn = new utils.DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentID);
            stmt.setInt(2, assignmentID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToProgress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error getting progress by student and assignment: " + e.getMessage());
        }
        return null;
    }
    // Phương thức insertProgress mới để thêm tiến độ (nếu chưa có trong ProgressDAO của bạn)
    public boolean insertProgress(Progress progress) {
        String sql = "INSERT INTO Progress (studentID, enrollmentID, lessonID, assignmentID, completionStatus, startDate, endDate, score) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, progress.getStudentID());
            stmt.setString(2, progress.getEnrollmentID());
            
            // Xử lý giá trị NULL cho lessonID và assignmentID
            if (progress.getLessonID() != 0) { // Giả định 0 là giá trị mặc định khi không có lessonID
                stmt.setInt(3, progress.getLessonID());
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            if (progress.getAssignmentID() != 0) { // Giả định 0 là giá trị mặc định khi không có assignmentID
                stmt.setInt(4, progress.getAssignmentID());
            } else {
                stmt.setNull(4, Types.INTEGER);
            }
            
            stmt.setString(5, progress.getCompletionStatus());
            stmt.setDate(6, progress.getStartDate());
            stmt.setDate(7, progress.getEndDate()); // Có thể là NULL
            
            // Xử lý giá trị NULL cho score
            if (progress.getScore() != 0) { // Giả định 0 là giá trị mặc định khi không có score
                stmt.setDouble(8, progress.getScore());
            } else {
                stmt.setNull(8, Types.INTEGER); // Hoặc Types.DECIMAL tùy thuộc vào kiểu dữ liệu score trong model
            }

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
     public int[] getProgressStatsByStudent(String studentID) {
        String sql = " SELECT \n"
                + "                COUNT(*) as totalLessons,\n"
                + "                SUM(CASE WHEN completionStatus = 'complete' THEN 1 ELSE 0 END) as completedLessons,\n"
                + "                SUM(CASE WHEN completionStatus = 'in progress' THEN 1 ELSE 0 END) as inProgressLessons\n"
                + "            FROM Progress \n"
                + "            WHERE studentID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new int[]{
                    rs.getInt("totalLessons"),
                    rs.getInt("completedLessons"),
                    rs.getInt("inProgressLessons")
                };
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new int[]{0, 0, 0};
    }


    public boolean updateProgress(Progress progress) {
        String sql = "UPDATE Progress SET completionStatus = ?, endDate = ?, score = ? WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, progress.getCompletionStatus());
            stmt.setDate(2, progress.getEndDate());
             if (progress.getScore() != 0) {
                stmt.setDouble(3, progress.getScore());
            } else {
                stmt.setNull(3, Types.INTEGER); // Hoặc Types.DECIMAL
            }
            stmt.setInt(4, progress.getProgressID());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
 public double getAverageScoreByStudent(String studentID) {
        String sql = " SELECT AVG(score) as averageScore\n"
                + "            FROM Progress \n"
                + "            WHERE studentID = ? AND score IS NOT NULL AND score > 0";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("averageScore");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

private Progress mapResultSetToProgress(ResultSet rs) throws SQLException {
    Progress progress = new Progress();
    progress.setProgressID(rs.getInt("id"));
    progress.setStudentID(rs.getString("studentID"));
    progress.setEnrollmentID(rs.getString("enrollmentID"));
    progress.setLessonID(rs.getInt("lessonID"));
    if (rs.wasNull()) progress.setLessonID(0);
    progress.setAssignmentID(rs.getInt("assignmentID"));
    if (rs.wasNull()) progress.setAssignmentID(0);
    progress.setCompletionStatus(rs.getString("completionStatus"));
    progress.setStartDate(rs.getDate("startDate"));
    progress.setEndDate(rs.getDate("endDate"));
    progress.setScore(rs.getDouble("score"));
    if (rs.wasNull()) progress.setScore(0);

    // Kiểm tra xem cột có tồn tại trước khi truy cập
    try {
        progress.setAssignmentTitle(rs.getString("assignmentTitle"));
    } catch (SQLException e) {
        progress.setAssignmentTitle(null); // Hoặc giá trị mặc định
    }
    try {
        progress.setAssignmentDescription(rs.getString("assignmentDescription"));
    } catch (SQLException e) {
        progress.setAssignmentDescription(null);
    }
    try {
        progress.setLessonTitle(rs.getString("lessonTitle"));
    } catch (SQLException e) {
        progress.setLessonTitle(null);
    }
    try {
        progress.setLessonDescription(rs.getString("lessonDescription"));
    } catch (SQLException e) {
        progress.setLessonDescription(null);
    }
    try {
        progress.setDuration(rs.getInt("duration"));
        if (rs.wasNull()) progress.setDuration(0);
    } catch (SQLException e) {
        progress.setDuration(0);
    }
    try {
        progress.setTopicID(rs.getString("topicID"));
    } catch (SQLException e) {
        progress.setTopicID(null);
    }
    try {
        progress.setTopicName(rs.getString("topicName"));
    } catch (SQLException e) {
        progress.setTopicName(null);
    }

    return progress;
}
     public List<Progress> getProgressByStudentAndClass(String studentID, String classID) {
        List<Progress> progressList = new ArrayList<>();
        String sql = "SELECT \n"
                + "    p.id, \n"
                + "    p.studentID, \n"
                + "    p.enrollmentID, \n" // Thêm enrollmentID vào SELECT
                + "    p.lessonID, \n"
                + "    p.assignmentID, \n" // Thêm assignmentID vào SELECT
                + "    p.completionStatus, \n"
                + "    p.startDate, \n"
                + "    p.endDate, \n"
                + "    p.score, \n"
                + "    l.title AS lessonTitle, \n"
                + "    l.description AS lessonDescription, \n"
                + "    t.topicID, \n"
                + "    t.topicName, \n"
                + "    a.title AS assignmentTitle, \n" // Thêm thông tin Assignment
                + "    a.description AS assignmentDescription, \n" // Thêm thông tin Assignment
                + "    a.duration \n" // Thêm thông tin Assignment
                + "FROM Progress p\n"
                + "INNER JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID\n"
                + "INNER JOIN Courses c ON ce.courseID = c.courseID\n"
                + "INNER JOIN Class cl ON c.courseID = cl.courseID\n"
                + "INNER JOIN Class_Students cs ON cl.classID = cs.classID AND cs.studentID = p.studentID\n"
                + "LEFT JOIN Lesson l ON p.lessonID = l.id\n" // Thay đổi thành LEFT JOIN
                + "LEFT JOIN Topic t ON l.topicID = t.topicID\n" // Thay đổi thành LEFT JOIN
                + "LEFT JOIN Assignment a ON p.assignmentID = a.id\n" // Thêm LEFT JOIN cho Assignment
                + "WHERE p.studentID = ? AND cl.classID = ?\n"
                + "ORDER BY p.startDate DESC;";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentID);
            stmt.setString(2, classID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Progress progress = mapResultSetToProgress(rs); //
                progressList.add(progress);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Nên in ra lỗi để debug
        }

        return progressList;
    }


    public static void main(String[] args) {
        ProgressDAO dao = new ProgressDAO();
        
        System.out.println("Tiến độ của sinh viên S002:");
        List<Progress> studentProgress = dao.getProgressByStudent("S002");
        for (Progress p : studentProgress) {
            // Đảm bảo toString() trong Progress.java hiển thị đầy đủ thông tin để kiểm tra
            System.out.println(p.toString()); 
        }

        System.out.println("\nTiến độ của sinh viên S002 trong lớp CL001:");
        List<Progress> studentClassProgress = dao.getProgressByStudentAndClass("S002", "CL001");
        for (Progress p : studentClassProgress) {
             System.out.println(p.toString());
        }

        System.out.println("\nThống kê tiến độ của sinh viên S002:");
        int[] stats = dao.getProgressStatsByStudent("S002");
        System.out.println("Tổng số mục: " + stats[0] + ", Hoàn thành: " + stats[1] + ", Đang tiến hành: " + stats[2]);

        System.out.println("\nĐiểm trung bình của sinh viên S002: " + dao.getAverageScoreByStudent("S002"));
    }
}