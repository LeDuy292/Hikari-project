package model;

public class Answer {
    private int questionId;
private String  studentID ; 
private int testId ;
    private String studentAnswer;
    private String correctAnswer;
    private double score;
    private boolean correct;
    private boolean answered;

    // Constructor

    public Answer(int questionId, String studentID, int testId, String studentAnswer, String correctAnswer, double score, boolean correct, boolean answered) {
        this.questionId = questionId;
        this.studentID = studentID;
        this.testId = testId;
        this.studentAnswer = studentAnswer;
        this.correctAnswer = correctAnswer;
        this.score = score;
        this.correct = correct;
        this.answered = answered;
    }

    
   

    // Getters and Setters
    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

  

    public String getStudentAnswer() {
        return studentAnswer;
    }

    public void setStudentAnswer(String studentAnswer) {
        this.studentAnswer = studentAnswer;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    public boolean isAnswered() {
        return answered;
    }

    public void setAnswered(boolean answered) {
        this.answered = answered;
    }
}