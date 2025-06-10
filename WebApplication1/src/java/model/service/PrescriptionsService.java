package model.service;

import model.dao.PrescriptionsDAO;
import model.entity.Prescriptions;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

public class PrescriptionsService {
    private final PrescriptionsDAO prescriptionsDAO;

    public PrescriptionsService() {
        this.prescriptionsDAO = new PrescriptionsDAO();
    }

    // Method với tham số đầy đủ
    public boolean addPrescription(int doctorId, int patientId, String prescriptionDetails, 
                                 String status, Timestamp createdAt, int createdBy, 
                                 Integer resultId, Integer appointmentId) {
        try {
            Prescriptions prescription = new Prescriptions();
            
            // Set ResultID và AppointmentID
            prescription.setResultID(resultId != null ? resultId : 0);
            prescription.setAppointmentID(appointmentId != null ? appointmentId : 0);
            prescription.setDoctorID(doctorId);
            prescription.setPatientID(patientId);
            prescription.setPrescriptionDetails(prescriptionDetails);
            prescription.setStatus(status);
            prescription.setCreatedBy(createdBy);
            prescription.setCreatedAt(createdAt);
            prescription.setUpdatedAt(createdAt);
            
            return prescriptionsDAO.addPrescription(prescription);
        } catch (SQLException e) {
            System.err.println("addPrescription failed: " + e.getMessage());
            return false;
        }
    }

    // Method với tham số cơ bản (backward compatibility)
    public boolean addPrescription(int doctorId, int patientId, String prescriptionDetails, 
                                 String status, Timestamp createdAt, int createdBy) {
        return addPrescription(doctorId, patientId, prescriptionDetails, status, createdAt, createdBy, null, null);
    }

    // Lấy toa thuốc theo ID
    public Prescriptions getPrescriptionByID(int id) {
        try {
            return prescriptionsDAO.getPrescriptionByID(id);
        } catch (SQLException e) {
            System.err.println("getPrescriptionByID failed: " + e.getMessage());
            return null;
        }
    }

    // Lấy danh sách tất cả toa thuốc
    public List<Prescriptions> getAllPrescriptions() {
        try {
            return prescriptionsDAO.getAllPrescriptions();
        } catch (SQLException e) {
            System.err.println("getAllPrescriptions failed: " + e.getMessage());
            return null;
        }
    }
}