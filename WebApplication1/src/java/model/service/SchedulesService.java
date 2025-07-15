package model.service;

import model.dao.ScheduleDAO;
import model.entity.ScheduleEmployee;
import model.entity.AppointmentQueue;
import model.entity.DoctorAbsence;
import model.entity.AppointmentLog;
import model.entity.SMSTemplate;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import model.dao.DBContext;
import model.entity.Rooms;

public class SchedulesService {
    private final ScheduleDAO scheduleDAO;
    private final RoomService roomService;

    public SchedulesService() {
        this.scheduleDAO = new ScheduleDAO();
        this.roomService = new RoomService();
    }

    // Tạo lịch làm việc tự động
    public void generateSchedule(List<Integer> userIds, List<String> roles, int roomId, int createdBy, LocalDate startDate, boolean isYearly) throws SQLException, ClassNotFoundException {
        // Kiểm tra dữ liệu đầu vào
        if (userIds == null || roles == null || userIds.size() != roles.size()) {
            throw new IllegalArgumentException("Invalid input: userIds and roles must not be null and must have the same size.");
        }

        // Kiểm tra và lấy RoomID hợp lệ
        if (roomId <= 0) {
            roomId = roomService.getFirstAvailableRoomId();
            if (roomId == -1) {
                throw new IllegalArgumentException("No available rooms found.");
            }
        } else {
            try {
                Rooms room = roomService.getRoomByID(roomId); // Kiểm tra bằng getRoomByID
                if (room == null) {
                    throw new IllegalArgumentException("RoomID " + roomId + " does not exist.");
                }
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("RoomID " + roomId + " is invalid: " + e.getMessage());
            }
        }

        // Kiểm tra vai trò hợp lệ và phòng
        for (int i = 0; i < userIds.size(); i++) {
            String role = roles.get(i);
            if (!isValidRole(role)) {
                throw new IllegalArgumentException("Invalid role: " + role);
            }
            if (!isValidUser(userIds.get(i), role)) {
                throw new IllegalArgumentException("User ID " + userIds.get(i) + " does not match role " + role);
            }
        }

        // Gọi DAO để tạo lịch
        scheduleDAO.addSchedule(userIds, roles, roomId, createdBy, startDate, isYearly);
    }

    // Thêm slot
    public boolean addScheduleEmployee(ScheduleEmployee slot) throws SQLException, ClassNotFoundException {
        // Kiểm tra dữ liệu đầu vào
        if (slot == null || slot.getUserId() <= 0 || slot.getRole() == null || slot.getSlotDate() == null) {
            throw new IllegalArgumentException("Invalid schedule employee data.");
        }

        // Kiểm tra vai trò hợp lệ
        if (!isValidRole(slot.getRole())) {
            throw new IllegalArgumentException("Invalid role: " + slot.getRole());
        }

        // Kiểm tra UserID và Role
        if (!isValidUser(slot.getUserId(), slot.getRole())) {
            throw new IllegalArgumentException("User ID " + slot.getUserId() + " does not match role " + slot.getRole());
        }

        // Kiểm tra RoomID
        if (slot.getRoomId() <= 0) {
            int defaultRoomId = roomService.getFirstAvailableRoomId();
            if (defaultRoomId == -1) {
                throw new IllegalArgumentException("No available rooms found.");
            }
            slot.setRoomId(defaultRoomId); // Gán RoomID mặc định nếu không có
        } else {
            try {
                Rooms room = roomService.getRoomByID(slot.getRoomId()); // Kiểm tra bằng getRoomByID
                if (room == null) {
                    throw new IllegalArgumentException("RoomID " + slot.getRoomId() + " does not exist.");
                }
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("RoomID " + slot.getRoomId() + " is invalid: " + e.getMessage());
            }
        }

        // Thay vì cố định RoomID = 1 cho Receptionist, sử dụng RoomID hợp lệ
        if ("Receptionist".equalsIgnoreCase(slot.getRole()) && slot.getRoomId() <= 0) {
            int defaultRoomId = roomService.getFirstAvailableRoomId();
            if (defaultRoomId == -1) {
                throw new IllegalArgumentException("No available rooms found for Receptionist.");
            }
            slot.setRoomId(defaultRoomId); // Gán RoomID hợp lệ thay vì 1
        }

        return scheduleDAO.addScheduleEmployee(slot);
    }

