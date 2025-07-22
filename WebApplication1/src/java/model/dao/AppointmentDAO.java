package model.dao;

import model.entity.Users;
import model.entity.Schedules;
import model.entity.Rooms;
import model.entity.Services;
import model.entity.ScheduleEmployee;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppointmentDAO {

    private final DBContext dbContext;

    public AppointmentDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Tìm kiếm bác sĩ theo tên và chuyên môn
    public List<Users> searchDoctorsByNameAndSpecialty(String nameKeyword, String specialtyKeyword, int page, int pageSize) throws SQLException {
        List<Users> doctors = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT UserID, FullName, Specialization FROM Users WHERE Role = 'Doctor' AND Status = 'Active' ");
        List<String> params = new ArrayList<>();

        if (nameKeyword != null && !nameKeyword.trim().isEmpty()) {
            sql.append("AND FullName LIKE ? ");
            params.add("%" + nameKeyword.trim() + "%");
        }
        if (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty()) {
            sql.append("AND Specialization LIKE ? ");
            params.add("%" + specialtyKeyword.trim() + "%");
        }
        sql.append("ORDER BY UserID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (String param : params) {
                pstmt.setString(paramIndex++, param);
            }
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);
            pstmt.setInt(paramIndex, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Users doctor = new Users();
                    doctor.setUserID(rs.getInt("UserID"));
                    doctor.setFullName(rs.getString("FullName"));
                    doctor.setSpecialization(rs.getString("Specialization"));
                    doctors.add(doctor);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in searchDoctorsByNameAndSpecialty at " + LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }
        return doctors;
    }

    // Đếm tổng số bác sĩ
    public int getTotalDoctorRecords(String nameKeyword, String specialtyKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Users WHERE Role = 'Doctor' AND Status = 'Active' ");
        List<String> params = new ArrayList<>();

        if (nameKeyword != null && !nameKeyword.trim().isEmpty()) {
            sql.append("AND FullName LIKE ? ");
            params.add("%" + nameKeyword.trim() + "%");
        }
        if (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty()) {
            sql.append("AND Specialization LIKE ? ");
            params.add("%" + specialtyKeyword.trim() + "%");
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (String param : params) {
                pstmt.setString(paramIndex++, param);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalDoctorRecords at " + LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }
        return 0;
    }

    // Lấy thông tin phòng theo DoctorID
    public String getRoomByDoctorId(int doctorId) throws SQLException {
        String sql = "SELECT RoomName FROM Rooms WHERE DoctorID = ? AND Status = 'Available'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("RoomName");
                }
            }
        }
        return "N/A";
    }

    // Lấy danh sách dịch vụ theo DoctorID
    public List<String> getServicesByDoctorId(int doctorId) throws SQLException {
        List<String> services = new ArrayList<>();
        String sql = "SELECT DISTINCT s.ServiceName FROM Services s "
                + "JOIN RoomServices rs ON s.ServiceID = rs.ServiceID "
                + "JOIN Rooms r ON rs.RoomID = r.RoomID "
                + "WHERE r.DoctorID = ? AND s.Status = 'Active'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    services.add(rs.getString("ServiceName"));
                }
            }
        }
        return services.isEmpty() ? List.of("N/A") : services;
    }

    // Lấy danh sách lịch trình theo DoctorID (đã sửa sang dùng ScheduleEmployee)
    public List<String> getSchedulesByDoctorId(int doctorId) throws SQLException {
        List<String> schedules = new ArrayList<>();
        String sql = "SELECT SlotDate, StartTime, EndTime, Status FROM ScheduleEmployee "
                + "WHERE UserID = ? AND Role = 'Doctor' AND Status = 'Available'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String schedule = rs.getDate("SlotDate").toLocalDate() + " ("
                            + rs.getTime("StartTime").toLocalTime() + " - "
                            + rs.getTime("EndTime").toLocalTime() + ", Status: "
                            + rs.getString("Status") + ")";
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByDoctorId at " + LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }
        return schedules.isEmpty() ? List.of("N/A") : schedules;
    }

    // Lấy thông tin chi tiết phòng theo RoomID
    public Rooms getRoomByID(int roomID) throws SQLException {
        String sql = "SELECT * FROM Rooms WHERE RoomID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomID(rs.getInt("RoomID"));
                    room.setRoomName(rs.getString("RoomName"));
                    room.setDescription(rs.getString("Description"));
                    room.setDoctorID(rs.getObject("DoctorID") != null ? rs.getInt("DoctorID") : null);
                    room.setNurseID(rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                    room.setStatus(rs.getString("Status"));
                    room.setCreatedBy(rs.getInt("CreatedBy"));
                    room.setCreatedAt(rs.getDate("CreatedAt"));
                    room.setUpdatedAt(rs.getDate("UpdatedAt"));
                    return room;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getRoomByID: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // Lấy danh sách dịch vụ theo RoomID
    public List<Services> getServicesByRoom(int roomId) throws SQLException {
        List<Services> services = new ArrayList<>();
        String sql = "SELECT s.* FROM RoomServices rs "
                + "JOIN Services s ON rs.ServiceID = s.ServiceID "
                + "WHERE rs.RoomID = ? AND s.Status = 'Active'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Services s = new Services();
                    s.setServiceID(rs.getInt("ServiceID"));
                    s.setServiceName(rs.getString("ServiceName"));
                    s.setDescription(rs.getString("Description"));
                    s.setPrice(rs.getDouble("Price"));
                    s.setStatus(rs.getString("Status"));
                    s.setCreatedBy(rs.getInt("CreatedBy"));
                    s.setCreatedAt(rs.getDate("CreatedAt"));
                    s.setUpdatedAt(rs.getDate("UpdatedAt"));
                    services.add(s);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getServicesByRoom: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return services;
    }

    // Lấy danh sách bệnh nhân theo RoomID
    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        List<String> patients = new ArrayList<>();
        String sql = "SELECT DISTINCT u.FullName FROM Appointments a "
                + "JOIN Users u ON a.PatientID = u.UserID WHERE a.RoomID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    patients.add(rs.getString("FullName"));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getPatientsByRoomId: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return patients.isEmpty() ? List.of("Không có bệnh nhân") : patients;
    }

    // Lấy lịch trình theo Role và UserID (sửa để dùng ScheduleEmployee)
    public List<ScheduleEmployee> getSchedulesByRoleAndUserId(String role, Integer userId) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt "
                + "FROM ScheduleEmployee";
        if (!"admin".equalsIgnoreCase(role)) {
            sql += " WHERE Role = ? AND UserID = ? AND Status = 'Available'";
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (!"admin".equalsIgnoreCase(role)) {
                stmt.setString(1, role);
                stmt.setInt(2, userId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("SlotID"));
                    schedule.setUserId(rs.getInt("UserID"));
                    schedule.setRole(rs.getString("Role"));
                    schedule.setRoomId(rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null);
                    schedule.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                    schedule.setStartTime(rs.getTime("StartTime").toLocalTime());
                    schedule.setEndTime(rs.getTime("EndTime").toLocalTime());
                    schedule.setStatus(rs.getString("Status"));
                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
                    schedule.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    schedule.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByRoleAndUserId: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    // Lấy tên người dùng theo UserID
    public String getUserFullNameById(int userId) throws SQLException {
        String sql = "SELECT FullName FROM Users WHERE UserID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("FullName");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getUserFullNameById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    // Hiển thị chi tiết lịch hẹn (sửa để dùng ScheduleEmployee)
    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
        Map<String, Object> details = new HashMap<>();

        // Lấy thông tin bác sĩ
        String doctorSql = "SELECT FullName, Specialization FROM Users WHERE UserID = ? AND Role = 'doctor' AND Status = 'Active'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(doctorSql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    details.put("doctorName", rs.getString("FullName"));
                    details.put("specialization", rs.getString("Specialization"));
                } else {
                    details.put("doctorName", "N/A");
                    details.put("specialization", "N/A");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in viewDetailBook (doctor query, doctorId=" + doctorId + "): " + e.getMessage() + ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }

        // Lấy thông tin phòng
        String roomSql = "SELECT TOP 1 se.RoomID, RoomName FROM ScheduleEmployee se "
                + "JOIN Rooms r ON se.RoomID = r.RoomID "
                + "WHERE se.UserID = ? AND se.SlotDate = ? AND se.Status = 'Available' "
                + "AND r.Status = 'Available'";
        int roomId = -1;
        String roomName = "N/A";
        LocalDate currentDate = LocalDate.now();
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(roomSql)) {
            pstmt.setInt(1, doctorId);
            pstmt.setDate(2, Date.valueOf(currentDate));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    roomId = rs.getInt("RoomID");
                    roomName = rs.getString("RoomName");
                    System.out.println("🔧 DEBUG - AppointmentDAO.viewDetailBook: doctorId = " + doctorId + ", roomId = " + roomId + ", roomName = " + roomName + ", currentDate = " + currentDate + " at " + LocalDateTime.now() + " +07");
                } else {
                    System.out.println("🔧 DEBUG - AppointmentDAO.viewDetailBook: No room found for doctorId = " + doctorId + " on " + currentDate + " at " + LocalDateTime.now() + " +07");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in viewDetailBook (room query, doctorId=" + doctorId + ", date=" + currentDate + "): " + e.getMessage() + ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }

        details.put("roomID", roomId == -1 ? "N/A" : roomId);
        details.put("roomName", roomName);

        // Lấy danh sách dịch vụ
        List<Map<String, Object>> services = new ArrayList<>();
        if (roomId != -1) {
            try {
                for (Services service : getServicesByRoom(roomId)) {
                    Map<String, Object> serviceMap = new HashMap<>();
                    serviceMap.put("serviceID", service.getServiceID());
                    serviceMap.put("serviceName", service.getServiceName());
                    serviceMap.put("description", service.getDescription());
                    serviceMap.put("price", service.getPrice());
                    services.add(serviceMap);
                }
            } catch (SQLException e) {
                System.err.println("SQLException in getServicesByRoom (roomId=" + roomId + "): " + e.getMessage() + ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
                throw e;
            }
        }
        details.put("services", services.isEmpty() ? List.of(Map.of("serviceName", "N/A", "description", "N/A", "price", 0.0)) : services);

        // Lấy danh sách lịch trình
        List<Map<String, Object>> schedules = new ArrayList<>();
        try {
            for (ScheduleEmployee schedule : getSchedulesByRoleAndUserId("Doctor", doctorId)) {
                Map<String, Object> scheduleMap = new HashMap<>();
                scheduleMap.put("scheduleID", schedule.getSlotId());
                scheduleMap.put("slotDate", schedule.getSlotDate());
                scheduleMap.put("startTime", schedule.getStartTime());
                scheduleMap.put("endTime", schedule.getEndTime());
                scheduleMap.put("status", schedule.getStatus());
                schedules.add(scheduleMap);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByRoleAndUserId (doctorId=" + doctorId + "): " + e.getMessage() + ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        details.put("schedules", schedules.isEmpty() ? List.of(Map.of("scheduleInfo", "N/A")) : schedules);

        return details;
    }

    // Đếm số lượng lịch hẹn theo SlotID
    public int countAppointmentsBySlotId(int slotId) throws SQLException {
        String sql = "SELECT COUNT(*) AS AppointmentCount FROM Appointments WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slotId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("AppointmentCount");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in countAppointmentsBySlotId for slotId " + slotId + ": " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return 0;
    }

    // Tạo mới một lịch hẹn (thêm kiểm tra slot hợp lệ)
   public boolean createAppointment(int patientId, int doctorId, int serviceId, int slotId, int roomId) throws SQLException {
    if (patientId <= 0 || doctorId <= 0 || serviceId <= 0 || slotId <= 0 || roomId <= 0) {
        throw new IllegalArgumentException("Invalid input: All IDs must be positive");
    }

    // Kiểm tra slot đã đủ 5 lịch hẹn chưa
    int appointmentCount = countAppointmentsBySlotId(slotId);
    if (appointmentCount >= 5) {
        System.err.println("Slot " + slotId + " is full (reached 5 appointments) at " + LocalDateTime.now() + " +07");
        return false;
    }

 
    String getSlotTimeSql = "SELECT se.SlotDate, se.StartTime, se.EndTime, se.Status, r.RoomName, u.FullName as DoctorName " +
                           "FROM ScheduleEmployee se " +
                           "JOIN Rooms r ON se.RoomID = r.RoomID " +
                           "JOIN Users u ON se.UserID = u.UserID " +
                           "WHERE se.SlotID = ? AND se.UserID = ? AND se.RoomID = ? " +
                           "AND se.Status = 'Available' AND r.Status = 'Available' AND u.Status = 'Active'";
    
    Timestamp appointmentTime = null;
    try (Connection conn = dbContext.getConnection(); 
         PreparedStatement getSlotStmt = conn.prepareStatement(getSlotTimeSql)) {
        
        getSlotStmt.setInt(1, slotId);
        getSlotStmt.setInt(2, doctorId);
        getSlotStmt.setInt(3, roomId);
        
        try (ResultSet rs = getSlotStmt.executeQuery()) {
            if (!rs.next()) {
                System.err.println("❌ Invalid or unavailable schedule slot for slotId: " + slotId + 
                                 ", doctorId: " + doctorId + ", roomId: " + roomId + 
                                 " at " + LocalDateTime.now() + " +07");
                return false;
            }
            
            LocalDateTime slotTime = rs.getDate("SlotDate").toLocalDate()
                                     .atTime(rs.getTime("StartTime").toLocalTime());
            appointmentTime = Timestamp.valueOf(slotTime);
            
            System.out.println("✅ Valid slot found - Doctor: " + rs.getString("DoctorName") + 
                             ", Room: " + rs.getString("RoomName") + 
                             ", Time: " + slotTime);
        }
    }

    // ✅ FIXED: Kiểm tra dịch vụ với JOIN để đảm bảo service available trong room
    String checkServiceSql = "SELECT s.ServiceName, rs.RoomID " +
                            "FROM RoomServices rs " +
                            "JOIN Services s ON rs.ServiceID = s.ServiceID " +
                            "JOIN Rooms r ON rs.RoomID = r.RoomID " +
                            "WHERE rs.RoomID = ? AND rs.ServiceID = ? " +
                            "AND r.Status = 'Available' AND s.Status = 'Active'";
    
    try (Connection conn = dbContext.getConnection(); 
         PreparedStatement checkServiceStmt = conn.prepareStatement(checkServiceSql)) {
        
        checkServiceStmt.setInt(1, roomId);
        checkServiceStmt.setInt(2, serviceId);
        
        try (ResultSet rs = checkServiceStmt.executeQuery()) {
            if (!rs.next()) {
                System.err.println("❌ Service " + serviceId + " is not available in room " + roomId + 
                                 " at " + LocalDateTime.now() + " +07");
                return false;
            }
            System.out.println("✅ Service available: " + rs.getString("ServiceName"));
        }
    }

    // ✅ IMPROVED: Sử dụng transaction để đảm bảo data consistency
    Connection conn = null;
    try {
        conn = dbContext.getConnection();
        conn.setAutoCommit(false);  // Bắt đầu transaction

        // Chèn appointment
        String insertSql = "INSERT INTO Appointments (PatientID, DoctorID, ServiceID, SlotID, RoomID, AppointmentTime, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                          "VALUES (?, ?, ?, ?, ?, ?, 'Scheduled', ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(insertSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, patientId);
            pstmt.setInt(2, doctorId);
            pstmt.setInt(3, serviceId);
            pstmt.setInt(4, slotId);
            pstmt.setInt(5, roomId);
            pstmt.setTimestamp(6, appointmentTime);
            pstmt.setInt(7, patientId);
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            pstmt.setTimestamp(8, now);
            pstmt.setTimestamp(9, now);
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected == 0) {
                System.err.println("❌ Failed to insert appointment for slotId: " + slotId);
                conn.rollback();
                return false;
            }
        }

        // Cập nhật trạng thái slot
        String updateSlotSql = "UPDATE ScheduleEmployee SET Status = 'Booked', PatientID = ?, UpdatedAt = GETDATE() " +
                              "WHERE SlotID = ? AND Status = 'Available' AND UserID = ? AND RoomID = ?";
        
        try (PreparedStatement updateStmt = conn.prepareStatement(updateSlotSql)) {
            updateStmt.setInt(1, patientId);
            updateStmt.setInt(2, slotId);
            updateStmt.setInt(3, doctorId);
            updateStmt.setInt(4, roomId);
            
            int rowsAffected = updateStmt.executeUpdate();
            if (rowsAffected == 0) {
                System.err.println("❌ Failed to update slot status for slotId: " + slotId);
                conn.rollback();
                return false;
            }
        }

        conn.commit();  // Commit transaction
        System.out.println("✅ Appointment created successfully for slotId: " + slotId);
        return true;

    } catch (SQLException e) {
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException rollbackEx) {
                System.err.println("❌ Rollback failed: " + rollbackEx.getMessage());
            }
        }
        System.err.println("❌ SQLException in createAppointment: " + e.getMessage());
        throw e;
    } finally {
        if (conn != null) {
            try {
                conn.setAutoCommit(true);  // Restore auto-commit
                conn.close();
            } catch (SQLException e) {
                System.err.println("❌ Failed to close connection: " + e.getMessage());
            }
        }
    }
}

    // Kiểm tra xem lịch hẹn có tồn tại không
    public boolean appointmentExists(int appointmentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Appointments WHERE AppointmentID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in appointmentExists: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return false;
    }

    // Lấy thông tin chi tiết lịch hẹn theo ID
    public Map<String, Object> getAppointmentById(int appointmentId) throws SQLException {
        String sql = "SELECT a.AppointmentID, a.PatientID, a.DoctorID, a.ServiceID, a.ScheduleID, a.RoomID, "
                + "a.AppointmentTime, a.Status, a.CreatedAt, a.UpdatedAt, "
                + "u1.FullName as PatientName, u2.FullName as DoctorName, "
                + "s.ServiceName, r.RoomName "
                + "FROM Appointments a "
                + "JOIN Users u1 ON a.PatientID = u1.UserID "
                + "JOIN Users u2 ON a.DoctorID = u2.UserID "
                + "JOIN Services s ON a.ServiceID = s.ServiceID "
                + "JOIN Rooms r ON a.RoomID = r.RoomID "
                + "WHERE a.AppointmentID = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointmentId", rs.getInt("AppointmentID"));
                    appointment.put("patientId", rs.getInt("PatientID"));
                    appointment.put("doctorId", rs.getInt("DoctorID"));
                    appointment.put("serviceId", rs.getInt("ServiceID"));
                    appointment.put("scheduleId", rs.getInt("ScheduleID"));
                    appointment.put("roomId", rs.getInt("RoomID"));
                    appointment.put("appointmentTime", rs.getTimestamp("AppointmentTime"));
                    appointment.put("status", rs.getString("Status"));
                    appointment.put("createdAt", rs.getTimestamp("CreatedAt"));
                    appointment.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                    appointment.put("patientName", rs.getString("PatientName"));
                    appointment.put("doctorName", rs.getString("DoctorName"));
                    appointment.put("serviceName", rs.getString("ServiceName"));
                    appointment.put("roomName", rs.getString("RoomName"));
                    return appointment;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAppointmentById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    // Hủy lịch hẹn (soft delete)
    public boolean cancelAppointment(int appointmentId) throws SQLException {
        String sql = "UPDATE Appointments SET Status = 'Cancelled', UpdatedAt = ? WHERE AppointmentID = ? AND Status != 'Cancelled'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setTimestamp(1, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setInt(2, appointmentId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in cancelAppointment: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Xóa lịch hẹn vĩnh viễn (hard delete)
    public boolean deleteAppointmentPermanently(int appointmentId) throws SQLException {
        String sql = "DELETE FROM Appointments WHERE AppointmentID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, appointmentId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in deleteAppointmentPermanently: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Hủy nhiều lịch hẹn cùng lúc (soft delete)
    public int cancelMultipleAppointments(List<Integer> appointmentIds) throws SQLException {
        if (appointmentIds == null || appointmentIds.isEmpty()) {
            return 0;
        }

        String sql = "UPDATE Appointments SET Status = 'Cancelled', UpdatedAt = ? WHERE AppointmentID = ? AND Status != 'Cancelled'";
        int totalCancelled = 0;

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());

            for (Integer appointmentId : appointmentIds) {
                pstmt.setTimestamp(1, now);
                pstmt.setInt(2, appointmentId);
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            for (int result : results) {
                if (result > 0) {
                    totalCancelled++;
                }
            }
            conn.commit();
        } catch (SQLException e) {
            System.err.println("SQLException in cancelMultipleAppointments: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return totalCancelled;
    }

    // Lấy danh sách lịch hẹn theo PatientID
    public List<Map<String, Object>> getAppointmentsByPatientId(int patientId) throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT a.AppointmentID, a.AppointmentTime, a.Status, "
                + "u.FullName as DoctorName, s.ServiceName, r.RoomName "
                + "FROM Appointments a "
                + "JOIN Users u ON a.DoctorID = u.UserID "
                + "JOIN Services s ON a.ServiceID = s.ServiceID "
                + "JOIN Rooms r ON a.RoomID = r.RoomID "
                + "WHERE a.PatientID = ? "
                + "ORDER BY a.AppointmentTime DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, patientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointmentId", rs.getInt("AppointmentID"));
                    appointment.put("appointmentTime", rs.getTimestamp("AppointmentTime"));
                    appointment.put("status", rs.getString("Status"));
                    appointment.put("doctorName", rs.getString("DoctorName"));
                    appointment.put("serviceName", rs.getString("ServiceName"));
                    appointment.put("roomName", rs.getString("RoomName"));
                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAppointmentsByPatientId: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return appointments;
    }

    // Lấy danh sách lịch hẹn theo DoctorID
    public List<Map<String, Object>> getAppointmentsByDoctorId(int doctorId) throws SQLException {
        List<Map<String, Object>> appointments = new ArrayList<>();
        String sql = "SELECT a.AppointmentID, a.AppointmentTime, a.Status, "
                + "u.FullName as PatientName, s.ServiceName, r.RoomName "
                + "FROM Appointments a "
                + "JOIN Users u ON a.PatientID = u.UserID "
                + "JOIN Services s ON a.ServiceID = s.ServiceID "
                + "JOIN Rooms r ON a.RoomID = r.RoomID "
                + "WHERE a.DoctorID = ? "
                + "ORDER BY a.AppointmentTime DESC";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> appointment = new HashMap<>();
                    appointment.put("appointmentId", rs.getInt("AppointmentID"));
                    appointment.put("appointmentTime", rs.getTimestamp("AppointmentTime"));
                    appointment.put("status", rs.getString("Status"));
                    appointment.put("patientName", rs.getString("PatientName"));
                    appointment.put("serviceName", rs.getString("ServiceName"));
                    appointment.put("roomName", rs.getString("RoomName"));
                    appointments.add(appointment);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAppointmentsByDoctorId: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return appointments;
    }
}