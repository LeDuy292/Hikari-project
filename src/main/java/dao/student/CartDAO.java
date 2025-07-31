package dao.student;

import model.student.Cart;
import utils.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CartDAO {

    private static final Logger logger = LoggerFactory.getLogger(CartDAO.class);

    public CartDAO() {
        // Connection is obtained per method
    }

    public Connection getConnection() {
        DBContext dbContext = new DBContext();
        Connection conn = null;
        try {
            conn = dbContext.getConnection();
        } catch (SQLException ex) {
            logger.error("CartDAO: Failed to obtain database connection: {}", ex.getMessage(), ex);
        }
        if (conn == null) {
            logger.error("CartDAO: Database connection is null.");
            throw new IllegalStateException("Database connection is null.");
        }
        logger.debug("CartDAO: Obtained new database connection.");
        return conn;
    }

    public Cart getCartById(int cartID) {
        String sql = "SELECT c.*, COUNT(ci.cartItemID) AS itemCount FROM Cart c LEFT JOIN CartItem ci ON c.cartID = ci.cartID WHERE c.cartID = ? GROUP BY c.cartID";
        Cart cart = null;
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    cart = new Cart();
                    cart.setCartID(rs.getInt("cartID"));
                    cart.setUserID(rs.getString("userID"));
                    cart.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    cart.setDiscountCodeApplied(rs.getString("discountCodeApplied"));
                    cart.setDiscountAmount(rs.getBigDecimal("discountAmount"));
                    cart.setCreatedAt(rs.getTimestamp("createdAt"));
                    cart.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    cart.setItemCount(rs.getInt("itemCount"));
                    logger.debug("CartDAO: Retrieved cart for cartID {}: UserID={}", cartID, cart.getUserID());
                } else {
                    logger.debug("CartDAO: No cart found for cartID {}.", cartID);
                }
            }
        } catch (SQLException e) {
            logger.error("CartDAO: Error in getCartById for cartID {}: {}", cartID, e.getMessage(), e);
        }
        return cart;
    }

    public boolean enrollStudent(String userID, String courseID, Connection conn) throws SQLException {
        String getStudentSQL = "SELECT studentID FROM Student WHERE userID = ?";
        String studentID;
        try (PreparedStatement pre = conn.prepareStatement(getStudentSQL)) {
            pre.setString(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    studentID = rs.getString("studentID");
                } else {
                    logger.error("No student found for userID: {}", userID);
                    return false;
                }
            }
        }

        String sql = "INSERT INTO Course_Enrollments (enrollmentID, studentID, courseID, enrollmentDate) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, generateEnrollmentID(conn));
            stmt.setString(2, studentID);
            stmt.setString(3, courseID);
            stmt.setDate(4, new java.sql.Date(System.currentTimeMillis()));
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.error("Failed to enroll studentID: {} for courseID: {}", studentID, courseID, e);
            throw e;
        }
    }

    private String generateEnrollmentID(Connection conn) throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(enrollmentID, 2) AS UNSIGNED)) AS maxID FROM Course_Enrollments";
        try (PreparedStatement pre = conn.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            int maxID = 0;
            if (rs.next()) {
                maxID = rs.getInt("maxID");
            }
            return String.format("E%03d", maxID + 1);
        }
    }

    public Cart getCartByUserID(String userID) {
        String sql = "SELECT c.*, COUNT(ci.cartItemID) AS itemCount FROM Cart c LEFT JOIN CartItem ci ON c.cartID = ci.cartID WHERE c.userID = ? GROUP BY c.cartID";
        Cart cart = null;
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, userID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    cart = new Cart();
                    cart.setCartID(rs.getInt("cartID"));
                    cart.setUserID(rs.getString("userID"));
                    cart.setTotalAmount(rs.getBigDecimal("totalAmount"));
                    cart.setDiscountCodeApplied(rs.getString("discountCodeApplied"));
                    cart.setDiscountAmount(rs.getBigDecimal("discountAmount"));
                    cart.setCreatedAt(rs.getTimestamp("createdAt"));
                    cart.setUpdatedAt(rs.getTimestamp("updatedAt"));
                    cart.setItemCount(rs.getInt("itemCount"));
                    logger.debug("CartDAO: Retrieved cart for user {}: CartID={}", userID, cart.getCartID());
                } else {
                    logger.debug("CartDAO: No cart found for user {}.", userID);
                }
            }
        } catch (SQLException e) {
            logger.error("CartDAO: Error in getCartByUserID for user {}: {}", userID, e.getMessage(), e);
        }
        return cart;
    }

    public int createCart(String userID) {
        String sql = "INSERT INTO Cart (userID, totalAmount, discountAmount) VALUES (?, ?, ?)";
        int cartID = -1;
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement pre = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pre.setString(1, userID);
                pre.setBigDecimal(2, BigDecimal.ZERO);
                pre.setBigDecimal(3, BigDecimal.ZERO);
                int affectedRows = pre.executeUpdate();
                if (affectedRows > 0) {
                    try (ResultSet rs = pre.getGeneratedKeys()) {
                        if (rs.next()) {
                            cartID = rs.getInt(1);
                            logger.info("CartDAO: Created new cart for user {}: CartID={}", userID, cartID);
                        }
                    }
                } else {
                    logger.warn("CartDAO: No rows affected when creating cart for user {}.", userID);
                }
            }
            conn.commit();
        } catch (SQLException e) {
            logger.error("CartDAO: Error in createCart for user {}: {}", userID, e.getMessage(), e);
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException rollbackEx) {
                logger.error("CartDAO: Rollback failed: {}", rollbackEx.getMessage(), rollbackEx);
            }
            if (e.getSQLState().startsWith("23")) {
                logger.warn("CartDAO: Unique constraint violation when creating cart for user {}. Attempting to retrieve existing cart.", userID);
                Cart existingCart = getCartByUserID(userID);
                if (existingCart != null) {
                    cartID = existingCart.getCartID();
                    logger.info("CartDAO: Retrieved existing cart ID {} for user {} after failed creation attempt.", cartID, userID);
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                    logger.debug("CartDAO: Closed database connection.");
                } catch (SQLException e) {
                    logger.error("CartDAO: Error closing connection: {}", e.getMessage(), e);
                }
            }
        }
        return cartID;
    }

    public boolean updateCartTotals(int cartID, BigDecimal totalAmount, BigDecimal discountAmount, String discountCodeApplied) {
        String sql = "UPDATE Cart SET totalAmount = ?, discountAmount = ?, discountCodeApplied = ?, updatedAt = CURRENT_TIMESTAMP WHERE cartID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setBigDecimal(1, totalAmount);
            pre.setBigDecimal(2, discountAmount);
            pre.setString(3, discountCodeApplied);
            pre.setInt(4, cartID);
            boolean updated = pre.executeUpdate() > 0;
            if (updated) {
                logger.info("CartDAO: Updated totals for cart {}: Total={}, Discount={}, Code={}", cartID, totalAmount, discountAmount, discountCodeApplied);
            } else {
                logger.warn("CartDAO: Failed to update totals for cart {}.", cartID);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("CartDAO: Error in updateCartTotals for cart {}: {}", cartID, e.getMessage(), e);
            return false;
        }
    }

    public boolean clearCart(int cartID, Connection conn) throws SQLException {
        String sqlDeleteItems = "DELETE FROM CartItem WHERE cartID = ?";
        String sqlUpdateCart = "UPDATE Cart SET totalAmount = 0, discountAmount = 0, discountCodeApplied = NULL, updatedAt = CURRENT_TIMESTAMP WHERE cartID = ?";
        try (PreparedStatement preDelete = conn.prepareStatement(sqlDeleteItems); PreparedStatement preUpdate = conn.prepareStatement(sqlUpdateCart)) {
            preDelete.setInt(1, cartID);
            int deletedItems = preDelete.executeUpdate();
            logger.info("CartDAO: Cleared {} items from cart {}.", deletedItems, cartID);

            preUpdate.setInt(1, cartID);
            boolean updatedCart = preUpdate.executeUpdate() > 0;
            if (updatedCart) {
                logger.info("CartDAO: Reset totals for cart {}.", cartID);
            } else {
                logger.warn("CartDAO: Failed to reset totals for cart {}.", cartID);
            }
            return updatedCart;
        }
    }

    public String getUserIdByCartId(Integer cartID) {
        String sql = "SELECT userID FROM Cart WHERE cartID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    String userID = rs.getString("userID");
                    logger.debug("CartDAO: Found userID {} for cartID {}.", userID, cartID);
                    return userID;
                } else {
                    logger.warn("CartDAO: No userID found for cartID {}.", cartID);
                    return null;
                }
            }
        } catch (SQLException e) {
            logger.error("CartDAO: Error in getUserIdByCartId for cartID {}: {}", cartID, e.getMessage(), e);
            return null;
        }
    }

    public Integer getCartIdByOrderCode(String orderCode) {
        String sql = "SELECT cartID FROM Cart WHERE orderCode = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, orderCode);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    Integer cartID = rs.getInt("cartID");
                    logger.debug("CartDAO: Found cartID {} for orderCode {}.", cartID, orderCode);
                    return cartID;
                } else {
                    logger.warn("CartDAO: No cart found for orderCode {}.", orderCode);
                    return null;
                }
            }
        } catch (SQLException e) {
            logger.error("CartDAO: Error in getCartIdByOrderCode for orderCode {}: {}", orderCode, e.getMessage(), e);
            return null;
        }
    }

    public boolean saveOrderCode(int cartID, String orderCode) {
        String sql = "UPDATE Cart SET orderCode = ? WHERE cartID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setString(1, orderCode);
            pre.setInt(2, cartID);
            int rowsAffected = pre.executeUpdate();
            if (rowsAffected > 0) {
                logger.info("CartDAO: Saved orderCode {} for cartID {}.", orderCode, cartID);
                return true;
            } else {
                logger.warn("CartDAO: Failed to save orderCode {} for cartID {}.", orderCode, cartID);
                return false;
            }
        } catch (SQLException e) {
            logger.error("CartDAO: Error in saveOrderCode for cartID {}: {}", cartID, e.getMessage(), e);
            return false;
        }
    }

    public void closeConnection() {
        logger.info("CartDAO: No persistent connection to close.");
    }
}