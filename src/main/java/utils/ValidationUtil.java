package utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ValidationUtil {
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
}