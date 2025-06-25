package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserAccount;
import service.UserService;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/users")
public class ManageUsersServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String message = req.getParameter("message");
        req.setAttribute("message", message);

        try {
            if ("view".equals(action)) {
                String userID = req.getParameter("id");
                UserAccount user = userService.findByUserNum(userID);
                req.setAttribute("user", user);
                req.getRequestDispatcher("/view/admin/viewUser.jsp").forward(req, resp);
            } else if ("filter".equals(action)) {
                String role = req.getParameter("role");
                List<UserAccount> users = userService.getUsersByRole(role);
                req.setAttribute("users", users);
                req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
            } else {
                List<UserAccount> users = userService.getAllUsers();
                req.setAttribute("users", users);
                req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        try {
            if ("add".equals(action)) {
                UserAccount user = new UserAccount();
                user.setUserID(userService.generateNewUserID());
                user.setFullName(req.getParameter("fullName"));
                user.setUsername(req.getParameter("username"));
                user.setEmail(req.getParameter("email"));
                user.setPassword(req.getParameter("password"));
                user.setRole(req.getParameter("role"));
                
                boolean success = userService.registerUser(user);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?message=Thêm thành công");
                } else {
                    req.setAttribute("error", "Không thể thêm người dùng");
                    req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
                }
                
            } else if ("edit".equals(action)) {
                UserAccount user = new UserAccount();
                user.setUserID(req.getParameter("userId"));
                user.setFullName(req.getParameter("fullName"));
                user.setUsername(req.getParameter("username"));
                user.setEmail(req.getParameter("email"));
                user.setRole(req.getParameter("role"));
                
                String password = req.getParameter("password");
                if (password != null && !password.trim().isEmpty()) {
                    user.setPassword(password);
                }
                
                userService.updateUserInfo(user);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=Cập nhật thành công");
                
            } else if ("block".equals(action)) {
                String userID = req.getParameter("userId");
                String status = req.getParameter("status");
                boolean isActive = "Hoạt Động".equals(status);
                
                userService.updateUserStatus(userID, isActive);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=Cập nhật trạng thái thành công");
                
            } else if ("delete".equals(action)) {
                String userID = req.getParameter("userId");
                userService.deleteUser(userID);
                resp.sendRedirect(req.getContextPath() + "/admin/users?message=Xóa thành công");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/view/admin/error.jsp").forward(req, resp);
        }
    }
}
