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
public class AppointmentQueue {

    private int queueId;

    private int slotId;
    private int appointmentId;
    private int queueNumber;
    private LocalDateTime createdAt;

    public AppointmentQueue() {
    }

    public AppointmentQueue(int queueId, int slotId, int appointmentId, int queueNumber, LocalDateTime createdAt) {
        this.queueId = queueId;
        this.slotId = slotId;
        this.appointmentId = appointmentId;
        this.queueNumber = queueNumber;
        this.createdAt = createdAt;
    }

    public int getQueueId() {
        return queueId;
    }

    public void setQueueId(int queueId) {
        this.queueId = queueId;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public int getQueueNumber() {
        return queueNumber;
    }

    public void setQueueNumber(int queueNumber) {
        this.queueNumber = queueNumber;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

}
