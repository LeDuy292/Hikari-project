package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {
   
   private static final String EMAIL_USERNAME = "lequochung.17g@gmail.com"; // Thay bằng email của bạn
   private static final String EMAIL_PASSWORD = "swux xase ymxr ryhm"; // Thay bằng mật khẩu ứng dụng
   private static final String FROM_NAME = "HIKARI JAPAN Support";
   
   /**
    * Method gốc - Gửi email reset password (giữ nguyên)
    */
   public static boolean sendResetPasswordEmail(String recipientEmail, String otpMessage) {
       Properties props = new Properties();
       props.put("mail.smtp.auth", "true");
       props.put("mail.smtp.starttls.enable", "true");
       props.put("mail.smtp.host", "smtp.gmail.com");
       props.put("mail.smtp.port", "587");
       props.put("mail.debug", "true"); // Bật debug để xem lỗi chi tiết

       Session session = Session.getInstance(props, new Authenticator() {
           @Override
           protected PasswordAuthentication getPasswordAuthentication() {
               return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
           }
       });

       try {
           Message message = new MimeMessage(session);
           message.setFrom(new InternetAddress(EMAIL_USERNAME));
           message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
           message.setSubject("Mã OTP - JLearning");
           message.setText("Chào bạn,\n\n" +
                          "Mã OTP để đặt lại mật khẩu cho tài khoản JLearning của bạn là:\n" +
                          otpMessage + "\n\n" +
                          "Mã này có hiệu lực trong 10 phút. Vui lòng không chia sẻ mã này với bất kỳ ai.\n\n" +
                          "Trân trọng,\nJLearning Team");

           Transport.send(message);
           return true; // Gửi thành công
       } catch (MessagingException e) {
           e.printStackTrace();
           return false; // Gửi thất bại
       }
   }
   
   /**
    * Method gốc - Send custom email with subject and content (giữ nguyên)
    */
   public static boolean sendEmail(String recipientEmail, String subject, String content) {
       Properties props = new Properties();
       props.put("mail.smtp.auth", "true");
       props.put("mail.smtp.starttls.enable", "true");
       props.put("mail.smtp.host", "smtp.gmail.com");
       props.put("mail.smtp.port", "587");
       props.put("mail.debug", "false"); // Tắt debug cho production

       Session session = Session.getInstance(props, new Authenticator() {
           @Override
           protected PasswordAuthentication getPasswordAuthentication() {
               return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
           }
       });

       try {
           Message message = new MimeMessage(session);
           message.setFrom(new InternetAddress(EMAIL_USERNAME));
           message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
           message.setSubject(subject);
           message.setText(content);

           Transport.send(message);
           System.out.println("Email sent successfully to: " + recipientEmail);
           return true;
       } catch (MessagingException e) {
           System.err.println("Error sending email to " + recipientEmail + ": " + e.getMessage());
           e.printStackTrace();
           return false;
       }
   }
   
   // ==================== CÁC METHOD MỚI CHO HỆ THỐNG CONTACT ====================
   
   /**
    * Send email with HTML content (method mới)
    */
   public static boolean sendHtmlEmail(String toEmail, String subject, String htmlContent) {
       return sendEmailInternal(toEmail, subject, htmlContent, true);
   }
   
   /**
    * Send auto-reply email with professional HTML template (method mới)
    */
   public static boolean sendAutoReplyEmail(String toEmail, String customerName, String issueType, String templateContent) {
       String subject = getAutoReplySubject(issueType);
       String htmlContent = buildAutoReplyHtml(customerName, templateContent, issueType);
       
       return sendHtmlEmail(toEmail, subject, htmlContent);
   }
   
   /**
    * Send coordinator response email (method mới)
    */
   public static boolean sendCoordinatorResponseEmail(String toEmail, String customerName, String issueType, String response) {
       String subject = "Phản hồi từ HIKARI JAPAN - " + getIssueTypeDisplayName(issueType);
       String htmlContent = buildCoordinatorResponseHtml(customerName, response, issueType);
       
       return sendHtmlEmail(toEmail, subject, htmlContent);
   }
   
   /**
    * Core email sending method with HTML support (method mới)
    */
   private static boolean sendEmailInternal(String toEmail, String subject, String content, boolean isHtml) {
       try {
           // Create properties for SMTP
           Properties props = new Properties();
           props.put("mail.smtp.auth", "true");
           props.put("mail.smtp.starttls.enable", "true");
           props.put("mail.smtp.host", "smtp.gmail.com");
           props.put("mail.smtp.port", "587");
           props.put("mail.smtp.ssl.protocols", "TLSv1.2");
           
           // Create authenticator
           Authenticator authenticator = new Authenticator() {
               @Override
               protected PasswordAuthentication getPasswordAuthentication() {
                   return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
               }
           };
           
           // Create session
           Session session = Session.getInstance(props, authenticator);
           
           // Create message
           Message message = new MimeMessage(session);
           message.setFrom(new InternetAddress(EMAIL_USERNAME, FROM_NAME));
           message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
           message.setSubject(subject);
           
           if (isHtml) {
               message.setContent(content, "text/html; charset=utf-8");
           } else {
               message.setText(content);
           }
           
           // Send message
           Transport.send(message);
           
           System.out.println("Email sent successfully to: " + toEmail);
           return true;
           
       } catch (Exception e) {
           System.err.println("Error sending email to " + toEmail + ": " + e.getMessage());
           e.printStackTrace();
           return false;
       }
   }
   
   /**
    * Get auto-reply subject based on issue type (method mới)
    */
   private static String getAutoReplySubject(String issueType) {
       switch (issueType) {
           case "COURSE_ADVICE":
               return "Tư vấn khóa học - HIKARI JAPAN";
           case "TECHNICAL_ISSUE":
               return "Hỗ trợ kỹ thuật - HIKARI JAPAN";
           case "TUITION_SCHEDULE":
               return "Thông tin học phí & lịch học - HIKARI JAPAN";
           case "PAYMENT_SUPPORT":
               return "Hỗ trợ thanh toán - HIKARI JAPAN";
           default:
               return "Yêu cầu của bạn - HIKARI JAPAN";
       }
   }
   
   /**
    * Get display name for issue type (method mới)
    */
   private static String getIssueTypeDisplayName(String issueType) {
       switch (issueType) {
           case "COURSE_ADVICE":
               return "Tư vấn khóa học";
           case "TECHNICAL_ISSUE":
               return "Hỗ trợ kỹ thuật";
           case "TUITION_SCHEDULE":
               return "Học phí & Lịch học";
           case "PAYMENT_SUPPORT":
               return "Hỗ trợ thanh toán";
           default:
               return "Yêu cầu hỗ trợ";
       }
   }
   
   /**
    * Build HTML template for auto-reply email (method mới)
    */
   private static String buildAutoReplyHtml(String customerName, String templateContent, String issueType) {
       return "<!DOCTYPE html>" +
               "<html lang='vi'>" +
               "<head>" +
               "<meta charset='UTF-8'>" +
               "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
               "<title>HIKARI JAPAN - Phản hồi tự động</title>" +
               "</head>" +
               "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
               
               "<!-- Header -->" +
               "<div style='background: linear-gradient(135deg, #e67e22 0%, #f39c12 100%); color: white; padding: 30px 20px; text-align: center; border-radius: 10px 10px 0 0;'>" +
               "<h1 style='margin: 0; font-size: 28px; font-weight: bold;'>🌸 HIKARI JAPAN 🌸</h1>" +
               "<p style='margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;'>Trung tâm tiếng Nhật hàng đầu</p>" +
               "</div>" +
               
               "<!-- Content -->" +
               "<div style='background: #ffffff; padding: 30px 20px; border: 1px solid #e0e0e0; border-top: none;'>" +
               "<h2 style='color: #e67e22; margin-top: 0; font-size: 22px;'>Xin chào " + customerName + "!</h2>" +
               
               "<div style='background: #f8f9fa; padding: 20px; border-left: 4px solid #e67e22; margin: 20px 0;'>" +
               "<p style='margin: 0; font-weight: bold; color: #e67e22;'>📧 Phản hồi tự động - " + getIssueTypeDisplayName(issueType) + "</p>" +
               "</div>" +
               
               "<div style='margin: 25px 0; line-height: 1.8;'>" +
               templateContent.replace("\n", "<br>") +
               "</div>" +
               
               "<!-- Contact Info -->" +
               "<div style='background: #fff3e0; padding: 20px; border-radius: 8px; margin: 25px 0;'>" +
               "<h3 style='color: #e67e22; margin-top: 0; font-size: 18px;'>📞 Thông tin liên hệ</h3>" +
               "<p style='margin: 8px 0;'><strong>Hotline:</strong> 1900-HIKARI (1900-445274)</p>" +
               "<p style='margin: 8px 0;'><strong>Email:</strong> support@hikari.com</p>" +
               "<p style='margin: 8px 0;'><strong>Website:</strong> <a href='#' style='color: #e67e22;'>www.hikari.com</a></p>" +
               "<p style='margin: 8px 0;'><strong>Địa chỉ:</strong> 123 Nguyễn Văn Cừ, Quận 1, TP.HCM</p>" +
               "</div>" +
               
               "<!-- Social Media -->" +
               "<div style='text-align: center; margin: 25px 0;'>" +
               "<p style='margin-bottom: 15px; font-weight: bold; color: #666;'>Theo dõi chúng tôi:</p>" +
               "<a href='#' style='display: inline-block; margin: 0 10px; padding: 8px 15px; background: #3b5998; color: white; text-decoration: none; border-radius: 5px;'>Facebook</a>" +
               "<a href='#' style='display: inline-block; margin: 0 10px; padding: 8px 15px; background: #1da1f2; color: white; text-decoration: none; border-radius: 5px;'>Twitter</a>" +
               "<a href='#' style='display: inline-block; margin: 0 10px; padding: 8px 15px; background: #0077b5; color: white; text-decoration: none; border-radius: 5px;'>LinkedIn</a>" +
               "</div>" +
               "</div>" +
               
               "<!-- Footer -->" +
               "<div style='background: #2c3e50; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px;'>" +
               "<p style='margin: 0; font-size: 14px; opacity: 0.8;'>© 2025 HIKARI JAPAN. Tất cả quyền được bảo lưu.</p>" +
               "<p style='margin: 10px 0 0 0; font-size: 12px; opacity: 0.6;'>Email này được gửi tự động, vui lòng không trả lời trực tiếp.</p>" +
               "</div>" +
               
               "</body>" +
               "</html>";
   }
   
   /**
    * Build HTML template for coordinator response email (method mới)
    */
   private static String buildCoordinatorResponseHtml(String customerName, String response, String issueType) {
       return "<!DOCTYPE html>" +
               "<html lang='vi'>" +
               "<head>" +
               "<meta charset='UTF-8'>" +
               "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
               "<title>HIKARI JAPAN - Phản hồi chuyên viên</title>" +
               "</head>" +
               "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px;'>" +
               
               "<!-- Header -->" +
               "<div style='background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%); color: white; padding: 30px 20px; text-align: center; border-radius: 10px 10px 0 0;'>" +
               "<h1 style='margin: 0; font-size: 28px; font-weight: bold;'>🌸 HIKARI JAPAN 🌸</h1>" +
               "<p style='margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;'>Phản hồi từ chuyên viên tư vấn</p>" +
               "</div>" +
               
               "<!-- Content -->" +
               "<div style='background: #ffffff; padding: 30px 20px; border: 1px solid #e0e0e0; border-top: none;'>" +
               "<h2 style='color: #27ae60; margin-top: 0; font-size: 22px;'>Kính chào " + customerName + "!</h2>" +
               
               "<div style='background: #e8f5e8; padding: 20px; border-left: 4px solid #27ae60; margin: 20px 0;'>" +
               "<p style='margin: 0; font-weight: bold; color: #27ae60;'>👨‍💼 Phản hồi từ chuyên viên - " + getIssueTypeDisplayName(issueType) + "</p>" +
               "</div>" +
               
               "<div style='margin: 25px 0; line-height: 1.8; background: #f8f9fa; padding: 20px; border-radius: 8px;'>" +
               response.replace("\n", "<br>") +
               "</div>" +
               
               "<div style='background: #fff3e0; padding: 20px; border-radius: 8px; margin: 25px 0;'>" +
               "<p style='margin: 0; color: #e67e22; font-weight: bold;'>💡 Cần hỗ trợ thêm?</p>" +
               "<p style='margin: 10px 0 0 0;'>Nếu bạn cần trao đổi thêm, vui lòng liên hệ trực tiếp với chúng tôi qua hotline hoặc email.</p>" +
               "</div>" +
               
               "<!-- Contact Info -->" +
               "<div style='background: #f0f8ff; padding: 20px; border-radius: 8px; margin: 25px 0;'>" +
               "<h3 style='color: #27ae60; margin-top: 0; font-size: 18px;'>📞 Thông tin liên hệ</h3>" +
               "<p style='margin: 8px 0;'><strong>Hotline:</strong> 1900-HIKARI (1900-445274)</p>" +
               "<p style='margin: 8px 0;'><strong>Email:</strong> support@hikari.com</p>" +
               "<p style='margin: 8px 0;'><strong>Website:</strong> <a href='#' style='color: #27ae60;'>www.hikari.com</a></p>" +
               "</div>" +
               "</div>" +
               
               "<!-- Footer -->" +
               "<div style='background: #2c3e50; color: white; padding: 20px; text-align: center; border-radius: 0 0 10px 10px;'>" +
               "<p style='margin: 0; font-size: 14px; opacity: 0.8;'>© 2025 HIKARI JAPAN. Tất cả quyền được bảo lưu.</p>" +
               "<p style='margin: 10px 0 0 0; font-size: 12px; opacity: 0.6;'>Cảm ơn bạn đã tin tưởng HIKARI JAPAN!</p>" +
               "</div>" +
               
               "</body>" +
               "</html>";
   }
}
