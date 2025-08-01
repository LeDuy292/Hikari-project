package model.coordinator;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


/**
 *
 * @author LENOVO
 */
import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int id;
    private String coordinatorID;
    private String teacherID;
    private String teacherName;
    private String courseID;
    private String courseName;
    private Integer testID;
    private String jlptLevel;
    private Timestamp assignedDate;
    private Date deadline;
    private String description;
    private String status;
    
    // Constructors
    public Task() {}
    
    public Task(String coordinatorID, String teacherID, String courseID, Integer testID, 
                Date deadline, String description) {
        this.coordinatorID = coordinatorID;
        this.teacherID = teacherID;
        this.courseID = courseID;
        this.testID = testID;
        this.deadline = deadline;
        this.description = description;
        this.status = "Assigned";
        this.assignedDate = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCoordinatorID() { return coordinatorID; }
    public void setCoordinatorID(String coordinatorID) { this.coordinatorID = coordinatorID; }
    
    public String getTeacherID() { return teacherID; }
    public void setTeacherID(String teacherID) { this.teacherID = teacherID; }
    
    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }
    
    public String getCourseID() { return courseID; }
    public void setCourseID(String courseID) { this.courseID = courseID; }
    
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    
    public Integer getTestID() { return testID; }
    public void setTestID(Integer testID) { this.testID = testID; }
    
    public String getJlptLevel() { return jlptLevel; }
    public void setJlptLevel(String jlptLevel) { this.jlptLevel = jlptLevel; }
    
    public Timestamp getAssignedDate() { return assignedDate; }
    public void setAssignedDate(Timestamp assignedDate) { this.assignedDate = assignedDate; }
    
    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    // Helper methods
    public boolean isCourseTask() {
        return courseID != null && !courseID.isEmpty();
    }
    
    public boolean isTestTask() {
        return testID != null;
    }
    
    public boolean isOverdue() {
        return deadline != null && deadline.before(new Date(System.currentTimeMillis()));
    }
}