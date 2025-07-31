package model.service;

import model.dao.RoomsDAO;
import model.entity.Rooms;
import model.entity.Services;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Collections;

/**
 * RoomsService handles business logic related to room management.
 */
public class RoomService {
    private final RoomsDAO roomsDAO;

    public RoomService() {
        this.roomsDAO = new RoomsDAO();
    }

    /**
     * Adds a new room to the database.
     * @param room The room object to add.
     * @param createdBy The ID of the user creating the room.
     * @return true if the room was added successfully, false otherwise.
     * @throws SQLException if a database error occurs.
     * @throws IllegalArgumentException if the room name already exists or input is invalid.
     */
    public boolean addRoom(Rooms room, int createdBy) throws SQLException {
        if (room == null || room.getRoomName() == null || room.getRoomName().trim().isEmpty()) {
            throw new IllegalArgumentException("Room or RoomName cannot be null or empty.");
        }
        if (roomsDAO.isRoomNameExists(room.getRoomName(), 0)) {
            throw new IllegalArgumentException("Room name already exists.");
        }
        return roomsDAO.addRoom(room, createdBy);
    }

    /**
     * Searches for rooms based on a keyword.
     * @param keyword The keyword to search for.
     * @return A list of rooms matching the keyword.
     * @throws SQLException if a database error occurs.
     */
    public List<Rooms> searchRooms(String keyword) throws SQLException {
        return roomsDAO.searchRooms(keyword);
    }

