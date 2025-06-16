package controller.login;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserAccount;
import service.UserService;
import utils.ValidationUtil;
import authentication.SessionManager;
import dao.UserDAO;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserService userService = new UserService();
    private SessionManager sessionManager = new SessionManager();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
//            UserDAO dao = new UserDAO();
            String action = request.getParameter("action");
            if ("login".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                UserAccount user = userService.login(username, password);
                if (user != null) {
                    HttpSession session = request.getSession();
                    try {
                        sessionManager.updateSession(user, session);
                        session.setAttribute("user", user);
                        if(user.getRole().equals("Teacher")){
                             response.sendRedirect(request.getContextPath() + "/view/teacher/manageCourse.jsp");
                        }
                        else if(user.getRole().equals("Student")){
                            response.sendRedirect(request.getContextPath() + "/view/student/home.jsp");
                        }
                    } catch (Exception e) {
                        session.invalidate();
                        request.setAttribute("error", "Lỗi đăng nhập: " + e.getMessage());
                        request.getRequestDispatcher("/view/login.jsp").forward(request, response);
                    }
                } else {
                    request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng.");
                    request.getRequestDispatcher("/view/login.jsp").forward(request, response);
                }
            } else if ("signup".equals(action)) {
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String confirmPassword = request.getParameter("confirmPassword");

                if (!ValidationUtil.isValidEmail(email)) {
                    request.setAttribute("error", "Email không hợp lệ. Vui lòng kiểm tra lại.");
                    request.getRequestDispatcher("/view/login.jsp?formType=signup").forward(request, response);
                    return;
                }
                if (!ValidationUtil.isValidUsername(username)) {
                    request.setAttribute("error", "Tên đăng nhập phải dài 3-20 ký tự và chỉ chứa chữ cái/số.");
                    request.getRequestDispatcher("/view/login.jsp?formType=signup").forward(request, response);
                    return;
                }
                if (!ValidationUtil.isValidPassword(password)) {
                    request.setAttribute("error", "Mật khẩu phải dài 6-50 ký tự và chứa ít nhất một chữ và một số.");
                    request.getRequestDispatcher("/view/login.jsp?formType=signup").forward(request, response);
                    return;
                }
                if (!password.equals(confirmPassword)) {
                    request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
                    request.getRequestDispatcher("/view/login.jsp?formType=signup").forward(request, response);
                    return;
                }

                if (userService.isEmailExists(email)) {
                    request.setAttribute("error", "Email đã tồn tại. Vui lòng chọn email khác.");
                    request.getRequestDispatcher("/view/login.jsp?formType=signup").forward(request, response);
                    return;
                }

                UserAccount newUser = new UserAccount();
                newUser.setEmail(email);
                newUser.setUsername(username);
                newUser.setPassword(password); // Store plaintext
                newUser.setFullName(username);
                newUser.setRole("Student");

                boolean isRegistered = userService.registerUser(newUser);
                if (isRegistered) {
                    request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("/view/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                    request.getRequestDispatcher("/view/login.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/login.jsp").forward(request, response);
        }
    }
}