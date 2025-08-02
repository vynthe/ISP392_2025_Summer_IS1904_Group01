package model.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.Arrays;
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

    public String getDiagnosisByAppointmentId(int appointmentId) throws SQLException {
        String sql = """
            SELECT Diagnosis
            FROM ExaminationResults
            WHERE AppointmentID = ?
            """;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("Diagnosis");
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getDiagnosisDetailsByAppointmentId for appointmentId %d at %s +07: %s, SQLState: %s",
                    appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }
        return null;

    }
   /**
 * Lấy danh sách lịch hẹn của bác sĩ theo DoctorID, bao gồm thông tin bệnh nhân và Y tá.
 *
 * @param doctorId ID của bác sĩ
 * @param page     Trang hiện tại (dùng cho phân trang)
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
            -- Lấy thông tin Y tá từ Room
            room_nurse.UserID AS NurseID,
            room_nurse.FullName AS NurseName,
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
        -- Join để lấy thông tin Y tá từ bảng Rooms
        LEFT JOIN Users room_nurse ON r.UserID = room_nurse.UserID AND r.Role = 'Nurse'
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
                
                // Thêm thông tin Y tá từ Room
                appointment.put("nurseId", rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                appointment.put("nurseName", rs.getString("NurseName")); // Không set "N/A" ở đây, để JSP xử lý
                
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

    /**
     * Thêm kết quả khám từ lịch hẹn (không bao gồm diagnosis và notes).
     *
     * @param appointmentId ID của lịch hẹn
     * @param nurseId       ID của y tá (có thể null)
     * @param status        Trạng thái của kết quả khám
     * @return true nếu thêm thành công, false nếu không
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public boolean addExaminationResultFromAppointment(int appointmentId, Integer nurseId, String status) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Appointment ID must be a positive integer.");
        }

        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status is required.");
        }

        List<String> validStatuses = Arrays.asList("Pending", "Draft", "Completed", "Reviewed", "Cancelled");
        if (!validStatuses.contains(status.trim())) {
            throw new IllegalArgumentException("Invalid status. Allowed values are: " + String.join(", ", validStatuses) + ".");
        }

        // Lấy thông tin từ Appointments
        Map<String, Object> appointmentData = getAppointmentDetailsById(appointmentId);
        if (appointmentData.isEmpty()) {
            throw new SQLException("No appointment found with ID: " + appointmentId);
        }

        int doctorId = (int) appointmentData.get("doctorId");
        int patientId = (int) appointmentData.get("patientId");
        int serviceId = (int) appointmentData.get("serviceId");

        // Nếu nurseId không được cung cấp, có thể lấy từ ScheduleEmployee
        if (nurseId == null) {
            nurseId = getNurseIdFromSchedule((int) appointmentData.get("slotId"));
        }

        String sql = """
            INSERT INTO ExaminationResults (AppointmentID, DoctorID, PatientID, NurseID, ServiceID, [Status], CreatedAt, UpdatedAt)
            VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())
            """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);
            pstmt.setInt(2, doctorId);
            pstmt.setInt(3, patientId);
            pstmt.setInt(4, nurseId != null ? nurseId : 0); // Sử dụng 0 nếu nurseId null (cần kiểm tra logic thực tế)
            pstmt.setInt(5, serviceId);
            pstmt.setString(6, status.trim());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in addExaminationResultFromAppointment for appointmentId %d at %s +07: %s, SQLState: %s",
                    appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }
    }

    /**
     * Thêm kết quả khám từ lịch hẹn (bao gồm diagnosis và notes).
     *
     * @param appointmentId ID của lịch hẹn
     * @param nurseId       ID của y tá (có thể null)
     * @param status        Trạng thái của kết quả khám
     * @param diagnosis     Chẩn đoán
     * @param notes         Ghi chú
     * @return true nếu thêm thành công, false nếu không
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public boolean addExaminationResultFromAppointment(int appointmentId, Integer nurseId, String status, String diagnosis, String notes) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Appointment ID must be a positive integer.");
        }

        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status is required.");
        }

        List<String> validStatuses = Arrays.asList("Pending", "Draft", "Completed", "Reviewed", "Cancelled");
        if (!validStatuses.contains(status.trim())) {
            throw new IllegalArgumentException("Invalid status. Allowed values are: " + String.join(", ", validStatuses) + ".");
        }

        // Lấy thông tin từ Appointments
        Map<String, Object> appointmentData = getAppointmentDetailsById(appointmentId);
        if (appointmentData.isEmpty()) {
            throw new SQLException("No appointment found with ID: " + appointmentId);
        }

        int doctorId = (int) appointmentData.get("doctorId");
        int patientId = (int) appointmentData.get("patientId");
        int serviceId = (int) appointmentData.get("serviceId");

        // Nếu nurseId không được cung cấp, có thể lấy từ ScheduleEmployee
        if (nurseId == null) {
            nurseId = getNurseIdFromSchedule((int) appointmentData.get("slotId"));
        }

        String sql = """
            INSERT INTO ExaminationResults (AppointmentID, DoctorID, PatientID, NurseID, ServiceID, [Status], Diagnosis, Notes, CreatedAt, UpdatedAt)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())
            """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);
            pstmt.setInt(2, doctorId);
            pstmt.setInt(3, patientId);
            pstmt.setInt(4, nurseId != null ? nurseId : 0); // Sử dụng 0 nếu nurseId null (cần kiểm tra logic thực tế)
            pstmt.setInt(5, serviceId);
            pstmt.setString(6, status.trim());
            pstmt.setString(7, diagnosis != null ? diagnosis.trim() : null); // Diagnosis
            pstmt.setString(8, notes != null ? notes.trim() : null); // Notes

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in addExaminationResultFromAppointment for appointmentId %d at %s +07: %s, SQLState: %s",
                    appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }
    }

    /**
     * Lấy thông tin chi tiết của một lịch hẹn theo AppointmentID.
     *
     * @param appointmentId ID của lịch hẹn
     * @return Map chứa thông tin chi tiết của lịch hẹn
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public Map<String, Object> getAppointmentDetailsById(int appointmentId) throws SQLException {
        Map<String, Object> appointment = new HashMap<>();

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
                u2.UserID AS DoctorID,
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
            WHERE a.AppointmentID = ?
            """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    appointment.put("appointmentId", rs.getInt("AppointmentID"));
                    appointment.put("patientId", rs.getObject("PatientID") != null ? rs.getInt("PatientID") : null);
                    appointment.put("patientName", rs.getString("PatientName") != null ? rs.getString("PatientName") : "N/A");
                    appointment.put("patientPhone", rs.getString("PatientPhone") != null ? rs.getString("PatientPhone") : "N/A");
                    appointment.put("patientEmail", rs.getString("PatientEmail") != null ? rs.getString("PatientEmail") : "N/A");
                    appointment.put("doctorId", rs.getInt("DoctorID"));
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
                } else {
                    throw new SQLException("No appointment found with ID: " + appointmentId);
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getAppointmentDetailsById for appointmentId %d at %s +07: %s, SQLState: %s",
                    appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }

        return appointment;
    }

    /**
     * Lấy ID của y tá từ ScheduleEmployee dựa trên SlotID.
     *
     * @param slotId ID của slot trong ScheduleEmployee
     * @return NurseID nếu tìm thấy và vai trò là 'Nurse', null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    private Integer getNurseIdFromSchedule(int slotId) throws SQLException {
        String sql = """
            SELECT UserID
            FROM ScheduleEmployee
            WHERE SlotID = ? AND Role = 'Nurse'
            """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slotId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("UserID");
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getNurseIdFromSchedule for slotId %d at %s +07: %s, SQLState: %s",
                    slotId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }

        return null; // Trả về null nếu không tìm thấy y tá
    }

    /**
     * Lấy thông tin kết quả khám theo ResultID.
     *
     * @param resultId ID của kết quả khám
     * @return Map chứa thông tin chi tiết kết quả khám
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public Map<String, Object> getExaminationResultById(int resultId) throws SQLException {
        Map<String, Object> result = new HashMap<>();

        String sql = """
            SELECT
                er.ResultID,
                er.AppointmentID,
                er.DoctorID,
                u2.FullName AS DoctorName,
                er.PatientID,
                u1.FullName AS PatientName,
                er.NurseID,
                u3.FullName AS NurseName,
                er.ServiceID,
                s.ServiceName,
                er.[Status],
                er.Diagnosis,
                er.Notes,
                er.CreatedAt,
                er.UpdatedAt
            FROM ExaminationResults er
            LEFT JOIN Users u1 ON er.PatientID = u1.UserID
            LEFT JOIN Users u2 ON er.DoctorID = u2.UserID
            LEFT JOIN Users u3 ON er.NurseID = u3.UserID
            JOIN Services s ON er.ServiceID = s.ServiceID
            WHERE er.ResultID = ?
            """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, resultId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result.put("resultId", rs.getInt("ResultID"));
                    result.put("appointmentId", rs.getInt("AppointmentID"));
                    result.put("doctorId", rs.getInt("DoctorID"));
                    result.put("doctorName", rs.getString("DoctorName") != null ? rs.getString("DoctorName") : "N/A");
                    result.put("patientId", rs.getInt("PatientID"));
                    result.put("patientName", rs.getString("PatientName") != null ? rs.getString("PatientName") : "N/A");
                    result.put("nurseId", rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                    result.put("nurseName", rs.getString("NurseName") != null ? rs.getString("NurseName") : "N/A");
                    result.put("serviceId", rs.getInt("ServiceID"));
                    result.put("serviceName", rs.getString("ServiceName"));
                    result.put("status", rs.getString("Status"));
                    result.put("diagnosis", rs.getString("Diagnosis") != null ? rs.getString("Diagnosis") : "N/A");
                    result.put("notes", rs.getString("Notes") != null ? rs.getString("Notes") : "N/A");
                    result.put("createdAt", rs.getTimestamp("CreatedAt"));
                    result.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                } else {
                    throw new SQLException("No examination result found with ID: " + resultId);
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getExaminationResultById for resultId %d at %s +07: %s, SQLState: %s",
                    resultId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }

        return result;
    }

    /**
     * Lấy ResultID từ AppointmentID.
     *
     * @param appointmentId ID của lịch hẹn
     * @return ResultID nếu tìm thấy, null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public Integer getResultIdByAppointmentId(int appointmentId) throws SQLException {
        String sql = "SELECT ResultID FROM ExaminationResults WHERE AppointmentID = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("ResultID");
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getResultIdByAppointmentId for appointmentId %d at %s +07: %s, SQLState: %s",
                    appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }

        return null;
    }

    /**
     * Cập nhật kết quả khám (chỉ cập nhật Diagnosis và Notes, không thay đổi Status).
     *
     * @param resultId  ID của kết quả khám
     * @param diagnosis Chẩn đoán
     * @param notes     Ghi chú
     * @return true nếu cập nhật thành công, false nếu không
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
   /**
 * Cập nhật kết quả khám (có thể cập nhật từng phần riêng lẻ).
 *
 * @param resultId  ID của kết quả khám
 * @param diagnosis Chẩn đoán (null nếu không cập nhật)
 * @param notes     Ghi chú (null nếu không cập nhật)
 * @return true nếu cập nhật thành công, false nếu không
 * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
 */
