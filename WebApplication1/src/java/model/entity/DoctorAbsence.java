/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 *
 * @author exorc
 */
public class DoctorAbsence {

    private int absenceId;

    private int doctorId;
    private LocalDate absenceDate;
    private String reason;
    private String status;
    private LocalDateTime createdAt;
    private Integer approvedBy;
    private LocalDateTime approvedAt;

    public DoctorAbsence() {
    }

    public DoctorAbsence(int absenceId, int doctorId, LocalDate absenceDate, String reason, String status, LocalDateTime createdAt, Integer approvedBy, LocalDateTime approvedAt) {
        this.absenceId = absenceId;
        this.doctorId = doctorId;
        this.absenceDate = absenceDate;
        this.reason = reason;
        this.status = status;
        this.createdAt = createdAt;
        this.approvedBy = approvedBy;
        this.approvedAt = approvedAt;
    }

    public int getAbsenceId() {
        return absenceId;
    }

    public void setAbsenceId(int absenceId) {
        this.absenceId = absenceId;
    }

    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }

    public LocalDate getAbsenceDate() {
        return absenceDate;
    }

    public void setAbsenceDate(LocalDate absenceDate) {
        this.absenceDate = absenceDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
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

    public Integer getApprovedBy() {
        return approvedBy;
    }

    public void setApprovedBy(Integer approvedBy) {
        this.approvedBy = approvedBy;
    }

    public LocalDateTime getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(LocalDateTime approvedAt) {
        this.approvedAt = approvedAt;
    }

}
