package controller.login;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;
import service.UserService;
import utils.EmailUtil;
import java.sql.SQLException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private UserService userService = new UserService();
    private static final long OTP_RESEND_COOLDOWN = 60 * 1000; // 60 seconds

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/view/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String otp = request.getParameter("otp");
            HttpSession session = request.getSession();

            // Lưu email vào request để sử dụng lại
            if (email != null && !email.trim().isEmpty()) {
                request.setAttribute("email", email.trim());
            } else {
                request.setAttribute("error", "Vui lòng nhập email.");
                request.getRequestDispatcher("/view/forgot-password.jsp").forward(request, response);
                return;
            }

            if (otp == null || otp.trim().isEmpty()) {
                // Bước 1: Gửi hoặc resend mã OTP
                Long lastOtpSent = (Long) session.getAttribute("lastOtpSent");
                long currentTime = System.currentTimeMillis();
                if (lastOtpSent != null && (currentTime - lastOtpSent) < OTP_RESEND_COOLDOWN) {
                    request.setAttribute("error", "Vui lòng chờ " + ((OTP_RESEND_COOLDOWN - (currentTime - lastOtpSent)) / 1000) + " giây trước khi gửi lại OTP.");
                    request.getRequestDispatcher("/view/forgot-password.jsp").forward(request, response);
                    return;
                }

                LOGGER.info("Processing forgot password request for email: " + email);
                UserAccount user = userService.findByEmail(email);
                if (user != null) {
                    userService.updateOtp(user); // Tạo mới OTP, ghi đè OTP cũ
                    LOGGER.info("Generated OTP: " + user.getOtp() + " for user: " + email);
                    String otpMessage = "Mã OTP của bạn là: " + user.getOtp() + ". Mã có hiệu lực trong 10 phút.";
                    if (EmailUtil.sendResetPasswordEmail(email, otpMessage)) {
                        session.setAttribute("lastOtpSent", currentTime);
                        String successMessage = "Mã OTP đã được gửi đến " + email + ". Vui lòng kiểm tra email của bạn trong vòng 10 phút!";
                        request.setAttribute("success", successMessage);
                    } else {
                        request.setAttribute("error", "Không thể gửi mã OTP. Vui lòng kiểm tra kết nối hoặc thử lại sau.");
                    }
                } else {
                    request.setAttribute("error", "Email không tồn tại trong hệ thống. Vui lòng kiểm tra lại.");
                }
                request.getRequestDispatcher("/view/forgot-password.jsp").forward(request, response);
            } else {
                // Bước 2: Xác nhận OTP
                LOGGER.info("Validating OTP: " + otp + " for email: " + email);
                UserAccount user = userService.findByOtp(otp.trim());
                if (user != null && user.getOtp() != null && user.getOtp().equals(otp.trim())) {
                    if (user.getOtpExpiry() != null && user.getOtpExpiry().after(new Date())) {
                        // OTP hợp lệ, lưu userID vào session và chuyển đến trang reset mật khẩu
                        // FIX: Store userID as String to maintain consistency
                        session.setAttribute("resetUserNum", user.getUserID());
                        LOGGER.info("OTP validated successfully for user: " + user.getUserID());
                        response.sendRedirect(request.getContextPath() + "/view/reset-password.jsp");
                        return;
                    } else {
                        request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.");
                    }
                } else {
                    request.setAttribute("error", "Mã OTP không đúng. Vui lòng kiểm tra lại hoặc yêu cầu mã mới.");
                }
                request.getRequestDispatcher("/view/forgot-password.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.severe("Error in forgot password: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/view/forgot-password.jsp").forward(request, response);
        }
    }
}
