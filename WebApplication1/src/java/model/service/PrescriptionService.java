package model.service;

import model.entity.Prescriptions;
import model.entity.Medication;
import model.dao.PrescriptionDAO;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.sql.SQLException;
import java.util.List;

public class PrescriptionService {
    private static final Log log = LogFactory.getLog(PrescriptionService.class);
    private final PrescriptionDAO prescriptionDAO;
    private final MedicationService medicationService;

    public PrescriptionService() {
        this.prescriptionDAO = new PrescriptionDAO();
        this.medicationService = new MedicationService();
    }

    public boolean addPrescription(Prescriptions prescription, List<Integer> medicationIds, List<String> dosageInstructions) throws SQLException {
        // Validate required fields
        if (prescription.getPatientId() <= 0 || prescription.getDoctorId() <= 0 || 
            medicationIds.isEmpty() || prescription.getStatus() == null || 
            prescription.getStatus().trim().isEmpty()) {
            log.warn("Validation failed: Required fields are missing or invalid (patient_id, doctor_id, medication_ids, status)");
            throw new IllegalArgumentException("Required fields (patient_id, doctor_id, medication_ids, status) are missing or invalid.");
        }
        if (dosageInstructions == null || dosageInstructions.size() != medicationIds.size() || 
            dosageInstructions.stream().anyMatch(di -> di == null || di.trim().isEmpty())) {
            log.warn("Validation failed: Dosage instructions are required for each medication.");
            throw new IllegalArgumentException("Dosage instructions are required for each medication.");
        }

        // Construct prescriptionDetails if not provided
        if (prescription.getPrescriptionDetails() == null || prescription.getPrescriptionDetails().trim().isEmpty()) {
            StringBuilder prescriptionDetails = new StringBuilder();
            try {
                for (int i = 0; i < medicationIds.size(); i++) {
                    int medicationId = medicationIds.get(i);
                    Medication medication = medicationService.getMedicationById(medicationId);
                    if (medication == null) {
                        log.warn("Medication not found for medicationId: " + medicationId);
                        throw new IllegalArgumentException("Medication not found with ID: " + medicationId);
                    }
                    if (medication.getDosage() == null || medication.getDosage().trim().isEmpty()) {
                        log.warn("Medication dosage is missing for medicationId: " + medicationId);
                        throw new IllegalArgumentException("Medication dosage is required for ID: " + medicationId);
                    }

                    prescriptionDetails.append("Thuốc: ").append(medication.getName())
                                      .append(", Liều lượng: ").append(medication.getDosage())
                                      .append(", Hướng dẫn: ").append(dosageInstructions.get(i).trim());
                    if (i < medicationIds.size() - 1) {
                        prescriptionDetails.append(" | ");
                    }
                }
                if (prescriptionDetails.length() > 4000) { // TEXT field can handle large data, but setting a reasonable limit
                    log.warn("Prescription details exceed 4000 characters, truncating");
                    prescriptionDetails.setLength(4000);
                }
                prescription.setPrescriptionDetails(prescriptionDetails.toString());
            } catch (SQLException e) {
                log.error("SQLException fetching medication: " + e.getMessage(), e);
                throw new SQLException("Error fetching medication details: " + e.getMessage());
            }
        }

        // Save to database
        boolean added = prescriptionDAO.addPrescription(prescription, medicationIds, dosageInstructions);
        if (added) {
            log.info("Successfully added prescription for patient_id: " + prescription.getPatientId() + ", medication_ids: " + medicationIds);
        } else {
            log.warn("Failed to add prescription for patient_id: " + prescription.getPatientId());
        }
        return added;
    }

    public List<Prescriptions> getAllPrescriptions() throws SQLException {
        try {
            List<Prescriptions> prescriptions = prescriptionDAO.getAllPrescriptions();
            log.info("Retrieved " + prescriptions.size() + " prescriptions");
            return prescriptions;
        } catch (SQLException e) {
            log.error("SQLException retrieving prescriptions: " + e.getMessage(), e);
            throw e;
        }
    }

    public List<Prescriptions> searchPrescriptionsByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword, int page, int pageSize) throws SQLException {
        try {
            List<Prescriptions> prescriptions = prescriptionDAO.searchPrescriptionsByPatientAndMedication(patientNameKeyword, medicationNameKeyword, page, pageSize);
            log.info("Search for patientNameKeyword '" + patientNameKeyword + "' and medicationNameKeyword '" + medicationNameKeyword + 
                     "' returned " + prescriptions.size() + " prescriptions for page " + page);
            return prescriptions;
        } catch (SQLException e) {
            log.error("SQLException searching prescriptions by patient and medication: " + e.getMessage(), e);
            throw e;
        }
    }

    public int getTotalCountByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword) throws SQLException {
        try {
            int total = prescriptionDAO.getTotalCountByPatientAndMedication(patientNameKeyword, medicationNameKeyword);
            log.info("Retrieved total prescriptions matching patientNameKeyword '" + patientNameKeyword + 
                     "' and medicationNameKeyword '" + medicationNameKeyword + "': " + total);
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
            log.info("Retrieved " + medications.size() + " medications for dropdown");
            return medications;
        } catch (SQLException e) {
            log.error("SQLException retrieving medications: " + e.getMessage(), e);
            throw e;
        }
    }
}