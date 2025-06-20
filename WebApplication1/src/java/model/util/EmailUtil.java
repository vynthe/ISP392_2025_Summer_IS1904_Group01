package model.util;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import java.util.Properties;

public class EmailUtil {
    private static final String CONFIG_FILE = "config.properties";

    public static void sendEmail(String toEmail, String subject, String body) throws MessagingException {
        // Load cấu hình từ file properties
        Properties props = new Properties();
        try {
            props.load(EmailUtil.class.getClassLoader().getResourceAsStream(CONFIG_FILE));
        } catch (Exception e) {
            throw new MessagingException("Không thể tải file cấu hình: " + e.getMessage());
        }

        final String fromEmail = props.getProperty("email.from");
        final String password = props.getProperty("email.password");

        if (fromEmail == null || password == null) {
            throw new MessagingException("Cấu hình email hoặc mật khẩu không được để trống trong config.properties.");
        }

        // Cấu hình properties cho Gmail SMTP
        Properties smtpProps = new Properties();
        smtpProps.put("mail.smtp.auth", "true");
        smtpProps.put("mail.smtp.starttls.enable", "true");
        smtpProps.put("mail.smtp.host", "smtp.gmail.com");
        smtpProps.put("mail.smtp.port", "587");

        // Tạo session với xác thực
        Session session = Session.getInstance(smtpProps, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        // Tạo và gửi email
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent successfully to " + toEmail);
        } catch (MessagingException e) {
            System.err.println("Failed to send email: " + e.getMessage());
            throw e;
        }
    }

    // Phương thức chuyên dụng để gửi mã xác thực
    public static void sendVerificationEmail(String toEmail, String verificationCode) throws MessagingException {
        String subject = "Xác thực tài khoản bệnh viện";
        String body = "<p>Mã xác thực của bạn là: <strong>" + verificationCode + "</strong>. Mã này có hiệu lực trong 10 phút.</p>";
        sendEmail(toEmail, subject, body);
    }
}