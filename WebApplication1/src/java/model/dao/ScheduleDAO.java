package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import model.entity.ScheduleEmployee;
import model.entity.Rooms;
import model.entity.Services;

public class ScheduleDAO {

    private final DBContext dbContext;
    private final RoomsDAO roomsDAO; // Assuming RoomsDAO is correctly implemented elsewhere

    public ScheduleDAO() {
        this.dbContext = DBContext.getInstance();
        this.roomsDAO = new RoomsDAO(); // Initialize RoomsDAO
    }

    // Tạo lịch tự động
    public void addSchedule(List<Integer> userIds, List<String> roles, int defaultRoomId, int createdBy, LocalDate startDate, int weeks)
            throws SQLException, ClassNotFoundException {
        if (userIds.size() != roles.size()) {
            throw new IllegalArgumentException("The number of userIds must match the number of roles.");
        }

        LocalDate endDate = startDate.plusWeeks(weeks).plusDays(1); // Use the weeks parameter
        LocalTime morningStart = LocalTime.of(7, 30);
        LocalTime morningEnd = LocalTime.of(12, 30);
        LocalTime afternoonStart = LocalTime.of(13, 30);
        LocalTime afternoonEnd = LocalTime.of(17, 30);

        String insertScheduleSql = "INSERT INTO ScheduleEmployee (UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        String checkConflictSql = "SELECT COUNT(*) FROM ScheduleEmployee WHERE UserID = ? AND SlotDate = ? AND "
                + "((StartTime <= ? AND EndTime > ?) OR (StartTime < ? AND EndTime >= ?)) AND Status != 'Cancelled'";
        String insertNotificationSql = "INSERT INTO Notifications (SenderID, SenderRole, ReceiverID, ReceiverRole, Title, Message, IsRead, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = dbContext.getConnection(); PreparedStatement insertStmt = conn.prepareStatement(insertScheduleSql); PreparedStatement conflictStmt = conn.prepareStatement(checkConflictSql); PreparedStatement notifyStmt = conn.prepareStatement(insertNotificationSql)) {

            conn.setAutoCommit(false);

            for (LocalDate date = startDate; date.isBefore(endDate); date = date.plusDays(1)) {
                if (date.getDayOfWeek().getValue() <= 6) { // Không tạo lịch cho Chủ Nhật
                    for (int i = 0; i < userIds.size(); i++) {
                        int userId = userIds.get(i);
                        String role = roles.get(i);
                        Integer roomIdToUse = null;
                        if ("Receptionist".equalsIgnoreCase(role) && defaultRoomId > 0) {
                            roomIdToUse = defaultRoomId;
                        }

                        // Morning slot conflict check
                        conflictStmt.setInt(1, userId);
                        conflictStmt.setDate(2, Date.valueOf(date));
                        conflictStmt.setTime(3, Time.valueOf(morningStart));
                        conflictStmt.setTime(4, Time.valueOf(morningStart));
                        conflictStmt.setTime(5, Time.valueOf(morningEnd));
                        conflictStmt.setTime(6, Time.valueOf(morningEnd));
                        try (ResultSet rs = conflictStmt.executeQuery()) {
                            if (rs.next() && rs.getInt(1) == 0) {
                                insertStmt.setInt(1, userId);
                                insertStmt.setString(2, role);
                                if (roomIdToUse != null) {
                                    insertStmt.setInt(3, roomIdToUse);
                                } else {
                                    insertStmt.setNull(3, java.sql.Types.INTEGER);
                                }
                                insertStmt.setDate(4, Date.valueOf(date));
                                insertStmt.setTime(5, Time.valueOf(morningStart));
                                insertStmt.setTime(6, Time.valueOf(morningEnd));
                                insertStmt.setString(7, "Available");
                                insertStmt.setInt(8, createdBy);
                                insertStmt.addBatch();

                                notifyStmt.setInt(1, createdBy);
                                notifyStmt.setString(2, "receptionist");
                                notifyStmt.setInt(3, userId);
                                notifyStmt.setString(4, role);
                                notifyStmt.setString(5, "Lịch làm việc mới");
                                notifyStmt.setString(6, "Bạn được phân lịch ngày " + date + " từ " + morningStart + " đến " + morningEnd);
                                notifyStmt.setBoolean(7, false);
                                notifyStmt.addBatch();
                            }
                        }

                        // Afternoon slot conflict check
                        conflictStmt.setInt(1, userId);
                        conflictStmt.setDate(2, Date.valueOf(date));
                        conflictStmt.setTime(3, Time.valueOf(afternoonStart));
                        conflictStmt.setTime(4, Time.valueOf(afternoonStart));
                        conflictStmt.setTime(5, Time.valueOf(afternoonEnd));
                        conflictStmt.setTime(6, Time.valueOf(afternoonEnd));
                        try (ResultSet rs = conflictStmt.executeQuery()) {
                            if (rs.next() && rs.getInt(1) == 0) {
                                insertStmt.setInt(1, userId);
                                insertStmt.setString(2, role);
                                if (roomIdToUse != null) {
                                    insertStmt.setInt(3, roomIdToUse);
                                } else {
                                    insertStmt.setNull(3, java.sql.Types.INTEGER);
                                }
                                insertStmt.setDate(4, Date.valueOf(date));
                                insertStmt.setTime(5, Time.valueOf(afternoonStart));
                                insertStmt.setTime(6, Time.valueOf(afternoonEnd));
                                insertStmt.setString(7, "Available");
                                insertStmt.setInt(8, createdBy);
                                insertStmt.addBatch();

                                notifyStmt.setInt(1, createdBy);
                                notifyStmt.setString(2, "Receptionist");
                                notifyStmt.setInt(3, userId);
                                notifyStmt.setString(4, role);
                                notifyStmt.setString(5, "Lịch làm việc mới");
                                notifyStmt.setString(6, "Bạn được phân lịch ngày " + date + " từ " + afternoonStart + " đến " + afternoonEnd);
                                notifyStmt.setBoolean(7, false);
                                notifyStmt.addBatch();
                            }
                        }
                    }
                }
            }

            insertStmt.executeBatch();
            notifyStmt.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo lịch làm việc: " + e.getMessage());
            if (dbContext.getConnection() != null) {
                try {
                    dbContext.getConnection().rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
            throw e;
        }
    }

    // Thêm slot
    public boolean addScheduleEmployee(ScheduleEmployee slot) throws SQLException, ClassNotFoundException {
        if (slot == null || slot.getUserId() <= 0 || slot.getRole() == null || slot.getSlotDate() == null) {
            throw new IllegalArgumentException("Invalid schedule employee data.");
        }

        // Removed IsAbsent and AbsenceReason from INSERT statement
        String sql = "INSERT INTO ScheduleEmployee (UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slot.getUserId());
            pstmt.setString(2, slot.getRole());
            // Handle RoomID: if it's 0, set as NULL in DB. For Receptionist, default to 1 if defaultRoomId is used.
            if (slot.getRoomId() > 0) {
                pstmt.setInt(3, slot.getRoomId());
            } else if (Objects.equals(slot.getRole(), "Receptionist")) { // Assuming default RoomID 1 for Receptionist if no specific room is provided
                pstmt.setInt(3, 1);
            } else {
                pstmt.setNull(3, java.sql.Types.INTEGER);
            }
            pstmt.setDate(4, Date.valueOf(slot.getSlotDate()));
            pstmt.setTime(5, Time.valueOf(slot.getStartTime()));
            pstmt.setTime(6, Time.valueOf(slot.getEndTime()));
            // Removed pstmt.setBoolean(7, slot.isAbsent());
            // Removed pstmt.setString(8, slot.getAbsenceReason());
            pstmt.setString(7, slot.getStatus()); // Shifted index
            pstmt.setInt(8, slot.getCreatedBy()); // Shifted index
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding schedule employee slot: " + e.getMessage());
            throw e;
        }
    }

