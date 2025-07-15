package controller.login;

import java.io.IOException;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserAccount;
import service.UserService;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ResetPasswordServlet.class.getName());
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();

            String userNumParam = request.getParameter("userNum");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            LOGGER.info("Processing password reset for userNum: " + userNumParam);

            // Xác minh userNum trong session
            Object sessionUserNumObj = session.getAttribute("resetUserNum");
            String sessionUserNum = null;
            if (sessionUserNumObj instanceof Integer) {
                sessionUserNum = ((Integer) sessionUserNumObj).toString();
            } else if (sessionUserNumObj instanceof String) {
                sessionUserNum = (String) sessionUserNumObj;
            }

            if (userNumParam == null || sessionUserNum == null || !userNumParam.equals(sessionUserNum)) {
                LOGGER.warning("Invalid or missing session userNum for reset. Expected: " + sessionUserNum + ", Got: " + userNumParam);
                session.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng yêu cầu lại OTP.");
                response.sendRedirect(request.getContextPath() + "/reset-password-page");
                return;
            }

            // Kiểm tra password hợp lệ
            if (newPassword == null || newPassword.trim().isEmpty()) {
                session.setAttribute("error", "Mật khẩu mới không được để trống.");
                response.sendRedirect(request.getContextPath() + "/reset-password-page");
                return;
            }

            if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
                session.setAttribute("error", "Xác nhận mật khẩu không được để trống.");
                response.sendRedirect(request.getContextPath() + "/reset-password-page");
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                LOGGER.warning("Password mismatch for userNum: " + userNumParam);
                session.setAttribute("error", "Mật khẩu xác nhận không khớp.");
                response.sendRedirect(request.getContextPath() + "/reset-password-page");
                return;
            }

            // Cập nhật mật khẩu
            UserAccount user = userService.findByUserNum(userNumParam);
            if (user != null) {
                user.setPassword(newPassword.trim());
                boolean updated = userService.updatePassword(user);

                LOGGER.info("Password update result for userID " + user.getUserID() + ": " + updated);
                if (updated) {
                    session.removeAttribute("resetUserNum");
                    session.setAttribute("success", "Mật khẩu đã được cập nhật thành công. Vui lòng đăng nhập lại!");
                    response.sendRedirect(request.getContextPath() + "/loginPage");
                } else {
                    session.setAttribute("error", "Cập nhật mật khẩu thất bại. Vui lòng thử lại.");
                    response.sendRedirect(request.getContextPath() + "/reset-password-page");
                }
            } else {
                LOGGER.warning("No user found for userID: " + userNumParam);
                session.setAttribute("error", "Tài khoản không tồn tại. Vui lòng yêu cầu lại OTP.");
                response.sendRedirect(request.getContextPath() + "/reset-password-page");
            }

        } catch (Exception e) {
            LOGGER.severe("Exception in reset-password POST: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/reset-password-page");
        }
    }
}
