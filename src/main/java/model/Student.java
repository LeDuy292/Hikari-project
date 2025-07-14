package model;

import java.util.Date;

public class Student {
    private String studentID;
    private String userID;
    private Date enrollmentDate;
    private int vote;

    // Constructors
    public Student() {}

    public Student(String studentID, String userID, Date enrollmentDate, int vote) {
        this.studentID = studentID;
        this.userID = userID;
        this.enrollmentDate = enrollmentDate;
        this.vote = vote;
    }

    // Getters and Setters
    public String getStudentID() { return studentID; }
    public void setStudentID(String studentID) { this.studentID = studentID; }
    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }
    public Date getEnrollmentDate() { return enrollmentDate; }
    public void setEnrollmentDate(Date enrollmentDate) { this.enrollmentDate = enrollmentDate; }
    public int getVote() { return vote; }
    public void setVote(int vote) { this.vote = vote; }

    @Override
    public String toString() {
        return "Student{" +
               "studentID='" + studentID + '\'' +
               ", userID='" + userID + '\'' +
               ", enrollmentDate=" + enrollmentDate +
               ", vote=" + vote +
               '}';
    }
}