    public List<ScheduleEmployee> getAllScheduleEmployees() throws SQLException {
        List<ScheduleEmployee> slots = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, "
                + "CreatedBy, CreatedAt, UpdatedAt FROM ScheduleEmployee";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ScheduleEmployee slot = new ScheduleEmployee();
                slot.setSlotId(rs.getInt("SlotID"));
                slot.setUserId(rs.getInt("UserID"));
                slot.setRole(rs.getString("Role"));
                int roomId = rs.getInt("RoomID");
                slot.setRoomId(rs.wasNull() ? 0 : roomId);
                slot.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                slot.setStartTime(rs.getTime("StartTime").toLocalTime());
                slot.setEndTime(rs.getTime("EndTime").toLocalTime());
                slot.setStatus(rs.getString("Status"));
                slot.setCreatedBy(rs.getInt("CreatedBy"));
                slot.setCreatedAt(rs.getObject("CreatedAt", LocalDateTime.class));
                slot.setUpdatedAt(rs.getObject("UpdatedAt", LocalDateTime.class));
                slots.add(slot);
            }
        }
        return slots;
    }

    public ScheduleEmployee getScheduleEmployeeById(int slotId) throws SQLException, ClassNotFoundException {
        // Removed IsAbsent and AbsenceReason from SELECT statement
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt FROM ScheduleEmployee WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ScheduleEmployee slot = new ScheduleEmployee();
                    slot.setSlotId(rs.getInt("SlotID"));
                    slot.setUserId(rs.getInt("UserID"));
                    slot.setRole(rs.getString("Role"));

                    // Read RoomID, it can be null
                    int roomId = rs.getInt("RoomID");
                    if (rs.wasNull()) {
                        slot.setRoomId(0); // Represent NULL as 0 or handle as Integer object
                    } else {
                        slot.setRoomId(roomId);
                    }

                    slot.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                    slot.setStartTime(rs.getTime("StartTime").toLocalTime());
                    slot.setEndTime(rs.getTime("EndTime").toLocalTime());
                    // Removed slot.setAbsent(rs.getBoolean("IsAbsent"));
                    // Removed slot.setAbsenceReason(rs.getString("AbsenceReason"));
                    slot.setStatus(rs.getString("Status"));
                    slot.setCreatedBy(rs.getInt("CreatedBy"));
                    slot.setCreatedAt(rs.getObject("CreatedAt", LocalDateTime.class));
                    slot.setUpdatedAt(rs.getObject("UpdatedAt", LocalDateTime.class));
                    return slot;
                }
            }
        }
        return null;
    }

    public boolean deleteScheduleEmployee(int slotId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM ScheduleEmployee WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting schedule employee slot: " + e.getMessage());
            throw e;
        }
    }

    public List<ScheduleEmployee> getScheduleEmployeesByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        List<ScheduleEmployee> slots = new ArrayList<>();
        // Removed IsAbsent and AbsenceReason from SELECT statement
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status "
                + "FROM ScheduleEmployee WHERE SlotDate BETWEEN ? AND ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee slot = new ScheduleEmployee();
                    slot.setSlotId(rs.getInt("SlotID"));
                    slot.setUserId(rs.getInt("UserID"));
                    slot.setRole(rs.getString("Role"));

                    // Read RoomID, it can be null
                    int roomId = rs.getInt("RoomID");
                    if (rs.wasNull()) {
                        slot.setRoomId(0); // Represent NULL as 0 or handle as Integer object
                    } else {
                        slot.setRoomId(roomId);
                    }

                    slot.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                    Time startTime = rs.getTime("StartTime");
                    Time endTime = rs.getTime("EndTime");
                    slot.setStartTime(startTime != null ? startTime.toLocalTime() : null);
                    slot.setEndTime(endTime != null ? endTime.toLocalTime() : null);

                    // Removed slot.setAbsent(rs.getBoolean("IsAbsent"));
                    // Removed slot.setAbsenceReason(rs.getString("AbsenceReason"));
                    slot.setStatus(rs.getString("Status"));
                    slots.add(slot);
                }
            }
        }
        return slots;
    }

    public boolean assignRoomToSchedule(int slotId, Integer roomId) throws SQLException {
    String updateScheduleSql = "UPDATE ScheduleEmployee SET RoomID = ?, UpdatedAt = GETDATE() WHERE SlotID = ?";
    String updateRoomSql = "UPDATE Rooms SET UserID = (SELECT UserID FROM ScheduleEmployee WHERE SlotID = ?), " +
                          "Role = (SELECT Role FROM ScheduleEmployee WHERE SlotID = ?), UpdatedAt = GETDATE() WHERE RoomID = ?";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmtSchedule = conn.prepareStatement(updateScheduleSql);
         PreparedStatement stmtRoom = conn.prepareStatement(updateRoomSql)) {
        conn.setAutoCommit(false);
        stmtSchedule.setInt(1, roomId != null ? roomId : 0);
        stmtSchedule.setInt(2, slotId);
        int scheduleRows = stmtSchedule.executeUpdate();

        if (roomId != null && roomId > 0 && scheduleRows > 0) {
            stmtRoom.setInt(1, slotId);
            stmtRoom.setInt(2, slotId);
            stmtRoom.setInt(3, roomId);
            int roomRows = stmtRoom.executeUpdate();
            if (roomRows == 0) {
                throw new SQLException("Không thể cập nhật thông tin phòng trong Rooms.");
            }
        }
        conn.commit();
        return scheduleRows > 0;
    } catch (SQLException e) {
        System.err.println("SQLException in assignRoomToSchedule: " + e.getMessage());
        throw e;
    }
}

    public List<ScheduleEmployee> getSchedulesWithoutRoom(int userId, LocalDate slotDate) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt "
                + "FROM ScheduleEmployee "
                + "WHERE UserID = ? AND SlotDate = ? AND RoomID IS NULL AND Status = 'Active'";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setDate(2, java.sql.Date.valueOf(slotDate));
            try (ResultSet rs = stmt.executeQuery()) {
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
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesWithoutRoom: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    public List<ScheduleEmployee> getSchedulesByDetails(int userId, LocalDate slotDate, String role) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt "
                + "FROM ScheduleEmployee "
                + "WHERE UserID = ? AND SlotDate = ? AND Role = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setDate(2, java.sql.Date.valueOf(slotDate));
            stmt.setString(3, role);
            try (ResultSet rs = stmt.executeQuery()) {
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
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByDetails: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    public List<ScheduleEmployee> getSchedulesByRoomAndRole(int roomId, LocalDate slotDate, String role) throws SQLException {
        List<ScheduleEmployee> schedulesInRoom = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status "
                + "FROM ScheduleEmployee "
                + "WHERE RoomID = ? AND SlotDate = ? AND Role = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.setDate(2, java.sql.Date.valueOf(slotDate));
            stmt.setString(3, role);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("SlotID"));
                    schedule.setUserId(rs.getInt("UserID"));
                    schedule.setRole(rs.getString("Role"));
                    schedule.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                    schedule.setStartTime(rs.getTime("StartTime").toLocalTime());
                    schedule.setEndTime(rs.getTime("EndTime").toLocalTime());
                    schedule.setRoomId(rs.getInt("RoomID"));
                    schedule.setStatus(rs.getString("Status"));
                    schedulesInRoom.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByRoomAndRole: " + e.getMessage());
            throw e;
        }
        return schedulesInRoom;
    }

    public ScheduleEmployee getScheduleById(int slotId) throws SQLException {
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt "
                + "FROM ScheduleEmployee WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("SlotID"));
                    schedule.setUserId(rs.getInt("UserID"));
                    schedule.setRole(rs.getString("Role"));
                    schedule.setRoomId(rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null);
                    schedule.setSlotDate(rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null);
                    schedule.setStartTime(rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null);
                    schedule.setEndTime(rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null);
                    schedule.setStatus(rs.getString("Status"));
                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
                    schedule.setCreatedAt(rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toLocalDateTime() : null);
                    schedule.setUpdatedAt(rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime() : null);
                    return schedule;
                }
            }
        }
        return null;
    }

    public List<ScheduleEmployee> getAllSchedules() throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt FROM ScheduleEmployee";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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

    public List<ScheduleEmployee> getSchedulesWithoutRoom() throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt "
                + "FROM ScheduleEmployee "
                + "WHERE RoomID IS NULL";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("SlotID"));
                    schedule.setUserId(rs.getInt("UserID"));
                    schedule.setRole(rs.getString("Role"));
                    schedule.setRoomId(null);
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
            System.err.println("SQLException in getSchedulesWithoutRoom: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    public List<ScheduleEmployee> getSchedulesWithoutRoomByUserId(int userId) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        // SQL query to select schedules where roomID is NULL and userID matches the given ID
        String sql = "SELECT slotId, userID, role, slotDate, startTime, endTime, roomID, status "
                + "FROM ScheduleEmployee "
                + "WHERE roomID IS NULL AND userID = ?";

        try (Connection conn = dbContext.getConnection(); // Use your actual database connection method
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId); // Set the userId parameter

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("slotId"));
                    schedule.setUserId(rs.getInt("userID"));
                    schedule.setRole(rs.getString("role"));

                    java.sql.Date sqlDate = rs.getDate("slotDate");
                    if (sqlDate != null) {
                        schedule.setSlotDate(sqlDate.toLocalDate());
                    } else {
                        // Handle cases where slotDate might be null in the DB, though it should ideally not be for schedules
                        System.err.println("Warning: Schedule ID " + schedule.getSlotId() + " has a null slotDate in DB.");
                    }

                    java.sql.Time sqlStartTime = rs.getTime("startTime");
                    if (sqlStartTime != null) {
                        schedule.setStartTime(sqlStartTime.toLocalTime());
                    }

                    java.sql.Time sqlEndTime = rs.getTime("endTime");
                    if (sqlEndTime != null) {
                        schedule.setEndTime(sqlEndTime.toLocalTime());
                    }

                    // roomID can be null, so use getObject for Integer type
                    schedule.setRoomId((Integer) rs.getObject("roomID")); // Cast to Integer to handle null correctly
                    schedule.setStatus(rs.getString("status"));

                    schedules.add(schedule);
                }
            }
        }
        return schedules;
    }

    // Lấy danh sách lịch theo userId, khoảng thời gian, và đặc điểm slot
    public List<ScheduleEmployee> getSchedulesByUserIdAndDateRange(int userId, LocalDate startDate, LocalDate endDate, LocalTime startTime, LocalTime endTime, String role) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt "
                + "FROM ScheduleEmployee "
                + "WHERE UserID = ? AND SlotDate BETWEEN ? AND ? AND StartTime = ? AND EndTime = ? AND Role = ? AND RoomID IS NULL";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setDate(2, Date.valueOf(startDate));
            stmt.setDate(3, Date.valueOf(endDate));
            stmt.setTime(4, startTime != null ? Time.valueOf(startTime) : null);
            stmt.setTime(5, endTime != null ? Time.valueOf(endTime) : null);
            stmt.setString(6, role);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("SlotID"));
                    schedule.setUserId(rs.getInt("UserID"));
                    schedule.setRole(rs.getString("Role"));
                    schedule.setRoomId(rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null);
                    schedule.setSlotDate(rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null);
                    schedule.setStartTime(rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null);
                    schedule.setEndTime(rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null);
                    schedule.setStatus(rs.getString("Status"));
                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
                    schedule.setCreatedAt(rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toLocalDateTime() : null);
                    schedule.setUpdatedAt(rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime() : null);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException trong getSchedulesByUserIdAndDateRange: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    // Kiểm tra ràng buộc gán phòng: tối đa 1 bác sĩ và 1 y tá mỗi phòng trong cùng slot thời gian
    public boolean checkRoomAssignmentConstraints(int roomId, LocalDate slotDate, LocalTime startTime, LocalTime endTime, String role) throws SQLException {
        String sql = "SELECT Role FROM ScheduleEmployee "
                + "WHERE RoomID = ? AND SlotDate = ? AND StartTime = ? AND EndTime = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, roomId);
            pstmt.setDate(2, Date.valueOf(slotDate));
            pstmt.setTime(3, Time.valueOf(startTime));
            pstmt.setTime(4, Time.valueOf(endTime));
            try (ResultSet rs = pstmt.executeQuery()) {
                boolean hasDoctor = false;
                boolean hasNurse = false;
                while (rs.next()) {
                    String existingRole = rs.getString("Role");
                    if ("Doctor".equalsIgnoreCase(existingRole)) {
                        hasDoctor = true;
                    } else if ("Nurse".equalsIgnoreCase(existingRole)) {
                        hasNurse = true;
                    }
                }
                if ("Doctor".equalsIgnoreCase(role) && hasDoctor) {
                    return false;
                }
                if ("Nurse".equalsIgnoreCase(role) && hasNurse) {
                    return false;
                }
                return true;
            }
        }
    }

    public List<ScheduleEmployee> getScheduleByDate(int userId, LocalDate date) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT se.slotId, se.userId, se.role, se.roomId, se.slotDate, se.startTime, se.endTime, se.status, "
                + "se.createdBy, se.createdAt, se.updatedAt, "
                + "r.roomID AS room_roomID, r.roomName, r.status AS roomStatus, "
                + "s.serviceID AS service_serviceID, s.serviceName "
                + "FROM ScheduleEmployee se "
                + "LEFT JOIN Rooms r ON se.roomId = r.roomID "
                + "LEFT JOIN RoomServices rs ON r.roomID = rs.roomID "
                + "LEFT JOIN Services s ON rs.serviceID = s.serviceID "
                + "WHERE se.userId = ? AND se.slotDate = ?"; // Removed DATE function

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(date));
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("slotId"));
                    schedule.setUserId(rs.getInt("userId"));
                    schedule.setRole(rs.getString("role"));
                    schedule.setRoomId(rs.getObject("roomId") != null ? rs.getInt("roomId") : null);
                    schedule.setSlotDate(rs.getDate("slotDate").toLocalDate());
                    schedule.setStartTime(rs.getTime("startTime") != null ? rs.getTime("startTime").toLocalTime() : null);
                    schedule.setEndTime(rs.getTime("endTime") != null ? rs.getTime("endTime").toLocalTime() : null);
                    schedule.setStatus(rs.getString("status"));
                    schedule.setCreatedBy(rs.getInt("createdBy"));
                    schedule.setCreatedAt(rs.getTimestamp("createdAt") != null ? rs.getTimestamp("createdAt").toLocalDateTime() : null);
                    schedule.setUpdatedAt(rs.getTimestamp("updatedAt") != null ? rs.getTimestamp("updatedAt").toLocalDateTime() : null);

                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getScheduleByDate: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    public ScheduleEmployee getScheduleDetailsBySlotId(int slotId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "u.FullName, r.RoomName, STRING_AGG(s.ServiceName, ',') AS ServiceNames "
                + "FROM ScheduleEmployee se "
                + "LEFT JOIN Users u ON se.UserID = u.UserID "
                + "LEFT JOIN Rooms r ON se.RoomID = r.RoomID "
                + "LEFT JOIN RoomServices rs ON r.RoomID = rs.RoomID "
                + "LEFT JOIN Services s ON rs.ServiceID = s.ServiceID "
                + "WHERE se.SlotID = ? "
                + "GROUP BY se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "u.FullName, r.RoomName";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    List<String> serviceNames = new ArrayList<>();
                    String serviceNamesStr = rs.getString("ServiceNames");
                    if (serviceNamesStr != null && !serviceNamesStr.isEmpty()) {
                        serviceNames.addAll(Arrays.asList(serviceNamesStr.split(",")));
                    }

                    ScheduleEmployee schedule = new ScheduleEmployee(
                            rs.getInt("SlotID"),
                            rs.getInt("UserID"),
                            rs.getString("Role"),
                            rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null,
                            rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null,
                            rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null,
                            rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null,
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toLocalDateTime() : null,
                            rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime() : null,
                            rs.getString("FullName"),
                            rs.getString("RoomName"),
                            serviceNames
                    );
                    return schedule;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getScheduleDetailsBySlotId: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    public List<ScheduleEmployee> getAllSchedulesByUserId(int userId) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, "
                + "u.FullName, r.RoomName, up.FullName AS PatientName, STRING_AGG(s.ServiceName, ',') AS ServiceNames "
                + "FROM ScheduleEmployee se "
                + "LEFT JOIN Users u ON se.UserID = u.UserID "
                + "LEFT JOIN Rooms r ON se.RoomID = r.RoomID "
                + "LEFT JOIN Users up ON se.PatientID = up.UserID "
                + "LEFT JOIN RoomServices rs ON r.RoomID = rs.RoomID "
                + "LEFT JOIN Services s ON rs.ServiceID = s.ServiceID "
                + "WHERE se.UserID = ? "
                + "GROUP BY se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, u.FullName, r.RoomName, up.FullName";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    List<String> serviceNames = new ArrayList<>();
                    String serviceNamesStr = rs.getString("ServiceNames");
                    if (serviceNamesStr != null && !serviceNamesStr.isEmpty()) {
                        serviceNames.addAll(Arrays.asList(serviceNamesStr.split(",")));
                    }

                    ScheduleEmployee schedule = new ScheduleEmployee(
                            rs.getInt("SlotID"),
                            rs.getInt("UserID"),
                            rs.getString("Role"),
                            rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null,
                            rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null,
                            rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null,
                            rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null,
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toLocalDateTime() : null,
                            rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime() : null,
                            rs.getString("FullName"),
                            rs.getString("RoomName"),
                            serviceNames
                    );
                    schedule.setPatientId(rs.getObject("PatientID") != null ? rs.getInt("PatientID") : null);
                    schedule.setPatientName(rs.getString("PatientName"));
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllSchedulesByUserId: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    public List<ScheduleEmployee> getAllSchedulesByDoctorNurseId(int userId) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, "
                + "u.FullName, r.RoomName, up.FullName AS PatientName, STRING_AGG(s.ServiceName, ',') AS ServiceNames "
                + "FROM ScheduleEmployee se "
                + "LEFT JOIN Users u ON se.UserID = u.UserID "
                + "LEFT JOIN Rooms r ON se.RoomID = r.RoomID "
                + "LEFT JOIN Users up ON se.PatientID = up.UserID "
                + "LEFT JOIN RoomServices rs ON r.RoomID = rs.RoomID "
                + "LEFT JOIN Services s ON rs.ServiceID = s.ServiceID "
                + "WHERE se.UserID = ? AND u.Role IN ('Doctor', 'Nurse') "
                + "GROUP BY se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, u.FullName, r.RoomName, up.FullName";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    List<String> serviceNames = new ArrayList<>();
                    String serviceNamesStr = rs.getString("ServiceNames");
                    if (serviceNamesStr != null && !serviceNamesStr.isEmpty()) {
                        serviceNames.addAll(Arrays.asList(serviceNamesStr.split(",")));
                    }

                    ScheduleEmployee schedule = new ScheduleEmployee(
                            rs.getInt("SlotID"),
                            rs.getInt("UserID"),
                            rs.getString("Role"),
                            rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null,
                            rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null,
                            rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null,
                            rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null,
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toLocalDateTime() : null,
                            rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime() : null,
                            rs.getString("FullName"),
                            rs.getString("RoomName"),
                            serviceNames
                    );
                    schedule.setPatientId(rs.getObject("PatientID") != null ? rs.getInt("PatientID") : null);
                    schedule.setPatientName(rs.getString("PatientName"));
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllSchedulesByUserId: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

    public List<ScheduleEmployee> getAssignedSchedulesByUserId(int userId, LocalDate startDate, LocalDate endDate) throws SQLException {
        List<ScheduleEmployee> assignedSchedules = new ArrayList<>();
        String sql = "SELECT * FROM ScheduleEmployee WHERE UserID = ? AND SlotDate BETWEEN ? AND ? AND RoomID IS NOT NULL";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setDate(2, java.sql.Date.valueOf(startDate)); // Chuyển LocalDate sang java.sql.Date
            pstmt.setDate(3, java.sql.Date.valueOf(endDate));   // Chuyển LocalDate sang java.sql.Date

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee schedule = new ScheduleEmployee();
                    schedule.setSlotId(rs.getInt("SlotID"));
                    schedule.setUserId(rs.getInt("UserID"));
                    schedule.setRole(rs.getString("Role"));
                    schedule.setRoomId(rs.getInt("RoomID")); // Có thể null, nhưng ở đây đã lọc RoomID IS NOT NULL
                    schedule.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                    schedule.setStartTime(rs.getTime("StartTime").toLocalTime());
                    schedule.setEndTime(rs.getTime("EndTime").toLocalTime());
                    schedule.setStatus(rs.getString("Status"));
                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
                    schedule.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    schedule.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                    schedule.setPatientId(rs.getInt("PatientID")); // Có thể null

                    assignedSchedules.add(schedule);
                }
            }
        }
        return assignedSchedules;
    }

    private Map<Integer, Map<String, String>> getAllEmployees() throws SQLException {
        Map<Integer, Map<String, String>> allEmployees = new LinkedHashMap<>();
        String sqlEmployees = "SELECT UserID, FullName, Role FROM Users WHERE Role IN ('Doctor', 'Nurse', 'Receptionist') AND Status = 'Active'";
        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sqlEmployees); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int userId = rs.getInt("UserID");
                String fullName = rs.getString("FullName");
                String role = rs.getString("Role");
                Map<String, String> employeeInfo = new HashMap<>();
                employeeInfo.put("FullName", fullName);
                employeeInfo.put("Role", role);
                allEmployees.put(userId, employeeInfo);
            }
        }
        return allEmployees;
    }

    public Map<String, Object> getWeeklyScheduleFullEmployeeCentricNoRoom() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        // scheduleData: FullName -> Day -> Shift -> AssignedRoleForSlot (e.g., "Doctor", "N/A")
        Map<String, Map<String, Map<String, String>>> scheduleData = new LinkedHashMap<>();
        List<String> days = new ArrayList<>();
        Map<String, String> dayNameMap = new LinkedHashMap<>();
        String startDate = null, endDate = null;

        // 1. Get current week dates (Monday to Sunday)
        String sqlDays = "SELECT CONVERT(varchar, DATEADD(DAY, v.number, weekStart), 23) as Day, DATENAME(weekday, DATEADD(DAY, v.number, weekStart)) as WeekDay "
                + "FROM (SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) as weekStart) d "
                + "CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6)) v(number)";
        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sqlDays); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String day = rs.getString("Day");
                String weekDay = rs.getString("WeekDay");
                days.add(day);
                dayNameMap.put(day, weekDay);
            }
            if (!days.isEmpty()) {
                startDate = days.get(0);
                endDate = days.get(days.size() - 1);
            }
        }

        // 2. Get all relevant employees (Doctors, Nurses, Receptionists)
        Map<Integer, Map<String, String>> allEmployees = getAllEmployees();

        // 3. Fetch schedule data for employees (NO ROOM JOIN)
        String sql = "SELECT u.UserID, u.FullName, se.Role AS AssignedRole, "
                + // Use se.Role to get the specific role for the slot
                "CASE WHEN FORMAT(se.StartTime, 'HH:mm') < '12:00' THEN 'Ca sáng' ELSE 'Ca chiều' END AS Shift, "
                + "CONVERT(varchar, se.SlotDate, 23) as Day "
                + "FROM Users u "
                + "LEFT JOIN ScheduleEmployee se ON u.UserID = se.UserID AND se.SlotDate BETWEEN ? AND ? "
                + "WHERE u.Role IN ('Doctor', 'Nurse', 'Receptionist') AND u.Status = 'Active'";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String employeeName = rs.getString("FullName");
                    String assignedRoleForSlot = rs.getString("AssignedRole"); // Role from ScheduleEmployee table for the slot
                    String shift = rs.getString("Shift") != null ? rs.getString("Shift") : "Ca sáng"; // Default if no StartTime
                    String day = rs.getString("Day");

                    // Only process actual scheduled days (ignore rows where se.SlotDate was null due to LEFT JOIN)
                    if (day == null) {
                        continue;
                    }

                    // Ensure map structure exists: FullName -> Day -> Shift
                    scheduleData.putIfAbsent(employeeName, new LinkedHashMap<>());
                    scheduleData.get(employeeName).putIfAbsent(day, new LinkedHashMap<>());

                    // Store the specific role for that slot, or a generic "Scheduled" if assignedRoleForSlot is null
                    scheduleData.get(employeeName).get(day).put(shift, assignedRoleForSlot != null ? assignedRoleForSlot : "Scheduled");
                }
            }
        }

        for (Map.Entry<Integer, Map<String, String>> entry : allEmployees.entrySet()) {
            String employeeName = entry.getValue().get("FullName");

            scheduleData.putIfAbsent(employeeName, new LinkedHashMap<>()); // Ensure employee exists in scheduleData

            for (String day : days) {
                scheduleData.get(employeeName).putIfAbsent(day, new LinkedHashMap<>()); // Ensure day exists for employee
                // Add placeholders for morning/afternoon shifts if they are not filled
                scheduleData.get(employeeName).get(day).putIfAbsent("Ca sáng", "N/A"); // "N/A" means Not Assigned / Available
                scheduleData.get(employeeName).get(day).putIfAbsent("Ca chiều", "N/A"); // "N/A" means Not Assigned / Available
            }
        }

        result.put("scheduleData", scheduleData);
        result.put("days", days);
        result.put("dayNameMap", dayNameMap);
        result.put("startDate", startDate);
        result.put("endDate", endDate);
        return result;
    }

    public Map<String, Object> getWeeklyScheduleByRangeEmployeeCentricNoRoom(String startDate, String endDate) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        // scheduleData: FullName -> Day -> Shift -> AssignedRoleForSlot (e.g., "Doctor", "N/A")
        Map<String, Map<String, Map<String, String>>> scheduleData = new LinkedHashMap<>();
        List<String> days = new ArrayList<>();
        Map<String, String> dayNameMap = new LinkedHashMap<>();

        // 1. Get dates within the specified range
        String sqlDays = "SELECT CONVERT(varchar, d, 23) as Day, DATENAME(weekday, d) as WeekDay "
                + "FROM (SELECT TOP (DATEDIFF(DAY, ?, ?) + 1) DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, ?) as d "
                + "FROM sys.all_objects) AS x";
        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sqlDays)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ps.setString(3, startDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String day = rs.getString("Day");
                    String weekDay = rs.getString("WeekDay");
                    days.add(day);
                    dayNameMap.put(day, weekDay);
                }
            }
        }

        Map<Integer, Map<String, String>> allEmployees = getAllEmployees();
        String sql = "SELECT u.UserID, u.FullName, se.Role AS AssignedRole, "
                + // Use se.Role for the specific slot role
                "CASE WHEN FORMAT(se.StartTime, 'HH:mm') < '12:00' THEN 'Ca sáng' ELSE 'Ca chiều' END AS Shift, "
                + "CONVERT(varchar, se.SlotDate, 23) as Day "
                + "FROM Users u "
                + "LEFT JOIN ScheduleEmployee se ON u.UserID = se.UserID AND se.SlotDate BETWEEN ? AND ? "
                + "WHERE u.Role IN ('Doctor', 'Nurse', 'Receptionist') AND u.Status = 'Active'";

        try (Connection con = dbContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String employeeName = rs.getString("FullName");
                    String assignedRoleForSlot = rs.getString("AssignedRole");
                    String shift = rs.getString("Shift") != null ? rs.getString("Shift") : "Ca sáng";
                    String day = rs.getString("Day");

                    if (day == null) {
                        continue;
                    }

                    scheduleData.putIfAbsent(employeeName, new LinkedHashMap<>());
                    scheduleData.get(employeeName).putIfAbsent(day, new LinkedHashMap<>());
                    scheduleData.get(employeeName).get(day).put(shift, assignedRoleForSlot != null ? assignedRoleForSlot : "Scheduled");
                }
            }
        }

        // 4. Ensure all employees have entries for all days/shifts in the range
        for (Map.Entry<Integer, Map<String, String>> entry : allEmployees.entrySet()) {
            String employeeName = entry.getValue().get("FullName");

            scheduleData.putIfAbsent(employeeName, new LinkedHashMap<>());

            for (String day : days) {
                scheduleData.get(employeeName).putIfAbsent(day, new LinkedHashMap<>());
                scheduleData.get(employeeName).get(day).putIfAbsent("Ca sáng", "N/A");
                scheduleData.get(employeeName).get(day).putIfAbsent("Ca chiều", "N/A");
            }
        }

        result.put("scheduleData", scheduleData);
        result.put("days", days);
        result.put("dayNameMap", dayNameMap);
        result.put("startDate", days.isEmpty() ? startDate : days.get(0));
        result.put("endDate", days.isEmpty() ? endDate : days.get(days.size() - 1));
        return result;
    }

    public List<ScheduleEmployee> searchSchedules(String keyword) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, "
                + "u.FullName, r.RoomName, STRING_AGG(s.ServiceName, ',') AS ServiceNames "
                + "FROM ScheduleEmployee se "
                + "LEFT JOIN Users u ON se.UserID = u.UserID "
                + "LEFT JOIN Rooms r ON se.RoomID = r.RoomID "
                + "LEFT JOIN RoomServices rs ON r.RoomID = rs.RoomID "
                + "LEFT JOIN Services s ON rs.ServiceID = s.ServiceID "
                + "WHERE (u.FullName LIKE ? OR se.Role LIKE ? OR CONVERT(VARCHAR, se.SlotDate) LIKE ? OR se.Status LIKE ?) "
                + "GROUP BY se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, u.FullName, r.RoomName";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    List<String> serviceNames = new ArrayList<>();
                    String serviceNamesStr = rs.getString("ServiceNames");
                    if (serviceNamesStr != null && !serviceNamesStr.isEmpty()) {
                        serviceNames.addAll(java.util.Arrays.asList(serviceNamesStr.split(",")));
                    }

                    ScheduleEmployee schedule = new ScheduleEmployee(
                            rs.getInt("SlotID"),
                            rs.getInt("UserID"),
                            rs.getString("Role"),
                            rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null,
                            rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null,
                            rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null,
                            rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null,
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toLocalDateTime() : null,
                            rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime() : null,
                            rs.getString("FullName"),
                            rs.getString("RoomName"),
                            serviceNames
                    );
                    schedule.setPatientId(rs.getObject("PatientID") != null ? rs.getInt("PatientID") : null);
                    schedules.add(schedule);
                }
            }
        }
        return schedules;
    }

    public List<ScheduleEmployee> getSchedulesByUserIdAndRole(int userId, String role) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, "
                + "u.FullName, r.RoomName, STRING_AGG(s.ServiceName, ',') AS ServiceNames "
                + "FROM ScheduleEmployee se "
                + "LEFT JOIN Users u ON se.UserID = u.UserID "
                + "LEFT JOIN Rooms r ON se.RoomID = r.RoomID "
                + "LEFT JOIN RoomServices rs ON r.RoomID = rs.RoomID "
                + "LEFT JOIN Services s ON rs.ServiceID = s.ServiceID "
                + "WHERE se.UserID = ? AND se.Role = ? "
                + "GROUP BY se.SlotID, se.UserID, se.Role, se.RoomID, se.SlotDate, se.StartTime, se.EndTime, se.Status, "
                + "se.CreatedBy, se.CreatedAt, se.UpdatedAt, se.PatientID, u.FullName, r.RoomName";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, role);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    List<String> serviceNames = new ArrayList<>();
                    String serviceNamesStr = rs.getString("ServiceNames");
                    if (serviceNamesStr != null && !serviceNamesStr.isEmpty()) {
                        serviceNames.addAll(Arrays.asList(serviceNamesStr.split(",")));
                    }

                    ScheduleEmployee schedule = new ScheduleEmployee(
                            rs.getInt("SlotID"),
                            rs.getInt("UserID"),
                            rs.getString("Role"),
                            rs.getObject("RoomID") != null ? rs.getInt("RoomID") : null,
                            rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toLocalDate() : null,
                            rs.getTime("StartTime") != null ? rs.getTime("StartTime").toLocalTime() : null,
                            rs.getTime("EndTime") != null ? rs.getTime("EndTime").toLocalTime() : null,
                            rs.getString("Status"),
                            rs.getInt("CreatedBy"),
                            rs.getTimestamp("CreatedAt") != null ? rs.getTimestamp("CreatedAt").toLocalDateTime() : null,
                            rs.getTimestamp("UpdatedAt") != null ? rs.getTimestamp("UpdatedAt").toLocalDateTime() : null,
                            rs.getString("FullName"),
                            rs.getString("RoomName"),
                            serviceNames
                    );
                    schedule.setPatientId(rs.getObject("PatientID") != null ? rs.getInt("PatientID") : null);
                    schedules.add(schedule);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByUserIdAndRole: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedules;
    }

