/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.entity;
import java.sql.Date;
/**
 *
 * @author exorc
 */
public class Rooms {
    private int roomID;
    private String roomName;
    private String description;
    private Integer doctorID;
    private Integer nurseID;
    private String status;
    private int createdBy;
    private Date createdAt;
    private Date updatedAt; 
     private String doctorName; 
    private String nurseName;

    public Rooms() {
    }

    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }

    public String getNurseName() {
        return nurseName;
    }

    public void setNurseName(String nurseName) {
        this.nurseName = nurseName;
    }

    public Rooms(int roomID, String roomName, String description, int doctorID, int nurseID, String status, int createdBy, Date createdAt, Date updatedAt, String doctorName, String nurseName) {
        this.roomID = roomID;
        this.roomName = roomName;
        this.description = description;
        this.doctorID = doctorID;
        this.nurseID = nurseID;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.doctorName = doctorName;
        this.nurseName = nurseName;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDoctorID() {
        return doctorID;
    }

    public void setDoctorID(Integer doctorID) {
        this.doctorID = doctorID;
    }

    public Integer getNurseID() {
        return nurseID;
    }

    public void setNurseID(Integer nurseID) {
        this.nurseID = nurseID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
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

    @Override
    public String toString() {
        return "Rooms{" + "roomID=" + roomID + ", roomName=" + roomName + ", description=" + description + ", doctorID=" + doctorID + ", nurseID=" + nurseID + ", status=" + status + ", createdBy=" + createdBy + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
}
