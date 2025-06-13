package model.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Medication {

    // Database fields
    private Integer medicationID;
    private String medicationName;
    private String genericName;
    private String brandName;
    private String description;
    private String defaultDosage;
    private String defaultDosageUnit;
    private Integer defaultDosagePerDay;
    private Integer defaultDurationDays;
    private BigDecimal sellingPrice;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Integer createdBy;

    // API fields (tạm thời lưu trữ data từ API)
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

    public String getDefaultDosage() {
        return defaultDosage;
    }

    public void setDefaultDosage(String defaultDosage) {
        this.defaultDosage = defaultDosage;
    }

    public String getDefaultDosageUnit() {
        return defaultDosageUnit;
    }

    public void setDefaultDosageUnit(String defaultDosageUnit) {
        this.defaultDosageUnit = defaultDosageUnit;
    }

    public Integer getDefaultDosagePerDay() {
        return defaultDosagePerDay;
    }

    public void setDefaultDosagePerDay(Integer defaultDosagePerDay) {
        this.defaultDosagePerDay = defaultDosagePerDay;
    }

    public Integer getDefaultDurationDays() {
        return defaultDurationDays;
    }

    public void setDefaultDurationDays(Integer defaultDurationDays) {
        this.defaultDurationDays = defaultDurationDays;
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

    /**
     * Helper method: Tự động set MedicationName từ GenericName hoặc BrandName
     */
    public void autoSetMedicationName() {
        if (this.medicationName == null || this.medicationName.trim().isEmpty()) {
            if (this.brandName != null && !this.brandName.trim().isEmpty()) {
                this.medicationName = this.brandName;
            } else if (this.genericName != null && !this.genericName.trim().isEmpty()) {
                this.medicationName = this.genericName;
            }
        }
    }

    /**
     * Helper method: Parse dosage từ API string
     */
    public void parseDosageFromApi(String apiDosage) {
        if (apiDosage != null && !apiDosage.trim().isEmpty()) {
            // Ví dụ: "500 mg" -> defaultDosage = "500", defaultDosageUnit = "mg"
            String[] parts = apiDosage.trim().split("\\s+");
            if (parts.length >= 2) {
                this.defaultDosage = parts[0];
                this.defaultDosageUnit = parts[1];
            } else {
                this.defaultDosage = apiDosage;
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
                + ", defaultDosage='" + defaultDosage + '\''
                + ", defaultDosageUnit='" + defaultDosageUnit + '\''
                + ", sellingPrice=" + sellingPrice
                + ", status='" + status + '\''
                + '}';
    }
}
