package model;

import java.util.Date;

/**
 * Model class for Contact requests
 * Represents contact form submissions from users
 */
public class Contact {
    private String contactID;
    private String name;
    private String email;
    private String phone;
    private String issueType;
    private String message;
    private String status;
    private boolean autoReplySent;
    private String coordinatorResponse;
    private String coordinatorId;
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public Contact() {
    }

    public Contact(String contactID, String name, String email, String phone, 
                  String issueType, String message) {
        this.contactID = contactID;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.issueType = issueType;
        this.message = message;
        this.status = "PENDING";
        this.autoReplySent = false;
    }

    public Contact(String contactID, String name, String email, String phone, 
                  String issueType, String message, String status, boolean autoReplySent,
                  String coordinatorResponse, String coordinatorId, Date createdAt, Date updatedAt) {
        this.contactID = contactID;
        this.name = name;
        this.email = email;
        this.phone = phone;
        this.issueType = issueType;
        this.message = message;
        this.status = status;
        this.autoReplySent = autoReplySent;
        this.coordinatorResponse = coordinatorResponse;
        this.coordinatorId = coordinatorId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public String getContactID() {
        return contactID;
    }

    public void setContactID(String contactID) {
        this.contactID = contactID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getIssueType() {
        return issueType;
    }

    public void setIssueType(String issueType) {
        this.issueType = issueType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isAutoReplySent() {
        return autoReplySent;
    }

    public void setAutoReplySent(boolean autoReplySent) {
        this.autoReplySent = autoReplySent;
    }

    public String getCoordinatorResponse() {
        return coordinatorResponse;
    }

    public void setCoordinatorResponse(String coordinatorResponse) {
        this.coordinatorResponse = coordinatorResponse;
    }

    public String getCoordinatorId() {
        return coordinatorId;
    }

    public void setCoordinatorId(String coordinatorId) {
        this.coordinatorId = coordinatorId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper methods
    public String getStatusDisplayName() {
        switch (status) {
            case "PENDING":
                return "Chờ xử lý";
            case "IN_PROGRESS":
                return "Đang xử lý";
            case "RESPONDED":
                return "Đã phản hồi";
            case "CLOSED":
                return "Đã đóng";
            default:
                return status;
        }
    }

    public String getIssueTypeDisplayName() {
        switch (issueType) {
            case "COURSE_ADVICE":
                return "Tư vấn khóa học";
            case "TECHNICAL_ISSUE":
                return "Lỗi kỹ thuật";
            case "TUITION_SCHEDULE":
                return "Học phí/Lịch học";
            case "PAYMENT_SUPPORT":
                return "Hỗ trợ thanh toán";
            case "OTHER":
                return "Khác";
            default:
                return issueType;
        }
    }

    @Override
    public String toString() {
        return "Contact{" +
                "contactID='" + contactID + '\'' +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", issueType='" + issueType + '\'' +
                ", status='" + status + '\'' +
                ", autoReplySent=" + autoReplySent +
                '}';
    }
} 