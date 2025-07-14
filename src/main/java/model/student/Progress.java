package model.student;

import java.util.Date;

public class Progress {
    private int id;
    private String studentID;
    private String enrollmentID;
    private int lessonID;
    private String completionStatus;
    private Date startDate;
    private Date endDate;
    private double score;
    private String feedback;

    // Constructors
    public Progress() {}

    public Progress(int id, String studentID, String enrollmentID, int lessonID, String completionStatus, Date startDate, Date endDate, double score, String feedback) {
        this.id = id;
        this.studentID = studentID;
        this.enrollmentID = enrollmentID;
        this.lessonID = lessonID;
        this.completionStatus = completionStatus;
        this.startDate = startDate;
        this.endDate = endDate;
        this.score = score;
        this.feedback = feedback;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getStudentID() { return studentID; }
    public void setStudentID(String studentID) { this.studentID = studentID; }
    public String getEnrollmentID() { return enrollmentID; }
    public void setEnrollmentID(String enrollmentID) { this.enrollmentID = enrollmentID; }
    public int getLessonID() { return lessonID; }
    public void setLessonID(int lessonID) { this.lessonID = lessonID; }
    public String getCompletionStatus() { return completionStatus; }
    public void setCompletionStatus(String completionStatus) { this.completionStatus = completionStatus; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }
    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    @Override
    public String toString() {
        return "Progress{" +
               "id=" + id +
               ", studentID='" + studentID + '\'' +
               ", enrollmentID='" + enrollmentID + '\'' +
               ", lessonID=" + lessonID +
               ", completionStatus='" + completionStatus + '\'' +
               ", startDate=" + startDate +
               ", endDate=" + endDate +
               ", score=" + score +
               ", feedback='" + feedback + '\'' +
               '}';
    }
}