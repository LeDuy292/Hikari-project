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

    private Connection getConnection() throws SQLException {
        DBContext dbContext = new DBContext();
        Connection conn = dbContext.getConnection();
        if (conn == null) {
            logger.error("CartDAO: Failed to obtain database connection.");
            throw new SQLException("Database connection is null.");
        }
        logger.debug("CartDAO: Obtained new database connection.");
        return conn;
    }

    public Cart getCartByUserID(String userID) {
        String sql = "SELECT c.*, COUNT(ci.cartItemID) AS itemCount FROM Cart c LEFT JOIN CartItem ci ON c.cartID = ci.cartID WHERE c.userID = ? GROUP BY c.cartID";
        Cart cart = null;
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {
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
                if (conn != null) conn.rollback();
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
        try (Connection conn = getConnection();
             PreparedStatement pre = conn.prepareStatement(sql)) {
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

    public boolean clearCart(int cartID) {
        String sqlDeleteItems = "DELETE FROM CartItem WHERE cartID = ?";
        String sqlUpdateCart = "UPDATE Cart SET totalAmount = 0, discountAmount = 0, discountCodeApplied = NULL, updatedAt = CURRENT_TIMESTAMP WHERE cartID = ?";
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            try (PreparedStatement preDelete = conn.prepareStatement(sqlDeleteItems);
                 PreparedStatement preUpdate = conn.prepareStatement(sqlUpdateCart)) {
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
                conn.commit();
                return updatedCart;
            }
        } catch (SQLException e) {
            logger.error("CartDAO: Error in clearCart for cart {}: {}", cartID, e.getMessage(), e);
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException rollbackEx) {
                logger.error("CartDAO: Rollback failed: {}", rollbackEx.getMessage(), rollbackEx);
            }
            return false;
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
    }

    public void closeConnection() {
        logger.info("CartDAO: No persistent connection to close.");
    }
}