package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.entity.Schedules;
import model.entity.Rooms;

public class SchedulesDAO {
    private final DBContext dbContext;
    private final RoomsDAO roomsDAO;

    public SchedulesDAO() {
        this.dbContext = DBContext.getInstance();
        this.roomsDAO = new RoomsDAO();
    }

    private boolean isValidDateRange(Date startDate, Date endDate) {
        if (startDate == null || endDate == null) return false;
        return !startDate.after(endDate);
    }

    private boolean isValidShiftTime(Time shiftStart, Time shiftEnd) {
        if (shiftStart == null || shiftEnd == null) return false;
        return shiftEnd.after(shiftStart);
    }

    private boolean isValidDayOfWeek(String dayOfWeek) {
        if (dayOfWeek == null) return false;
        String[] validDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        for (String day : validDays) {
            if (day.equalsIgnoreCase(dayOfWeek)) return true;
        }
        return false;
    }

    private boolean isValidRole(String role) {
        if (role == null) return false;
        return "Doctor".equals(role) || "Nurse".equals(role) || "Receptionist".equals(role);
    }

    public boolean addSchedule(Schedules schedule) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO Schedules (EmployeeID, Role, StartTime, EndTime, ShiftStartTime, ShiftEndTime, DayOfWeek, RoomID, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, schedule.getEmployeeID());
            pstmt.setString(2, schedule.getRole());
            pstmt.setDate(3, schedule.getStartTime());
            pstmt.setDate(4, schedule.getEndTime());
            pstmt.setTime(5, schedule.getShiftStart());
            pstmt.setTime(6, schedule.getShiftEnd());
            pstmt.setString(7, schedule.getDayOfWeek());
            pstmt.setInt(8, schedule.getRoomID());
            pstmt.setString(9, schedule.getStatus());
            pstmt.setInt(10, schedule.getCreatedBy());
            pstmt.setTimestamp(11, new java.sql.Timestamp(System.currentTimeMillis()));
            pstmt.setTimestamp(12, new java.sql.Timestamp(System.currentTimeMillis()));
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding schedule: " + e.getMessage());
            throw e;
        }
    }

    public boolean isScheduleConflict(Schedules newSchedule) throws SQLException, ClassNotFoundException {
        String sqlRoomConflict = "SELECT COUNT(*) FROM Schedules " +
                                "WHERE RoomID = ? AND StartTime = ? AND " +
                                "((DATEADD(hour, DATEPART(hour, ShiftStartTime), DATEADD(minute, DATEPART(minute, ShiftStartTime), CAST(StartTime AS DATETIME))) < DATEADD(hour, DATEPART(hour, ?), DATEADD(minute, DATEPART(minute, ?), CAST(? AS DATETIME)))) " +
                                "AND (DATEADD(hour, DATEPART(hour, ShiftEndTime), DATEADD(minute, DATEPART(minute, ShiftEndTime), CAST(StartTime AS DATETIME))) > DATEADD(hour, DATEPART(hour, ?), DATEADD(minute, DATEPART(minute, ?), CAST(? AS DATETIME)))))";

        boolean conflictFound = false;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmtRoom = conn.prepareStatement(sqlRoomConflict)) {
            pstmtRoom.setInt(1, newSchedule.getRoomID());
            pstmtRoom.setDate(2, newSchedule.getStartTime());
            pstmtRoom.setTime(3, newSchedule.getShiftEnd());
            pstmtRoom.setTime(4, newSchedule.getShiftEnd());
            pstmtRoom.setDate(5, newSchedule.getStartTime());
            pstmtRoom.setTime(6, newSchedule.getShiftStart());
            pstmtRoom.setTime(7, newSchedule.getShiftStart());
            pstmtRoom.setDate(8, newSchedule.getStartTime());

            try (ResultSet rs = pstmtRoom.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    conflictFound = true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking room schedule conflict: " + e.getMessage());
            throw e;
        }

        return conflictFound;
    }

    public boolean updateSchedule(Schedules schedule) throws SQLException, ClassNotFoundException {
        if (schedule == null) throw new SQLException("Schedule object cannot be null.");
        if (!isValidDateRange(schedule.getStartTime(), schedule.getEndTime())) {
            throw new SQLException("Invalid date range for schedule.");
        }
        if (!isValidShiftTime(schedule.getShiftStart(), schedule.getShiftEnd())) {
            throw new SQLException("Invalid shift time range for schedule.");
        }
        if (!isValidDayOfWeek(schedule.getDayOfWeek())) {
            throw new SQLException("Invalid day of week for schedule.");
        }
        if (!isValidRole(schedule.getRole())) {
            throw new SQLException("Invalid role for schedule.");
        }

        Rooms room = roomsDAO.getRoomByID(schedule.getRoomID());
        if (room == null || !room.getStatus().equals("Available")) {
            System.err.println("Room " + schedule.getRoomID() + " is not available or does not exist for update.");
            return false;
        }
        if ("Doctor".equals(schedule.getRole()) && schedule.getEmployeeID() != room.getDoctorID()) {
            System.err.println("Employee " + schedule.getEmployeeID() + " (Doctor) is not the fixed doctor for Room " + schedule.getRoomID() + " for update.");
            return false;
        }
        if ("Nurse".equals(schedule.getRole()) && schedule.getEmployeeID() != room.getNurseID()) {
            System.err.println("Employee " + schedule.getEmployeeID() + " (Nurse) is not the fixed nurse for Room " + schedule.getRoomID() + " for update.");
            return false;
        }

        String query = "UPDATE Schedules SET EmployeeID = ?, Role = ?, StartTime = ?, EndTime = ?, DayOfWeek = ?, RoomID = ?, ShiftStartTime = ?, ShiftEndTime = ?, [Status] = ?, CreatedBy = ?, UpdatedAt = GETDATE() WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, schedule.getEmployeeID());
            stmt.setString(2, schedule.getRole());
            stmt.setDate(3, schedule.getStartTime());
            stmt.setDate(4, schedule.getEndTime());
            stmt.setString(5, schedule.getDayOfWeek());
            stmt.setInt(6, schedule.getRoomID());
            stmt.setTime(7, schedule.getShiftStart());
            stmt.setTime(8, schedule.getShiftEnd());
            stmt.setString(9, schedule.getStatus());
            stmt.setInt(10, schedule.getCreatedBy());
            stmt.setInt(11, schedule.getScheduleID());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in updateSchedule: " + e.getMessage());
            throw e;
        }
    }

    public List<Schedules> getAllSchedules() throws SQLException, ClassNotFoundException {
        List<Schedules> schedules = new ArrayList<>();
        String sql = "SELECT ScheduleID, EmployeeID, Role, StartTime, EndTime, DayOfWeek, RoomID, ShiftStartTime, ShiftEndTime, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Schedules";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                schedules.add(mapResultSetToSchedule(rs));
            }
        }
        return schedules;
    }

    public List<Map<String, Object>> getAllSchedulesWithUserInfo() throws SQLException, ClassNotFoundException {
        List<Map<String, Object>> schedules = new ArrayList<>();
        String sql = "SELECT s.ScheduleID, s.EmployeeID, s.Role, s.StartTime, s.EndTime, s.DayOfWeek, s.RoomID, s.ShiftStartTime, s.ShiftEndTime, s.[Status], s.CreatedBy, s.CreatedAt, s.UpdatedAt, u.fullName " +
                     "FROM Schedules s " +
                     "LEFT JOIN Users u ON s.EmployeeID = u.userID";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> scheduleMap = new HashMap<>();
                scheduleMap.put("scheduleID", rs.getInt("ScheduleID"));
                scheduleMap.put("employeeID", rs.getInt("EmployeeID"));
                scheduleMap.put("role", rs.getString("Role"));
                scheduleMap.put("startTime", rs.getDate("StartTime"));
                scheduleMap.put("endTime", rs.getDate("EndTime"));
                scheduleMap.put("dayOfWeek", rs.getString("DayOfWeek"));
                scheduleMap.put("roomID", rs.getInt("RoomID"));
                scheduleMap.put("shiftStart", rs.getTime("ShiftStartTime"));
                scheduleMap.put("shiftEnd", rs.getTime("ShiftEndTime"));
                scheduleMap.put("status", rs.getString("Status"));
                scheduleMap.put("createdBy", rs.getInt("CreatedBy"));
                scheduleMap.put("createdAt", rs.getDate("CreatedAt"));
                scheduleMap.put("updatedAt", rs.getDate("UpdatedAt"));
                scheduleMap.put("fullName", rs.getString("fullName") != null ? rs.getString("fullName") : "Unknown");
                schedules.add(scheduleMap);
            }
        }
        return schedules;
    }

    public List<Map<String, Object>> searchSchedule(String employeeName, String role, String employeeID, LocalDate searchDate) throws SQLException, ClassNotFoundException {
        List<Map<String, Object>> schedules = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT s.ScheduleID, s.EmployeeID, s.Role, s.StartTime, s.EndTime, s.DayOfWeek, s.RoomID, " +
            "s.ShiftStartTime, s.ShiftEndTime, s.[Status], s.CreatedBy, s.CreatedAt, s.UpdatedAt, u.fullName " +
            "FROM Schedules s LEFT JOIN Users u ON s.EmployeeID = u.userID WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();
        int paramIndex = 1;

        if (employeeName != null && !employeeName.trim().isEmpty()) {
            sql.append(" AND u.fullName LIKE ?");
            params.add("%" + employeeName.trim() + "%");
        }
        if (role != null && !role.trim().isEmpty()) {
            sql.append(" AND s.Role = ?");
            params.add(role.trim());
        }
        if (employeeID != null && !employeeID.trim().isEmpty()) {
            sql.append(" AND s.EmployeeID = ?");
            params.add(Integer.parseInt(employeeID.trim()));
        }
        if (searchDate != null) {
            sql.append(" AND s.StartTime = ?");
            params.add(Date.valueOf(searchDate));
        }

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(paramIndex++, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> scheduleMap = new HashMap<>();
                    scheduleMap.put("scheduleID", rs.getInt("ScheduleID"));
                    scheduleMap.put("employeeID", rs.getInt("EmployeeID"));
                    scheduleMap.put("role", rs.getString("Role"));
                    scheduleMap.put("startTime", rs.getDate("StartTime"));
                    scheduleMap.put("endTime", rs.getDate("EndTime"));
                    scheduleMap.put("dayOfWeek", rs.getString("DayOfWeek"));
                    scheduleMap.put("roomID", rs.getInt("RoomID"));
                    scheduleMap.put("shiftStart", rs.getTime("ShiftStartTime"));
                    scheduleMap.put("shiftEnd", rs.getTime("ShiftEndTime"));
                    scheduleMap.put("status", rs.getString("Status"));
                    scheduleMap.put("createdBy", rs.getInt("CreatedBy"));
                    scheduleMap.put("createdAt", rs.getDate("CreatedAt"));
                    scheduleMap.put("updatedAt", rs.getDate("UpdatedAt"));
                    scheduleMap.put("fullName", rs.getString("fullName") != null ? rs.getString("fullName") : "Unknown");
                    schedules.add(scheduleMap);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in searchSchedule: " + e.getMessage());
            throw e;
        }
        return schedules;
    }

    public List<Schedules> getSchedulesByRoleAndUserId(String role, Integer userId) throws SQLException, ClassNotFoundException {
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
                    schedules.add(mapResultSetToSchedule(rs));
                }
            }
        }
        return schedules;
    }

    public Schedules getScheduleById(int scheduleID) throws SQLException, ClassNotFoundException {
        String query = "SELECT ScheduleID, EmployeeID, Role, StartTime, EndTime, DayOfWeek, RoomID, ShiftStartTime, ShiftEndTime, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Schedules WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return mapResultSetToSchedule(rs);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getScheduleById: " + e.getMessage());
            throw e;
        }
        return null;
    }

    public boolean deleteSchedule(int scheduleID) throws SQLException, ClassNotFoundException {
        String query = "DELETE FROM Schedules WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                System.err.println("Schedule with ID " + scheduleID + " not found for deletion.");
                return false;
            }
            return true;
        } catch (SQLException e) {
            System.err.println("SQLException in deleteSchedule: " + e.getMessage());
            throw e;
        }
    }

    public List<Schedules> getSchedulesByRole(String role) throws SQLException, ClassNotFoundException {
        List<Schedules> schedules = new ArrayList<>();
        String sql = "SELECT ScheduleID, EmployeeID, Role, StartTime, EndTime, DayOfWeek, RoomID, ShiftStartTime, ShiftEndTime, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Schedules WHERE Role = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToSchedule(rs));
                }
            }
        }
        return schedules;
    }

    public List<Schedules> getSchedulesByEmployeeId(int employeeID) throws SQLException, ClassNotFoundException {
        List<Schedules> schedules = new ArrayList<>();
        String sql = "SELECT ScheduleID, EmployeeID, Role, StartTime, EndTime, DayOfWeek, RoomID, ShiftStartTime, ShiftEndTime, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Schedules WHERE EmployeeID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, employeeID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    schedules.add(mapResultSetToSchedule(rs));
                }
            }
        }
        return schedules;
    }

    private Schedules mapResultSetToSchedule(ResultSet rs) throws SQLException {
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
        return schedule;
    }

    public boolean hasScheduleForRoleInPeriod(String role, LocalDate startDate, LocalDate endDate) throws SQLException, ClassNotFoundException {
        String query = "SELECT COUNT(*) FROM Schedules " +
                       "WHERE Role = ? " +
                       "AND StartTime >= ? AND StartTime <= ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, role);
            ps.setDate(2, Date.valueOf(startDate));
            ps.setDate(3, Date.valueOf(endDate));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    public Map<String, Object> ViewDetailSchedule(int scheduleID) throws SQLException, ClassNotFoundException {
        if (scheduleID <= 0) {
            throw new IllegalArgumentException("ID lịch không hợp lệ.");
        }

        Map<String, Object> scheduleDetails = new HashMap<>();
        Schedules schedule = getScheduleById(scheduleID);
        if (schedule == null) {
            throw new SQLException("Lịch với ID " + scheduleID + " không tồn tại.");
        }

        // Thêm thông tin cơ bản của lịch
        scheduleDetails.put("scheduleID", schedule.getScheduleID());
        scheduleDetails.put("employeeID", schedule.getEmployeeID());
        scheduleDetails.put("role", schedule.getRole());
        scheduleDetails.put("startTime", schedule.getStartTime());
        scheduleDetails.put("endTime", schedule.getEndTime());
        scheduleDetails.put("shiftStart", schedule.getShiftStart());
        scheduleDetails.put("shiftEnd", schedule.getShiftEnd());
        scheduleDetails.put("dayOfWeek", schedule.getDayOfWeek());
        scheduleDetails.put("roomID", schedule.getRoomID());
        scheduleDetails.put("status", schedule.getStatus());

        // Lấy thông tin phòng
        Rooms room = roomsDAO.getRoomByID(schedule.getRoomID());
        String roomName = room != null ? room.getRoomName() : "N/A";
        scheduleDetails.put("roomName", roomName);

        // Lấy ID và tên bác sĩ/y tá từ bảng Rooms và Users
        String doctorName = "N/A";
        String nurseName = "N/A";
        Integer doctorID = null;
        Integer nurseID = null;

        if (dbContext != null) {
            try (Connection conn = dbContext.getConnection()) {
                if (conn != null) {
                    if (room != null && room.getDoctorID() != 0) {
                        doctorID = room.getDoctorID();
                        String sqlDoctor = "SELECT FullName FROM Users WHERE UserID = ? AND Role = 'Doctor'";
                        try (PreparedStatement stmt = conn.prepareStatement(sqlDoctor)) {
                            stmt.setInt(1, doctorID);
                            try (ResultSet rs = stmt.executeQuery()) {
                                if (rs.next()) {
                                    doctorName = rs.getString("FullName") != null ? rs.getString("FullName") : "N/A";
                                }
                            }
                        } catch (SQLException e) {
                            System.err.println("Lỗi khi thực thi truy vấn bác sĩ: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
                            throw e;
                        }
                    }
                   if (room != null && room.getDoctorID() != 0) {
                        nurseID = room.getNurseID();
                        String sqlNurse = "SELECT FullName FROM Users WHERE UserID = ? AND Role = 'Nurse'";
                        try (PreparedStatement stmt = conn.prepareStatement(sqlNurse)) {
                            stmt.setInt(1, nurseID);
                            try (ResultSet rs = stmt.executeQuery()) {
                                if (rs.next()) {
                                    nurseName = rs.getString("FullName") != null ? rs.getString("FullName") : "N/A";
                                }
                            }
                        } catch (SQLException e) {
                            System.err.println("Lỗi khi thực thi truy vấn y tá: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
                            throw e;
                        }
                    }
                } else {
                    System.err.println("Không thể lấy kết nối cơ sở dữ liệu tại " + LocalDateTime.now() + " +07");
                }
            } catch (SQLException e) {
                System.err.println("Lỗi khi lấy kết nối: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
                throw e;
            }
        } else {
            System.err.println("DBContext không được khởi tạo tại " + LocalDateTime.now() + " +07");
        }

        scheduleDetails.put("doctorID", doctorID != null ? doctorID : "N/A");
        scheduleDetails.put("doctorName", doctorName);
        scheduleDetails.put("nurseID", nurseID != null ? nurseID : "N/A");
        scheduleDetails.put("nurseName", nurseName);

        // Lấy danh sách dịch vụ phòng
        List<Map<String, Object>> services = new ArrayList<>();
        if (dbContext != null) {
            try (Connection conn = dbContext.getConnection()) {
                if (conn != null) {
                    String sqlServices = "SELECT s.ServiceName, s.Price FROM RoomServices rs JOIN Services s ON rs.ServiceID = s.ServiceID WHERE rs.RoomID = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(sqlServices)) {
                        stmt.setInt(1, schedule.getRoomID());
                        try (ResultSet rs = stmt.executeQuery()) {
                            while (rs.next()) {
                                Map<String, Object> service = new HashMap<>();
                                service.put("serviceName", rs.getString("ServiceName"));
                                service.put("price", rs.getDouble("Price"));
                                services.add(service);
                            }
                        }
                    }
                } else {
                    System.err.println("Không thể lấy kết nối cơ sở dữ liệu tại " + LocalDateTime.now() + " +07");
                }
            } catch (SQLException e) {
                System.err.println("Lỗi khi lấy dịch vụ phòng: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
                services.add(Map.of("serviceName", "N/A", "price", 0.0));
            }
        } else {
            System.err.println("DBContext không được khởi tạo tại " + LocalDateTime.now() + " +07");
            services.add(Map.of("serviceName", "N/A", "price", 0.0));
        }
        scheduleDetails.put("services", services.isEmpty() ? List.of(Map.of("serviceName", "N/A", "price", 0.0)) : services);

        // Lấy danh sách bệnh nhân trong phòng
        List<Map<String, Object>> patients = new ArrayList<>();
        if (dbContext != null) {
            try (Connection conn = dbContext.getConnection()) {
                if (conn != null) {
                    String sqlPatients = "SELECT p.PatientID, p.FullName FROM RoomAssignments ra JOIN Patients p ON ra.PatientID = p.PatientID WHERE ra.RoomID = ? AND ra.Status = 'Active' AND ? BETWEEN ra.StartDate AND ra.EndDate";
                    try (PreparedStatement stmt = conn.prepareStatement(sqlPatients)) {
                        stmt.setInt(1, schedule.getRoomID());
                        stmt.setDate(2, schedule.getStartTime());
                        try (ResultSet rs = stmt.executeQuery()) {
                            while (rs.next()) {
                                Map<String, Object> patient = new HashMap<>();
                                patient.put("patientID", rs.getInt("PatientID"));
                                patient.put("fullName", rs.getString("FullName"));
                                patients.add(patient);
                            }
                        }
                    }
                } else {
                    System.err.println("Không thể lấy kết nối cơ sở dữ liệu tại " + LocalDateTime.now() + " +07");
                }
            } catch (SQLException e) {
                System.err.println("Lỗi khi lấy danh sách bệnh nhân: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
                patients.add(Map.of("patientID", "N/A", "fullName", "N/A"));
            }
        } else {
            System.err.println("DBContext không được khởi tạo tại " + LocalDateTime.now() + " +07");
            patients.add(Map.of("patientID", "N/A", "fullName", "N/A"));
        }
        scheduleDetails.put("patients", patients.isEmpty() ? List.of(Map.of("patientID", "N/A", "fullName", "N/A")) : patients);

        return scheduleDetails;
    }
}