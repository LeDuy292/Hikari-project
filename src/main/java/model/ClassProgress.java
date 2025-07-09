/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author LENOVO
 */
public class ClassProgress {
        private String classID;
        private String className;
        private int completedLessons;
        private int totalLessons;
        private double completionPercentage;

        // Getters and Setters
        public String getClassID() { return classID; }
        public void setClassID(String classID) { this.classID = classID; }
        public String getClassName() { return className; }
        public void setClassName(String className) { this.className = className; }
        public int getCompletedLessons() { return completedLessons; }
        public void setCompletedLessons(int completedLessons) { this.completedLessons = completedLessons; }
        public int getTotalLessons() { return totalLessons; }
        public void setTotalLessons(int totalLessons) { this.totalLessons = totalLessons; }
        public double getCompletionPercentage() { return completionPercentage; }
        public void setCompletionPercentage(double completionPercentage) { this.completionPercentage = completionPercentage; }
    }
