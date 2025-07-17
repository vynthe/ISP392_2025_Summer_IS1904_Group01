package model.entity;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;

public class ScheduleEmployee {
    private int slotId;
    private int userId; // ID của nhân viên (Doctor, Nurse, Receptionist)
    private String role; // Vai trò: Doctor, Nurse, Receptionist
    private Integer roomId; // ID phòng, dùng Integer để hỗ trợ NULL
    private LocalDate slotDate; // Ngày làm việc
    private LocalTime startTime; // Giờ bắt đầu
    private LocalTime endTime; // Giờ kết thúc
    private String status; // Trạng thái: Available, Booked, Completed, Cancelled
    private int createdBy; // ID của admin tạo lịch
    private LocalDateTime createdAt; // Thời gian tạo
    private LocalDateTime updatedAt; // Thời gian cập nhật

    // Constructor mặc định
    public ScheduleEmployee() {
    }

    // Constructor đầy đủ (cập nhật roomId thành Integer)
    public ScheduleEmployee(int slotId, int userId, String role, Integer roomId, LocalDate slotDate,
            LocalTime startTime, LocalTime endTime, boolean isAbsent, String absenceReason,
            String status, int createdBy, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.slotId = slotId;
        this.userId = userId;
        this.role = role;
        this.roomId = roomId; // Có thể là null
        this.slotDate = slotDate;
        this.startTime = startTime;
        this.endTime = endTime;
  
        this.status = status;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters và Setters (cập nhật roomId)
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

    // toString để debug
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
                + '}';
    }
}