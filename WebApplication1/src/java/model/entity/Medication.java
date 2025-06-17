package model.entity;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Medication {

    // Database fields
    private Integer medicationID;
    private String medicationName;
    private String genericName;
    private String brandName;
    private String description;
    private String dosage;              // Thay thế defaultDosage, phân tích từ API
    private BigDecimal sellingPrice;
    private String status;
    private LocalDate manufacturingDate; // Di chuyển từ API
    private LocalDate expiryDate;       // Di chuyển từ API
    private Integer quantity;           // Di chuyển từ API
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer createdBy;

    // API fields (chỉ dùng tạm thời để lấy dữ liệu)
    private String manufacturer;
    private String ndc;
    private String dosageForm;

    // Constructors
    public Medication() {
        this.status = "Available";
        this.sellingPrice = BigDecimal.ZERO;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Medication(String medicationName, String genericName, String brandName) {
        this();
        this.medicationName = medicationName;
        this.genericName = genericName;
        this.brandName = brandName;
    }

    // Getters and Setters for Database fields
    public Integer getMedicationID() {
        return medicationID;
    }

    public void setMedicationID(Integer medicationID) {
        this.medicationID = medicationID;
    }

    public String getMedicationName() {
        return medicationName;
    }

    public void setMedicationName(String medicationName) {
        this.medicationName = medicationName;
    }

    public String getGenericName() {
        return genericName;
    }

    public void setGenericName(String genericName) {
        this.genericName = genericName;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }

    public BigDecimal getSellingPrice() {
        return sellingPrice;
    }

    public void setSellingPrice(BigDecimal sellingPrice) {
        this.sellingPrice = sellingPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getManufacturingDate() {
        return manufacturingDate;
    }

    public void setManufacturingDate(LocalDate manufacturingDate) {
        this.manufacturingDate = manufacturingDate;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
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

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    // Getters and Setters for API fields
    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getNdc() {
        return ndc;
    }

    public void setNdc(String ndc) {
        this.ndc = ndc;
    }

    public String getDosageForm() {
        return dosageForm;
    }

    public void setDosageForm(String dosageForm) {
        this.dosageForm = dosageForm;
    }

    public void parseDosageFromApi(String apiDosage) {
        if (apiDosage != null && !apiDosage.trim().isEmpty()) {
            String[] parts = apiDosage.trim().split("\\s+");
            if (parts.length >= 2) {
                this.dosage = apiDosage; // Lưu toàn bộ dosage, có thể phân tích thêm nếu cần
            } else {
                this.dosage = apiDosage;
            }
        }
    }

    @Override
    public String toString() {
        return "Medication{"
                + "medicationID=" + medicationID
                + ", medicationName='" + medicationName + '\''
                + ", genericName='" + genericName + '\''
                + ", brandName='" + brandName + '\''
                + ", description='" + description + '\''
                + ", dosage='" + dosage + '\''
                + ", sellingPrice=" + sellingPrice
                + ", status='" + status + '\''
                + ", manufacturer='" + manufacturer + '\''
                + ", ndc='" + ndc + '\''
                + ", dosageForm='" + dosageForm + '\''
                + ", manufacturingDate=" + manufacturingDate
                + ", expiryDate=" + expiryDate
                + ", quantity=" + quantity
                + '}';
    }
}
