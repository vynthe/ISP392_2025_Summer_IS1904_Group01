/*
 * Click nfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nfs://SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
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
import model.entity.DoctorSlots;

import model.entity.AppointmentQueue;
import model.entity.DoctorAbsence;
import model.entity.AppointmentLog;
import model.entity.SMSTemplate;

public class ScheduleDAO {
    private final DBContext dbContext;

    public ScheduleDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Tạo lịch làm việc tự động (⏱️)
    public void generateSchedule(int doctorId, int roomId, int createdBy, LocalDate startDate, boolean isYearly) throws SQLException, ClassNotFoundException {
        LocalDate endDate = isYearly ? startDate.plusYears(1) : startDate.plusWeeks(1);
        LocalTime morningStart = LocalTime.of(7, 30);
        LocalTime morningEnd = LocalTime.of(12, 30);
        LocalTime afternoonStart = LocalTime.of(13, 30);
        LocalTime afternoonEnd = LocalTime.of(17, 30);

        String sql = "INSERT INTO DoctorSlots (DoctorID, RoomID, SlotDate, StartTime, EndTime, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            conn.setAutoCommit(false);

            for (LocalDate date = startDate; date.isBefore(endDate); date = date.plusDays(1)) {
                if (date.getDayOfWeek().getValue() <= 6) { // Thứ 2 đến thứ 7 (1-6)
                    // Buổi sáng
                    pstmt.setInt(1, doctorId);
                    pstmt.setInt(2, roomId);
                    pstmt.setDate(3, Date.valueOf(date));
                    pstmt.setTime(4, Time.valueOf(morningStart));
                    pstmt.setTime(5, Time.valueOf(morningEnd));
                    pstmt.setString(6, "Available");
                    pstmt.setInt(7, createdBy);
                    pstmt.addBatch();

                    // Buổi chiều
                    pstmt.setInt(1, doctorId);
                    pstmt.setInt(2, roomId);
                    pstmt.setDate(3, Date.valueOf(date));
                    pstmt.setTime(4, Time.valueOf(afternoonStart));
                    pstmt.setTime(5, Time.valueOf(afternoonEnd));
                    pstmt.setString(6, "Available");
                    pstmt.setInt(7, createdBy);
                    pstmt.addBatch();
                }
            }

            pstmt.executeBatch();
            conn.commit();
        } catch (SQLException e) {
            System.err.println("Error generating schedule: " + e.getMessage());
            throw e;
        }
    }

    // Thêm slot (🧠)
    public boolean addDoctorSlot(DoctorSlots slot) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO DoctorSlots (DoctorID, RoomID, SlotDate, StartTime, EndTime, IsAbsent, AbsenceReason, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slot.getDoctorId());
            pstmt.setInt(2, slot.getRoomId());
            pstmt.setDate(3, Date.valueOf(slot.getSlotDate()));
            pstmt.setTime(4, Time.valueOf(slot.getStartTime()));
            pstmt.setTime(5, Time.valueOf(slot.getEndTime()));
            pstmt.setBoolean(6, slot.isAbsent());
            pstmt.setString(7, slot.getAbsenceReason());
            pstmt.setString(8, slot.getStatus());
            pstmt.setInt(9, slot.getCreatedBy());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error adding doctor slot: " + e.getMessage());
            throw e;
        }
    }

    // Cập nhật slot (bao gồm xử lý vắng mặt ❌)
    public boolean updateDoctorSlot(DoctorSlots slot) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE DoctorSlots SET DoctorID = ?, RoomID = ?, SlotDate = ?, StartTime = ?, EndTime = ?, IsAbsent = ?, AbsenceReason = ?, Status = ?, CreatedBy = ?, UpdatedAt = GETDATE() WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, slot.getDoctorId());
            pstmt.setInt(2, slot.getRoomId());
            pstmt.setDate(3, Date.valueOf(slot.getSlotDate()));
            pstmt.setTime(4, Time.valueOf(slot.getStartTime()));
            pstmt.setTime(5, Time.valueOf(slot.getEndTime()));
            pstmt.setBoolean(6, slot.isAbsent());
            pstmt.setString(7, slot.getAbsenceReason());
            pstmt.setString(8, slot.getStatus());
            pstmt.setInt(9, slot.getCreatedBy());
            pstmt.setInt(10, slot.getSlotId());
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating doctor slot: " + e.getMessage());
            throw e;
        }
    }

    // Lấy tất cả slot
    public List<DoctorSlots> getAllDoctorSlots() throws SQLException, ClassNotFoundException {
        List<DoctorSlots> slots = new ArrayList<>();
        String sql = "SELECT SlotID, DoctorID, RoomID, SlotDate, StartTime, EndTime, IsAbsent, AbsenceReason, Status, CreatedBy, CreatedAt, UpdatedAt FROM DoctorSlots";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                DoctorSlots slot = new DoctorSlots();
                slot.setSlotId(rs.getInt("SlotID"));
                slot.setDoctorId(rs.getInt("DoctorID"));
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

    // Lấy slot theo ID
    public DoctorSlots getDoctorSlotById(int slotId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT SlotID, DoctorID, RoomID, SlotDate, StartTime, EndTime, IsAbsent, AbsenceReason, Status, CreatedBy, CreatedAt, UpdatedAt FROM DoctorSlots WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    DoctorSlots slot = new DoctorSlots();
                    slot.setSlotId(rs.getInt("SlotID"));
                    slot.setDoctorId(rs.getInt("DoctorID"));
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

    // Xóa slot
    public boolean deleteDoctorSlot(int slotId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM DoctorSlots WHERE SlotID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, slotId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting doctor slot: " + e.getMessage());
            throw e;
        }
    }
    // Gán STT cho bệnh nhân trong slot (📌)
    public boolean addAppointmentQueue(AppointmentQueue queue) throws SQLException, ClassNotFoundException {
        // Tính QueueNumber tự động (tăng dần theo SlotID)
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
        return 1; // Nếu chưa có queue cho slot này
    }
// Thêm lịch nghỉ
    public boolean addDoctorAbsence(DoctorAbsence absence) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO DoctorAbsences (DoctorID, AbsenceDate, Reason, Status, CreatedAt, ApprovedBy, ApprovedAt) VALUES (?, ?, ?, ?, GETDATE(), ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, absence.getDoctorId());
            pstmt.setDate(3, Date.valueOf(absence.getAbsenceDate())); // Chuyển LocalDate sang java.sql.Date
            pstmt.setString(4, absence.getReason());
            pstmt.setString(5, absence.getStatus());
            pstmt.setInt(6, absence.getApprovedBy());
            pstmt.setDate(7, Date.valueOf(absence.getApprovedAt() != null ? absence.getApprovedAt().toLocalDate() : LocalDate.now())); // Xử lý ApprovedAt
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

    // Cập nhật slot khi bác sĩ vắng mặt (❌)
    private void updateSlotsForAbsence(DoctorAbsence absence) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE DoctorSlots SET IsAbsent = 1, AbsenceReason = ?, Status = 'Cancelled', UpdatedAt = GETDATE() WHERE DoctorID = ? AND SlotDate = ? AND IsAbsent = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, absence.getReason());
            pstmt.setInt(2, absence.getDoctorId());
            pstmt.setDate(3, Date.valueOf(absence.getAbsenceDate()));
            pstmt.executeUpdate();

            // Hoãn lịch hẹn liên quan
            String updateAppointmentsSql = "UPDATE Appointments SET Status = 'Rescheduled' WHERE SlotID IN (SELECT SlotID FROM DoctorSlots WHERE DoctorID = ? AND SlotDate = ? AND IsAbsent = 1)";
            try (PreparedStatement pstmt2 = conn.prepareStatement(updateAppointmentsSql)) {
                pstmt2.setInt(1, absence.getDoctorId());
                pstmt2.setDate(2, Date.valueOf(absence.getAbsenceDate()));
                pstmt2.executeUpdate();
            }
        }
    }

    // Thêm log thay đổi (🛠️)
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

    // Thêm hoặc lấy mẫu tin nhắn SMS (💬)
    public boolean addSMSTemplate(SMSTemplate template) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO SMSTemplates (TemplateCode, Message, UseCase, IsActive, CreatedAt) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, template.getTemplateCode());
            pstmt.setString(2, template.getMessage());
            pstmt.setString(3, template.getUseCase());
            pstmt.setBoolean(4, template.isIsActive()); // Sử dụng isIsActive() theo entity
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
                    template.setIsActive(rs.getBoolean("IsActive")); // Sử dụng setIsActive
                    template.setCreatedAt(rs.getObject("CreatedAt", LocalDateTime.class));
                    return template;
                }
            }
        }
        return null;
    }

    // Gửi SMS (mô phỏng, cần tích hợp API thực tế)
    public boolean sendSMS(int appointmentId, String useCase) throws SQLException, ClassNotFoundException {
        SMSTemplate template = getSMSTemplateByUseCase(useCase);
        if (template != null && template.isIsActive()) { // Kiểm tra IsActive theo entity
            // Logic giả lập gửi SMS, sử dụng templateId và message
            System.out.println("Sending SMS for appointment " + appointmentId + " [Template ID: " + template.getTemplateId() + "]: " + template.getMessage());
            return true;
        }
        return false;
    }
}