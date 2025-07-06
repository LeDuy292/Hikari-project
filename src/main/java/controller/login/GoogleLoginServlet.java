package controller.login;

import constant.Constant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class GoogleLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {      
        // Tạo URL để xác thực với Google
    String googleAuthUrl = "https://accounts.google.com/o/oauth2/auth?"
            + "client_id=" + Constant.GOOGLE_CLIENT_ID
            + "&redirect_uri=" + Constant.GOOGLE_REDIRECT_URI
            + "&response_type=code"
            + "&scope=email%20profile";

    // Chuyển hướng người dùng đến trang đăng nhập Google
    response.sendRedirect(googleAuthUrl);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}