
package model.dao;

import model.entity.Medication;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class MedicationDAO {

    private final DBContext dbContext;

    public MedicationDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Add a new medication to the database
    public boolean addMedication(Medication medication) throws SQLException {
        if (medication == null) {
            throw new SQLException("Medication object cannot be null.");
        }

        String sql = "INSERT INTO Medications (name, dosage, manufacturer, description, production_date, " +
                     "expiration_date, price, quantity, status, dosage_form) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
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
            System.err.println("SQLException in addMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // View all medications
    public List<Medication> getAllMedications() throws SQLException {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications WHERE status = 'Active'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Medication medication = mapResultSetToMedication(rs);
                medications.add(medication);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllMedications: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return medications;
    }

    // View a specific medication by ID
    public Medication getMedicationById(int medicationId) throws SQLException {
        String sql = "SELECT * FROM Medications WHERE MedicationID = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, medicationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMedication(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getMedicationById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    // Retrieve paginated list of medications
    public List<Medication> getMedicationsPaginated(int page, int pageSize) throws SQLException {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications WHERE status = 'Active' " +
                     "ORDER BY MedicationID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int offset = (page - 1) * pageSize;
            pstmt.setInt(1, offset);
            pstmt.setInt(2, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Medication medication = mapResultSetToMedication(rs);
                    medications.add(medication);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getMedicationsPaginated: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return medications;
    }

    // Count total number of active medications
    public int getTotalMedicationCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Medications WHERE status = 'Active'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalMedicationCount: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return 0;
    }

    // Helper method to map ResultSet to Medication object
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
}