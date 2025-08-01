package model.coordinator;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


/**
 *
 * @author LENOVO
 */
import java.sql.Timestamp;

public class TaskReview {
    private int id;
    private String courseID;
    private Integer testID;
    private String entityTitle;
    private String reviewerID;
    private String reviewerName;
    private int rating;
    private String reviewText;
    private String reviewStatus;
    private Timestamp reviewDate;
    
    // Constructors
    public TaskReview() {}
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCourseID() { return courseID; }
    public void setCourseID(String courseID) { this.courseID = courseID; }
    
    public Integer getTestID() { return testID; }
    public void setTestID(Integer testID) { this.testID = testID; }
    
    public String getEntityTitle() { return entityTitle; }
    public void setEntityTitle(String entityTitle) { this.entityTitle = entityTitle; }
    
    public String getReviewerID() { return reviewerID; }
    public void setReviewerID(String reviewerID) { this.reviewerID = reviewerID; }
    
    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
    
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    
    public String getReviewText() { return reviewText; }
    public void setReviewText(String reviewText) { this.reviewText = reviewText; }
    
    public String getReviewStatus() { return reviewStatus; }
    public void setReviewStatus(String reviewStatus) { this.reviewStatus = reviewStatus; }
    
    public Timestamp getReviewDate() { return reviewDate; }
    public void setReviewDate(Timestamp reviewDate) { this.reviewDate = reviewDate; }
}