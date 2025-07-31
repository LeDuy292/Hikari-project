package utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Pattern;

public class ValidationUtil {
   
   // ==================== CÁC METHOD GỐC (GIỮ NGUYÊN) ====================
   
   // Kiểm tra email hợp lệ (bao gồm định dạng cơ bản và độ dài)
   public static boolean isValidEmail(String email) {
       if (email == null || email.trim().isEmpty()) {
           return false;
       }
       if (email.length() > 255) { // Giới hạn độ dài email
           return false;
       }
       String emailRegex = "^[A-Za-z0-9+_.-]+@(.+)$";
       if (!email.matches(emailRegex)) {
           return false;
       }
       return email.contains("@") && email.contains(".");
   }

   // Kiểm tra password hợp lệ (ít nhất 6 ký tự, chứa chữ và số)
   public static boolean isValidPassword(String password) {
       if (password == null || password.trim().isEmpty()) {
           return false;
       }
       if (password.length() < 6 || password.length() > 50) { // Giới hạn độ dài
           return false;
       }
       String passwordRegex = "^(?=.*[0-9])(?=.*[a-zA-Z]).*$";
       return password.matches(passwordRegex);
   }

   // Kiểm tra username hợp lệ (chỉ chữ cái, số, độ dài 3-20 ký tự)
   public static boolean isValidUsername(String username) {
       if (username == null || username.trim().isEmpty()) {
           return false;
       }
       if (username.length() < 3 || username.length() > 20) {
           return false;
       }
       String usernameRegex = "^[a-zA-Z0-9]+$";
       return username.matches(usernameRegex);
   }

   // Kiểm tra fullName hợp lệ (chỉ chữ cái, khoảng trắng, độ dài 2-50 ký tự)
   public static boolean isValidFullName(String fullName) {
       // Cho phép chữ hoa thường có dấu, khoảng trắng giữa các từ
       return fullName != null && fullName.matches("^[\\p{L} ]{2,50}$");
   }

   public static boolean isValidPhoneNumber(String phoneNumber) {
       return phoneNumber != null && phoneNumber.matches("^0\\d{9}$");
   }

   public static boolean isValidDateOfBirth(String dob) {
       if (dob == null || dob.trim().isEmpty()) return false;
       SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
       sdf.setLenient(false);
       try {
           Date date = sdf.parse(dob);
           // Không được chọn ngày trong tương lai
           return date.before(new Date());
       } catch (ParseException e) {
           return false;
       }
   }
   
   // ==================== CÁC METHOD MỚI CHO HỆ THỐNG CONTACT ====================
   
   // Enhanced email validation with more comprehensive regex
   private static final Pattern ENHANCED_EMAIL_PATTERN = Pattern.compile(
       "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$"
   );
   
   // Vietnamese phone number pattern
   private static final Pattern VIETNAMESE_PHONE_PATTERN = Pattern.compile(
       "^(\\+84|84|0)(3[2-9]|5[6|8|9]|7[0|6-9]|8[1-6|8|9]|9[0-4|6-9])[0-9]{7}$"
   );
   
   // Vietnamese name pattern (with accents, cho phép cả tên không dấu, dấu nháy đơn, dấu gạch ngang)
   private static final Pattern VIETNAMESE_NAME_PATTERN = Pattern.compile(
       "^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ\\s'-]{2,50}$"
   );
   
   /**
    * Check if string is null or empty
    */
   public static boolean isEmpty(String str) {
       return str == null || str.trim().isEmpty();
   }
   
   /**
    * Enhanced email validation for contact form
    */
   public static boolean isValidContactEmail(String email) {
       if (isEmpty(email)) {
           return false;
       }
       
       String trimmedEmail = email.trim();
       
       // Check length
       if (trimmedEmail.length() > 255) {
           return false;
       }
       
       // Use enhanced pattern
       return ENHANCED_EMAIL_PATTERN.matcher(trimmedEmail).matches();
   }
   
   /**
    * Validate Vietnamese phone number for contact form
    */
   public static boolean isValidPhone(String phone) {
       if (isEmpty(phone)) {
           return false;
       }
       
       // Remove spaces and dashes
       String cleanPhone = phone.replaceAll("[\\s-]", "");
       
       // Check basic length (10-11 digits for Vietnamese numbers)
       if (cleanPhone.length() < 10 || cleanPhone.length() > 11) {
           return false;
       }
       
       // Check if all characters are digits (after removing +84 prefix)
       String phoneToCheck = cleanPhone;
       if (phoneToCheck.startsWith("+84")) {
           phoneToCheck = "0" + phoneToCheck.substring(3);
       } else if (phoneToCheck.startsWith("84")) {
           phoneToCheck = "0" + phoneToCheck.substring(2);
       }
       
       return phoneToCheck.matches("^0[3-9][0-9]{8}$");
   }
   
   /**
    * Validate Vietnamese name for contact form
    */
   public static boolean isValidName(String name) {
       if (isEmpty(name)) {
           return false;
       }
       
       String trimmedName = name.trim();
       
       // Check length
       if (trimmedName.length() < 2 || trimmedName.length() > 50) {
           return false;
       }
       
       // More flexible regex that allows both Vietnamese and English names
       String flexibleNameRegex = "^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ\\s'-]{2,50}$";
       
       return trimmedName.matches(flexibleNameRegex);
   }
   
