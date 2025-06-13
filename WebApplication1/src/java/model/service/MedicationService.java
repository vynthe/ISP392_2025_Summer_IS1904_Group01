package model.service;

import model.dao.MedicationDAO;
import model.entity.Medication;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class MedicationService {
    private final MedicationDAO medicationDAO;

    public MedicationService() {
        this.medicationDAO = new MedicationDAO();
    }

    /**
     * Tự động thêm thuốc từ dữ liệu API (cần truyền connection từ ngoài)
     */
    public boolean autoAddMedication(Connection conn, Medication medication) {
        try {
            // Tự động tạo tên thuốc nếu thiếu
            medication.autoSetMedicationName();

            // Parse liều lượng nếu đến từ API
            medication.parseDosageFromApi(medication.getDefaultDosage());

            // Kiểm tra tên thuốc hợp lệ
            if (medication.getMedicationName() == null || medication.getMedicationName().trim().isEmpty()) {
                return false;
            }

            // Kiểm tra trùng tên thuốc
            if (medicationDAO.existsByMedicationName(conn, medication.getMedicationName())) {
                return false; // Đã tồn tại, không thêm lại
            }

            return medicationDAO.addMedication(conn, medication);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy danh sách tất cả thuốc trong hệ thống (cần truyền connection từ ngoài)
     */
    public List<Medication> getAllMedications(Connection conn) {
        try {
            return medicationDAO.getAllMedications(conn);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
