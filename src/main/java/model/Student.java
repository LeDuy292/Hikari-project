package model;

import java.sql.Date;
import java.time.LocalDate;

public class Student {
    private int studentNum;
    private String studentID;
    private String userID;
    private Date enrollmentDate;
    private int vote;
    
    // Default constructor
    public Student() {
        this.enrollmentDate = Date.valueOf(LocalDate.now());
        this.vote = 0;
    }
    
    // Constructor with userID
    public Student(String userID) {
        this();
        this.userID = userID;
    }
    
    // Full constructor
    public Student(int studentNum, String studentID, String userID, Date enrollmentDate, int vote) {
        this.studentNum = studentNum;
        this.studentID = studentID;
        this.userID = userID;
        this.enrollmentDate = enrollmentDate;
        this.vote = vote;
    }
    
    // Getters and Setters
    public int getStudentNum() {
        return studentNum;
    }
    
    public void setStudentNum(int studentNum) {
        this.studentNum = studentNum;
    }
    
    public String getStudentID() {
        return studentID;
    }
    
    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }
    
    public String getUserID() {
        return userID;
    }
    
    public void setUserID(String userID) {
        this.userID = userID;
    }
    
    public Date getEnrollmentDate() {
        return enrollmentDate;
    }
    
    public void setEnrollmentDate(Date enrollmentDate) {
        this.enrollmentDate = enrollmentDate;
    }
    
    public int getVote() {
        return vote;
    }
    
    public void setVote(int vote) {
        this.vote = vote;
    }
    
    @Override
    public String toString() {
        return "Student{" +
                "studentNum=" + studentNum +
                ", studentID='" + studentID + '\'' +
                ", userID='" + userID + '\'' +
                ", enrollmentDate=" + enrollmentDate +
                ", vote=" + vote +
                '}';
    }
}
