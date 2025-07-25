package model.service;

import model.entity.Prescriptions;
import model.entity.Medication;
import model.dao.PrescriptionDAO;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class PrescriptionService {
    private static final Log log = LogFactory.getLog(PrescriptionService.class);
    private final PrescriptionDAO prescriptionDAO;

    public PrescriptionService() {
        this.prescriptionDAO = new PrescriptionDAO();
    }

    public List<Prescriptions> searchPrescriptionsByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword, int page, int pageSize) throws SQLException {
        if (page <= 0 || pageSize <= 0) {
            log.warn("Invalid pagination parameters: page=" + page + ", pageSize=" + pageSize);
            throw new IllegalArgumentException("Page and pageSize must be greater than 0.");
        }

        try {
            String trimmedPatientName = patientNameKeyword != null ? patientNameKeyword.trim() : null;
            String trimmedMedicationName = medicationNameKeyword != null ? medicationNameKeyword.trim() : null;

            List<Prescriptions> prescriptions = prescriptionDAO.searchPrescriptionsByPatientAndMedication(
                    trimmedPatientName, trimmedMedicationName, page, pageSize);
            log.info("Search for patientNameKeyword '" + trimmedPatientName + 
                     "' and medicationNameKeyword '" + trimmedMedicationName + 
                     "' returned " + prescriptions.size() + " prescriptions for page " + page);
            return prescriptions;
        } catch (SQLException e) {
            log.error("SQLException searching prescriptions by patient and medication: " + e.getMessage(), e);
            throw e;
        }
    }

    public int getTotalCountByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword) throws SQLException {
        try {
            String trimmedPatientName = patientNameKeyword != null ? patientNameKeyword.trim() : null;
            String trimmedMedicationName = medicationNameKeyword != null ? medicationNameKeyword.trim() : null;

            int total = prescriptionDAO.getTotalCountByPatientAndMedication(trimmedPatientName, trimmedMedicationName);
            log.info("Retrieved total prescriptions matching patientNameKeyword '" + trimmedPatientName + 
                     "' and medicationNameKeyword '" + trimmedMedicationName + "': " + total);
            return total;
        } catch (SQLException e) {
            log.error("SQLException retrieving total prescriptions by patient and medication: " + e.getMessage(), e);
            throw e;
        }
    }

    public int getTotalPrescriptions() throws SQLException {
        try {
            int total = prescriptionDAO.getTotalPrescriptionCount();
            log.info("Retrieved total prescriptions: " + total);
            return total;
        } catch (SQLException e) {
            log.error("SQLException retrieving total prescriptions: " + e.getMessage(), e);
            throw e;
        }
    }

    public List<Prescriptions> getPrescriptionsByPage(int page, int pageSize) throws SQLException {
        if (page <= 0 || pageSize <= 0) {
            log.warn("Invalid pagination parameters: page=" + page + ", pageSize=" + pageSize);
            throw new IllegalArgumentException("Page and pageSize must be greater than 0.");
        }

        try {
            List<Prescriptions> prescriptions = prescriptionDAO.getPrescriptionsByPage(page, pageSize);
            log.info("Retrieved " + prescriptions.size() + " prescriptions for page " + page);
            return prescriptions;
        } catch (SQLException e) {
            log.error("SQLException retrieving prescriptions for page " + page + ": " + e.getMessage(), e);
            throw e;
        }
    }

    public List<Medication> getAllMedications() throws SQLException {
        try {
            List<Medication> medications = prescriptionDAO.getAllMedications();
            log.info("Retrieved " + medications.size() + " medications");
            return medications;
        } catch (SQLException e) {
            log.error("SQLException retrieving medications: " + e.getMessage(), e);
            throw e;
        }
    }

   public boolean addPrescription(Prescriptions prescription, int resultId, int appointmentId, List<Integer> medicationId) throws SQLException {
        if (prescription == null) {
            log.warn("Invalid input: Prescription object cannot be null");
            throw new IllegalArgumentException("Prescription object cannot be null.");
        }
        if (prescription.getPatientId() <= 0 || prescription.getDoctorId() <= 0 || resultId <= 0 || appointmentId <= 0) {
            log.warn("Invalid input: Patient ID, Doctor ID, Result ID, and Appointment ID must be greater than 0");
            throw new IllegalArgumentException("Patient ID, Doctor ID, Result ID, and Appointment ID must be greater than 0.");
        }
        if (medicationId == null || medicationId.isEmpty()) {
            log.warn("Invalid input: Medication IDs list cannot be null or empty");
            throw new IllegalArgumentException("Medication IDs list cannot be null or empty.");
        }
        if (medicationId.stream().anyMatch(id -> id <= 0)) {
            log.warn("Invalid input: All Medication IDs must be positive integers");
            throw new IllegalArgumentException("All Medication IDs must be positive integers.");
        }

        try {
            boolean added = prescriptionDAO.addPrescription(prescription, resultId, appointmentId, medicationId);
            if (added) {
                log.info("Successfully added prescription with ID: " + prescription.getPrescriptionId() + 
                         ", ResultID: " + resultId + ", AppointmentID: " + appointmentId + 
                         ", MedicationIDs: " + medicationId);
            } else {
                log.warn("Failed to add prescription for ResultID: " + resultId + 
                         ", AppointmentID: " + appointmentId);
            }
            return added;
        } catch (SQLException e) {
            log.error("SQLException adding prescription: " + e.getMessage(), e);
            throw new SQLException("Failed to add prescription: " + e.getMessage(), e);
        }
    }

    public Prescriptions getPrescriptionById(int prescriptionId) throws SQLException {
        if (prescriptionId <= 0) {
            log.warn("Invalid prescription ID: " + prescriptionId);
            throw new IllegalArgumentException("Prescription ID must be greater than 0.");
        }

        try {
            Prescriptions prescription = prescriptionDAO.getPrescriptionById(prescriptionId);
            if (prescription == null) {
                log.warn("No prescription found with ID: " + prescriptionId);
            } else {
                log.info("Fetched prescription with ID: " + prescriptionId);
            }
            return prescription;
        } catch (SQLException e) {
            log.error("SQLException fetching prescription by ID: " + e.getMessage(), e);
            throw e;
        }
    }

    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            log.warn("Invalid patient ID: " + patientId);
            throw new IllegalArgumentException("Patient ID must be greater than 0.");
        }

        try {
            List<Map<String, Object>> results = prescriptionDAO.getExaminationResultsByPatientId(patientId);
            log.info("Retrieved " + results.size() + " examination results for patient ID: " + patientId);
            return results;
        } catch (SQLException e) {
            log.error("SQLException retrieving examination results for patient ID " + patientId + ": " + e.getMessage(), e);
            throw e;
        }
    }

    public List<Map<String, Object>> getAllExaminationResults() throws SQLException {
        try {
            List<Map<String, Object>> results = prescriptionDAO.getAllExaminationResults();
            log.info("Retrieved " + results.size() + " examination results for all patients");
            return results;
        } catch (SQLException e) {
            log.error("SQLException retrieving all examination results: " + e.getMessage(), e);
            throw e;
        }
    }
    public List<Map<String, Object>> getExaminationResultsByPatientName(String patientName) throws SQLException {
    if (patientName == null || patientName.trim().isEmpty()) {
        log.warn("Invalid patient name: " + patientName);
        throw new IllegalArgumentException("Patient name cannot be null or empty.");
    }

    try {
        String trimmedPatientName = patientName.trim();
        List<Map<String, Object>> results = prescriptionDAO.getExaminationResultsByPatientName(trimmedPatientName);
        log.info("Retrieved " + results.size() + " examination results for patient name: " + trimmedPatientName);
        return results;
    } catch (SQLException e) {
        log.error("SQLException retrieving examination results for patient name " + patientName + ": " + e.getMessage(), e);
        throw e;
    }
}
    
}