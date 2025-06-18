package controller.login;

import java.io.IOException;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;
import service.UserService;
import java.sql.SQLException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ResetPasswordServlet.class.getName());
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("resetUserNum") == null) {
            response.sendRedirect(request.getContextPath() + "/view/forgot-password.jsp");
            return;
        }
        request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String userNumStr = request.getParameter("userNum");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            LOGGER.info("Processing password reset for userNum: " + userNumStr);

            if (userNumStr == null || userNumStr.isEmpty()) {
                LOGGER.warning("No userNum provided in POST request");
                request.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng yêu cầu lại OTP.");
                request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
                return;
            }

            Integer sessionUserNum = (Integer) session.getAttribute("resetUserNum");
            if (sessionUserNum == null || !userNumStr.equals(sessionUserNum.toString())) {
                LOGGER.warning("Invalid or missing session userNum for reset");
                request.setAttribute("error", "Phiên đặt lại mật khẩu không hợp lệ. Vui lòng yêu cầu lại OTP.");
                request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                LOGGER.warning("Password mismatch for userNum: " + userNumStr);
                request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
                request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
                return;
            }

            int userNum;
            try {
                userNum = Integer.parseInt(userNumStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid userNum format: " + userNumStr);
                request.setAttribute("error", "Dữ liệu không hợp lệ. Vui lòng thử lại.");
                request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
                return;
            }

            UserAccount user = userService.findByUserNum(userNum); // Sửa lỗi đánh máy
            if (user != null) {
                user.setPassword(newPassword); // Store plaintext directly
                boolean updated = userService.updatePassword(user);
                LOGGER.info("Password update result for userNum " + user.getUserNum() + ": " + updated);
                if (updated) {
                    session.removeAttribute("resetUserNum"); // Clear session
                    request.setAttribute("success", "Mật khẩu đã được cập nhật thành công. Vui lòng đăng nhập lại!");
                    request.getRequestDispatcher("/view/login.jsp?formType=login").forward(request, response);
                } else {
                    LOGGER.warning("Password update failed for userNum: " + userNumStr);
                    request.setAttribute("error", "Cập nhật mật khẩu thất bại. Vui lòng thử lại.");
                    request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
                }
            } else {
                LOGGER.warning("No user found for userNum: " + userNumStr);
                request.setAttribute("error", "Tài khoản không tồn tại. Vui lòng yêu cầu lại OTP.");
                request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.severe("Database error in reset password: " + e.getMessage());
            request.setAttribute("error", "Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.severe("Exception in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/reset-password.jsp").forward(request, response);
        }
    }
}