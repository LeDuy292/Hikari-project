package model.admin;

import java.util.Date;
import java.util.List;

public class Payment {
    private int id;
    private String studentID;
    private int cartID; // Thay đổi từ String enrollmentID sang int cartID
    private double amount;
        private List<String> courseIDs;
    private String paymentMethod;
    private String paymentStatus;
    private Date paymentDate;
    private String transactionID;
    
    // Additional fields for display
    private String studentName;
    private String courseName;

    public Payment() {}

    public Payment(String studentID, int cartID, double amount, String paymentMethod, String paymentStatus) {
        this.studentID = studentID;
        this.cartID = cartID; // Thay đổi
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.paymentDate = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getStudentID() { return studentID; }
    public void setStudentID(String studentID) { this.studentID = studentID; }

    // Thay đổi từ enrollmentID sang cartID
    public int getCartID() { return cartID; }
    public void setCartID(int cartID) { this.cartID = cartID; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }

    public String getTransactionID() { return transactionID; }
    public void setTransactionID(String transactionID) { this.transactionID = transactionID; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public List<String> getCourseIDs() {
        return courseIDs;
    }

    public void setCourseIDs(List<String> courseIDs) {
        this.courseIDs = courseIDs;
    }

    
    
    @Override
    public String toString() {
        return "Payment{" +
                "id=" + id +
                ", studentID='" + studentID + '\'' +
                ", cartID=" + cartID +
                ", amount=" + amount +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", paymentDate=" + paymentDate +
                ", transactionID='" + transactionID + '\'' +
                ", studentName='" + studentName + '\'' +
                ", courseName='" + courseName + '\'' +
                '}';
    }
}

