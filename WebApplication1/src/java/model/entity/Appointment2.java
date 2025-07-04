package model.entity;

import java.sql.Timestamp;

public class Appointment2 {
    private int id;
    private String fullName;
    private String phoneNumber;
    private String email;
    private int serviceID;
    private String serviceName; // Thêm trường để lưu tên dịch vụ
    private Timestamp appointmentDate;
    private String status;

    // Default constructor
    public Appointment2() {
    }

    // Constructor với các trường bắt buộc
    public Appointment2(String fullName, String phoneNumber, String email, int serviceID) {
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.serviceID = serviceID;
    }

    // Getters và Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public Timestamp getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(Timestamp appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}