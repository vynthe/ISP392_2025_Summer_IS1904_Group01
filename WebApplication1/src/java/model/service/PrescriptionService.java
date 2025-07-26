package model.service;

import com.sun.jdi.connect.spi.Connection;
import model.entity.Prescriptions;
import model.entity.Medication;
import model.dao.PrescriptionDAO;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public class PrescriptionService {
    private static final Log log = LogFactory.getLog(PrescriptionService.class);
    private final PrescriptionDAO prescriptionDAO;

    public PrescriptionService() {
        this.prescriptionDAO = new PrescriptionDAO();
    }

    // Constructor for dependency injection (optional)
    public PrescriptionService(PrescriptionDAO prescriptionDAO) {
        this.prescriptionDAO = prescriptionDAO;
    }

    /**
     * Add a new prescription with associated medications and signature
     * The NurseID will be automatically retrieved from ExaminationResults
     * @param prescription The prescription object
     * @param resultId The examination result ID
     * @param appointmentId The appointment ID
     * @param medicationIds List of medication IDs
     * @param signature Doctor's signature
     * @return true if prescription was added successfully
     * @throws SQLException if database operation fails
     * @throws IllegalArgumentException if input parameters are invalid
     */
    public boolean addPrescription(Prescriptions prescription, int resultId, int appointmentId, 
                                 List<Integer> medicationIds, String signature) throws SQLException {
        validatePrescriptionInput(prescription, resultId, appointmentId, medicationIds);
        
        try {
            boolean added = prescriptionDAO.addPrescription(prescription, resultId, appointmentId, medicationIds, signature);
            if (added) {
                String nurseInfo = prescription.getNurseId() != null ? 
                    ", NurseID: " + prescription.getNurseId() : ", NurseID: null";
                log.info("Successfully added prescription with ID: " + prescription.getPrescriptionId() + 
                         ", ResultID: " + resultId + ", AppointmentID: " + appointmentId + 
                         ", MedicationIDs: " + medicationIds + nurseInfo + 
                         " at " + LocalDateTime.now() + " +07");
            } else {
                log.warn("Failed to add prescription for ResultID: " + resultId + 
                         ", AppointmentID: " + appointmentId + " at " + LocalDateTime.now() + " +07");
            }
            return added;
        } catch (SQLException e) {
            log.error("SQLException adding prescription: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw new SQLException("Failed to add prescription: " + e.getMessage(), e);
        }
    }

    /**
     * Add a new prescription without signature (backward compatibility)
     */
    public boolean addPrescription(Prescriptions prescription, int resultId, int appointmentId, 
                                 List<Integer> medicationIds) throws SQLException {
        return addPrescription(prescription, resultId, appointmentId, medicationIds, null);
    }

    /**
     * Get prescription by its ID
     * @param prescriptionId The prescription ID to fetch
     * @return Prescription object or null if not found
     * @throws SQLException if database operation fails
     * @throws IllegalArgumentException if prescriptionId is invalid
     */
    public Prescriptions getPrescriptionById(int prescriptionId) throws SQLException {
        validatePositiveId(prescriptionId, "Prescription ID");

        try {
            Prescriptions prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
            if (prescription == null) {
                log.warn("No prescription found with ID: " + prescriptionId + " at " + LocalDateTime.now() + " +07");
            } else {
                String nurseInfo = prescription.getNurseId() != null ? 
                    ", NurseID: " + prescription.getNurseId() : ", NurseID: null";
                log.info("Retrieved prescription with ID: " + prescriptionId + nurseInfo + 
                        " at " + LocalDateTime.now() + " +07");
            }
            return prescription;
        } catch (SQLException e) {
            log.error("SQLException retrieving prescription by ID " + prescriptionId + ": " + 
                     e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get all prescriptions in the system
     * @return List of all prescriptions
     * @throws SQLException if database operation fails
     */
    public List<Prescriptions> getAllPrescriptions() throws SQLException {
        try {
            List<Prescriptions> prescriptions = prescriptionDAO.getAllPrescriptions();
            long countWithNurse = prescriptions.stream().filter(p -> p.getNurseId() != null).count();
            log.info("Retrieved all " + prescriptions.size() + " prescriptions (" + 
                    countWithNurse + " with nurse involvement) at " + LocalDateTime.now() + " +07");
            return prescriptions;
        } catch (SQLException e) {
            log.error("SQLException retrieving all prescriptions: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get prescriptions with pagination
     * @param page Page number (1-based)
     * @param pageSize Number of prescriptions per page
     * @return List of prescriptions for the specified page
     * @throws SQLException if database operation fails
     * @throws IllegalArgumentException if pagination parameters are invalid
     */
    public List<Prescriptions> getPrescriptionsByPage(int page, int pageSize) throws SQLException {
        validatePaginationParameters(page, pageSize);

        try {
            List<Prescriptions> prescriptions = prescriptionDAO.getPrescriptionsByPage(page, pageSize);
            long countWithNurse = prescriptions.stream().filter(p -> p.getNurseId() != null).count();
            log.info("Retrieved " + prescriptions.size() + " prescriptions for page " + page + 
                    " (pageSize: " + pageSize + ", " + countWithNurse + " with nurse) at " + 
                    LocalDateTime.now() + " +07");
            return prescriptions;
        } catch (SQLException e) {
            log.error("SQLException retrieving prescriptions for page " + page + ": " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get total number of prescriptions in the system
     * @return Total count of prescriptions
     * @throws SQLException if database operation fails
     */
    public int getTotalPrescriptions() throws SQLException {
        try {
            int total = prescriptionDAO.getTotalPrescriptionCount();
            log.info("Retrieved total prescriptions count: " + total + " at " + LocalDateTime.now() + " +07");
            return total;
        } catch (SQLException e) {
            log.error("SQLException retrieving total prescriptions count: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Search prescriptions by patient name and medication keyword with pagination
     * @param patientNameKeyword Patient name keyword (can be null or empty)
     * @param medicationNameKeyword Medication name keyword (can be null or empty)
     * @param page Page number (1-based)
     * @param pageSize Number of prescriptions per page
     * @return List of matching prescriptions
     * @throws SQLException if database operation fails
     * @throws IllegalArgumentException if pagination parameters are invalid
     */
    public List<Prescriptions> searchPrescriptionsByPatientAndMedication(String patientNameKeyword, 
                                                                        String medicationNameKeyword, 
                                                                        int page, int pageSize) throws SQLException {
        validatePaginationParameters(page, pageSize);

        try {
            String trimmedPatientName = trimString(patientNameKeyword);
            String trimmedMedicationName = trimString(medicationNameKeyword);

            List<Prescriptions> prescriptions = prescriptionDAO.searchPrescriptionsByPatientAndMedication(
                    trimmedPatientName, trimmedMedicationName, page, pageSize);
            
            long countWithNurse = prescriptions.stream().filter(p -> p.getNurseId() != null).count();
            log.info("Search for patient '" + trimmedPatientName + 
                     "' and medication '" + trimmedMedicationName + 
                     "' returned " + prescriptions.size() + " prescriptions (" + 
                     countWithNurse + " with nurse) for page " + page + 
                     " at " + LocalDateTime.now() + " +07");
            return prescriptions;
        } catch (SQLException e) {
            log.error("SQLException searching prescriptions by patient and medication: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get total count of prescriptions matching search criteria
     * @param patientNameKeyword Patient name keyword (can be null or empty)
     * @param medicationNameKeyword Medication name keyword (can be null or empty)
     * @return Total count of matching prescriptions
     * @throws SQLException if database operation fails
     */
    public int getTotalCountByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword) throws SQLException {
        try {
            String trimmedPatientName = trimString(patientNameKeyword);
            String trimmedMedicationName = trimString(medicationNameKeyword);

            int total = prescriptionDAO.getTotalCountByPatientAndMedication(trimmedPatientName, trimmedMedicationName);
            log.info("Retrieved total prescriptions matching patient '" + trimmedPatientName + 
                     "' and medication '" + trimmedMedicationName + "': " + total + 
                     " at " + LocalDateTime.now() + " +07");
            return total;
        } catch (SQLException e) {
            log.error("SQLException retrieving total prescriptions by patient and medication: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Update note for a specific prescription
     * @param prescriptionId The prescription ID to update
     * @param note The note to add/update
     * @return true if update was successful
     * @throws SQLException if database operation fails
     * @throws IllegalArgumentException if prescriptionId is invalid
     */
    public boolean updateNoteForPrescription(int prescriptionId, String note) throws SQLException {
        validatePositiveId(prescriptionId, "Prescription ID");
        
        try {
            boolean updated = prescriptionDAO.updateNoteForPrescription(prescriptionId, note);
            if (updated) {
                log.info("Successfully updated note for prescription ID: " + prescriptionId + 
                        " at " + LocalDateTime.now() + " +07");
            } else {
                log.warn("No prescription found with ID: " + prescriptionId + 
                        " for note update at " + LocalDateTime.now() + " +07");
            }
            return updated;
        } catch (SQLException e) {
            log.error("SQLException updating note for prescription ID " + prescriptionId + ": " + 
                     e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get all available medications
     * @return List of all medications
     * @throws SQLException if database operation fails
     */
    public List<Medication> getAllMedications() throws SQLException {
        try {
            List<Medication> medications = prescriptionDAO.getAllMedications();
            log.info("Retrieved " + medications.size() + " medications at " + LocalDateTime.now() + " +07");
            return medications;
        } catch (SQLException e) {
            log.error("SQLException retrieving medications: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get examination results by patient ID
     * Now includes NurseID information from ExaminationResults
     * @param patientId The patient ID
     * @return List of examination results with diagnosis, notes, and nurse information
     * @throws SQLException if database operation fails
     * @throws IllegalArgumentException if patientId is invalid
     */
    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId) throws SQLException {
        validatePositiveId(patientId, "Patient ID");

        try {
            List<Map<String, Object>> results = prescriptionDAO.getExaminationResultsByPatientId(patientId);
            long countWithNurse = results.stream().filter(r -> r.get("nurseId") != null).count();
            log.info("Retrieved " + results.size() + " examination results for patient ID: " + patientId + 
                    " (" + countWithNurse + " with nurse involvement) at " + LocalDateTime.now() + " +07");
            return results;
        } catch (SQLException e) {
            log.error("SQLException retrieving examination results for patient ID " + patientId + ": " + 
                     e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get examination results by patient name (partial match)
     * Now includes NurseID information from ExaminationResults
     * @param patientName The patient name to search for
     * @return List of examination results with diagnosis, notes, and nurse information
     * @throws SQLException if database operation fails
     * @throws IllegalArgumentException if patientName is invalid
     */
    public List<Map<String, Object>> getExaminationResultsByPatientName(String patientName) throws SQLException {
        validateNonEmptyString(patientName, "Patient name");

        try {
            String trimmedPatientName = patientName.trim();
            List<Map<String, Object>> results = prescriptionDAO.getExaminationResultsByPatientName(trimmedPatientName);
            long countWithNurse = results.stream().filter(r -> r.get("nurseId") != null).count();
            log.info("Retrieved " + results.size() + " examination results for patient name: '" + 
                    trimmedPatientName + "' (" + countWithNurse + " with nurse involvement) at " + 
                    LocalDateTime.now() + " +07");
            return results;
        } catch (SQLException e) {
            log.error("SQLException retrieving examination results for patient name '" + patientName + "': " + 
                     e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get all examination results in the system
     * Now includes NurseID information from ExaminationResults
     * @return List of all examination results with diagnosis, notes, and nurse information
     * @throws SQLException if database operation fails
     */
    public List<Map<String, Object>> getAllExaminationResults() throws SQLException {
        try {
            List<Map<String, Object>> results = prescriptionDAO.getAllExaminationResults();
            long countWithNurse = results.stream().filter(r -> r.get("nurseId") != null).count();
            log.info("Retrieved " + results.size() + " examination results for all patients (" + 
                    countWithNurse + " with nurse involvement) at " + LocalDateTime.now() + " +07");
            return results;
        } catch (SQLException e) {
            log.error("SQLException retrieving all examination results: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    /**
     * Get examination results with nurse information summary
     * @return Map containing statistics about nurse involvement in examinations
     * @throws SQLException if database operation fails
     */
    public Map<String, Object> getExaminationResultsStatistics() throws SQLException {
        try {
            List<Map<String, Object>> allResults = prescriptionDAO.getAllExaminationResults();
            
            long totalResults = allResults.size();
            long resultsWithNurse = allResults.stream().filter(r -> r.get("nurseId") != null).count();
            long resultsWithoutNurse = totalResults - resultsWithNurse;
            
            Map<String, Object> statistics = new java.util.HashMap<>();
            statistics.put("totalExaminationResults", totalResults);
            statistics.put("resultsWithNurse", resultsWithNurse);
            statistics.put("resultsWithoutNurse", resultsWithoutNurse);
            statistics.put("nurseInvolvementPercentage", 
                totalResults > 0 ? Math.round((double) resultsWithNurse / totalResults * 100.0) : 0);
            statistics.put("generatedAt", LocalDateTime.now());
            
            log.info("Generated examination results statistics: Total=" + totalResults + 
                    ", WithNurse=" + resultsWithNurse + ", WithoutNurse=" + resultsWithoutNurse + 
                    " at " + LocalDateTime.now() + " +07");
            
            return statistics;
        } catch (SQLException e) {
            log.error("SQLException generating examination results statistics: " + e.getMessage() + 
                     " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }
   public boolean hasPrescription(int resultId) throws SQLException {
        validatePositiveId(resultId, "Result ID");

        try {
            boolean exists = prescriptionDAO.hasPrescription(resultId);
            log.info("Checked prescription existence for ResultID: " + resultId + 
                     ", exists: " + exists + " at " + LocalDateTime.now() + " +07");
            return exists;
        } catch (SQLException e) {
            log.error("SQLException checking prescription existence for ResultID " + resultId + ": " + 
                     e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            throw e;
        }
    }

    // Private validation methods
    private void validatePrescriptionInput(Prescriptions prescription, int resultId, int appointmentId, 
                                         List<Integer> medicationIds) {
        if (prescription == null) {
            log.warn("Invalid input: Prescription object cannot be null at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException("Prescription object cannot be null");
        }
        
        if (prescription.getPatientId() <= 0) {
            log.warn("Invalid input: Patient ID must be positive at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException("Patient ID must be positive");
        }
        
        if (prescription.getDoctorId() <= 0) {
            log.warn("Invalid input: Doctor ID must be positive at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException("Doctor ID must be positive");
        }
        
        // Note: We don't validate NurseID here since it's automatically retrieved from ExaminationResults
        
        validatePositiveId(resultId, "Result ID");
        validatePositiveId(appointmentId, "Appointment ID");
        
        if (medicationIds == null || medicationIds.isEmpty()) {
            log.warn("Invalid input: Medication IDs list cannot be null or empty at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException("Medication IDs list cannot be null or empty");
        }
        
        if (medicationIds.stream().anyMatch(id -> id == null || id <= 0)) {
            log.warn("Invalid input: All Medication IDs must be positive integers at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException("All Medication IDs must be positive integers");
        }
    }

    private void validatePositiveId(int id, String fieldName) {
        if (id <= 0) {
            log.warn("Invalid input: " + fieldName + " must be positive: " + id + " at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException(fieldName + " must be positive");
        }
    }

    private void validatePaginationParameters(int page, int pageSize) {
        if (page <= 0 || pageSize <= 0) {
            log.warn("Invalid pagination parameters: page=" + page + ", pageSize=" + pageSize + 
                    " at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException("Page and pageSize must be greater than 0");
        }
    }

    private void validateNonEmptyString(String value, String fieldName) {
        if (value == null || value.trim().isEmpty()) {
            log.warn("Invalid input: " + fieldName + " cannot be null or empty at " + LocalDateTime.now() + " +07");
            throw new IllegalArgumentException(fieldName + " cannot be null or empty");
        }
    }

    private String trimString(String value) {
        return value != null ? value.trim() : null;
    }
}