package dao.student;

import model.student.CartItem;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CartItemDAO {

    private static final Logger logger = LoggerFactory.getLogger(CartItemDAO.class);

    public CartItemDAO() {
        // No connection initialization
    }

    private Connection getConnection() throws SQLException {
        DBContext dbContext = new DBContext();
        Connection conn = dbContext.getConnection();
        if (conn == null) {
            logger.error("CartItemDAO: Failed to obtain database connection.");
            throw new SQLException("Database connection is null.");
        }
        logger.debug("CartItemDAO: Obtained new database connection.");
        return conn;
    }

    public CartItem getCartItemByCartIdAndCourseId(int cartID, String courseID) {
        String sql = "SELECT ci.*, c.title AS courseTitle, c.description AS courseDescription, c.imageUrl AS courseImageUrl "
                + "FROM CartItem ci JOIN Courses c ON ci.courseID = c.courseID "
                + "WHERE ci.cartID = ? AND ci.courseID = ?";
        CartItem cartItem = null;
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartID);
            pre.setString(2, courseID);
            try (ResultSet rs = pre.executeQuery()) {
                if (rs.next()) {
                    cartItem = mapResultSetToCartItem(rs);
                    logger.debug("CartItemDAO: Retrieved cart item: cartID={}, courseID={}", cartID, courseID);
                } else {
                    logger.debug("CartItemDAO: No cart item found for cartID={}, courseID={}", cartID, courseID);
                }
            }
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in getCartItemByCartIdAndCourseId (cartID={}, courseID={}): {}", cartID, courseID, e.getMessage(), e);
        }
        return cartItem;
    }

    public List<CartItem> getCartItemsByCartID(int cartID) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT ci.*, c.title AS courseTitle, c.description AS courseDescription, c.imageUrl AS courseImageUrl "
                + "FROM CartItem ci JOIN Courses c ON ci.courseID = c.courseID "
                + "WHERE ci.cartID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    cartItems.add(mapResultSetToCartItem(rs));
                }
                logger.debug("CartItemDAO: Retrieved {} items for cartID={}", cartItems.size(), cartID);
            }
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in getCartItemsByCartID (cartID={}): {}", cartID, e.getMessage(), e);
        }
        return cartItems;
    }

    public boolean addCartItem(CartItem cartItem) {
        String sql = "INSERT INTO CartItem (cartID, courseID, quantity, priceAtTime, discountApplied) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartItem.getCartID());
            pre.setString(2, cartItem.getCourseID());
            pre.setInt(3, cartItem.getQuantity());
            pre.setBigDecimal(4, cartItem.getPriceAtTime());
            pre.setBigDecimal(5, cartItem.getDiscountApplied());
            boolean added = pre.executeUpdate() > 0;
            if (added) {
                logger.info("CartItemDAO: Added cart item: cartID={}, courseID={}", cartItem.getCartID(), cartItem.getCourseID());
            } else {
                logger.warn("CartItemDAO: Failed to add cart item: cartID={}, courseID={}", cartItem.getCartID(), cartItem.getCourseID());
            }
            return added;
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in addCartItem (cartID={}, courseID={}): {}", cartItem.getCartID(), cartItem.getCourseID(), e.getMessage(), e);
            if (e.getSQLState().startsWith("23")) {
                logger.error("CartItemDAO: Unique constraint violation when adding item. Item might already exist in cart.");
            }
            return false;
        }
    }

    public boolean updateCartItemQuantity(int cartItemID, int quantity) {
        String sql = "UPDATE CartItem SET quantity = ? WHERE cartItemID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, quantity);
            pre.setInt(2, cartItemID);
            boolean updated = pre.executeUpdate() > 0;
            if (updated) {
                logger.info("CartItemDAO: Updated quantity for cartItemID {} to {}.", cartItemID, quantity);
            } else {
                logger.warn("CartItemDAO: Failed to update quantity for cartItemID {}.", cartItemID);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in updateCartItemQuantity (cartItemID={}): {}", cartItemID, e.getMessage(), e);
            return false;
        }
    }

    public boolean updateCartItemDiscount(int cartItemID, BigDecimal discountApplied) {
        String sql = "UPDATE CartItem SET discountApplied = ? WHERE cartItemID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setBigDecimal(1, discountApplied);
            pre.setInt(2, cartItemID);
            boolean updated = pre.executeUpdate() > 0;
            if (updated) {
                logger.info("CartItemDAO: Updated discount for cartItemID {} to {}.", cartItemID, discountApplied);
            } else {
                logger.warn("CartItemDAO: Failed to update discount for cartItemID {}.", cartItemID);
            }
            return updated;
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in updateCartItemDiscount (cartItemID={}): {}", cartItemID, e.getMessage(), e);
            return false;
        }
    }

    public boolean removeCartItem(int cartItemID) {
        String sql = "DELETE FROM CartItem WHERE cartItemID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartItemID);
            boolean removed = pre.executeUpdate() > 0;
            if (removed) {
                logger.info("CartItemDAO: Removed cart item {}.", cartItemID);
            } else {
                logger.warn("CartItemDAO: Failed to remove cart item {}.", cartItemID);
            }
            return removed;
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in removeCartItem (cartItemID={}): {}", cartItemID, e.getMessage(), e);
            return false;
        }
    }

    public List<String> getCourseIdsByCartId(Integer cartID) {
        List<String> courseIds = new ArrayList<>();
        String sql = "SELECT courseID FROM CartItem WHERE cartID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartID);
            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    courseIds.add(rs.getString("courseID"));
                }
                logger.debug("CartItemDAO: Retrieved {} course IDs for cartID {}.", courseIds.size(), cartID);
            }
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in getCourseIdsByCartId for cartID {}: {}", cartID, e.getMessage(), e);
        }
        return courseIds;
    }

    public boolean clearCartItems(Integer cartID, Connection conn) throws SQLException {
        String sql = "DELETE FROM CartItem WHERE cartID = ?";
        try (PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartID);
            int rowsAffected = pre.executeUpdate();
            logger.info("CartItemDAO: Cleared {} items from cartID {}.", rowsAffected, cartID);
            return rowsAffected >= 0;
        }
    }

    public boolean clearCartItems(Integer cartID) {
        String sql = "DELETE FROM CartItem WHERE cartID = ?";
        try (Connection conn = getConnection(); PreparedStatement pre = conn.prepareStatement(sql)) {
            pre.setInt(1, cartID);
            int rowsAffected = pre.executeUpdate();
            logger.info("CartItemDAO: Cleared {} items from cartID {}.", rowsAffected, cartID);
            return rowsAffected >= 0;
        } catch (SQLException e) {
            logger.error("CartItemDAO: Error in clearCartItems for cartID {}: {}", cartID, e.getMessage(), e);
            return false;
        }
    }

    private CartItem mapResultSetToCartItem(ResultSet rs) throws SQLException {
        CartItem cartItem = new CartItem();
        cartItem.setCartItemID(rs.getInt("cartItemID"));
        cartItem.setCartID(rs.getInt("cartID"));
        cartItem.setCourseID(rs.getString("courseID"));
        cartItem.setQuantity(rs.getInt("quantity"));
        cartItem.setPriceAtTime(rs.getBigDecimal("priceAtTime"));
        cartItem.setDiscountApplied(rs.getBigDecimal("discountApplied"));
        cartItem.setCourseTitle(rs.getString("courseTitle"));
        cartItem.setCourseDescription(rs.getString("courseDescription"));
        cartItem.setCourseImageUrl(rs.getString("courseImageUrl"));
        cartItem.setTotalPrice(cartItem.getPriceAtTime().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
        return cartItem;
    }

    public void closeConnection() {
        logger.info("CartItemDAO: No persistent connection to close.");
    }
}
