package service;

import dao.admin.PaymentDAO;
import model.admin.Payment;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

public class PaymentService {
    private static final Logger LOGGER = Logger.getLogger(PaymentService.class.getName());
    private final PaymentDAO paymentDAO = new PaymentDAO();

    public List<Payment> getAllPayments() throws SQLException {
        return paymentDAO.getAllPayments();
    }

    public Payment getPaymentById(int id) throws SQLException {
        if (id <= 0) {
            throw new IllegalArgumentException("ID thanh toán không hợp lệ");
        }
        return paymentDAO.getPaymentById(id);
    }

    public List<Payment> getPaymentsByStatus(String status) throws SQLException {
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Trạng thái thanh toán không hợp lệ");
        }
        return paymentDAO.getPaymentsByStatus(status);
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
        paymentDAO.updatePaymentStatus(paymentId, status);
    }

    private boolean isValidPaymentStatus(String status) {
        return "Complete".equals(status) || "Pending".equals(status) || "Cancel".equals(status);
    }
}
