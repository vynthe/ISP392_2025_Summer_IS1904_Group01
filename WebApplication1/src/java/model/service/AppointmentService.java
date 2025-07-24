
package model.service;

import model.entity.Users;
import model.entity.Rooms;
import model.entity.Services;
import model.entity.ScheduleEmployee;
import model.dao.AppointmentDAO;

import java.sql.SQLException;
import java.time.LocalDateTime;
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

        String trimmedKeyword = keyword != null ? keyword.trim() : null;

        // Gọi DAO để lấy danh sách lịch hẹn
        List<Map<String, Object>> appointments = appointmentDAO.searchAppointments(page, pageSize, trimmedKeyword);
        
        // Lấy tổng số bản ghi
        int totalRecords = appointmentDAO.getTotalFilteredRecords(trimmedKeyword);
        
        // Tính tổng số trang
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Trả về kết quả đóng gói
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
            this.appointments = appointments;
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

        String trimmedNameKeyword = nameKeyword != null ? nameKeyword.trim() : null;
        String trimmedSpecialtyKeyword = specialtyKeyword != null ? specialtyKeyword.trim() : null;

        return appointmentDAO.searchDoctorsByNameAndSpecialty(trimmedNameKeyword, trimmedSpecialtyKeyword, page, pageSize);
    }

    public int getTotalDoctorRecords(String nameKeyword, String specialtyKeyword) throws SQLException {
        String trimmedNameKeyword = nameKeyword != null ? nameKeyword.trim() : null;
        String trimmedSpecialtyKeyword = specialtyKeyword != null ? specialtyKeyword.trim() : null;

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

    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("ID bác sĩ không hợp lệ: " + doctorId);
        }

        Map<String, Object> details = appointmentDAO.viewDetailBook(doctorId);
        if (details == null) {
            System.err.println("🔧 DEBUG - AppointmentService.viewDetailBook: Không tìm thấy thông tin cho doctorId = " + doctorId + " tại " + java.time.LocalDateTime.now() + " +07");
            return new HashMap<>();
        }

        System.out.println("🔧 DEBUG - AppointmentService.viewDetailBook: doctorId = " + doctorId + ", roomID = " + (details.get("roomID") != null ? details.get("roomID") : "null") + " tại " + java.time.LocalDateTime.now() + " +07");
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
            System.err.println("Ca " + slotId + " đã đầy (đạt 5 lịch hẹn) tại " + java.time.LocalDateTime.now() + " +07");
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

        return appointmentDAO.cancelAppointment(appointmentId);
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

    return appointmentDAO.getScheduleWithAppointments(roomId, slotId); // ⬅️ Đảm bảo DAO có hàm này
}


        public String getUserNameById(int userId) throws SQLException {
    if (userId <= 0) {
        throw new IllegalArgumentException("ID người dùng không hợp lệ: " + userId);
    }
    return appointmentDAO.getUserFullNameById(userId); // gọi hàm đã sẵn có
}

public String getServiceNameById(int serviceId) throws SQLException {
    if (serviceId <= 0) {
        throw new IllegalArgumentException("ID dịch vụ không hợp lệ: " + serviceId);
    }
    return appointmentDAO.getServiceNameById(serviceId);
}


}
