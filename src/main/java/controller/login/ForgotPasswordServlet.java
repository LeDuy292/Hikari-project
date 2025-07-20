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

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForgotPasswordServlet.class.getName());
    private final UserService userService = new UserService();
    private static final long OTP_RESEND_COOLDOWN = 60 * 1000; // 60 giây cooldown

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String otp = request.getParameter("otp");
            HttpSession session = request.getSession();

            if (email == null || email.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập email.");
                response.sendRedirect(request.getContextPath() + "/forgot-password-page");
                return;
            }

            email = email.trim();
            session.setAttribute("email", email); // Lưu để dùng lại ở view

            if (otp == null || otp.trim().isEmpty()) {
                // Trường hợp chưa nhập OTP => gửi hoặc resend OTP
                Long lastOtpSent = (Long) session.getAttribute("lastOtpSent");
                long currentTime = System.currentTimeMillis();

                if (lastOtpSent != null && (currentTime - lastOtpSent) < OTP_RESEND_COOLDOWN) {
                    long secondsLeft = (OTP_RESEND_COOLDOWN - (currentTime - lastOtpSent)) / 1000;
                    session.setAttribute("error", "Vui lòng chờ " + secondsLeft + " giây trước khi gửi lại mã OTP.");
                    response.sendRedirect(request.getContextPath() + "/forgot-password-page");
                    return;
                }

                LOGGER.info("Processing forgot password request for email: " + email);
                UserAccount user = userService.findByEmail(email);

                if (user != null) {
                    userService.updateOtp(user); // Ghi đè mã OTP
                    LOGGER.info("Generated OTP: " + user.getOtp() + " for user: " + email);

                    String otpMessage = "Mã OTP của bạn là: " + user.getOtp() + ". Mã có hiệu lực trong 10 phút.";

                    if (EmailUtil.sendResetPasswordEmail(email, otpMessage)) {
                        session.setAttribute("lastOtpSent", currentTime);
                        session.setAttribute("success", "Mã OTP đã được gửi đến " + email + ". Vui lòng kiểm tra email trong 10 phút!");
                    } else {
                        session.setAttribute("error", "Không thể gửi mã OTP. Vui lòng kiểm tra kết nối hoặc thử lại sau.");
                    }
                } else {
                    session.setAttribute("error", "Email không tồn tại trong hệ thống. Vui lòng kiểm tra lại.");
                }

                response.sendRedirect(request.getContextPath() + "/forgot-password-page");
            } else {
                // Trường hợp đã nhập OTP => kiểm tra OTP
                LOGGER.info("Validating OTP: " + otp + " for email: " + email);
                UserAccount user = userService.findByOtp(otp.trim());

                if (user != null && user.getOtp() != null && user.getOtp().equals(otp.trim())) {
                    if (user.getOtpExpiry() != null && user.getOtpExpiry().after(new Date())) {
                        session.setAttribute("resetUserNum", user.getUserID());
                        LOGGER.info("OTP validated successfully for user: " + user.getUserID());
                        response.sendRedirect(request.getContextPath() + "/reset-password-page"); // Trang reset mật khẩu
                        return;
                    } else {
                        session.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng yêu cầu mã mới.");
                    }
                } else {
                    session.setAttribute("error", "Mã OTP không đúng. Vui lòng kiểm tra lại hoặc yêu cầu mã mới.");
                }

                response.sendRedirect(request.getContextPath() + "/forgot-password-page");
            }

        } catch (Exception e) {
            LOGGER.severe("Error in forgot password: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống xảy ra. Vui lòng thử lại sau.");
            response.sendRedirect(request.getContextPath() + "/forgot-password-page");
        }
    }
}
