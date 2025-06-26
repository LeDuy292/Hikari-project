package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UserAccount;
import service.UserService;
import dao.UserDAO;
import utils.ValidationUtil;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.sql.SQLException;

@WebServlet("/admin/users")
public class ManageUsersServlet extends HttpServlet {
    private final UserService userService = new UserService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String message = req.getParameter("message");
        String error = req.getParameter("error");
        
        req.setAttribute("message", message);
        req.setAttribute("error", error);

        try {
            if ("view".equals(action)) {
                handleViewUser(req, resp);
            } else if ("filter".equals(action)) {
                handleFilterUsers(req, resp);
            } else if ("search".equals(action)) {
                handleSearchUsers(req, resp);
            } else {
                // Default: load all users
                List<UserAccount> users = userService.getAllUsers();
                req.setAttribute("users", users);
                req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
        }
    }

    private void handleViewUser(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException, ClassNotFoundException, SQLException {
        String userID = req.getParameter("id");
        if (userID != null && !userID.trim().isEmpty()) {
            UserAccount user = userService.findByUserNum(userID);
            if (user != null) {
                req.setAttribute("viewUser", user);
                req.setAttribute("users", userService.getAllUsers());
                req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Không tìm thấy người dùng với ID: " + userID);
                req.setAttribute("users", userService.getAllUsers());
                req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
            }
        }
    }

    private void handleFilterUsers(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException, SQLException {
        String role = req.getParameter("role");
        String status = req.getParameter("status");
        String dateFrom = req.getParameter("dateFrom");
        String dateTo = req.getParameter("dateTo");
        String nameSearch = req.getParameter("nameSearch");
        String minCoursesStr = req.getParameter("minCourses");
        
        int minCourses = 0;
        if (minCoursesStr != null && !minCoursesStr.trim().isEmpty()) {
            try {
                minCourses = Integer.parseInt(minCoursesStr);
            } catch (NumberFormatException e) {
                minCourses = 0;
            }
        }

        List<UserAccount> users = userDAO.getFilteredUsers(role, status, dateFrom, dateTo, nameSearch, minCourses);
        req.setAttribute("users", users);
        
        // Keep filter values for form
        req.setAttribute("selectedRole", role);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("selectedDateFrom", dateFrom);
        req.setAttribute("selectedDateTo", dateTo);
        req.setAttribute("selectedNameSearch", nameSearch);
        req.setAttribute("selectedMinCourses", minCoursesStr);
        
        req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
    }

    private void handleSearchUsers(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException, SQLException, ClassNotFoundException {
        String searchTerm = req.getParameter("search");
        List<UserAccount> users;
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            users = userDAO.getFilteredUsers(null, null, null, null, searchTerm, 0);
        } else {
            users = userService.getAllUsers();
        }
        
        req.setAttribute("users", users);
        req.setAttribute("searchTerm", searchTerm);
        req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    handleAddUser(req, resp);
                    break;
                case "edit":
                    handleEditUser(req, resp);
                    break;
                case "block":
                    handleBlockUser(req, resp);
                    break;
                case "delete":
                    handleDeleteUser(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/users?error=Hành động không hợp lệ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + e.getMessage());
        }
    }

    private void handleAddUser(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException, ClassNotFoundException, SQLException {
        // Validate input
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String role = req.getParameter("role");
        String phone = req.getParameter("phone");
        String birthDateStr = req.getParameter("birthDate");

        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Họ tên không được để trống");
            return;
        }
        
        if (!ValidationUtil.isValidUsername(username)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Tên đăng nhập không hợp lệ");
            return;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Email không hợp lệ");
            return;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Mật khẩu phải dài 6-50 ký tự và chứa ít nhất một chữ và một số");
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Mật khẩu xác nhận không khớp");
            return;
        }

        if (userService.isEmailExists(email)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Email đã tồn tại");
            return;
        }

        // Create new user
        UserAccount user = new UserAccount();
        user.setUserID(userService.generateNewUserID());
        user.setFullName(fullName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);
        user.setPhone(phone);
        
        // Parse birth date
        if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date birthDate = sdf.parse(birthDateStr);
                user.setBirthDate(birthDate);
            } catch (Exception e) {
                // Ignore invalid date
            }
        }
        
        boolean success = userService.registerUser(user);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?message=Thêm người dùng thành công");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Không thể thêm người dùng");
        }
    }

    private void handleEditUser(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException, ClassNotFoundException, SQLException {
        String userID = req.getParameter("userId");
        String fullName = req.getParameter("fullName");
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");
        String phone = req.getParameter("phone");
        String birthDateStr = req.getParameter("birthDate");

        // Validation
        if (userID == null || userID.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=ID người dùng không hợp lệ");
            return;
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Họ tên không được để trống");
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Email không hợp lệ");
            return;
        }

        // Get existing user
        UserAccount existingUser = userService.findByUserNum(userID);
        if (existingUser == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=Không tìm thấy người dùng");
            return;
        }

        // Update user info
        existingUser.setFullName(fullName);
        existingUser.setUsername(username);
        existingUser.setEmail(email);
        existingUser.setRole(role);
        existingUser.setPhone(phone);
        
        // Update password only if provided
        if (password != null && !password.trim().isEmpty()) {
            if (!ValidationUtil.isValidPassword(password)) {
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=Mật khẩu không hợp lệ");
                return;
            }
            existingUser.setPassword(password);
        }
        
        // Parse birth date
        if (birthDateStr != null && !birthDateStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date birthDate = sdf.parse(birthDateStr);
                existingUser.setBirthDate(birthDate);
            } catch (Exception e) {
                // Ignore invalid date
            }
        }
        
        userService.updateUserInfo(existingUser);
        resp.sendRedirect(req.getContextPath() + "/admin/users?message=Cập nhật thông tin thành công");
    }

    private void handleBlockUser(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException, ClassNotFoundException, SQLException {
        String userID = req.getParameter("userId");
        String statusStr = req.getParameter("status");
        
        if (userID == null || userID.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=ID người dùng không hợp lệ");
            return;
        }
        
        boolean isActive = "Hoạt Động".equals(statusStr);
        userService.updateUserStatus(userID, isActive);
        
        String message = isActive ? "Mở khóa tài khoản thành công" : "Khóa tài khoản thành công";
        resp.sendRedirect(req.getContextPath() + "/admin/users?message=" + message);
    }

    private void handleDeleteUser(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException, ClassNotFoundException, SQLException {
        String userID = req.getParameter("userId");
        
        if (userID == null || userID.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=ID người dùng không hợp lệ");
            return;
        }
        
        userService.deleteUser(userID);
        resp.sendRedirect(req.getContextPath() + "/admin/users?message=Xóa người dùng thành công");
    }
}
