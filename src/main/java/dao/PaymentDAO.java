package dao;

import model.admin.Payment;
import model.admin.PaymentDTO;
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

    public List<PaymentDTO> getAllPayments() throws SQLException {
        List<PaymentDTO> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, GROUP_CONCAT(c.title) as courseNames "
                + "FROM Payment p "
                + "JOIN Student s ON p.studentID = s.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "GROUP BY p.id "
                + "ORDER BY p.paymentDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                payments.add(mapResultSetToPaymentDTO(rs));
            }
            LOGGER.debug("Retrieved {} payments from getAllPayments", payments.size());
        } catch (SQLException e) {
            LOGGER.error("Error getting all payments", e);
            throw e;
        }
        return payments;
    }

    public PaymentDTO getPaymentById(int id) throws SQLException {
        String sql = "SELECT p.*, u.fullName as studentName, GROUP_CONCAT(c.title) as courseNames "
                + "FROM Payment p "
                + "JOIN Student s ON p.studentID = s.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "WHERE p.id = ? "
                + "GROUP BY p.id";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPaymentDTO(rs);
                }
            }
            LOGGER.debug("No payment found for id: {}", id);
        } catch (SQLException e) {
            LOGGER.error("Error getting payment by id {}", id, e);
            throw e;
        }
        return null;
    }

    public List<PaymentDTO> getPaymentsByStatus(String status) throws SQLException {
        List<PaymentDTO> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, GROUP_CONCAT(c.title) as courseNames "
                + "FROM Payment p "
                + "JOIN Student s ON p.studentID = s.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "WHERE p.paymentStatus = ? "
                + "GROUP BY p.id "
                + "ORDER BY p.paymentDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPaymentDTO(rs));
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

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    public List<PaymentDTO> getPaymentsByStudentId(String studentID) throws SQLException {
        List<PaymentDTO> payments = new ArrayList<>();
        String sql = "SELECT p.*, u.fullName as studentName, GROUP_CONCAT(c.title) as courseNames "
                + "FROM Payment p "
                + "JOIN Student s ON p.studentID = s.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "WHERE p.studentID = ? "
                + "GROUP BY p.id "
                + "ORDER BY p.paymentDate DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, studentID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPaymentDTO(rs));
                }
            }
            LOGGER.debug("Retrieved {} payments for studentID: {}", payments.size(), studentID);
        } catch (SQLException e) {
            LOGGER.error("Error getting payments by studentID {}", studentID, e);
            throw e;
        }
        return payments;
    }

    public List<PaymentDTO> getPaymentsWithFilters(String status, String studentID, String date,
            double minAmount, double maxAmount, String sortBy, int offset, int limit) throws SQLException {
        List<PaymentDTO> payments = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, u.fullName as studentName, GROUP_CONCAT(c.title) as courseNames "
                + "FROM Payment p "
                + "JOIN Student s ON p.studentID = s.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "WHERE p.studentID = ?"
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

        sql.append(" GROUP BY p.id");

        if (sortBy != null && !sortBy.trim().isEmpty()) {
            String[] sortParts = sortBy.split("_");
            String column = sortParts[0];
            String direction = sortParts.length > 1 ? sortParts[1] : "ASC";
            String sortColumn;
            switch (column) {
                case "id":
                    sortColumn = "p.id";
                    break;
                case "amount":
                    sortColumn = "p.amount";
                    break;
                case "date":
                    sortColumn = "p.paymentDate";
                    break;
                default:
                    sortColumn = "p.paymentDate";
                    direction = "DESC";
            }
            sql.append(" ORDER BY ").append(sortColumn).append(" ").append(direction);
        } else {
            sql.append(" ORDER BY p.paymentDate DESC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPaymentDTO(rs));
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
                "SELECT COUNT(DISTINCT p.id) "
                + "FROM Payment p "
                + "JOIN Student s ON p.studentID = s.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "WHERE p.studentID = ?"
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

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
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

    public boolean savePayment(Payment payment, Connection conn) throws SQLException {
        String sqlPayment = "INSERT INTO Payment (cartID, studentID, amount, paymentMethod, paymentStatus, paymentDate, transactionID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlPaymentCourses = "INSERT INTO Payment_Courses (paymentID, courseID) VALUES (?, ?)";

        boolean paymentSaved = false;
        try (PreparedStatement stmtPayment = conn.prepareStatement(sqlPayment, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmtPayment.setInt(1, payment.getCartID());
            stmtPayment.setString(2, payment.getStudentID());
            stmtPayment.setDouble(3, payment.getAmount());
            stmtPayment.setString(4, payment.getPaymentMethod());
            stmtPayment.setString(5, payment.getPaymentStatus());
            stmtPayment.setTimestamp(6, (Timestamp) payment.getPaymentDate());
            stmtPayment.setString(7, payment.getTransactionID());

            int affectedRows = stmtPayment.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmtPayment.getGeneratedKeys()) {
                    if (rs.next()) {
                        int paymentID = rs.getInt(1);
                        payment.setId(paymentID);

                        try (PreparedStatement stmtCourses = conn.prepareStatement(sqlPaymentCourses)) {
                            for (String courseID : payment.getCourseIDs()) {
                                stmtCourses.setInt(1, paymentID);
                                stmtCourses.setString(2, courseID);
                                stmtCourses.addBatch();
                            }
                            int[] batchResults = stmtCourses.executeBatch();
                            for (int result : batchResults) {
                                if (result == PreparedStatement.EXECUTE_FAILED) {
                                    throw new SQLException("Failed to save courses for payment.");
                                }
                            }
                        }
                        paymentSaved = true;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.error("Error saving payment for studentID {}: {}", payment.getStudentID(), e.getMessage(), e);
            throw e;
        }
        return paymentSaved;
    }

    private void savePaymentCourses(Connection conn, int paymentId, List<String> courseIDs) throws SQLException {
        String sql = "INSERT INTO Payment_Courses (paymentID, courseID) VALUES (?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (String courseID : courseIDs) {
                stmt.setInt(1, paymentId);
                stmt.setString(2, courseID);
                stmt.addBatch();
            }
            stmt.executeBatch();
            LOGGER.debug("Saved {} course IDs for paymentID: {}", courseIDs.size(), paymentId);
        }
    }

    public boolean deletePayment(int id) throws SQLException {
        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            String deleteCoursesSql = "DELETE FROM Payment_Courses WHERE paymentID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteCoursesSql)) {
                stmt.setInt(1, id);
                stmt.executeUpdate();
            }

            String deletePaymentSql = "DELETE FROM Payment WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deletePaymentSql)) {
                stmt.setInt(1, id);
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    conn.commit();
                    LOGGER.info("Payment deleted successfully for id: {}", id);
                    return true;
                } else {
                    conn.rollback();
                    LOGGER.warn("No payment found to delete for id: {}", id);
                    return false;
                }
            }
        } catch (SQLException e) {
            LOGGER.error("Error deleting payment for id {}", id, e);
            throw e;
        }
    }

    public boolean updatePayment(Payment payment, Connection conn) throws SQLException {
        String sql = "UPDATE Payment SET studentID = ?, amount = ?, paymentMethod = ?, paymentStatus = ?, paymentDate = ?, transactionID = ?, cartID = ? WHERE id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, payment.getStudentID());
            stmt.setDouble(2, payment.getAmount());
            stmt.setString(3, payment.getPaymentMethod());
            stmt.setString(4, payment.getPaymentStatus());
            stmt.setTimestamp(5, new Timestamp(payment.getPaymentDate().getTime()));
            stmt.setString(6, payment.getTransactionID());
            stmt.setObject(7, payment.getCartID(), Types.INTEGER);
            stmt.setInt(8, payment.getId());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                LOGGER.warn("No payment found to update for id: {}", payment.getId());
                return false;
            }
        }

        String deleteCoursesSql = "DELETE FROM Payment_Courses WHERE paymentID = ?";
        try (PreparedStatement stmt = conn.prepareStatement(deleteCoursesSql)) {
            stmt.setInt(1, payment.getId());
            stmt.executeUpdate();
        }
        if (!payment.getCourseIDs().isEmpty()) {
            savePaymentCourses(conn, payment.getId(), payment.getCourseIDs());
        }

        LOGGER.info("Payment updated successfully for id: {}", payment.getId());
        return true;
    }

    public double getTotalAmountByFilters(String status, String studentID, String date, double minAmount, double maxAmount) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COALESCE(SUM(p.amount), 0) "
                + "FROM Payment p "
                + "JOIN Student s ON p.studentID = s.studentID "
                + "JOIN UserAccount u ON s.userID = u.userID "
                + "LEFT JOIN Payment_Courses pc ON p.id = pc.paymentID "
                + "LEFT JOIN Courses c ON pc.courseID = c.courseID "
                + "WHERE p.studentID = ?"
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

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
            LOGGER.debug("Calculated total amount with filters, SQL: {}", sql.toString());
        } catch (SQLException e) {
            LOGGER.error("Error calculating total amount with filters", e);
            throw e;
        }
        return 0.0;
    }

    public void closeConnection() {
        if (dbContext != null) {
            dbContext.closeConnection();
            LOGGER.info("Connection closed in PaymentDAO.");
        }
    }

    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setId(rs.getInt("id"));
        payment.setStudentID(rs.getString("studentID"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setPaymentMethod(rs.getString("paymentMethod"));
        payment.setPaymentStatus(rs.getString("paymentStatus"));
        payment.setPaymentDate(rs.getTimestamp("paymentDate"));
        payment.setTransactionID(rs.getString("transactionID"));
        payment.setCartID(rs.getInt("cartID") == 0 ? null : rs.getInt("cartID"));
        payment.setCourseIDs(new ArrayList<>());
        return payment;
    }

    private PaymentDTO mapResultSetToPaymentDTO(ResultSet rs) throws SQLException {
        PaymentDTO payment = new PaymentDTO();
        payment.setId(rs.getInt("id"));
        payment.setStudentID(rs.getString("studentID"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setPaymentMethod(rs.getString("paymentMethod"));
        payment.setPaymentStatus(rs.getString("paymentStatus"));
        payment.setPaymentDate(rs.getTimestamp("paymentDate"));
        payment.setTransactionID(rs.getString("transactionID"));
        payment.setStudentName(rs.getString("studentName"));
        payment.setCourseNames(rs.getString("courseNames"));
        payment.setCartID(rs.getInt("cartID") == 0 ? null : rs.getInt("cartID"));
        payment.setCourseIDs(new ArrayList<>());
        return payment;
    }

    private List<String> getCourseIDsForPayment(int paymentId) throws SQLException {
        List<String> courseIDs = new ArrayList<>();
        String sql = "SELECT courseID FROM Payment_Courses WHERE paymentID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, paymentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    courseIDs.add(rs.getString("courseID"));
                }
            }
        }
        return courseIDs;
    }
}

