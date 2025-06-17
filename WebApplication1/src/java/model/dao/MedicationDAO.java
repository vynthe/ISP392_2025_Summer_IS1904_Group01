package model.dao;

import model.entity.Medication;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

public class MedicationDAO {
    private final DBContext dbContext;

    public MedicationDAO() {
        this.dbContext = DBContext.getInstance();
    }

    private boolean isValidMedicationName(String medicationName) {
        return medicationName != null && !medicationName.trim().isEmpty();
    }

    private boolean isValidSellingPrice(java.math.BigDecimal sellingPrice) {
        return sellingPrice != null && sellingPrice.compareTo(java.math.BigDecimal.ZERO) >= 0;
    }

    private boolean isValidStatus(String status) {
        if (status == null) return false;
        return "Available".equals(status) || "Out of Stock".equals(status) || "Discontinued".equals(status);
    }

    public void addMedication(Medication medication) throws SQLException {
        if (medication == null) throw new SQLException("Medication object cannot be null.");
        if (!isValidMedicationName(medication.getMedicationName())) {
            throw new SQLException("Invalid medication name.");
        }
        if (!isValidSellingPrice(medication.getSellingPrice())) {
            throw new SQLException("Invalid selling price.");
        }
        if (!isValidStatus(medication.getStatus())) {
            throw new SQLException("Invalid status.");
        }

        String sql = "INSERT INTO Medications (MedicationName, GenericName, BrandName, Description, Dosage, SellingPrice, Status, CreatedAt, UpdatedAt, CreatedBy, Manufacturer, Ndc, DosageForm, ManufacturingDate, ExpiryDate, Quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, medication.getMedicationName());
            stmt.setString(2, medication.getGenericName());
            stmt.setString(3, medication.getBrandName());
            stmt.setString(4, medication.getDescription());
            stmt.setString(5, medication.getDosage());
            stmt.setBigDecimal(6, medication.getSellingPrice());
            stmt.setString(7, medication.getStatus());
            stmt.setTimestamp(8, Timestamp.valueOf(medication.getCreatedAt()));
            stmt.setTimestamp(9, Timestamp.valueOf(medication.getUpdatedAt()));
            stmt.setObject(10, medication.getCreatedBy());
            stmt.setString(11, medication.getManufacturer());
            stmt.setString(12, medication.getNdc());
            stmt.setString(13, medication.getDosageForm());
            stmt.setObject(14, medication.getManufacturingDate());
            stmt.setObject(15, medication.getExpiryDate());
            stmt.setObject(16, medication.getQuantity());
            stmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error adding medication: " + e.getMessage());
            throw e;
        }
    }

