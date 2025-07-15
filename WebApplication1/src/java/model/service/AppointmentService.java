package model.service;

import model.entity.Users;
import model.entity.Rooms;
import model.entity.Schedules;
import model.entity.Services;
import model.dao.AppointmentDAO;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AppointmentService {

    private final AppointmentDAO appointmentDAO;

    public AppointmentService() {
        this.appointmentDAO = new AppointmentDAO();
    }

    // Tìm kiếm bác sĩ theo tên và chuyên môn
    public List<Users> searchDoctorsByNameAndSpecialty(String nameKeyword, String specialtyKeyword, int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page and pageSize must be positive");
        }
        return appointmentDAO.searchDoctorsByNameAndSpecialty(nameKeyword, specialtyKeyword, page, pageSize);
    }

    // Lấy tổng số bác sĩ
    public int getTotalDoctorRecords(String nameKeyword, String specialtyKeyword) throws SQLException {
        return appointmentDAO.getTotalDoctorRecords(nameKeyword, specialtyKeyword);
    }

    // Lấy thông tin chi tiết bác sĩ
    public Map<String, Object> getDoctorDetails(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("Invalid doctor ID");
        }
        Map<String, Object> details = new HashMap<>();
        details.put("room", appointmentDAO.getRoomByDoctorId(doctorId));
        details.put("services", appointmentDAO.getServicesByDoctorId(doctorId));
        details.put("schedule", appointmentDAO.getSchedulesByDoctorId(doctorId));
        return details;
    }

    // Xem chi tiết lịch hẹn của bác sĩ
    public Map<String, Object> viewDetailBook(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("Invalid doctor ID");
        }
        return appointmentDAO.viewDetailBook(doctorId);
    }

    // Lấy thông tin chi tiết phòng theo RoomID
    public Rooms getRoomByID(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID");
        }
        return appointmentDAO.getRoomByID(roomId);
    }

    // Lấy danh sách dịch vụ theo RoomID
    public List<Services> getServicesByRoom(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID");
        }
        return appointmentDAO.getServicesByRoom(roomId);
    }

    // Lấy danh sách bệnh nhân theo RoomID
    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID");
        }
        return appointmentDAO.getPatientsByRoomId(roomId);
    }

    // Lấy lịch trình theo vai trò và UserID
    public List<Schedules> getSchedulesByRoleAndUserId(String role, int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        if (role == null || role.trim().isEmpty()) {
            throw new IllegalArgumentException("Role cannot be null or empty");
        }
        return appointmentDAO.getSchedulesByRoleAndUserId(role, userId);
    }

    // Lấy tên người dùng theo UserID
    public String getUserFullNameById(int userId) throws SQLException {
        if (userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        return appointmentDAO.getUserFullNameById(userId);
    }
}