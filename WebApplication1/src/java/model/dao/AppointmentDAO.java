package model.dao;

import model.entity.Users;
import model.entity.Schedules;
import model.entity.Rooms;
import model.entity.Services;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppointmentDAO {

    private final DBContext dbContext = DBContext.getInstance();

    // Phương thức tìm kiếm bác sĩ theo tên và chuyên môn
    public List<Users> searchDoctorsByNameAndSpecialty(String nameKeyword, String specialtyKeyword, int page, int pageSize) throws SQLException {
        List<Users> doctors = new ArrayList<>();
        String sql = "SELECT UserID, FullName, Specialization " +
                     "FROM Users " +
                     "WHERE Role = 'Doctor' AND Status = 'Active' " +
                     (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "AND FullName LIKE ? " : "") +
                     (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "AND Specialization LIKE ? " : "") +
                     "ORDER BY UserID " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (nameKeyword != null && !nameKeyword.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + nameKeyword.trim() + "%");
            }
            if (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + specialtyKeyword.trim() + "%");
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

    // Phương thức đếm tổng số bác sĩ
    public int getTotalDoctorRecords(String nameKeyword, String specialtyKeyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users " +
                     "WHERE Role = 'Doctor' AND Status = 'Active' " +
                     (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "AND FullName LIKE ? " : "") +
                     (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "AND Specialization LIKE ? " : "");

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int paramIndex = 1;
            if (nameKeyword != null && !nameKeyword.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + nameKeyword.trim() + "%");
            }
            if (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty()) {
                pstmt.setString(paramIndex++, "%" + specialtyKeyword.trim() + "%");
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
        String sql = "SELECT RoomName FROM Rooms WHERE DoctorID = ? AND Status = 'Available' LIMIT 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT DISTINCT s.ServiceName FROM Services s " +
                     "JOIN RoomServices rs ON s.ServiceID = rs.ServiceID " +
                     "JOIN Rooms r ON rs.RoomID = r.RoomID " +
                     "WHERE r.DoctorID = ? AND s.Status = 'Active'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    services.add(rs.getString("ServiceName"));
                }
            }
        }
        return services.isEmpty() ? List.of("N/A") : services;
    }

    // Lấy danh sách lịch trình theo DoctorID
    public List<String> getSchedulesByDoctorId(int doctorId) throws SQLException {
        List<String> schedules = new ArrayList<>();
        String sql = "SELECT StartTime, EndTime, ShiftStartTime, ShiftEndTime, DayOfWeek FROM Schedules WHERE EmployeeID = ? AND Role = 'Doctor'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String schedule = rs.getDate("StartTime") + " to " + rs.getDate("EndTime") +
                                     " (" + rs.getTime("ShiftStartTime") + " - " + rs.getTime("ShiftEndTime") +
                                     ", " + rs.getString("DayOfWeek") + ")";
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
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT s.* FROM RoomServices rs " +
                     "JOIN Services s ON rs.ServiceID = s.ServiceID " +
                     "WHERE rs.RoomID = ? AND s.Status = 'Active'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT DISTINCT u.FullName " +
                     "FROM Appointments a " +
                     "JOIN Users u ON a.PatientID = u.UserID " +
                     "WHERE a.RoomID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    // Lấy lịch trình theo Role và UserID
    public List<Schedules> getSchedulesByRoleAndUserId(String role, Integer userId) throws SQLException {
        List<Schedules> schedules = new ArrayList<>();
        String sql = "SELECT ScheduleID, EmployeeID, Role, StartTime, EndTime, DayOfWeek, RoomID, ShiftStartTime, ShiftEndTime, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Schedules";
        if (!"admin".equalsIgnoreCase(role)) sql += " WHERE Role = ? AND EmployeeID = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (!"admin".equalsIgnoreCase(role)) {
                stmt.setString(1, role);
                stmt.setInt(2, userId);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Schedules schedule = new Schedules();
                    schedule.setScheduleID(rs.getInt("ScheduleID"));
                    schedule.setEmployeeID(rs.getInt("EmployeeID"));
                    schedule.setRole(rs.getString("Role"));
                    schedule.setStartTime(rs.getDate("StartTime"));
                    schedule.setEndTime(rs.getDate("EndTime"));
                    schedule.setDayOfWeek(rs.getString("DayOfWeek"));
                    schedule.setRoomID(rs.getInt("RoomID"));
                    schedule.setShiftStart(rs.getTime("ShiftStartTime"));
                    schedule.setShiftEnd(rs.getTime("ShiftEndTime"));
                    schedule.setStatus(rs.getString("Status"));
                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
                    schedule.setCreatedAt(rs.getDate("CreatedAt"));
                    schedule.setUpdatedAt(rs.getDate("UpdatedAt"));
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByRoleAndUserId: " + e.getMessage());
            throw e;
        }
        return schedules;
    }

    // Lấy tên người dùng theo UserID
    public String getUserFullNameById(int userId) throws SQLException {
        String sql = "SELECT FullName FROM Users WHERE UserID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    // Hàm viewDetailBook hiển thị lịch trình, phòng, tên bác sĩ, và dịch vụ
    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
    Map<String, Object> details = new HashMap<>();

    // Lấy thông tin bác sĩ
    String doctorSql = "SELECT FullName, Specialization FROM Users WHERE UserID = ? AND Role = 'Doctor' AND Status = 'Active'";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(doctorSql)) {
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
    }

    // Lấy thông tin phòng
    String roomSql = "SELECT RoomID, RoomName FROM Rooms WHERE DoctorID = ? AND Status = 'Available'";
    int roomId = -1;
    String roomName = "N/A";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(roomSql)) {
        pstmt.setInt(1, doctorId);
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                roomId = rs.getInt("RoomID");
                roomName = rs.getString("RoomName");
            }
        }
    }
    details.put("roomID", roomId == -1 ? "N/A" : roomId);
    details.put("roomName", roomName);

    // Lấy danh sách dịch vụ
    List<Map<String, Object>> services = new ArrayList<>();
    if (roomId != -1) {
        for (Services service : getServicesByRoom(roomId)) {
            Map<String, Object> serviceMap = new HashMap<>();
            serviceMap.put("serviceID", service.getServiceID());
            serviceMap.put("serviceName", service.getServiceName());
            serviceMap.put("description", service.getDescription());
            serviceMap.put("price", service.getPrice());
            services.add(serviceMap);
        }
    }
    details.put("services", services.isEmpty() ? List.of(Map.of("serviceName", "N/A", "description", "N/A", "price", 0.0)) : services);

    // Lấy danh sách lịch trình
    List<Map<String, Object>> schedules = new ArrayList<>();
    for (Schedules schedule : getSchedulesByRoleAndUserId("Doctor", doctorId)) {
        Map<String, Object> scheduleMap = new HashMap<>();
        scheduleMap.put("scheduleID", schedule.getScheduleID());
        scheduleMap.put("startTime", schedule.getStartTime());
        scheduleMap.put("endTime", schedule.getEndTime());
        scheduleMap.put("shiftStart", schedule.getShiftStart());
        scheduleMap.put("shiftEnd", schedule.getShiftEnd());
        scheduleMap.put("dayOfWeek", schedule.getDayOfWeek());
        scheduleMap.put("status", schedule.getStatus());
        schedules.add(scheduleMap);
    }
    details.put("schedules", schedules.isEmpty() ? List.of(Map.of("scheduleInfo", "N/A")) : schedules);

    return details;
}
 public boolean bookAppointment(int doctorId, int patientId, String appointmentDate, String dayOfWeek, String shiftStart, String shiftEnd) throws SQLException {
        // Validate schedule availability
        String checkScheduleSql = "SELECT ScheduleID, RoomID FROM Schedules " +
                                 "WHERE EmployeeID = ? AND Role = 'Doctor' " +
                                 "AND StartTime = ? AND DayOfWeek = ? " +
                                 "AND ShiftStartTime = ? AND ShiftEndTime = ? AND Status = 'Available'";
        int scheduleId = -1;
        int roomId = -1;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(checkScheduleSql)) {
            pstmt.setInt(1, doctorId);
            pstmt.setDate(2, Date.valueOf(appointmentDate));
            pstmt.setString(3, dayOfWeek);
            pstmt.setTime(4, Time.valueOf(shiftStart));
            pstmt.setTime(5, Time.valueOf(shiftEnd));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    scheduleId = rs.getInt("ScheduleID");
                    roomId = rs.getInt("RoomID");
                } else {
                    System.err.println("No available schedule found for doctorId: " + doctorId + " on " + appointmentDate + " at " + shiftStart + " - " + shiftEnd);
                    return false;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in bookAppointment (check schedule) at " + LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }

        // Check if the appointment already exists
        String checkDuplicateSql = "SELECT COUNT(*) FROM Appointments WHERE ScheduleID = ? AND PatientID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(checkDuplicateSql)) {
            pstmt.setInt(1, scheduleId);
            pstmt.setInt(2, patientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    System.err.println("Duplicate appointment found for patientId: " + patientId + " on scheduleId: " + scheduleId);
                    return false;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in bookAppointment (check duplicate) at " + LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }

        // Insert new appointment
        String insertSql = "INSERT INTO Appointments (ScheduleID, PatientID, RoomID, DoctorID, AppointmentDate, DayOfWeek, ShiftStartTime, ShiftEndTime, Status, CreatedBy, CreatedAt) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Scheduled', ?, GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
            pstmt.setInt(1, scheduleId);
            pstmt.setInt(2, patientId);
            pstmt.setInt(3, roomId);
            pstmt.setInt(4, doctorId);
            pstmt.setDate(5, Date.valueOf(appointmentDate));
            pstmt.setString(6, dayOfWeek);
            pstmt.setTime(7, Time.valueOf(shiftStart));
            pstmt.setTime(8, Time.valueOf(shiftEnd));
            pstmt.setInt(9, patientId); // Assuming CreatedBy is the patient who created the appointment
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in bookAppointment (insert) at " + LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }
    }
}

