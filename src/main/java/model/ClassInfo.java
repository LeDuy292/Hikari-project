package model;

import java.util.Date;

public class ClassInfo {
    private String classID;
    private String courseID;
    private String name;
    private String teacherID;
    private Date startDate;
    private Date endDate;
    
    // Course information
    private String courseTitle;
    private String courseDescription;
    private int courseDuration;
    private String courseLevel;
    
    // Teacher information
    private String teacherName;
    private String teacherSpecialization;
    private String teacherEmail;
    
    // Statistics
    private int numberOfStudents;
    private int completedLessons;
    private int totalLessons;
    private double averageProgress;

    // Constructors
    public ClassInfo() {}

    public ClassInfo(String classID, String courseID, String name, String teacherID) {
        this.classID = classID;
        this.courseID = courseID;
        this.name = name;
        this.teacherID = teacherID;
    }

    // Getters and Setters
    public String getClassID() {
        return classID;
    }

    public void setClassID(String classID) {
        this.classID = classID;
    }

    public String getCourseID() {
        return courseID;
    }

    public void setCourseID(String courseID) {
        this.courseID = courseID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTeacherID() {
        return teacherID;
    }

    public void setTeacherID(String teacherID) {
        this.teacherID = teacherID;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }


    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getCourseDescription() {
        return courseDescription;
    }

    public void setCourseDescription(String courseDescription) {
        this.courseDescription = courseDescription;
    }

    public int getCourseDuration() {
        return courseDuration;
    }

    public void setCourseDuration(int courseDuration) {
        this.courseDuration = courseDuration;
    }

    public String getCourseLevel() {
        return courseLevel;
    }

    public void setCourseLevel(String courseLevel) {
        this.courseLevel = courseLevel;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public String getTeacherSpecialization() {
        return teacherSpecialization;
    }

    public void setTeacherSpecialization(String teacherSpecialization) {
        this.teacherSpecialization = teacherSpecialization;
    }

    public String getTeacherEmail() {
        return teacherEmail;
    }

    public void setTeacherEmail(String teacherEmail) {
        this.teacherEmail = teacherEmail;
    }

    public int getNumberOfStudents() {
        return numberOfStudents;
    }

    public void setNumberOfStudents(int numberOfStudents) {
        this.numberOfStudents = numberOfStudents;
    }

    public int getCompletedLessons() {
        return completedLessons;
    }

    public void setCompletedLessons(int completedLessons) {
        this.completedLessons = completedLessons;
    }

    public int getTotalLessons() {
        return totalLessons;
    }

    public void setTotalLessons(int totalLessons) {
        this.totalLessons = totalLessons;
    }

    public double getAverageProgress() {
        return averageProgress;
    }

    public void setAverageProgress(double averageProgress) {
        this.averageProgress = averageProgress;
    }

    @Override
    public String toString() {
        return "ClassInfo{" +
                "classID='" + classID + '\'' +
                ", name='" + name + '\'' +
                ", courseTitle='" + courseTitle + '\'' +
                ", teacherName='" + teacherName + '\'' +
                ", numberOfStudents=" + numberOfStudents +
                '}';
    }
}
