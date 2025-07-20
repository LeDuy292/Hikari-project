package dao;

import model.SearchHistory;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DictionaryDAO {

    private final DBContext dbContext;

    public DictionaryDAO() {
        this.dbContext = new DBContext();
    }

    public void addSearchHistory(SearchHistory history) {
        String sql = "INSERT INTO search_history (keyword, user_identifier, search_time) VALUES (?, ?, ?)";
        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, history.getKeyword());
            ps.setString(2, history.getUserIdentifier());
            ps.setTimestamp(3, history.getSearchTime() != null ? Timestamp.valueOf(history.getSearchTime()) : null);
            ps.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(DictionaryDAO.class.getName()).log(Level.SEVERE, "Lỗi khi thêm lịch sử tìm kiếm", ex);
        }
    }

    public List<SearchHistory> getRecentSearchHistory(String userIdentifier, int limit) {
        List<SearchHistory> historyList = new ArrayList<>();
        String sql = "SELECT id, keyword, search_time FROM search_history WHERE user_identifier = ? ORDER BY search_time DESC LIMIT ?";
        try (Connection connection = dbContext.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, userIdentifier);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String keyword = rs.getString("keyword");
                    LocalDateTime searchTime = rs.getTimestamp("search_time") != null ? rs.getTimestamp("search_time").toLocalDateTime() : null;
                    historyList.add(new SearchHistory(id, keyword, searchTime, userIdentifier));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(DictionaryDAO.class.getName()).log(Level.SEVERE, "Lỗi khi lấy lịch sử tìm kiếm", ex);
        }
        return historyList;
    }
}