/*
 * Click nfs://netbeans/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nfs://netbeans/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.service;

import java.sql.SQLException;
import java.util.List;
import model.entity.Rooms;
import model.dao.RoomsDAO;
import model.entity.Services;

/**
 *
 * @author exorc
 */
public class RoomService {
    private final RoomsDAO roomsDAO;

    public RoomService() {
        this.roomsDAO = new RoomsDAO();
    }

    public boolean addRoom(String roomName, String description, Integer doctorID, Integer nurseID, String status, int createdBy) throws SQLException {
        // Validate inputs
        if (roomName == null || roomName.trim().isEmpty()) {
            throw new IllegalArgumentException("Tên phòng không được để trống.");
        }
        if (doctorID != null && doctorID <= 0 || !roomsDAO.isValidDoctor(doctorID)) {
            throw new IllegalArgumentException("Doctor ID không tồn tại hoặc không hợp lệ.");
        }
        if (nurseID != null && nurseID <= 0 || !roomsDAO.isValidNurse(nurseID)) {
            throw new IllegalArgumentException("Nurse ID không tồn tại hoặc không hợp lệ.");
        }
        if (createdBy <= 0) {
            throw new IllegalArgumentException("ID người tạo không hợp lệ.");
        }

        // Normalize and default status
        String finalStatus = (status != null && !status.trim().isEmpty()) ? status.trim() : "Available";
        if (!finalStatus.equals("Available") && !finalStatus.equals("Not Available") && 
            !finalStatus.equals("In Progress") && !finalStatus.equals("Completed")) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ. Chỉ chấp nhận 'Available', 'Not Available', 'In Progress', hoặc 'Completed'.");
        }

        // Create Room object
        Rooms room = new Rooms();
        room.setRoomName(roomName.trim());
        room.setDescription(description != null ? description.trim() : null);
        room.setDoctorID(doctorID);
        room.setNurseID(nurseID);
        room.setStatus(finalStatus);

        // Call DAO to insert room
        return roomsDAO.addRoom(room, createdBy);
    }

public boolean isDoctorAssigned(Integer doctorID) throws SQLException {
        return roomsDAO.isDoctorAssigned(doctorID);
    }

    public boolean isNurseAssigned(Integer nurseID) throws SQLException {
        return roomsDAO.isNurseAssigned(nurseID);
    }

    public boolean isValidDoctor(Integer doctorID) throws SQLException {
        if (doctorID == null || doctorID <= 0) return false;
        return roomsDAO.isValidDoctor(doctorID);
    }

    public boolean isValidNurse(Integer nurseID) throws SQLException {
        if (nurseID == null || nurseID <= 0) return false;
        return roomsDAO.isValidNurse(nurseID);
    }

    private boolean isAuthorized(int userId) {
        return userId > 0;
    }

    public List<Rooms> searchRooms(String keyword) throws SQLException {
        return roomsDAO.searchRooms(keyword);
    }

    public List<Rooms> getAllRooms() throws SQLException {
        try {
            return roomsDAO.getAllRooms();
        } catch (SQLException e) {
            System.err.println("Error in RoomService.getAllRooms: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public boolean updateRoom(Rooms room) throws SQLException {
        if (room.getRoomID() <= 0) {
            throw new IllegalArgumentException("ID phòng không hợp lệ.");
        }
        return roomsDAO.updateRoom(room);
    }

    public Rooms getRoomByID(int roomID) throws SQLException {
        if (roomID <= 0) {
            throw new IllegalArgumentException("ID phòng không hợp lệ.");
        }
        return roomsDAO.getRoomByID(roomID);
    }

    public void deleteRoom(int roomID) throws Exception {
        if (roomID <= 0) {
            throw new IllegalArgumentException("ID phòng không hợp lệ.");
        }
        roomsDAO.deleteRoom(roomID);
    }
      public List<Integer> getAllRoomIds() throws SQLException, ClassNotFoundException {
        try {
            return roomsDAO.getAllRoomIds(); // Gọi phương thức từ DAO
        } catch (SQLException e) {
            System.err.println("Error in RoomService.getAllRoomIds: " + e.getMessage());
            throw e; 
        }
    }
 public List<Rooms> getRoomsByUserIdAndRole(int userId, String role) throws SQLException {
    return roomsDAO.getRoomByID(userId, role);  // phương thức này bạn đã viết rồi
}
public boolean isDoctorOrNurseAssignedToAnotherRoom(Integer doctorID, Integer nurseID, int excludeRoomID) throws SQLException {
        return roomsDAO.isDoctorOrNurseAssignedToAnotherRoom(doctorID, nurseID, excludeRoomID);
    }

    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        return roomsDAO.getPatientsByRoomId(roomId);
    }

    public List<String> getServicesByRoomId(int roomId) throws SQLException {
        return roomsDAO.getServicesByRoomId(roomId);
    }
    public String getDoctorNameByRoomId(int roomId) throws SQLException {
        Rooms room = getRoomByID(roomId);
        if (room != null) {
            return roomsDAO.getUserFullNameById(room.getDoctorID()); 
        }
        return null;
    }

    public String getNurseNameByRoomId(int roomId) throws SQLException {
        Rooms room = getRoomByID(roomId);
        if (room != null) {
            return roomsDAO.getUserFullNameById(room.getNurseID()); 
        }
        return null;
    }
    public boolean assignServiceToRoom(int roomId, int serviceId) {
    return roomsDAO.addServiceToRoom(roomId, serviceId);
}
public List<Services> getServicesByRoom(int roomId) {
        try {
            return roomsDAO.getServicesByRoom(roomId);
        } catch (SQLException e) {
            System.err.println("Error in RoomService.getServicesByRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            return List.of(); // Trả về list rỗng nếu lỗi
        }
    }
 public boolean assignServiceToRoom(int roomId, int serviceId, int createdBy) {
        return roomsDAO.assignServiceToRoom(roomId, serviceId, createdBy);
    }

public List<Services> getAllActiveServices() throws SQLException {
    return roomsDAO.getAllActiveServices();
}

  public int countAvailableRooms() throws SQLException {
        return roomsDAO.countAvailableRooms();
    }
}