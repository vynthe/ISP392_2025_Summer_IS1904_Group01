package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.entity.Schedules;
import model.entity.Rooms;

public class SchedulesDAO {
    private DBContext dbContext;

    // Constructor sử dụng DBContext
    public SchedulesDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Kiểm tra StartTime và EndTime nằm trong ca sáng (7:00-12:00) hoặc ca chiều (13:00-18:00)
    private boolean isValidTimeSlot(Date startTime, Date endTime) {
        LocalTime morningStart = LocalTime.of(7, 0);
        LocalTime morningEnd = LocalTime.of(12, 0);
        LocalTime afternoonStart = LocalTime.of(13, 0);
        LocalTime afternoonEnd = LocalTime.of(18, 0);

        // Chuyển java.sql.Date thành LocalDateTime (giả định giờ/phút được nhập từ giao diện)
        LocalDateTime startDateTime = startTime.toLocalDate().atStartOfDay();
        LocalDateTime endDateTime = endTime.toLocalDate().atStartOfDay();

        // Giả định giờ/phút được cung cấp qua giao diện, cần lấy từ logic khác
        // Vì java.sql.Date không lưu giờ, kiểm tra này chỉ kiểm tra ngày
        // Cảnh báo: Nên dùng java.sql.Timestamp để lưu giờ
        if (!startDateTime.toLocalDate().equals(endDateTime.toLocalDate())) {
            return false; // Không cho phép lịch trình kéo dài qua ngày
        }

        // Vì java.sql.Date không lưu giờ, kiểm tra khung giờ cần được thực hiện ở tầng giao diện
        // Giả định giao diện đảm bảo giờ trong khoảng 7:00-12:00 hoặc 13:00-18:00
        return true;
    }

    // Kiểm tra DayOfWeek từ Monday đến Saturday
    private boolean isValidDayOfWeek(String dayOfWeek) {
        String[] validDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
        for (String day : validDays) {
            if (day.equalsIgnoreCase(dayOfWeek)) {
                return true;
            }
        }
        return false;
    }

