package model;

import java.util.List;

public class Assignment {

    private int id;
    private String topicID;
    private String title;
    private String description;
    private double totalMark;
    private int duration;
    private int totalQuestions;
    private boolean isActive;
    private List<Question> questions;

    public List<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }

    public Assignment() {
    }

    public Assignment(int id, String topicID, String title, String description, double totalMark, int duration, int totalQuestions, boolean isActive) {
        this.id = id;
        this.topicID = topicID;
        this.title = title;
        this.description = description;
        this.totalMark = totalMark;
        this.duration = duration;
        this.totalQuestions = totalQuestions;
        this.isActive = isActive;
    }

    public Assignment(int id, String topicID, String title, String description, double totalMark, int duration, int totalQuestions, boolean isActive, List<Question> questions) {
        this.id = id;
        this.topicID = topicID;
        this.title = title;
        this.description = description;
        this.totalMark = totalMark;
        this.duration = duration;
        this.totalQuestions = totalQuestions;
        this.isActive = isActive;
        this.questions = questions;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTopicID() {
        return topicID;
    }

    public void setTopicID(String topicID) {
        this.topicID = topicID;
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

    public double getTotalMark() {
        return totalMark;
    }

    public void setTotalMark(double totalMark) {
        this.totalMark = totalMark;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "Assignment{" + "id=" + id + ", topicID=" + topicID + ", title=" + title + ", description=" + description + ", totalMark=" + totalMark + ", duration=" + duration + ", totalQuestions=" + totalQuestions + ", isActive=" + isActive + '}';
    }

    
}
