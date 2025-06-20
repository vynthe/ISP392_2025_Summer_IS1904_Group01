package model.entity;

import java.sql.Date;
import java.sql.Timestamp;

public class Users {
    private int userID;
    private String username;
    private String password;
    private String email;
    private String fullName;
    private Date dob;
    private String gender;
    private String phone;
    private String address;
    private String medicalHistory;
    private String specialization;
    private String role;
    private String status;
    private Integer createdBy;
    private Date createdAt;
    private Date updatedAt;
    // Thêm các thuộc tính mới
    private String verificationCode;
    private Timestamp verificationCodeExpiry;
    private boolean isVerified;

    public Users() {
    }

    public Users(int userID, String username, String password, String email, String fullName, Date dob, String gender, 
                 String phone, String address, String medicalHistory, String specialization, String role, String status, 
                 Integer createdBy, Date createdAt, Date updatedAt, String verificationCode, 
                 Timestamp verificationCodeExpiry, boolean isVerified) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.email = email;
        this.fullName = fullName;
        this.dob = dob;
        this.gender = gender;
        this.phone = phone;
        this.address = address;
        this.medicalHistory = medicalHistory;
        this.specialization = specialization;
        this.role = role;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.verificationCode = verificationCode;
        this.verificationCodeExpiry = verificationCodeExpiry;
        this.isVerified = isVerified;
    }

    // Getters và Setters cho các thuộc tính hiện có
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getMedicalHistory() {
        return medicalHistory;
    }

    public void setMedicalHistory(String medicalHistory) {
        this.medicalHistory = medicalHistory;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Getters và Setters cho các thuộc tính mới
    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public Timestamp getVerificationCodeExpiry() {
        return verificationCodeExpiry;
    }

    public void setVerificationCodeExpiry(Timestamp verificationCodeExpiry) {
        this.verificationCodeExpiry = verificationCodeExpiry;
    }

    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean isVerified) {
        this.isVerified = isVerified;
    }

    @Override
    public String toString() {
        return "Users{" +
                "userID=" + userID +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", dob=" + dob +
                ", gender='" + gender + '\'' +
                ", phone='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", medicalHistory='" + medicalHistory + '\'' +
                ", specialization='" + specialization + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", verificationCode='" + verificationCode + '\'' +
                ", verificationCodeExpiry=" + verificationCodeExpiry +
                ", isVerified=" + isVerified +
                '}';
    }

    public void setCreatedBy(Object object) {
        if (object instanceof Integer) {
            this.createdBy = (Integer) object;
        } else {
            throw new IllegalArgumentException("CreatedBy must be an Integer");
        }
    }
}