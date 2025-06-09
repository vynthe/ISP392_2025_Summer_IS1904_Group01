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

  
public boolean addPrescription(int doctorId, int patientId, String prescriptionDetail, String trimmedStatus, Timestamp createdAt, int createdBy) {
    try {
        Prescriptions prescription = new Prescriptions();
        // Mặc định ResultID và AppointmentID bạn có thể set = 0 hoặc null nếu chưa có
        prescription.setResultID(0); // hoặc set từ param nếu có
        prescription.setAppointmentID(0); // hoặc set từ param nếu có
        prescription.setDoctorID(doctorId);
        prescription.setPatientID(patientId);
        prescription.setPrescriptionDetails(prescriptionDetail); // MedicationDetails nếu có thì cộng dồn vào đây
        prescription.setStatus(trimmedStatus);
        prescription.setCreatedBy(createdBy); // lấy từ session
        prescription.setCreatedAt(createdAt);
        prescription.setUpdatedAt(createdAt);

        return prescriptionsDAO.addPrescription(prescription);
    } catch (SQLException e) {
        System.err.println("addPrescription failed: " + e.getMessage());
        return false;
    }
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

    public boolean addPrescription(int doctorId, int patientId, String prescriptionDetail, String medicationDetails, String trimmedStatus, Timestamp createdAt) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean addPrescription(int doctorId, int patientId, String prescriptionDetail, String status, Timestamp createdAt) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public boolean addPrescription(Integer doctorId, Integer patientId, String prescriptionDetails, String status, Timestamp createdAt, Integer createdBy, Integer resultId, Integer appointmentId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}