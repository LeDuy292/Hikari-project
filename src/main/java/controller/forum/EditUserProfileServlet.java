package controller.forum;

import dao.UserDAO;
import model.UserAccount;
import responsitory.ForumImageRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "EditUserProfileServlet", urlPatterns = {"/profile/edit"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // 10MB
public class EditUserProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String currentUserId = (String) session.getAttribute("userId");

        // Lấy đối tượng userDetail từ session
        UserAccount currentUser = (UserAccount) session.getAttribute("user");

        // Trường hợp chưa đăng nhập hoặc user không đúng kiểu
        if (currentUserId == null || currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        // Lấy userId từ form (ẩn)
        String userId = request.getParameter("userId");
        if (userId == null || userId.isEmpty()) {
            userId = currentUserId;
        }

        // Không cho sửa tài khoản người khác
        if (!currentUserId.equals(userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền sửa thông tin người khác!");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String birthDateStr = request.getParameter("birthDate");
            String bio = request.getParameter("bio");

            Date birthDate = null;
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                birthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDateStr);
            }

            // Cập nhật dữ liệu cơ bản
            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setPhone(phone);
            currentUser.setBirthDate(birthDate);
            currentUser.setBio(bio);

            // Cập nhật ảnh đại diện
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                ForumImageRepository repo = new ForumImageRepository();
                String avatarUrl = repo.uploadAvatarImage(avatarPart, userId);
                if (avatarUrl != null && !avatarUrl.isEmpty()) {
                    currentUser.setProfilePicture(avatarUrl);
                }
            }
            // Cập nhật ảnh bìa
            Part coverPart = request.getPart("coverPhoto");
            if (coverPart != null && coverPart.getSize() > 0) {
                ForumImageRepository repo = new ForumImageRepository();
                String coverUrl = repo.uploadImage(coverPart, "forum/covers/" + userId + "/", 5 * 1024 * 1024, "cover");
                if (coverUrl != null && !coverUrl.isEmpty()) {
                    currentUser.setCoverPhoto(coverUrl);
                }
            }

            // Cập nhật vào CSDL
            userDAO.updateUserProfileDetail(currentUser);

            // Cập nhật session
            session.setAttribute("userDetail", currentUser); // thông tin chi tiết
            session.setAttribute("user", currentUser); // thông tin cơ bản (dùng UserProfileDetail luôn)
            session.setAttribute("message", "Cập nhật thông tin thành công!");

            response.sendRedirect(request.getContextPath() + "/profile?userId=" + userId);
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/view/forum/editUserProfileForum.jsp");
        }
    }
}
