package dao;

import model.Cart;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.*;

public class CartDAO {
  private Connection con;

  public CartDAO() {
      DBContext dBContext = new DBContext();
      try {
          con = dBContext.getConnection();
          System.out.println("CartDAO: KET NOI THANH CONG!");
      } catch (Exception e) {
          System.err.println("CartDAO: Error connecting to database: " + e);
      }
  }

  public Cart getCartByUserID(String userID) {
      String sql = "SELECT c.*, COUNT(ci.cartItemID) AS itemCount FROM Cart c LEFT JOIN CartItem ci ON c.cartID = ci.cartID WHERE c.userID = ? GROUP BY c.cartID";
      Cart cart = null;
      try (PreparedStatement pre = con.prepareStatement(sql)) {
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
              }
          }
      } catch (SQLException e) {
          System.err.println("Error in getCartByUserID: " + e.getMessage());
      }
      return cart;
  }

  public int createCart(String userID) {
      String sql = "INSERT INTO Cart (userID, totalAmount, discountAmount) VALUES (?, ?, ?)";
      int cartID = -1;
      try (PreparedStatement pre = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
          pre.setString(1, userID);
          pre.setBigDecimal(2, BigDecimal.ZERO);
          pre.setBigDecimal(3, BigDecimal.ZERO);
          int affectedRows = pre.executeUpdate();
          if (affectedRows > 0) {
              try (ResultSet rs = pre.getGeneratedKeys()) {
                  if (rs.next()) {
                      cartID = rs.getInt(1);
                  }
              }
          }
      } catch (SQLException e) {
          System.err.println("Error in createCart: " + e.getMessage());
      }
      return cartID;
  }

  public boolean updateCartTotals(int cartID, BigDecimal totalAmount, BigDecimal discountAmount, String discountCodeApplied) {
      String sql = "UPDATE Cart SET totalAmount = ?, discountAmount = ?, discountCodeApplied = ? WHERE cartID = ?";
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setBigDecimal(1, totalAmount);
          pre.setBigDecimal(2, discountAmount);
          pre.setString(3, discountCodeApplied);
          pre.setInt(4, cartID);
          return pre.executeUpdate() > 0;
      } catch (SQLException e) {
          System.err.println("Error in updateCartTotals: " + e.getMessage());
          return false;
      }
  }
  
  public boolean clearCart(int cartID) {
      String sql = "DELETE FROM CartItem WHERE cartID = ?";
      try (PreparedStatement pre = con.prepareStatement(sql)) {
          pre.setInt(1, cartID);
          pre.executeUpdate(); // Delete all items first

          // Reset cart totals
          String updateCartSql = "UPDATE Cart SET totalAmount = 0, discountAmount = 0, discountCodeApplied = NULL WHERE cartID = ?";
          try (PreparedStatement updatePre = con.prepareStatement(updateCartSql)) {
              updatePre.setInt(1, cartID);
              return updatePre.executeUpdate() > 0;
          }
      } catch (SQLException e) {
          System.err.println("Error in clearCart: " + e.getMessage());
          return false;
      }
  }

  public void closeConnection() {
      try {
          if (con != null && !con.isClosed()) {
              con.close();
              System.out.println("CartDAO: KET NOI DA DONG!");
          }
      } catch (SQLException e) {
          System.err.println("Error closing connection in CartDAO: " + e);
      }
  }
}
