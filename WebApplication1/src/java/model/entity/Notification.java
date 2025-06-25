package model.entity;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Notification {
    private int notificationID;
    private int senderID;
    private String senderRole;
    private int receiverID;
    private String receiverRole;
    private String title;
    private String message;
    private boolean isRead;
    private LocalDateTime createdAt;

    // Constructors
    public Notification() {}

    public Notification(int senderID, String senderRole, int receiverID, String receiverRole, String title, String message) {
        this.senderID = senderID;
        this.senderRole = senderRole;
        this.receiverID = receiverID;
        this.receiverRole = receiverRole;
        this.title = title;
        this.message = message;
        this.isRead = false;
        this.createdAt = LocalDateTime.now();
    }

    public Notification(int adminId, String admin, int userId, String patient, String title, String message, Timestamp timestamp) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    // Getters and Setters
    public int getNotificationID() { return notificationID; }
    public void setNotificationID(int notificationID) { this.notificationID = notificationID; }
    public int getSenderID() { return senderID; }
    public void setSenderID(int senderID) { this.senderID = senderID; }
    public String getSenderRole() { return senderRole; }
    public void setSenderRole(String senderRole) { this.senderRole = senderRole; }
    public int getReceiverID() { return receiverID; }
    public void setReceiverID(int receiverID) { this.receiverID = receiverID; }
    public String getReceiverRole() { return receiverRole; }
    public void setReceiverRole(String receiverRole) { this.receiverRole = receiverRole; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}