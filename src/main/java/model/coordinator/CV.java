package model.coordinator;

import java.util.Date;

public class CV {

    private int cvID;
    private String userID;
    private String fullName;
    private String email;
    private String phone;
    private String fileUrl;
    private Date uploadDate;
    private String status;
    private String reviewerID;
    private Date reviewDate;
    private String comments;

    public CV() {
    }

    public CV(int cvID, String userID, String fullName, String email, String phone, String fileUrl,
            Date uploadDate, String status, String reviewerID, Date reviewDate, String comments) {
        this.cvID = cvID;
        this.userID = userID;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.fileUrl = fileUrl;
        this.uploadDate = uploadDate;
        this.status = status;
        this.reviewerID = reviewerID;
        this.reviewDate = reviewDate;
        this.comments = comments;
    }

    public int getCvID() {
        return cvID;
    }

    public void setCvID(int cvID) {
        this.cvID = cvID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public Date getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Date uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReviewerID() {
        return reviewerID;
    }

    public void setReviewerID(String reviewerID) {
        this.reviewerID = reviewerID;
    }

    public Date getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Date reviewDate) {
        this.reviewDate = reviewDate;
    }

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }
}
