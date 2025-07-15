/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;

import java.time.LocalDateTime;

/**
 *
 * @author exorc
 */
public class AppointmentLog {

    private int logId;

    private int appointmentId;
    private String action;
    private Integer oldDoctorId;
    private Integer newDoctorId;
    private Integer oldSlotId;
    private Integer newSlotId;
    private Integer performedBy;
    private String notes;
    private LocalDateTime createdAt;

    public AppointmentLog() {
    }

    public AppointmentLog(int logId, int appointmentId, String action, Integer oldDoctorId, Integer newDoctorId, Integer oldSlotId, Integer newSlotId, Integer performedBy, String notes, LocalDateTime createdAt) {
        this.logId = logId;
        this.appointmentId = appointmentId;
        this.action = action;
        this.oldDoctorId = oldDoctorId;
        this.newDoctorId = newDoctorId;
        this.oldSlotId = oldSlotId;
        this.newSlotId = newSlotId;
        this.performedBy = performedBy;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Integer getOldDoctorId() {
        return oldDoctorId;
    }

    public void setOldDoctorId(Integer oldDoctorId) {
        this.oldDoctorId = oldDoctorId;
    }

    public Integer getNewDoctorId() {
        return newDoctorId;
    }

    public void setNewDoctorId(Integer newDoctorId) {
        this.newDoctorId = newDoctorId;
    }

    public Integer getOldSlotId() {
        return oldSlotId;
    }

    public void setOldSlotId(Integer oldSlotId) {
        this.oldSlotId = oldSlotId;
    }

    public Integer getNewSlotId() {
        return newSlotId;
    }

    public void setNewSlotId(Integer newSlotId) {
        this.newSlotId = newSlotId;
    }

    public Integer getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(Integer performedBy) {
        this.performedBy = performedBy;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
