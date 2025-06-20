package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.logging.Level;
import model.UserAccount;
import utils.DBContext;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    private final DBContext dbContext;

    public UserDAO() {
        this.dbContext = new DBContext();
    }

    public UserAccount authenticateUser(String username, String password) throws ClassNotFoundException, SQLException {
        String sql = "SELECT userID, role FROM UserAccount WHERE username = ? AND password = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password); // Compare directly with plaintext
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserAccount user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setRole(rs.getString("role"));
                    user.setUsername(username);
                    return user;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error authenticating user: " + username + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    public boolean registerUser(UserAccount user) throws ClassNotFoundException, SQLException {
        if (isEmailExists(user.getEmail()) || isUsernameExists(user.getUsername())) {
            LOGGER.warning("Registration failed: Email or username already exists for " + user.getEmail());
            return false;
        }

        String sql = "INSERT INTO UserAccount (userID, username, email, password, role, fullName, registrationDate, profilePicture, phone, birthDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // Start transaction
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, user.getUserID()); // Now userID is already set
                stmt.setString(2, user.getUsername());
                stmt.setString(3, user.getEmail());
                stmt.setString(4, user.getPassword()); // Store plaintext
                stmt.setString(5, user.getRole());
                stmt.setString(6, user.getFullName() != null ? user.getFullName() : user.getUsername());
                stmt.setDate(7, Date.valueOf(LocalDate.now()));
                stmt.setString(8, null);
                stmt.setString(9, null);
                stmt.setDate(10, null);
                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    conn.commit();
                    LOGGER.info("User registered successfully: " + user.getUsername() + " with ID: " + user.getUserID());
                    return true;
                }
                conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.severe("Rollback failed: " + rollbackEx.getMessage());
                }
            }
            LOGGER.severe("SQL error during registration: " + e.getMessage());
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    LOGGER.severe("Error closing connection: " + closeEx.getMessage());
                }
            }
        }
    }

    private boolean isEmailExists(String email) throws ClassNotFoundException, SQLException {
        return findByEmail(email) != null;
    }

    private boolean isUsernameExists(String username) throws ClassNotFoundException, SQLException {
        String sql = "SELECT COUNT(*) FROM UserAccount WHERE username = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error checking username existence: " + e.getMessage());
            throw e;
        }
        return false;
    }

    // FIX: Updated generateNewUserID method to use correct table name
    public String generateNewUserID() throws SQLException, ClassNotFoundException {
        String query = "SELECT userID FROM UserAccount WHERE userID LIKE 'U%' ORDER BY userID DESC LIMIT 1";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                String lastID = rs.getString("userID"); // ví dụ: U007
                int num = Integer.parseInt(lastID.substring(1)); // lấy 007 → 7
                int newNum = num + 1;
                return String.format("U%03d", newNum); // → U008
            } else {
                return "U001"; // Nếu chưa có ai trong bảng
            }
        } catch (SQLException e) {
            LOGGER.severe("Error generating new userID: " + e.getMessage());
            throw e;
        }
    }

    public UserAccount findByEmail(String email) throws ClassNotFoundException, SQLException {
        UserAccount user = null;
        String sql = "SELECT * FROM UserAccount WHERE email = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("fullName"));
                    user.setRegistrationDate(rs.getDate("registrationDate"));
                    user.setProfilePicture(rs.getString("profilePicture"));
                    user.setPhone(rs.getString("phone"));
                    user.setBirthDate(rs.getDate("birthDate"));
                    user.setOtp(rs.getString("otp"));
                    user.setOtpExpiry(rs.getTimestamp("otpExpiry"));
                    user.setResetToken(rs.getString("resetToken"));
                    user.setResetTokenExpiry(rs.getTimestamp("resetTokenExpiry"));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by email: " + email + ", " + e.getMessage());
            throw e;
        }
        return user;
    }

    public void updateOtp(UserAccount user) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE UserAccount SET otp = ?, otpExpiry = ? WHERE userID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getOtp());
            pstmt.setTimestamp(2, user.getOtpExpiry() != null ? new Timestamp(user.getOtpExpiry().getTime()) : null);
            pstmt.setString(3, user.getUserID());
            int rows = pstmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("No user found with userNum: " + user.getUserID());
            }
            LOGGER.info("OTP updated for userNum: " + user.getUserID());
        } catch (SQLException e) {
            LOGGER.severe("Error updating OTP for userNum: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        }
    }

    public UserAccount findByOtp(String otp) throws ClassNotFoundException, SQLException {
        UserAccount user = null;
        String sql = "SELECT * FROM UserAccount WHERE otp = ? AND (otpExpiry IS NULL OR otpExpiry > ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, otp);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setOtp(rs.getString("otp"));
                    user.setOtpExpiry(rs.getTimestamp("otpExpiry"));
                    user.setResetToken(rs.getString("resetToken"));
                    user.setResetTokenExpiry(rs.getTimestamp("resetTokenExpiry"));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by OTP: " + otp + ", " + e.getMessage());
            throw e;
        }
        return user;
    }

    public void updatePassword(UserAccount user) throws ClassNotFoundException, SQLException {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // Start transaction
            String sql = "UPDATE UserAccount SET password = ?, otp = ?, otpExpiry = ?, sessionId = ? WHERE UserID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, user.getPassword()); // Store plaintext
                pstmt.setString(2, null); // Reset otp to null
                pstmt.setTimestamp(3, null); // Reset otpExpiry to null
                pstmt.setString(4, null); // Invalidate session
                pstmt.setString(5, user.getUserID());
                int rows = pstmt.executeUpdate();
                if (rows == 0) {
                    throw new SQLException("No user found with userNum: " + user.getUserID());
                }
                conn.commit();
                LOGGER.info("Password updated for userNum: " + user.getUserID());
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.severe("Rollback failed: " + rollbackEx.getMessage());
                }
            }
            LOGGER.severe("Error updating password for userNum: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    LOGGER.severe("Error closing connection: " + closeEx.getMessage());
                }
            }
        }
    }

    public void updateResetToken(UserAccount user) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE UserAccount SET resetToken = ?, resetTokenExpiry = ? WHERE userID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getResetToken());
            pstmt.setTimestamp(2, user.getResetTokenExpiry() != null ? new Timestamp(user.getResetTokenExpiry().getTime()) : null);
            pstmt.setString(3, user.getUserID());
            int rows = pstmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("No user found with userNum: " + user.getUserID());
            }
            LOGGER.info("Reset token updated for userNum: " + user.getUserID());
        } catch (SQLException e) {
            LOGGER.severe("Error updating reset token for userNum: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        }
    }

    public UserAccount findByResetToken(String resetToken) throws ClassNotFoundException, SQLException {
        UserAccount user = null;
        String sql = "SELECT * FROM UserAccount WHERE resetToken = ? AND (resetTokenExpiry IS NULL OR resetTokenExpiry > ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, resetToken);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setOtp(rs.getString("otp"));
                    user.setOtpExpiry(rs.getTimestamp("otpExpiry"));
                    user.setResetToken(rs.getString("resetToken"));
                    user.setResetTokenExpiry(rs.getTimestamp("resetTokenExpiry"));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by reset token: " + resetToken + ", " + e.getMessage());
            throw e;
        }
        return user;
    }

    public boolean testConnection() {
        try (Connection conn = new DBContext().getConnection()) {
            if (conn != null && !conn.isClosed()) {
                LOGGER.info("Database connection successful");
                return true;
            }
        } catch (SQLException e) {
            LOGGER.severe("Database connection failed: " + e.getMessage());
        }
        return false;
    }

    public void updateSessionId(String userID, String sessionId) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE UserAccount SET sessionId = ? WHERE userID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionId);
            stmt.setString(2, userID);
            int rowsAffected = stmt.executeUpdate();
            LOGGER.info("Updated sessionId for userNum " + userID + " to: " + sessionId + ", Rows affected: " + rowsAffected);
        } catch (SQLException e) {
            LOGGER.severe("Error updating sessionId for userNum: " + userID + ", " + e.getMessage());
            throw e;
        }
    }

    public String getSessionIdByUsername(String username) throws SQLException, ClassNotFoundException {
        String sql = "SELECT sessionId FROM UserAccount WHERE username = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String sessionId = rs.getString("sessionId");
                    LOGGER.info("Retrieved sessionId for " + username + ": " + sessionId);
                    return sessionId;
                } else {
                    LOGGER.info("No sessionId found for " + username);
                    return null;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving sessionId for username: " + username + ", " + e.getMessage());
            throw e;
        }
    }

    public void updateUserProfile(UserAccount user) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE UserAccount SET fullName = ?, phone = ?, birthDate = ?, email = ?, profilePicture = ? WHERE userID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getPhone());
            pstmt.setDate(3, user.getBirthDate() != null ? new java.sql.Date(user.getBirthDate().getTime()) : null);
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getProfilePicture());
            pstmt.setString(6, user.getUserID());
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No user found with userNum: " + user.getUserID());
            }
            LOGGER.info("User profile updated for userNum: " + user.getUserID());
        } catch (SQLException e) {
            LOGGER.severe("Error updating user profile for userNum: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        }
    }

    public UserAccount findByUsername(String username) throws ClassNotFoundException, SQLException {
        UserAccount user = null;
        String sql = "SELECT * FROM UserAccount WHERE username = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("fullName"));
                    user.setRegistrationDate(rs.getDate("registrationDate"));
                    user.setProfilePicture(rs.getString("profilePicture"));
                    user.setPhone(rs.getString("phone"));
                    user.setBirthDate(rs.getDate("birthDate"));
                    user.setOtp(rs.getString("otp"));
                    user.setOtpExpiry(rs.getTimestamp("otpExpiry"));
                    user.setResetToken(rs.getString("resetToken"));
                    user.setResetTokenExpiry(rs.getTimestamp("resetTokenExpiry"));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by username: " + username + ", " + e.getMessage());
            throw e;
        }
        return user;
    }

    public UserAccount findByUserNum(String UserID) throws ClassNotFoundException, SQLException {
        UserAccount user = null;
        String sql = "SELECT * FROM UserAccount WHERE UserID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, UserID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount();
                    user.setUserID(rs.getString("UserID"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setFullName(rs.getString("fullName"));
                    user.setRegistrationDate(rs.getDate("registrationDate"));
                    user.setProfilePicture(rs.getString("profilePicture"));
                    user.setPhone(rs.getString("phone"));
                    user.setBirthDate(rs.getDate("birthDate"));
                    user.setOtp(rs.getString("otp"));
                    user.setOtpExpiry(rs.getTimestamp("otpExpiry"));
                    user.setResetToken(rs.getString("resetToken"));
                    user.setResetTokenExpiry(rs.getTimestamp("resetTokenExpiry"));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by userNum: " + UserID + ", " + e.getMessage());
            throw e;
        }
        return user;
    }
    
    
    // forum///
     public UserAccount getUserByUsername(String username) throws SQLException {
        UserAccount user = null;
        String query = "SELECT userID, username, fullName, email, password, role, registrationDate, "
                + "profilePicture, phone, birthDate FROM UserAccount WHERE username = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getDate("registrationDate"));
                    user.setProfilePicture(rs.getString("profilePicture"));
                    user.setPhone(rs.getString("phone"));
                    user.setBirthDate(rs.getDate("birthDate"));
                }
                LOGGER.info("Retrieved user: " + (user != null ? user.getUsername() : "null"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return user;
    }

    public String getUsernameByUserID(String userID) throws SQLException {
        String username = "Unknown";
        String query = "SELECT username FROM UserAccount WHERE userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("username");
                }
            }
        } finally {
            dbContext.closeConnection();
        }
        return username;
    }

    public UserAccount getUserById(String userID) throws SQLException {
        UserAccount user = null;
        String query = "SELECT userID, username, fullName, email, password, role, registrationDate, "
                + "profilePicture, phone, birthDate FROM UserAccount WHERE userID = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("fullName"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role"));
                    user.setRegistrationDate(rs.getDate("registrationDate"));
                    user.setProfilePicture(rs.getString("profilePicture"));
                    user.setPhone(rs.getString("phone"));
                    user.setBirthDate(rs.getDate("birthDate"));
                }
                LOGGER.info("Retrieved user by ID: " + (user != null ? user.getUserID() : "null"));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving user by ID: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return user;
    }
    
    ///end
}
