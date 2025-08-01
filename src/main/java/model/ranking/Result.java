package model.ranking;

public class Result {
    private String studentID;
    private int testId;
    private double score;
    private String timeTaken;
    private String status;
    private String studentName;
    private String profilePicture;
    private String jlptLevel;
    private String testTitle;
    
    // Constructors
    public Result() {}
    
    public Result(String studentID, int testId, double score, String timeTaken, String status) {
        this.studentID = studentID;
        this.testId = testId;
        this.score = score;
        this.timeTaken = timeTaken;
        this.status = status;
    }
    
    // Getters and Setters
    public String getStudentID() { return studentID; }
    public void setStudentID(String studentID) { this.studentID = studentID; }
    
    public int getTestId() { return testId; }
    public void setTestId(int testId) { this.testId = testId; }
    
    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }
    
    public String getTimeTaken() { return timeTaken; }
    public void setTimeTaken(String timeTaken) { this.timeTaken = timeTaken; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }
    
    public String getJlptLevel() { return jlptLevel; }
    public void setJlptLevel(String jlptLevel) { this.jlptLevel = jlptLevel; }
    
    public String getTestTitle() { return testTitle; }
    public void setTestTitle(String testTitle) { this.testTitle = testTitle; }
    
    @Override
    public String toString() {
        return "Result{" +
                "studentID='" + studentID + '\'' +
                ", testId=" + testId +
                ", score=" + score +
                ", timeTaken='" + timeTaken + '\'' +
                ", status='" + status + '\'' +
                ", studentName='" + studentName + '\'' +
                ", jlptLevel='" + jlptLevel + '\'' +
                ", testTitle='" + testTitle + '\'' +
                '}';
    }
}
