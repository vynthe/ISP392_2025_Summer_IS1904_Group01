package model.entity;

import java.time.LocalDate;

public class Medication {

    // Database fields
    private Integer medicationID;
    private String name;                // Tên thuốc
    private String dosage;             // Liều dùng
    private String manufacturer;       // Nhà sản xuất
    private String description;        // Mô tả
    private String status;             // Trạng thái
    private String dosageForm;         // Dạng bào chế

    // Constructor mặc định với giá trị khởi tạo
    public Medication() {
        this.status = "Active";
        
    }

    // Constructor đầy đủ
    public Medication(Integer medicationID, String name, String dosage, String manufacturer, String description,
            LocalDate productionDate, LocalDate expirationDate, Double price, Integer quantity,
            String status, String dosageForm) {
        this.medicationID = medicationID;
        this.name = name;
        this.dosage = dosage;
        this.manufacturer = manufacturer;
        this.description = description;
        this.status = status;
        this.dosageForm = dosageForm;
    }

    // Getters and Setters
    public Integer getMedicationID() {
        return medicationID;
    }

    public void setMedicationID(Integer medicationID) {
        this.medicationID = medicationID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        if (status != null && (status.equals("Active") || status.equals("Inactive") || status.equals("Out of Stock"))) {
            this.status = status;
        } else {
            throw new IllegalArgumentException("Status must be 'Active', 'Inactive', or 'Out of Stock'");
        }
    }

    public String getDosageForm() {
        return dosageForm;
    }

    public void setDosageForm(String dosageForm) {
        if (dosageForm != null && (dosageForm.equals("Tablet") || dosageForm.equals("Liquid")
                || dosageForm.equals("Capsule") || dosageForm.equals("Injection")
                || dosageForm.equals("Syrup") || dosageForm.equals("Powder")
                || dosageForm.equals("Cream") || dosageForm.equals("Ointment"))) {
            this.dosageForm = dosageForm;
        } else {
            throw new IllegalArgumentException("Dosage form must be one of: Tablet, Liquid, Capsule, Injection, Syrup, Powder, Cream, Ointment");
        }
    }



    @Override
    public String toString() {
        return "Medication{"
                + "medicationID=" + medicationID
                + ", name='" + name + '\''
                + ", dosage='" + dosage + '\''
                + ", manufacturer='" + manufacturer + '\''
                + ", description='" + description + '\''
                + ", status='" + status + '\''
                + ", dosageForm='" + dosageForm + '\''
                + '}';
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        Medication that = (Medication) obj;
        return medicationID != null && medicationID.equals(that.medicationID);
    }

    @Override
    public int hashCode() {
        return medicationID != null ? medicationID.hashCode() : 0;
    }
}
