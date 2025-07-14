/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.coordinator;

import java.sql.Date;
import java.sql.Timestamp;

public class LessonReviews {

    private int id;
    private int lessonID;
    private String reviewerID;
    private int rating;
    private String reviewText;
    private String reviewStatus;
    private Timestamp reviewDate;

    public LessonReviews(int id, int lessonID, String reviewerID, int rating, String reviewText,
            String reviewStatus, Timestamp reviewDate) {
        this.id = id;
        this.lessonID = lessonID;
        this.reviewerID = reviewerID;
        this.rating = rating;
        this.reviewText = reviewText;
        this.reviewStatus = reviewStatus;
        this.reviewDate = reviewDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getLessonID() {
        return lessonID;
    }

    public void setLessonID(int lessonID) {
        this.lessonID = lessonID;
    }

    public String getReviewerID() {
        return reviewerID;
    }

    public void setReviewerID(String reviewerID) {
        this.reviewerID = reviewerID;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public String getReviewStatus() {
        return reviewStatus;
    }

    public void setReviewStatus(String reviewStatus) {
        this.reviewStatus = reviewStatus;
    }

    public Timestamp getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(Timestamp reviewDate) {
        this.reviewDate = reviewDate;
    }

    @Override
    public String toString() {
        return "LessonReviews{" + "id=" + id + ", lessonID=" + lessonID + ", reviewerID='" + reviewerID + '\''
                + ", rating=" + rating + ", reviewText='" + reviewText + '\'' + ", reviewStatus='" + reviewStatus + '\''
                + ", reviewDate=" + reviewDate + '}';
    }
}
