package model.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.HashMap;

/**
 * Data Access Object for handling examination results and appointments.
 *
 * @author HTC
 */
public class ExaminationResultsDAO {
    private final DBContext dbContext;

    public ExaminationResultsDAO() {
        this.dbContext = DBContext.getInstance();
    }

    /**
     * Lấy danh sách lịch hẹn của bác sĩ theo DoctorID, bao gồm thông tin bệnh nhân.
     *
     * @param doctorId ID của bác sĩ
     * @param page Trang hiện tại (dùng cho phân trang)
     * @param pageSize Số bản ghi trên mỗi trang
     * @return Danh sách các lịch hẹn với thông tin chi tiết
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public List<Map<String, Object>> getAppointmentsWithPatientByDoctorId(int doctorId, int page, int pageSize) throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = """
            SELECT 
                a.AppointmentID,
                a.AppointmentTime,
                a.Status,
                a.CreatedAt,
                a.UpdatedAt,
                u1.UserID AS PatientID,
                u1.FullName AS PatientName,
                u1.Phone AS PatientPhone,
                u1.Email AS PatientEmail,
                u2.FullName AS DoctorName,
                s.ServiceName,
                s.ServiceID,
                r.RoomName,
                r.RoomID,
                se.SlotID,
                se.SlotDate,
                se.StartTime,
                se.EndTime
            FROM Appointments a
            LEFT JOIN Users u1 ON a.PatientID = u1.UserID
            JOIN Users u2 ON a.DoctorID = u2.UserID
            JOIN Services s ON a.ServiceID = s.ServiceID
            JOIN Rooms r ON a.RoomID = r.RoomID
            JOIN ScheduleEmployee se ON a.SlotID = se.SlotID
            WHERE a.DoctorID = ?
            ORDER BY a.AppointmentTime DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            pstmt.setInt(2, (page - 1) * pageSize);
            pstmt.setInt(3, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointmentId", rs.getInt("AppointmentID"));
                    appointment.put("patientId", rs.getObject("PatientID") != null ? rs.getInt("PatientID") : null);
                    appointment.put("patientName", rs.getString("PatientName") != null ? rs.getString("PatientName") : "N/A");
                    appointment.put("patientPhone", rs.getString("PatientPhone") != null ? rs.getString("PatientPhone") : "N/A");
                    appointment.put("patientEmail", rs.getString("PatientEmail") != null ? rs.getString("PatientEmail") : "N/A");
                    appointment.put("doctorName", rs.getString("DoctorName"));
                    appointment.put("serviceId", rs.getInt("ServiceID"));
                    appointment.put("serviceName", rs.getString("ServiceName"));
                    appointment.put("roomId", rs.getInt("RoomID"));
                    appointment.put("roomName", rs.getString("RoomName"));
                    appointment.put("slotId", rs.getInt("SlotID"));
                    appointment.put("slotDate", rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null);
                    appointment.put("startTime", rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null);
                    appointment.put("endTime", rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null);
                    appointment.put("appointmentTime", rs.getTimestamp("AppointmentTime"));
                    appointment.put("status", rs.getString("Status"));
                    appointment.put("createdAt", rs.getTimestamp("CreatedAt"));
                    appointment.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getAppointmentsWithPatientByDoctorId for doctorId %d at %s +07: %s, SQLState: %s",
                    doctorId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }
        return appointments;
    }

    /**
     * Đếm tổng số bản ghi lịch hẹn của bác sĩ theo DoctorID.
     *
     * @param doctorId ID của bác sĩ
     * @return Tổng số bản ghi
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public int getTotalAppointmentsByDoctorId(int doctorId) throws SQLException {
        String sql = """
            SELECT COUNT(*) AS Total
            FROM Appointments
            WHERE DoctorID = ?
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("Total");
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getTotalAppointmentsByDoctorId for doctorId %d at %s +07: %s, SQLState: %s",
                    doctorId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }
        return 0;
    }
}