public Medication getMedicationById(int id) throws SQLException {
    String sql = "SELECT * FROM Medications WHERE MedicationID = ?";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, id);

        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Medication medication = new Medication();
                medication.setMedicationID(rs.getInt("MedicationID"));
                medication.setMedicationName(rs.getString("MedicationName"));
                medication.setGenericName(rs.getString("GenericName"));
                medication.setBrandName(rs.getString("BrandName"));
                medication.setDescription(rs.getString("Description"));
                medication.setDosage(rs.getString("Dosage"));
                medication.setSellingPrice(rs.getBigDecimal("SellingPrice"));
                medication.setStatus(rs.getString("Status"));

                // Optional: kiểm tra null để tránh lỗi
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
                medication.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
                medication.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);

                medication.setCreatedBy(rs.getInt("CreatedBy"));

                medication.setManufacturer(rs.getString("Manufacturer"));
                medication.setNdc(rs.getString("Ndc"));
                medication.setDosageForm(rs.getString("DosageForm"));

                Date manuDate = rs.getDate("ManufacturingDate");
                Date expDate = rs.getDate("ExpiryDate");

                medication.setManufacturingDate(manuDate != null ? manuDate.toLocalDate() : null);
                medication.setExpiryDate(expDate != null ? expDate.toLocalDate() : null);

                medication.setQuantity(rs.getInt("Quantity"));

                return medication;
            }
        }
    } catch (SQLException e) {
        System.err.println("Error retrieving medication by ID: " + e.getMessage());
        throw e;
    }
    return null;
}

    public List<Medication> getAllMedications() throws SQLException {
        List<Medication> medications = new ArrayList<>();
        String sql = "SELECT * FROM Medications";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Medication medication = new Medication();
                medication.setMedicationID(rs.getInt("MedicationID"));
                medication.setMedicationName(rs.getString("MedicationName"));
                medication.setGenericName(rs.getString("GenericName"));
                medication.setBrandName(rs.getString("BrandName"));
                medication.setDescription(rs.getString("Description"));
                medication.setDosage(rs.getString("Dosage"));
                medication.setSellingPrice(rs.getBigDecimal("SellingPrice"));
                medication.setStatus(rs.getString("Status"));
                medication.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                medication.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
                medication.setCreatedBy(rs.getInt("CreatedBy"));
                medication.setManufacturer(rs.getString("Manufacturer"));
                medication.setNdc(rs.getString("Ndc"));
                medication.setDosageForm(rs.getString("DosageForm"));
                medication.setManufacturingDate(rs.getDate("ManufacturingDate") != null ? rs.getDate("ManufacturingDate").toLocalDate() : null);
                medication.setExpiryDate(rs.getDate("ExpiryDate") != null ? rs.getDate("ExpiryDate").toLocalDate() : null);
                medication.setQuantity(rs.getInt("Quantity"));
                medications.add(medication);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all medications: " + e.getMessage());
            throw e;
        }
        return medications;
    }

    public boolean updateMedication(Medication medication) throws SQLException {
        if (medication == null) throw new SQLException("Medication object cannot be null.");
        if (!isValidMedicationName(medication.getMedicationName())) {
            throw new SQLException("Invalid medication name.");
        }
        if (!isValidSellingPrice(medication.getSellingPrice())) {
            throw new SQLException("Invalid selling price.");
        }
        if (!isValidStatus(medication.getStatus())) {
            throw new SQLException("Invalid status.");
        }

        String query = "UPDATE Medications SET MedicationName = ?, GenericName = ?, BrandName = ?, Description = ?, Dosage = ?, SellingPrice = ?, Status = ?, UpdatedAt = ?, CreatedBy = ?, Manufacturer = ?, Ndc = ?, DosageForm = ?, ManufacturingDate = ?, ExpiryDate = ?, Quantity = ? WHERE MedicationID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, medication.getMedicationName());
            stmt.setString(2, medication.getGenericName());
            stmt.setString(3, medication.getBrandName());
            stmt.setString(4, medication.getDescription());
            stmt.setString(5, medication.getDosage());
            stmt.setBigDecimal(6, medication.getSellingPrice());
            stmt.setString(7, medication.getStatus());
            stmt.setTimestamp(8, Timestamp.valueOf(medication.getUpdatedAt()));
            stmt.setObject(9, medication.getCreatedBy());
            stmt.setString(10, medication.getManufacturer());
            stmt.setString(11, medication.getNdc());
            stmt.setString(12, medication.getDosageForm());
            stmt.setObject(13, medication.getManufacturingDate());
            stmt.setObject(14, medication.getExpiryDate());
            stmt.setObject(15, medication.getQuantity());
            stmt.setInt(16, medication.getMedicationID());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating medication: " + e.getMessage());
            throw e;
        }
    }

    public boolean deleteMedication(int medicationID) throws SQLException {
        String query = "DELETE FROM Medications WHERE MedicationID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, medicationID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                System.err.println("Medication with ID " + medicationID + " not found for deletion.");
                return false;
            }
            return true;
        } catch (SQLException e) {
            System.err.println("Error deleting medication: " + e.getMessage());
            throw e;
        }
    }

    public boolean isMedicationExists(String medicationName) throws SQLException {
        if (!isValidMedicationName(medicationName)) {
            return false;
        }
        String sql = "SELECT COUNT(*) FROM Medications WHERE MedicationName = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, medicationName);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking medication existence: " + e.getMessage());
            throw e;
        }
        return false;
    }
}