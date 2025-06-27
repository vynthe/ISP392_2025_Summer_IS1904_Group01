package model.service;

import model.dao.MedicationDAO;
import model.entity.Medication;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.List;

public class MedicationService {

    private final MedicationDAO medicationDAO;

    public MedicationService() {
        this.medicationDAO = new MedicationDAO();
    }

    // Validate production and expiration dates
    private void validateDates(LocalDate productionDate, LocalDate expirationDate) throws IllegalArgumentException {
        LocalDate currentDate = LocalDate.now(); // Current date is 2025-06-23 based on context

        // Check if dates are null
        if (productionDate == null || expirationDate == null) {
            throw new IllegalArgumentException("Production date and expiration date cannot be null.");
        }

        // Validate production date not exceeding current date
        if (productionDate.isAfter(currentDate)) {
            throw new IllegalArgumentException("Production date cannot be in the future.");
        }

        // Validate year must be 2025 or later
        if (productionDate.getYear() < 2025 || expirationDate.getYear() < 2025) {
            throw new IllegalArgumentException("Production and expiration dates must be from 2025 onwards.");
        }

        // Validate expiration date is not before production date
        if (expirationDate.isBefore(productionDate)) {
            throw new IllegalArgumentException("Expiration date cannot be before production date.");
        }

        // Validate maximum 3 years difference
        Period period = Period.between(productionDate, expirationDate);
        if (period.getYears() > 3 || (period.getYears() == 3 && (period.getMonths() > 0 || period.getDays() > 0))) {
            throw new IllegalArgumentException("Expiration date cannot exceed 3 years from production date.");
        }
    }

    // Add a new medication with validation
    public boolean addMedication(Medication medication) throws SQLException, IllegalArgumentException {
        if (medication == null) {
            throw new IllegalArgumentException("Medication object cannot be null.");
        }

        // Validate required fields
        if (medication.getName() == null || medication.getName().trim().isEmpty()) {
            throw new IllegalArgumentException("Medication name is required.");
        }
        if (medication.getDosage() == null || medication.getDosage().trim().isEmpty()) {
            throw new IllegalArgumentException("Dosage is required.");
        }
        if (medication.getManufacturer() == null || medication.getManufacturer().trim().isEmpty()) {
            throw new IllegalArgumentException("Manufacturer is required.");
        }
        if (medication.getProductionDate() == null) {
            throw new IllegalArgumentException("Production date is required.");
        }
        if (medication.getExpirationDate() == null) {
            throw new IllegalArgumentException("Expiration date is required.");
        }
        if (medication.getPrice() < 0) {
            throw new IllegalArgumentException("Price must be non-negative.");
        }
        if (medication.getQuantity() < 0) {
            throw new IllegalArgumentException("Quantity must be non-negative.");
        }
        if (medication.getDosageForm() == null || medication.getDosageForm().trim().isEmpty()) {
            throw new IllegalArgumentException("Dosage form is required.");
        }

        // Validate business rules for dates
        validateDates(medication.getProductionDate(), medication.getExpirationDate());

        // Set default values if not provided
        if (medication.getStatus() == null || medication.getStatus().trim().isEmpty()) {
            medication.setStatus("Active");
        }

        // Call DAO to persist the medication
        try {
            return medicationDAO.addMedication(medication);
        } catch (SQLException e) {
            System.err.println("SQLException in addMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Retrieve all medications
    public List<Medication> getAllMedications() throws SQLException {
        try {
            return medicationDAO.getAllMedications();
        } catch (SQLException e) {
            System.err.println("SQLException in getAllMedications: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Retrieve a medication by ID
    public Medication getMedicationById(int medicationId) throws SQLException, IllegalArgumentException {
        if (medicationId <= 0) {
            throw new IllegalArgumentException("Invalid medication ID.");
        }
        try {
            Medication medication = medicationDAO.getMedicationById(medicationId);
            if (medication == null) {
                throw new IllegalArgumentException("Medication not found with ID: " + medicationId);
            }
            return medication;
        } catch (SQLException e) {
            System.err.println("SQLException in getMedicationById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Retrieve paginated medications
    public List<Medication> getMedicationsPaginated(int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Invalid page or pageSize.");
        }
        try {
            return medicationDAO.getMedicationsPaginated(page, pageSize);
        } catch (SQLException e) {
            System.err.println("SQLException in getMedicationsPaginated: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Get total number of active medications
    public int getTotalMedicationCount() throws SQLException {
        try {
            return medicationDAO.getTotalMedicationCount();
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalMedicationCount: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    // Import medication by updating specific fields
    public boolean importMedication(Medication medication) throws SQLException, IllegalArgumentException {
        if (medication == null || medication.getMedicationID() <= 0) {
            throw new IllegalArgumentException("Medication object or ID cannot be null or invalid.");
        }

        // Validate required fields for import
        if (medication.getProductionDate() == null) {
            throw new IllegalArgumentException("Production date is required for import.");
        }
        if (medication.getExpirationDate() == null) {
            throw new IllegalArgumentException("Expiration date is required for import.");
        }
        if (medication.getPrice() < 0) {
            throw new IllegalArgumentException("Price must be non-negative.");
        }
        if (medication.getQuantity() < 0) {
            throw new IllegalArgumentException("Quantity must be non-negative.");
        }

        // Validate business rules for dates
        validateDates(medication.getProductionDate(), medication.getExpirationDate());

        // Verify the medication exists and is active
        Medication existingMedication = getMedicationById(medication.getMedicationID());
        if (existingMedication == null) {
            throw new IllegalArgumentException("Medication with ID " + medication.getMedicationID() + " does not exist or is not active.");
        }

        // Call DAO to update the medication
        try {
            return medicationDAO.updateMedicationForImport(medication);
        } catch (SQLException e) {
            System.err.println("SQLException in importMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }
    public List<Medication> searchMedications(String keyword) throws SQLException {
        return medicationDAO.searchMedications(keyword);
    }
    
    // Search medications with pagination
    public List<Medication> searchMedicationsPaginated(String keyword, int page, int pageSize) throws SQLException {
        if (page < 1 || pageSize < 1) {
            throw new IllegalArgumentException("Invalid page or pageSize.");
        }
        try {
            return medicationDAO.searchMedicationsPaginated(keyword, page, pageSize);
        } catch (SQLException e) {
            System.err.println("SQLException in searchMedicationsPaginated: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }
    
    // Get total number of medications matching the keyword
    public int getTotalSearchMedicationCount(String keyword) throws SQLException {
        try {
            return medicationDAO.getTotalSearchMedicationCount(keyword);
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalSearchMedicationCount: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }
   
    // Tìm kiếm theo tên và dạng bào chế (có phân trang)
public List<Medication> searchMedicationsByNameAndDosageForm(String nameKeyword, String dosageFormKeyword, int page, int pageSize) throws SQLException {
    if (page < 1 || pageSize < 1) {
        throw new IllegalArgumentException("Invalid page or pageSize.");
    }
    return medicationDAO.searchMedicationsByNameAndDosageForm(nameKeyword, dosageFormKeyword, page, pageSize);
}

// Đếm tổng số thuốc theo tên và dạng bào chế
public int getTotalCountByNameAndDosageForm(String nameKeyword, String dosageFormKeyword) throws SQLException {
    return medicationDAO.getTotalCountByNameAndDosageForm(nameKeyword, dosageFormKeyword);
}

}