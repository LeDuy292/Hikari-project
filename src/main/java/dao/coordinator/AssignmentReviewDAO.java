/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.coordinator;

import model.coordinator.AssignmentReview;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssignmentReviewDAO {
    private final DBContext dbContext;

    public AssignmentReviewDAO() {
        this.dbContext = new DBContext();
    }

    public boolean insertAssignmentReview(AssignmentReview review) {
        String sql = "INSERT INTO Assignment_Reviews (assignmentID, reviewerID, reviewStatus, reviewDate) VALUES (?, ?, ?, NOW())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, review.getAssignmentID());
            ps.setString(2, review.getReviewerID());
            ps.setString(3, review.getReviewStatus());
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm assignment review: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<AssignmentReview> getAssignmentReviewsByStatus(String status) {
        List<AssignmentReview> reviews = new ArrayList<>();
        String sql = "SELECT * FROM Assignment_Reviews WHERE reviewStatus = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                AssignmentReview review = new AssignmentReview();
                review.setId(rs.getInt("id"));
                review.setAssignmentID(rs.getInt("assignmentID"));
                review.setReviewerID(rs.getString("reviewerID"));
                review.setRating(rs.getInt("rating"));
                review.setReviewText(rs.getString("reviewText"));
                review.setReviewStatus(rs.getString("reviewStatus"));
                review.setReviewDate(rs.getTimestamp("reviewDate"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy assignment reviews: " + e.getMessage());
        }
        return reviews;
    }
}
