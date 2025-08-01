package model;

import java.util.Date;

public class Review {
    private String reviewID;
    private String userID;
    private String courseID;
    private int rating; // 1-5 stars
    private String reviewText;
    private Date reviewDate;
    private boolean isActive;
    
    // Additional fields for display
    private String username;
    private String fullName;
    private String profilePicture;

    // Constructors
    public Review() {
        this.isActive = true;
    }

    public Review(String userID, String courseID, int rating, String reviewText) {
        this.userID = userID;
        this.courseID = courseID;
        this.rating = rating;
        this.reviewText = reviewText;
        this.reviewDate = new Date();
        this.isActive = true;
    }

    // Getters and Setters
    public String getReviewID() { return reviewID; }
    public void setReviewID(String reviewID) { this.reviewID = reviewID; }

    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }

    public String getCourseID() { return courseID; }
    public void setCourseID(String courseID) { this.courseID = courseID; }

    public int getRating() { return rating; }
    public void setRating(int rating) { 
        if (rating >= 1 && rating <= 5) {
            this.rating = rating; 
        } else {
            throw new IllegalArgumentException("Rating must be between 1 and 5");
        }
    }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { 
        this.reviewText = reviewText != null ? reviewText.trim() : ""; 
    }

    // Backward compatibility
    public String getComment() { return reviewText; }
    public void setComment(String comment) { this.reviewText = comment != null ? comment.trim() : ""; }

    public Date getReviewDate() { return reviewDate; }
    public void setReviewDate(Date reviewDate) { this.reviewDate = reviewDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    // Display fields
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }

    @Override
    public String toString() {
        return "Review{" +
                "reviewID='" + reviewID + '\'' +
                ", userID='" + userID + '\'' +
                ", courseID='" + courseID + '\'' +
                ", rating=" + rating +
                ", reviewText='" + reviewText + '\'' +
                ", reviewDate=" + reviewDate +
                ", isActive=" + isActive +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                '}';
    }
}
