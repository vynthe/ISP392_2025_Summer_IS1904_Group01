package model.service;

import model.entity.Users;
import model.entity.Rooms;
import model.entity.Services;
import model.entity.ScheduleEmployee;
import model.dao.AppointmentDAO;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

public class AppointmentService {

    private final AppointmentDAO appointmentDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
    }

    public List<Users> searchDoctorsByNameAndSpecialty(String nameKeyword, String specialtyKeyword, int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page and pageSize must be positive");
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
            throw new IllegalArgumentException("Invalid doctor ID: " + doctorId);
        }
        Map<String, Object> details = new HashMap<>();
        details.put("room", appointmentDAO.getRoomByDoctorId(doctorId));
        details.put("services", appointmentDAO.getServicesByDoctorId(doctorId));
        details.put("schedule", appointmentDAO.getSchedulesByDoctorId(doctorId));
        return details;
    }

    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("Invalid doctor ID: " + doctorId);
        }
        Map<String, Object> details = appointmentDAO.viewDetailBook(doctorId);
        if (details == null) {
            System.err.println("🔧 DEBUG - AppointmentService.viewDetailBook: No details returned for doctorId = " + doctorId + " at " + java.time.LocalDateTime.now() + " +07");
            return new HashMap<>(); // Trả về Map rỗng thay vì null
        }
        System.out.println("🔧 DEBUG - AppointmentService.viewDetailBook: doctorId = " + doctorId + ", roomID = " + (details.get("roomID") != null ? details.get("roomID") : "null") + " at " + java.time.LocalDateTime.now() + " +07");
        return details;
    }

    public Rooms getRoomByID(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID: " + roomId);
        }
        return appointmentDAO.getRoomByID(roomId);
    }

    public List<Services> getServicesByRoom(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID: " + roomId);
        }
        return appointmentDAO.getServicesByRoom(roomId);
    }

    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID: " + roomId);
        }
        return appointmentDAO.getPatientsByRoomId(roomId);
    }

    public List<ScheduleEmployee> getSchedulesByRoleAndUserId(String role, int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID: " + userId);
        }
        if (role == null || role.trim().isEmpty()) {
            throw new IllegalArgumentException("Role cannot be null or empty");
        }
        return appointmentDAO.getSchedulesByRoleAndUserId(role.trim(), userId);
    }

    public String getUserFullNameById(int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID: " + userId);
        }
        return appointmentDAO.getUserFullNameById(userId);
    }

    public boolean isSlotFullyBooked(int slotId) throws SQLException {
        if (slotId <= 0) {
            throw new IllegalArgumentException("Invalid slot ID: " + slotId);
        }
        int appointmentCount = appointmentDAO.countAppointmentsBySlotId(slotId);
        return appointmentCount >= 5;
    }

    public boolean createAppointment(int patientId, int doctorId, int serviceId, int slotId, int roomId) throws SQLException {
        if (patientId <= 0 || doctorId <= 0 || serviceId <= 0 || slotId <= 0 || roomId <= 0) {
            throw new IllegalArgumentException("Invalid input: All IDs must be positive");
        }
        if (isSlotFullyBooked(slotId)) {
            System.err.println("Slot " + slotId + " is fully booked (reached 5 appointments) at " + java.time.LocalDateTime.now() + " +07");
            return false;
        }
        return appointmentDAO.createAppointment(patientId, doctorId, serviceId, slotId, roomId);
    }

    public boolean appointmentExists(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.appointmentExists(appointmentId);
    }

    public Map<String, Object> getAppointmentById(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.getAppointmentById(appointmentId);
    }

    public boolean cancelAppointment(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.cancelAppointment(appointmentId);
    }

    public boolean deleteAppointmentPermanently(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.deleteAppointmentPermanently(appointmentId);
    }

    public int cancelMultipleAppointments(List<Integer> appointmentIds) throws SQLException {
        if (appointmentIds == null || appointmentIds.isEmpty()) {
            throw new IllegalArgumentException("Appointment IDs list cannot be null or empty");
        }
        for (Integer id : appointmentIds) {
            if (id == null || id <= 0) {
                throw new IllegalArgumentException("Invalid appointment ID in list: " + id);
            }
        }
        return appointmentDAO.cancelMultipleAppointments(appointmentIds);
    }

    public List<Map<String, Object>> getAppointmentsByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            throw new IllegalArgumentException("Invalid patient ID: " + patientId);
        }
        return appointmentDAO.getAppointmentsByPatientId(patientId);
    }

    public List<Map<String, Object>> getAppointmentsByDoctorId(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("Invalid doctor ID: " + doctorId);
        }
        return appointmentDAO.getAppointmentsByDoctorId(doctorId);
    }
    public List<Map<String, Object>> getAllAppointments(int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page and pageSize must be positive");
        }
        return appointmentDAO.getAllAppointments(page, pageSize);
    }
}