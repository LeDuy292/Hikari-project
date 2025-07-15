package dao.document;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.DBContext;


public class StudentDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(StudentDAO.class.getName());

    public String getStudentIDByUserID(String userID) {
        String sql = "SELECT studentID FROM Student WHERE userID = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String studentID = rs.getString("studentID");
                LOGGER.info("Found studentID: " + studentID + " for userID: " + userID);
                return studentID;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting studentID for userID: " + userID, ex);
        }
        LOGGER.warning("No studentID found for userID: " + userID);
        return null;
    }

    public String getUserIDByStudentID(String studentID) {
        String sql = "SELECT userID FROM Student WHERE studentID = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("userID");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting userID for studentID: " + studentID, ex);
        }
        return null;
    }

    public boolean isValidStudent(String studentID) {
        String sql = "SELECT COUNT(*) FROM Student WHERE studentID = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking if student exists: " + studentID, ex);
        }
        return false;
    }
}
