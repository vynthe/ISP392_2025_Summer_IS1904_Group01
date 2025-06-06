package model.service;

import model.dao.SchedulesDAO;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import model.entity.Schedules;
import java.sql.Date;

public class SchedulesService {
    private final SchedulesDAO schedulesDAO;

    public SchedulesService() {
        this.schedulesDAO = new SchedulesDAO();
    }

  // Get all schedules (for admin)
   public List<Schedules> getAllSchedules() throws SQLException {
    return schedulesDAO.getAllSchedules();
}
   public List<Schedules> getSchedulesByRoleAndUserId(String role, Integer userId) throws SQLException {
    if ("admin".equalsIgnoreCase(role) || "receptionist".equalsIgnoreCase(role)) {
        return schedulesDAO.getAllSchedules();
    } else if ("doctor".equalsIgnoreCase(role) || "nurse".equalsIgnoreCase(role)) {
        return schedulesDAO.getSchedulesByRoleAndUserId(role, userId);
    }
    return null;
}

    // Lấy chi tiết phòng theo ScheduleID (chỉ cho doctor/nurse)
    public Map<String, Object> getRoomDetailsByScheduleId(int scheduleId, String role) throws SQLException {
        if ("doctor".equalsIgnoreCase(role) || "nurse".equalsIgnoreCase(role)) {
            return schedulesDAO.getRoomDetailsByScheduleId(scheduleId);
        }
        return null; // Chỉ doctor/nurse mới xem được chi tiết phòng
    }

    // Thêm lịch mới
    public boolean addSchedule(Map<String, Object> scheduleData) throws SQLException {
        // Giả định scheduleData chứa các key: startTime, endTime, dayOfWeek, roomId, createdBy
        Schedules entity = new Schedules();
        entity.setStartTime((Date) scheduleData.get("startTime"));
        entity.setEndTime((Date) scheduleData.get("endTime"));
        entity.setDayOfWeek((String) scheduleData.get("dayOfWeek"));
        entity.setRoomID((Integer) scheduleData.get("roomId"));
        entity.setCreatedBy((Integer) scheduleData.get("createdBy"));
        entity.setStatus("Available");
        return schedulesDAO.createSchedule(entity);
    }

    // Cập nhật lịch
    public boolean updateSchedule(Map<String, Object> scheduleData) throws SQLException {
        // Giả định scheduleData chứa các key: scheduleId, startTime, endTime, dayOfWeek, roomId, createdBy, status
        Schedules entity = new Schedules();
        entity.setScheduleID((Integer) scheduleData.get("scheduleId"));
        entity.setStartTime((Date) scheduleData.get("startTime"));
        entity.setEndTime((Date) scheduleData.get("endTime"));
        entity.setDayOfWeek((String) scheduleData.get("dayOfWeek"));
        entity.setRoomID((Integer) scheduleData.get("roomId"));
        entity.setCreatedBy((Integer) scheduleData.get("createdBy"));
        entity.setStatus((String) scheduleData.get("status"));
        return schedulesDAO.updateSchedule(entity);
    }

    // Xóa lịch
    public boolean deleteSchedule(int scheduleId) throws SQLException {
        Schedules entity = schedulesDAO.getScheduleById(scheduleId); // Giả định có phương thức này
        if (entity != null) {
            return schedulesDAO.deleteSchedule(scheduleId);
        }
        return false;
    }
}