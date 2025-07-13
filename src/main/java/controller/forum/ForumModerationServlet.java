package controller.forum;

import dao.forum.ForumPostDAO;
import dao.UserDAO;
import model.forum.ForumPost;
import model.UserAccount;
import service.ForumPermissionService;
import constant.ForumPermissions;
import authentication.UserAuthentication;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "ForumModerationServlet", urlPatterns = {"/forum/moderate", "/forum/moderate/*"})
public class ForumModerationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ForumModerationServlet.class.getName());
    private ForumPostDAO postDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new ForumPostDAO();
        userDAO = new UserDAO();
        LOGGER.info("ForumModerationServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication and permissions
        HttpSession session = request.getSession();
        String userId = UserAuthentication.getUserID(session);
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (userId == null || user == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        // Check if user has moderation permissions
        if (!ForumPermissionService.hasPermission(user, ForumPermissions.PERM_MODERATE_CONTENT)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập trang này");
            return;
        }

        try {
            String pathInfo = request.getPathInfo();

            if (pathInfo == null || pathInfo.equals("/")) {
                // Show moderation dashboard
                List<ForumPost> moderationPosts = postDAO.getHiddenOrPinnedPosts(20);
                System.out.println("moderationPosts size: " + moderationPosts.size()); // Debug

                request.setAttribute("moderationPosts", moderationPosts);
                request.getRequestDispatcher("/view/forum/moderate.jsp").forward(request, response);

            } else if (pathInfo.startsWith("/post/")) {
                // Moderate specific post
                int postId = Integer.parseInt(pathInfo.substring(6));
                ForumPost post = postDAO.getPostById(postId);

                if (post == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bài viết không tồn tại");
                    return;
                }

                // Check if user can moderate this category
                if (!ForumPermissionService.canModerateCategory(user, post.getCategory())) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền kiểm duyệt chuyên mục này");
                    return;
                }

                request.setAttribute("post", post);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/view/forum/moderate.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error in moderation: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check authentication and permissions
        HttpSession session = request.getSession();
        String userId = UserAuthentication.getUserID(session);
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (userId == null || user == null) {
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return;
        }

        if (!ForumPermissionService.hasPermission(user, ForumPermissions.PERM_MODERATE_CONTENT)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện hành động này");
            return;
        }

        try {
            String action = request.getParameter("action");
            int postId = Integer.parseInt(request.getParameter("postId"));

            ForumPost post = postDAO.getPostById(postId);
            if (post == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bài viết không tồn tại");
                return;
            }

            // Check if user can moderate this category
            if (!ForumPermissionService.canModerateCategory(user, post.getCategory())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền kiểm duyệt chuyên mục này");
                return;
            }

            boolean success = false;
            String message = "";

            switch (action) {
                case "hide":
                    if (ForumPermissionService.canHidePost(user)) {
                        success = postDAO.hidePost(postId, userId);
                        message = success ? "Đã ẩn bài viết thành công" : "Không thể ẩn bài viết";
                    } else {
                        message = "Bạn không có quyền ẩn bài viết";
                    }
                    break;

                case "show":
                    if (ForumPermissionService.canHidePost(user)) {
                        success = postDAO.showPost(postId, userId);
                        message = success ? "Đã hiển thị bài viết thành công" : "Không thể hiển thị bài viết";
                    } else {
                        message = "Bạn không có quyền hiển thị bài viết";
                    }
                    break;

                case "pin":
                    if (ForumPermissionService.canPinPost(user)) {
                        success = postDAO.pinPost(postId, userId);
                        message = success ? "Đã ghim bài viết thành công" : "Không thể ghim bài viết";
                    } else {
                        message = "Bạn không có quyền ghim bài viết";
                    }
                    break;

                case "unpin":
                    if (ForumPermissionService.canPinPost(user)) {
                        success = postDAO.unpinPost(postId, userId);
                        message = success ? "Đã bỏ ghim bài viết thành công" : "Không thể bỏ ghim bài viết";
                    } else {
                        message = "Bạn không có quyền bỏ ghim bài viết";
                    }
                    break;

                case "delete":
                    if (ForumPermissionService.canDeletePost(user, post)) {
                        success = postDAO.deletePost(postId, userId);
                        message = success ? "Đã xóa bài viết thành công" : "Không thể xóa bài viết";
                    } else {
                        message = "Bạn không có quyền xóa bài viết này";
                    }
                    break;

                default:
                    message = "Hành động không hợp lệ";
            }

            request.getSession().setAttribute("message", message);

            if ("delete".equals(action) && success) {
                response.sendRedirect(request.getContextPath() + "/forum");
            } else {
                response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
            }

        } catch (SQLException e) {
            LOGGER.severe("Database error in moderation action: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi cơ sở dữ liệu");
            response.sendRedirect(request.getContextPath() + "/forum/moderate");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ");
        }
    }
}
