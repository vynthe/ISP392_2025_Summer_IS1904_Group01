package model.entity;

import java.sql.Timestamp;

public class AppointmentGuest {
    private int id;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String service;
    private Timestamp appointmentDate;
    private String status;

    // Constructor mặc định
    public AppointmentGuest() {
    }

    // Constructor với các trường bắt buộc
    public AppointmentGuest(String fullName, String phoneNumber, String email, String service) {
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.service = service;
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

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
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