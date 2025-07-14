/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.coordinator;

import java.sql.Date;

public class Lesson {

    private int id;
    private String teacherID;
    private String topicID;
    private String topicName;
    private String title;
    private String description;
    private String mediaUrl;
    private int duration;
    private boolean isCompleted;
    private boolean isActive;
    private String teacherName;

    public Lesson(int id, String teacherID, String topicID, String topicName, String title, String description, String mediaUrl, int duration, boolean isCompleted, boolean isActive) {
        this.id = id;
        this.teacherID = teacherID;
        this.topicID = topicID;
        this.topicName = topicName;
        this.title = title;
        this.description = description;
        this.mediaUrl = mediaUrl;
        this.duration = duration;
        this.isCompleted = isCompleted;
        this.isActive = isActive;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTeacherID() {
        return teacherID;
    }

    public void setTeacherID(String teacherID) {
        this.teacherID = teacherID;
    }

    public String getTopicID() {
        return topicID;
    }

    public void setTopicID(String topicID) {
        this.topicID = topicID;
    }

    public String getTopicName() {
        return topicName;
    }

    public void setTopicName(String topicName) {
        this.topicName = topicName;
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

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public boolean isIsCompleted() {
        return isCompleted;
    }

    public void setIsCompleted(boolean isCompleted) {
        this.isCompleted = isCompleted;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
    
    
    @Override
    public String toString() {
        return "Lesson{" + "id=" + id + ", teacherID=" + teacherID + ", topicID=" + topicID + ", topicName=" + topicName + ", title=" + title + ", description=" + description + ", mediaUrl=" + mediaUrl + ", duration=" + duration + ", isCompleted=" + isCompleted + ", isActive=" + isActive + '}';
    }
}
