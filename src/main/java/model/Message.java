package model;


import java.time.LocalDate;
import java.util.Date;

public class Message {
    private String sender;
    private String receiver;
    private String content;
    private Date timestamp;

    // Getters và Setters
    public String getSender() { return sender; }
    public void setSender(String sender) { this.sender = sender; }
    public String getReceiver() { return receiver; }
    public void setReceiver(String receiver) { this.receiver = receiver; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Date getTimestamp() { return timestamp; }
    public void setTimestamp(Date timestamp) { this.timestamp = timestamp; }

    @Override
    public String toString() {
        return "Message{" + "sender=" + sender + ", receiver=" + receiver + ", content=" + content + ", timestamp=" + timestamp + '}';
    }

}