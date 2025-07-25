package service;

import dao.admin.PaymentDAO;
import model.admin.PaymentDTO; // **CHANGED**: Use PaymentDTO
import java.sql.SQLException;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PaymentService {
    private static final Logger LOGGER = LoggerFactory.getLogger(PaymentService.class);
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public List<PaymentDTO> getAllPayments() throws SQLException { // **CHANGED**: Return PaymentDTO
        try {
            List<PaymentDTO> payments = paymentDAO.getAllPayments(); // **CHANGED**: Use PaymentDTO
            LOGGER.info("Retrieved {} payments", payments.size());
            return payments;
        } catch (SQLException e) {
            LOGGER.error("Error getting all payments", e);
            throw e;
        }
    }

    public PaymentDTO getPaymentById(int id) throws SQLException { // **CHANGED**: Return PaymentDTO
        if (id <= 0) {
            throw new IllegalArgumentException("ID thanh toán không hợp lệ");
        }
        try {
            PaymentDTO payment = paymentDAO.getPaymentById(id); // **CHANGED**: Use PaymentDTO
            if (payment == null) {
                LOGGER.warn("No payment found for id: {}", id);
            }
            return payment;
        } catch (SQLException e) {
            LOGGER.error("Error getting payment by id {}", id, e);
            throw e;
        }
    }

    public List<PaymentDTO> getPaymentsByStatus(String status) throws SQLException { // **CHANGED**: Return PaymentDTO
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Trạng thái thanh toán không hợp lệ");
        }
        try {
            List<PaymentDTO> payments = paymentDAO.getPaymentsByStatus(status); // **CHANGED**: Use PaymentDTO
            LOGGER.info("Retrieved {} payments with status: {}", payments.size(), status);
            return payments;
        } catch (SQLException e) {
            LOGGER.error("Error getting payments by status {}", status, e);
            throw e;
        }
    }

    public void updatePaymentStatus(int paymentId, String status) throws SQLException {
        if (paymentId <= 0) {
            throw new IllegalArgumentException("ID thanh toán không hợp lệ");
        }
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Trạng thái thanh toán không hợp lệ");
        }
        if (!isValidPaymentStatus(status)) {
            throw new IllegalArgumentException("Trạng thái thanh toán không được hỗ trợ");
        }
        try {
            paymentDAO.updatePaymentStatus(paymentId, status);
            LOGGER.info("Updated payment status for paymentId: {}", paymentId);
        } catch (SQLException e) {
            LOGGER.error("Error updating payment status for id {}", paymentId, e);
            throw e;
        }
    }

    public List<PaymentDTO> getPaymentsByStudentId(String studentID) throws SQLException { // **CHANGED**: Return PaymentDTO
        if (studentID == null || studentID.trim().isEmpty()) {
            LOGGER.error("Invalid studentID: {}", studentID);
            throw new IllegalArgumentException("StudentID không hợp lệ");
        }
        try {
            List<PaymentDTO> payments = paymentDAO.getPaymentsByStudentId(studentID); // **CHANGED**: Use PaymentDTO
            payments.removeIf(p -> !"Complete".equalsIgnoreCase(p.getPaymentStatus()));
            LOGGER.info("Retrieved {} 'Complete' payments for studentID: {} (total fetched: {})", 
                       payments.size(), studentID, paymentDAO.getPaymentsByStudentId(studentID).size());
            return payments;
        } catch (SQLException e) {
            LOGGER.error("Error retrieving payments for studentID {}", studentID, e);
            throw e;
        }
    }

    public List<PaymentDTO> getPaymentsWithFilters(String status, String search, String date, String minAmountStr, 
                                                  String maxAmountStr, String sortBy, int page, int pageSize) throws SQLException { // **CHANGED**: Return PaymentDTO
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 9;
        int offset = (page - 1) * pageSize;
        double minAmount = parseDoubleOrDefault(minAmountStr, 0.0);
        double maxAmount = parseDoubleOrDefault(maxAmountStr, Double.MAX_VALUE);
        try {
            List<PaymentDTO> payments = paymentDAO.getPaymentsWithFilters(status, search, date, minAmount, maxAmount, sortBy, offset, pageSize); // **CHANGED**: Use PaymentDTO
            LOGGER.info("Retrieved {} payments with filters, page: {}, pageSize: {}", payments.size(), page, pageSize);
            return payments;
        } catch (SQLException e) {
            LOGGER.error("Error getting payments with filters", e);
            throw e;
        }
    }

    public int countPaymentsWithFilters(String status, String search, String date, String minAmountStr, String maxAmountStr) throws SQLException {
        double minAmount = parseDoubleOrDefault(minAmountStr, 0.0);
        double maxAmount = parseDoubleOrDefault(maxAmountStr, Double.MAX_VALUE);
        try {
            int count = paymentDAO.countPaymentsWithFilters(status, search, date, minAmount, maxAmount);
            LOGGER.info("Counted {} payments with filters", count);
            return count;
        } catch (SQLException e) {
            LOGGER.error("Error counting payments with filters", e);
            throw e;
        }
    }

    private boolean isValidPaymentStatus(String status) {
        return "Complete".equals(status) || "Pending".equals(status) || "Cancel".equals(status);
    }

    private double parseDoubleOrDefault(String value, double defaultValue) {
        try {
            return value != null && !value.trim().isEmpty() ? Double.parseDouble(value) : defaultValue;
        } catch (NumberFormatException e) {
            LOGGER.warn("Invalid number format: {}", value, e);
            return defaultValue;
        }
    }
}