package model.service;

import model.dao.ExaminationResultsDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Service class to handle business logic related to examination results and appointments.
 */
public class ExaminationResultsService {

    private final ExaminationResultsDAO examinationResultsDAO;

    public ExaminationResultsService() {
        this.examinationResultsDAO = new ExaminationResultsDAO();
    }

    /**
     * Lấy danh sách lịch hẹn của bác sĩ theo DoctorID, bao gồm thông tin bệnh nhân.
     * @param doctorId ID của bác sĩ
     * @param page Trang hiện tại (dùng cho phân trang)
     * @param pageSize Số bản ghi trên mỗi trang
     * @return Danh sách các lịch hẹn với thông tin chi tiết
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public boolean addExaminationResultFromAppointment(int appointmentId, Integer nurseId, String status) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Appointment ID must be positive");
        }
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status is required");
        }
        return examinationResultsDAO.addExaminationResultFromAppointment(appointmentId, nurseId, status);
    }

    // Các phương thức khác (getAppointmentsWithPatientByDoctorId, getTotalAppointmentsByDoctorId) giữ nguyên

    public List<Map<String, Object>> getAppointmentsWithPatientByDoctorId(int doctorId, int page, int pageSize) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("Doctor ID must be positive");
        }
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Page and pageSize must be positive");
        }

        try {
            return examinationResultsDAO.getAppointmentsWithPatientByDoctorId(doctorId, page, pageSize);
        } catch (SQLException e) {
            // Log lỗi hoặc xử lý tùy theo yêu cầu
            System.err.println("Error in ExaminationResultsService.getAppointmentsWithPatientByDoctorId: " + e.getMessage());
            throw e;
        }
    }

    // Thêm phương thức mới để lấy tổng số lịch hẹn
    public int getTotalAppointmentsByDoctorId(int doctorId) throws SQLException {
        return examinationResultsDAO.getTotalAppointmentsByDoctorId(doctorId);
    }

    public boolean addExaminationResultFromAppointment(int appointmentId, Integer nurseId, String status, String diagnosis, String notes) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Appointment ID must be positive");
        }
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status is required");
        }
        return examinationResultsDAO.addExaminationResultFromAppointment(appointmentId, nurseId, status, diagnosis, notes);
    }

    public Map<String, Object> getExaminationResultById(int resultId) throws SQLException {
        if (resultId <= 0) {
            throw new IllegalArgumentException("Result ID must be positive");
        }
        return examinationResultsDAO.getExaminationResultById(resultId);
    }

    /**
     * Lấy ResultID từ AppointmentID.
     * @param appointmentId ID của lịch hẹn
     * @return ResultID nếu tìm thấy, null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public Integer getResultIdByAppointmentId(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Appointment ID must be positive");
        }
        return examinationResultsDAO.getResultIdByAppointmentId(appointmentId);
    }

   // In ExaminationResultsService.java - Replace the existing updateExaminationResult method with this:

public boolean updateExaminationResult(int resultId, String diagnosis, String notes) throws SQLException {
    if (resultId <= 0) {
        throw new IllegalArgumentException("Result ID must be positive");
    }
    // Remove status validation since we're not updating status anymore
    return examinationResultsDAO.updateExaminationResult(resultId, diagnosis, notes);
}

    /**
     * Lấy chi tiết chẩn đoán theo AppointmentID.
     * @param appointmentId ID của lịch hẹn
     * @return Map chứa thông tin chi tiết chẩn đoán
     * @throws SQLException Nếu có lỗi khi truy vấn cơ sở dữ liệu
     */
    public Map<String, Object> getDiagnosisDetailsByAppointmentId(int appointmentId) throws SQLException {
        if (appointmentId <= 0) {
            throw new IllegalArgumentException("Appointment ID must be positive");
        }
        
        try {
            return examinationResultsDAO.getDiagnosisDetailsByAppointmentId(appointmentId);
        } catch (SQLException e) {
            System.err.println("Error in ExaminationResultsService.getDiagnosisDetailsByAppointmentId: " + e.getMessage());
            throw e;
        }
    }
    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId, int page, int pageSize) throws SQLException {
    if (patientId <= 0) {
        throw new IllegalArgumentException("Patient ID must be positive");
    }
    if (page < 1 || pageSize < 1) {
        throw new IllegalArgumentException("Page and pageSize must be positive");
    }

    try {
        return examinationResultsDAO.getExaminationResultsByPatientId(patientId, page, pageSize);
    } catch (SQLException e) {
        System.err.println("Error in ExaminationResultsService.getExaminationResultsByPatientId: " + e.getMessage());
        throw e;
    }
}
public int getTotalExaminationResultsByPatientId(int patientId) throws SQLException {
    if (patientId <= 0) {
        throw new IllegalArgumentException("Patient ID must be positive");
    }
    return examinationResultsDAO.getTotalExaminationResultsByPatientId(patientId);
}
public Map<String, Object> getExaminationResultDetailForPatient(int resultId, int patientId) throws SQLException {
    if (resultId <= 0) {
        throw new IllegalArgumentException("Result ID must be positive");
    }
    if (patientId <= 0) {
        throw new IllegalArgumentException("Patient ID must be positive");
    }

    try {
        return examinationResultsDAO.getExaminationResultDetailForPatient(resultId, patientId);
    } catch (SQLException e) {
        System.err.println("Error in ExaminationResultsService.getExaminationResultDetailForPatient: " + e.getMessage());
        throw e;
    }
}
}