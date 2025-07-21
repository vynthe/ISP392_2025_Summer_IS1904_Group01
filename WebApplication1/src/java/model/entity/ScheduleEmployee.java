package model.entity;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.List;

public class ScheduleEmployee {

    private int slotId;
    private int userId;
    private String role;
    private Integer roomId;
    private LocalDate slotDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String status;
    private int createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String fullName; // Tên bác sĩ/y tá từ Users
    private String roomName; // Tên phòng từ Rooms
    private List<String> serviceNames; // Danh sách tên dịch vụ từ RoomServices

    // Constructor mặc định
    public ScheduleEmployee() {
    }

    // Constructor đầy đủ
    public ScheduleEmployee(int slotId, int userId, String role, Integer roomId, LocalDate slotDate,
            LocalTime startTime, LocalTime endTime, String status, int createdBy,
            LocalDateTime createdAt, LocalDateTime updatedAt, String fullName,
            String roomName, List<String> serviceNames) {
        this.slotId = slotId;
        this.userId = userId;
        this.role = role;
        this.roomId = roomId;
        this.slotDate = slotDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.fullName = fullName;
        this.roomName = roomName;
        this.serviceNames = serviceNames;
    }

    // Getters và Setters
    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public LocalDate getSlotDate() {
        return slotDate;
    }

    public void setSlotDate(LocalDate slotDate) {
        this.slotDate = slotDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public List<String> getServiceNames() {
        return serviceNames;
    }

    public void setServiceNames(List<String> serviceNames) {
        this.serviceNames = serviceNames;
    }

    @Override
    public String toString() {
        return "ScheduleEmployee{"
                + "slotId=" + slotId
                + ", userId=" + userId
                + ", role='" + role + '\''
                + ", roomId=" + roomId
                + ", slotDate=" + slotDate
                + ", startTime=" + startTime
                + ", endTime=" + endTime
                + ", status='" + status + '\''
                + ", createdBy=" + createdBy
                + ", createdAt=" + createdAt
                + ", updatedAt=" + updatedAt
                + ", fullName='" + fullName + '\''
                + ", roomName='" + roomName + '\''
                + ", serviceNames=" + serviceNames
                + '}';
    }
}
