package controller.shopping;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.UserAccount;
import model.admin.PaymentDTO; // **CHANGED**: Use PaymentDTO instead of Payment
import dao.PaymentDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import utils.DBContext;

@WebServlet("/profile/paymentHistory")
public class ProfileMyPaymentServlet extends HttpServlet {
    private static final Logger LOGGER = LoggerFactory.getLogger(ProfileMyPaymentServlet.class);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserAccount user = (UserAccount) request.getSession().getAttribute("user");
        if (user == null) {
            LOGGER.warn("Phiên làm việc hết hạn, chuyển hướng đến trang đăng nhập");
            response.sendRedirect(request.getContextPath() + "/loginPage?error=Phiên+làm+việc+hết+hạn");
            return;
        }

        PaymentDAO paymentDAO = new PaymentDAO();
        List<PaymentDTO> payments = new ArrayList<>(); // **CHANGED**: Use PaymentDTO
        String studentID = null;

        try {
            // Lấy studentID của người dùng hiện tại từ database
            studentID = getStudentID(user.getUserID());
            if (studentID == null) {
                LOGGER.warn("Không tìm thấy studentID cho userID: {}", user.getUserID());
                request.setAttribute("error", "Bạn chưa được liên kết với tài khoản học viên.");
                request.getRequestDispatcher("/view/student/paymentHistory.jsp").forward(request, response);
                return;
            }

            // Sử dụng method đơn giản để lấy tất cả payments của student
            payments = paymentDAO.getPaymentsByStudentId(studentID);

            LOGGER.debug("Đã lấy được {} thanh toán cho studentID: {}", payments.size(), studentID);

            // Tính tổng số tiền đã chi từ dữ liệu lấy được
            double totalSpent = payments.stream()
                    .filter(p -> "Complete".equalsIgnoreCase(p.getPaymentStatus()))
                    .mapToDouble(PaymentDTO::getAmount) // **CHANGED**: Use PaymentDTO method
                    .sum();

            // Đưa dữ liệu vào request
            request.setAttribute("payments", payments);
            request.setAttribute("totalSpent", totalSpent);

            request.getRequestDispatcher("/view/student/paymentHistory.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.error("Lỗi SQL khi xử lý thanh toán cho userID: {}, chi tiết: {}", user.getUserID(), e.getMessage(), e);
            request.setAttribute("error", "Lỗi khi truy vấn cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/view/student/paymentHistory.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.error("Lỗi không xác định trong ProfileMyPaymentServlet cho userID: {}, chi tiết: {}", user.getUserID(), e.getMessage(), e);
            request.setAttribute("error", "Lỗi server: Vui lòng thử lại sau.");
            request.getRequestDispatcher("/view/student/paymentHistory.jsp").forward(request, response);
        }
    }

    private String getStudentID(String userID) throws SQLException {
        String sql = "SELECT studentID FROM Student WHERE userID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("studentID");
                }
            }
            LOGGER.debug("Không tìm thấy studentID cho userID: {}", userID);
            return null;
        } catch (SQLException e) {
            LOGGER.error("Lỗi khi lấy studentID cho userID: {}, chi tiết: {}", userID, e.getMessage(), e);
            throw e;
        }
    }
}


