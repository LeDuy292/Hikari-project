package model;

import java.util.List;


public class Exercise {

    private int id;
    private int lessonID;
    private String title;
    private String description;
    private boolean isActive;
    private List<Question> questions;
    
    public Exercise() {
    }

    public Exercise(int id, int lessonID, String title, String description, boolean isActive, List<Question> questions) {
        this.id = id;
        this.lessonID = lessonID;
        this.title = title;
        this.description = description;
        this.isActive = isActive;
        this.questions = questions;
    }

    public Exercise(int id, int lessonID, String title, String description, boolean isActive) {
        this.id = id;
        this.lessonID = lessonID;
        this.title = title;
        this.description = description;
        this.isActive = isActive;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public List<Question> getQuestions() {
        return questions;
    }

    public void setQuestions(List<Question> questions) {
        this.questions = questions;
    }

    // Getters and Setters
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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "Exercise{" + "id=" + id + ", lessonID=" + lessonID + ", title=" + title + ", description=" + description + ", isActive=" + isActive + ", questions=" + questions + '}';
    }
    
}
