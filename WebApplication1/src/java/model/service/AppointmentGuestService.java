package model.service;

import java.sql.SQLException;
import java.util.regex.Pattern;
import model.entity.AppointmentGuest;
import model.dao.AppointmentGuestDAO;

public class AppointmentGuestService {
    private final AppointmentGuestDAO appointmentDAO = new AppointmentGuestDAO();

    public boolean bookAppointment(AppointmentGuest appointment) {
        try {
            // Kiểm tra dữ liệu cơ bản
            if (appointment.getFullName() == null || appointment.getPhoneNumber() == null || appointment.getService() == null) {
                return false;
            }

            // Kiểm tra hợp lệ dữ liệu
            if (!validateFullName(appointment.getFullName())) {
                return false;
            }
            if (!isValidPhoneNumber(appointment.getPhoneNumber())) {
                return false;
            }
            if (appointment.getEmail() != null && !isValidEmail(appointment.getEmail())) {
                return false;
            }

            // Lưu lịch hẹn
            appointmentDAO.saveAppointment(appointment);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
    private boolean isValidPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.length() != 10 || phoneNumber.trim().isEmpty()) {
            return false;
        }
        return Pattern.matches("\\d{10}", phoneNumber);
    }

    // Phương thức kiểm tra hợp lệ email
    private boolean isValidEmail(String email) {
        if (email == null) {
            return true; // Email là optional
        }
        return Pattern.matches("^[a-zA-Z0-9._%+-]+@gmail\\.com$", email);
    }
}