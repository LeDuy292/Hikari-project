package dao.forum;

import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.forum.Achievement;

public class AchievementDAO {
    private static final Logger LOGGER = Logger.getLogger(AchievementDAO.class.getName());
    private final DBContext dbContext;

    public AchievementDAO() {
        this.dbContext = new DBContext();
    }

    public List<Achievement> getAchievementsByUserId(String userId) throws SQLException {
        List<Achievement> achievements = new ArrayList<>();
        String query = "SELECT id, userID, achievementType, title, description, achievedDate, relatedID, isActive " +
                      "FROM Achievements WHERE userID = ? AND isActive = TRUE " +
                      "ORDER BY achievedDate DESC";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Achievement achievement = new Achievement();
                    achievement.setId(rs.getInt("id"));
                    achievement.setUserId(rs.getString("userID"));
                    achievement.setAchievementType(rs.getString("achievementType"));
                    achievement.setTitle(rs.getString("title"));
                    achievement.setDescription(rs.getString("description"));
                    achievement.setAchievedDate(rs.getDate("achievedDate"));
                    achievement.setRelatedId(rs.getInt("relatedID"));
                    achievement.setActive(rs.getBoolean("isActive"));
                    achievements.add(achievement);
                }
                LOGGER.info("Retrieved " + achievements.size() + " achievements for user: " + userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving achievements for user: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return achievements;
    }
}
