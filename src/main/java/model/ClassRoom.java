/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class ClassRoom {
    private String classID;
    private String courseID;
    private String name;
    private String teacherID;
    private int numberOfStudents;

    public ClassRoom() {}

    public ClassRoom(String classID, String courseID, String name, String teacherID, int numberOfStudents) {
        this.classID = classID;
        this.courseID = courseID;
        this.name = name;
        this.teacherID = teacherID;
        this.numberOfStudents = numberOfStudents;
    }

    

    // Getters and Setters
    
    public String getCourseID() { return courseID; }
    public void setCourseID(String courseID) { this.courseID = courseID; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getTeacherID() { return teacherID; }
    public void setTeacherID(String teacherID) { this.teacherID = teacherID; }

    public String getClassID() {
        return classID;
    }

    public void setClassID(String classID) {
        this.classID = classID;
    }

    public int getNumberOfStudents() {
        return numberOfStudents;
    }

    public void setNumberOfStudents(int numberOfStudents) {
        this.numberOfStudents = numberOfStudents;
    }

    @Override
    public String toString() {
        return "ClassRoom{" + "classID=" + classID + ", courseID=" + courseID + ", name=" + name + ", teacherID=" + teacherID + ", numberOfStudents=" + numberOfStudents + '}';
    }
    
}