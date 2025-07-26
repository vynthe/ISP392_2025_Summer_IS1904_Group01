package model.entity;

import java.time.LocalDateTime;

public class Prescriptions {
    private int prescriptionId;
    private int patientId;
    private int doctorId;
    private Integer nurseId; // Sử dụng Integer để có thể null
    private String prescriptionDetails;
    private String signature;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Default constructor
    public Prescriptions() {}

    // Constructor with all fields
    public Prescriptions(int prescriptionId, int patientId, int doctorId, Integer nurseId, 
                        String prescriptionDetails, String signature, 
                        LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.prescriptionId = prescriptionId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.nurseId = nurseId;
        this.prescriptionDetails = prescriptionDetails;
        this.signature = signature;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Constructor without ID (for new prescriptions)
    public Prescriptions(int patientId, int doctorId, Integer nurseId, 
                        String prescriptionDetails, String signature) {
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.nurseId = nurseId;
        this.prescriptionDetails = prescriptionDetails;
        this.signature = signature;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
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

    public String getPrescriptionDetails() {
        return prescriptionDetails;
    }

    public void setPrescriptionDetails(String prescriptionDetails) {
        this.prescriptionDetails = prescriptionDetails;
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
        return "Prescriptions{" +
                "prescriptionId=" + prescriptionId +
                ", patientId=" + patientId +
                ", doctorId=" + doctorId +
                ", nurseId=" + nurseId +
                ", prescriptionDetails='" + prescriptionDetails + '\'' +
                ", signature='" + signature + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        Prescriptions that = (Prescriptions) obj;
        return prescriptionId == that.prescriptionId;
    }

    @Override
    public int hashCode() {
        return Integer.hashCode(prescriptionId);
    }
}