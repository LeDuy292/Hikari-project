package model.admin;

import java.util.Date;

public class Notification {
    private int id;
    private String title;
    private String content;
    private String type;
    private String recipient;
    private Date sendDate;
    private Date createdDate;
    private String postedBy;
    private boolean isActive;

    public Notification() {}

    public Notification(String title, String content, String type, String recipient, Date sendDate, String postedBy) {
        this.title = title;
        this.content = content;
        this.type = type;
        this.recipient = recipient;
        this.sendDate = sendDate;
        this.postedBy = postedBy;
        this.isActive = true;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getRecipient() { return recipient; }
    public void setRecipient(String recipient) { this.recipient = recipient; }

    public Date getSendDate() { return sendDate; }
    public void setSendDate(Date sendDate) { this.sendDate = sendDate; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

    public String getPostedBy() { return postedBy; }
    public void setPostedBy(String postedBy) { this.postedBy = postedBy; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
