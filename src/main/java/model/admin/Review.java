package model.admin;

import java.util.Date;

public class Review {
    private int id;
    private String courseID;
    private String userID;
    private int rating;
    private String reviewText;
    private Date reviewDate;
    
    // Additional fields for display
    private String reviewerName;
    private String courseName;
    private String instructorName;

    public Review() {}

    public Review(String courseID, String userID, int rating, String reviewText) {
        this.courseID = courseID;
        this.userID = userID;
        this.rating = rating;
        this.reviewText = reviewText;
        this.reviewDate = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCourseID() { return courseID; }
    public void setCourseID(String courseID) { this.courseID = courseID; }

    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }

    public Date getReviewDate() { return reviewDate; }
    public void setReviewDate(Date reviewDate) { this.reviewDate = reviewDate; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }
}
