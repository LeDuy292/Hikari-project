package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Represents a Course entity with attributes such as course number, ID, title, description, fee, duration,
 * start and end dates, active status, image URL, progress, class count, instructor, category, and created date.
 *
 * @author LENOVO
 */
public class Course {
    private int courseNum;
    private String courseID;
    private String title;
    private String description;
    private BigDecimal fee;
    private int duration;
    private Date startDate;
    private Date endDate;
    private boolean isActive;
    private String imageUrl;
    private BigDecimal progress;
    private int classCount;
    private String instructor;
    private String category;
    private Timestamp createdDate;

    // Constructors

    /**
     * Default constructor for creating an empty Course object.
     */
    public Course() {
    }

    /**
     * Constructor with required fields except progress, classCount, instructor, category, and createdDate.
     *
     * @param courseNum   the unique course number
     * @param courseID    the unique course identifier
     * @param title       the course title
     * @param description the course description
     * @param fee         the course fee
     * @param duration    the course duration in days
     * @param startDate   the course start date
     * @param endDate     the course end date
     * @param isActive    the active status of the course
     * @param imageUrl    the URL of the course image
     */
    public Course(int courseNum, String courseID, String title, String description, BigDecimal fee, 
                  int duration, Date startDate, Date endDate, boolean isActive, String imageUrl) {
        this.courseNum = courseNum;
        this.courseID = courseID;
        this.title = title;
        this.description = description;
        this.fee = fee;
        this.duration = duration;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public int getCourseNum() {
        return courseNum;
    }

    public void setCourseNum(int courseNum) {
        this.courseNum = courseNum;
    }

    public String getCourseID() {
        return courseID;
    }

    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getFee() {
        return fee;
    }

    public void setFee(BigDecimal fee) {
        this.fee = fee;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public BigDecimal getProgress() {
        return progress;
    }

    public void setProgress(BigDecimal progress) {
        this.progress = progress;
    }

    public int getClassCount() {
        return classCount;
    }

    public void setClassCount(int classCount) {
        this.classCount = classCount;
    }

    public String getInstructor() {
        return instructor;
    }

    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "Course{" + "courseNum=" + courseNum + ", courseID=" + courseID + ", title=" + title + 
               ", description=" + description + ", fee=" + fee + ", duration=" + duration + 
               ", startDate=" + startDate + ", endDate=" + endDate + ", isActive=" + isActive + 
               ", imageUrl=" + imageUrl + ", progress=" + progress + ", classCount=" + classCount + 
               ", instructor=" + instructor + ", category=" + category + ", createdDate=" + createdDate + '}';
    }
}