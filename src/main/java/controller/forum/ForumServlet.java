package controller.forum;

import dao.forum.ForumPostDAO;
import dao.forum.UserActivityScoreDAO;
import dao.UserDAO;
import dao.forum.PostViewDAO;
import model.forum.ForumPost;
import model.forum.UserActivityScore;
import authentication.UserAuthentication;
import service.ForumPermissionService;
import constant.ForumPermissions;
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
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.logging.Logger;
import model.UserAccount;

@WebServlet(name = "ForumServlet", urlPatterns = {"/forum", "/forum/createPost", "/forum/post/*", "/forum/deletePost"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ForumServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ForumServlet.class.getName());
    private ForumPostDAO postDAO;
    private UserActivityScoreDAO scoreDAO;
    private UserDAO userDAO;
    private PostViewDAO postViewDAO;
    private ForumImageRepository imageRepository;

    private static final List<String> VALID_SORTS = Arrays.asList("newest", "popular", "most-liked");
    private static final List<String> VALID_FILTERS = Arrays.asList("all", "with-replies", "no-replies");

    @Override
    public void init() throws ServletException {
        postDAO = new ForumPostDAO();
        scoreDAO = new UserActivityScoreDAO();
        userDAO = new UserDAO();
        postViewDAO = new PostViewDAO();
        imageRepository = new ForumImageRepository();
        LOGGER.info("ForumServlet initialized");
    }

    /**
     * Check if user is authenticated using existing UserAuthentication utility
     */
    private boolean checkAuthentication(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            redirectToLogin(request, response);
            return false;
        }
        
        String userId = (String) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (userId == null || username == null || user == null) {
            LOGGER.info("User not authenticated, redirecting to login");
            redirectToLogin(request, response);
            return false;
        }
        
        return true;
    }
    
    private void redirectToLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String originalUrl = request.getRequestURI();
        if (request.getQueryString() != null) {
            originalUrl += "?" + request.getQueryString();
        }
        
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("redirectUrl", originalUrl);
        
        response.sendRedirect(request.getContextPath() + "/view/login.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ForumServlet doGet called for URL: " + request.getRequestURI());
        
        // Check authentication first
        if (!checkAuthentication(request, response)) {
            return;
        }
        
        try {
            String pathInfo = request.getPathInfo();
            HttpSession session = request.getSession();
            
            String userId = UserAuthentication.getUserID(session);
            String userRole = UserAuthentication.getUserRole(session);
            UserAccount user = (UserAccount) session.getAttribute("user");

            if (userId == null || user == null) {
                LOGGER.warning("User session invalid, redirecting to login");
                redirectToLogin(request, response);
                return;
            }
            
            // Check basic read permission
            if (!ForumPermissionService.hasPermission(user, ForumPermissions.PERM_READ_POSTS)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập diễn đàn");
                return;
            }
            
            request.setAttribute("user", user);
            request.setAttribute("userId", userId);
            request.setAttribute("userRole", userRole);
            LOGGER.info("User authenticated: " + user.getUsername() + " (ID: " + userId + ", Role: " + userRole + ")");

            // Set leaderboard data for both forum and post detail pages
            int limit = 100;
            String timeFrame = request.getParameter("sort") != null
                    && Arrays.asList("weekly", "monthly", "alltime").contains(request.getParameter("sort"))
                    ? request.getParameter("sort") : "alltime";
            List<UserActivityScore> topUsers = scoreDAO.getTopUsers(limit, timeFrame);
            request.setAttribute("topUsers", topUsers);
            request.setAttribute("timeFrame", timeFrame);
            LOGGER.info("Leaderboard set with timeFrame: " + timeFrame + ", topUsers size: " + (topUsers != null ? topUsers.size() : 0));

            if (pathInfo != null && pathInfo.matches("/\\d+")) {
                // Viewing a specific post
                int postId = Integer.parseInt(pathInfo.substring(1));
                ForumPost post = postDAO.getPostById(postId);
                if (post == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bài viết không tồn tại");
                    return;
                }

                // Mark post as viewed by current user
                try {
                    postViewDAO.markPostAsViewed(userId, postId);
                    LOGGER.info("Marked post " + postId + " as viewed by user " + userId);
                } catch (SQLException e) {
                    LOGGER.warning("Could not mark post as viewed: " + e.getMessage());
                }

                postDAO.incrementViewCount(postId);
                request.setAttribute("postDetail", post);

                // Get related posts
                List<ForumPost> relatedPosts = postDAO.getRelatedPosts(postId, post.getCategory(), 3);
                request.setAttribute("relatedPosts", relatedPosts);

                // Set sort and filter defaults for consistency
                String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "newest";
                String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "all";
                String search = request.getParameter("search");
                request.setAttribute("sort", sort);
                request.setAttribute("filter", filter);
                request.setAttribute("search", search);

                LOGGER.info("Forwarding to /view/forum/postDetail.jsp for postId: " + postId);
                request.getRequestDispatcher("/view/forum/postDetail.jsp").forward(request, response);
                return;
            } else {
                // Handle forum main page
                String sort = request.getParameter("sort") != null ? request.getParameter("sort") : "newest";
                String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "all";
                String search = request.getParameter("search");
                int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                int size = 10;

                if (!VALID_SORTS.contains(sort) && !Arrays.asList("weekly", "monthly", "alltime").contains(sort)) {
                    sort = "newest";
                    LOGGER.warning("Invalid sort parameter, defaulting to newest");
                }
                if (!VALID_FILTERS.contains(filter)) {
                    filter = "all";
                    LOGGER.warning("Invalid filter parameter, defaulting to all");
                }
                if (page < 1) {
                    page = 1;
                    LOGGER.warning("Invalid page parameter, defaulting to 1");
                }

                List<ForumPost> posts = postDAO.getPostsSortedAndFiltered(sort, filter, search, page, size);

                // Get viewed posts for current user
                Set<Integer> viewedPostIds = null;
                try {
                    viewedPostIds = postViewDAO.getViewedPostIds(userId);
                    LOGGER.info("Retrieved " + viewedPostIds.size() + " viewed posts for user " + userId);
                } catch (SQLException e) {
                    LOGGER.warning("Could not get viewed posts: " + e.getMessage());
                    viewedPostIds = new java.util.HashSet<>();
                }

                request.setAttribute("posts", posts);
                request.setAttribute("viewedPostIds", viewedPostIds);
                request.setAttribute("sort", sort);
                request.setAttribute("filter", filter);
                request.setAttribute("page", page);
                request.setAttribute("search", search);

                LOGGER.info("Forwarding to /view/forum/forum.jsp with sort: " + sort + ", filter: " + filter + ", search: " + search + ", page: " + page + ", timeFrame: " + timeFrame);
                request.getRequestDispatcher("/view/forum/forum.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.severe("Database error in doGet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cơ sở dữ liệu: " + e.getMessage());
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid post ID format: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID bài viết không hợp lệ");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error in doGet: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi không xác định: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ForumServlet doPost called for URL: " + request.getServletPath());
        
        // Check authentication first
        if (!checkAuthentication(request, response)) {
            return;
        }
        
        String action = request.getServletPath();

        if ("/forum/createPost".equals(action)) {
            handleCreatePost(request, response);
        } else if ("/forum/deletePost".equals(action)) {
            handleDeletePost(request, response);
        }
    }
    
    private void handleCreatePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String userId = UserAuthentication.getUserID(session);
            UserAccount user = (UserAccount) session.getAttribute("user");

            if (userId == null || user == null) {
                LOGGER.warning("User session invalid during post creation");
                redirectToLogin(request, response);
                return;
            }
            
            // Check create post permission
            if (!ForumPermissionService.hasPermission(user, ForumPermissions.PERM_CREATE_POSTS)) {
                request.getSession().setAttribute("message", "Bạn không có quyền tạo bài viết!");
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }
            
            LOGGER.info("Creating post for user: " + user.getUsername() + " (ID: " + userId + ")");

            String title = request.getParameter("postTitle");
            String content = request.getParameter("postContent");
            String category = request.getParameter("postCategory");
            
            if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()
                    || category == null || category.trim().isEmpty()) {
                request.getSession().setAttribute("message", "Tiêu đề, nội dung và chủ đề không được để trống");
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }
            
            // Check if user can post in this category
            if (!ForumPermissionService.canPostInCategory(user, category)) {
                request.getSession().setAttribute("message", "Bạn không có quyền đăng bài trong chuyên mục này!");
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }

            // Handle image upload through repository
            String imageUrl = null;
            Part filePart = request.getPart("imageInput");
            if (filePart != null && filePart.getSize() > 0) {
                try {
                    imageUrl = imageRepository.uploadPostImage(filePart, userId);
                    if (imageUrl == null) {
                        request.getSession().setAttribute("message", "Lỗi khi tải lên hình ảnh!");
                        response.sendRedirect(request.getContextPath() + "/forum");
                        return;
                    }
                    LOGGER.info("Uploaded image to S3: " + imageUrl);
                } catch (Exception e) {
                    LOGGER.severe("Error uploading image: " + e.getMessage());
                    request.getSession().setAttribute("message", "Lỗi khi tải lên hình ảnh!");
                    response.sendRedirect(request.getContextPath() + "/forum");
                    return;
                }
            }

            ForumPost post = new ForumPost();
            post.setTitle(title);
            post.setContent(content);
            post.setPostedBy(userId);
            post.setCreatedDate(new Timestamp(System.currentTimeMillis()));
            post.setCategory(category);
            post.setPicture(imageUrl);
            post.setViewCount(0);
            post.setVoteCount(0);

            postDAO.createPost(post);

            request.getSession().setAttribute("message", "Bài viết đã được tạo thành công!");
            LOGGER.info("Post created successfully by user: " + user.getUsername());
            response.sendRedirect(request.getContextPath() + "/forum");
        } catch (SQLException e) {
            LOGGER.severe("Database error in handleCreatePost: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi cơ sở dữ liệu khi tạo bài viết");
            response.sendRedirect(request.getContextPath() + "/forum");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error in handleCreatePost: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi không xác định khi tạo bài viết");
            response.sendRedirect(request.getContextPath() + "/forum");
        }
    }
    
    private void handleDeletePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            String userId = UserAuthentication.getUserID(session);
            UserAccount user = (UserAccount) session.getAttribute("user");

            if (userId == null || user == null) {
                LOGGER.warning("User session invalid during post deletion");
                redirectToLogin(request, response);
                return;
            }

            int postId = Integer.parseInt(request.getParameter("postId"));
            
            // Get the post to check permissions
            ForumPost post = postDAO.getPostById(postId);
            if (post == null) {
                request.getSession().setAttribute("message", "Bài viết không tồn tại!");
                response.sendRedirect(request.getContextPath() + "/forum");
                return;
            }
            
            // Check delete permission
            if (!ForumPermissionService.canDeletePost(user, post)) {
                request.getSession().setAttribute("message", "Bạn không có quyền xóa bài viết này!");
                response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
                return;
            }
            
            // Delete image from S3 if exists
            if (post.getPicture() != null && !post.getPicture().isEmpty()) {
                try {
                    imageRepository.deleteImage(post.getPicture());
                    LOGGER.info("Deleted image from S3: " + post.getPicture());
                } catch (Exception e) {
                    LOGGER.warning("Could not delete image from S3: " + e.getMessage());
                }
            }
            
            boolean deleted = postDAO.deletePost(postId, userId);
            if (deleted) {
                request.getSession().setAttribute("message", "Xóa bài viết thành công!");
                response.sendRedirect(request.getContextPath() + "/forum");
            } else {
                request.getSession().setAttribute("message", "Không thể xóa bài viết!");
                response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
            }
        } catch (NumberFormatException e) {
            LOGGER.severe("Invalid post ID when deleting: " + e.getMessage());
            request.getSession().setAttribute("message", "ID bài viết không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/forum");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error when deleting post: " + e.getMessage());
            request.getSession().setAttribute("message", "Lỗi không xác định khi xóa bài viết!");
            response.sendRedirect(request.getContextPath() + "/forum");
        }
    }
}
