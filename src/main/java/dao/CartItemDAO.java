package dao;

import model.CartItem;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAO {
  private Connection con;

  public CartItemDAO() {
      DBContext dBContext = new DBContext();
      try {
          con = dBContext.getConnection();
          System.out.println("CartItemDAO: KET NOI THANH CONG!");
      } catch (Exception e) {
          System.err.println("CartItemDAO: Error connecting to database: " + e);
      }
  }

  public CartItem getCartItemByCartIdAndCourseId(int cartID, String courseID) {
      String sql = "SELECT ci.*, c.title AS courseTitle, c.description AS courseDescription, c.imageUrl AS courseImageUrl " +
                   "FROM CartItem ci JOIN Courses c ON ci.courseID = c.courseID " +
                   "WHERE ci.cartID = ? AND ci.courseID = ?";
      CartItem cartItem = null;
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setInt(1, cartID);
          pre.setString(2, courseID);
          try (ResultSet rs = pre.executeQuery()) {
              if (rs.next()) {
                  cartItem = mapResultSetToCartItem(rs);
              }
          }
      } catch (SQLException e) {
          System.err.println("Error in getCartItemByCartIdAndCourseId: " + e.getMessage());
      }
      return cartItem;
  }

  public List<CartItem> getCartItemsByCartID(int cartID) {
      List<CartItem> cartItems = new ArrayList<>();
      String sql = "SELECT ci.*, c.title AS courseTitle, c.description AS courseDescription, c.imageUrl AS courseImageUrl " +
                   "FROM CartItem ci JOIN Courses c ON ci.courseID = c.courseID " +
                   "WHERE ci.cartID = ?";
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setInt(1, cartID);
          try (ResultSet rs = pre.executeQuery()) {
              while (rs.next()) {
                  cartItems.add(mapResultSetToCartItem(rs));
              }
          }
      } catch (SQLException e) {
          System.err.println("Error in getCartItemsByCartID: " + e.getMessage());
      }
      return cartItems;
  }

  public boolean addCartItem(CartItem cartItem) {
      String sql = "INSERT INTO CartItem (cartID, courseID, quantity, priceAtTime, discountApplied) VALUES (?, ?, ?, ?, ?)";
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setInt(1, cartItem.getCartID());
          pre.setString(2, cartItem.getCourseID());
          pre.setInt(3, cartItem.getQuantity());
          pre.setBigDecimal(4, cartItem.getPriceAtTime());
          pre.setBigDecimal(5, cartItem.getDiscountApplied());
          return pre.executeUpdate() > 0;
      } catch (SQLException e) {
          System.err.println("Error in addCartItem: " + e.getMessage());
          return false;
      }
  }

  public boolean updateCartItemQuantity(int cartItemID, int quantity) {
      String sql = "UPDATE CartItem SET quantity = ? WHERE cartItemID = ?";
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setInt(1, quantity);
          pre.setInt(2, cartItemID);
          return pre.executeUpdate() > 0;
      } catch (SQLException e) {
          System.err.println("Error in updateCartItemQuantity: " + e.getMessage());
          return false;
      }
  }
  
  public boolean updateCartItemDiscount(int cartItemID, BigDecimal discountApplied) {
      String sql = "UPDATE CartItem SET discountApplied = ? WHERE cartItemID = ?";
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setBigDecimal(1, discountApplied);
          pre.setInt(2, cartItemID);
          return pre.executeUpdate() > 0;
      } catch (SQLException e) {
          System.err.println("Error in updateCartItemDiscount: " + e.getMessage());
          return false;
      }
  }

  public boolean removeCartItem(int cartItemID) {
      String sql = "DELETE FROM CartItem WHERE cartItemID = ?";
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setInt(1, cartItemID);
          return pre.executeUpdate() > 0;
      } catch (SQLException e) {
          System.err.println("Error in removeCartItem: " + e.getMessage());
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
      
      // Set transient fields for display
      cartItem.setCourseTitle(rs.getString("courseTitle"));
      cartItem.setCourseDescription(rs.getString("courseDescription"));
      cartItem.setCourseImageUrl(rs.getString("courseImageUrl"));
      
      // Calculate total price for the item
      cartItem.setTotalPrice(cartItem.getPriceAtTime().multiply(BigDecimal.valueOf(cartItem.getQuantity())));
      
      return cartItem;
  }

  public void closeConnection() {
      try {
          if (con != null && !con.isClosed()) {
              con.close();
              System.out.println("CartItemDAO: KET NOI DA DONG!");
          }
      } catch (SQLException e) {
          System.err.println("Error closing connection in CartItemDAO: " + e);
      }
  }
}
