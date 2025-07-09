package model;

public class Lesson {
    private int id;
    private String topicID;
    private String topic;
    private String title;
    private String description;
    private String mediaUrl;
    private int duration;
    private boolean isActive;
    private boolean isCompleted;

    // Constructors
    public Lesson() {}

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public boolean isIsCompleted() {
        return isCompleted;
    }

    public void setIsCompleted(boolean isCompleted) {
        this.isCompleted = isCompleted;
    }

    public Lesson(int id, String topicID, String topic, String title, String description, String mediaUrl, int duration, boolean isActive, boolean isCompleted) {
        this.id = id;
        this.topicID = topicID;
        this.topic = topic;
        this.title = title;
        this.description = description;
        this.mediaUrl = mediaUrl;
        this.duration = duration;
        this.isActive = isActive;
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

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
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

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "Lesson{" + "id=" + id + ", topicID=" + topicID + ", topic=" + topic + ", title=" + title + ", description=" + description + ", mediaUrl=" + mediaUrl + ", duration=" + duration + ", isActive=" + isActive + ", isCompleted=" + isCompleted + '}';
    }

   
}
