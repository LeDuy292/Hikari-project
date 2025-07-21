package model.admin;

import java.sql.Timestamp;
import java.util.List;

public class PaymentDTO extends Payment {
    private String studentName;
    private String courseNames;

    // Getters and Setters
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public String getCourseNames() { return courseNames; }
    public void setCourseNames(String courseNames) { this.courseNames = courseNames; }
}