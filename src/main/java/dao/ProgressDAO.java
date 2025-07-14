package dao;

import model.Progress;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBContext;

public class ProgressDAO {

    // Get progress by student ID
    public List<Progress> getProgressByStudent(String studentID) {
        List<Progress> progressList = new ArrayList<>();
        String sql = "SELECT p.id, p.studentID, p.lessonID, p.completionStatus, \n"
                + "                   p.startDate, p.endDate, p.score, p.feedback,\n"
                + "                   l.title as lessonTitle, l.description as lessonDescription, \n"
                + "                   l.duration, t.topicID, t.topicName \n"
                + "            FROM Progress p\n"
                + "            INNER JOIN Lesson l ON p.lessonID = l.id\n"
                + "            INNER JOIN Topic t ON l.topicID = t.topicID\n"
                + "            WHERE p.studentID = ?\n"
                + "            ORDER BY p.startDate DESC";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Progress progress = mapResultSetToProgress(rs);
                progressList.add(progress);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return progressList;
    }

    // Get progress by student and class
    public List<Progress> getProgressByStudentAndClass(String studentID, String classID) {
        List<Progress> progressList = new ArrayList<>();
        String sql = "SELECT \n"
                + "    p.id, \n"
                + "    p.studentID, \n"
                + "    p.lessonID, \n"
                + "    p.completionStatus, \n"
                + "    p.startDate, \n"
                + "    p.endDate, \n"
                + "    p.score, \n"
                + "    p.feedback,\n"
                + "    l.title AS lessonTitle, \n"
                + "    l.description AS lessonDescription, \n"
                + "    l.duration, \n"
                + "    t.topicID, \n"
                + "    t.topicName\n"
                + "FROM Progress p\n"
                + "INNER JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID\n"
                + "INNER JOIN Lesson l ON p.lessonID = l.id\n"
                + "INNER JOIN Topic t ON l.topicID = t.topicID\n"
                + "INNER JOIN Courses c ON ce.courseID = c.courseID\n"
                + "INNER JOIN Class cl ON c.courseID = cl.courseID\n"
                + "INNER JOIN Class_Students cs ON cl.classID = cs.classID\n"
                + "WHERE p.studentID = ? AND cl.classID = ?\n"
                + "ORDER BY p.startDate DESC;";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, studentID);
            stmt.setString(2, classID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Progress progress = mapResultSetToProgress(rs);
                progressList.add(progress);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return progressList;
    }

    // Get progress statistics by student
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

    // Get average score by student
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

    // Update progress
    public boolean updateProgress(Progress progress) {
        String sql = "UPDATE Progress \n"
                + "            SET completionStatus = ?, endDate = ?, score = ?, feedback = ?\n"
                + "            WHERE progressID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, progress.getCompletionStatus());
            stmt.setDate(2, progress.getEndDate());
            stmt.setInt(3, progress.getScore());
            stmt.setString(4, progress.getFeedback());
            stmt.setInt(5, progress.getProgressID());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Helper method to map ResultSet to Progress
    private Progress mapResultSetToProgress(ResultSet rs) throws SQLException {
        Progress progress = new Progress();

        progress.setProgressID(rs.getInt("id"));
        progress.setStudentID(rs.getString("studentID"));
        progress.setLessonID(rs.getInt("lessonID"));
        progress.setCompletionStatus(rs.getString("completionStatus"));
        progress.setStartDate(rs.getDate("startDate"));
        progress.setEndDate(rs.getDate("endDate"));
        progress.setScore(rs.getInt("score"));
        progress.setFeedback(rs.getString("feedback"));

        progress.setLessonTitle(rs.getString("lessonTitle"));
        progress.setLessonDescription(rs.getString("lessonDescription"));
        progress.setDuration(rs.getInt("duration"));
        progress.setTopicID(rs.getString("topicID"));
        progress.setTopicName(rs.getString("topicName"));

        return progress;
    }

    public static void main(String[] args) {
        ProgressDAO dao = new ProgressDAO();
        System.out.println(dao.getProgressByStudent("S002"));
        System.out.println(dao.getProgressByStudentAndClass("S002", "CL001"));
    }
}
