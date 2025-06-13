package model.dao;

import model.entity.Medication;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MedicationDAO {
    private static final Logger logger = Logger.getLogger(MedicationDAO.class.getName());

    /**
     * Thêm thuốc mới vào cơ sở dữ liệu
     */
    public boolean addMedication(Connection conn, Medication medication) {
        String sql = "INSERT INTO Medications ("
                + "MedicationName, GenericName, BrandName, Description, "
                + "DefaultDosage, DefaultDosageUnit, DefaultDosagePerDay, DefaultDurationDays, "
                + "SellingPrice, Status, CreatedAt, UpdatedAt, CreatedBy"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, medication.getMedicationName());
            stmt.setString(2, medication.getGenericName());
            stmt.setString(3, medication.getBrandName());
            stmt.setString(4, medication.getDescription());
            stmt.setString(5, medication.getDefaultDosage());
            stmt.setString(6, medication.getDefaultDosageUnit());
            stmt.setObject(7, medication.getDefaultDosagePerDay(), Types.INTEGER);
            stmt.setObject(8, medication.getDefaultDurationDays(), Types.INTEGER);
            stmt.setBigDecimal(9, medication.getSellingPrice());
            stmt.setString(10, medication.getStatus());
            stmt.setTimestamp(11, Timestamp.valueOf(medication.getCreatedAt()));
            stmt.setTimestamp(12, Timestamp.valueOf(medication.getUpdatedAt()));
            stmt.setObject(13, medication.getCreatedBy(), Types.INTEGER);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi khi thêm thuốc: " + medication.getMedicationName(), e);
            return false;
        }
    }

    /**
     * Kiểm tra xem thuốc đã tồn tại theo MedicationName chưa
     */
    public boolean existsByMedicationName(Connection conn, String medicationName) {
        String sql = "SELECT 1 FROM Medications WHERE MedicationName = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, medicationName);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // Nếu có kết quả -> đã tồn tại
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi kiểm tra tồn tại thuốc: " + medicationName, e);
            return false;
        }
    }

    /**
     * Lấy tất cả thuốc trong bảng Medications
     */
    public List<Medication> getAllMedications(Connection conn) {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications";

        try (PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Medication medication = new Medication();
                medication.setMedicationID(rs.getInt("MedicationID"));
                medication.setMedicationName(rs.getString("MedicationName"));
                medication.setGenericName(rs.getString("GenericName"));
                medication.setBrandName(rs.getString("BrandName"));
                medication.setDescription(rs.getString("Description"));
                medication.setDefaultDosage(rs.getString("DefaultDosage"));
                medication.setDefaultDosageUnit(rs.getString("DefaultDosageUnit"));
                medication.setDefaultDosagePerDay(rs.getObject("DefaultDosagePerDay", Integer.class));
                medication.setDefaultDurationDays(rs.getObject("DefaultDurationDays", Integer.class));
                medication.setSellingPrice(rs.getBigDecimal("SellingPrice"));
                medication.setStatus(rs.getString("Status"));

                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                medication.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                medication.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
                medication.setCreatedBy(rs.getObject("CreatedBy", Integer.class));

                medications.add(medication);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Lỗi lấy danh sách thuốc", e);
        }

        return medications;
    }
}
