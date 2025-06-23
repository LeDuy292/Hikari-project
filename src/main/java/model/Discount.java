package model;

import java.sql.Date;

public class Discount {
  private int id;
  private String code;
  private String courseID;
  private int discountPercent;
  private Date startDate;
  private Date endDate;
  private boolean isActive;

  public Discount() {
  }

  public Discount(int id, String code, String courseID, int discountPercent, Date startDate, Date endDate, boolean isActive) {
      this.id = id;
      this.code = code;
      this.courseID = courseID;
      this.discountPercent = discountPercent;
      this.startDate = startDate;
      this.endDate = endDate;
      this.isActive = isActive;
  }

  // Getters and Setters
  public int getId() {
      return id;
  }

  public void setId(int id) {
      this.id = id;
  }

  public String getCode() {
      return code;
  }

  public void setCode(String code) {
      this.code = code;
  }

  public String getCourseID() {
      return courseID;
  }

  public void setCourseID(String courseID) {
      this.courseID = courseID;
  }

  public int getDiscountPercent() {
      return discountPercent;
  }

  public void setDiscountPercent(int discountPercent) {
      this.discountPercent = discountPercent;
  }

  public Date getStartDate() {
      return startDate;
  }

  public void setStartDate(Date startDate) {
      this.startDate = startDate;
  }

  public Date getEndDate() {
      return endDate;
  }

  public void setEndDate(Date endDate) {
      this.endDate = endDate;
  }

  public boolean isActive() {
      return isActive;
  }

  public void setActive(boolean active) {
      isActive = active;
  }

  @Override
  public String toString() {
      return "Discount{" +
              "id=" + id +
              ", code='" + code + '\'' +
              ", courseID='" + courseID + '\'' +
              ", discountPercent=" + discountPercent +
              ", startDate=" + startDate +
              ", endDate=" + endDate +
              ", isActive=" + isActive +
              '}';
  }
}
