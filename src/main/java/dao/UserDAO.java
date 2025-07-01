package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import model.UserAccount;
import utils.DBContext;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());
    private final DBContext dbContext;

    public UserDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * Retrieves a user by their email.
     */
    public UserAccount getUserByEmail(String email) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM UserAccount WHERE email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error in getUserByEmail: " + email + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * Adds a new user to the database.
     */
    public void addUser(UserAccount user) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO UserAccount (userID, fullName, username, email, password, role, profilePicture, phone, birthDate, registrationDate, isActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUserID());
            pstmt.setString(2, user.getFullName());
            pstmt.setString(3, user.getUsername());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getPassword());
            pstmt.setString(6, user.getRole());
            pstmt.setString(7, user.getProfilePicture());
            pstmt.setString(8, user.getPhone());
            pstmt.setDate(9, user.getBirthDate() != null ? new Date(user.getBirthDate().getTime()) : null);
            pstmt.setDate(10, Date.valueOf(LocalDate.now()));
            pstmt.setBoolean(11, true); // Default active
            pstmt.executeUpdate();
            LOGGER.info("User added successfully: " + user.getUsername());
        } catch (SQLException e) {
            LOGGER.severe("Error in addUser: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Updates user profile for Google login.
     */
    public void updateUserProfileGG(UserAccount user) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE UserAccount SET fullName = ?, username = ?, phone = ?, birthDate = ?, password = ? WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getUsername());
            pstmt.setString(3, user.getPhone());
            pstmt.setDate(4, user.getBirthDate() != null ? new Date(user.getBirthDate().getTime()) : null);
            pstmt.setString(5, user.getPassword());
            pstmt.setString(6, user.getUserID());
            int rows = pstmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("No user found with userID: " + user.getUserID());
            }
            LOGGER.info("User profile updated for Google login: " + user.getUserID());
        } catch (SQLException e) {
            LOGGER.severe("Error in updateUserProfileGG: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Authenticates a user by username and password.
     */
    public UserAccount authenticateUser(String username, String password) throws SQLException, ClassNotFoundException {
        String sql = "SELECT userID, role, isActive FROM UserAccount WHERE username = ? AND password = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserAccount user = new UserAccount();
                    user.setUserID(rs.getString("userID"));
                    user.setRole(rs.getString("role"));
                    user.setUsername(username);
                    user.setIsActive(rs.getBoolean("isActive"));
                    return user;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error authenticating user: " + username + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * Registers a new user.
     */
    public boolean registerUser(UserAccount user) throws ClassNotFoundException, SQLException {
        if (isEmailExists(user.getEmail()) || isUsernameExists(user.getUsername())) {
            LOGGER.warning("Registration failed: Email or username already exists for " + user.getEmail());
            return false;
        }

        String sql = "INSERT INTO UserAccount (userID, username, email, password, role, fullName, registrationDate, profilePicture, phone, birthDate, isActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, user.getUserID());
                stmt.setString(2, user.getUsername());
                stmt.setString(3, user.getEmail());
                stmt.setString(4, user.getPassword());
                stmt.setString(5, user.getRole());
                stmt.setString(6, user.getFullName() != null ? user.getFullName() : user.getUsername());
                stmt.setDate(7, Date.valueOf(LocalDate.now()));
                stmt.setString(8, user.getProfilePicture());
                stmt.setString(9, user.getPhone());
                stmt.setDate(10, user.getBirthDate() != null ? new Date(user.getBirthDate().getTime()) : null);
                stmt.setBoolean(11, user.getIsActive());
                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    conn.commit();
                    LOGGER.info("User registered successfully: " + user.getUsername() + " with ID: " + user.getUserID() + " and role: " + user.getRole());
                    return true;
                }
                conn.rollback();
                return false;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOGGER.severe("SQL error during registration: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Checks if an email already exists.
     */
    private boolean isEmailExists(String email) throws ClassNotFoundException, SQLException {
        return findByEmail(email) != null;
    }

    /**
     * Checks if a username already exists.
     */
    private boolean isUsernameExists(String username) throws ClassNotFoundException, SQLException {
        String sql = "SELECT COUNT(*) FROM UserAccount WHERE username = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    /**
     * Generates a new user ID.
     */
    public String generateNewUserID() throws SQLException, ClassNotFoundException {
        String query = "SELECT userID FROM UserAccount WHERE userID LIKE 'U%' ORDER BY userID DESC LIMIT 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String lastID = rs.getString("userID");
                int num = Integer.parseInt(lastID.substring(1));
                int newNum = num + 1;
                return String.format("U%03d", newNum);
            }
            return "U001";
        } catch (SQLException e) {
            LOGGER.severe("Error generating new userID: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Finds a user by email.
     */
    public UserAccount findByEmail(String email) throws ClassNotFoundException, SQLException {
        String sql = "SELECT * FROM UserAccount WHERE email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by email: " + email + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * Updates OTP for a user.
     */
    public void updateOtp(UserAccount user) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE UserAccount SET otp = ?, otpExpiry = ? WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getOtp());
            pstmt.setTimestamp(2, user.getOtpExpiry() != null ? new Timestamp(user.getOtpExpiry().getTime()) : null);
            pstmt.setString(3, user.getUserID());
            int rows = pstmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("No user found with userID: " + user.getUserID());
            }
            LOGGER.info("OTP updated for userID: " + user.getUserID());
        } catch (SQLException e) {
            LOGGER.severe("Error updating OTP for userID: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Finds a user by OTP.
     */
    public UserAccount findByOtp(String otp) throws ClassNotFoundException, SQLException {
        String sql = "SELECT * FROM UserAccount WHERE otp = ? AND (otpExpiry IS NULL OR otpExpiry > ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, otp);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by OTP: " + otp + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * Updates a user's password.
     */
    public void updatePassword(UserAccount user) throws ClassNotFoundException, SQLException {
        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);
            String sql = "UPDATE UserAccount SET password = ?, otp = ?, otpExpiry = ?, sessionId = ? WHERE userID = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, user.getPassword());
                pstmt.setString(2, null);
                pstmt.setTimestamp(3, null);
                pstmt.setString(4, null);
                pstmt.setString(5, user.getUserID());
                int rows = pstmt.executeUpdate();
                if (rows == 0) {
                    throw new SQLException("No user found with userID: " + user.getUserID());
                }
                conn.commit();
                LOGGER.info("Password updated for userID: " + user.getUserID());
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error updating password for userID: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Updates a user's reset token.
     */
    public void updateResetToken(UserAccount user) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE UserAccount SET resetToken = ?, resetTokenExpiry = ? WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getResetToken());
            pstmt.setTimestamp(2, user.getResetTokenExpiry() != null ? new Timestamp(user.getResetTokenExpiry().getTime()) : null);
            pstmt.setString(3, user.getUserID());
            int rows = pstmt.executeUpdate();
            if (rows == 0) {
                throw new SQLException("No user found with userID: " + user.getUserID());
            }
            LOGGER.info("Reset token updated for userID: " + user.getUserID());
        } catch (SQLException e) {
            LOGGER.severe("Error updating reset token for userID: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Finds a user by reset token.
     */
    public UserAccount findByResetToken(String resetToken) throws ClassNotFoundException, SQLException {
        String sql = "SELECT * FROM UserAccount WHERE resetToken = ? AND (resetTokenExpiry IS NULL OR resetTokenExpiry > ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, resetToken);
            pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by reset token: " + resetToken + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * Tests database connection.
     */
    public boolean testConnection() throws SQLException, ClassNotFoundException {
        try (Connection conn = dbContext.getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            LOGGER.severe("Database connection failed: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Updates a user's session ID.
     */
    public void updateSessionId(String userID, String sessionId) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE UserAccount SET sessionId = ? WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, sessionId);
            stmt.setString(2, userID);
            int rowsAffected = stmt.executeUpdate();
            LOGGER.info("Updated sessionId for userID " + userID + " to: " + sessionId + ", Rows affected: " + rowsAffected);
        } catch (SQLException e) {
            LOGGER.severe("Error updating sessionId for userID: " + userID + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Retrieves session ID by username.
     */
    public String getSessionIdByUsername(String username) throws SQLException, ClassNotFoundException {
        String sql = "SELECT sessionId FROM UserAccount WHERE username = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String sessionId = rs.getString("sessionId");
                    LOGGER.info("Retrieved sessionId for " + username + ": " + sessionId);
                    return sessionId;
                }
                LOGGER.info("No sessionId found for " + username);
                return null;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving sessionId for username: " + username + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Updates user profile.
     */
    public void updateUserProfile(UserAccount user) throws ClassNotFoundException, SQLException {
        String sql = "UPDATE UserAccount SET fullName = ?, username = ?, email = ?, phone = ?, birthDate = ?, profilePicture = ?, role = ?";
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            sql += ", password = ?";
        }
        sql += " WHERE userID = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            pstmt.setString(paramIndex++, user.getFullName());
            pstmt.setString(paramIndex++, user.getUsername());
            pstmt.setString(paramIndex++, user.getEmail());
            pstmt.setString(paramIndex++, user.getPhone());
            pstmt.setDate(paramIndex++, user.getBirthDate() != null ? new java.sql.Date(user.getBirthDate().getTime()) : null);
            pstmt.setString(paramIndex++, user.getProfilePicture());
            pstmt.setString(paramIndex++, user.getRole());
            if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
                pstmt.setString(paramIndex++, user.getPassword());
            }
            pstmt.setString(paramIndex, user.getUserID());
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No user found with userID: " + user.getUserID());
            }
            LOGGER.info("User profile updated for userID: " + user.getUserID() + " with role: " + user.getRole());
        } catch (SQLException e) {
            LOGGER.severe("Error updating user profile for userID: " + user.getUserID() + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Finds a user by username.
     */
    public UserAccount findByUsername(String username) throws ClassNotFoundException, SQLException {
        String sql = "SELECT * FROM UserAccount WHERE username = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by username: " + username + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * Finds a user by userID.
     */
    public UserAccount findByUserNum(String userID) throws ClassNotFoundException, SQLException {
        String sql = "SELECT * FROM UserAccount WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error finding user by userID: " + userID + ", " + e.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * Retrieves a user by username (for forum).
     */
    public UserAccount getUserByUsername(String username) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM UserAccount WHERE username = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserAccount user = mapResultSetToUser(rs);
                    LOGGER.info("Retrieved user: " + user.getUsername());
                    return user;
                }
                LOGGER.info("No user found for username: " + username);
                return null;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving user: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Retrieves username by userID.
     */
    public String getUsernameByUserID(String userID) throws SQLException, ClassNotFoundException {
        String sql = "SELECT username FROM UserAccount WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
                return "Unknown";
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving username by userID: " + userID + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Retrieves a user by userID (for forum).
     */
    public UserAccount getUserById(String userID) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM UserAccount WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    UserAccount user = mapResultSetToUser(rs);
                    LOGGER.info("Retrieved user by ID: " + user.getUserID());
                    return user;
                }
                LOGGER.info("No user found for userID: " + userID);
                return null;
            }
        } catch (SQLException e) {
            LOGGER.severe("Error retrieving user by ID: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Retrieves all users with course count.
     */
    public List<UserAccount> getAllUsers() throws SQLException, ClassNotFoundException {
        List<UserAccount> users = new ArrayList<>();
        String sql = "SELECT u.*, " +
                     "(SELECT COUNT(*) FROM Course_Enrollments ce " +
                     "JOIN Student s ON ce.studentID = s.studentID " +
                     "WHERE s.userID = u.userID) as courseCount " +
                     "FROM UserAccount u ORDER BY u.registrationDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                UserAccount user = mapResultSetToUser(rs);
                LOGGER.info("Fetched user: " + user.getUserID() + ", isActive: " + user.getIsActive());
                users.add(user);
            }
            LOGGER.info("Total users fetched: " + users.size());
        } catch (SQLException e) {
            LOGGER.severe("Error getting all users: " + e.getMessage());
            throw e;
        }
        return users;
    }

    /**
     * Updates user status (active/inactive).
     */
    public void updateUserStatus(String userID, boolean isActive) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE UserAccount SET isActive = ? WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, isActive);
            stmt.setString(2, userID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No user found with ID: " + userID);
            }
            LOGGER.info("User status updated for: " + userID + ", isActive: " + isActive);
        } catch (SQLException e) {
            LOGGER.severe("Error updating user status: " + userID + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Deletes a user by userID.
     */
    public void deleteUser(String userID) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM UserAccount WHERE userID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No user found with ID: " + userID);
            }
            LOGGER.info("User deleted successfully: " + userID);
        } catch (SQLException e) {
            LOGGER.severe("Error deleting user: " + userID + ", " + e.getMessage());
            throw e;
        }
    }

    /**
     * Retrieves users by role.
     */
    public List<UserAccount> getUsersByRole(String role) throws SQLException, ClassNotFoundException {
        List<UserAccount> users = new ArrayList<>();
        String sql = "SELECT u.*, " +
                     "(SELECT COUNT(*) FROM Course_Enrollments ce " +
                     "JOIN Student s ON ce.studentID = s.studentID " +
                     "WHERE s.userID = u.userID) as courseCount " +
                     "FROM UserAccount u WHERE u.role = ? ORDER BY u.registrationDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting users by role: " + role + ", " + e.getMessage());
            throw e;
        }
        return users;
    }

    /**
     * Retrieves filtered users based on criteria.
     */
    public List<UserAccount> getFilteredUsers(String role, String status, String dateFrom, String dateTo,
                                             String nameSearch, int minCourses) throws SQLException, ClassNotFoundException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.*, ");
        sql.append("(SELECT COUNT(*) FROM Course_Enrollments ce ");
        sql.append("JOIN Student s ON ce.studentID = s.studentID ");
        sql.append("WHERE s.userID = u.userID) as courseCount ");
        sql.append("FROM UserAccount u WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (role != null && !role.trim().isEmpty()) {
            sql.append("AND u.role = ? ");
            params.add(role);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND u.isActive = ? ");
            params.add(Boolean.parseBoolean(status));
        }
        
        if (nameSearch != null && !nameSearch.trim().isEmpty()) {
            sql.append("AND (u.fullName LIKE ? OR u.username LIKE ? OR u.email LIKE ?) ");
            String searchPattern = "%" + nameSearch + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append("AND u.registrationDate >= ? ");
            params.add(Date.valueOf(dateFrom));
        }
        
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append("AND u.registrationDate <= ? ");
            params.add(Date.valueOf(dateTo));
        }
        
        sql.append("HAVING courseCount >= ? ");
        params.add(minCourses);
        
        sql.append("ORDER BY u.registrationDate DESC");
        
        List<UserAccount> users = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting filtered users: " + e.getMessage());
            throw e;
        }
        return users;
    }

    /**
     * Maps ResultSet to UserAccount object.
     */
    private UserAccount mapResultSetToUser(ResultSet rs) throws SQLException {
        UserAccount user = new UserAccount();
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
        user.setIsActive(rs.getBoolean("isActive"));
        try {
            user.setCourseCount(rs.getInt("courseCount"));
        } catch (SQLException e) {
            user.setCourseCount(0); // Default if column not present
        }
        return user;
    }
}