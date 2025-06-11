package model.service;

import model.dao.SchedulesDAO;
import java.sql.SQLException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import model.entity.Schedules;

public class SchedulesService {

    private final SchedulesDAO schedulesDAO;

    public SchedulesService() {
        this.schedulesDAO = new SchedulesDAO();
    }

    public List<Map<String, Object>> getAllSchedules() throws SQLException, ClassNotFoundException {
        return schedulesDAO.getAllSchedulesWithUserInfo(); // Trả về Map với thông tin user
    }

    public List<Schedules> getSchedulesByRoleAndUserId(String role, Integer userId) throws SQLException, ClassNotFoundException {
        return schedulesDAO.getSchedulesByRoleAndUserId(role, userId);
    }

    public boolean addSchedule(Schedules schedule) throws SQLException, ClassNotFoundException {
        try {
            return schedulesDAO.addSchedule(schedule);
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error in SchedulesService.addSchedule: " + e.getMessage());
            throw e;
        }
    }

    // Delegates conflict check to DAO, now only checking room conflicts
    public boolean isScheduleConflict(Schedules schedule) throws SQLException, ClassNotFoundException {
        return schedulesDAO.isScheduleConflict(schedule);
    }
    public boolean checkScheduleExists(LocalDate startDate, LocalDate endDate, String role)
            throws SQLException, ClassNotFoundException {
        return schedulesDAO.hasScheduleForRoleInPeriod(role, startDate, endDate);
    }

    public boolean updateSchedule(Map<String, Object> scheduleData) throws SQLException, ClassNotFoundException {
        Schedules entity = new Schedules();
        entity.setScheduleID((Integer) scheduleData.get("scheduleId"));
        entity.setEmployeeID((Integer) scheduleData.get("employeeId"));
        entity.setRole((String) scheduleData.get("role"));
        entity.setStartTime((Date) scheduleData.get("startTime"));
        entity.setEndTime((Date) scheduleData.get("endTime"));
        entity.setDayOfWeek((String) scheduleData.get("dayOfWeek"));
        entity.setRoomID((Integer) scheduleData.get("roomId"));
        entity.setStatus((String) scheduleData.get("status"));
        entity.setCreatedBy((Integer) scheduleData.get("createdBy"));
        entity.setShiftStart((Time) scheduleData.get("shiftStart"));
        entity.setShiftEnd((Time) scheduleData.get("shiftEnd"));

        return schedulesDAO.updateSchedule(entity);
    }

    public boolean updateScheduleWithOldParams(Map<String, Object> scheduleData) throws SQLException, ClassNotFoundException {
        Schedules entity = new Schedules();
        entity.setScheduleID((Integer) scheduleData.get("scheduleId"));

        // Xử lý role và employeeID dựa trên tham số cũ
        if (scheduleData.containsKey("doctorId") && scheduleData.get("doctorId") != null) {
            entity.setEmployeeID((Integer) scheduleData.get("doctorId"));
            entity.setRole("Doctor");
        } else if (scheduleData.containsKey("nurseId") && scheduleData.get("nurseId") != null) {
            entity.setEmployeeID((Integer) scheduleData.get("nurseId"));
            entity.setRole("Nurse");
        } else if (scheduleData.containsKey("receptionistId") && scheduleData.get("receptionistId") != null) {
            entity.setEmployeeID((Integer) scheduleData.get("receptionistId"));
            entity.setRole("Receptionist");
        }

        entity.setStartTime((Date) scheduleData.get("startTime"));
        entity.setEndTime((Date) scheduleData.get("endTime"));
        entity.setDayOfWeek((String) scheduleData.get("dayOfWeek"));
        entity.setRoomID((Integer) scheduleData.get("roomId"));
        entity.setStatus((String) scheduleData.get("status"));
        entity.setCreatedBy((Integer) scheduleData.get("createdBy"));
        entity.setShiftStart((Time) scheduleData.get("shiftStart"));
        entity.setShiftEnd((Time) scheduleData.get("shiftEnd"));

        return schedulesDAO.updateSchedule(entity);
    }

    public boolean deleteSchedule(int scheduleId) throws SQLException, ClassNotFoundException {
        Schedules entity = schedulesDAO.getScheduleById(scheduleId);
        if (entity != null) {
            return schedulesDAO.deleteSchedule(scheduleId);
        }
        return false;
    }

