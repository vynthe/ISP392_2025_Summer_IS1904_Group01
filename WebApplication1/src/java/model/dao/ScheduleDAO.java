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
import model.entity.ScheduleEmployee;
import model.entity.AppointmentQueue;
import model.entity.DoctorAbsence;
import model.entity.AppointmentLog;
import model.entity.Rooms;
import model.entity.SMSTemplate;

public class ScheduleDAO {
    private final DBContext dbContext;
    private final RoomsDAO roomsDAO;

    public ScheduleDAO() {
        this.dbContext = DBContext.getInstance();
        this.roomsDAO = new RoomsDAO();
    }

    // Tạo lịch tự động
    public void addSchedule(List<Integer> userIds, List<String> roles, int roomId, int createdBy, LocalDate startDate, boolean isYearly) throws SQLException, ClassNotFoundException {
        if (userIds.size() != roles.size()) {
            throw new IllegalArgumentException("The number of userIds must match the number of roles.");
        }

        // Kiểm tra roomId hợp lệ
        if (roomId > 0) {
            Rooms room = roomsDAO.getRoomByID(roomId); // Kiểm tra bằng getRoomByID
            if (room == null) {
                throw new IllegalArgumentException("RoomID " + roomId + " does not exist.");
            }
        }

        // Lấy RoomID hợp lệ cho phòng lễ tân thay vì cố định là 1
        int receptionistRoomId = roomsDAO.getFirstAvailableRoomId();
        if (receptionistRoomId == -1) {
            throw new IllegalArgumentException("No available Receptionist RoomID exists. Please create a room first.");
        }

        LocalDate endDate = isYearly ? startDate.plusYears(1) : startDate.plusWeeks(1);
        LocalTime morningStart = LocalTime.of(7, 30);
        LocalTime morningEnd = LocalTime.of(12, 30);
        LocalTime afternoonStart = LocalTime.of(13, 30);
        LocalTime afternoonEnd = LocalTime.of(17, 30);

        String insertScheduleSql = "INSERT INTO ScheduleEmployee (UserID, Role, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                                  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        String checkConflictSql = "SELECT COUNT(*) FROM ScheduleEmployee WHERE UserID = ? AND SlotDate = ? AND " +
                                 "((StartTime <= ? AND EndTime > ?) OR (StartTime < ? AND EndTime >= ?)) AND Status != 'Cancelled'";
        String checkAbsenceSql = "SELECT COUNT(*) FROM DoctorAbsences WHERE DoctorID = ? AND AbsenceDate = ? AND Status = 'Approved'";
        String insertNotificationSql = "INSERT INTO Notifications (SenderID, SenderRole, ReceiverID, ReceiverRole, Title, Message, IsRead, CreatedAt) " +
                                      "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement insertStmt = conn.prepareStatement(insertScheduleSql);
             PreparedStatement conflictStmt = conn.prepareStatement(checkConflictSql);
             PreparedStatement absenceStmt = conn.prepareStatement(checkAbsenceSql);
             PreparedStatement notifyStmt = conn.prepareStatement(insertNotificationSql)) {

            conn.setAutoCommit(false);

            for (LocalDate date = startDate; date.isBefore(endDate); date = date.plusDays(1)) {
                if (date.getDayOfWeek().getValue() <= 6) { // Không tạo lịch cho Chủ Nhật
                    for (int i = 0; i < userIds.size(); i++) {
                        int userId = userIds.get(i);
                        String role = roles.get(i);
                        int currentRoomId = "Receptionist".equalsIgnoreCase(role) ? receptionistRoomId : roomId;

                        // Kiểm tra ngày nghỉ nếu là Doctor
                        boolean isAbsent = false;
                        if ("Doctor".equalsIgnoreCase(role)) {
                            absenceStmt.setInt(1, userId);
                            absenceStmt.setDate(2, Date.valueOf(date));
                            try (ResultSet rs = absenceStmt.executeQuery()) {
                                if (rs.next() && rs.getInt(1) > 0) {
                                    isAbsent = true;
                                }
                            }
                        }

                        if (!isAbsent) {
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
                                    insertStmt.setInt(3, currentRoomId);
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
                                    notifyStmt.setString(6, "Bạn được phân lịch ngày " + date + " từ " + morningStart + " đến " + morningEnd + " tại phòng " + currentRoomId);
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
                                    insertStmt.setInt(3, currentRoomId);
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
                                    notifyStmt.setString(6, "Bạn được phân lịch ngày " + date + " từ " + afternoonStart + " đến " + afternoonEnd + " tại phòng " + currentRoomId);
                                    notifyStmt.setBoolean(7, false);
                                    notifyStmt.addBatch();
                                }
                            }
                        }
                    }
                }
            }

            // Thực thi batch
            insertStmt.executeBatch();
            notifyStmt.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            System.err.println("Lỗi khi tạo lịch làm việc: " + e.getMessage());
            throw e;
        }
    }

    // Thêm slot
    public boolean addScheduleEmployee(ScheduleEmployee slot) throws SQLException, ClassNotFoundException {
        // Kiểm tra roomId hợp lệ
        if (slot.getRoomId() > 0) {
            Rooms room = roomsDAO.getRoomByID(slot.getRoomId()); // Kiểm tra bằng getRoomByID
            if (room == null) {
                throw new IllegalArgumentException("RoomID " + slot.getRoomId() + " does not exist.");
            }
        }

        String sql = "INSERT INTO ScheduleEmployee (UserID, Role, RoomID, SlotDate, StartTime, EndTime, IsAbsent, AbsenceReason, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slot.getUserId());
            pstmt.setString(2, slot.getRole());
            pstmt.setInt(3, slot.getRoomId());
            pstmt.setDate(4, Date.valueOf(slot.getSlotDate()));
            pstmt.setTime(5, Time.valueOf(slot.getStartTime()));
            pstmt.setTime(6, Time.valueOf(slot.getEndTime()));
            pstmt.setBoolean(7, slot.isAbsent());
            pstmt.setString(8, slot.getAbsenceReason());
            pstmt.setString(9, slot.getStatus());
            pstmt.setInt(10, slot.getCreatedBy());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding schedule employee slot: " + e.getMessage());
            throw e;
        }
    }

    // Cập nhật slot
    public boolean updateScheduleEmployee(ScheduleEmployee slot) throws SQLException, ClassNotFoundException {
        // Kiểm tra roomId hợp lệ
        if (slot.getRoomId() > 0) {
            Rooms room = roomsDAO.getRoomByID(slot.getRoomId()); // Kiểm tra bằng getRoomByID
            if (room == null) {
                throw new IllegalArgumentException("RoomID " + slot.getRoomId() + " does not exist.");
            }
        }

        String sql = "UPDATE ScheduleEmployee SET UserID = ?, Role = ?, RoomID = ?, SlotDate = ?, StartTime = ?, EndTime = ?, IsAbsent = ?, AbsenceReason = ?, Status = ?, CreatedBy = ?, UpdatedAt = GETDATE() WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slot.getUserId());
            pstmt.setString(2, slot.getRole());
            pstmt.setInt(3, slot.getRoomId());
            pstmt.setDate(4, Date.valueOf(slot.getSlotDate()));
            pstmt.setTime(5, Time.valueOf(slot.getStartTime()));
            pstmt.setTime(6, Time.valueOf(slot.getEndTime()));
            pstmt.setBoolean(7, slot.isAbsent());
            pstmt.setString(8, slot.getAbsenceReason());
            pstmt.setString(9, slot.getStatus());
            pstmt.setInt(10, slot.getCreatedBy());
            pstmt.setInt(11, slot.getSlotId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating schedule employee slot: " + e.getMessage());
            throw e;
        }
    }

    // Các phương thức khác giữ nguyên
    public List<ScheduleEmployee> getAllScheduleEmployees() throws SQLException, ClassNotFoundException {
        List<ScheduleEmployee> slots = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, IsAbsent, AbsenceReason, Status, CreatedBy, CreatedAt, UpdatedAt FROM ScheduleEmployee";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ScheduleEmployee slot = new ScheduleEmployee();
                slot.setSlotId(rs.getInt("SlotID"));
                slot.setUserId(rs.getInt("UserID"));
                slot.setRole(rs.getString("Role"));
                slot.setRoomId(rs.getInt("RoomID"));
                slot.setSlotDate(rs.getObject("SlotDate", LocalDate.class));
                slot.setStartTime(rs.getObject("StartTime", LocalTime.class));
                slot.setEndTime(rs.getObject("EndTime", LocalTime.class));
                slot.setAbsent(rs.getBoolean("IsAbsent"));
                slot.setAbsenceReason(rs.getString("AbsenceReason"));
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
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, IsAbsent, AbsenceReason, Status, CreatedBy, CreatedAt, UpdatedAt FROM ScheduleEmployee WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ScheduleEmployee slot = new ScheduleEmployee();
                    slot.setSlotId(rs.getInt("SlotID"));
                    slot.setUserId(rs.getInt("UserID"));
                    slot.setRole(rs.getString("Role"));
                    slot.setRoomId(rs.getInt("RoomID"));
                    slot.setSlotDate(rs.getObject("SlotDate", LocalDate.class));
                    slot.setStartTime(rs.getObject("StartTime", LocalTime.class));
                    slot.setEndTime(rs.getObject("EndTime", LocalTime.class));
                    slot.setAbsent(rs.getBoolean("IsAbsent"));
                    slot.setAbsenceReason(rs.getString("AbsenceReason"));
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
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
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
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
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
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slotId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("NextQueue");
                }
            }
        }
        return 1;
    }

    public boolean addDoctorAbsence(DoctorAbsence absence) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO DoctorAbsences (DoctorID, AbsenceDate, Reason, Status, CreatedAt, ApprovedBy, ApprovedAt) VALUES (?, ?, ?, ?, GETDATE(), ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, absence.getDoctorId());
            pstmt.setDate(2, Date.valueOf(absence.getAbsenceDate()));
            pstmt.setString(3, absence.getReason());
            pstmt.setString(4, absence.getStatus());
            pstmt.setInt(5, absence.getApprovedBy());
            pstmt.setDate(6, absence.getApprovedAt() != null ? Date.valueOf(absence.getApprovedAt().toLocalDate()) : Date.valueOf(LocalDate.now()));
            int rowsApproved = pstmt.executeUpdate();
            if (rowsApproved > 0 && "Approved".equals(absence.getStatus())) {
                updateSlotsForAbsence(absence);
            }
            return rowsApproved > 0;
        } catch (SQLException e) {
            System.err.println("Error adding doctor absence: " + e.getMessage());
            throw e;
        }
    }

    private void updateSlotsForAbsence(DoctorAbsence absence) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE ScheduleEmployee SET IsAbsent = 1, AbsenceReason = ?, Status = 'Cancelled', UpdatedAt = GETDATE() WHERE UserID = ? AND SlotDate = ? AND IsAbsent = 0 AND Role = 'Doctor'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, absence.getReason());
            pstmt.setInt(2, absence.getDoctorId());
            pstmt.setDate(3, Date.valueOf(absence.getAbsenceDate()));
            pstmt.executeUpdate();

            String updateAppointmentsSql = "UPDATE Appointments SET Status = 'Rescheduled' WHERE SlotID IN (SELECT SlotID FROM ScheduleEmployee WHERE UserID = ? AND SlotDate = ? AND IsAbsent = 1 AND Role = 'Doctor')";
            try (PreparedStatement pstmt2 = conn.prepareStatement(updateAppointmentsSql)) {
                pstmt2.setInt(1, absence.getDoctorId());
                pstmt2.setDate(2, Date.valueOf(absence.getAbsenceDate()));
                pstmt2.executeUpdate();
            }
        }
    }

    public boolean addAppointmentLog(AppointmentLog log) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO AppointmentLogs (AppointmentID, Action, OldDoctorID, NewDoctorID, OldSlotID, NewSlotID, PerformedBy, Notes, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, log.getAppointmentId());
            pstmt.setString(2, log.getAction());
            pstmt.setInt(3, log.getOldDoctorId());
            pstmt.setInt(4, log.getNewDoctorId());
            pstmt.setInt(5, log.getOldSlotId());
            pstmt.setInt(6, log.getNewSlotId());
            pstmt.setInt(7, log.getPerformedBy());
            pstmt.setString(8, log.getNotes());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding appointment log: " + e.getMessage());
            throw e;
        }
    }

    public boolean addSMSTemplate(SMSTemplate template) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO SMSTemplates (TemplateCode, Message, UseCase, IsActive, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, template.getTemplateCode());
            pstmt.setString(2, template.getMessage());
            pstmt.setString(3, template.getUseCase());
            pstmt.setBoolean(4, template.isIsActive());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding SMS template: " + e.getMessage());
            throw e;
        }
    }

    public SMSTemplate getSMSTemplateByUseCase(String useCase) throws SQLException, ClassNotFoundException {
        String sql = "SELECT TemplateID, TemplateCode, Message, UseCase, IsActive, CreatedAt FROM SMSTemplates WHERE UseCase = ? AND IsActive = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, useCase);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    SMSTemplate template = new SMSTemplate();
                    template.setTemplateId(rs.getInt("TemplateID"));
                    template.setTemplateCode(rs.getString("TemplateCode"));
                    template.setMessage(rs.getString("Message"));
                    template.setUseCase(rs.getString("UseCase"));
                    template.setIsActive(rs.getBoolean("IsActive"));
                    template.setCreatedAt(rs.getObject("CreatedAt", LocalDateTime.class));
                    return template;
                }
            }
        }
        return null;
    }

    public boolean sendSMS(int appointmentId, String useCase) throws SQLException, ClassNotFoundException {
        SMSTemplate template = getSMSTemplateByUseCase(useCase);
        if (template != null && template.isIsActive()) {
            System.out.println("Sending SMS for appointment " + appointmentId + " [Template ID: " + template.getTemplateId() + "]: " + template.getMessage());
            return true;
        }
        return false;
    }

    public List<ScheduleEmployee> getScheduleEmployeesByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        List<ScheduleEmployee> slots = new ArrayList<>();
        String sql = "SELECT SlotID, UserID, Role, RoomID, SlotDate, StartTime, EndTime, IsAbsent, AbsenceReason, Status " +
                     "FROM ScheduleEmployee WHERE SlotDate BETWEEN ? AND ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, Date.valueOf(startDate));
            stmt.setDate(2, Date.valueOf(endDate));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ScheduleEmployee slot = new ScheduleEmployee();
                    slot.setSlotId(rs.getInt("SlotID"));
                    slot.setUserId(rs.getInt("UserID"));
                    slot.setRole(rs.getString("Role"));
                    slot.setRoomId(rs.getInt("RoomID"));
                    slot.setSlotDate(rs.getObject("SlotDate", LocalDate.class));
                    slot.setStartTime(rs.getObject("StartTime", Time.class).toLocalTime());
                    slot.setEndTime(rs.getObject("EndTime", Time.class).toLocalTime());
                    slot.setAbsent(rs.getBoolean("IsAbsent"));
                    slot.setAbsenceReason(rs.getString("AbsenceReason"));
                    slot.setStatus(rs.getString("Status"));
                    slots.add(slot);
                }
            }
        }
        return slots;
    }
}