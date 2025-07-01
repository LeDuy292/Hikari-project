
package dao.admin;

import model.admin.Payment;
import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PaymentDAO {
    private static final Logger LOGGER = LoggerFactory.getLogger(PaymentDAO.class);
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
            if (conn == null) {
                throw new SQLException("Failed to establish database connection");
            }
            while (rs.next()) {
                payments.add(mapResultSetToPayment(rs));
            }
            LOGGER.debug("Retrieved {} payments.", payments.size());
        } catch (SQLException e) {
            LOGGER.error("Error getting all payments: {}", e.getMessage(), e);
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
            if (conn == null) {
                throw new SQLException("Failed to establish database connection");
            }
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
                LOGGER.warn("No payment found for ID: {}", id);
            }
        } catch (SQLException e) {
            LOGGER.error("Error getting payment by ID {}: {}", id, e.getMessage(), e);
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
            if (conn == null) {
                throw new SQLException("Failed to establish database connection");
            }
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
            LOGGER.debug("Retrieved {} payments with status '{}'.", payments.size(), status);
        } catch (SQLException e) {
            LOGGER.error("Error getting payments by status '{}': {}", status, e.getMessage(), e);
            throw e;
        }
        return payments;
    }

    public void updatePaymentStatus(int paymentId, String status) throws SQLException {
        String sql = "UPDATE Payment SET paymentStatus = ? WHERE id = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (conn == null) {
                throw new SQLException("Failed to establish database connection");
            }
            stmt.setString(1, status);
            stmt.setInt(2, paymentId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                LOGGER.warn("Updating payment status failed, no rows affected for ID: {}", paymentId);
                throw new SQLException("Updating payment status failed, no rows affected.");
            }
            
            LOGGER.info("Payment status updated successfully for ID: {}", paymentId);
        } catch (SQLException e) {
            LOGGER.error("Error updating payment status for ID {}: {}", paymentId, e.getMessage(), e);
            throw e;
        }
    }

    public List<Payment> getPaymentsByUserID(String userID) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, c.title as courseName " +
                     "FROM Payment p " +
                     "JOIN Student s ON p.studentID = s.studentID " +
                     "JOIN UserAccount u ON s.userID = u.userID " +
                     "JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID " +
                     "JOIN Courses c ON ce.courseID = c.courseID " +
                     "WHERE u.userID = ? " +
                     "ORDER BY p.paymentDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (conn == null) {
                throw new SQLException("Failed to establish database connection");
            }
            stmt.setString(1, userID);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
            LOGGER.debug("Retrieved {} payments for userID '{}'.", payments.size(), userID);
        } catch (SQLException e) {
            LOGGER.error("Error getting payments by userID '{}': {}", userID, e.getMessage(), e);
            throw e;
        }
        return payments;
    }

    public void closeConnection() {
        dbContext.closeConnection();
        LOGGER.info("PaymentDAO: Database connection closed via DBContext.");
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
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
