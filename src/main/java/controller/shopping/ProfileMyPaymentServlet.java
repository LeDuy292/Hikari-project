package controller.shopping;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.UserAccount;
import model.admin.PaymentDTO; // **CHANGED**: Use PaymentDTO instead of Payment
import dao.admin.PaymentDAO;
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
        int pageSize = 10;
        int currentPage = 1;
        int totalPayments = 0;
        int totalPages = 1;
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

            // Lấy các tham số lọc
            String status = request.getParameter("status");
            String date = request.getParameter("date");
            String minAmountStr = request.getParameter("minAmount");
            String maxAmountStr = request.getParameter("maxAmount");
            String sortBy = request.getParameter("sortBy");
            String pageParam = request.getParameter("page");

            // Xử lý tham số trang
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    LOGGER.warn("Tham số page không hợp lệ: {}, sử dụng mặc định: 1", pageParam);
                    currentPage = 1;
                }
            }

            // Xử lý tham số số tiền với giá trị mặc định hợp lệ
            double minAmount = 0.0;
            double maxAmount = Double.MAX_VALUE;
            try {
                if (minAmountStr != null && !minAmountStr.trim().isEmpty()) {
                    minAmount = Double.parseDouble(minAmountStr);
                    if (minAmount < 0) throw new NumberFormatException("Số tiền tối thiểu không được âm");
                }
                if (maxAmountStr != null && !maxAmountStr.trim().isEmpty()) {
                    maxAmount = Double.parseDouble(maxAmountStr);
                    if (maxAmount < 0) throw new NumberFormatException("Số tiền tối đa không được âm");
                }
                if (minAmount > maxAmount) {
                    throw new NumberFormatException("Số tiền tối thiểu không được lớn hơn số tiền tối đa");
                }
            } catch (NumberFormatException e) {
                LOGGER.error("Lỗi định dạng số cho tham số minAmount hoặc maxAmount: {}", e.getMessage(), e);
                request.setAttribute("error", "Số tiền tối thiểu hoặc tối đa không hợp lệ: " + e.getMessage());
                request.getRequestDispatcher("/view/student/paymentHistory.jsp").forward(request, response);
                return;
            }

            // Thiết lập mặc định cho sortBy
            if (sortBy == null || sortBy.isEmpty()) {
                sortBy = "date_DESC";
            }

            // Tính offset cho phân trang
            int offset = (currentPage - 1) * pageSize;

            // Lấy danh sách thanh toán từ database
            payments = paymentDAO.getPaymentsWithFilters(status, studentID, date, minAmount, maxAmount, sortBy, offset, pageSize);
            totalPayments = paymentDAO.countPaymentsWithFilters(status, studentID, date, minAmount, maxAmount);
            totalPages = (int) Math.ceil((double) totalPayments / pageSize);

            LOGGER.debug("Đã lấy được {} thanh toán cho studentID: {}", payments.size(), studentID);

            // Tính tổng số tiền đã chi từ dữ liệu lấy được
            double totalSpent = payments.stream()
                    .filter(p -> "Complete".equalsIgnoreCase(p.getPaymentStatus()))
                    .mapToDouble(PaymentDTO::getAmount) // **CHANGED**: Use PaymentDTO method
                    .sum();

            // Đưa dữ liệu vào request
            request.setAttribute("payments", payments);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPayments", totalPayments);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("status", status);
            request.setAttribute("date", date);
            request.setAttribute("minAmount", minAmountStr);
            request.setAttribute("maxAmount", maxAmountStr);
            request.setAttribute("sortBy", sortBy);
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