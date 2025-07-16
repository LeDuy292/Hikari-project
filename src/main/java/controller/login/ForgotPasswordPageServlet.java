package controller.login;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

@WebServlet("/forgot-password-page")
public class ForgotPasswordPageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Lấy thông báo từ session -> đẩy sang request để hiển thị ở JSP
        request.setAttribute("error", session.getAttribute("error"));
        request.setAttribute("success", session.getAttribute("success"));
        request.setAttribute("email", session.getAttribute("email"));

        // Xóa khỏi session sau khi hiển thị
        session.removeAttribute("error");
        session.removeAttribute("success");
        session.removeAttribute("email");

        request.getRequestDispatcher("/view/authentication/forgot-password.jsp").forward(request, response);
    }
}
