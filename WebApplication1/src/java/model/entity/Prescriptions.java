package model.entity;

import java.time.LocalDateTime;

public class Prescriptions {
    private int prescriptionId;
    private int patientId;
    private int doctorId;
    private Integer nurseId; // Sử dụng Integer để có thể null
    private String prescriptionDosage;
    private String quantity;
    private String instruct;
    private String signature;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Default constructor

    public Prescriptions() {
    }

    public Prescriptions(int prescriptionId, int patientId, int doctorId, Integer nurseId, String prescriptionDosage, String quantity, String instruct, String signature, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.prescriptionId = prescriptionId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.nurseId = nurseId;
        this.prescriptionDosage = prescriptionDosage;
        this.quantity = quantity;
        this.instruct = instruct;
        this.signature = signature;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public Integer getNurseId() {
        return nurseId;
    }

    public void setNurseId(Integer nurseId) {
        this.nurseId = nurseId;
    }

    public String getPrescriptionDosage() {
        return prescriptionDosage;
    }

    public void setPrescriptionDosage(String prescriptionDosage) {
        this.prescriptionDosage = prescriptionDosage;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public String getInstruct() {
        return instruct;
    }

    public void setInstruct(String instruct) {
        this.instruct = instruct;
    }

    public String getSignature() {
        return signature;
    }

    public void setSignature(String signature) {
        this.signature = signature;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Prescriptions{" + "prescriptionId=" + prescriptionId + ", patientId=" + patientId + ", doctorId=" + doctorId + ", nurseId=" + nurseId + ", prescriptionDosage=" + prescriptionDosage + ", quantity=" + quantity + ", instruct=" + instruct + ", signature=" + signature + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
   
  
}