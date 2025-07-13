package model;

public class Result {
    private String studentID;
    private String studentName;
    private int testId;
    private double score;
    private String timeTaken;
    private String status;

    public Result(String studentID, String studentName, int testId, double score, String timeTaken, String status) {
        this.studentID = studentID;
        this.studentName = studentName;
        this.testId = testId;
        this.score = score;
        this.timeTaken = timeTaken;
        this.status = status;
    }

    public Result(String studentID, int testId, double score, String timeTaken, String status) {
        this.studentID = studentID;
        this.testId = testId;
        this.score = score;
        this.timeTaken = timeTaken;
        this.status = status;
    }

   

    // Getters and Setters
    public String getStudentID() {
        return studentID;
    }

    public void setStudentID(String studentID) {
        this.studentID = studentID;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public int getTestId() {
        return testId;
    }

    public void setTestId(int testId) {
        this.testId = testId;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public String getTimeTaken() {
        return timeTaken;
    }

    public void setTimeTaken(String timeTaken) {
        this.timeTaken = timeTaken;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Result{" + "studentID=" + studentID + ", studentName=" + studentName + ", testId=" + testId + ", score=" + score + ", timeTaken=" + timeTaken + ", status=" + status + '}';
    }
    
}