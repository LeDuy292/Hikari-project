package dao.coordinator;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.coordinator.CV;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CVDAO {
    private static final Logger logger = LoggerFactory.getLogger(CVDAO.class);
    private Connection connection;

    public CVDAO() {
        DBContext dbContext = new DBContext();
        try {
            connection = dbContext.getConnection();
            logger.info("CVDAO: Database connection established successfully.");
        } catch (SQLException e) {
            logger.error("CVDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    public void addCV(CV cv) {
        String sql = "INSERT INTO CV (userID, fullName, email, phone, fileUrl, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, cv.getUserID());
            stmt.setString(2, cv.getFullName());
            stmt.setString(3, cv.getEmail());
            stmt.setString(4, cv.getPhone());
            stmt.setString(5, cv.getFileUrl());
            stmt.setString(6, cv.getStatus());
            stmt.executeUpdate();
            logger.info("CVDAO: Added new CV for userID: {}", cv.getUserID());
        } catch (SQLException e) {
            logger.error("CVDAO: Error adding CV for userID {}: {}", cv.getUserID(), e.getMessage(), e);
        }
    }

    public List<CV> getAllCVs() {
        List<CV> cvList = new ArrayList<>();
        String sql = "SELECT * FROM CV";
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                CV cv = new CV();
                cv.setCvID(rs.getInt("cvID"));
                cv.setUserID(rs.getString("userID"));
                cv.setFullName(rs.getString("fullName"));
                cv.setEmail(rs.getString("email"));
                cv.setPhone(rs.getString("phone"));
                cv.setFileUrl(rs.getString("fileUrl"));
                cv.setUploadDate(rs.getTimestamp("uploadDate"));
                cv.setStatus(rs.getString("status"));
                cv.setReviewerID(rs.getString("reviewerID"));
                cv.setReviewDate(rs.getTimestamp("reviewDate"));
                cv.setComments(rs.getString("comments"));
                cvList.add(cv);
            }
            logger.debug("CVDAO: Retrieved {} CVs.", cvList.size());
        } catch (SQLException e) {
            logger.error("CVDAO: Error getting all CVs: {}", e.getMessage(), e);
        }
        return cvList;
    }

    public CV getCVByID(int cvID) {
        String sql = "SELECT * FROM CV WHERE cvID = ?";
        CV cv = null;
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cvID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cv = new CV();
                    cv.setCvID(rs.getInt("cvID"));
                    cv.setUserID(rs.getString("userID"));
                    cv.setFullName(rs.getString("fullName"));
                    cv.setEmail(rs.getString("email"));
                    cv.setPhone(rs.getString("phone"));
                    cv.setFileUrl(rs.getString("fileUrl"));
                    cv.setUploadDate(rs.getTimestamp("uploadDate"));
                    cv.setStatus(rs.getString("status"));
                    cv.setReviewerID(rs.getString("reviewerID"));
                    cv.setReviewDate(rs.getTimestamp("reviewDate"));
                    cv.setComments(rs.getString("comments"));
                    logger.debug("CVDAO: Retrieved CV with ID {}: {}", cvID, cv);
                } else {
                    logger.warn("CVDAO: No CV found for ID: {}", cvID);
                }
            }
        } catch (SQLException e) {
            logger.error("CVDAO: Error getting CV by ID {}: {}", cvID, e.getMessage(), e);
        }
        return cv;
    }

    public void updateCVStatus(int cvID, String status, String reviewerID, String comments) {
        String sql = "UPDATE CV SET status = ?, reviewerID = ?, reviewDate = CURRENT_TIMESTAMP, comments = ? WHERE cvID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, reviewerID);
            stmt.setString(3, comments);
            stmt.setInt(4, cvID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                logger.info("CVDAO: Updated CV status for cvID {} to {}", cvID, status);
            } else {
                logger.warn("CVDAO: No CV found to update status for cvID: {}", cvID);
            }
        } catch (SQLException e) {
            logger.error("CVDAO: Error updating CV status for cvID {}: {}", cvID, e.getMessage(), e);
        }
    }

    public List<CV> getCVsByUserID(String userID) {
        List<CV> cvList = new ArrayList<>();
        String sql = "SELECT * FROM CV WHERE userID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CV cv = new CV();
                    cv.setCvID(rs.getInt("cvID"));
                    cv.setUserID(rs.getString("userID"));
                    cv.setFullName(rs.getString("fullName"));
                    cv.setEmail(rs.getString("email"));
                    cv.setPhone(rs.getString("phone"));
                    cv.setFileUrl(rs.getString("fileUrl"));
                    cv.setUploadDate(rs.getTimestamp("uploadDate"));
                    cv.setStatus(rs.getString("status"));
                    cv.setReviewerID(rs.getString("reviewerID"));
                    cv.setReviewDate(rs.getTimestamp("reviewDate"));
                    cv.setComments(rs.getString("comments"));
                    cvList.add(cv);
                }
                logger.debug("CVDAO: Retrieved {} CVs for userID: {}", cvList.size(), userID);
            }
        } catch (SQLException e) {
            logger.error("CVDAO: Error getting CVs for userID {}: {}", userID, e.getMessage(), e);
        }
        return cvList;
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                logger.info("CVDAO: Database connection closed.");
            }
        } catch (SQLException e) {
            logger.error("CVDAO: Error closing connection: {}", e.getMessage(), e);
        }
    }

    public static void main(String[] args) {
        CVDAO dao = new CVDAO();
        List<CV> cvList = dao.getAllCVs();
        System.out.println("All CVs: " + cvList);
        CV cv = dao.getCVByID(1);
        System.out.println("CV with ID 1: " + cv);
        List<CV> userCVs = dao.getCVsByUserID("U001");
        System.out.println("CVs for user U001: " + userCVs);
        dao.closeConnection();
    }
}