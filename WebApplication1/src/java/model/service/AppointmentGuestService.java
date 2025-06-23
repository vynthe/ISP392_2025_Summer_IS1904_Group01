package model.service;

import java.sql.SQLException;
import java.util.regex.Pattern;
import model.entity.AppointmentGuest;
import model.dao.AppointmentGuestDAO;

public class AppointmentGuestService {

    private final AppointmentGuestDAO appointmentDAO = new AppointmentGuestDAO();

    public void bookAppointment(AppointmentGuest appointment) throws SQLException {
        // Kiểm tra dữ liệu cơ bản
        if (appointment.getFullName() == null || appointment.getPhoneNumber() == null || appointment.getService() == null) {
            throw new SQLException("Dữ liệu cơ bản không được để trống.");
        }

        // Kiểm tra hợp lệ dữ liệu
        validateFullName(appointment.getFullName());
        isValidPhoneNumber(appointment.getPhoneNumber());
        if (appointment.getEmail() != null) {
            isValidEmail(appointment.getEmail());
        }

        // Lưu lịch hẹn
        appointmentDAO.saveAppointment(appointment);
    }

    // Phương thức kiểm tra hợp lệ tên
    public void validateFullName(String fullName) throws SQLException {
        String trimmedFullName = (fullName != null) ? fullName.trim() : null;

        if (trimmedFullName == null || trimmedFullName.isEmpty()) {
            throw new SQLException("Họ và tên không được để trống.");
        }
        if (trimmedFullName.length() > 100) {
            throw new SQLException("Họ và tên không được vượt quá 100 ký tự.");
        }
        if (!trimmedFullName.matches("^[\\p{L}\\s]+$")) {
            throw new SQLException("Họ và tên chỉ được chứa chữ cái và dấu cách.");
        }
    }

    // Phương thức kiểm tra hợp lệ số điện thoại
    public void isValidPhoneNumber(String phoneNumber) throws SQLException {
        if (phoneNumber == null || phoneNumber.length() != 10 || phoneNumber.trim().isEmpty()) {
            throw new SQLException("Số điện thoại không hợp lệ.");
        }
        if (!Pattern.matches("\\d{10}", phoneNumber)) {
            throw new SQLException("Số điện thoại phải chứa đúng 10 chữ số.");
        }
    }

    // Phương thức kiểm tra hợp lệ email
    public void isValidEmail(String email) throws SQLException {
        if (email == null) {
            return; // Email là optional
        }
        if (!Pattern.matches("^[a-zA-Z0-9._%+-]+@gmail\\.com$", email)) {
            throw new SQLException("Email không hợp lệ, phải là địa chỉ gmail.");
        }
    }
}
