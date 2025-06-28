package dao.student;

import model.student.Discount;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DiscountDAO {
    private static final Logger logger = LoggerFactory.getLogger(DiscountDAO.class);

    public DiscountDAO() {
        // Connection is obtained per method
    }

    private Connection getConnection() throws SQLException {
        DBContext dbContext = new DBContext();
        Connection conn = dbContext.getConnection();
        if (conn == null) {
            logger.error("DiscountDAO: Failed to obtain database connection.");
            throw new SQLException("Database connection is null.");
        }
        logger.debug("DiscountDAO: Obtained new database connection.");
        return conn;
    }

    public Discount getDiscountByCode(String code) {
        String sql = "SELECT * FROM Discount WHERE code = ? AND isActive = TRUE AND startDate <= CURDATE() AND endDate >= CURDATE()";
        Discount discount = null;
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, code);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    discount = new Discount();
                    discount.setId(rs.getInt("id"));
                    discount.setCode(rs.getString("code"));
                    discount.setCourseID(rs.getString("courseID"));
                    discount.setDiscountPercent(rs.getInt("discountPercent"));
                    discount.setStartDate(rs.getDate("startDate"));
                    discount.setEndDate(rs.getDate("endDate"));
                    discount.setActive(rs.getBoolean("isActive"));
                    logger.info("DiscountDAO: Found valid discount code: {} with {}% discount", code, discount.getDiscountPercent());
                } else {
                    logger.warn("DiscountDAO: No valid discount found for code: {}", code);
                }
            }
        } catch (SQLException e) {
            logger.error("DiscountDAO: Error in getDiscountByCode for code {}: {}", code, e.getMessage(), e);
        }
        return discount;
    }

    public void closeConnection() {
        logger.info("DiscountDAO: No persistent connection to close.");
    }

    // Main method for testing
    public static void main(String[] args) {
        DiscountDAO discountDAO = new DiscountDAO();

        // Array of test discount codes from the provided Discount table
        String[] testCodes = {"NEWBIE2025", "NEWBE12", "SUMMER2024", "JLPTN3SALE"};

        for (String code : testCodes) {
            System.out.println("\nTesting discount code: " + code);
            Discount discount = discountDAO.getDiscountByCode(code);

            if (discount != null) {
                System.out.println("Discount found:");
                System.out.println("ID: " + discount.getId());
                System.out.println("Code: " + discount.getCode());
                System.out.println("Course ID: " + discount.getCourseID());
                System.out.println("Discount Percent: " + discount.getDiscountPercent() + "%");
                System.out.println("Start Date: " + discount.getStartDate());
                System.out.println("End Date: " + discount.getEndDate());
                System.out.println("Active: " + discount.isActive());
            } else {
                System.out.println("No valid discount found for code: " + code);
            }
        }

        // Close connection (logs no persistent connection message)
        discountDAO.closeConnection();
    }
}