package dao.forum;

import utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.forum.ForumComment;
import model.forum.ForumPost;

public class ForumPostDAO {

    private static final Logger LOGGER = Logger.getLogger(ForumPostDAO.class.getName());
    private final DBContext dbContext;
    private final ForumCommentDAO commentDAO;

    public ForumPostDAO() {
        this.dbContext = new DBContext();
        this.commentDAO = new ForumCommentDAO();
    }

    public List<ForumPost> getAllPosts() throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        String query = "SELECT id, title, content, postedBy, createdDate, category, viewCount, voteCount, picture, isPinned, isHidden, moderatedBy, moderatedDate FROM ForumPost WHERE status IS NULL OR status != 'DELETED' ORDER BY isPinned DESC, createdDate DESC";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ForumPost post = new ForumPost();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setPostedBy(rs.getString("postedBy"));
                post.setCreatedDate(rs.getTimestamp("createdDate"));
                post.setCategory(rs.getString("category"));
                post.setViewCount(rs.getInt("viewCount"));
                post.setVoteCount(rs.getInt("voteCount"));
                post.setPicture(rs.getString("picture"));
                post.setPinned(rs.getBoolean("isPinned"));
                post.setHidden(rs.getBoolean("isHidden"));
                post.setModeratedBy(rs.getString("moderatedBy"));
                post.setModeratedDate(rs.getTimestamp("moderatedDate"));
                posts.add(post);
            }
        }
        return posts;
    }

    public List<ForumPost> getPostsSortedAndFiltered(String sort, String filter, String search, int page, int size, String userId, Set<Integer> viewedPostIds) throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT fp.id, fp.title, fp.content, fp.postedBy, fp.createdDate, fp.category, fp.viewCount, fp.voteCount, fp.picture, fp.status, fp.isPinned, ua.username AS postedByUsername "
                + "FROM ForumPost fp LEFT JOIN UserAccount ua ON fp.postedBy = ua.userID "
        );
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        // Only show active or pinned posts
        conditions.add("(fp.status IS NULL OR fp.status = 'ACTIVE' OR fp.status = 'PINNED')");
        conditions.add("fp.isHidden = 0");

        // Handle search by title
        if (search != null && !search.trim().isEmpty()) {
            conditions.add("fp.title LIKE ?");
            parameters.add("%" + search.trim() + "%");
        }

        // Handle filter conditions
        if ("with-replies".equals(filter)) {
            conditions.add("fp.id IN (SELECT postID FROM ForumComment)");
        } else if ("no-replies".equals(filter)) {
            conditions.add("fp.id NOT IN (SELECT postID FROM ForumComment)");
        }

        // Combine conditions
        if (!conditions.isEmpty()) {
            query.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
        }

        // Handle sorting
        query.append("ORDER BY ");
        query.append("fp.isPinned DESC, "); // Pinned posts come first
        if (viewedPostIds != null && !viewedPostIds.isEmpty()) {
            query.append("CASE WHEN fp.id IN (").append(String.join(",", viewedPostIds.stream().map(String::valueOf).toArray(String[]::new))).append(") THEN 1 ELSE 0 END, ");
        } else {
            query.append("0, "); // No viewed posts, treat all as unread
        }
        if ("newest".equals(sort)) {
            query.append("fp.createdDate DESC ");
        } else if ("popular".equals(sort)) {
            query.append("fp.viewCount DESC ");
        } else if ("most-liked".equals(sort)) {
            query.append("fp.voteCount DESC ");
        } else {
            query.append("fp.createdDate DESC ");
        }
        query.append("LIMIT ? OFFSET ?");

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            // Set parameters
            int paramIndex = 1;
            for (Object param : parameters) {
                stmt.setObject(paramIndex++, param);
            }
            stmt.setInt(paramIndex++, size);
            stmt.setInt(paramIndex, (page - 1) * size);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumPost post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));
                    post.setStatus(rs.getString("status"));
                    post.setPinned(rs.getBoolean("isPinned"));

                    String commentCountQuery = "SELECT COUNT(*) AS commentCount FROM ForumComment WHERE postID = ?";
                    try (PreparedStatement countStmt = conn.prepareStatement(commentCountQuery)) {
                        countStmt.setInt(1, post.getId());
                        try (ResultSet countRs = countStmt.executeQuery()) {
                            if (countRs.next()) {
                                post.setCommentCount(countRs.getInt("commentCount"));
                            }
                        }
                    }

                    post.setComments(commentDAO.getCommentsByPostId(post.getId()));
                    posts.add(post);
                }
                LOGGER.info("Retrieved " + posts.size() + " posts for user: " + userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving posts: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return posts;
    }

    public ForumPost getPostById(int postId) throws SQLException {
        ForumPost post = null;
        String query = "SELECT fp.id, fp.title, fp.content, fp.postedBy, fp.createdDate, fp.category, fp.viewCount, fp.voteCount, fp.picture, fp.status, fp.isPinned, fp.isHidden, fp.moderatedBy, fp.moderatedDate, ua.username AS postedByUsername "
                + "FROM ForumPost fp LEFT JOIN UserAccount ua ON fp.postedBy = ua.userID WHERE fp.id = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));
                    post.setStatus(rs.getString("status"));
                    post.setPinned(rs.getBoolean("isPinned"));
                    post.setHidden(rs.getBoolean("isHidden"));
                    post.setModeratedBy(rs.getString("moderatedBy"));
                    post.setModeratedDate(rs.getTimestamp("moderatedDate"));

                    String commentCountQuery = "SELECT COUNT(*) AS commentCount FROM ForumComment WHERE postID = ?";
                    try (PreparedStatement countStmt = conn.prepareStatement(commentCountQuery)) {
                        countStmt.setInt(1, post.getId());
                        try (ResultSet countRs = countStmt.executeQuery()) {
                            if (countRs.next()) {
                                post.setCommentCount(countRs.getInt("commentCount"));
                            }
                        }
                    }

                    post.setComments(commentDAO.getCommentsByPostId(post.getId()));
                }
                LOGGER.info("Retrieved post with ID: " + postId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving post: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return post;
    }

    public void incrementViewCount(int postId) throws SQLException {
        String query = "UPDATE ForumPost SET viewCount = viewCount + 1 WHERE id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            stmt.executeUpdate();
            LOGGER.info("Incremented view count for post ID: " + postId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error incrementing view count: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }

    public void addLike(int postId, String userId) throws SQLException {
        String checkQuery = "SELECT COUNT(*) FROM ForumCommentVote WHERE commentID IS NULL AND postID = ? AND userID = ?";
        String insertQuery = "INSERT INTO ForumCommentVote (postID, userID, voteValue, voteDate) VALUES (?, ?, 1, NOW())";
        String updateQuery = "UPDATE ForumPost SET voteCount = voteCount + 1 WHERE id = ?";

        Connection conn = dbContext.getConnection();
        try {
            conn.setAutoCommit(false);

            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setInt(1, postId);
                checkStmt.setString(2, userId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        conn.rollback();
                        LOGGER.info("User " + userId + " has already liked post ID: " + postId);
                        return;
                    }
                }
            }

            try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                insertStmt.setInt(1, postId);
                insertStmt.setString(2, userId);
                insertStmt.executeUpdate();
            }

            try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                updateStmt.setInt(1, postId);
                updateStmt.executeUpdate();
            }

            conn.commit();
            LOGGER.info("Added like for post ID: " + postId + " by user: " + userId);
        } catch (SQLException e) {
            conn.rollback();
            LOGGER.log(Level.SEVERE, "Error adding like: " + e.getMessage(), e);
            throw e;
        } finally {
            conn.setAutoCommit(true);
            dbContext.closeConnection();
        }
    }

    public void removeLike(int postId, String userId) throws SQLException {
        String deleteQuery = "DELETE FROM ForumCommentVote WHERE commentID IS NULL AND postID = ? AND userID = ?";
        String updateQuery = "UPDATE ForumPost SET voteCount = voteCount - 1 WHERE id = ?";

        Connection conn = dbContext.getConnection();
        try {
            conn.setAutoCommit(false);

            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
                deleteStmt.setInt(1, postId);
                deleteStmt.setString(2, userId);
                deleteStmt.executeUpdate();
            }

            try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                updateStmt.setInt(1, postId);
                updateStmt.executeUpdate();
            }

            conn.commit();
            LOGGER.info("Removed like for post ID: " + postId + " by user: " + userId);
        } catch (SQLException e) {
            conn.rollback();
            LOGGER.log(Level.SEVERE, "Error removing like: " + e.getMessage(), e);
            throw e;
        } finally {
            conn.setAutoCommit(true);
            dbContext.closeConnection();
        }
    }

    public boolean hasUserLikedPost(int postId, String userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM ForumCommentVote WHERE commentID IS NULL AND postID = ? AND userID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, postId);
            stmt.setString(2, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking like status: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return false;
    }

    public void createPost(ForumPost post) throws SQLException {
        String query = "INSERT INTO ForumPost (title, content, postedBy, createdDate, category, viewCount, voteCount, picture, status, isPinned) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, post.getTitle());
            stmt.setString(2, post.getContent());
            stmt.setString(3, post.getPostedBy());
            stmt.setTimestamp(4, post.getCreatedDate());
            stmt.setString(5, post.getCategory());
            stmt.setInt(6, post.getViewCount());
            stmt.setInt(7, post.getVoteCount());
            stmt.setString(8, post.getPicture());
            stmt.setString(9, "ACTIVE");
            stmt.setBoolean(10, false); // Default isPinned to false
            stmt.executeUpdate();
            LOGGER.info("Created new post: " + post.getTitle());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating post: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }

    public boolean updatePost(ForumPost post) {
        String sql = "UPDATE ForumPost SET title = ?, content = ?, category = ?, picture = ? WHERE id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setString(3, post.getCategory());
            ps.setString(4, post.getPicture());
            ps.setInt(5, post.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating post: " + e.getMessage(), e);
            return false;
        }
    }

    public boolean deletePost(int postId, String userId) {
        String sql = "UPDATE ForumPost SET status = 'DELETED', moderatedBy = ?, moderatedDate = NOW() WHERE id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting post: " + e.getMessage(), e);
            return false;
        }
    }

    public boolean hidePost(int postId, String moderatorId) {
        String sql = "UPDATE ForumPost SET status = 'HIDDEN', isHidden = 1, moderatedBy = ?, moderatedDate = NOW() WHERE id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, moderatorId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error hiding post: " + e.getMessage(), e);
            return false;
        }
    }

    public boolean showPost(int postId, String moderatorId) {
        String sql = "UPDATE ForumPost SET status = 'ACTIVE', isHidden = 0, moderatedBy = ?, moderatedDate = NOW() WHERE id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, moderatorId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error showing post: " + e.getMessage(), e);
            return false;
        }
    }

    public boolean pinPost(int postId, String moderatorId) {
        String sql = "UPDATE ForumPost SET status = 'PINNED', isPinned = 1, moderatedBy = ?, moderatedDate = NOW() WHERE id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, moderatorId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error pinning post: " + e.getMessage(), e);
            return false;
        }
    }

    public boolean unpinPost(int postId, String moderatorId) {
        String sql = "UPDATE ForumPost SET status = 'ACTIVE', isPinned = 0, moderatedBy = ?, moderatedDate = NOW() WHERE id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, moderatorId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unpinning post: " + e.getMessage(), e);
            return false;
        }
    }

    public List<ForumPost> getRelatedPosts(int postId, String category, int limit) throws SQLException {
        List<ForumPost> related = new ArrayList<>();
        String query = "SELECT id, title, content, postedBy, createdDate, category, viewCount, voteCount, picture, status, isPinned "
                + "FROM ForumPost WHERE category = ? AND id <> ? AND (status IS NULL OR status = 'ACTIVE') AND isHidden = 0 ORDER BY createdDate DESC LIMIT ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, category);
            stmt.setInt(2, postId);
            stmt.setInt(3, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumPost post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));
                    post.setStatus(rs.getString("status"));
                    post.setPinned(rs.getBoolean("isPinned"));
                    related.add(post);
                }
            }
        } finally {
            dbContext.closeConnection();
        }
        return related;
    }

    public void createComment(ForumComment comment) throws SQLException {
        String query = "INSERT INTO ForumComment (postID, commentText, commentedBy, commentedDate, voteCount) "
                + "VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, comment.getPostID());
            stmt.setString(2, comment.getCommentText());
            stmt.setString(3, comment.getCommentedBy());
            stmt.setTimestamp(4, comment.getCommentedDate());
            stmt.setInt(5, comment.getVoteCount());
            stmt.executeUpdate();
            LOGGER.info("Created new comment for postID: " + comment.getPostID() + " by user: " + comment.getCommentedBy());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating comment: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
    }

    public List<ForumPost> getPostsByUserId(String userId, int limit) throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        String query = "SELECT id, title, content, postedBy, createdDate, category, viewCount, voteCount, picture, status, isPinned "
                + "FROM ForumPost WHERE postedBy = ? AND (status IS NULL OR status = 'ACTIVE') AND isHidden = 0 ORDER BY createdDate DESC LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, userId);
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumPost post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));
                    post.setStatus(rs.getString("status"));
                    post.setPinned(rs.getBoolean("isPinned"));

                    String commentCountQuery = "SELECT COUNT(*) AS commentCount FROM ForumComment WHERE postID = ?";
                    try (PreparedStatement countStmt = conn.prepareStatement(commentCountQuery)) {
                        countStmt.setInt(1, post.getId());
                        try (ResultSet countRs = countStmt.executeQuery()) {
                            if (countRs.next()) {
                                post.setCommentCount(countRs.getInt("commentCount"));
                            }
                        }
                    }

                    posts.add(post);
                }
                LOGGER.info("Retrieved " + posts.size() + " posts for user: " + userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving posts for user: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return posts;
    }

    public List<ForumPost> getRecentPostsForModeration(int limit) throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        String query = "SELECT fp.id, fp.title, fp.content, fp.postedBy, fp.createdDate, fp.category, fp.viewCount, fp.voteCount, fp.picture, fp.status, fp.isPinned, fp.isHidden, fp.moderatedBy, fp.moderatedDate, ua.username AS postedByUsername "
                + "FROM ForumPost fp LEFT JOIN UserAccount ua ON fp.postedBy = ua.userID "
                + "WHERE fp.isHidden = 0 ORDER BY fp.isPinned DESC, fp.createdDate DESC LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumPost post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));
                    post.setStatus(rs.getString("status"));
                    post.setPinned(rs.getBoolean("isPinned"));
                    post.setHidden(rs.getBoolean("isHidden"));
                    post.setModeratedBy(rs.getString("moderatedBy"));
                    post.setModeratedDate(rs.getTimestamp("moderatedDate"));
                    posts.add(post);
                }
                LOGGER.info("Retrieved " + posts.size() + " posts for moderation");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving posts for moderation: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }
        return posts;
    }

    public List<ForumPost> getHiddenOrPinnedPosts(int limit) throws SQLException {
        List<ForumPost> posts = new ArrayList<>();

        String query = "SELECT "
                + "id, title, content, postedBy, createdDate, category, "
                + "viewCount, voteCount, picture, status, isPinned, isHidden, "
                + "moderatedBy, moderatedDate "
                + "FROM ForumPost "
                + "WHERE (isHidden = 1 OR isPinned = 1) "
                + "AND (status IS NULL OR status != 'DELETED') "
                + "ORDER BY isPinned DESC, isHidden DESC, moderatedDate DESC "
                + "LIMIT ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ForumPost post = new ForumPost();
                    post.setId(rs.getInt("id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setPostedBy(rs.getString("postedBy"));
                    post.setCreatedDate(rs.getTimestamp("createdDate"));
                    post.setCategory(rs.getString("category"));
                    post.setViewCount(rs.getInt("viewCount"));
                    post.setVoteCount(rs.getInt("voteCount"));
                    post.setPicture(rs.getString("picture"));
                    post.setStatus(rs.getString("status"));
                    post.setPinned(rs.getBoolean("isPinned"));
                    post.setHidden(rs.getBoolean("isHidden"));
                    post.setModeratedBy(rs.getString("moderatedBy"));
                    post.setModeratedDate(rs.getTimestamp("moderatedDate"));

                    posts.add(post);
                }
                LOGGER.info("Retrieved " + posts.size() + " hidden or pinned posts for moderation");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving hidden or pinned posts: " + e.getMessage(), e);
            throw e;
        } finally {
            dbContext.closeConnection();
        }

        return posts;
    }

}
