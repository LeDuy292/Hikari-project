package controller.forum;

import dao.UserDAO;
import model.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import responsitory.ForumImageRepository;

@WebServlet(name = "EditUserProfileServlet", urlPatterns = {"/profile/edit"})
@MultipartConfig(maxFileSize = 10 * 1024 * 1024) // Đảm bảo hỗ trợ upload ảnh lớn
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
        UserAccount currentUser = (UserAccount) session.getAttribute("user");

        // Lấy userId cần sửa (từ session hoặc form)
        String userId = request.getParameter("userId");
        if (userId == null || userId.isEmpty()) {
            userId = currentUserId;
        }

        // Chỉ cho phép user tự sửa thông tin của mình
        if (currentUserId == null || !currentUserId.equals(userId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền sửa thông tin người khác!");
            return;
        }

        try {
            // Lấy thông tin từ form
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String birthDateStr = request.getParameter("birthDate");

            java.util.Date birthDate = null;
            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                birthDate = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(birthDateStr);
            }

            // Cập nhật thông tin user
            currentUser.setFullName(fullName);
            currentUser.setEmail(email);
            currentUser.setPhone(phone);
            currentUser.setBirthDate(birthDate);

            // Xử lý ảnh đại diện
            Part avatarPart = request.getPart("avatar");
            if (avatarPart != null && avatarPart.getSize() > 0) {
                ForumImageRepository repo = new ForumImageRepository();
                String avatarUrl = repo.uploadAvatarImage(avatarPart, userId);
                if (avatarUrl != null && !avatarUrl.isEmpty()) {
                    currentUser.setProfilePicture(avatarUrl);
                }
            }

            // Xử lý ảnh bìa (nếu bạn muốn lưu đường dẫn ảnh bìa, hãy thêm trường coverPhoto vào UserAccount và DB)
            Part coverPart = request.getPart("coverPhoto");
            if (coverPart != null && coverPart.getSize() > 0) {
                ForumImageRepository repo = new ForumImageRepository();
                String coverUrl = repo.uploadImage(coverPart, "forum/covers/" + userId + "/", 5 * 1024 * 1024, "cover");
                // Nếu có trường coverPhoto trong UserAccount:
                // currentUser.setCoverPhoto(coverUrl);
                // Nếu không, bạn có thể bỏ qua hoặc lưu vào session để hiển thị tạm thời
                session.setAttribute("coverPhotoUrl", coverUrl);
            }

            userDAO.updateUserProfile(currentUser);

            // Cập nhật lại session
            session.setAttribute("user", currentUser);

            // Thông báo thành công
            session.setAttribute("message", "Cập nhật thông tin thành công!");
            response.sendRedirect(request.getContextPath() + "/profile?userId=" + userId);
        } catch (Exception e) {
            session.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/view/forum/editUserProfileForum.jsp");
        }
    }
}