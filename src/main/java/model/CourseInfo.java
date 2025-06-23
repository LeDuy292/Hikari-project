package model;

public class CourseInfo {
    private int id;
    private int courseId;
    private String overview;
    private String objectives;
    private String levelDescription;
    private String tuitionInfo;
    private String duration;

    // Constructors
    public CourseInfo() {}

    public CourseInfo(int courseId, String overview, String objectives, 
                     String levelDescription, String tuitionInfo, String duration) {
        this.courseId = courseId;
        this.overview = overview;
        this.objectives = objectives;
        this.levelDescription = levelDescription;
        this.tuitionInfo = tuitionInfo;
        this.duration = duration;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getOverview() { return overview; }
    public void setOverview(String overview) { this.overview = overview; }

    public String getObjectives() { return objectives; }
    public void setObjectives(String objectives) { this.objectives = objectives; }

    public String getLevelDescription() { return levelDescription; }
    public void setLevelDescription(String levelDescription) { this.levelDescription = levelDescription; }

    public String getTuitionInfo() { return tuitionInfo; }
    public void setTuitionInfo(String tuitionInfo) { this.tuitionInfo = tuitionInfo; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }
}
