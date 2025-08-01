package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.ContactService;
import utils.ValidationUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Enhanced Servlet to handle contact form submissions
 * Includes comprehensive validation and error handling
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    
    private final ContactService contactService;
    private final Gson gson;
    
    public ContactServlet() {
        this.contactService = new ContactService();
        this.gson = new Gson();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to contact form page
        request.getRequestDispatcher("/view/student/contact.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Get parameters with null safety
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String issueType = request.getParameter("issueType");
        String message = request.getParameter("message");
            
        System.out.println("=== DEBUG CONTACT ===");
        System.out.println("Name: [" + (name != null ? name : "NULL") + "]");
        System.out.println("Email: [" + (email != null ? email : "NULL") + "]");
        System.out.println("Phone: [" + (phone != null ? phone : "NULL") + "]");
        System.out.println("IssueType: [" + (issueType != null ? issueType : "NULL") + "]");
        System.out.println("Message: [" + (message != null ? message : "NULL") + "]");

        // Check for null parameters first
        if (name == null || email == null || phone == null || issueType == null || message == null) {
            System.err.println("One or more parameters are null!");
            
            // Check if this is an AJAX request
            String contentType = request.getContentType();
            if (contentType != null && contentType.contains("application/json")) {
                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false, \"message\":\"Dữ liệu không hợp lệ! Vui lòng thử lại.\"}");
                out.flush();
            } else {
                // Traditional form submission - redirect with error
                request.setAttribute("error", "Dữ liệu không hợp lệ! Vui lòng thử lại.");
                request.getRequestDispatcher("/view/student/contact.jsp").forward(request, response);
            }
            return;
        }

        // Validate data before processing
        ValidationResult validation = validateContactData(name, email, phone, issueType, message);
        if (!validation.isValid()) {
            System.out.println("Validation failed: " + validation.getErrorMessage());
            
            // Check if this is an AJAX request
            String contentType = request.getContentType();
            if (contentType != null && contentType.contains("application/json")) {
                response.setContentType("application/json; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":false, \"message\":\"" + validation.getErrorMessage() + "\"}");
                out.flush();
            } else {
                // Traditional form submission - redirect with error
                request.setAttribute("error", validation.getErrorMessage());
                request.getRequestDispatcher("/view/student/contact.jsp").forward(request, response);
            }
            return;
        }
            
        System.out.println("Validation passed, submitting contact request...");
        boolean success = contactService.submitContactRequest(name, email, phone, issueType, message);
            
        // Check if this is an AJAX request
        String contentType = request.getContentType();
        if (contentType != null && contentType.contains("application/json")) {
            response.setContentType("application/json; charset=UTF-8");
            PrintWriter out = response.getWriter();
            if (success) {
                out.print("{\"success\":true, \"message\":\"Gửi liên hệ thành công! Chúng tôi sẽ phản hồi sớm nhất.\"}");
            } else {
                out.print("{\"success\":false, \"message\":\"Có lỗi xảy ra, vui lòng thử lại sau!\"}");
            }
            out.flush();
        } else {
            // Traditional form submission - redirect with result
            if (success) {
                request.setAttribute("success", "Gửi liên hệ thành công! Chúng tôi sẽ phản hồi sớm nhất.");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại sau!");
            }
            request.getRequestDispatcher("/view/student/contact.jsp").forward(request, response);
        }
    }
    
    /**
     * Comprehensive validation with detailed error messages
     */
    private ValidationResult validateContactData(String name, String email, String phone, String issueType, String message) {
        // Check for null or empty fields
        if (ValidationUtil.isEmpty(name)) {
            return new ValidationResult(false, "Vui lòng nhập họ và tên!", "name");
        }
        if (ValidationUtil.isEmpty(email)) {
            return new ValidationResult(false, "Vui lòng nhập địa chỉ email!", "email");
        }
        if (ValidationUtil.isEmpty(phone)) {
            return new ValidationResult(false, "Vui lòng nhập số điện thoại!", "phone");
        }
        if (ValidationUtil.isEmpty(issueType)) {
            return new ValidationResult(false, "Vui lòng chọn loại yêu cầu!", "issueType");
        }
        if (ValidationUtil.isEmpty(message)) {
            return new ValidationResult(false, "Vui lòng nhập nội dung yêu cầu!", "message");
        }
        
        // Validate name
        if (!ValidationUtil.isValidName(name.trim())) {
            return new ValidationResult(false, "Họ tên không hợp lệ! Vui lòng nhập từ 2-50 ký tự, chỉ chứa chữ cái.", "name");
        }
        
        // Validate email
        if (!ValidationUtil.isValidContactEmail(email.trim())) {
            return new ValidationResult(false, "Địa chỉ email không hợp lệ! Vui lòng kiểm tra lại.", "email");
        }
        
        // Validate phone
        if (!ValidationUtil.isValidPhone(phone.trim())) {
            return new ValidationResult(false, "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam (10-11 chữ số).", "phone");
        }
        
        // Validate issue type
        if (!ValidationUtil.isValidIssueType(issueType.trim())) {
            return new ValidationResult(false, "Loại yêu cầu không hợp lệ! Vui lòng chọn lại.", "issueType");
        }
        
        // Validate message
        if (!ValidationUtil.isValidMessage(message.trim())) {
            return new ValidationResult(false, "Nội dung yêu cầu phải từ 10-1000 ký tự!", "message");
        }
        
        return new ValidationResult(true, null, null);
    }
    
    /**
     * Get additional information based on issue type
     */
    private String getAdditionalInfo(String issueType) {
        switch (issueType) {
            case "COURSE_ADVICE":
                return "Bạn sẽ nhận được email tư vấn chi tiết và tư vấn viên sẽ gọi trong 24h.";
            case "TECHNICAL_ISSUE":
                return "Đội ngũ kỹ thuật sẽ xử lý trong 2-4 giờ. Bạn có thể thử các bước khắc phục trong email.";
            case "TUITION_SCHEDULE":
                return "Thông tin học phí và lịch học chi tiết đã được gửi qua email.";
            case "PAYMENT_SUPPORT":
                return "Đội hỗ trợ thanh toán sẽ liên hệ trong 1-2 giờ để giải quyết vấn đề.";
            case "OTHER":
                return "Yêu cầu của bạn sẽ được chuyển đến bộ phận chuyên môn xử lý.";
            default:
                return null;
        }
    }
    
    /**
     * Inner class for validation results
     */
    private static class ValidationResult {
        private final boolean valid;
        private final String errorMessage;
        private final String errorField;
        
        public ValidationResult(boolean valid, String errorMessage, String errorField) {
            this.valid = valid;
            this.errorMessage = errorMessage;
            this.errorField = errorField;
        }
        
        public boolean isValid() { return valid; }
        public String getErrorMessage() { return errorMessage; }
        public String getErrorField() { return errorField; }
    }
}
