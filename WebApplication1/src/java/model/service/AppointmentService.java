package model.service;

import model.entity.Users;
import model.entity.Rooms;
import model.entity.Services;
import model.entity.ScheduleEmployee;
import model.dao.AppointmentDAO;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Service class for managing appointment-related operations.
 * This class acts as an intermediary between the controller and the AppointmentDAO,
 * providing business logic and input validation.
 */
public class AppointmentService {

    private final AppointmentDAO appointmentDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
    }

    /**
     * Searches for doctors by name and specialty with pagination.
     *
     * @param nameKeyword     The keyword to search for in the doctor's name (can be null or empty).
     * @param specialtyKeyword The keyword to search for in the doctor's specialization (can be null or empty).
     * @param page            The page number (must be positive).
     * @param pageSize        The number of records per page (must be positive).
     * @return A list of Users matching the search criteria.
     * @throws IllegalArgumentException if page or pageSize is invalid.
     * @throws SQLException if a database error occurs.
     */
    public List<Users> searchDoctorsByNameAndSpecialty(String nameKeyword, String specialtyKeyword, int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page and pageSize must be positive");
        }
        // Trim and null-check keywords
        String trimmedNameKeyword = nameKeyword != null ? nameKeyword.trim() : null;
        String trimmedSpecialtyKeyword = specialtyKeyword != null ? specialtyKeyword.trim() : null;
        return appointmentDAO.searchDoctorsByNameAndSpecialty(trimmedNameKeyword, trimmedSpecialtyKeyword, page, pageSize);
    }

    /**
     * Retrieves the total number of doctors matching the search criteria.
     *
     * @param nameKeyword     The keyword to search for in the doctor's name (can be null or empty).
     * @param specialtyKeyword The keyword to search for in the doctor's specialization (can be null or empty).
     * @return The total number of matching doctor records.
     * @throws SQLException if a database error occurs.
     */
    public int getTotalDoctorRecords(String nameKeyword, String specialtyKeyword) throws SQLException {
        String trimmedNameKeyword = nameKeyword != null ? nameKeyword.trim() : null;
        String trimmedSpecialtyKeyword = specialtyKeyword != null ? specialtyKeyword.trim() : null;
        return appointmentDAO.getTotalDoctorRecords(trimmedNameKeyword, trimmedSpecialtyKeyword);
    }

    /**
     * Retrieves detailed information about a doctor, including their room, services, and schedule.
     *
     * @param doctorId The ID of the doctor.
     * @return A map containing the doctor's room, services, and schedule.
     * @throws IllegalArgumentException if doctorId is invalid.
     * @throws SQLException if a database error occurs.
     */
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

    /**
     * Retrieves detailed booking information for a doctor, including their name, specialization, room, services, and schedule.
     *
     * @param doctorId The ID of the doctor.
     * @return A map containing detailed booking information.
     * @throws IllegalArgumentException if doctorId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("Invalid doctor ID: " + doctorId);
        }
        return appointmentDAO.viewDetailBook(doctorId);
    }

    /**
     * Retrieves room details by room ID.
     *
     * @param roomId The ID of the room.
     * @return The Rooms object containing room details, or null if not found.
     * @throws IllegalArgumentException if roomId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public Rooms getRoomByID(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID: " + roomId);
        }
        return appointmentDAO.getRoomByID(roomId);
    }

    /**
     * Retrieves a list of active services associated with a room.
     *
     * @param roomId The ID of the room.
     * @return A list of Services associated with the room.
     * @throws IllegalArgumentException if roomId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public List<Services> getServicesByRoom(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID: " + roomId);
        }
        return appointmentDAO.getServicesByRoom(roomId);
    }

    /**
     * Retrieves a list of patient names associated with appointments in a room.
     *
     * @param roomId The ID of the room.
     * @return A list of patient names, or a list containing "Không có bệnh nhân" if none exist.
     * @throws IllegalArgumentException if roomId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID: " + roomId);
        }
        return appointmentDAO.getPatientsByRoomId(roomId);
    }

    /**
     * Retrieves schedules for a user based on their role and ID.
     *
     * @param role   The role of the user (e.g., "Doctor", "Nurse", "admin").
     * @param userId The ID of the user.
     * @return A list of ScheduleEmployee objects.
     * @throws IllegalArgumentException if userId is invalid or role is null/empty.
     * @throws SQLException if a database error occurs.
     */
    public List<ScheduleEmployee> getSchedulesByRoleAndUserId(String role, int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID: " + userId);
        }
        if (role == null || role.trim().isEmpty()) {
            throw new IllegalArgumentException("Role cannot be null or empty");
        }
        return appointmentDAO.getSchedulesByRoleAndUserId(role.trim(), userId);
    }

    /**
     * Retrieves the full name of a user by their ID.
     *
     * @param userId The ID of the user.
     * @return The full name of the user, or null if not found.
     * @throws IllegalArgumentException if userId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public String getUserFullNameById(int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID: " + userId);
        }
        return appointmentDAO.getUserFullNameById(userId);
    }

    /**
     * Creates a new appointment.
     *
     * @param patientId      The ID of the patient.
     * @param doctorId       The ID of the doctor.
     * @param serviceId      The ID of the service.
     * @param scheduleId     The ID of the schedule slot.
     * @param roomId         The ID of the room.
     * @param appointmentTime The timestamp of the appointment.
     * @return true if the appointment was created successfully, false otherwise.
     * @throws IllegalArgumentException if any input parameter is invalid.
     * @throws SQLException if a database error occurs.
     */
    public boolean createAppointment(int patientId, int doctorId, int serviceId, int scheduleId, int roomId, Timestamp appointmentTime) throws SQLException {
        if (patientId <= 0 || doctorId <= 0 || serviceId <= 0 || scheduleId <= 0 || roomId <= 0) {
            throw new IllegalArgumentException("Invalid input: All IDs must be positive");
        }
        if (appointmentTime == null) {
            throw new IllegalArgumentException("Appointment time cannot be null");
        }
        // Additional business logic: Validate that the doctor and service are associated with the room
        Rooms room = appointmentDAO.getRoomByID(roomId);
        if (room == null || !Objects.equals(room.getDoctorID(), doctorId)) {
            throw new IllegalArgumentException("Doctor ID " + doctorId + " is not assigned to room ID " + roomId);
        }
        List<Services> services = appointmentDAO.getServicesByRoom(roomId);
        boolean serviceValid = services.stream().anyMatch(s -> s.getServiceID() == serviceId);
        if (!serviceValid) {
            throw new IllegalArgumentException("Service ID " + serviceId + " is not available in room ID " + roomId);
        }
        return appointmentDAO.createAppointment(patientId, doctorId, serviceId, scheduleId, roomId, appointmentTime);
    }

    /**
     * Checks if an appointment exists by its ID.
     *
     * @param appointmentId The ID of the appointment.
     * @return true if the appointment exists, false otherwise.
     * @throws IllegalArgumentException if appointmentId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public boolean appointmentExists(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.appointmentExists(appointmentId);
    }

    /**
     * Retrieves appointment details by appointment ID.
     *
     * @param appointmentId The ID of the appointment.
     * @return A map containing appointment details, or null if not found.
     * @throws IllegalArgumentException if appointmentId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public Map<String, Object> getAppointmentById(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.getAppointmentById(appointmentId);
    }

    /**
     * Cancels an appointment (soft delete by updating status to 'Cancelled').
     *
     * @param appointmentId The ID of the appointment to cancel.
     * @return true if the appointment was cancelled successfully, false otherwise.
     * @throws IllegalArgumentException if appointmentId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public boolean cancelAppointment(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.cancelAppointment(appointmentId);
    }

    /**
     * Permanently deletes an appointment (hard delete).
     *
     * @param appointmentId The ID of the appointment to delete.
     * @return true if the appointment was deleted successfully, false otherwise.
     * @throws IllegalArgumentException if appointmentId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public boolean deleteAppointmentPermanently(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Invalid appointment ID: " + appointmentId);
        }
        return appointmentDAO.deleteAppointmentPermanently(appointmentId);
    }

    /**
     * Cancels multiple appointments (soft delete).
     *
     * @param appointmentIds The list of appointment IDs to cancel.
     * @return The number of appointments successfully cancelled.
     * @throws IllegalArgumentException if appointmentIds is null or empty, or contains invalid IDs.
     * @throws SQLException if a database error occurs.
     */
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

    /**
     * Retrieves a list of appointments for a patient.
     *
     * @param patientId The ID of the patient.
     * @return A list of maps containing appointment details.
     * @throws IllegalArgumentException if patientId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public List<Map<String, Object>> getAppointmentsByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            throw new IllegalArgumentException("Invalid patient ID: " + patientId);
        }
        return appointmentDAO.getAppointmentsByPatientId(patientId);
    }

    /**
     * Retrieves a list of appointments for a doctor.
     *
     * @param doctorId The ID of the doctor.
     * @return A list of maps containing appointment details.
     * @throws IllegalArgumentException if doctorId is invalid.
     * @throws SQLException if a database error occurs.
     */
    public List<Map<String, Object>> getAppointmentsByDoctorId(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("Invalid doctor ID: " + doctorId);
        }
        return appointmentDAO.getAppointmentsByDoctorId(doctorId);
    }
}