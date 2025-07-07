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
import authentication.UserAuthentication;
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
            String action = request.getParameter("action");
            if ("login".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                UserAccount user = userService.login(username, password);
                if (user != null) {
                    HttpSession session = request.getSession();
                    try {
                        // Set user session using existing UserAuthentication utility
                        UserAuthentication.setUserSession(session, user.getUserID(), user.getRole());

                        // Also store the full user object for compatibility with existing code
                        session.setAttribute("user", user);
                        session.setAttribute("role", user.getRole());
                        session.setAttribute("userId", user.getUserID());
                        session.setAttribute("username", user.getUsername());
                        // Update session using existing SessionManager
                        sessionManager.updateSession(user, session);
                        
                        // Check if there's a redirect URL stored in session
                        String redirectUrl = (String) session.getAttribute("redirectUrl");
                         if (redirectUrl != null) {
                            session.removeAttribute("redirectUrl");
                            System.out.println("Redirecting user to original URL: " + redirectUrl);
                            response.sendRedirect(redirectUrl);
                        } else if((user.getRole()).equals("Student")){
                            response.sendRedirect(request.getContextPath() + "/view/student/home.jsp");
                        } 
                        else if((user.getRole()).equals("Coordinator")){
                            response.sendRedirect(request.getContextPath() + "/LoadDashboard");
                        }
                         else if((user.getRole()).equals("Admin")){
                            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                        }
                        else if((user.getRole()).equals("Teacher")){
                            response.sendRedirect(request.getContextPath() + "/view/teacher/manageCourse.jsp");
                        }
                         else 
                             response.sendRedirect(request.getContextPath() + "/view/student/home.jsp");
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
                newUser.setPassword(password);
                newUser.setFullName(username);
                newUser.setRole("Student");
                
                // Generate userID BEFORE registering
                try {
                    String newUserID = new UserDAO().generateNewUserID();
                    newUser.setUserID(newUserID);
                    System.out.println("Generated userID: " + newUserID);
                } catch (SQLException e) {
                    request.setAttribute("error", "Lỗi tạo ID người dùng: " + e.getMessage());
                    request.getRequestDispatcher("/view/login.jsp?formType=signup").forward(request, response);
                    return;
                }
                
                boolean isRegistered = userService.registerUser(newUser);
                if (isRegistered) {
                    request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
                    request.getRequestDispatcher("/view/login.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
                    request.getRequestDispatcher("/view/login.jsp").forward(request, response);
                }
            }
        } catch (ServletException | IOException | ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/view/login.jsp").forward(request, response);
        }
    }
}
