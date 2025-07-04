package model.service;

import java.sql.SQLException;
import java.util.regex.Pattern;
import model.entity.Appointment2;
import model.dao.Appointment2DAO;
import model.service.Services_Service;

public class Appointment2Service {

    private final Appointment2DAO appointmentDAO = new Appointment2DAO();
    private final Services_Service servicesService = new Services_Service();

    public void bookAppointment(Appointment2 appointment) throws SQLException {
        // Kiểm tra dữ liệu cơ bản
        if (appointment.getFullName() == null || appointment.getPhoneNumber() == null) {
            throw new SQLException("Họ và tên hoặc số điện thoại không được để trống.");
        }

        // Kiểm tra hợp lệ dữ liệu
        validateFullName(appointment.getFullName());
        isValidPhoneNumber(appointment.getPhoneNumber());
        if (appointment.getEmail() != null) {
            isValidEmail(appointment.getEmail());
        }

        // Kiểm tra serviceID
        if (appointment.getServiceID() <= 0) {
            throw new SQLException("Service ID phải là một số nguyên dương.");
        }
        try {
            if (!servicesService.getServiceById(appointment.getServiceID()).getStatus().equals("Active")) {
                throw new SQLException("Dịch vụ không tồn tại hoặc không ở trạng thái Active.");
            }
        } catch (SQLException e) {
            throw new SQLException("Dịch vụ với ID " + appointment.getServiceID() + " không tồn tại.");
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
        if (phoneNumber == null || phoneNumber.trim().isEmpty() || phoneNumber.length() != 10) {
            throw new SQLException("Số điện thoại không hợp lệ, phải có đúng 10 chữ số.");
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