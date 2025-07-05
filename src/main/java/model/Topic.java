package model;

import java.util.Date;


public class Topic {

    private String topicId;
    private String topicName;
    private String description;
    private int orderIndex;
    private boolean isActive;
    private Date createdDate;
    private String courseId;

    public Topic(String topicId, String topicName, String description, int orderIndex,
            boolean isActive, Date createdDate, String courseId) {
        this.topicId = topicId;
        this.topicName = topicName;
        this.description = description;
        this.orderIndex = orderIndex;
        this.isActive = isActive;
        this.createdDate = createdDate;
        this.courseId = courseId;
    }

    // Getters
    public String getTopicId() {
        return topicId;
    }

    public String getTopicName() {
        return topicName;
    }

    public String getDescription() {
        return description;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public boolean isActive() {
        return isActive;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public String getCourseId() {
        return courseId;
    }
}
