package model.dao;

import model.dao.DBContext; // Đảm bảo đường dẫn này đúng
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp; // Thêm import này
import java.time.LocalDate;
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
        // Kiểm tra shiftEnd phải sau shiftStart
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

    public boolean addSchedule(Schedules schedule) throws SQLException, ClassNotFoundException { // Thêm ClassNotFoundException
        String sql = "INSERT INTO Schedules (EmployeeID, Role, StartTime, EndTime, ShiftStartTime, ShiftEndTime, DayOfWeek, RoomID, Status, CreatedBy) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding schedule to DB: " + e.getMessage());
            throw e;
        }
    }

    public boolean isScheduleConflict(Schedules newSchedule) throws SQLException, ClassNotFoundException { // Thêm ClassNotFoundException
        // SQL Server syntax for combining DATE and TIME into DATETIME for comparison
        // Check for EmployeeID conflict first
        String sqlEmployeeConflict = "SELECT COUNT(*) FROM Schedules " +
                                     "WHERE EmployeeID = ? AND StartTime = ? AND " + // Same employee, same date
                                     // Overlap condition: (StartA < EndB) AND (EndA > StartB)
                                     "((DATEADD(hour, DATEPART(hour, ShiftStartTime), DATEADD(minute, DATEPART(minute, ShiftStartTime), CAST(StartTime AS DATETIME))) < DATEADD(hour, DATEPART(hour, ?), DATEADD(minute, DATEPART(minute, ?), CAST(? AS DATETIME)))) " + // Existing start < New end
                                     "AND (DATEADD(hour, DATEPART(hour, ShiftEndTime), DATEADD(minute, DATEPART(minute, ShiftEndTime), CAST(StartTime AS DATETIME))) > DATEADD(hour, DATEPART(hour, ?), DATEADD(minute, DATEPART(minute, ?), CAST(? AS DATETIME)))))"; // Existing end > New start

        boolean conflictFound = false;
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmtEmployee = conn.prepareStatement(sqlEmployeeConflict)) {
            pstmtEmployee.setInt(1, newSchedule.getEmployeeID());
            pstmtEmployee.setDate(2, newSchedule.getStartTime());

            // Parameters for new schedule's combined start/end
            // For new end time
            pstmtEmployee.setTime(3, newSchedule.getShiftEnd()); // Hour/Minute of new shiftEnd
            pstmtEmployee.setTime(4, newSchedule.getShiftEnd());
            pstmtEmployee.setDate(5, newSchedule.getStartTime()); // Date of new schedule

            // For new start time
            pstmtEmployee.setTime(6, newSchedule.getShiftStart()); // Hour/Minute of new shiftStart
            pstmtEmployee.setTime(7, newSchedule.getShiftStart());
            pstmtEmployee.setDate(8, newSchedule.getStartTime()); // Date of new schedule

            try (ResultSet rs = pstmtEmployee.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    conflictFound = true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking employee schedule conflict: " + e.getMessage());
            throw e;
        }

        if (conflictFound) return true; // If employee conflict found, no need to check room

        // Check for RoomID conflict
        String sqlRoomConflict = "SELECT COUNT(*) FROM Schedules " +
                                 "WHERE RoomID = ? AND StartTime = ? AND " + // Same room, same date
                                 // Overlap condition: (StartA < EndB) AND (EndA > StartB)
                                 "((DATEADD(hour, DATEPART(hour, ShiftStartTime), DATEADD(minute, DATEPART(minute, ShiftStartTime), CAST(StartTime AS DATETIME))) < DATEADD(hour, DATEPART(hour, ?), DATEADD(minute, DATEPART(minute, ?), CAST(? AS DATETIME)))) " + // Existing start < New end
                                 "AND (DATEADD(hour, DATEPART(hour, ShiftEndTime), DATEADD(minute, DATEPART(minute, ShiftEndTime), CAST(StartTime AS DATETIME))) > DATEADD(hour, DATEPART(hour, ?), DATEADD(minute, DATEPART(minute, ?), CAST(? AS DATETIME)))))"; // Existing end > New start

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmtRoom = conn.prepareStatement(sqlRoomConflict)) {
            pstmtRoom.setInt(1, newSchedule.getRoomID());
            pstmtRoom.setDate(2, newSchedule.getStartTime());

            // Parameters for new schedule's combined start/end
            // For new end time
            pstmtRoom.setTime(3, newSchedule.getShiftEnd());    // Hour/Minute of new shiftEnd
            pstmtRoom.setTime(4, newSchedule.getShiftEnd());
            pstmtRoom.setDate(5, newSchedule.getStartTime());   // Date of new schedule

            // For new start time
            pstmtRoom.setTime(6, newSchedule.getShiftStart());  // Hour/Minute of new shiftStart
            pstmtRoom.setTime(7, newSchedule.getShiftStart());
            pstmtRoom.setDate(8, newSchedule.getStartTime());   // Date of new schedule

            try (ResultSet rs = pstmtRoom.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    conflictFound = true; // If room conflict found
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
        // Logic kiểm tra bác sĩ/y tá cố định cho phòng nên ở tầng Business/Service, không phải DAO.
        // DAO chỉ nên tập trung vào tương tác CSDL.
        // Tạm thời để lại đây nhưng khuyến nghị di chuyển.
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
        // Đảm bảo tên cột trong SQL khớp với tên cột trong DB
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
                scheduleMap.put("startTime", rs.getDate("StartTime")); // Đây là ngày bắt đầu của lịch, không phải giờ làm việc
                scheduleMap.put("endTime", rs.getDate("EndTime"));     // Đây là ngày kết thúc của lịch, không phải giờ làm việc
                scheduleMap.put("dayOfWeek", rs.getString("DayOfWeek"));
                scheduleMap.put("roomID", rs.getInt("RoomID"));
                scheduleMap.put("shiftStart", rs.getTime("ShiftStartTime")); // <-- Correctly getting Time here
                scheduleMap.put("shiftEnd", rs.getTime("ShiftEndTime"));     // <-- Correctly getting Time here
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
        schedule.setShiftStart(rs.getTime("ShiftStartTime")); // <-- Correctly getting Time here
        schedule.setShiftEnd(rs.getTime("ShiftEndTime"));     // <-- Correctly getting Time here
        schedule.setStatus(rs.getString("Status"));
        schedule.setCreatedBy(rs.getInt("CreatedBy"));
        schedule.setCreatedAt(rs.getDate("CreatedAt"));
        schedule.setUpdatedAt(rs.getDate("UpdatedAt"));
        return schedule;
    }

    public boolean hasScheduleForRoleInPeriod(String role, LocalDate startDate, LocalDate endDate) throws SQLException, ClassNotFoundException { // Thêm ClassNotFoundException
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
}