    /**
     * Searches for rooms by keyword and status.
     * @param keyword The keyword to search for.
     * @param status The status to filter by.
     * @return A list of rooms matching the keyword and status.
     * @throws SQLException if a database error occurs.
     */
    public List<Rooms> searchRoomsByKeywordAndStatus(String keyword, String status) throws SQLException {
        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Status cannot be null or empty.");
        }
        return roomsDAO.searchRoomsByKeywordAndStatus(keyword, status);
    }

    /**
     * Retrieves all rooms from the database.
     * @return A list of all rooms.
     * @throws SQLException if a database error occurs.
     */
    public List<Rooms> getAllRooms() throws SQLException {
        return roomsDAO.getAllRooms();
    }

    /**
     * Updates an existing room in the database.
     * @param room The room object with updated information.
     * @return true if the room was updated successfully, false otherwise.
     * @throws SQLException if a database error occurs.
     * @throws IllegalArgumentException if the room name already exists or input is invalid.
     */
    public boolean updateRoom(Rooms room) throws SQLException {
        if (room == null || room.getRoomName() == null || room.getRoomName().trim().isEmpty()) {
            throw new IllegalArgumentException("Room or RoomName cannot be null or empty.");
        }
        if (roomsDAO.isRoomNameExists(room.getRoomName(), room.getRoomID())) {
            throw new IllegalArgumentException("Room name already exists.");
        }
        return roomsDAO.updateRoom(room);
    }

    /**
     * Retrieves a room by its ID.
     * @param roomID The ID of the room to retrieve.
     * @return The room object, or null if not found.
     * @throws SQLException if a database error occurs.
     */
    public Rooms getRoomByID(int roomID) throws SQLException {
        if (roomID <= 0) {
            throw new IllegalArgumentException("Invalid Room ID.");
        }
        return roomsDAO.getRoomByID(roomID);
    }

    /**
     * Deletes a room and its related data from the database.
     * @param roomID The ID of the room to delete.
     * @throws SQLException if a database error occurs.
     * @throws ClassNotFoundException if the database driver is not found.
     */
    public void deleteRoom(int roomID) throws SQLException, ClassNotFoundException {
        if (roomID <= 0) {
            throw new IllegalArgumentException("Invalid Room ID.");
        }
        roomsDAO.deleteRoom(roomID);
    }

    /**
     * Retrieves all room IDs from the database.
     * @return A list of room IDs.
     * @throws SQLException if a database error occurs.
     */
    public List<Integer> getAllRoomIds() throws SQLException {
        return roomsDAO.getAllRoomIds();
    }

    /**
     * Retrieves the ID of the first available room.
     * @return The ID of the first available room, or -1 if none are available.
     * @throws SQLException if a database error occurs.
     */
    public int getFirstAvailableRoomId() throws SQLException {
        return roomsDAO.getFirstAvailableRoomId();
    }

    /**
     * Counts the number of available rooms.
     * @return The count of available rooms.
     * @throws SQLException if a database error occurs.
     */
    public int countAvailableRooms() throws SQLException {
        return roomsDAO.countAvailableRooms();
    }

    /**
     * Assigns a service to a room.
     * @param roomId The ID of the room.
     * @param serviceId The ID of the service.
     * @param createdBy The ID of the user assigning the service.
     * @return true if the service was assigned successfully, false otherwise.
     * @throws IllegalArgumentException if input is invalid.
     */
    public boolean assignServiceToRoom(int roomId, int serviceId, int createdBy) {
        if (roomId <= 0 || serviceId <= 0 || createdBy <= 0) {
            throw new IllegalArgumentException("Invalid Room ID, Service ID, or CreatedBy ID.");
        }
        return roomsDAO.assignServiceToRoom(roomId, serviceId, createdBy);
    }

    /**
     * Retrieves all active services.
     * @return A list of active services.
     */
    public List<Services> getAllActiveServices() {
        return roomsDAO.getAllActiveServices();
    }

    /**
     * Checks if a room name already exists, excluding a specific room ID.
     * @param roomName The room name to check.
     * @param excludeRoomID The room ID to exclude from the check.
     * @return true if the room name exists, false otherwise.
     * @throws SQLException if a database error occurs.
     */
    public boolean isRoomNameExists(String roomName, int excludeRoomID) throws SQLException {
        if (roomName == null || roomName.trim().isEmpty()) {
            throw new IllegalArgumentException("Room name cannot be null or empty.");
        }
        return roomsDAO.isRoomNameExists(roomName, excludeRoomID);
    }

    /**
     * Retrieves the list of patient names associated with a room.
     * @param roomId The ID of the room.
     * @return A list of patient names.
     * @throws SQLException if a database error occurs.
     */
    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid Room ID.");
        }
        return roomsDAO.getPatientsByRoomId(roomId);
    }

    /**
     * Retrieves the list of service names associated with a room.
     * @param roomId The ID of the room.
     * @return A list of service names.
     * @throws SQLException if a database error occurs.
     */
    public List<String> getServicesByRoomId(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid Room ID.");
        }
        return roomsDAO.getServicesByRoomId(roomId);
    }

    /**
     * Adds a service to a room.
     * @param roomId The ID of the room.
     * @param serviceId The ID of the service.
     * @return true if the service was added successfully, false otherwise.
     * @throws IllegalArgumentException if input is invalid.
     */
    public boolean addServiceToRoom(int roomId, int serviceId) {
        if (roomId <= 0 || serviceId <= 0) {
            throw new IllegalArgumentException("Invalid Room ID or Service ID.");
        }
        return roomsDAO.addServiceToRoom(roomId, serviceId);
    }

    /**
     * Retrieves the list of services associated with a room.
     * @param roomId The ID of the room.
     * @return A list of services.
     * @throws SQLException if a database error occurs.
     */
    public List<Services> getServicesByRoom(int roomId) throws SQLException {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid Room ID.");
        }
        return roomsDAO.getServicesByRoom(roomId);
    }

    /**
     * Retrieves the weekly schedule for all rooms.
     * @return A map containing the schedule data, days, day name map, start date, and end date.
     * @throws SQLException if a database error occurs.
     */
    public Map<String, Object> getWeeklyScheduleFull() throws SQLException {
        return roomsDAO.getWeeklyScheduleFull();
    }

    /**
     * Retrieves the weekly schedule for a specified date range.
     * @param startDate The start date of the range (YYYY-MM-DD).
     * @param endDate The end date of the range (YYYY-MM-DD).
     * @return A map containing the schedule data, days, day name map, start date, and end date.
     * @throws SQLException if a database error occurs.
     * @throws IllegalArgumentException if the date format is invalid or end date is before start date.
     */
    public Map<String, Object> getWeeklyScheduleByRange(String startDate, String endDate) throws SQLException {
        if (startDate == null || endDate == null || !startDate.matches("\\d{4}-\\d{2}-\\d{2}") || !endDate.matches("\\d{4}-\\d{2}-\\d{2}")) {
            throw new IllegalArgumentException("Invalid date format. Use YYYY-MM-DD.");
        }
        if (startDate.compareTo(endDate) > 0) {
            throw new IllegalArgumentException("End date must be after start date.");
        }
        return roomsDAO.getWeeklyScheduleByRange(startDate, endDate);
    }
}