package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import model.entity.AppointmentGuest;

public class AppointmentGuestDAO {
    private final DBContext dbContext;

    public AppointmentGuestDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Lưu lịch hẹn mới
    public boolean saveAppointment(AppointmentGuest appointment) throws SQLException {
        if (appointment == null) {
            throw new SQLException("Appointment object cannot be null.");
        }

        // Kiểm tra hợp lệ dữ liệu
        if (!isValidFullName(appointment.getFullName())) {
            throw new SQLException("Tên không được chứa ký tự đặc biệt và tối đa 100 ký tự.");
        }
        if (!isValidPhoneNumber(appointment.getPhoneNumber())) {
            throw new SQLException("Số điện thoại phải là 10 chữ số.");
        }
        if (appointment.getEmail() != null && !isValidEmail(appointment.getEmail())) {
            throw new SQLException("Email phải có đuôi @gmail.com.");
        }

        String sql = "INSERT INTO appointments2 (fullName, phoneNumber, email, service) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, appointment.getFullName());
            pstmt.setString(2, appointment.getPhoneNumber());
            pstmt.setString(3, appointment.getEmail());
            pstmt.setString(4, appointment.getService());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        appointment.setId(generatedKeys.getInt(1));
                    }
                }
            }
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in saveAppointment: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Lấy tất cả lịch hẹn
    public List<AppointmentGuest> getAllAppointments() throws SQLException {
        List<AppointmentGuest> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments2 WHERE status = 'Pending'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                appointments.add(mapResultSetToAppointment(rs));
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllAppointments: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return appointments;
    }

    // Lấy lịch hẹn theo ID
    public AppointmentGuest getAppointmentById(int id) throws SQLException {
        String sql = "SELECT * FROM appointments2 WHERE id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAppointment(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAppointmentById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    // Lấy danh sách lịch hẹn phân trang
    public List<AppointmentGuest> getAppointmentsPaginated(int page, int pageSize) throws SQLException {
        List<AppointmentGuest> appointments = new ArrayList<>();
        String sql = "SELECT * FROM appointments2 WHERE status = 'Pending' ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int offset = (page - 1) * pageSize;
            pstmt.setInt(1, offset);
            pstmt.setInt(2, pageSize);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    appointments.add(mapResultSetToAppointment(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAppointmentsPaginated: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return appointments;
    }

    // Đếm tổng số lịch hẹn
    public int getTotalAppointmentCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM appointments2 WHERE status = 'Pending'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalAppointmentCount: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return 0;
    }

    // Cập nhật lịch hẹn
    public void updateAppointment(AppointmentGuest appointment) throws SQLException {
        if (!isValidFullName(appointment.getFullName())) {
            throw new SQLException("Tên không được chứa ký tự đặc biệt và tối đa 100 ký tự.");
        }
        if (!isValidPhoneNumber(appointment.getPhoneNumber())) {
            throw new SQLException("Số điện thoại phải là 10 chữ số.");
        }
        if (appointment.getEmail() != null && !isValidEmail(appointment.getEmail())) {
            throw new SQLException("Email phải có đuôi @gmail.com.");
        }

        String sql = "UPDATE appointments2 SET fullName = ?, phoneNumber = ?, email = ?, service = ?, status = ? WHERE id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, appointment.getFullName());
            pstmt.setString(2, appointment.getPhoneNumber());
            pstmt.setString(3, appointment.getEmail());
            pstmt.setString(4, appointment.getService());
            pstmt.setString(5, appointment.getStatus());
            pstmt.setInt(6, appointment.getId());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("SQLException in updateAppointment: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Xóa lịch hẹn
    public void deleteAppointment(int id) throws SQLException {
        String sql = "DELETE FROM appointments2 WHERE id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("SQLException in deleteAppointment: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Ánh xạ ResultSet thành đối tượng AppointmentGuest
    private AppointmentGuest mapResultSetToAppointment(ResultSet rs) throws SQLException {
        AppointmentGuest appointment = new AppointmentGuest();
        appointment.setId(rs.getInt("id"));
        appointment.setFullName(rs.getString("fullName"));
        appointment.setPhoneNumber(rs.getString("phoneNumber"));
        appointment.setEmail(rs.getString("email"));
        appointment.setService(rs.getString("service"));
        appointment.setAppointmentDate(rs.getTimestamp("appointmentDate"));
        appointment.setStatus(rs.getString("status"));
        return appointment;
    }

    // Kiểm tra hợp lệ tên
    private boolean isValidFullName(String fullName) {
        if (fullName == null || fullName.length() > 100 || fullName.trim().isEmpty()) {
            return false;
        }
        return Pattern.matches("^[a-zA-Z0-9\\s]+$", fullName);
    }

    // Kiểm tra hợp lệ số điện thoại
    private boolean isValidPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.length() != 10 || phoneNumber.trim().isEmpty()) {
            return false;
        }
        return Pattern.matches("\\d{10}", phoneNumber);
    }

    // Kiểm tra hợp lệ email
    private boolean isValidEmail(String email) {
        if (email == null) {
            return true; // Email là optional
        }
        return Pattern.matches("^[a-zA-Z0-9._%+-]+@gmail\\.com$", email);
    }
}