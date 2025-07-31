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
    private Integer userID;  // Changed from separate doctorID/nurseID
    private String role;     // Added role field to match schema
    private String description;
    private String status;
    private int createdBy;
    private Date createdAt;
    private Date updatedAt; 
    
    public Rooms() {
    }
    
    public Rooms(int roomID, String roomName, Integer userID, String role, String description, 
                 String status, int createdBy, Date createdAt, Date updatedAt) {
        this.roomID = roomID;
        this.roomName = roomName;
        this.userID = userID;
        this.role = role;
        this.description = description;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
      
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
    
    public Integer getUserID() {
        return userID;
    }
    
    public void setUserID(Integer userID) {
        this.userID = userID;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
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
    
    // Convenience methods to check role
    public boolean isDoctor() {
        return "Doctor".equals(role);
    }
    
    public boolean isNurse() {
        return "Nurse".equals(role);
    }
    
    public boolean isReceptionist() {
        return "Receptionist".equals(role);
    }
    
    @Override
    public String toString() {
        return "Rooms{" + 
               "roomID=" + roomID + 
               ", roomName=" + roomName + 
               ", userID=" + userID + 
               ", role=" + role + 
               ", description=" + description + 
               ", status=" + status + 
               ", createdBy=" + createdBy + 
               ", createdAt=" + createdAt + 
               ", updatedAt=" + updatedAt + 
           
               '}';
    }
}