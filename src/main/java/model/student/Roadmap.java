package model.student;

public class Roadmap {
    private int id;
    private String courseId; // Changed from int to String
    private int stepNumber;
    private String title;
    private String description;
    private String duration;

    // Constructors
    public Roadmap() {}

    public Roadmap(String courseId, int stepNumber, String title, 
                  String description, String duration) {
        this.courseId = courseId;
        this.stepNumber = stepNumber;
        this.title = title;
        this.description = description;
        this.duration = duration;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

    public int getStepNumber() { return stepNumber; }
    public void setStepNumber(int stepNumber) { this.stepNumber = stepNumber; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
}
