package model;

import java.sql.Date;

public class Progress {
    private int progressID;
    private String studentID;
    private int lessonID;
    private String completionStatus;
    private Date startDate;
    private Date endDate;
    private int score;
    private String feedback;
    
    // Additional lesson information
    private String lessonTitle;
    private String topicName;
    private String  topicID;
    private String lessonDescription;
    private int duration;

    // Constructors
    public Progress() {}

    public Progress(String studentID, int lessonID, String completionStatus) {
        this.studentID = studentID;
        this.lessonID = lessonID;
        this.completionStatus = completionStatus;
    }

    // Getters and Setters
    public int getProgressID() {
        return progressID;
    }

    public void setProgressID(int progressID) {
        this.progressID = progressID;
    }

    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public int getLessonID() {
        return lessonID;
    }

    public void setLessonID(int lessonID) {
        this.lessonID = lessonID;
    }

    public String getCompletionStatus() {
        return completionStatus;
    }

    public void setCompletionStatus(String completionStatus) {
        this.completionStatus = completionStatus;
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

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String getLessonTitle() {
        return lessonTitle;
    }

    public void setLessonTitle(String lessonTitle) {
        this.lessonTitle = lessonTitle;
    }

    public String getTopicName() {
        return topicName;
    }

    public void setTopicName(String topicName) {
        this.topicName = topicName;
    }

    public String getTopicID() {
        return topicID;
    }

    public void setTopicID(String topicID) {
        this.topicID = topicID;
    }

    public String getLessonDescription() {
        return lessonDescription;
    }

    public void setLessonDescription(String lessonDescription) {
        this.lessonDescription = lessonDescription;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    @Override
    public String toString() {
        return "Progress{" +
                "progressID=" + progressID +
                ", studentID='" + studentID + '\'' +
                ", lessonID=" + lessonID +
                ", completionStatus='" + completionStatus + '\'' +
                ", score=" + score +
                '}';
    }
}
