package controller.forum;

import dao.forum.ForumPostDAO;
import dao.forum.UserActivityScoreDAO;
import dao.UserDAO;
import dao.forum.PostViewDAO;
import model.forum.ForumPost;
import model.forum.UserActivityScore;
import authentication.UserAuthentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
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

    private static final List<String> VALID_SORTS = Arrays.asList("newest", "popular", "most-liked");
    private static final List<String> VALID_FILTERS = Arrays.asList("all", "with-replies", "no-replies");

    @Override
    public void init() throws ServletException {
        postDAO = new ForumPostDAO();
        scoreDAO = new UserActivityScoreDAO();
        userDAO = new UserDAO();
        postViewDAO = new PostViewDAO();
        LOGGER.info("ForumServlet initialized");
    }

    /**
     * Check if user is authenticated using existing UserAuthentication utility
     */
    private boolean checkAuthentication(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        // In the checkAuthentication method, replace the UserAuthentication check with:
        // Check authentication using session attributes directly
        String userId = (String) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (userId == null || username == null || user == null) {
            LOGGER.info("User not authenticated, redirecting to login");
            // Store the original URL they were trying to access
            String originalUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                originalUrl += "?" + request.getQueryString();
            }
            
            // Create session if doesn't exist to store redirect URL
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("redirectUrl", originalUrl);
            
            response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            return false;
        }
        
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("ForumServlet doGet called for URL: " + request.getRequestURI());
        
        // Check authentication first
        if (!checkAuthentication(request, response)) {
            return; // User not authenticated, already redirected
        }
        
        try {
            String pathInfo = request.getPathInfo();
            HttpSession session = request.getSession();
            
            // Get user information using existing authentication system
            String userId = UserAuthentication.getUserID(session);
            String userRole = UserAuthentication.getUserRole(session);

            // Also get the UserAccount object stored in session for compatibility
            UserAccount user = (UserAccount) session.getAttribute("user");

            if (userId == null || user == null) {
                LOGGER.warning("User session invalid, redirecting to login");
                response.sendRedirect(request.getContextPath() + "/view/login.jsp");
                return;
            }
            
            // Get full user information from database
            //UserAccount user = userDAO.getUserByUserID(userId);
            //if (user == null) {
            //    LOGGER.warning("User not found in database: " + userId);
            //    response.sendRedirect(request.getContextPath() + "/view/login.jsp");
            //    return;
            //}
            
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
            return; // User not authenticated, already redirected
        }
        
        String action = request.getServletPath();

        if ("/forum/createPost".equals(action)) {
            try {
                HttpSession session = request.getSession();
                String userId = UserAuthentication.getUserID(session);
                UserAccount user = (UserAccount) session.getAttribute("user");

                if (userId == null || user == null) {
                    LOGGER.warning("User session invalid during post creation");
                    response.sendRedirect(request.getContextPath() + "/view/login.jsp");
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

                Part filePart = request.getPart("imageInput");
                String fileName = null;
                if (filePart != null && filePart.getSize() > 0) {
                    String contentType = filePart.getContentType();
                    if (!contentType.startsWith("image/")) {
                        request.getSession().setAttribute("message", "Chỉ hỗ trợ hình ảnh");
                        response.sendRedirect(request.getContextPath() + "/forum");
                        return;
                    }
                    fileName = System.currentTimeMillis() + "_" + extractFileName(filePart);
                    String uploadPath = getServletContext().getRealPath("") + File.separator + "Uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    filePart.write(uploadPath + File.separator + fileName);
                    fileName = "Uploads/" + fileName;
                    LOGGER.info("Uploaded file: " + fileName);
                }

                ForumPost post = new ForumPost();
                post.setTitle(title);
                post.setContent(content);
                post.setPostedBy(userId);
                post.setCreatedDate(new Timestamp(System.currentTimeMillis()));
                post.setCategory(category);
                post.setPicture(fileName);
                post.setViewCount(0);
                post.setVoteCount(0);

                postDAO.createPost(post);

                request.getSession().setAttribute("message", "Bài viết đã được tạo thành công!");
                LOGGER.info("Post created successfully by user: " + user.getUsername());
                response.sendRedirect(request.getContextPath() + "/forum");
            } catch (SQLException e) {
                LOGGER.severe("Database error in doPost: " + e.getMessage());
                request.getSession().setAttribute("message", "Lỗi cơ sở dữ liệu khi tạo bài viết");
                response.sendRedirect(request.getContextPath() + "/forum");
            } catch (Exception e) {
                LOGGER.severe("Unexpected error in doPost: " + e.getMessage());
                request.getSession().setAttribute("message", "Lỗi không xác định khi tạo bài viết");
                response.sendRedirect(request.getContextPath() + "/forum");
            }
        } else if ("/forum/deletePost".equals(action)) {
            try {
                HttpSession session = request.getSession();
                String userId = UserAuthentication.getUserID(session);
                String userRole = UserAuthentication.getUserRole(session);

                if (userId == null) {
                    LOGGER.warning("User session invalid during post deletion");
                    response.sendRedirect(request.getContextPath() + "/view/login.jsp");
                    return;
                }

                int postId = Integer.parseInt(request.getParameter("postId"));
                
                // Check if user has permission to delete (owner or admin)
                ForumPost post = postDAO.getPostById(postId);
                boolean canDelete = false;
                
                if (post != null) {
                    // User can delete if they are the owner or an admin
                    canDelete = post.getPostedBy().equals(userId) || 
                               (userRole != null && userRole.toLowerCase().contains("admin"));
                }
                
                if (canDelete) {
                    boolean deleted = postDAO.deletePost(postId, userId);
                    if (deleted) {
                        request.getSession().setAttribute("message", "Xóa bài viết thành công!");
                        response.sendRedirect(request.getContextPath() + "/forum");
                    } else {
                        request.getSession().setAttribute("message", "Không thể xóa bài viết!");
                        response.sendRedirect(request.getContextPath() + "/forum/post/" + postId);
                    }
                } else {
                    request.getSession().setAttribute("message", "Bạn không có quyền xóa bài viết này!");
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

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
