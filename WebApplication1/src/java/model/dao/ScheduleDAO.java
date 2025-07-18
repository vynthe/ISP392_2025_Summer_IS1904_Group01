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
import java.util.List;
import java.util.Objects;
import model.entity.ScheduleEmployee;
import model.entity.AppointmentQueue;
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
    public void addSchedule(List<Integer> userIds, List<String> roles, int defaultRoomId, int createdBy, LocalDate startDate, boolean isYearly)
            throws SQLException, ClassNotFoundException {
        if (userIds.size() != roles.size()) {
            throw new IllegalArgumentException("The number of userIds must match the number of roles.");
        }

        LocalDate endDate = isYearly ? startDate.plusYears(1) : startDate.plusWeeks(1);
        LocalTime morningStart = LocalTime.of(7, 30);
        LocalTime morningEnd = LocalTime.of(12, 30);
        LocalTime afternoonStart = LocalTime.of(13, 30);
        LocalTime afternoonEnd = LocalTime.of(17, 30);

        String insertScheduleSql = "INSERT INTO ScheduleEmployee (UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        String checkConflictSql = "SELECT COUNT(*) FROM ScheduleEmployee WHERE UserID = ? AND SlotDate = ? AND "
                + "((StartTime <= ? AND EndTime > ?) OR (StartTime < ? AND EndTime >= ?)) AND Status != 'Cancelled'";
        // DoctorAbsences table and IsAbsent column are not in schema, so related checks are removed.
        String insertNotificationSql = "INSERT INTO Notifications (SenderID, SenderRole, ReceiverID, ReceiverRole, Title, Message, IsRead, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement insertStmt = conn.prepareStatement(insertScheduleSql);
             PreparedStatement conflictStmt = conn.prepareStatement(checkConflictSql);
             PreparedStatement notifyStmt = conn.prepareStatement(insertNotificationSql)) {

            conn.setAutoCommit(false);

            for (LocalDate date = startDate; date.isBefore(endDate); date = date.plusDays(1)) {
                if (date.getDayOfWeek().getValue() <= 6) { // Không tạo lịch cho Chủ Nhật
                    for (int i = 0; i < userIds.size(); i++) {
                        int userId = userIds.get(i);
                        String role = roles.get(i);
                        // RoomID can be NULL. For Receptionist, it can be defaultRoomId if > 0, otherwise NULL.
                        // For others, it should be NULL in DB if not explicitly assigned.
                        // int roomIdToUse = ("Receptionist".equalsIgnoreCase(role) && defaultRoomId > 0) ? defaultRoomId : 0;
                        // Use Integer for RoomID if it can be null in the DB, and set it to null if 0 or not applicable.
                        Integer roomIdToUse = null;
                        if ("Receptionist".equalsIgnoreCase(role) && defaultRoomId > 0) {
                            roomIdToUse = defaultRoomId;
                        }

                        // Không kiểm tra ngày nghỉ vì IsAbsent và DoctorAbsences không có trong schema
                        // if (!isAbsent) {

                        // Kiểm tra xung đột slot buổi sáng
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
                                    insertStmt.setNull(3, java.sql.Types.INTEGER); // Set as NULL if not assigned
                                }
                                insertStmt.setDate(4, Date.valueOf(date));
                                insertStmt.setTime(5, Time.valueOf(morningStart));
                                insertStmt.setTime(6, Time.valueOf(morningEnd));
                                insertStmt.setString(7, "Available");
                                insertStmt.setInt(8, createdBy);
                                insertStmt.addBatch();

                                notifyStmt.setInt(1, createdBy);
                                notifyStmt.setString(2, "Admin");
                                notifyStmt.setInt(3, userId);
                                notifyStmt.setString(4, role);
                                notifyStmt.setString(5, "Lịch làm việc mới");
                                notifyStmt.setString(6, "Bạn được phân lịch ngày " + date + " từ " + morningStart + " đến " + morningEnd);
                                notifyStmt.setBoolean(7, false);
                                notifyStmt.addBatch();
                            }
                        }

                        // Kiểm tra xung đột slot buổi chiều
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
                                    insertStmt.setNull(3, java.sql.Types.INTEGER); // Set as NULL if not assigned
                                }
                                insertStmt.setDate(4, Date.valueOf(date));
                                insertStmt.setTime(5, Time.valueOf(afternoonStart));
                                insertStmt.setTime(6, Time.valueOf(afternoonEnd));
                                insertStmt.setString(7, "Available");
                                insertStmt.setInt(8, createdBy);
                                insertStmt.addBatch();

                                notifyStmt.setInt(1, createdBy);
                                notifyStmt.setString(2, "Admin");
                                notifyStmt.setInt(3, userId);
                                notifyStmt.setString(4, role);
                                notifyStmt.setString(5, "Lịch làm việc mới");
                                notifyStmt.setString(6, "Bạn được phân lịch ngày " + date + " từ " + afternoonStart + " đến " + afternoonEnd);
                                notifyStmt.setBoolean(7, false);
                                notifyStmt.addBatch();
                            }
                        }
                        // } // End of !isAbsent block, now removed
                    }
                }
            }

            // Thực thi batch
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
            } else if (Objects.equals(slot.getRole(), "Receptionist") ) { // Assuming default RoomID 1 for Receptionist if no specific room is provided
                 pstmt.setInt(3, 1);
            }
            else {
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

    // Cập nhật slot
    public boolean updateScheduleEmployee(ScheduleEmployee slot) throws SQLException, ClassNotFoundException {
        if (slot == null || slot.getSlotId() <= 0 || slot.getUserId() <= 0 || slot.getRole() == null) {
            throw new IllegalArgumentException("Invalid schedule employee data.");
        }

        // Removed IsAbsent and AbsenceReason from UPDATE statement
        String sql = "UPDATE ScheduleEmployee SET UserID = ?, Role = ?, RoomID = ?, SlotDate = ?, StartTime = ?, EndTime = ?, Status = ?, CreatedBy = ?, UpdatedAt = GETDATE() WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slot.getUserId());
            pstmt.setString(2, slot.getRole());
            // Handle RoomID: if it's 0, set as NULL in DB. For Receptionist, default to 1 if defaultRoomId is used.
            if (slot.getRoomId() > 0) {
                pstmt.setInt(3, slot.getRoomId());
            } else if (Objects.equals(slot.getRole(), "Receptionist")) { // Assuming default RoomID 1 for Receptionist if no specific room is provided
                 pstmt.setInt(3, 1);
            }
            else {
                pstmt.setNull(3, java.sql.Types.INTEGER);
            }
            pstmt.setDate(4, Date.valueOf(slot.getSlotDate()));
            pstmt.setTime(5, Time.valueOf(slot.getStartTime()));
            pstmt.setTime(6, Time.valueOf(slot.getEndTime()));
            // Removed pstmt.setBoolean(7, slot.isAbsent());
            // Removed pstmt.setString(8, slot.getAbsenceReason());
            pstmt.setString(7, slot.getStatus()); // Shifted index
            pstmt.setInt(8, slot.getCreatedBy()); // Shifted index
            pstmt.setInt(9, slot.getSlotId()); // Shifted index
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating schedule employee slot: " + e.getMessage());
            throw e;
        }
    }

    public List<ScheduleEmployee> getAllScheduleEmployees() throws SQLException, ClassNotFoundException {
        List<ScheduleEmployee> slots = new ArrayList<>();
        // Removed IsAbsent and AbsenceReason from SELECT statement
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt FROM ScheduleEmployee";
        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
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
                slot.setStartTime(rs.getTime("StartTime").toLocalTime());
                slot.setEndTime(rs.getTime("EndTime").toLocalTime());
                // Removed slot.setAbsent(rs.getBoolean("IsAbsent"));
                // Removed slot.setAbsenceReason(rs.getString("AbsenceReason"));
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

    public boolean addAppointmentQueue(AppointmentQueue queue) throws SQLException, ClassNotFoundException {
        int queueNumber = getNextQueueNumber(queue.getSlotId());
        queue.setQueueNumber(queueNumber);

        String sql = "INSERT INTO AppointmentQueue (SlotID, AppointmentID, QueueNumber, CreatedAt) VALUES (?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, queue.getSlotId());
            pstmt.setInt(2, queue.getAppointmentId());
            pstmt.setInt(3, queue.getQueueNumber());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding appointment queue: " + e.getMessage());
            throw e;
        }
    }

    private int getNextQueueNumber(int slotId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COALESCE(MAX(QueueNumber), 0) + 1 AS NextQueue FROM AppointmentQueue WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slotId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("NextQueue");
                }
            }
        }
        return 1;
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
        String sql = "UPDATE ScheduleEmployee SET RoomID = ?, UpdatedAt = GETDATE() WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (roomId != null && roomId > 0) {
                stmt.setInt(1, roomId);
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setInt(2, slotId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in assignRoomToSchedule: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public List<ScheduleEmployee> getSchedulesWithoutRoom(int userId, LocalDate slotDate) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt " +
                     "FROM ScheduleEmployee " +
                     "WHERE UserID = ? AND SlotDate = ? AND RoomID IS NULL AND Status = 'Active'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt " +
                     "FROM ScheduleEmployee " +
                     "WHERE UserID = ? AND SlotDate = ? AND Role = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status " +
                     "FROM ScheduleEmployee " +
                     "WHERE RoomID = ? AND SlotDate = ? AND Role = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt " +
                     "FROM ScheduleEmployee WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
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
                    return schedule;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getScheduleById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    public List<ScheduleEmployee> getAllSchedules() throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt FROM ScheduleEmployee";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
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
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt " +
                     "FROM ScheduleEmployee " +
                     "WHERE RoomID IS NULL";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT slotId, userID, role, slotDate, startTime, endTime, roomID, status " +
                     "FROM ScheduleEmployee " +
                     "WHERE roomID IS NULL AND userID = ?";

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
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt " +
                     "FROM ScheduleEmployee " +
                     "WHERE UserID = ? AND SlotDate BETWEEN ? AND ? AND StartTime = ? AND EndTime = ? AND Role = ? AND RoomID IS NULL";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        String sql = "SELECT Role FROM ScheduleEmployee " +
                     "WHERE RoomID = ? AND SlotDate = ? AND StartTime = ? AND EndTime = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.setDate(2, Date.valueOf(slotDate));
            stmt.setTime(3, Time.valueOf(startTime));
            stmt.setTime(4, Time.valueOf(endTime));
            try (ResultSet rs = stmt.executeQuery()) {
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
                // Nếu gán cho bác sĩ mà đã có bác sĩ, hoặc gán cho y tá mà đã có y tá, trả về false
                if ("Doctor".equalsIgnoreCase(role) && hasDoctor) {
                    return false;
                }
                if ("Nurse".equalsIgnoreCase(role) && hasNurse) {
                    return false;
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("SQLException trong checkRoomAssignmentConstraints: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
            throw e;
        }
    }
   
  public List<ScheduleEmployee> getScheduleByDate(int userId, LocalDate date) throws SQLException {
        List<ScheduleEmployee> schedules = new ArrayList<>();
        String sql = "SELECT se.slotId, se.userId, se.role, se.roomId, se.slotDate, se.startTime, se.endTime, se.status, " +
                     "se.createdBy, se.createdAt, se.updatedAt, " +
                     "r.roomID AS room_roomID, r.roomName, r.status AS roomStatus, " +
                     "s.serviceID AS service_serviceID, s.serviceName " +
                     "FROM ScheduleEmployee se " +
                     "LEFT JOIN Rooms r ON se.roomId = r.roomID " +
                     "LEFT JOIN RoomServices rs ON r.roomID = rs.roomID " +
                     "LEFT JOIN Services s ON rs.serviceID = s.serviceID " +
                     "WHERE se.userId = ? AND DATE(se.slotDate) = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
}



