package model.student;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Cart {
  private int cartID;
  private String userID; // Changed from int to String
  private BigDecimal totalAmount;
  private String discountCodeApplied;
  private BigDecimal discountAmount;
  private Timestamp createdAt;
  private Timestamp updatedAt;
  private int itemCount; // Transient field for display purposes

  public Cart() {
  }

  public Cart(int cartID, String userID, BigDecimal totalAmount, String discountCodeApplied, BigDecimal discountAmount, Timestamp createdAt, Timestamp updatedAt) {
      this.cartID = cartID;
      this.userID = userID;
      this.totalAmount = totalAmount;
      this.discountCodeApplied = discountCodeApplied;
      this.discountAmount = discountAmount;
      this.createdAt = createdAt;
      this.updatedAt = updatedAt;
  }

  // Getters and Setters
  public int getCartID() {
      return cartID;
  }

  public void setCartID(int cartID) {
      this.cartID = cartID;
  }

  public String getUserID() {
      return userID;
  }

  public void setUserID(String userID) {
      this.userID = userID;
  }

  public BigDecimal getTotalAmount() {
      return totalAmount;
  }

  public void setTotalAmount(BigDecimal totalAmount) {
      this.totalAmount = totalAmount;
  }

  public String getDiscountCodeApplied() {
      return discountCodeApplied;
  }

  public void setDiscountCodeApplied(String discountCodeApplied) {
      this.discountCodeApplied = discountCodeApplied;
  }

  public BigDecimal getDiscountAmount() {
      return discountAmount;
  }

  public void setDiscountAmount(BigDecimal discountAmount) {
      this.discountAmount = discountAmount;
  }

  public Timestamp getCreatedAt() {
      return createdAt;
  }

  public void setCreatedAt(Timestamp createdAt) {
      this.createdAt = createdAt;
  }

  public Timestamp getUpdatedAt() {
      return updatedAt;
  }

  public void setUpdatedAt(Timestamp updatedAt) {
      this.updatedAt = updatedAt;
  }

  public int getItemCount() {
      return itemCount;
  }

  public void setItemCount(int itemCount) {
      this.itemCount = itemCount;
  }

  @Override
  public String toString() {
      return "Cart{" +
              "cartID=" + cartID +
              ", userID='" + userID + '\'' +
              ", totalAmount=" + totalAmount +
              ", discountCodeApplied='" + discountCodeApplied + '\'' +
              ", discountAmount=" + discountAmount +
              ", createdAt=" + createdAt +
              ", updatedAt=" + updatedAt +
              ", itemCount=" + itemCount +
              '}';
  }
}
