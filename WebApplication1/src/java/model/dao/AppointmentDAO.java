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
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.entity.ScheduleEmployee;

public class AppointmentDAO {

    private final DBContext dbContext = DBContext.getInstance();

    // Phương thức tìm kiếm bác sĩ theo tên và chuyên môn
    public List<Users> searchDoctorsByNameAndSpecialty(String nameKeyword, String specialtyKeyword, int page, int pageSize) throws SQLException {
        List<Users> doctors = new ArrayList<>();
        String sql = "SELECT UserID, FullName, Specialization "
                + "FROM Users "
                + "WHERE Role = 'Doctor' AND Status = 'Active' "
                + (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "AND FullName LIKE ? " : "")
                + (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "AND Specialization LIKE ? " : "")
                + "ORDER BY UserID "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT COUNT(*) FROM Users "
                + "WHERE Role = 'Doctor' AND Status = 'Active' "
                + (nameKeyword != null && !nameKeyword.trim().isEmpty() ? "AND FullName LIKE ? " : "")
                + (specialtyKeyword != null && !specialtyKeyword.trim().isEmpty() ? "AND Specialization LIKE ? " : "");

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
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

    // Lấy danh sách lịch trình theo DoctorID
    public List<String> getSchedulesByDoctorId(int doctorId) throws SQLException {
        List<String> schedules = new ArrayList<>();
        String sql = "SELECT StartTime, EndTime, ShiftStartTime, ShiftEndTime, DayOfWeek FROM Schedules WHERE EmployeeID = ? AND Role = 'Doctor'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, doctorId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String schedule = rs.getDate("StartTime") + " to " + rs.getDate("EndTime")
                            + " (" + rs.getTime("ShiftStartTime") + " - " + rs.getTime("ShiftEndTime")
                            + ", " + rs.getString("DayOfWeek") + ")";
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
        String sql = "SELECT DISTINCT u.FullName "
                + "FROM Appointments a "
                + "JOIN Users u ON a.PatientID = u.UserID "
                + "WHERE a.RoomID = ?";
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

    // Lấy lịch trình theo Role và UserID
    public List<ScheduleEmployee> getSchedulesByRoleAndUserId(String role, Integer userId) throws SQLException {
//        List<Schedules> schedules = new ArrayList<>();
//        String sql = "SELECT ScheduleID, EmployeeID, Role, StartTime, EndTime, DayOfWeek, RoomID, ShiftStartTime,"
//                + " ShiftEndTime, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Schedules";
//        if (!"admin".equalsIgnoreCase(role)) {
//            sql += " WHERE Role = ? AND EmployeeID = ?";
//        }
//
//        try (Connection conn = dbContext.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            if (!"admin".equalsIgnoreCase(role)) {
//                stmt.setString(1, role);
//                stmt.setInt(2, userId);
//            }
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Schedules schedule = new Schedules();
//                    schedule.setScheduleID(rs.getInt("ScheduleID"));
//                    schedule.setEmployeeID(rs.getInt("EmployeeID"));
//                    schedule.setRole(rs.getString("Role"));
//                    schedule.setStartTime(rs.getDate("StartTime"));
//                    schedule.setEndTime(rs.getDate("EndTime"));
//                    schedule.setDayOfWeek(rs.getString("DayOfWeek"));
//                    schedule.setRoomID(rs.getInt("RoomID"));
//                    schedule.setShiftStart(rs.getTime("ShiftStartTime"));
//                    schedule.setShiftEnd(rs.getTime("ShiftEndTime"));
//                    schedule.setStatus(rs.getString("Status"));
//                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
//                    schedule.setCreatedAt(rs.getDate("CreatedAt"));
//                    schedule.setUpdatedAt(rs.getDate("UpdatedAt"));
//                    schedules.add(schedule);
//                }
//            }
//        } catch (SQLException e) {
//            System.err.println("SQLException in getSchedulesByRoleAndUserId: " + e.getMessage());
//            throw e;
//        }
//        return schedules;
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy,"
                + " CreatedAt, UpdatedAt FROM ScheduleEmployee";
        if (!"admin".equalsIgnoreCase(role)) {
            sql += " WHERE Role = ? AND UserID = ?";
        }
        
        try  {
            Connection conn = dbContext.getConnection(); 
            PreparedStatement stmt = conn.prepareStatement(sql); 
            
             if (!"admin".equalsIgnoreCase(role)) {
                stmt.setString(1, role);
                stmt.setInt(2, userId);
            }
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ScheduleEmployee schedule = new ScheduleEmployee();
                schedule.setSlotId(rs.getInt("SlotID"));
                schedule.setUserId(rs.getInt("UserID"));
                schedule.setRole(rs.getString("Role"));
                Object roomIdObj = rs.getObject("RoomID");
                schedule.setRoomId(roomIdObj != null ? (Integer) roomIdObj : null);
                schedule.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                schedule.setStartTime(rs.getTime("StartTime").toLocalTime());
                schedule.setEndTime(rs.getTime("EndTime").toLocalTime());
                schedule.setStatus(rs.getString("Status"));
                schedule.setCreatedBy(rs.getInt("CreatedBy"));
                schedule.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                schedule.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                schedules.add(schedule);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllSchedules: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
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

    // Hàm viewDetailBook hiển thị lịch trình, phòng, tên bác sĩ, và dịch vụ
    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
        Map<String, Object> details = new HashMap<>();

        // Lấy thông tin bác sĩ
        String doctorSql = "SELECT FullName, Specialization FROM Users WHERE UserID = ? AND Role = 'Doctor' AND Status = 'Active'";
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
        }

        // Lấy thông tin phòng
        String roomSql = "SELECT RoomID, RoomName FROM Rooms WHERE DoctorID = ? AND Status = 'Available'";
        int roomId = -1;
        String roomName = "N/A";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(roomSql)) {
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
        for (ScheduleEmployee schedule : getSchedulesByRoleAndUserId("Doctor", doctorId)) {
            Map<String, Object> scheduleMap = new HashMap<>();
            scheduleMap.put("scheduleID", schedule.getSlotId());
            scheduleMap.put("startTime", schedule.getStartTime());
            scheduleMap.put("endTime", schedule.getEndTime());
            scheduleMap.put("shiftStart", schedule.getStartTime());
            scheduleMap.put("shiftEnd", schedule.getEndTime());
//            scheduleMap.put("dayOfWeek", schedule.get()); //da ko con thuoc tinh nay
            scheduleMap.put("status", schedule.getStatus());
            schedules.add(scheduleMap);
        }
        details.put("schedules", schedules.isEmpty() ? List.of(Map.of("scheduleInfo", "N/A")) : schedules);

        return details;
    }

    // Tạo mới một lịch hẹn
    public boolean createAppointment(int patientId, int doctorId, int serviceId, int scheduleId, int roomId, Timestamp appointmentTime) throws SQLException {
        String sql = "INSERT INTO Appointments (PatientID, DoctorID, ServiceID, ScheduleID, RoomID, AppointmentTime, Status, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'Scheduled', ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, patientId);
            pstmt.setInt(2, doctorId);
            pstmt.setInt(3, serviceId);
            pstmt.setInt(4, scheduleId);
            pstmt.setInt(5, roomId);
            pstmt.setTimestamp(6, appointmentTime);
            Timestamp now = Timestamp.valueOf(LocalDateTime.now());
            pstmt.setTimestamp(7, now);
            pstmt.setTimestamp(8, now);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in createAppointment: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
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
                    appointment.put("appointmentTime", rs.getDate("AppointmentTime"));
                    appointment.put("status", rs.getString("Status"));
                    appointment.put("createdAt", rs.getDate("CreatedAt"));
                    appointment.put("updatedAt", rs.getDate("UpdatedAt"));
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

    // Xóa lịch hẹn theo ID (soft delete - cập nhật status thành 'Cancelled')
    public boolean cancelAppointment(int appointmentId) throws SQLException {
        String sql = "UPDATE Appointments SET Status = 'Cancelled', UpdatedAt = ? WHERE AppointmentID = ? AND Status != 'Cancelled'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, new Date(System.currentTimeMillis()));
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

    // Xóa nhiều lịch hẹn cùng lúc (soft delete)
    public int cancelMultipleAppointments(List<Integer> appointmentIds) throws SQLException {
        if (appointmentIds == null || appointmentIds.isEmpty()) {
            return 0;
        }

        String sql = "UPDATE Appointments SET Status = 'Cancelled', UpdatedAt = ? WHERE AppointmentID = ? AND Status != 'Cancelled'";
        int totalCancelled = 0;

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            Date now = new Date(System.currentTimeMillis());

            for (Integer appointmentId : appointmentIds) {
                pstmt.setDate(1, now);
                pstmt.setInt(2, appointmentId);
                pstmt.addBatch();
            }

            int[] results = pstmt.executeBatch();
            for (int result : results) {
                if (result > 0) {
                    totalCancelled++;
                }
            }
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
                    appointment.put("appointmentTime", rs.getDate("AppointmentTime"));
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
                    appointment.put("appointmentTime", rs.getDate("AppointmentTime"));
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
