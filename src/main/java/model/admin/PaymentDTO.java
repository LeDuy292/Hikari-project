package model.admin;

import java.sql.Timestamp;
import java.util.List;

public class PaymentDTO extends Payment {
    private String studentName;
    private String courseNames;
    private String courseIDs; // String concatenated IDs for display

    // Default constructor
    public PaymentDTO() {
        super();
    }

    // Constructor with Payment object
    public PaymentDTO(Payment payment) {
        super();
        this.setId(payment.getId());
        this.setStudentID(payment.getStudentID());
        this.setCartID(payment.getCartID());
        this.setAmount(payment.getAmount());
        this.setPaymentMethod(payment.getPaymentMethod());
        this.setPaymentStatus(payment.getPaymentStatus());
        this.setPaymentDate(payment.getPaymentDate());
        this.setTransactionID(payment.getTransactionID());
        this.setStudentName(payment.getStudentName());
        this.setCourseName(payment.getCourseName());
        this.setCourseIDs(payment.getCourseIDs());
    }

    // Getters and Setters for additional fields
    @Override
    public String getStudentName() { 
        return studentName != null ? studentName : super.getStudentName(); 
    }
    
    @Override
    public void setStudentName(String studentName) { 
        this.studentName = studentName; 
        super.setStudentName(studentName);
    }
    
    public String getCourseNames() { return courseNames; }
    public void setCourseNames(String courseNames) { this.courseNames = courseNames; }
    
    // For concatenated course IDs as string
    public String getCourseIDsAsString() { return courseIDs; }
    public void setCourseIDsAsString(String courseIDs) { this.courseIDs = courseIDs; }
    
    // Alternative getter name for JavaScript compatibility
    public void setCourseIDs(String courseIDs) { this.courseIDs = courseIDs; }
    
}