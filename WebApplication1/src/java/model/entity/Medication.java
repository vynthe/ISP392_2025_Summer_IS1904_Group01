package model.entity;

import java.time.LocalDate;

public class Medication {

    // Database fields
    private Integer medicationID;
    private String name;                // Tên thuốc
    private String dosage;             // Liều dùng
    private String manufacturer;       // Nhà sản xuất
    private String description;        // Mô tả
    private LocalDate productionDate;  // Ngày sản xuất
    private LocalDate expirationDate;  // Hạn dùng
    private Double price;              // Giá tiền
    private Integer quantity;          // Số lượng
    private String status;             // Trạng thái
    private String dosageForm;         // Dạng bào chế

    // Constructor mặc định với giá trị khởi tạo
    public Medication() {
        this.status = "Active";
        this.quantity = 0;
        this.price = 0.0;
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
        this.productionDate = productionDate;
        this.expirationDate = expirationDate;
        this.price = price;
        this.quantity = quantity;
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

    public LocalDate getProductionDate() {
        return productionDate;
    }

    public void setProductionDate(LocalDate productionDate) {
        this.productionDate = productionDate;
    }

    public LocalDate getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(LocalDate expirationDate) {
        this.expirationDate = expirationDate;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        if (price != null && price < 0) {
            throw new IllegalArgumentException("Price must be non-negative");
        }
        this.price = price;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        if (quantity != null && quantity < 0) {
            throw new IllegalArgumentException("Quantity must be non-negative");
        }
        this.quantity = quantity;
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

    // Validation for dates
    public void validateDates() {
        if (productionDate != null && expirationDate != null && !expirationDate.isAfter(productionDate)) {
            throw new IllegalArgumentException("Expiration date must be after production date");
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
                + ", productionDate=" + productionDate
                + ", expirationDate=" + expirationDate
                + ", price=" + price
                + ", quantity=" + quantity
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
