package model;

import java.util.List;

public class Lesson {
    private int id;
    private String topicID;
    private String title;
    private String description;
    private String mediaUrl;
    private boolean isCompleted;
    private String teacherID;
    private List<Document> documents; // Thêm thuộc tính này
    private List<Exercise> exercises;
    // Constructors
    public Lesson() {}

    public Lesson(int id, String topicID, String title, String description, String mediaUrl, boolean isCompleted, String teacherID) {
        this.id = id;
        this.topicID = topicID;
        this.title = title;
        this.description = description;
        this.mediaUrl = mediaUrl;
        this.isCompleted = isCompleted;
        this.teacherID = teacherID;
    }

    
public String getTeacherID() {
        return teacherID;
    }

    public void setTeacherID(String teacherID) {
        this.teacherID = teacherID;
    }
    public boolean isIsCompleted() {
        return isCompleted;
    }

    public void setIsCompleted(boolean isCompleted) {
        this.isCompleted = isCompleted;
    }  

    // Getters and Setters
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

    public String getMediaUrl() {
        return mediaUrl;
    }

    public void setMediaUrl(String mediaUrl) {
        this.mediaUrl = mediaUrl;
    }

    public List<Document> getDocuments() {
        return documents;
    }

    public void setDocuments(List<Document> documents) {
        this.documents = documents;
    }

    public List<Exercise> getExercises() {
        return exercises;
    }

    public void setExercises(List<Exercise> exercises) {
        this.exercises = exercises;
    }



    @Override
    public String toString() {
        return "Lesson{" + "id=" + id + ", topicID=" + topicID  + ", title=" + title + ", description=" + description + ", mediaUrl=" + mediaUrl + ", isCompleted=" + isCompleted + '}';
    }

   
}
