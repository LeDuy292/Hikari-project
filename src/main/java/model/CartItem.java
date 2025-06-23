package model;

import java.math.BigDecimal;

public class CartItem {
  private int cartItemID;
  private int cartID;
  private String courseID;
  private int quantity;
  private BigDecimal priceAtTime;
  private BigDecimal discountApplied;

  // Transient fields for display purposes
  private String courseTitle;
  private String courseDescription;
  private String courseImageUrl;
  private BigDecimal totalPrice; // quantity * priceAtTime

  public CartItem() {
  }

  public CartItem(int cartItemID, int cartID, String courseID, int quantity, BigDecimal priceAtTime, BigDecimal discountApplied) {
      this.cartItemID = cartItemID;
      this.cartID = cartID;
      this.courseID = courseID;
      this.quantity = quantity;
      this.priceAtTime = priceAtTime;
      this.discountApplied = discountApplied;
  }

  // Getters and Setters
  public int getCartItemID() {
      return cartItemID;
  }

  public void setCartItemID(int cartItemID) {
      this.cartItemID = cartItemID;
  }

  public int getCartID() {
      return cartID;
  }

  public void setCartID(int cartID) {
      this.cartID = cartID;
  }

  public String getCourseID() {
      return courseID;
  }

  public void setCourseID(String courseID) {
      this.courseID = courseID;
  }

  public int getQuantity() {
      return quantity;
  }

  public void setQuantity(int quantity) {
      this.quantity = quantity;
  }

  public BigDecimal getPriceAtTime() {
      return priceAtTime;
  }

  public void setPriceAtTime(BigDecimal priceAtTime) {
      this.priceAtTime = priceAtTime;
  }

  public BigDecimal getDiscountApplied() {
      return discountApplied;
  }

  public void setDiscountApplied(BigDecimal discountApplied) {
      this.discountApplied = discountApplied;
  }

  public String getCourseTitle() {
      return courseTitle;
  }

  public void setCourseTitle(String courseTitle) {
      this.courseTitle = courseTitle;
  }

  public String getCourseDescription() {
      return courseDescription;
  }

  public void setCourseDescription(String courseDescription) {
      this.courseDescription = courseDescription;
  }

  public String getCourseImageUrl() {
      return courseImageUrl;
  }

  public void setCourseImageUrl(String courseImageUrl) {
      this.courseImageUrl = courseImageUrl;
  }

  public BigDecimal getTotalPrice() {
      return totalPrice;
  }

  public void setTotalPrice(BigDecimal totalPrice) {
      this.totalPrice = totalPrice;
  }

  @Override
  public String toString() {
      return "CartItem{" +
              "cartItemID=" + cartItemID +
              ", cartID=" + cartID +
              ", courseID='" + courseID + '\'' +
              ", quantity=" + quantity +
              ", priceAtTime=" + priceAtTime +
              ", discountApplied=" + discountApplied +
              ", courseTitle='" + courseTitle + '\'' +
              ", courseDescription='" + courseDescription + '\'' +
              ", courseImageUrl='" + courseImageUrl + '\'' +
              ", totalPrice=" + totalPrice +
              '}';
  }
}
