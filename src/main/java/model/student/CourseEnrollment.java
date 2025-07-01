
package model.student;

import java.sql.Date;

public class CourseEnrollment {
    private String enrollmentID;
    private String studentID;
    private String courseID;
    private Date enrollmentDate;
    private Date completionDate;
    
    // Additional fields for display
    private String courseTitle;
    private String courseDescription;
    private String courseImageUrl;
    private double courseFee;
    private int courseDuration;
    private int progressPercentage;
    private String status;

    // Constructors
    public CourseEnrollment() {}

    public CourseEnrollment(String enrollmentID, String studentID, String courseID, 
                           Date enrollmentDate, Date completionDate) {
        this.enrollmentID = enrollmentID;
        this.studentID = studentID;
        this.courseID = courseID;
        this.enrollmentDate = enrollmentDate;
        this.completionDate = completionDate;
    }

    // Getters and Setters
    public String getEnrollmentID() {
        return enrollmentID;
    }

    public void setEnrollmentID(String enrollmentID) {
        this.enrollmentID = enrollmentID;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public String getCourseID() {
        return courseID;
    }

    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    public Date getEnrollmentDate() {
        return enrollmentDate;
    }

    public void setEnrollmentDate(Date enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }

    public Date getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(Date completionDate) {
        this.completionDate = completionDate;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getCourseDescription() {
        return courseDescription;
    }

    public void setCourseDescription(String courseDescription) {
        this.courseDescription = courseDescription;
    }

    public String getCourseImageUrl() {
        return courseImageUrl;
    }

    public void setCourseImageUrl(String courseImageUrl) {
        this.courseImageUrl = courseImageUrl;
    }

    public double getCourseFee() {
        return courseFee;
    }

    public void setCourseFee(double courseFee) {
        this.courseFee = courseFee;
    }

    public int getCourseDuration() {
        return courseDuration;
    }

    public void setCourseDuration(int courseDuration) {
        this.courseDuration = courseDuration;
    }

    public int getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(int progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public String getStatus() {
        return status != null ? status : (isCompleted() ? "completed" : (progressPercentage > 0 ? "in-progress" : "not-started"));
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Helper methods
    public boolean isCompleted() {
        return completionDate != null;
    }

    public String getStatusDisplay() {
        if (isCompleted()) {
            return "Đã hoàn thành";
        } else if (progressPercentage > 0) {
            return "Đang học";
        } else {
            return "Chưa bắt đầu";
        }
    }

}
