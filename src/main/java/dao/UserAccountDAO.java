package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.UserAccount;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class UserAccountDAO extends DBContext {
    private static final Logger logger = LoggerFactory.getLogger(UserAccountDAO.class);

    public List<UserAccount> getAllUsers() {
        List<UserAccount> users = new ArrayList<>();
        String sql = "SELECT userID, username, profilePicture FROM UserAccount";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserAccount user = new UserAccount();
                user.setUserID(rs.getString("userID"));
                user.setUsername(rs.getString("username"));
                user.setProfilePicture(rs.getString("profilePicture"));
                users.add(user);

            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public UserAccount getStudentNameById(String id) {
        UserAccount user = new UserAccount();
        String sql = "Select fullName from UserAccount u join Student s on u.userID = s.userID where s.studentID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                user.setFullName(rs.getString("fullName"));
            }
        } catch (Exception e) {
        }
        return user ; 
    }
    
        public void updateUserRole(String userID, String role) {
        String sql = "UPDATE UserAccount SET role = ? WHERE userID = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role);
            pstmt.setString(2, userID);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                logger.info("UserAccountDAO: Updated role to {} for userID: {}", role, userID);
            } else {
                logger.warn("UserAccountDAO: No user found to update role for userID: {}", userID);
            }
        } catch (SQLException e) {
            logger.error("UserAccountDAO: Error updating role for userID {}: {}", userID, e.getMessage(), e);
        }
    }
        
    public static void main(String[] args) {
        UserAccountDAO dao = new UserAccountDAO();
        System.out.println(dao.getStudentNameById("S001"));
    }
}
