package model;

import java.sql.Timestamp;

public class Document {

    private int id;
    private int lessonID;
    private String classID;
    private String title;
    private String description;
    private String fileUrl;
    private String imgUrl;
    private Timestamp uploadDate;
    private String uploadedBy;
    

    // Constructor đầy đủ (9 tham số)
    public Document(int id, int lessonID, String classID, String title, String description, String fileUrl, String imgUrl, Timestamp uploadDate, String uploadedBy) {
        this.id = id;
        this.lessonID = lessonID;
        this.classID = classID;
        this.title = title;
        this.description = description;
        this.fileUrl = fileUrl;
        this.imgUrl = imgUrl;
        this.uploadDate = uploadDate;
        this.uploadedBy = uploadedBy;
    }

    // Constructor cho việc tạo mới (6 tham số)
    public Document(String classID, String title, String description, String fileUrl, String uploadedBy, String imgUrl) {
        this.classID = classID;
        this.title = title;
        this.description = description;
        this.fileUrl = fileUrl;
        this.uploadedBy = uploadedBy;
        this.imgUrl = imgUrl;
        this.lessonID = 0; // Default value
        this.uploadDate = new Timestamp(System.currentTimeMillis());
    }

    // Constructor mặc định
    public Document() {
    }

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

    public String getClassID() {
        return classID;
    }

    public void setClassID(String classID) {
        this.classID = classID;
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

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(String uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    @Override
    public String toString() {
        return "Document{" + "id=" + id + ", lessonID=" + lessonID + ", classID=" + classID + ", title=" + title + ", description=" + description + ", fileUrl=" + fileUrl + ", imgUrl=" + imgUrl + ", uploadDate=" + uploadDate + ", uploadedBy=" + uploadedBy + '}';
    }
}
