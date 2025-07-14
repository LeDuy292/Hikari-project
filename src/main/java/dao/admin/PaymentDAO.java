package dao.admin;

import model.admin.Payment;
import utils.DBContext;
import java.sql.*;
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
            while (rs.next()) {
                Payment payment = mapResultSetToPayment(rs);
                payments.add(payment);
            }
            LOGGER.debug("Retrieved {} payments from getAllPayments", payments.size());
        } catch (SQLException e) {
            LOGGER.error("Error getting all payments", e);
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
                    return mapResultSetToPayment(rs);
                }
            }
            LOGGER.debug("No payment found for id: {}", id);
        } catch (SQLException e) {
            LOGGER.error("Error getting payment by id {}", id, e);
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
                    Payment payment = mapResultSetToPayment(rs);
                    payments.add(payment);
                }
            }
            LOGGER.debug("Retrieved {} payments with status: {}", payments.size(), status);
        } catch (SQLException e) {
            LOGGER.error("Error getting payments by status {}", status, e);
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
            LOGGER.info("Payment status updated successfully for id: {}", paymentId);
        } catch (SQLException e) {
            LOGGER.error("Error updating payment status for id {}", paymentId, e);
            throw e;
        }
    }

    public List<Payment> getPaymentsByStudentId(String studentID) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, c.title as courseName " +
                    "FROM Payment p " +
                    "JOIN Student s ON p.studentID = s.studentID " +
                    "JOIN UserAccount u ON s.userID = u.userID " +
                    "JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID " +
                    "JOIN Courses c ON ce.courseID = c.courseID " +
                    "WHERE p.studentID = ? " +
                    "ORDER BY p.paymentDate DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Payment payment = mapResultSetToPayment(rs);
                    payments.add(payment);
                }
            }
            LOGGER.debug("Retrieved {} payments for studentID: {}", payments.size(), studentID);
        } catch (SQLException e) {
            LOGGER.error("Error getting payments by studentID {}", studentID, e);
            throw e;
        }
        return payments;
    }

    public List<Payment> getPaymentsWithFilters(String status, String studentID, String date, 
            double minAmount, double maxAmount, String sortBy, int offset, int limit) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, u.fullName as studentName, c.title as courseName " +
            "FROM Payment p " +
            "JOIN Student s ON p.studentID = s.studentID " +
            "JOIN UserAccount u ON s.userID = u.userID " +
            "JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID " +
            "JOIN Courses c ON ce.courseID = c.courseID " +
            "WHERE p.studentID = ?"
        );
        List<Object> params = new ArrayList<>();
        params.add(studentID);

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND p.paymentStatus = ?");
            params.add(status.trim());
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append(" AND DATE(p.paymentDate) = ?");
            params.add(date);
        }

        sql.append(" AND p.amount BETWEEN ? AND ?");
        params.add(minAmount);
        params.add(maxAmount);

        if (sortBy != null && !sortBy.trim().isEmpty()) {
            String[] sortParts = sortBy.split("_");
            String column = sortParts[0];
            String direction = sortParts.length > 1 ? sortParts[1] : "ASC";
            String sortColumn;
            switch (column) {
                case "id": sortColumn = "p.id"; break;
                case "amount": sortColumn = "p.amount"; break;
                case "date": sortColumn = "p.paymentDate"; break;
                default: sortColumn = "p.paymentDate"; direction = "DESC";
            }
            sql.append(" ORDER BY ").append(sortColumn).append(" ").append(direction);
        } else {
            sql.append(" ORDER BY p.paymentDate DESC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
            LOGGER.debug("Retrieved {} payments with filters, SQL: {}", payments.size(), sql.toString());
        } catch (SQLException e) {
            LOGGER.error("Error getting payments with filters", e);
            throw e;
        }
        return payments;
    }

    public int countPaymentsWithFilters(String status, String studentID, String date, double minAmount, double maxAmount) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) " +
            "FROM Payment p " +
            "JOIN Student s ON p.studentID = s.studentID " +
            "JOIN UserAccount u ON s.userID = u.userID " +
            "JOIN Course_Enrollments ce ON p.enrollmentID = ce.enrollmentID " +
            "JOIN Courses c ON ce.courseID = c.courseID " +
            "WHERE p.studentID = ?"
        );
        List<Object> params = new ArrayList<>();
        params.add(studentID);

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND p.paymentStatus = ?");
            params.add(status.trim());
        }

        if (date != null && !date.trim().isEmpty()) {
            sql.append(" AND DATE(p.paymentDate) = ?");
            params.add(date);
        }

        sql.append(" AND p.amount BETWEEN ? AND ?");
        params.add(minAmount);
        params.add(maxAmount);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            LOGGER.debug("Counted payments with filters, SQL: {}", sql.toString());
        } catch (SQLException e) {
            LOGGER.error("Error counting payments with filters", e);
            throw e;
        }
        return 0;
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