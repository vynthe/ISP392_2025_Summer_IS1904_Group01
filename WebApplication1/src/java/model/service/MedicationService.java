
package model.service;

import model.dao.MedicationDAO;
import model.entity.Medication;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class MedicationService {

    private final MedicationDAO medicationDAO;

    public MedicationService() {
        this.medicationDAO = new MedicationDAO();
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

        // Validate business rules
        try {
            medication.validateDates(); // Ensure expiration_date > production_date
        } catch (IllegalArgumentException e) {
            System.err.println("Validation error in addMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }

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
}