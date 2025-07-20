package controller.forum;

import dao.forum.ForumPostDAO;
import dao.UserDAO;
import model.forum.ForumPost;
import model.UserAccount;
import service.ForumPermissionService;
import constant.ForumPermissions;
import authentication.UserAuthentication;
import responsitory.ForumImageRepository;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;
import service.SightengineClientService;

@WebServlet(name = "EditPostServlet", urlPatterns = {"/forum/editPost/*"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class EditPostServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(EditPostServlet.class.getName());
    private ForumPostDAO postDAO;
    private UserDAO userDAO;
    private ForumImageRepository imageRepository;

    @Override
    public void init() throws ServletException {
        postDAO = new ForumPostDAO();
        userDAO = new UserDAO();
        imageRepository = new ForumImageRepository();
        LOGGER.info("EditPostServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession();
        String userId = UserAuthentication.getUserID(session);
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (userId == null || user == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
                return;
            }

            int postId = Integer.parseInt(pathInfo.substring(1));
            ForumPost post = postDAO.getPostById(postId);

            if (post == null) {
                request.getSession().setAttribute("message", "Bài viết không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }

            // Check if user can edit this post
            if (!ForumPermissionService.canEditPost(user, post)) {
                request.getSession().setAttribute("message", "Bạn không có quyền chỉnh sửa bài viết này!");
                response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
                return;
            }

            // Get allowed categories for this user
            List<String> allowedCategories = ForumPermissionService.getAllowedCategories(user);

            request.setAttribute("post", post);
            request.setAttribute("user", user);
            request.setAttribute("allowedCategories", allowedCategories);

            LOGGER.info("User " + user.getUsername() + " is editing post " + postId);
            request.getRequestDispatcher("/view/forum/editPost.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.severe("Database error in doGet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication
        HttpSession session = request.getSession();
        String userId = UserAuthentication.getUserID(session);
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (userId == null || user == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.length() <= 1) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
                return;
            }

            int postId = Integer.parseInt(pathInfo.substring(1));
            ForumPost post = postDAO.getPostById(postId);

            if (post == null) {
                request.getSession().setAttribute("message", "Bài viết không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }

            // Check if user can edit this post
            if (!ForumPermissionService.canEditPost(user, post)) {
                request.getSession().setAttribute("message", "Bạn không có quyền chỉnh sửa bài viết này!");
                response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
                return;
            }

            String title = request.getParameter("postTitle");
            String content = request.getParameter("postContent");
            String category = request.getParameter("postCategory");

            if (title == null || title.trim().isEmpty()
                    || content == null || content.trim().isEmpty()
                    || category == null || category.trim().isEmpty()) {
                request.getSession().setAttribute("message", "Tiêu đề, nội dung và chuyên mục không được để trống!");
                response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
                return;
            }

            // Check if user can post in this category
            if (!ForumPermissionService.canPostInCategory(user, category)) {
                request.getSession().setAttribute("message", "Bạn không có quyền đăng bài trong chuyên mục này!");
                response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
                return;
            }

            // Handle image upload
            String imageUrl = post.getPicture(); // Keep existing image by default
            Part filePart = request.getPart("imageInput");
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    // Delete old image if exists
                    if (post.getPicture() != null && !post.getPicture().isEmpty()) {
                        imageRepository.deleteImage(post.getPicture());
                    }

                    // Upload new image
                    try (InputStream inputStream = filePart.getInputStream()) {
                        byte[] imageBytes = inputStream.readAllBytes();
                        String contentType = filePart.getContentType();

                        // Kiểm duyệt ảnh
                        SightengineClientService.ImageSafetyResult result
                                = new SightengineClientService().isImageSafe(imageBytes, contentType);

                        if (!result.isSafe) {
                            String violationMessage = "Hình ảnh vi phạm quy định cộng đồng: " + String.join(", ", result.violations);
                            request.getSession().setAttribute("message", violationMessage);
                            LOGGER.warning("Kiểm duyệt hình ảnh thất bại. Vi phạm: " + String.join(", ", result.violations));
                            response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
                            return;
                        }

                        // Xóa ảnh cũ nếu có
                        if (post.getPicture() != null && !post.getPicture().isEmpty()) {
                            imageRepository.deleteImage(post.getPicture());
                        }

                        // Tải ảnh mới nếu ảnh an toàn
                        imageUrl = imageRepository.uploadPostImage(filePart, userId);
                        if (imageUrl == null) {
                            request.getSession().setAttribute("message", "Lỗi khi tải lên hình ảnh!");
                            response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
                            return;
                        }

                        LOGGER.info("Updated image for post " + postId + ": " + imageUrl);
                    } catch (Exception e) {
                        LOGGER.severe("Error during image moderation/upload: " + e.getMessage());
                        request.getSession().setAttribute("message", "Lỗi khi kiểm duyệt hoặc tải lên hình ảnh!");
                        response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
                        return;
                    }

                    LOGGER.info("Updated image for post " + postId + ": " + imageUrl);
                } catch (Exception e) {
                    LOGGER.severe("Error uploading image: " + e.getMessage());
                    request.getSession().setAttribute("message", "Lỗi khi tải lên hình ảnh!");
                    response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
                    return;
                }
            }

            // Update post
            post.setTitle(title.trim());
            post.setContent(content.trim());
            post.setCategory(category.trim());
            post.setPicture(imageUrl);

            boolean updated = postDAO.updatePost(post);

            if (updated) {
                request.getSession().setAttribute("message", "Cập nhật bài viết thành công!");
                LOGGER.info("Post " + postId + " updated successfully by user " + user.getUsername());
                response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
            } else {
                request.getSession().setAttribute("message", "Không thể cập nhật bài viết!");
                response.sendRedirect(request.getContextPath() + "/forum/editPost/" + postId);
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error in doPost: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi cơ sở dữ liệu khi cập nhật bài viết");
            response.sendRedirect(request.getContextPath() + "/forum");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error in doPost: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi không xác định khi cập nhật bài viết");
            response.sendRedirect(request.getContextPath() + "/forum");
        }
    }
}