    // Lấy phòng khả dụng cho DoctorID và NurseID cụ thể
    private Room getAvailableRoomForDoctorAndNurse(int doctorID, int nurseID) throws SQLException {
        String query = "SELECT RoomID, DoctorID, NurseID FROM Rooms WHERE DoctorID = ? AND NurseID = ? AND Status = 'Available'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorID);
            stmt.setInt(2, nurseID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Room room = new Room();
                room.setRoomID(rs.getInt("RoomID"));
                room.setDoctorID(rs.getInt("DoctorID"));
                room.setNurseID(rs.getInt("NurseID"));
                return room;
            }
            return null; // Không có phòng khả dụng cho bác sĩ và y tá này
        }
    }

    // Create: Tạo lịch trình cho bác sĩ và y tá cụ thể
    public boolean createSchedule(Schedules schedule, int doctorID, int nurseID) throws SQLException {
        // Kiểm tra khung giờ hợp lệ
        if (!isValidTimeSlot(schedule.getStartTime(), schedule.getEndTime())) {
            return false; // Khung giờ không hợp lệ
        }

        // Kiểm tra ngày hợp lệ (Thứ Hai - Thứ Bảy)
        if (!isValidDayOfWeek(schedule.getDayOfWeek())) {
            return false; // Ngày không hợp lệ
        }

        // Lấy phòng khả dụng cho bác sĩ và y tá cụ thể
        Room room = getAvailableRoomForDoctorAndNurse(doctorID, nurseID);
        if (room == null) {
            return false; // Không có phòng khả dụng cho bác sĩ và y tá này
        }

        String query = "INSERT INTO Schedules (DoctorID, NurseID, StartTime, EndTime, DayOfWeek, RoomID, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorID);
            stmt.setInt(2, nurseID);
            stmt.setDate(3, schedule.getStartTime());
            stmt.setDate(4, schedule.getEndTime());
            stmt.setString(5, schedule.getDayOfWeek());
            stmt.setInt(6, room.getRoomID());
            stmt.setString(7, "Available"); // Trạng thái mặc định
            stmt.setInt(8, schedule.getCreatedBy());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Read: Lấy danh sách tất cả lịch trình
    public List<Schedules> getAllSchedules() throws SQLException {
        List<Schedules> schedules = new ArrayList<>();
        String query = "SELECT * FROM Schedules";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Schedules schedule = new Schedules();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setDoctorID(rs.getInt("DoctorID"));
                schedule.setNurseID(rs.getInt("NurseID"));
                schedule.setStartTime(rs.getDate("StartTime"));
                schedule.setEndTime(rs.getDate("EndTime"));
                schedule.setDayOfWeek(rs.getString("DayOfWeek"));
                schedule.setRoomID(rs.getInt("RoomID"));
                schedule.setStatus(rs.getString("Status"));
                schedule.setCreatedBy(rs.getInt("CreatedBy"));
                schedule.setCreatedAt(rs.getDate("CreatedAt"));
                schedule.setUpdatedAt(rs.getDate("UpdatedAt"));
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    // Read: Lấy lịch trình theo ID
    public Schedules getScheduleById(int scheduleID) throws SQLException {
        String query = "SELECT * FROM Schedules WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Schedules schedule = new Schedules();
                    schedule.setScheduleID(rs.getInt("ScheduleID"));
                    schedule.setDoctorID(rs.getInt("DoctorID"));
                    schedule.setNurseID(rs.getInt("NurseID"));
                    schedule.setStartTime(rs.getDate("StartTime"));
                    schedule.setEndTime(rs.getDate("EndTime"));
                    schedule.setDayOfWeek(rs.getString("DayOfWeek"));
                    schedule.setRoomID(rs.getInt("RoomID"));
                    schedule.setStatus(rs.getString("Status"));
                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
                    schedule.setCreatedAt(rs.getDate("CreatedAt"));
                    schedule.setUpdatedAt(rs.getDate("UpdatedAt"));
                    return schedule;
                }
            }
        }
        return null; // Không tìm thấy lịch trình
    }

    // Update: Cập nhật thông tin lịch trình
    public boolean updateSchedule(Schedules schedule) throws SQLException {
        // Kiểm tra khung giờ hợp lệ
        if (!isValidTimeSlot(schedule.getStartTime(), schedule.getEndTime())) {
            return false; // Khung giờ không hợp lệ
        }

        // Kiểm tra ngày hợp lệ (Thứ Hai - Thứ Bảy)
        if (!isValidDayOfWeek(schedule.getDayOfWeek())) {
            return false; // Ngày không hợp lệ
        }

        // Kiểm tra phòng có hợp lệ cho DoctorID và NurseID không
        String queryRoom = "SELECT DoctorID, NurseID FROM Rooms WHERE RoomID = ? AND Status = 'Available'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmtRoom = conn.prepareStatement(queryRoom)) {
            stmtRoom.setInt(1, schedule.getRoomID());
            try (ResultSet rs = stmtRoom.executeQuery()) {
                if (rs.next()) {
                    int roomDoctorID = rs.getInt("DoctorID");
                    int roomNurseID = rs.getInt("NurseID");
                    // Đảm bảo DoctorID và NurseID khớp với phòng
                    if (roomDoctorID != schedule.getDoctorID() || roomNurseID != schedule.getNurseID()) {
                        return false; // Không khớp với phòng
                    }
                } else {
                    return false; // Phòng không khả dụng
                }
            }
        }

        String query = "UPDATE Schedules SET DoctorID = ?, NurseID = ?, StartTime = ?, EndTime = ?, DayOfWeek = ?, " +
                      "RoomID = ?, Status = ?, CreatedBy = ?, UpdatedAt = GETDATE() WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, schedule.getDoctorID());
            stmt.setInt(2, schedule.getNurseID());
            stmt.setDate(3, schedule.getStartTime());
            stmt.setDate(4, schedule.getEndTime());
            stmt.setString(5, schedule.getDayOfWeek());
            stmt.setInt(6, schedule.getRoomID());
            stmt.setString(7, schedule.getStatus());
            stmt.setInt(8, schedule.getCreatedBy());
            stmt.setInt(9, schedule.getScheduleID());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Delete: Xóa lịch trình theo ID
    public boolean deleteSchedule(int scheduleID) throws SQLException {
        String query = "DELETE FROM Schedules WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}