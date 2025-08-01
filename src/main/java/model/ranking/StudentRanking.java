package model.ranking;

public class StudentRanking {
    private String studentID;
    private String studentName;
    private String profilePicture;
    private double averageScore;
    private int testCount;
    private String jlptLevels;
    private int rank;
    
    // Constructors
    public StudentRanking() {}
    
    public StudentRanking(String studentID, String studentName, double averageScore, int testCount) {
        this.studentID = studentID;
        this.studentName = studentName;
        this.averageScore = averageScore;
        this.testCount = testCount;
    }
    
    // Getters and Setters
    public String getStudentID() { return studentID; }
    public void setStudentID(String studentID) { this.studentID = studentID; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getProfilePicture() { return profilePicture; }
    public void setProfilePicture(String profilePicture) { this.profilePicture = profilePicture; }
    
    public double getAverageScore() { return averageScore; }
    public void setAverageScore(double averageScore) { this.averageScore = averageScore; }
    
    public int getTestCount() { return testCount; }
    public void setTestCount(int testCount) { this.testCount = testCount; }
    
    public String getJlptLevels() { return jlptLevels; }
    public void setJlptLevels(String jlptLevels) { this.jlptLevels = jlptLevels; }
    
    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }
    
    @Override
    public String toString() {
        return "StudentRanking{" +
                "studentID='" + studentID + '\'' +
                ", studentName='" + studentName + '\'' +
                ", averageScore=" + averageScore +
                ", testCount=" + testCount +
                ", jlptLevels='" + jlptLevels + '\'' +
                ", rank=" + rank +
                '}';
    }
}