    // Cập nhật slot
    public boolean updateScheduleEmployee(ScheduleEmployee slot) throws SQLException, ClassNotFoundException {
        // Kiểm tra dữ liệu đầu vào
        if (slot == null || slot.getSlotId() <= 0 || slot.getUserId() <= 0 || slot.getRole() == null) {
            throw new IllegalArgumentException("Invalid schedule employee data.");
        }

        // Kiểm tra vai trò hợp lệ
        if (!isValidRole(slot.getRole())) {
            throw new IllegalArgumentException("Invalid role: " + slot.getRole());
        }

        // Kiểm tra UserID và Role
        if (!isValidUser(slot.getUserId(), slot.getRole())) {
            throw new IllegalArgumentException("User ID " + slot.getUserId() + " does not match role " + slot.getRole());
        }

        // Kiểm tra RoomID
        if (slot.getRoomId() <= 0) {
            int defaultRoomId = roomService.getFirstAvailableRoomId();
            if (defaultRoomId == -1) {
                throw new IllegalArgumentException("No available rooms found.");
            }
            slot.setRoomId(defaultRoomId); // Gán RoomID mặc định nếu không có
        } else {
            try {
                Rooms room = roomService.getRoomByID(slot.getRoomId()); // Kiểm tra bằng getRoomByID
                if (room == null) {
                    throw new IllegalArgumentException("RoomID " + slot.getRoomId() + " does not exist.");
                }
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("RoomID " + slot.getRoomId() + " is invalid: " + e.getMessage());
            }
        }

        // Thay vì cố định RoomID = 1 cho Receptionist, sử dụng RoomID hợp lệ
        if ("Receptionist".equalsIgnoreCase(slot.getRole()) && slot.getRoomId() <= 0) {
            int defaultRoomId = roomService.getFirstAvailableRoomId();
            if (defaultRoomId == -1) {
                throw new IllegalArgumentException("No available rooms found for Receptionist.");
            }
            slot.setRoomId(defaultRoomId); // Gán RoomID hợp lệ thay vì 1
        }

        return scheduleDAO.updateScheduleEmployee(slot);
    }

    // Các phương thức khác giữ nguyên
    public List<ScheduleEmployee> getAllScheduleEmployees() throws SQLException, ClassNotFoundException {
        return scheduleDAO.getAllScheduleEmployees();
    }

    public ScheduleEmployee getScheduleEmployeeById(int slotId) throws SQLException, ClassNotFoundException {
        if (slotId <= 0) {
            throw new IllegalArgumentException("Invalid slot ID.");
        }
        return scheduleDAO.getScheduleEmployeeById(slotId);
    }

    public boolean deleteScheduleEmployee(int slotId) throws SQLException, ClassNotFoundException {
        if (slotId <= 0) {
            throw new IllegalArgumentException("Invalid slot ID.");
        }
        return scheduleDAO.deleteScheduleEmployee(slotId);
    }

    public boolean addAppointmentQueue(AppointmentQueue queue) throws SQLException, ClassNotFoundException {
        if (queue == null || queue.getSlotId() <= 0 || queue.getAppointmentId() <= 0) {
            throw new IllegalArgumentException("Invalid appointment queue data.");
        }
        return scheduleDAO.addAppointmentQueue(queue);
    }

    public boolean addDoctorAbsence(DoctorAbsence absence) throws SQLException, ClassNotFoundException {
        if (absence == null || absence.getDoctorId() <= 0 || absence.getAbsenceDate() == null) {
            throw new IllegalArgumentException("Invalid doctor absence data.");
        }
        if (!isValidUser(absence.getDoctorId(), "Doctor")) {
            throw new IllegalArgumentException("User ID " + absence.getDoctorId() + " is not a Doctor.");
        }
        return scheduleDAO.addDoctorAbsence(absence);
    }

    public boolean addAppointmentLog(AppointmentLog log) throws SQLException, ClassNotFoundException {
        if (log == null || log.getAppointmentId() <= 0) {
            throw new IllegalArgumentException("Invalid appointment log data.");
        }
        return scheduleDAO.addAppointmentLog(log);
    }

    public boolean addSMSTemplate(SMSTemplate template) throws SQLException, ClassNotFoundException {
        if (template == null || template.getTemplateCode() == null || template.getMessage() == null) {
            throw new IllegalArgumentException("Invalid SMS template data.");
        }
        return scheduleDAO.addSMSTemplate(template);
    }

    public SMSTemplate getSMSTemplateByUseCase(String useCase) throws SQLException, ClassNotFoundException {
        if (useCase == null || useCase.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid use case.");
        }
        return scheduleDAO.getSMSTemplateByUseCase(useCase);
    }

    public boolean sendSMS(int appointmentId, String useCase) throws SQLException, ClassNotFoundException {
        if (appointmentId <= 0 || useCase == null || useCase.trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid appointment ID or use case.");
        }
        return scheduleDAO.sendSMS(appointmentId, useCase);
    }

    private boolean isValidRole(String role) {
        return role != null && ("Doctor".equalsIgnoreCase(role) || "Nurse".equalsIgnoreCase(role) || "Receptionist".equalsIgnoreCase(role));
    }

    private boolean isValidUser(int userId, String role) throws SQLException, ClassNotFoundException {
        String sql = "SELECT Role FROM Users WHERE UserID = ?";
        try (Connection conn = DBContext.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String dbRole = rs.getString("Role");
                    return role.equalsIgnoreCase(dbRole);
                }
            }
        }
        return false;
    }

    public List<ScheduleEmployee> getScheduleEmployeesByDateRange(LocalDate startDate, LocalDate endDate) throws SQLException {
        if (startDate == null || endDate == null || startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Invalid date range.");
        }
        return scheduleDAO.getScheduleEmployeesByDateRange(startDate, endDate);
    }
}