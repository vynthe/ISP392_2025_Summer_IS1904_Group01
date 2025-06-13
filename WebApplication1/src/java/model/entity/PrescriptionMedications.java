package model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PrescriptionMedications {
    private int prescriptionId;
    private String medicationName; // Thêm trường này để lưu tên thuốc trực tiếp
    private int quantity = 1;
    private int dosagePerDay = 1;
    private int durationDays = 1;
    private String additionalInstructions = "";
    private BigDecimal price = BigDecimal.ZERO;
    private LocalDateTime createdAt = LocalDateTime.now();
    private LocalDateTime updatedAt = LocalDateTime.now();

    public PrescriptionMedications() {}

    public PrescriptionMedications(int prescriptionId, String medicationName, int dosagePerDay, int durationDays, int quantity) {
        this();
        this.prescriptionId = prescriptionId;
        this.medicationName = medicationName != null ? medicationName.trim() : "";
        this.dosagePerDay = Math.max(dosagePerDay, 1);
        this.durationDays = Math.max(durationDays, 1);
        this.quantity = Math.max(quantity, 1);
    }

    public int getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(int prescriptionId) { this.prescriptionId = prescriptionId; }

    public String getMedicationName() { return medicationName; }
    public void setMedicationName(String medicationName) { this.medicationName = medicationName != null ? medicationName.trim() : ""; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = Math.max(quantity, 1); }

    public int getDosagePerDay() { return dosagePerDay; }
    public void setDosagePerDay(int dosagePerDay) { this.dosagePerDay = Math.max(dosagePerDay, 1); }

    public int getDurationDays() { return durationDays; }
    public void setDurationDays(int durationDays) { this.durationDays = Math.max(durationDays, 1); }

    public String getAdditionalInstructions() { return additionalInstructions; }
    public void setAdditionalInstructions(String additionalInstructions) { this.additionalInstructions = additionalInstructions != null ? additionalInstructions : ""; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = (price != null && price.compareTo(BigDecimal.ZERO) >= 0) ? price : BigDecimal.ZERO; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt != null ? createdAt : LocalDateTime.now(); }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt != null ? updatedAt : LocalDateTime.now(); }

    public int getTotalDoses() {
        return dosagePerDay * durationDays * quantity;
    }

    @Override
    public String toString() {
        return "PrescriptionMedications{" +
                "prescriptionId=" + prescriptionId +
                ", medicationName='" + medicationName + '\'' +
                ", quantity=" + quantity +
                ", dosagePerDay=" + dosagePerDay +
                ", durationDays=" + durationDays +
                ", additionalInstructions='" + additionalInstructions + '\'' +
                ", price=" + price +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}