public boolean updateExaminationResult(int resultId, String diagnosis, String notes) throws SQLException {
    if (resultId <= 0) {
        throw new IllegalArgumentException("Result ID must be a positive integer.");
    }

    // Tạo câu SQL động dựa trên các tham số không null
    StringBuilder sqlBuilder = new StringBuilder("UPDATE ExaminationResults SET ");
    List<String> updateFields = new ArrayList<>();
    List<Object> parameters = new ArrayList<>();

    if (diagnosis != null) {
        updateFields.add("Diagnosis = ?");
        parameters.add(diagnosis.trim());
    }

    if (notes != null) {
        updateFields.add("Notes = ?");
        parameters.add(notes.trim());
    }

    // Nếu không có trường nào để cập nhật
    if (updateFields.isEmpty()) {
        return true; // Không có gì để cập nhật, trả về true
    }

    sqlBuilder.append(String.join(", ", updateFields));
    sqlBuilder.append(", UpdatedAt = GETDATE() WHERE ResultID = ?");
    parameters.add(resultId);

    String sql = sqlBuilder.toString();

    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        // Set parameters
        for (int i = 0; i < parameters.size(); i++) {
            pstmt.setObject(i + 1, parameters.get(i));
        }

        int rowsAffected = pstmt.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException e) {
        String errorMsg = String.format("SQLException in updateExaminationResult for resultId %d at %s +07: %s, SQLState: %s",
                resultId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
        System.err.println(errorMsg);
        throw e;
    }
}

    /**
     * Lấy chi tiết chẩn đoán theo AppointmentID, bao gồm thông tin từ bảng ExaminationResults và Appointments.
     *
     * @param appointmentId ID của lịch hẹn
     * @return Map chứa thông tin chi tiết chẩn đoán
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public Map<String, Object> getDiagnosisDetailsByAppointmentId(int appointmentId) throws SQLException {
        Map<String, Object> diagnosisDetails = new HashMap<>();

        String sql = """
            SELECT
                er.ResultID,
                er.AppointmentID,
                er.DoctorID,
                u2.FullName AS DoctorName,
                er.PatientID,
                u1.FullName AS PatientName,
                u1.Phone AS PatientPhone,
                u1.Email AS PatientEmail,
                u1.Gender AS PatientGender,
                er.NurseID,
                u3.FullName AS NurseName,
                er.ServiceID,
                s.ServiceName,
                s.Price AS ServicePrice,
                er.[Status],
                er.Diagnosis,
                er.Notes,
                er.CreatedAt AS ResultCreatedAt,
                er.UpdatedAt AS ResultUpdatedAt,
                a.AppointmentTime,
                a.Status AS AppointmentStatus,
                a.CreatedAt AS AppointmentCreatedAt,
                r.RoomName,
                se.SlotDate,
                se.StartTime,
                se.EndTime
            FROM ExaminationResults er
            LEFT JOIN Users u1 ON er.PatientID = u1.UserID
            LEFT JOIN Users u2 ON er.DoctorID = u2.UserID
            LEFT JOIN Users u3 ON er.NurseID = u3.UserID
            JOIN Services s ON er.ServiceID = s.ServiceID
            JOIN Appointments a ON er.AppointmentID = a.AppointmentID
            JOIN Rooms r ON a.RoomID = r.RoomID
            JOIN ScheduleEmployee se ON a.SlotID = se.SlotID
            WHERE er.AppointmentID = ?
            """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    // Thông tin kết quả khám
                    diagnosisDetails.put("resultId", rs.getInt("ResultID"));
                    diagnosisDetails.put("appointmentId", rs.getInt("AppointmentID"));
                    diagnosisDetails.put("diagnosis", rs.getString("Diagnosis") != null ? rs.getString("Diagnosis") : "Chưa có chẩn đoán");
                    diagnosisDetails.put("notes", rs.getString("Notes") != null ? rs.getString("Notes") : "Chưa có ghi chú");
                    diagnosisDetails.put("status", rs.getString("Status"));
                    diagnosisDetails.put("resultCreatedAt", rs.getTimestamp("ResultCreatedAt"));
                    diagnosisDetails.put("resultUpdatedAt", rs.getTimestamp("ResultUpdatedAt"));

                    // Thông tin bệnh nhân
                    diagnosisDetails.put("patientId", rs.getInt("PatientID"));
                    diagnosisDetails.put("patientName", rs.getString("PatientName") != null ? rs.getString("PatientName") : "N/A");
                    diagnosisDetails.put("patientPhone", rs.getString("PatientPhone") != null ? rs.getString("PatientPhone") : "N/A");
                    diagnosisDetails.put("patientEmail", rs.getString("PatientEmail") != null ? rs.getString("PatientEmail") : "N/A");
                    diagnosisDetails.put("patientGender", rs.getString("PatientGender") != null ? rs.getString("PatientGender") : "N/A");

                    // Thông tin bác sĩ
                    diagnosisDetails.put("doctorId", rs.getInt("DoctorID"));
                    diagnosisDetails.put("doctorName", rs.getString("DoctorName") != null ? rs.getString("DoctorName") : "N/A");

                    // Thông tin y tá
                    diagnosisDetails.put("nurseId", rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                    diagnosisDetails.put("nurseName", rs.getString("NurseName") != null ? rs.getString("NurseName") : "N/A");

                    // Thông tin dịch vụ
                    diagnosisDetails.put("serviceId", rs.getInt("ServiceID"));
                    diagnosisDetails.put("serviceName", rs.getString("ServiceName"));
                    diagnosisDetails.put("servicePrice", rs.getBigDecimal("ServicePrice"));

                    // Thông tin lịch hẹn
                    diagnosisDetails.put("appointmentTime", rs.getTimestamp("AppointmentTime"));
                    diagnosisDetails.put("appointmentStatus", rs.getString("AppointmentStatus"));
                    diagnosisDetails.put("appointmentCreatedAt", rs.getTimestamp("AppointmentCreatedAt"));
                    diagnosisDetails.put("roomName", rs.getString("RoomName"));
                    diagnosisDetails.put("slotDate", rs.getDate("SlotDate"));
                    diagnosisDetails.put("startTime", rs.getTime("StartTime"));
                    diagnosisDetails.put("endTime", rs.getTime("EndTime"));
                } else {
                    // Nếu không tìm thấy kết quả khám, trả về thông tin lịch hẹn cơ bản
                    Map<String, Object> appointmentData = getAppointmentDetailsById(appointmentId);
                    if (!appointmentData.isEmpty()) {
                        diagnosisDetails.put("appointmentId", appointmentId);
                        diagnosisDetails.put("diagnosis", "Chưa có chẩn đoán");
                        diagnosisDetails.put("notes", "Chưa có ghi chú");
                        diagnosisDetails.put("status", "Chưa có kết quả khám");
                        diagnosisDetails.put("resultId", null);

                        // Copy thông tin từ appointment
                        diagnosisDetails.putAll(appointmentData);
                    } else {
                        throw new SQLException("No appointment found with ID: " + appointmentId);
                    }
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getDiagnosisDetailsByAppointmentId for appointmentId %d at %s +07: %s, SQLState: %s",
                    appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }

        return diagnosisDetails;
    }
    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId, int page, int pageSize) throws SQLException {
    List<Map<String, Object>> results = new ArrayList<>();

    String sql = """
        SELECT
            er.ResultID,
            er.AppointmentID,
            er.DoctorID,
            u2.FullName AS DoctorName,
            u2.Specialization AS DoctorSpecialization,
            er.PatientID,
            u1.FullName AS PatientName,
            er.NurseID,
            u3.FullName AS NurseName,
            er.ServiceID,
            s.ServiceName,
            s.Price AS ServicePrice,
            er.[Status] AS ResultStatus,
            er.Diagnosis,
            er.Notes,
            er.CreatedAt AS ResultCreatedAt,
            er.UpdatedAt AS ResultUpdatedAt,
            a.AppointmentTime,
            a.Status AS AppointmentStatus,
            r.RoomName,
            se.SlotDate,
            se.StartTime,
            se.EndTime
        FROM ExaminationResults er
        LEFT JOIN Users u1 ON er.PatientID = u1.UserID
        LEFT JOIN Users u2 ON er.DoctorID = u2.UserID
        LEFT JOIN Users u3 ON er.NurseID = u3.UserID
        JOIN Services s ON er.ServiceID = s.ServiceID
        JOIN Appointments a ON er.AppointmentID = a.AppointmentID
        JOIN Rooms r ON a.RoomID = r.RoomID
        JOIN ScheduleEmployee se ON a.SlotID = se.SlotID
        WHERE er.PatientID = ?
        ORDER BY er.CreatedAt DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, patientId);
        pstmt.setInt(2, (page - 1) * pageSize);
        pstmt.setInt(3, pageSize);

        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> result = new HashMap<>();
                result.put("resultId", rs.getInt("ResultID"));
                result.put("appointmentId", rs.getInt("AppointmentID"));
                result.put("doctorId", rs.getInt("DoctorID"));
                result.put("doctorName", rs.getString("DoctorName"));
                result.put("doctorSpecialization", rs.getString("DoctorSpecialization"));
                result.put("patientId", rs.getInt("PatientID"));
                result.put("patientName", rs.getString("PatientName"));
                result.put("nurseId", rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                result.put("nurseName", rs.getString("NurseName") != null ? rs.getString("NurseName") : "N/A");
                result.put("serviceId", rs.getInt("ServiceID"));
                result.put("serviceName", rs.getString("ServiceName"));
                result.put("servicePrice", rs.getBigDecimal("ServicePrice"));
                result.put("resultStatus", rs.getString("ResultStatus"));
                result.put("diagnosis", rs.getString("Diagnosis") != null ? rs.getString("Diagnosis") : "Chưa có chẩn đoán");
                result.put("notes", rs.getString("Notes") != null ? rs.getString("Notes") : "Chưa có ghi chú");
                result.put("resultCreatedAt", rs.getTimestamp("ResultCreatedAt"));
                result.put("resultUpdatedAt", rs.getTimestamp("ResultUpdatedAt"));
                result.put("appointmentTime", rs.getTimestamp("AppointmentTime"));
                result.put("appointmentStatus", rs.getString("AppointmentStatus"));
                result.put("roomName", rs.getString("RoomName"));
                result.put("slotDate", rs.getDate("SlotDate"));
                result.put("startTime", rs.getTime("StartTime"));
                result.put("endTime", rs.getTime("EndTime"));
                results.add(result);
            }
        }
    } catch (SQLException e) {
        String errorMsg = String.format("SQLException in getExaminationResultsByPatientId for patientId %d at %s +07: %s, SQLState: %s",
                patientId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
        System.err.println(errorMsg);
        throw e;
    }

    return results;
}
public int getTotalExaminationResultsByPatientId(int patientId) throws SQLException {
    String sql = """
        SELECT COUNT(*) AS Total
        FROM ExaminationResults
        WHERE PatientID = ?
        """;

    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, patientId);

        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("Total");
            }
        }
    } catch (SQLException e) {
        String errorMsg = String.format("SQLException in getTotalExaminationResultsByPatientId for patientId %d at %s +07: %s, SQLState: %s",
                patientId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
        System.err.println(errorMsg);
        throw e;
    }

    return 0;
}
public Map<String, Object> getExaminationResultDetailForPatient(int resultId, int patientId) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        String sql = """
            SELECT
                er.ResultID,
                er.AppointmentID,
                er.DoctorID,
                u2.FullName AS DoctorName,
                u2.Specialization AS DoctorSpecialization,
                u2.Phone AS DoctorPhone,
                u2.Email AS DoctorEmail,
                er.PatientID,
                u1.FullName AS PatientName,
                er.NurseID,
                u3.FullName AS NurseName,
                u3.UserID AS NurseUserId,
                er.ServiceID,
                s.ServiceName,
                s.Description AS ServiceDescription,
                s.Price AS ServicePrice,
                er.[Status] AS ResultStatus,
                er.Diagnosis,
                er.Notes,
                er.CreatedAt AS ResultCreatedAt,
                er.UpdatedAt AS ResultUpdatedAt,
                a.AppointmentTime,
                a.Status AS AppointmentStatus,
                r.RoomName,
                se.SlotDate,
                se.StartTime,
                se.EndTime
            FROM ExaminationResults er
            LEFT JOIN Users u1 ON er.PatientID = u1.UserID
            LEFT JOIN Users u2 ON er.DoctorID = u2.UserID
            LEFT JOIN Users u3 ON er.NurseID = u3.UserID
            JOIN Services s ON er.ServiceID = s.ServiceID
            JOIN Appointments a ON er.AppointmentID = a.AppointmentID
            JOIN Rooms r ON a.RoomID = r.RoomID
            JOIN ScheduleEmployee se ON a.SlotID = se.SlotID
            WHERE er.ResultID = ? AND er.PatientID = ?
            """;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, resultId);
            pstmt.setInt(2, patientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result.put("resultId", rs.getInt("ResultID"));
                    result.put("appointmentId", rs.getInt("AppointmentID"));
                    result.put("doctorId", rs.getInt("DoctorID"));
                    result.put("doctorName", rs.getString("DoctorName"));
                    result.put("doctorSpecialization", rs.getString("DoctorSpecialization"));
                    result.put("doctorPhone", rs.getString("DoctorPhone"));
                    result.put("doctorEmail", rs.getString("DoctorEmail"));
                    result.put("patientId", rs.getInt("PatientID"));
                    result.put("patientName", rs.getString("PatientName"));
                    Integer nurseId = rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null;
                    result.put("nurseId", nurseId);
                    String nurseName = rs.getString("NurseName");
                    if (nurseId != null) {
                        if (nurseName == null) {
                            System.err.println("Warning: NurseID " + nurseId + " exists but no FullName found for ResultID " + resultId + " at " + LocalDateTime.now() + " +07");
                        } else {
                            System.out.println("Nurse found: NurseID " + nurseId + ", Name: " + nurseName + " for ResultID " + resultId);
                        }
                    } else {
                        System.err.println("No NurseID found for ResultID " + resultId + " at " + LocalDateTime.now() + " +07");
                    }
                    result.put("nurseName", nurseName != null ? nurseName : "Chưa gán y tá");
                    result.put("serviceId", rs.getInt("ServiceID"));
                    result.put("serviceName", rs.getString("ServiceName"));
                    result.put("serviceDescription", rs.getString("ServiceDescription"));
                    result.put("servicePrice", rs.getBigDecimal("ServicePrice"));
                    result.put("resultStatus", rs.getString("ResultStatus"));
                    result.put("diagnosis", rs.getString("Diagnosis") != null ? rs.getString("Diagnosis") : "Chưa có chẩn đoán");
                    result.put("notes", rs.getString("Notes") != null ? rs.getString("Notes") : "Chưa có ghi chú");
                    result.put("resultCreatedAt", rs.getTimestamp("ResultCreatedAt"));
                    result.put("resultUpdatedAt", rs.getTimestamp("ResultUpdatedAt"));
                    result.put("appointmentTime", rs.getTimestamp("AppointmentTime"));
                    result.put("appointmentStatus", rs.getString("AppointmentStatus"));
                    result.put("roomName", rs.getString("RoomName"));
                    result.put("slotDate", rs.getDate("SlotDate"));
                    result.put("startTime", rs.getTime("StartTime"));
                    result.put("endTime", rs.getTime("EndTime"));
                } else {
                    throw new SQLException("No examination result found with ID: " + resultId + " for patient: " + patientId);
                }
            }
        } catch (SQLException e) {
            String errorMsg = String.format("SQLException in getExaminationResultDetailForPatient for resultId %d, patientId %d at %s +07: %s, SQLState: %s",
                    resultId, patientId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
            System.err.println(errorMsg);
            throw e;
        }
        return result;
    }
public Map<String, Object> getNurseByAppointmentId(int appointmentId) throws SQLException {
    Map<String, Object> nurse = new HashMap<>();

    String sql = """
        SELECT DISTINCT
            u.UserID,
            u.FullName,
            u.Phone,
            u.Email,
            u.Gender
        FROM Appointments a
        JOIN ScheduleEmployee se ON a.SlotID = se.SlotID
        JOIN Users u ON se.UserID = u.UserID
        WHERE a.AppointmentID = ? 
        AND se.Role = 'Nurse'
        AND u.Role = 'Nurse'
        AND u.Status = 'Active'
        
        UNION
        
        SELECT DISTINCT
            u.UserID,
            u.FullName,
            u.Phone,
            u.Email,
            u.Gender
        FROM Appointments a
        JOIN Rooms r ON a.RoomID = r.RoomID
        JOIN Users u ON r.UserID = u.UserID
        WHERE a.AppointmentID = ?
        AND r.Role = 'Nurse'
        AND u.Role = 'Nurse'
        AND u.Status = 'Active'
        """;

    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, appointmentId);
        pstmt.setInt(2, appointmentId);

        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                nurse.put("userID", rs.getInt("UserID"));
                nurse.put("fullName", rs.getString("FullName"));
                nurse.put("phone", rs.getString("Phone"));
                nurse.put("email", rs.getString("Email"));
                nurse.put("gender", rs.getString("Gender"));
                return nurse;
            }
        }
    } catch (SQLException e) {
        String errorMsg = String.format("SQLException in getNurseByAppointmentId for appointmentId %d at %s +07: %s, SQLState: %s",
                appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
        System.err.println(errorMsg);
        throw e;
    }

    return null; // Trả về null nếu không tìm thấy y tá
}
public Map<String, Object> getAppointmentDetailsWithNurse(int appointmentId) throws SQLException {
    Map<String, Object> appointment = new HashMap<>();

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
            u2.UserID AS DoctorID,
            u2.FullName AS DoctorName,
            s.ServiceName,
            s.ServiceID,
            r.RoomName,
            r.RoomID,
            se.SlotID,
            se.SlotDate,
            se.StartTime,
            se.EndTime,
            -- Lấy y tá từ ScheduleEmployee
            se_nurse.UserID AS ScheduleNurseID,
            u_nurse_schedule.FullName AS ScheduleNurseName,
            u_nurse_schedule.Phone AS ScheduleNursePhone,
            u_nurse_schedule.Email AS ScheduleNurseEmail,
            -- Lấy y tá từ Room
            room_nurse.UserID AS RoomNurseID,
            u_nurse_room.FullName AS RoomNurseName,
            u_nurse_room.Phone AS RoomNursePhone,
            u_nurse_room.Email AS RoomNurseEmail
        FROM Appointments a
        LEFT JOIN Users u1 ON a.PatientID = u1.UserID
        JOIN Users u2 ON a.DoctorID = u2.UserID
        JOIN Services s ON a.ServiceID = s.ServiceID
        JOIN Rooms r ON a.RoomID = r.RoomID
        JOIN ScheduleEmployee se ON a.SlotID = se.SlotID
        -- Join y tá từ ScheduleEmployee
        LEFT JOIN ScheduleEmployee se_nurse ON se.SlotID = se_nurse.SlotID AND se_nurse.Role = 'Nurse'
        LEFT JOIN Users u_nurse_schedule ON se_nurse.UserID = u_nurse_schedule.UserID AND u_nurse_schedule.Status = 'Active'
        -- Join y tá từ Room
        LEFT JOIN Users room_nurse ON r.UserID = room_nurse.UserID AND r.Role = 'Nurse'
        LEFT JOIN Users u_nurse_room ON room_nurse.UserID = u_nurse_room.UserID AND u_nurse_room.Status = 'Active'
        WHERE a.AppointmentID = ?
        """;

    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, appointmentId);

        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                appointment.put("appointmentId", rs.getInt("AppointmentID"));
                appointment.put("patientId", rs.getObject("PatientID") != null ? rs.getInt("PatientID") : null);
                appointment.put("patientName", rs.getString("PatientName") != null ? rs.getString("PatientName") : "N/A");
                appointment.put("patientPhone", rs.getString("PatientPhone") != null ? rs.getString("PatientPhone") : "N/A");
                appointment.put("patientEmail", rs.getString("PatientEmail") != null ? rs.getString("PatientEmail") : "N/A");
                appointment.put("doctorId", rs.getInt("DoctorID"));
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

                // Xử lý thông tin y tá - ưu tiên y tá từ ScheduleEmployee trước
                Integer nurseId = null;
                String nurseName = null;
                String nursePhone = null;
                String nurseEmail = null;

                // Kiểm tra y tá từ ScheduleEmployee trước
                if (rs.getObject("ScheduleNurseID") != null) {
                    nurseId = rs.getInt("ScheduleNurseID");
                    nurseName = rs.getString("ScheduleNurseName");
                    nursePhone = rs.getString("ScheduleNursePhone");
                    nurseEmail = rs.getString("ScheduleNurseEmail");
                }
                // Nếu không có y tá từ ScheduleEmployee, kiểm tra y tá từ Room
                else if (rs.getObject("RoomNurseID") != null) {
                    nurseId = rs.getInt("RoomNurseID");
                    nurseName = rs.getString("RoomNurseName");
                    nursePhone = rs.getString("RoomNursePhone");
                    nurseEmail = rs.getString("RoomNurseEmail");
                }

                appointment.put("nurseId", nurseId);
                appointment.put("nurseName", nurseName);
                appointment.put("nursePhone", nursePhone);
                appointment.put("nurseEmail", nurseEmail);

            } else {
                throw new SQLException("No appointment found with ID: " + appointmentId);
            }
        }
    } catch (SQLException e) {
        String errorMsg = String.format("SQLException in getAppointmentDetailsWithNurse for appointmentId %d at %s +07: %s, SQLState: %s",
                appointmentId, LocalDateTime.now(), e.getMessage(), e.getSQLState());
        System.err.println(errorMsg);
        throw e;
    }

    return appointment;
}
}

