package model.forum;

import java.sql.Timestamp;
import java.util.List;

public class ForumPost {
    private int id;
    private String title;
    private String content;
    private String postedBy;
    private Timestamp createdDate;
    private String category;
    private int viewCount;
    private int voteCount;
    private String picture;
    private String status;
    private String moderatedBy;
    private Timestamp moderatedDate;
    private int commentCount;
    private List<ForumComment> comments;

    // Constructors
    public ForumPost() {}

    public ForumPost(int id, String title, String content, String postedBy, 
                    Timestamp createdDate, String category, int viewCount, 
                    int voteCount, String picture) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.postedBy = postedBy;
        this.createdDate = createdDate;
        this.category = category;
        this.viewCount = viewCount;
        this.voteCount = voteCount;
        this.picture = picture;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getPostedBy() {
        return postedBy;
    }

    public void setPostedBy(String postedBy) {
        this.postedBy = postedBy;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getViewCount() {
        return viewCount;
    }

    public void setViewCount(int viewCount) {
        this.viewCount = viewCount;
    }

    public int getVoteCount() {
        return voteCount;
    }

    public void setVoteCount(int voteCount) {
        this.voteCount = voteCount;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getModeratedBy() {
        return moderatedBy;
    }

    public void setModeratedBy(String moderatedBy) {
        this.moderatedBy = moderatedBy;
    }

    public Timestamp getModeratedDate() {
        return moderatedDate;
    }

    public void setModeratedDate(Timestamp moderatedDate) {
        this.moderatedDate = moderatedDate;
    }

    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public List<ForumComment> getComments() {
        return comments;
    }

    public void setComments(List<ForumComment> comments) {
        this.comments = comments;
    }

    // Status helper methods
    public boolean isPinned() {
        return "PINNED".equals(this.status);
    }

    public boolean isHidden() {
        return "HIDDEN".equals(this.status);
    }

    public boolean isActive() {
        return this.status == null || "ACTIVE".equals(this.status);
    }

    public boolean isDeleted() {
        return "DELETED".equals(this.status);
    }
}
