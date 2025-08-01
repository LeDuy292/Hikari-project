package dao.ranking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ranking.Result;
import model.ranking.StudentRanking;
import utils.DBContext;

public class ResultDAO {
    
    // Lấy tất cả kết quả với thông tin chi tiết
    public List<Result> getAllResultsWithDetails() {
        List<Result> results = new ArrayList<>();
        String sql = "SELECT r.studentID, r.testId, r.score, r.timeTaken, r.status, " +
                    "ua.fullName as studentName, ua.profilePicture, " +
                    "t.jlptLevel, t.title as testTitle " +
                    "FROM Result r " +
                    "JOIN Student s ON r.studentID = s.studentID " +
                    "JOIN UserAccount ua ON s.userID = ua.userID " +
                    "JOIN Test t ON r.testId = t.id " +
                    "WHERE r.status IN ('Pass', 'Fail') " +
                    "ORDER BY r.score DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Result result = new Result();
                result.setStudentID(rs.getString("studentID"));
                result.setTestId(rs.getInt("testId"));
                result.setScore(rs.getDouble("score"));
                result.setTimeTaken(rs.getString("timeTaken"));
                result.setStatus(rs.getString("status"));
                result.setStudentName(rs.getString("studentName"));
                result.setProfilePicture(rs.getString("profilePicture"));
                result.setJlptLevel(rs.getString("jlptLevel"));
                result.setTestTitle(rs.getString("testTitle"));
                results.add(result);
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy tất cả kết quả: " + e.getMessage());
            e.printStackTrace();
        }
        
