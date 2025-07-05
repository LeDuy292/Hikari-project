package dao.admin;

import model.admin.Payment;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class PaymentDAO {
    private static final Logger LOGGER = Logger.getLogger(PaymentDAO.class.getName());
    private final DBContext dbContext;

    public PaymentDAO() {
        this.dbContext = new DBContext();
    }

    public List<Payment> getAllPayments() throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, c.title as courseName " +
                    "FROM Payment p " +
                    "JOIN Student s ON p.studentID = s.studentID " +
                    "JOIN UserAccount u ON s.userID = u.userID " +
                    "JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID " +
                    "JOIN Courses c ON ce.courseID = c.courseID " +
                    "ORDER BY p.paymentDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Payment payment = new Payment();
                payment.setId(rs.getInt("id"));
                payment.setStudentID(rs.getString("studentID"));
                payment.setEnrollmentID(rs.getString("enrollmentID"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setPaymentMethod(rs.getString("paymentMethod"));
                payment.setPaymentStatus(rs.getString("paymentStatus"));
                payment.setPaymentDate(rs.getTimestamp("paymentDate"));
                payment.setTransactionID(rs.getString("transactionID"));
                payment.setStudentName(rs.getString("studentName"));
                payment.setCourseName(rs.getString("courseName"));
                payments.add(payment);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all payments", e);
            throw e;
        }
        return payments;
    }

    public Payment getPaymentById(int id) throws SQLException {
        String sql = "SELECT p.*, u.fullName as studentName, c.title as courseName " +
                    "FROM Payment p " +
                    "JOIN Student s ON p.studentID = s.studentID " +
                    "JOIN UserAccount u ON s.userID = u.userID " +
                    "JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID " +
                    "JOIN Courses c ON ce.courseID = c.courseID " +
                    "WHERE p.id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Payment payment = new Payment();
                    payment.setId(rs.getInt("id"));
                    payment.setStudentID(rs.getString("studentID"));
                    payment.setEnrollmentID(rs.getString("enrollmentID"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentMethod(rs.getString("paymentMethod"));
                    payment.setPaymentStatus(rs.getString("paymentStatus"));
                    payment.setPaymentDate(rs.getTimestamp("paymentDate"));
                    payment.setTransactionID(rs.getString("transactionID"));
                    payment.setStudentName(rs.getString("studentName"));
                    payment.setCourseName(rs.getString("courseName"));
                    return payment;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payment by id", e);
            throw e;
        }
        return null;
    }

    public List<Payment> getPaymentsByStatus(String status) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, c.title as courseName " +
                    "FROM Payment p " +
                    "JOIN Student s ON p.studentID = s.studentID " +
                    "JOIN UserAccount u ON s.userID = u.userID " +
                    "JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID " +
                    "JOIN Courses c ON ce.courseID = c.courseID " +
                    "WHERE p.paymentStatus = ? " +
                    "ORDER BY p.paymentDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment payment = new Payment();
                    payment.setId(rs.getInt("id"));
                    payment.setStudentID(rs.getString("studentID"));
                    payment.setEnrollmentID(rs.getString("enrollmentID"));
                    payment.setAmount(rs.getDouble("amount"));
                    payment.setPaymentMethod(rs.getString("paymentMethod"));
                    payment.setPaymentStatus(rs.getString("paymentStatus"));
                    payment.setPaymentDate(rs.getTimestamp("paymentDate"));
                    payment.setTransactionID(rs.getString("transactionID"));
                    payment.setStudentName(rs.getString("studentName"));
                    payment.setCourseName(rs.getString("courseName"));
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting payments by status", e);
            throw e;
        }
        return payments;
    }

    public void updatePaymentStatus(int paymentId, String status) throws SQLException {
        String sql = "UPDATE Payment SET paymentStatus = ? WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, paymentId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Updating payment status failed, no rows affected.");
            }
            
            LOGGER.info("Payment status updated successfully: " + paymentId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating payment status", e);
            throw e;
        }
    }
}
