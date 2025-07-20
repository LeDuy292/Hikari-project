package model;

public class Test {

    private int id;
    private String jlptLevel;
    private String title;
    private String description;
    private double totalMarks;
    private int totalQuestions;
    private boolean isActive;
    private int duration;

    public Test() {
    }

    public Test(int id, String jlptLevel, String title, String description, double totalMarks, int totalQuestions, boolean isActive, int duration) {
        this.id = id;
        this.jlptLevel = jlptLevel;
        this.title = title;
        this.description = description;
        this.totalMarks = totalMarks;
        this.totalQuestions = totalQuestions;
        this.isActive = isActive;
        this.duration = duration;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getJlptLevel() {
        return jlptLevel;
    }

    public void setJlptLevel(String jlptLevel) {
        this.jlptLevel = jlptLevel;
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

    public double getTotalMarks() {
        return totalMarks;
    }

    public void setTotalMarks(double totalMarks) {
        this.totalMarks = totalMarks;
    }

    public int getTotalQuestions() {
        return totalQuestions;
    }

    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "Test{" + "id=" + id + ", jlptLevel=" + jlptLevel + ", title=" + title + ", description=" + description + ", totalMarks=" + totalMarks + ", totalQuestions=" + totalQuestions + ", isActive=" + isActive + ", duration=" + duration + '}';
    }

}