public boolean updateScheduleForDoctorNurse(int slotId, int userId, LocalDate newSlotDate, 
            LocalTime newStartTime, LocalTime newEndTime, int updatedBy) 
            throws SQLException {
        // Kiểm tra đầu vào cơ bản
        if (slotId <= 0 || userId <= 0 || newSlotDate == null || newStartTime == null || newEndTime == null || updatedBy <= 0) {
            throw new IllegalArgumentException("Các tham số đầu vào không hợp lệ: slotId, userId, newSlotDate, newStartTime, newEndTime, updatedBy phải là giá trị dương và không null.");
        }
        if (newStartTime.isAfter(newEndTime)) {
            throw new IllegalArgumentException("Thời gian bắt đầu phải nhỏ hơn thời gian kết thúc.");
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            // Lấy thông tin lịch hiện tại
            String selectSql = "SELECT SlotID, UserID, Role, SlotDate, StartTime, EndTime, Status FROM ScheduleEmployee WHERE SlotID = ? AND UserID = ?";
            pstmt = conn.prepareStatement(selectSql);
            pstmt.setInt(1, slotId);
            pstmt.setInt(2, userId);
            rs = pstmt.executeQuery();

            ScheduleEmployee existingSchedule = null;
            if (rs.next()) {
                existingSchedule = new ScheduleEmployee();
                existingSchedule.setSlotId(rs.getInt("SlotID"));
                existingSchedule.setUserId(rs.getInt("UserID"));
                existingSchedule.setRole(rs.getString("Role"));
                existingSchedule.setSlotDate(rs.getDate("SlotDate").toLocalDate());
                existingSchedule.setStartTime(rs.getTime("StartTime").toLocalTime());
                existingSchedule.setEndTime(rs.getTime("EndTime").toLocalTime());
                existingSchedule.setStatus(rs.getString("Status"));
            }
            rs.close();
            pstmt.close();

            if (existingSchedule == null) {
                throw new IllegalArgumentException("Lịch trình không tồn tại hoặc không thuộc về người dùng ID: " + userId);
            }
            if (!"Doctor".equalsIgnoreCase(existingSchedule.getRole()) && !"Nurse".equalsIgnoreCase(existingSchedule.getRole())) {
                throw new IllegalArgumentException("Chỉ hỗ trợ cập nhật lịch cho bác sĩ hoặc y tá.");
            }

            // Kiểm tra xung đột lịch với các slot khác của cùng userId
            String conflictSql = "SELECT SlotID, SlotDate, StartTime, EndTime FROM ScheduleEmployee " +
                                "WHERE UserID = ? AND SlotID != ? AND Status = 'Active'";
            pstmt = conn.prepareStatement(conflictSql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, slotId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                LocalDate existingDate = rs.getDate("SlotDate").toLocalDate();
                LocalTime existingStartTime = rs.getTime("StartTime").toLocalTime();
                LocalTime existingEndTime = rs.getTime("EndTime").toLocalTime();

                if (newSlotDate.equals(existingDate) && 
                    ((newStartTime.isBefore(existingEndTime) && newEndTime.isAfter(existingStartTime)) || 
                     (existingStartTime.isBefore(newEndTime) && existingEndTime.isAfter(newStartTime)))) {
                    throw new IllegalArgumentException("Xung đột lịch: Người dùng ID " + userId + 
                            " đã có lịch vào ngày " + newSlotDate + " từ " + existingStartTime + " đến " + existingEndTime);
                }
            }
            rs.close();
            pstmt.close();

            // Cập nhật lịch trong cơ sở dữ liệu
            String updateSql = "UPDATE ScheduleEmployee SET SlotDate = ?, StartTime = ?, EndTime = ?, UpdatedAt = GETDATE(), UpdatedBy = ? " +
                              "WHERE SlotID = ? AND UserID = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setDate(1, java.sql.Date.valueOf(newSlotDate));
            pstmt.setTime(2, java.sql.Time.valueOf(newStartTime));
            pstmt.setTime(3, java.sql.Time.valueOf(newEndTime));
            pstmt.setInt(4, updatedBy);
            pstmt.setInt(5, slotId);
            pstmt.setInt(6, userId);

            int rowsAffected = pstmt.executeUpdate();
            conn.commit();

            if (rowsAffected > 0) {
                System.out.println("Cập nhật lịch thành công cho SlotID: " + slotId + " tại " + LocalDateTime.now() + " +07");
                return true;
            } else {
                System.out.println("Không thể cập nhật lịch cho SlotID: " + slotId + " tại " + LocalDateTime.now() + " +07");
                return false;
            }
        } catch (SQLException e) {
            System.err.println("SQLException trong updateScheduleForDoctorNurse: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Lỗi khi rollback: " + ex.getMessage());
                }
            }
            throw e;
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { /* ignored */ }
            if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignored */ }
        }
    }
 public boolean reassignScheduleToUser(int slotId, int newUserId) throws SQLException {
        // Validate input
        if (slotId <= 0 || newUserId <= 0) {
            throw new IllegalArgumentException("slotId và newUserId phải là số dương");
        }

        String checkSql = "SELECT SlotID, UserID, Role, SlotDate, StartTime, EndTime, Status FROM ScheduleEmployee WHERE SlotID = ?";
        String roleCheckSql = "SELECT Role FROM Users WHERE UserID = ? AND Role = ? AND Status = 'Active'";
        String conflictSql = "SELECT COUNT(*) FROM ScheduleEmployee " +
                            "WHERE UserID = ? AND SlotDate = ? AND Status != 'Cancelled' " +
                            "AND ((StartTime <= ? AND EndTime > ?) OR (StartTime < ? AND EndTime >= ?))";
        String updateSql = "UPDATE ScheduleEmployee SET UserID = ?, UpdatedAt = GETDATE() WHERE SlotID = ?";
        String notificationSql = "INSERT INTO Notifications (SenderID, SenderRole, ReceiverID, ReceiverRole, Title, Message, IsRead, CreatedAt) " +
                               "VALUES (?, 'Receptionist', ?, ?, ?, ?, 0, GETDATE())";

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            // Kiểm tra schedule có tồn tại không
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, slotId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Schedule với SlotID " + slotId + " không tồn tại");
                    }

                    int oldUserId = rs.getInt("UserID");
                    String role = rs.getString("Role");
                    LocalDate slotDate = rs.getDate("SlotDate").toLocalDate();
                    LocalTime startTime = rs.getTime("StartTime").toLocalTime();
                    LocalTime endTime = rs.getTime("EndTime").toLocalTime();
                    String status = rs.getString("Status");

                    // Kiểm tra user mới có cùng role không (Doctor thay Doctor, Nurse thay Nurse)
                    try (PreparedStatement roleStmt = conn.prepareStatement(roleCheckSql)) {
                        roleStmt.setInt(1, newUserId);
                        roleStmt.setString(2, role);
                        try (ResultSet rsRole = roleStmt.executeQuery()) {
                            if (!rsRole.next()) {
                                throw new IllegalArgumentException("User ID " + newUserId + " không có role " + role + " hoặc không active");
                            }
                        }
                    }

                    // Kiểm tra user mới có available không (không có lịch trùng)
                    try (PreparedStatement conflictStmt = conn.prepareStatement(conflictSql)) {
                        conflictStmt.setInt(1, newUserId);
                        conflictStmt.setDate(2, Date.valueOf(slotDate));
                        conflictStmt.setTime(3, Time.valueOf(startTime));
                        conflictStmt.setTime(4, Time.valueOf(startTime));
                        conflictStmt.setTime(5, Time.valueOf(endTime));
                        conflictStmt.setTime(6, Time.valueOf(endTime));
                        try (ResultSet rsConflict = conflictStmt.executeQuery()) {
                            if (rsConflict.next() && rsConflict.getInt(1) > 0) {
                                throw new IllegalArgumentException("User ID " + newUserId + " đã có lịch trùng thời gian trong slot " + 
                                                                 slotDate + " từ " + startTime + " đến " + endTime);
                            }
                        }
                    }

                    // Thực hiện reassign - CHỈ CẦN CẬP NHẬT UpdatedAt, KHÔNG CẦN UpdatedBy
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, newUserId);
                        updateStmt.setInt(2, slotId);
                        int rowsAffected = updateStmt.executeUpdate();

                        if (rowsAffected > 0) {
                            // Tạo notification cho user cũ và user mới
                            try (PreparedStatement notifyStmt = conn.prepareStatement(notificationSql)) {
                                // Notification cho user mới - sử dụng system user ID = 1
                                notifyStmt.setInt(1, 1); // System user
                                notifyStmt.setInt(2, newUserId);
                                notifyStmt.setString(3, role);
                                notifyStmt.setString(4, "Lịch làm việc mới được phân công");
                                notifyStmt.setString(5, "Bạn được thay thế làm " + role + " vào ngày " + slotDate + 
                                                   " từ " + startTime + " đến " + endTime);
                                notifyStmt.setBoolean(6, false);
                                notifyStmt.executeUpdate();

                                // Notification cho user cũ
                                notifyStmt.setInt(2, oldUserId);
                                notifyStmt.setString(4, "Lịch làm việc bị thay đổi");
                                notifyStmt.setString(5, "Lịch " + role + " của bạn vào ngày " + slotDate + 
                                                   " từ " + startTime + " đến " + endTime + " đã được chuyển cho người khác");
                                notifyStmt.executeUpdate();
                            }

                            conn.commit();
                            System.out.println("Reassign schedule thành công: SlotID " + slotId + 
                                              " từ UserID " + oldUserId + " sang UserID " + newUserId + 
                                              " tại " + LocalDateTime.now() + " +07");
                            return true;
                        } else {
                            conn.rollback();
                            return false;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException trong reassignScheduleToUser: " + e.getMessage() + 
                              " tại " + LocalDateTime.now() + " +07");
            throw e;
        }
    }
  public Map<String, String> getScheduleBySlotId(int slotId) throws SQLException {
        Map<String, String> schedule = new LinkedHashMap<>();
        String sql = "SELECT se.SlotID, se.UserID, u.FullName, se.Role, se.SlotDate, se.StartTime, se.EndTime, " +
                     "r.RoomName, STRING_AGG(s.ServiceName, ',') AS ServiceNames " +
                     "FROM ScheduleEmployee se " +
                     "LEFT JOIN Users u ON se.UserID = u.UserID " +
                     "LEFT JOIN Rooms r ON se.RoomID = r.RoomID " +
                     "LEFT JOIN RoomServices rs ON r.RoomID = rs.RoomID " +
                     "LEFT JOIN Services s ON rs.ServiceID = s.ServiceID " +
                     "WHERE se.SlotID = ? " +
                     "GROUP BY se.SlotID, se.UserID, u.FullName, se.Role, se.SlotDate, se.StartTime, se.EndTime, r.RoomName";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    schedule.put("SlotID", String.valueOf(rs.getInt("SlotID")));
                    schedule.put("UserID", String.valueOf(rs.getInt("UserID")));
                    schedule.put("FullName", rs.getString("FullName") != null ? rs.getString("FullName") : "");
                    schedule.put("Role", rs.getString("Role") != null ? rs.getString("Role") : "");
                    schedule.put("SlotDate", rs.getDate("SlotDate") != null ? rs.getDate("SlotDate").toString() : "");
                    schedule.put("StartTime", rs.getTime("StartTime") != null ? rs.getTime("StartTime").toString() : "");
                    schedule.put("EndTime", rs.getTime("EndTime") != null ? rs.getTime("EndTime").toString() : "");
                    schedule.put("RoomName", rs.getString("RoomName") != null ? rs.getString("RoomName") : "Chưa phân phòng");
                    schedule.put("ServiceNames", rs.getString("ServiceNames") != null ? rs.getString("ServiceNames") : "");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException trong getScheduleBySlotId: " + e.getMessage() + 
                              " tại " + LocalDateTime.now() + " +07");
            throw e;
        }
        return schedule;
    }
}