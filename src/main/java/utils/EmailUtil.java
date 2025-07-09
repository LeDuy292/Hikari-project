package utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailUtil {
    private static final String EMAIL_USERNAME = "lequochung.17g@gmail.com"; // Thay bằng email của bạn
    private static final String EMAIL_PASSWORD = "swux xase ymxr ryhm"; // Thay bằng mật khẩu ứng dụng

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
}