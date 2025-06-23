package dao;

import model.Discount;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class DiscountDAO {
  private Connection con;

  public DiscountDAO() {
      DBContext dBContext = new DBContext();
      try {
          con = dBContext.getConnection();
          System.out.println("DiscountDAO: KET NOI THANH CONG!");
      } catch (Exception e) {
          System.err.println("DiscountDAO: Error connecting to database: " + e);
      }
  }

  public Discount getDiscountByCode(String code) {
      String sql = "SELECT * FROM Discount WHERE code = ? AND isActive = TRUE AND startDate <= CURDATE() AND endDate >= CURDATE()";
      Discount discount = null;
      try (PreparedStatement pre = con.prepareStatement(sql)) {
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
              }
          }
      } catch (SQLException e) {
          System.err.println("Error in getDiscountByCode: " + e.getMessage());
      }
      return discount;
  }

  public void closeConnection() {
      try {
          if (con != null && !con.isClosed()) {
              con.close();
              System.out.println("DiscountDAO: KET NOI DA DONG!");
          }
      } catch (SQLException e) {
          System.err.println("Error closing connection in DiscountDAO: " + e);
      }
  }
}
