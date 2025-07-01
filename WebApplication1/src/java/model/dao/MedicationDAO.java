package model.dao;

import model.entity.Medication;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MedicationDAO {

    private final DBContext dbContext;

    public MedicationDAO() {
        this.dbContext = DBContext.getInstance();
    }

    public boolean addMedication(Medication medication) throws SQLException {
        if (medication == null) {
            throw new SQLException("Medication object cannot be null.");
        }

        String sql = "INSERT INTO Medications (name, dosage, manufacturer, description, production_date, "
                + "expiration_date, price, quantity, status, dosage_form) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, medication.getName());
            pstmt.setString(2, medication.getDosage());
            pstmt.setString(3, medication.getManufacturer());
            pstmt.setString(4, medication.getDescription());
            pstmt.setDate(5, medication.getProductionDate() != null ? java.sql.Date.valueOf(medication.getProductionDate()) : null);
            pstmt.setDate(6, medication.getExpirationDate() != null ? java.sql.Date.valueOf(medication.getExpirationDate()) : null);
            pstmt.setDouble(7, medication.getPrice());
            pstmt.setInt(8, medication.getQuantity());
            pstmt.setString(9, medication.getStatus());
            pstmt.setString(10, medication.getDosageForm());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        medication.setMedicationID(generatedKeys.getInt(1));
                    }
                }
            }
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in addMedication: " + e.getMessage());
            throw e;
        }
    }

    public List<Medication> getAllMedications() throws SQLException {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications WHERE status = 'Active'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                medications.add(mapResultSetToMedication(rs));
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllMedications: " + e.getMessage());
            throw e;
        }
        return medications;
    }

    public Medication getMedicationById(int medicationId) throws SQLException {
        String sql = "SELECT * FROM Medications WHERE MedicationID = ? AND status = 'Active'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, medicationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMedication(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getMedicationById: " + e.getMessage());
            throw e;
        }
        return null;
    }

    public List<Medication> getMedicationsPaginated(int page, int pageSize) throws SQLException {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications WHERE status = 'Active' "
                   + "ORDER BY MedicationID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    medications.add(mapResultSetToMedication(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getMedicationsPaginated: " + e.getMessage());
            throw e;
        }
        return medications;
    }

    public int getTotalMedicationCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Medications WHERE status = 'Active'";

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalMedicationCount: " + e.getMessage());
            throw e;
        }
        return 0;
    }

    public boolean updateMedicationForImport(Medication medication) throws SQLException {
        if (medication == null || medication.getMedicationID() <= 0) {
            throw new SQLException("Medication object or ID cannot be null or invalid.");
        }

        String sql = "UPDATE Medications SET production_date = ?, expiration_date = ?, price = ?, quantity = ? "
                   + "WHERE MedicationID = ? AND status = 'Active'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, medication.getProductionDate() != null ? java.sql.Date.valueOf(medication.getProductionDate()) : null);
            pstmt.setDate(2, medication.getExpirationDate() != null ? java.sql.Date.valueOf(medication.getExpirationDate()) : null);
            pstmt.setDouble(3, medication.getPrice());
            pstmt.setInt(4, medication.getQuantity());
            pstmt.setInt(5, medication.getMedicationID());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in updateMedicationForImport: " + e.getMessage());
            throw e;
        }
    }

   
    public List<Medication> searchMedications(String keyword) throws SQLException {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications WHERE "
                   + "(name LIKE ? OR manufacturer LIKE ? OR dosage_form LIKE ? OR dosage LIKE ?) AND status = 'Active'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            String pattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            stmt.setString(4, pattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    medications.add(mapResultSetToMedication(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in searchMedications: " + e.getMessage());
            throw e;
        }
        return medications;
    }

    // ✅ SEARCH + PAGINATION 
    public List<Medication> searchMedicationsPaginated(String keyword, int page, int pageSize) throws SQLException {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications WHERE "
                   + "(name LIKE ? OR manufacturer LIKE ? OR dosage_form LIKE ? OR dosage LIKE ?) AND status = 'Active' "
                   + "ORDER BY MedicationID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            String pattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            stmt.setString(4, pattern);
            stmt.setInt(5, (page - 1) * pageSize);
            stmt.setInt(6, pageSize);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    medications.add(mapResultSetToMedication(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in searchMedicationsPaginated: " + e.getMessage());
            throw e;
        }
        return medications;
    }

    // ✅ COUNT kết quả tìm kiếm 
    public int getTotalSearchMedicationCount(String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Medications WHERE "
                   + "(name LIKE ? OR manufacturer LIKE ? OR dosage_form LIKE ? OR dosage LIKE ?) AND status = 'Active'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            String pattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            stmt.setString(4, pattern);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalSearchMedicationCount: " + e.getMessage());
            throw e;
        }
        return 0;
    }

    // MAP ResultSet to Medication object
    private Medication mapResultSetToMedication(ResultSet rs) throws SQLException {
        Medication medication = new Medication();
        medication.setMedicationID(rs.getInt("MedicationID"));
        medication.setName(rs.getString("name"));
        medication.setDosage(rs.getString("dosage"));
        medication.setManufacturer(rs.getString("manufacturer"));
        medication.setDescription(rs.getString("description"));
        medication.setProductionDate(rs.getDate("production_date") != null ? rs.getDate("production_date").toLocalDate() : null);
        medication.setExpirationDate(rs.getDate("expiration_date") != null ? rs.getDate("expiration_date").toLocalDate() : null);
        medication.setPrice(rs.getDouble("price"));
        medication.setQuantity(rs.getInt("quantity"));
        medication.setStatus(rs.getString("status"));
        medication.setDosageForm(rs.getString("dosage_form"));
        return medication;
    }
    
    // Tìm kiếm theo tên và dạng bào chế có phân trang
public List<Medication> searchMedicationsByNameAndDosageForm(String nameKeyword, String dosageFormKeyword, int page, int pageSize) throws SQLException {
    List<Medication> medications = new ArrayList<>();
    String sql = "SELECT * FROM Medications WHERE status = 'Active' "
               + "AND name LIKE ? AND dosage_form LIKE ? "
               + "ORDER BY MedicationID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        
        String namePattern = "%" + (nameKeyword == null ? "" : nameKeyword.trim()) + "%";
        String dosagePattern = "%" + (dosageFormKeyword == null ? "" : dosageFormKeyword.trim()) + "%";

        stmt.setString(1, namePattern);
        stmt.setString(2, dosagePattern);
        stmt.setInt(3, (page - 1) * pageSize);
        stmt.setInt(4, pageSize);

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                medications.add(mapResultSetToMedication(rs));
            }
        }
    } catch (SQLException e) {
        System.err.println("SQLException in searchMedicationsByNameAndDosageForm: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
        throw e;
    }

    return medications;
}

// Đếm tổng số thuốc theo tên và dạng bào chế
public int getTotalCountByNameAndDosageForm(String nameKeyword, String dosageFormKeyword) throws SQLException {
    String sql = "SELECT COUNT(*) FROM Medications WHERE status = 'Active' "
               + "AND name LIKE ? AND dosage_form LIKE ?";

    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        String namePattern = "%" + (nameKeyword == null ? "" : nameKeyword.trim()) + "%";
        String dosagePattern = "%" + (dosageFormKeyword == null ? "" : dosageFormKeyword.trim()) + "%";

        stmt.setString(1, namePattern);
        stmt.setString(2, dosagePattern);

        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        System.err.println("SQLException in getTotalCountByNameAndDosageForm: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
        throw e;
    }

    return 0;
}

}
