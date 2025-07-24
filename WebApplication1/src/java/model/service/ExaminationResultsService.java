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
}