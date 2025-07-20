package controller.login;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/reset-password-page")
public class ResetPasswordPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Kiểm tra nếu không có resetUserNum trong session thì về forgot-password
        if (session.getAttribute("resetUserNum") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password-page");
            return;
        }

        // Lấy dữ liệu từ session sang request
        request.setAttribute("error", session.getAttribute("error"));
        request.setAttribute("success", session.getAttribute("success"));
        request.setAttribute("userNum", session.getAttribute("resetUserNum"));

        // Xóa khỏi session sau khi lấy
        session.removeAttribute("error");
        session.removeAttribute("success");

        request.getRequestDispatcher("/view/authentication/reset-password.jsp").forward(request, response);
    }
}
