/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author ADMIN
 */

public class Course {
    private String courseID;
    private String title;
    private String description;
    private double fee;
    private int duration;
    private Date startDate;
    private Date endDate;
    private boolean isActive;
    private String imageUrl;
    private int classCount;

    public Course() {
    }

    public Course(String courseID, String title, String description, double fee, int duration, Date startDate, Date endDate, boolean isActive) {
        this.courseID = courseID;
        this.title = title;
        this.description = description;
        this.fee = fee;
        this.duration = duration;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
    }

    public Course(String courseID, String title, String description, double fee, int duration, Date startDate, Date endDate, boolean isActive, String imageUrl) {
        this.courseID = courseID;
        this.title = title;
        this.description = description;
        this.fee = fee;
        this.duration = duration;
        this.startDate = startDate;
        this.endDate = endDate;
        this.isActive = isActive;
        this.imageUrl = imageUrl;
    }

        public String getCourseID() {
        return courseID;
    }

    public void setCourseID(String courseID) {
        this.courseID = courseID;
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

    public double getFee() {
        return fee;
    }

    public void setFee(double fee) {
        this.fee = fee;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
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

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public int getClassCount() {
        return classCount;
    }

    public void setClassCount(int classCount) {
        this.classCount = classCount;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "Course{" + "courseID=" + courseID + ", title=" + title + ", description=" + description + ", fee=" + fee + ", duration=" + duration + ", startDate=" + startDate + ", endDate=" + endDate + ", isActive=" + isActive + ", imageUrl=" + imageUrl + '}';
    }
    
  
}
