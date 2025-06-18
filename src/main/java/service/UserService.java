package service;

import dao.UserDAO;
import model.UserAccount;
import java.sql.SQLException;
import java.util.Date;
import java.util.Random;
import java.util.logging.Logger;

public class UserService {
    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());
    private UserDAO userDAO = new UserDAO();

    public boolean registerUser(UserAccount user) throws ClassNotFoundException, SQLException {
        if (user == null || user.getUsername() == null || user.getEmail() == null
                || user.getPassword() == null) {
            LOGGER.warning("Registration failed: User or required fields are null");
            return false;
        }
        if (user.getUsername().trim().isEmpty() || user.getEmail().trim().isEmpty()
                || user.getPassword().trim().isEmpty()) {
            LOGGER.warning("Registration failed: Empty fields detected");
            return false;
        }
        if (!user.getEmail().contains("@") || !user.getEmail().contains(".")) {
            LOGGER.warning("Registration failed: Invalid email format for " + user.getEmail());
            return false;
        }
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            user.setFullName(user.getUsername());
        }
        user.setRole("Student");
        boolean isRegistered = userDAO.registerUser(user);
        if (isRegistered) {
            LOGGER.info("User registered successfully: " + user.getUsername());
        } else {
            LOGGER.severe("User registration failed for: " + user.getUsername());
        }
        return isRegistered;
    }

    public UserAccount login(String username, String password) throws ClassNotFoundException, SQLException {
        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            LOGGER.warning("Login failed: Empty username or password");
            return null;
        }
        UserAccount user = userDAO.authenticateUser(username, password);
        if (user != null) {
            UserAccount fullUser = userDAO.findByUsername(username);
            if (fullUser != null) {
                LOGGER.info("User logged in successfully: " + username);
                return fullUser;
            }
        }
        LOGGER.warning("Login failed for username: " + username);
        return null;
    }

    public UserAccount findByEmail(String email) throws ClassNotFoundException, SQLException {
        UserAccount user = userDAO.findByEmail(email);
        if (user == null) {
            LOGGER.info("No user found for email: " + email);
        }
        return user;
    }

    public void updateOtp(UserAccount user) throws ClassNotFoundException, SQLException {
        String otp = String.format("%06d", new Random().nextInt(1000000));
        user.setOtp(otp);
        user.setOtpExpiry(new Date(System.currentTimeMillis() + 10 * 60 * 1000));
        userDAO.updateOtp(user);
        LOGGER.info("OTP generated for userNum: " + user.getUserID()+ ", OTP: " + otp);
    }

    public UserAccount findByOtp(String otp) throws ClassNotFoundException, SQLException {
        UserAccount user = userDAO.findByOtp(otp);
        if (user == null) {
            LOGGER.info("No user found for OTP: " + otp);
        }
        return user;
    }

    public boolean updatePassword(UserAccount user) throws ClassNotFoundException, SQLException {
        if (user == null || user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            LOGGER.warning("Password update failed: User or password is null/empty");
            return false;
        }
        userDAO.updatePassword(user);
        LOGGER.info("Password updated successfully for userNum: " + user.getUserID());
        return true;
    }

    public boolean isEmailExists(String email) throws ClassNotFoundException, SQLException {
        UserAccount user = userDAO.findByEmail(email);
        return user != null;
    }

    public void updateUser(UserAccount user) throws ClassNotFoundException, SQLException {
        if (user == null || user.getEmail() == null) {
            LOGGER.severe("Update user failed: User or email is null");
            throw new IllegalArgumentException("Người dùng hoặc email không được để trống");
        }
        userDAO.updateUserProfile(user);
        LOGGER.info("User profile updated for userNum: " + user.getUserID());
    }

    public UserAccount findByUserNum(String UserID) throws ClassNotFoundException, SQLException {
        UserAccount user = userDAO.findByUserNum(UserID);
        if (user == null) {
            LOGGER.info("No user found for userNum: " + UserID);
        }
        return user;
    }
}