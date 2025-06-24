package model.student;

public class Commitment {
    private int id;
    private String courseId; // Changed from int to String
    private String title;
    private String description;
    private String icon;
    private String imageUrl;
    private int displayOrder;

    // Constructors
    public Commitment() {}

    public Commitment(String courseId, String title, String description, 
                     String icon, String imageUrl, int displayOrder) {
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.icon = icon;
        this.imageUrl = imageUrl;
        this.displayOrder = displayOrder;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getCourseId() { return courseId; }
    public void setCourseId(String courseId) { this.courseId = courseId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
}
