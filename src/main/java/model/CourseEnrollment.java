package model;

import java.sql.Date;

public class CourseEnrollment {
  private String enrollmentID;
  private String studentID;
  private String courseID;
  private Date enrollmentDate;
  private Date completionDate;

  public CourseEnrollment() {
  }

  public CourseEnrollment(String enrollmentID, String studentID, String courseID, Date enrollmentDate, Date completionDate) {
      this.enrollmentID = enrollmentID;
      this.studentID = studentID;
      this.courseID = courseID;
      this.enrollmentDate = enrollmentDate;
      this.completionDate = completionDate;
  }

  // Getters and Setters
  public String getEnrollmentID() {
      return enrollmentID;
  }

  public void setEnrollmentID(String enrollmentID) {
      this.enrollmentID = enrollmentID;
  }

  public String getStudentID() {
      return studentID;
  }

  public void setStudentID(String studentID) {
      this.studentID = studentID;
  }

  public String getCourseID() {
      return courseID;
  }

  public void setCourseID(String courseID) {
      this.courseID = courseID;
  }

  public Date getEnrollmentDate() {
      return enrollmentDate;
  }

  public void setEnrollmentDate(Date enrollmentDate) {
      this.enrollmentDate = enrollmentDate;
  }

  public Date getCompletionDate() {
      return completionDate;
  }

  public void setCompletionDate(Date completionDate) {
      this.completionDate = completionDate;
  }

  @Override
  public String toString() {
      return "CourseEnrollment{" +
              "enrollmentID='" + enrollmentID + '\'' +
              ", studentID='" + studentID + '\'' +
              ", courseID='" + courseID + '\'' +
              ", courseID='" + courseID + '\'' +
              ", enrollmentDate=" + enrollmentDate +
              ", completionDate=" + completionDate +
              '}';
  }
}
