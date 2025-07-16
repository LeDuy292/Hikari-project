package dao.document;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.DBContext;


public class TeacherDAO extends DBContext {
    private static final Logger LOGGER = Logger.getLogger(TeacherDAO.class.getName());

    public String getTeacherIDByUserID(String userID) {
        String sql = "SELECT teacherID FROM Teacher WHERE userID = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String teacherID = rs.getString("teacherID");
                LOGGER.info("Found teacherID: " + teacherID + " for userID: " + userID);
                return teacherID;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting teacherID for userID: " + userID, ex);
        }
        LOGGER.warning("No teacherID found for userID: " + userID);
        return null;
    }

    public String getUserIDByTeacherID(String teacherID) {
        String sql = "SELECT userID FROM Teacher WHERE teacherID = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, teacherID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("userID");
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error getting userID for teacherID: " + teacherID, ex);
        }
        return null;
    }

    public boolean isValidTeacher(String teacherID) {
        String sql = "SELECT COUNT(*) FROM Teacher WHERE teacherID = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, teacherID);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking if teacher exists: " + teacherID, ex);
        }
        return false;
    }
}
