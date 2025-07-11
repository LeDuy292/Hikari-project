/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.coordinator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.coordinator.LessonReviews;
import utils.DBContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LessonReviewsDAO {

    private static final Logger logger = LoggerFactory.getLogger(LessonReviewsDAO.class);
    private Connection con;

    public LessonReviewsDAO() {
        DBContext dBContext = new DBContext();
        try {
            con = dBContext.getConnection();
            logger.info("LessonReviewsDAO: Database connection established successfully.");
        } catch (Exception e) {
            logger.error("LessonReviewsDAO: Error connecting to database: {}", e.getMessage(), e);
        }
    }

    public List<LessonReviews> getReviewsByLessonID(int lessonID) {
        String sql = "SELECT * FROM Lesson_Reviews WHERE lessonID = ?";
        List<LessonReviews> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, lessonID);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    String reviewerID = resultSet.getString("reviewerID");
                    int rating = resultSet.getInt("rating");
                    String reviewText = resultSet.getString("reviewText");
                    String reviewStatus = resultSet.getString("reviewStatus");
                    Timestamp reviewDate = resultSet.getTimestamp("reviewDate");

                    LessonReviews review = new LessonReviews(id, lessonID, reviewerID, rating, reviewText, reviewStatus, reviewDate);
                    list.add(review);
                }
                logger.debug("LessonReviewsDAO: Retrieved {} reviews for lessonID: {}", list.size(), lessonID);
            }
        } catch (SQLException e) {
            logger.error("LessonReviewsDAO: Error getting reviews by lessonID {}: {}", lessonID, e.getMessage(), e);
        }
        return list;
    }

    public List<LessonReviews> getReviewsByCourseID(String courseID) {
        String sql = "SELECT lr.* FROM Lesson_Reviews lr JOIN Lesson l ON lr.lessonID = l.id JOIN Topic t ON l.topicID = t.topicID WHERE t.courseID = ?";
        List<LessonReviews> list = new ArrayList<>();
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, courseID);
            try (ResultSet resultSet = pre.executeQuery()) {
                while (resultSet.next()) {
                    int id = resultSet.getInt("id");
                    int lessonID = resultSet.getInt("lessonID");
                    String reviewerID = resultSet.getString("reviewerID");
                    int rating = resultSet.getInt("rating");
                    String reviewText = resultSet.getString("reviewText");
                    String reviewStatus = resultSet.getString("reviewStatus");
                    Timestamp reviewDate = resultSet.getTimestamp("reviewDate");

                    LessonReviews review = new LessonReviews(id, lessonID, reviewerID, rating, reviewText, reviewStatus, reviewDate);
                    list.add(review);
                }
                logger.debug("LessonReviewsDAO: Retrieved {} reviews for courseID: {}", list.size(), courseID);
            }
        } catch (SQLException e) {
            logger.error("LessonReviewsDAO: Error getting reviews by courseID {}: {}", courseID, e.getMessage(), e);
        }
        return list;
    }

    public void addReview(LessonReviews review) {
        String sql = "INSERT INTO Lesson_Reviews (lessonID, reviewerID, rating, reviewText, reviewStatus, reviewDate) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, review.getLessonID());
            pre.setString(2, review.getReviewerID());
            pre.setInt(3, review.getRating());
            pre.setString(4, review.getReviewText());
            pre.setString(5, review.getReviewStatus());
            pre.setDate(6, new java.sql.Date(review.getReviewDate().getTime()));
            pre.executeUpdate();
            logger.info("LessonReviewsDAO: Added new review for lessonID: {}", review.getLessonID());
        } catch (SQLException e) {
            logger.error("LessonReviewsDAO: Error adding review for lessonID {}: {}", review.getLessonID(), e.getMessage(), e);
        }
    }

    public int addReviewWithReturn(LessonReviews review) {
        String sql = "INSERT INTO Lesson_Reviews (lessonID, reviewerID, rating, reviewText, reviewStatus, reviewDate) VALUES (?, ?, ?, ?, ?, ?)";
        int affectedRows = 0;
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, review.getLessonID());
            pre.setString(2, review.getReviewerID());
            pre.setInt(3, review.getRating());
            pre.setString(4, review.getReviewText());
            pre.setString(5, review.getReviewStatus());
            pre.setDate(6, new java.sql.Date(review.getReviewDate().getTime()));
            affectedRows = pre.executeUpdate();
            logger.info("LessonReviewsDAO: Added new review for lessonID: {}, affected rows: {}", review.getLessonID(), affectedRows);
        } catch (SQLException e) {
            logger.error("LessonReviewsDAO: Error adding review for lessonID {}: {}", review.getLessonID(), e.getMessage(), e);
        }
        return affectedRows;
    }

    public void updateReview(LessonReviews review) {
        String sql = "UPDATE Lesson_Reviews SET lessonID = ?, reviewerID = ?, rating = ?, reviewText = ?, reviewStatus = ?, reviewDate = ? WHERE id = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setInt(1, review.getLessonID());
            pre.setString(2, review.getReviewerID());
            pre.setInt(3, review.getRating());
            pre.setString(4, review.getReviewText());
            pre.setString(5, review.getReviewStatus());
            pre.setDate(6, new java.sql.Date(review.getReviewDate().getTime()));
            pre.setInt(7, review.getId());
            pre.executeUpdate();
            logger.info("LessonReviewsDAO: Updated review with ID: {}", review.getId());
        } catch (SQLException e) {
            logger.error("LessonReviewsDAO: Error updating review {}: {}", review.getId(), e.getMessage(), e);
        }
    }

    // Hàm mới: updateReviewByLessonID
    public void updateReviewByLessonID(LessonReviews review) {
        String sql = "UPDATE Lesson_Reviews SET reviewerID = ?, rating = ?, reviewText = ?, reviewStatus = ?, reviewDate = ? WHERE lessonID = ?";
        try (PreparedStatement pre = con.prepareStatement(sql)) {
            pre.setString(1, review.getReviewerID());
            pre.setInt(2, review.getRating());
            pre.setString(3, review.getReviewText());
            pre.setString(4, review.getReviewStatus());
            pre.setDate(5, new java.sql.Date(review.getReviewDate().getTime()));
            pre.setInt(6, review.getLessonID());
            int affectedRows = pre.executeUpdate();
            if (affectedRows > 0) {
                logger.info("LessonReviewsDAO: Updated {} reviews for lessonID: {}", affectedRows, review.getLessonID());
            } else {
                logger.warn("LessonReviewsDAO: No reviews updated for lessonID: {}", review.getLessonID());
            }
        } catch (SQLException e) {
            logger.error("LessonReviewsDAO: Error updating reviews for lessonID {}: {}", review.getLessonID(), e.getMessage(), e);
        }
    }

    public void closeConnection() {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                logger.info("LessonReviewsDAO: Database connection closed.");
            }
        } catch (SQLException e) {
            logger.error("LessonReviewsDAO: Error closing connection: {}", e.getMessage(), e);
        }
    }
}