        return results;
    }
    
    // Lọc kết quả theo JLPT level và từ khóa tìm kiếm
    public List<Result> getFilteredResults(String jlptLevel, String searchTerm) {
        List<Result> results = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.studentID, r.testId, r.score, r.timeTaken, r.status, " +
            "ua.fullName as studentName, ua.profilePicture, " +
            "t.jlptLevel, t.title as testTitle " +
            "FROM Result r " +
            "JOIN Student s ON r.studentID = s.studentID " +
            "JOIN UserAccount ua ON s.userID = ua.userID " +
            "JOIN Test t ON r.testId = t.id " +
            "WHERE r.status IN ('Pass', 'Fail')"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc JLPT level
        if (jlptLevel != null && !jlptLevel.isEmpty() && !jlptLevel.equals("Tất cả")) {
            sql.append(" AND t.jlptLevel = ?");
            params.add(jlptLevel);
        }
        
        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (ua.fullName LIKE ? OR r.studentID LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        sql.append(" ORDER BY r.score DESC, r.timeTaken ASC");
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Result result = new Result();
                    result.setStudentID(rs.getString("studentID"));
                    result.setTestId(rs.getInt("testId"));
                    result.setScore(rs.getDouble("score"));
                    result.setTimeTaken(rs.getString("timeTaken"));
                    result.setStatus(rs.getString("status"));
                    result.setStudentName(rs.getString("studentName"));
                    result.setProfilePicture(rs.getString("profilePicture"));
                    result.setJlptLevel(rs.getString("jlptLevel"));
                    result.setTestTitle(rs.getString("testTitle"));
                    results.add(result);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lọc kết quả: " + e.getMessage());
            e.printStackTrace();
        }
        
        return results;
    }
    
    // Lấy xếp hạng trung bình của học sinh
    public List<StudentRanking> getAverageRankings(String jlptLevel, String searchTerm) {
        List<StudentRanking> rankings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.studentID, ua.fullName as studentName, ua.profilePicture, " +
            "AVG(r.score) as averageScore, COUNT(r.testId) as testCount, " +
            "GROUP_CONCAT(DISTINCT t.jlptLevel ORDER BY t.jlptLevel) as jlptLevels " +
            "FROM Result r " +
            "JOIN Student s ON r.studentID = s.studentID " +
            "JOIN UserAccount ua ON s.userID = ua.userID " +
            "JOIN Test t ON r.testId = t.id " +
            "WHERE r.status IN ('Pass', 'Fail')"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc JLPT level
        if (jlptLevel != null && !jlptLevel.isEmpty() && !jlptLevel.equals("Tất cả")) {
            sql.append(" AND t.jlptLevel = ?");
            params.add(jlptLevel);
        }
        
        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (ua.fullName LIKE ? OR r.studentID LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        sql.append(" GROUP BY r.studentID, ua.fullName, ua.profilePicture");
        sql.append(" ORDER BY averageScore DESC, testCount DESC");
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    StudentRanking ranking = new StudentRanking();
                    ranking.setStudentID(rs.getString("studentID"));
                    ranking.setStudentName(rs.getString("studentName"));
                    ranking.setProfilePicture(rs.getString("profilePicture"));
                    ranking.setAverageScore(rs.getDouble("averageScore"));
                    ranking.setTestCount(rs.getInt("testCount"));
                    ranking.setJlptLevels(rs.getString("jlptLevels"));
                    ranking.setRank(rank++);
                    rankings.add(ranking);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy xếp hạng trung bình: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rankings;
    }
    
    // Lấy thống kê bảng xếp hạng
    public RankingStats getRankingStats(String jlptLevel, String searchTerm, String viewMode) {
        RankingStats stats = new RankingStats();
        
        try {
            if ("individual".equals(viewMode)) {
                List<Result> results = getFilteredResults(jlptLevel, searchTerm);
                stats.setTotalStudents(results.size());
                stats.setTotalTests(results.size());
                
                if (!results.isEmpty()) {
                    double sum = results.stream().mapToDouble(Result::getScore).sum();
                    stats.setAverageScore(sum / results.size());
                    stats.setHighestScore(results.stream().mapToDouble(Result::getScore).max().orElse(0));
                }
            } else {
                List<StudentRanking> rankings = getAverageRankings(jlptLevel, searchTerm);
                stats.setTotalStudents(rankings.size());
                
                if (!rankings.isEmpty()) {
                    int totalTests = rankings.stream().mapToInt(StudentRanking::getTestCount).sum();
                    stats.setTotalTests(totalTests);
                    
                    double sum = rankings.stream().mapToDouble(StudentRanking::getAverageScore).sum();
                    stats.setAverageScore(sum / rankings.size());
                    stats.setHighestScore(rankings.stream().mapToDouble(StudentRanking::getAverageScore).max().orElse(0));
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy thống kê: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    // Thêm các method phân trang sau method getRankingStats

    // Lấy kết quả với phân trang
    public List<Result> getFilteredResultsWithPagination(String jlptLevel, String searchTerm, int page, int pageSize) {
        List<Result> results = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.studentID, r.testId, r.score, r.timeTaken, r.status, " +
            "ua.fullName as studentName, ua.profilePicture, " +
            "t.jlptLevel, t.title as testTitle " +
            "FROM Result r " +
            "JOIN Student s ON r.studentID = s.studentID " +
            "JOIN UserAccount ua ON s.userID = ua.userID " +
            "JOIN Test t ON r.testId = t.id " +
            "WHERE r.status IN ('Pass', 'Fail')"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc JLPT level
        if (jlptLevel != null && !jlptLevel.isEmpty() && !jlptLevel.equals("Tất cả")) {
            sql.append(" AND t.jlptLevel = ?");
            params.add(jlptLevel);
        }
        
        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (ua.fullName LIKE ? OR r.studentID LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        sql.append(" ORDER BY r.score DESC, r.timeTaken ASC");
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Result result = new Result();
                    result.setStudentID(rs.getString("studentID"));
                    result.setTestId(rs.getInt("testId"));
                    result.setScore(rs.getDouble("score"));
                    result.setTimeTaken(rs.getString("timeTaken"));
                    result.setStatus(rs.getString("status"));
                    result.setStudentName(rs.getString("studentName"));
                    result.setProfilePicture(rs.getString("profilePicture"));
                    result.setJlptLevel(rs.getString("jlptLevel"));
                    result.setTestTitle(rs.getString("testTitle"));
                    results.add(result);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lọc kết quả với phân trang: " + e.getMessage());
            e.printStackTrace();
        }
        
        return results;
    }

    // Lấy xếp hạng trung bình với phân trang
    public List<StudentRanking> getAverageRankingsWithPagination(String jlptLevel, String searchTerm, int page, int pageSize) {
        List<StudentRanking> rankings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT r.studentID, ua.fullName as studentName, ua.profilePicture, " +
            "AVG(r.score) as averageScore, COUNT(r.testId) as testCount, " +
            "GROUP_CONCAT(DISTINCT t.jlptLevel ORDER BY t.jlptLevel) as jlptLevels " +
            "FROM Result r " +
            "JOIN Student s ON r.studentID = s.studentID " +
            "JOIN UserAccount ua ON s.userID = ua.userID " +
            "JOIN Test t ON r.testId = t.id " +
            "WHERE r.status IN ('Pass', 'Fail')"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc JLPT level
        if (jlptLevel != null && !jlptLevel.isEmpty() && !jlptLevel.equals("Tất cả")) {
            sql.append(" AND t.jlptLevel = ?");
            params.add(jlptLevel);
        }
        
        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (ua.fullName LIKE ? OR r.studentID LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        sql.append(" GROUP BY r.studentID, ua.fullName, ua.profilePicture");
        sql.append(" ORDER BY averageScore DESC, testCount DESC");
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                int rank = (page - 1) * pageSize + 1; // Tính rank dựa trên trang hiện tại
                while (rs.next()) {
                    StudentRanking ranking = new StudentRanking();
                    ranking.setStudentID(rs.getString("studentID"));
                    ranking.setStudentName(rs.getString("studentName"));
                    ranking.setProfilePicture(rs.getString("profilePicture"));
                    ranking.setAverageScore(rs.getDouble("averageScore"));
                    ranking.setTestCount(rs.getInt("testCount"));
                    ranking.setJlptLevels(rs.getString("jlptLevels"));
                    ranking.setRank(rank++);
                    rankings.add(ranking);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy xếp hạng trung bình với phân trang: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rankings;
    }

    // Đếm tổng số kết quả
    public int getTotalResultsCount(String jlptLevel, String searchTerm) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) as total " +
            "FROM Result r " +
            "JOIN Student s ON r.studentID = s.studentID " +
            "JOIN UserAccount ua ON s.userID = ua.userID " +
            "JOIN Test t ON r.testId = t.id " +
            "WHERE r.status IN ('Pass', 'Fail')"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc JLPT level
        if (jlptLevel != null && !jlptLevel.isEmpty() && !jlptLevel.equals("Tất cả")) {
            sql.append(" AND t.jlptLevel = ?");
            params.add(jlptLevel);
        }
        
        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (ua.fullName LIKE ? OR r.studentID LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi đếm tổng số kết quả: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }

    // Đếm tổng số học sinh (cho average ranking)
    public int getTotalStudentsCount(String jlptLevel, String searchTerm) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(DISTINCT r.studentID) as total " +
            "FROM Result r " +
            "JOIN Student s ON r.studentID = s.studentID " +
            "JOIN UserAccount ua ON s.userID = ua.userID " +
            "JOIN Test t ON r.testId = t.id " +
            "WHERE r.status IN ('Pass', 'Fail')"
        );
        
        List<Object> params = new ArrayList<>();
        
        // Thêm điều kiện lọc JLPT level
        if (jlptLevel != null && !jlptLevel.isEmpty() && !jlptLevel.equals("Tất cả")) {
            sql.append(" AND t.jlptLevel = ?");
            params.add(jlptLevel);
        }
        
        // Thêm điều kiện tìm kiếm
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (ua.fullName LIKE ? OR r.studentID LIKE ?)");
            String searchPattern = "%" + searchTerm.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi đếm tổng số học sinh: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Class thống kê
    public static class RankingStats {
        private int totalStudents;
        private double averageScore;
        private double highestScore;
        private int totalTests;
        
        // Getters and Setters
        public int getTotalStudents() { return totalStudents; }
        public void setTotalStudents(int totalStudents) { this.totalStudents = totalStudents; }
        
        public double getAverageScore() { return averageScore; }
        public void setAverageScore(double averageScore) { this.averageScore = averageScore; }
        
        public double getHighestScore() { return highestScore; }
        public void setHighestScore(double highestScore) { this.highestScore = highestScore; }
        
        public int getTotalTests() { return totalTests; }
        public void setTotalTests(int totalTests) { this.totalTests = totalTests; }
    }
    
    // Test method với dữ liệu thực tế
    public static void main(String[] args) {
        System.out.println("=== KIỂM TRA RESULTDAO VỚI DỮ LIỆU THỰC TẾ ===");
        ResultDAO dao = new ResultDAO();
        
        try {
            // Test 1: Lấy tất cả kết quả
            System.out.println("\n1. Kiểm tra lấy tất cả kết quả:");
            List<Result> allResults = dao.getAllResultsWithDetails();
            System.out.println("Tổng số kết quả: " + allResults.size());
            
            if (!allResults.isEmpty()) {
                System.out.println("Top 5 kết quả cao nhất:");
                for (int i = 0; i < Math.min(5, allResults.size()); i++) {
                    Result r = allResults.get(i);
                    System.out.printf("%d. %s (%s) - %.0f điểm - %s - Status: %s%n", 
                        i+1, r.getStudentName(), r.getStudentID(), 
                        r.getScore(), r.getTimeTaken(), r.getStatus());
                }
            }
            
            // Test 2: Kiểm tra các status có trong database
            System.out.println("\n2. Kiểm tra các status trong database:");
            List<String> statuses = new ArrayList<>();
            for (Result r : allResults) {
                if (!statuses.contains(r.getStatus())) {
                    statuses.add(r.getStatus());
                }
            }
            System.out.println("Các status có trong DB: " + statuses);
            
            // Test 3: Thống kê Pass/Fail
            System.out.println("\n3. Thống kê Pass/Fail:");
            long passCount = allResults.stream().filter(r -> "Pass".equals(r.getStatus())).count();
            long failCount = allResults.stream().filter(r -> "Fail".equals(r.getStatus())).count();
            System.out.println("Số bài Pass: " + passCount);
            System.out.println("Số bài Fail: " + failCount);
            System.out.println("Tỷ lệ Pass: " + String.format("%.1f%%", (passCount * 100.0 / allResults.size())));
            
            // Test 4: Lọc theo JLPT level
            System.out.println("\n4. Kiểm tra lọc theo JLPT level:");
            List<Result> n5Results = dao.getFilteredResults("N5", "");
            List<Result> n4Results = dao.getFilteredResults("N4", "");
            List<Result> n3Results = dao.getFilteredResults("N3", "");
            System.out.println("Kết quả N5: " + n5Results.size());
            System.out.println("Kết quả N4: " + n4Results.size());
            System.out.println("Kết quả N3: " + n3Results.size());
            
            // Test 5: Xếp hạng trung bình
            System.out.println("\n5. Kiểm tra xếp hạng trung bình:");
            List<StudentRanking> rankings = dao.getAverageRankings("", "");
            System.out.println("Số học sinh trong bảng xếp hạng: " + rankings.size());
            
            if (!rankings.isEmpty()) {
                System.out.println("Top 5 học sinh:");
                for (int i = 0; i < Math.min(5, rankings.size()); i++) {
                    StudentRanking r = rankings.get(i);
                    System.out.printf("%d. %s (%s) - %.1f điểm TB - %d bài thi%n", 
                        r.getRank(), r.getStudentName(), r.getStudentID(),
                        r.getAverageScore(), r.getTestCount());
                }
            }
            
            // Test 6: Thống kê tổng quan
            System.out.println("\n6. Thống kê tổng quan:");
            RankingStats stats = dao.getRankingStats("", "", "individual");
            System.out.println("Thống kê cá nhân:");
            System.out.println("- Tổng bài thi: " + stats.getTotalTests());
            System.out.println("- Điểm trung bình: " + String.format("%.1f", stats.getAverageScore()));
            System.out.println("- Điểm cao nhất: " + stats.getHighestScore());
            
        } catch (Exception e) {
            System.err.println("Lỗi trong quá trình test: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("\n=== KẾT THÚC KIỂM TRA ===");
    }
}
