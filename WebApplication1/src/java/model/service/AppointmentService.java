package model.service;

import model.entity.Users;
import model.entity.Rooms;
import model.entity.Services;
import model.entity.ScheduleEmployee;
import model.dao.AppointmentDAO;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class AppointmentService {

    private final AppointmentDAO appointmentDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
    }

    /**
     * Tìm kiếm lịch hẹn dựa trên từ khóa nhập vào, áp dụng cho các trường:
     * AppointmentID, PatientName, PatientPhone, PatientEmail, DoctorName, ServiceName, RoomName
     * @param page Trang hiện tại
     * @param pageSize Số bản ghi trên mỗi trang
     * @param keyword Từ khóa tìm kiếm
     * @return Đối tượng chứa danh sách lịch hẹn và thông tin phân trang
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public AppointmentSearchResult searchAppointments(int page, int pageSize, String keyword) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page và pageSize phải là số dương");
        }

        String trimmedKeyword = (keyword != null) ? keyword.trim() : null;
        List<Map<String, Object>> appointments = appointmentDAO.searchAppointments(page, pageSize, trimmedKeyword);
        int totalRecords = appointmentDAO.getTotalFilteredRecords(trimmedKeyword);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        return new AppointmentSearchResult(appointments, page, pageSize, totalPages);
    }

    /**
     * Lớp nội bộ để chứa kết quả tìm kiếm và thông tin phân trang
     */
    public static class AppointmentSearchResult {
        private final List<Map<String, Object>> appointments;
        private final int currentPage;
        private final int pageSize;
        private final int totalPages;

        public AppointmentSearchResult(List<Map<String, Object>> appointments, int currentPage, int pageSize, int totalPages) {
            this.appointments = (appointments != null) ? appointments : new ArrayList<>();
            this.currentPage = currentPage;
            this.pageSize = pageSize;
            this.totalPages = totalPages;
        }

        public List<Map<String, Object>> getAppointments() {
            return appointments;
        }

        public int getCurrentPage() {
            return currentPage;
        }

        public int getPageSize() {
            return pageSize;
        }

        public int getTotalPages() {
            return totalPages;
        }
    }

    public List<Users> searchDoctorsByNameAndSpecialty(String nameKeyword, String specialtyKeyword, int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page và pageSize phải là số dương");
        }

        String trimmedNameKeyword = (nameKeyword != null) ? nameKeyword.trim() : null;
        String trimmedSpecialtyKeyword = (specialtyKeyword != null) ? specialtyKeyword.trim() : null;

        return appointmentDAO.searchDoctorsByNameAndSpecialty(trimmedNameKeyword, trimmedSpecialtyKeyword, page, pageSize);
    }

    public int getTotalDoctorRecords(String nameKeyword, String specialtyKeyword) throws SQLException {
        String trimmedNameKeyword = (nameKeyword != null) ? nameKeyword.trim() : null;
        String trimmedSpecialtyKeyword = (specialtyKeyword != null) ? specialtyKeyword.trim() : null;

        return appointmentDAO.getTotalDoctorRecords(trimmedNameKeyword, trimmedSpecialtyKeyword);
    }

    public Map<String, Object> getDoctorDetails(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("ID bác sĩ không hợp lệ: " + doctorId);
        }

        Map<String, Object> details = new HashMap<>();
        details.put("room", appointmentDAO.getRoomByDoctorId(doctorId));
        details.put("services", appointmentDAO.getServicesByDoctorId(doctorId));
        details.put("schedule", appointmentDAO.getSchedulesByDoctorId(doctorId));

        return details;
    }

   public Map<String, Object> getSlotDetails(int slotId) throws SQLException {
    if (slotId <= 0) {
        throw new IllegalArgumentException("ID khung giờ không hợp lệ: " + slotId);
    }

    Map<String, Object> slotDetails = new HashMap<>();
    try {
        Map<String, Object> slotInfo = appointmentDAO.getSlotById(slotId);
        if (slotInfo == null || slotInfo.isEmpty()) {
            System.err.println("🔧 DEBUG - AppointmentService.getSlotDetails: Không tìm thấy khung giờ cho slotId = " + slotId + " tại " + LocalDateTime.now() + " +07");
            slotDetails.put("slotTime", "Không tìm thấy khung giờ");
            slotDetails.put("roomName", "Chưa có phòng");
            slotDetails.put("roomId", null);
            return slotDetails;
        }

        String startTime = (String) slotInfo.get("startTime");
        String endTime = (String) slotInfo.get("endTime");
        String roomName = (String) slotInfo.get("roomName");
        Object roomId = slotInfo.get("roomId");

        if (startTime != null && endTime != null) {
            String slotTime = startTime + " - " + endTime;
            slotDetails.put("slotTime", slotTime);
        } else {
            slotDetails.put("slotTime", "Khung giờ không xác định");
        }
        slotDetails.put("roomName", roomName != null && !roomName.equals("N/A") ? roomName : "Chưa có phòng");
        slotDetails.put("roomId", roomId);

        System.out.println("🔧 DEBUG - AppointmentService.getSlotDetails: slotId = " + slotId + 
                           ", slotTime = " + slotDetails.get("slotTime") + 
                           ", roomName = " + slotDetails.get("roomName") + 
                           ", roomId = " + slotDetails.get("roomId") + 
                           ", slotStatus = " + slotInfo.get("status") + 
                           " tại " + LocalDateTime.now() + " +07");
    } catch (SQLException e) {
        System.err.println("SQLException in getSlotDetails (slotId=" + slotId + "): " + 
                           e.getMessage() + ", SQLState: " + e.getSQLState() + " tại " + LocalDateTime.now() + " +07");
        slotDetails.put("slotTime", "Không tìm thấy khung giờ");
        slotDetails.put("roomName", "Chưa có phòng");
        slotDetails.put("roomId", null);
    }
    return slotDetails;
}
    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("ID bác sĩ không hợp lệ: " + doctorId);
        }

        Map<String, Object> details = appointmentDAO.viewDetailBook(doctorId);
        if (details == null || details.isEmpty()) {
            System.err.println("🔧 DEBUG - AppointmentService.viewDetailBook: Không tìm thấy thông tin cho doctorId = " + doctorId + " tại " + LocalDateTime.now() + " +07");
            return new HashMap<>();
        }

        // Kiểm tra và log chi tiết schedules
        List<Map<String, Object>> schedules = (List<Map<String, Object>>) details.get("schedules");
        if (schedules != null) {
            for (Map<String, Object> schedule : schedules) {
                System.out.println("🔧 DEBUG - Schedule for doctorId " + doctorId + ": slotId = " + schedule.get("slotId") + ", roomName = " + schedule.get("roomName") + " tại " + LocalDateTime.now() + " +07");
            }
        }

        System.out.println("🔧 DEBUG - AppointmentService.viewDetailBook: doctorId = " + doctorId + ", roomID = " + (details.get("roomID") != null ? details.get("roomID") : "null") + ", schedules count = " + (schedules != null ? schedules.size() : 0) + " tại " + LocalDateTime.now() + " +07");
        return details;
    }

    public Rooms getRoomByID(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("ID phòng không hợp lệ: " + roomId);
        }

        return appointmentDAO.getRoomByID(roomId);
    }

    public List<Services> getServicesByRoom(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("ID phòng không hợp lệ: " + roomId);
        }

        return appointmentDAO.getServicesByRoom(roomId);
    }

    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("ID phòng không hợp lệ: " + roomId);
        }

        return appointmentDAO.getPatientsByRoomId(roomId);
    }

    public List<ScheduleEmployee> getSchedulesByRoleAndUserId(String role, int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("ID người dùng không hợp lệ: " + userId);
        }
        if (role == null || role.trim().isEmpty()) {
            throw new IllegalArgumentException("Vai trò không được rỗng");
        }

        return appointmentDAO.getSchedulesByRoleAndUserId(role.trim(), userId);
    }

    public String getUserFullNameById(int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("ID người dùng không hợp lệ: " + userId);
        }

        return appointmentDAO.getUserFullNameById(userId);
    }

    public boolean isSlotFullyBooked(int slotId) throws SQLException {
        if (slotId <= 0) {
            throw new IllegalArgumentException("ID ca không hợp lệ: " + slotId);
        }

        int appointmentCount = appointmentDAO.countAppointmentsBySlotId(slotId);
        return appointmentCount >= 5;
    }

    public boolean createAppointment(int patientId, int doctorId, int serviceId, int slotId, int roomId) throws SQLException {
        if (patientId <= 0 || doctorId <= 0 || serviceId <= 0 || slotId <= 0 || roomId <= 0) {
            throw new IllegalArgumentException("Các ID phải là số dương");
        }

        if (isSlotFullyBooked(slotId)) {
            System.err.println("Ca " + slotId + " đã đầy (đạt 5 lịch hẹn) tại " + LocalDateTime.now() + " +07");
            return false;
        }

        return appointmentDAO.createAppointment(patientId, doctorId, serviceId, slotId, roomId);
    }

    public boolean appointmentExists(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("ID lịch hẹn không hợp lệ: " + appointmentId);
        }

        return appointmentDAO.appointmentExists(appointmentId);
    }

    public Map<String, Object> getAppointmentById(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("ID lịch hẹn không hợp lệ: " + appointmentId);
        }

        return appointmentDAO.getAppointmentById(appointmentId);
    }

 public boolean cancelAppointment(int appointmentId) throws SQLException {
    if (appointmentId <= 0) {
        throw new IllegalArgumentException("ID lịch hẹn không hợp lệ: " + appointmentId);
    }
    
    // Gọi phương thức tích hợp mới thay vì phương thức cũ
    return appointmentDAO.cancelAppointmentAndUpdateSlot(appointmentId);
}
    public boolean deleteAppointmentPermanently(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("ID lịch hẹn không hợp lệ: " + appointmentId);
        }

        return appointmentDAO.deleteAppointmentPermanently(appointmentId);
    }

    public int cancelMultipleAppointments(List<Integer> appointmentIds) throws SQLException {
        if (appointmentIds == null || appointmentIds.isEmpty()) {
            throw new IllegalArgumentException("Danh sách ID lịch hẹn không được rỗng");
        }

        for (Integer id : appointmentIds) {
            if (id == null || id <= 0) {
                throw new IllegalArgumentException("ID lịch hẹn không hợp lệ trong danh sách: " + id);
            }
        }

        return appointmentDAO.cancelMultipleAppointments(appointmentIds);
    }

    public List<Map<String, Object>> getAppointmentsByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            throw new IllegalArgumentException("ID bệnh nhân không hợp lệ: " + patientId);
        }

        return appointmentDAO.getAppointmentsByPatientId(patientId);
    }

    public List<Map<String, Object>> getAppointmentsByDoctorId(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("ID bác sĩ không hợp lệ: " + doctorId);
        }

        return appointmentDAO.getAppointmentsByDoctorId(doctorId);
    }

    public List<Map<String, Object>> getAllAppointments(int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page và pageSize phải là số dương");
        }

        return appointmentDAO.getAllAppointments(page, pageSize);
    }

    public List<Map<String, Object>> getScheduleWithAppointments(int roomId, int slotId) throws SQLException {
        if (roomId <= 0 || slotId <= 0) {
            throw new IllegalArgumentException("roomId và slotId phải là số dương");
        }

        return appointmentDAO.getScheduleWithAppointments(roomId, slotId);
    }

    public String getUserNameById(int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("ID người dùng không hợp lệ: " + userId);
        }
        return appointmentDAO.getUserFullNameById(userId);
    }

    public String getServiceNameById(int serviceId) throws SQLException {
        if (serviceId <= 0) {
            throw new IllegalArgumentException("ID dịch vụ không hợp lệ: " + serviceId);
        }
        return appointmentDAO.getServiceNameById(serviceId);
    }

    public boolean updateAppointmentSlot(int appointmentId, int newSlotId, int doctorId, int roomId) throws SQLException {
        if (appointmentId <= 0 || newSlotId <= 0 || doctorId <= 0 || roomId <= 0) {
            throw new IllegalArgumentException("Invalid input: All IDs must be positive");
        }

        Map<String, Object> appointmentDetails = appointmentDAO.getAppointmentById(appointmentId);
        if (appointmentDetails == null) {
            System.err.println("❌ Appointment " + appointmentId + " not found at " + LocalDateTime.now() + " +07");
            return false;
        }

        Integer appointmentDoctorId = (Integer) appointmentDetails.get("doctorId");
        if (appointmentDoctorId == null || !appointmentDoctorId.equals(doctorId)) {
            System.err.println("❌ Doctor ID mismatch for appointment " + appointmentId + 
                               " (expected: " + appointmentDoctorId + ", provided: " + doctorId + ") at " + LocalDateTime.now() + " +07");
            return false;
        }

        try {
            boolean updated = appointmentDAO.updateAppointmentSlot(appointmentId, newSlotId, doctorId, roomId);
            if (updated) {
                System.out.println("✅ Service: Appointment " + appointmentId + " slot updated successfully to slot " + newSlotId + 
                                   " at " + LocalDateTime.now() + " +07");
            } else {
                System.err.println("❌ Service: Failed to update appointment " + appointmentId + " to slot " + newSlotId + 
                                   " at " + LocalDateTime.now() + " +07");
            }
            return updated;
        } catch (SQLException e) {
            System.err.println("SQLException in updateAppointmentSlot (appointmentId=" + appointmentId + ", newSlotId=" + newSlotId + 
                               "): " + e.getMessage() + ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public List<Map<String, Object>> getAvailableSlotsForDoctor(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("ID bác sĩ không hợp lệ: " + doctorId);
        }

        try {
            List<ScheduleEmployee> schedules = appointmentDAO.getSchedulesByRoleAndUserId("Doctor", doctorId);
            List<Map<String, Object>> availableSlots = new ArrayList<>();
            for (ScheduleEmployee schedule : schedules) {
                int appointmentCount = appointmentDAO.countAppointmentsBySlotId(schedule.getSlotId());
                if (appointmentCount < 5) {
                    Map<String, Object> slot = new HashMap<>();
                    slot.put("slotId", schedule.getSlotId());
                    slot.put("slotDate", schedule.getSlotDate());
                    slot.put("startTime", schedule.getStartTime());
                    slot.put("endTime", schedule.getEndTime());
                    slot.put("roomId", schedule.getRoomId());
                    slot.put("status", schedule.getStatus());
                    slot.put("roomName", schedule.getRoomName()); // Thêm roomName
                    availableSlots.add(slot);
                }
            }
            return availableSlots;
        } catch (SQLException e) {
            System.err.println("SQLException in getAvailableSlotsForDoctor (doctorId=" + doctorId + 
                               "): " + e.getMessage() + ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public List<Map<String, Object>> getDetailedAppointmentsByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            throw new IllegalArgumentException("ID bệnh nhân không hợp lệ: " + patientId);
        }

        try {
            return appointmentDAO.getDetailedAppointmentsByPatientId(patientId);
        } catch (SQLException e) {
            throw new SQLException("Error getting detailed appointments by patient ID: " + e.getMessage(), e);
        }
    }

    /**
     * Lấy danh sách các phòng liên quan đến một bác sĩ dựa trên lịch trình
     * @param doctorId ID của bác sĩ
     * @return Danh sách các phòng với roomId và roomName
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public List<Map<String, Object>> getRoomsByDoctorId(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("ID bác sĩ không hợp lệ: " + doctorId);
        }

        List<Map<String, Object>> rooms = new ArrayList<>();
        List<ScheduleEmployee> schedules = appointmentDAO.getSchedulesByRoleAndUserId("Doctor", doctorId);
        for (ScheduleEmployee schedule : schedules) {
            Integer roomId = schedule.getRoomId();
            if (roomId != null) {
                Rooms room = appointmentDAO.getRoomByID(roomId);
                if (room != null && room.getRoomName() != null) {
                    Map<String, Object> roomMap = new HashMap<>();
                    roomMap.put("roomId", roomId);
                    roomMap.put("roomName", room.getRoomName());
                    if (rooms.stream().noneMatch(r -> r.get("roomId").equals(roomId))) {
                        rooms.add(roomMap);
                    }
                }
            }
        }
        return rooms.isEmpty() ? List.of(Map.of("roomId", "N/A", "roomName", "N/A")) : rooms;
    }
}