   /**
    * Validate issue type for contact form
    */
   public static boolean isValidIssueType(String issueType) {
       if (isEmpty(issueType)) {
           return false;
       }
       
       String[] validTypes = {
           "COURSE_ADVICE", 
           "TECHNICAL_ISSUE", 
           "TUITION_SCHEDULE", 
           "PAYMENT_SUPPORT", 
           "OTHER"
       };
       
       for (String validType : validTypes) {
           if (validType.equals(issueType.trim())) {
               return true;
           }
       }
       
       return false;
   }
   
   /**
    * Validate message content for contact form
    */
   public static boolean isValidMessage(String message) {
       if (isEmpty(message)) {
           return false;
       }
       
       String trimmedMessage = message.trim();
       
       // Check length (10-1000 characters)
       if (trimmedMessage.length() < 10 || trimmedMessage.length() > 1000) {
           return false;
       }
       
       return true;
   }
   
   /**
    * Sanitize input string to prevent XSS
    */
   public static String sanitizeInput(String input) {
       if (input == null) {
           return null;
       }
       
       return input.trim()
                  .replaceAll("<", "&lt;")
                  .replaceAll(">", "&gt;")
                  .replaceAll("\"", "&quot;")
                  .replaceAll("'", "&#x27;")
                  .replaceAll("/", "&#x2F;");
   }
   
   /**
    * Check if string has minimum length
    */
   public static boolean hasMinLength(String str, int minLength) {
       return str != null && str.trim().length() >= minLength;
   }
   
   /**
    * Check if string has maximum length
    */
   public static boolean hasMaxLength(String str, int maxLength) {
       return str != null && str.trim().length() <= maxLength;
   }
   
   /**
    * Validate contact ID format (C001, C002, etc.)
    */
   public static boolean isValidContactId(String contactId) {
       if (contactId == null || contactId.trim().isEmpty()) {
           return false;
       }
       
       return contactId.matches("^C[0-9]{3}$");
   }
   
   /**
    * Format phone number for display
    */
   public static String formatPhoneNumber(String phone) {
       if (phone == null || phone.trim().isEmpty()) {
           return phone;
       }
       
       String cleanPhone = phone.replaceAll("[\\s-]", "");
       
       // Convert to standard format
       if (cleanPhone.startsWith("+84")) {
           cleanPhone = "0" + cleanPhone.substring(3);
       } else if (cleanPhone.startsWith("84")) {
           cleanPhone = "0" + cleanPhone.substring(2);
       }
       
       // Format as 0xxx xxx xxx
       if (cleanPhone.length() == 10) {
           return cleanPhone.substring(0, 4) + " " + 
                  cleanPhone.substring(4, 7) + " " + 
                  cleanPhone.substring(7);
       }
       
       return phone; // Return original if can't format
   }
   
   /**
    * Validate string length within range
    */
   public static boolean isValidLength(String str, int minLength, int maxLength) {
       if (str == null) {
           return false;
       }
       
       int length = str.trim().length();
       return length >= minLength && length <= maxLength;
   }
   
   /**
    * Check if string contains only allowed characters
    */
   public static boolean containsOnlyAllowedChars(String str, String allowedCharsRegex) {
       if (str == null || str.trim().isEmpty()) {
           return false;
       }
       
       return str.matches(allowedCharsRegex);
   }
   
   /**
    * Validate contact data
    */
   public static String validateContactForm(String name, String email, String phone, String issueType, String message) {
       if (!isValidName(name)) {
           return "Họ tên không hợp lệ! Vui lòng nhập từ 2-50 ký tự, chỉ chứa chữ cái.";
       }
       
       if (!isValidContactEmail(email)) {
           return "Địa chỉ email không hợp lệ! Vui lòng kiểm tra lại.";
       }
       
       if (!isValidPhone(phone)) {
           return "Số điện thoại không hợp lệ! Vui lòng nhập số điện thoại Việt Nam (10-11 chữ số).";
       }
       
       if (!isValidIssueType(issueType)) {
           return "Loại yêu cầu không hợp lệ! Vui lòng chọn lại.";
       }
       
       if (!isValidMessage(message)) {
           return "Nội dung yêu cầu phải từ 10-1000 ký tự!";
       }
       
       return null; // No errors
   }
   
   /**
    * Clean and normalize Vietnamese text
    */
   public static String normalizeVietnameseText(String text) {
       if (text == null) {
           return null;
       }
       
       // Remove extra spaces and normalize
       return text.trim().replaceAll("\\s+", " ");
   }
   
   /**
    * Check if email domain is valid
    */
   public static boolean isValidEmailDomain(String email) {
       if (!isValidContactEmail(email)) {
           return false;
       }
       
       String domain = email.substring(email.lastIndexOf("@") + 1);
       
       // Basic domain validation
       return domain.contains(".") && 
              domain.length() > 3 && 
              !domain.startsWith(".") && 
              !domain.endsWith(".");
   }
   
   /**
    * Validate coordinator response content
    */
   public static boolean isValidCoordinatorResponse(String response) {
       if (response == null || response.trim().isEmpty()) {
           return false;
       }
       
       String trimmedResponse = response.trim();
       
       // Check length (20-2000 characters for coordinator response)
       if (trimmedResponse.length() < 20 || trimmedResponse.length() > 2000) {
           return false;
       }
       
       return true;
   }
}
