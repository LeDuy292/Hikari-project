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
import java.util.Arrays;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/admin/users")
public class ManageUsersServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ManageUsersServlet.class.getName());
    private final UserService userService = new UserService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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
                if (users == null || users.isEmpty()) {
                    LOGGER.warning("No users retrieved from database");
                    req.setAttribute("error", "Không có người dùng nào được tìm thấy");
                }
                req.setAttribute("users", users);
                req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing request: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.setAttribute("users", null); // Set to null to avoid passing invalid data
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
            throws ServletException, IOException, SQLException, ClassNotFoundException {
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
        if (users == null || users.isEmpty()) {
            LOGGER.warning("No users found for filter criteria");
            req.setAttribute("error", "Không tìm thấy người dùng theo tiêu chí lọc");
        }
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
        
        if (users == null || users.isEmpty()) {
            LOGGER.warning("No users found for search term: " + searchTerm);
            req.setAttribute("error", "Không tìm thấy người dùng theo từ khóa tìm kiếm");
        }
        
        req.setAttribute("users", users);
        req.setAttribute("searchTerm", searchTerm);
        req.getRequestDispatcher("/view/admin/manageUsers.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Check admin permission
        UserAccount currentUser = (UserAccount) req.getSession().getAttribute("user");
        if (currentUser == null || !"Admin".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

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
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/users?error=Hành động không hợp lệ");
            }
        } catch (Exception e) {
            LOGGER.severe("Error processing POST request: " + e.getMessage());
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
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
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Họ tên không được để trống", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidUsername(username)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Tên đăng nhập không hợp lệ", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidEmail(email)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Email không hợp lệ", "UTF-8"));
            return;
        }
        
        if (!ValidationUtil.isValidPassword(password)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Mật khẩu phải dài 6-50 ký tự và chứa ít nhất một chữ và một số", "UTF-8"));
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Mật khẩu xác nhận không khớp", "UTF-8"));
            return;
        }

        if (role == null || role.trim().isEmpty() || !Arrays.asList("Student", "Teacher", "Admin", "Coordinator").contains(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Vui lòng chọn vai trò hợp lệ", "UTF-8"));
            return;
        }

        if (userService.isEmailExists(email)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Email đã tồn tại", "UTF-8"));
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
        user.setIsActive(true);
        
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
            resp.sendRedirect(req.getContextPath() + "/admin/users?message=" + java.net.URLEncoder.encode("Thêm người dùng thành công với vai trò " + role, "UTF-8"));
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Không thể thêm người dùng", "UTF-8"));
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
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("ID người dùng không hợp lệ", "UTF-8"));
            return;
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Họ tên không được để trống", "UTF-8"));
            return;
        }

        if (!ValidationUtil.isValidEmail(email)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Email không hợp lệ", "UTF-8"));
            return;
        }

        if (role == null || role.trim().isEmpty() || !Arrays.asList("Student", "Teacher", "Admin", "Coordinator").contains(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Vui lòng chọn vai trò hợp lệ", "UTF-8"));
            return;
        }

        // Get existing user
        UserAccount existingUser = userService.findByUserNum(userID);
        if (existingUser == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Không tìm thấy người dùng", "UTF-8"));
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
                resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + java.net.URLEncoder.encode("Mật khẩu không hợp lệ", "UTF-8"));
                return;
            }
            existingUser.setPassword(password);
        } else {
            existingUser.setPassword(null); // Don't update password
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
        resp.sendRedirect(req.getContextPath() + "/admin/users?message=" + java.net.URLEncoder.encode("Cập nhật thông tin thành công với vai trò " + role, "UTF-8"));
    }

    private void handleBlockUser(HttpServletRequest req, HttpServletResponse resp) 
            throws IOException, ClassNotFoundException, SQLException {
        String userID = req.getParameter("userId");
        String isActiveStr = req.getParameter("isActive");
        
        if (userID == null || userID.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?error=" + 
                java.net.URLEncoder.encode("ID người dùng không hợp lệ", "UTF-8"));
            return;
        }
        
        boolean isActive = Boolean.parseBoolean(isActiveStr);
        userService.updateUserStatus(userID, isActive);
        
        String message = isActive ? "Mở khóa tài khoản thành công" : "Khóa tài khoản thành công";
        resp.sendRedirect(req.getContextPath() + "/admin/users?message=" + 
            java.net.URLEncoder.encode(message, "UTF-8"));
    }
}
