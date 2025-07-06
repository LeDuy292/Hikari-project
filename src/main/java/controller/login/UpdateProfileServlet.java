package controller.login;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import com.google.gson.Gson;
import model.UserAccount;
import dao.UserDAO;
import utils.ValidationUtil;

import java.io.File;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig(maxFileSize = 10485760) // 10MB max file size
public class UpdateProfileServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private static final String UPLOAD_DIR = "assets/img/uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.getWriter().write(new Gson().toJson(new Result(false, "Phiên làm việc hết hạn")));
            return;
        }

        UserAccount user = (UserAccount) session.getAttribute("user");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String birthDate = request.getParameter("birthDate");
        String email = request.getParameter("email");
        Part filePart = request.getPart("profileImage");
        String profilePicture = user.getProfilePicture();

        if (!ValidationUtil.isValidFullName(fullName)) {
            response.getWriter().write(new Gson().toJson(new Result(false, "Họ và tên không hợp lệ")));
            return;
        }
        if (phone != null && !phone.isEmpty() && !phone.matches("\\d{10,11}")) {
            response.getWriter().write(new Gson().toJson(new Result(false, "Số điện thoại không hợp lệ")));
            return;
        }
        if (birthDate != null && !birthDate.isEmpty()) {
            try {
                java.sql.Date.valueOf(birthDate);
            } catch (IllegalArgumentException e) {
                response.getWriter().write(new Gson().toJson(new Result(false, "Ngày sinh không hợp lệ")));
                return;
            }
        }
        if (email != null && !email.isEmpty() && !email.matches("^[\\w.-]+@([\\w-]+\\.)+[a-zA-Z]{2,}$")) {
            response.getWriter().write(new Gson().toJson(new Result(false, "Email không hợp lệ")));
            return;
        }
        if (email != null && !email.isEmpty() && !email.equals(user.getEmail())) {
            try {
                if (userDAO.findByEmail(email) != null) {
                    response.getWriter().write(new Gson().toJson(new Result(false, "Email đã tồn tại")));
                    return;
                }
            } catch (ClassNotFoundException e) {
                response.getWriter().write(new Gson().toJson(new Result(false, "Lỗi hệ thống")));
                return;
            } catch (SQLException ex) {
                Logger.getLogger(UpdateProfileServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        try {
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setBirthDate(birthDate != null && !birthDate.isEmpty() ? java.sql.Date.valueOf(birthDate) : null);
            if (email != null && !email.isEmpty()) user.setEmail(email);

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = user.getUserID() + "_" + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                profilePicture = "/assets/img/uploads/" + fileName; // Đường dẫn tương đối
                user.setProfilePicture(profilePicture);
                System.out.println("Saved profile picture: " + filePath); // Log để debug
            }

            userDAO.updateUserProfile(user); // Đảm bảo lưu vào database
            session.setAttribute("user", user); // Cập nhật session
            response.getWriter().write(new Gson().toJson(new Result(true, "Cập nhật thành công", profilePicture)));
        } catch (IllegalArgumentException e) {
            response.getWriter().write(new Gson().toJson(new Result(false, "Dữ liệu không hợp lệ: " + e.getMessage())));
        } catch (Exception e) {
            response.getWriter().write(new Gson().toJson(new Result(false, "Cập nhật thất bại: " + e.getMessage())));
            e.printStackTrace(); // Log lỗi chi tiết
        }
    }

    private class Result {
        private boolean success;
        private String message;
        private String profilePicture;

        public Result(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public Result(boolean success, String message, String profilePicture) {
            this.success = success;
            this.message = message;
            this.profilePicture = profilePicture;
        }
    }
}