    public List<Schedules> getSchedulesByRole(String role) throws SQLException, ClassNotFoundException {
        return schedulesDAO.getSchedulesByRole(role);
    }

    public List<Schedules> getSchedulesByEmployeeId(int employeeId) throws SQLException, ClassNotFoundException {
        return schedulesDAO.getSchedulesByEmployeeId(employeeId);
    }

    public Schedules getScheduleById(int scheduleId) throws SQLException, ClassNotFoundException {
        return schedulesDAO.getScheduleById(scheduleId);
    }

    public boolean createScheduleForEmployee(int employeeId, String role, Date startTime, Date endTime,
            Time shiftStart, Time shiftEnd, String dayOfWeek, int roomId, int createdBy)
            throws SQLException, ClassNotFoundException {
        Schedules schedule = new Schedules();
        schedule.setEmployeeID(employeeId);
        schedule.setRole(role);
        schedule.setStartTime(startTime);
        schedule.setEndTime(endTime);
        schedule.setDayOfWeek(dayOfWeek);
        schedule.setRoomID(roomId);
        schedule.setStatus("Available");
        schedule.setCreatedBy(createdBy);
        schedule.setShiftStart(shiftStart);
        schedule.setShiftEnd(shiftEnd);

        return schedulesDAO.addSchedule(schedule);
    }

    // Phương thức kiểm tra lịch theo role trong khoảng thời gian
    public boolean hasGeneralScheduleForRoleInPeriod(String role, LocalDate startDate, LocalDate endDate)
            throws SQLException, ClassNotFoundException {
        // Service có thể thêm logic nghiệp vụ ở đây trước khi gọi DAO
        // Ví dụ: kiểm tra tính hợp lệ của role, startDate, endDate
        if (role == null || role.trim().isEmpty()) {
            throw new IllegalArgumentException("Role cannot be null or empty");
        }
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Start date and end date cannot be null");
        }
        if (startDate.isAfter(endDate)) {
            throw new IllegalArgumentException("Start date cannot be after end date");
        }

        return schedulesDAO.hasScheduleForRoleInPeriod(role, startDate, endDate);
    }

    // Phương thức lấy tất cả schedules (trả về List<Schedules> thay vì Map)
    public List<Schedules> getAllSchedulesAsList() throws SQLException, ClassNotFoundException {
        return schedulesDAO.getAllSchedules();
    }

    // Phương thức validate schedule trước khi thêm/cập nhật
    public boolean validateSchedule(Schedules schedule) {
        if (schedule == null) {
            return false;
        }
        if (schedule.getEmployeeID() <= 0) {
            return false;
        }
        if (schedule.getRole() == null || schedule.getRole().trim().isEmpty()) {
            return false;
        }
        if (schedule.getStartTime() == null || schedule.getEndTime() == null) {
            return false;
        }
        if (schedule.getShiftStart() == null || schedule.getShiftEnd() == null) {
            return false;
        }
        if (schedule.getDayOfWeek() == null || schedule.getDayOfWeek().trim().isEmpty()) {
            return false;
        }
        if (schedule.getRoomID() <= 0) {
            return false;
        }

        // Kiểm tra startTime không sau endTime
        if (schedule.getStartTime().after(schedule.getEndTime())) {
            return false;
        }

        // Kiểm tra shiftStart không sau shiftEnd
        if (schedule.getShiftStart().after(schedule.getShiftEnd())) {
            return false;
        }

        return true;
    }

    // Phương thức thêm schedule với validation
    public boolean addScheduleWithValidation(Schedules schedule) throws SQLException, ClassNotFoundException {
        if (!validateSchedule(schedule)) {
            throw new IllegalArgumentException("Invalid schedule data");
        }
        // Kiểm tra conflict trước khi thêm
        if (isScheduleConflict(schedule)) {
            throw new IllegalStateException("Schedule conflict detected");
        }

        return schedulesDAO.addSchedule(schedule);
    }
public List<Map<String, Object>> searchSchedule(String employeeName, String role, String employeeID, LocalDate searchDate) throws SQLException, ClassNotFoundException {
    return schedulesDAO.searchSchedule(employeeName, role, employeeID, searchDate);
}
}

