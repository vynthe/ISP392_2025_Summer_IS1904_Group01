/*
 * Click nfs://netbeans/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nfs://netbeans/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.entity.Rooms;

/**
 *
 * @author ADMIN
 */
public class RoomsDAO {
    private final DBContext dbContext;

    public RoomsDAO() {
        this.dbContext = DBContext.getInstance();
    }

    public boolean addRoom(Rooms room, int createdBy) throws SQLException {
        if (room == null) {
            throw new SQLException("Room object cannot be null.");
        }

        String sql = "INSERT INTO Rooms (RoomName, [Description], DoctorID, NurseID, [Status], CreatedBy, CreatedAt, UpdatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getRoomName());
            stmt.setString(2, room.getDescription());
            Integer doctorID = room.getDoctorID();
            if (doctorID != null) {
                stmt.setInt(3, doctorID);
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }
            Integer nurseID = room.getNurseID();
            if (nurseID != null) {
                stmt.setInt(4, nurseID);
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }
            stmt.setString(5, room.getStatus());
            stmt.setInt(6, createdBy);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in addRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public boolean isValidDoctor(Integer doctorID) throws SQLException {
        if (doctorID == null || doctorID <= 0) return false;
        String sql = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Doctor'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorID);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean isValidNurse(Integer nurseID) throws SQLException {
        if (nurseID == null || nurseID <= 0) return false;
        String sql = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Nurse'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nurseID);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<Rooms> searchRooms(String keyword) throws SQLException {
        List<Rooms> roomList = new ArrayList<>();
        String sql = "SELECT RoomID, RoomName, [Description], DoctorID, NurseID, [Status] " +
                     "FROM Rooms " +
                     "WHERE RoomName LIKE ? OR CAST(RoomID AS NVARCHAR) LIKE ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String searchPattern = "%" + (keyword != null ? keyword : "") + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomID(rs.getInt("RoomID"));
                    room.setRoomName(rs.getString("RoomName"));
                    room.setDescription(rs.getString("Description"));
                    Integer doctorID = rs.getObject("DoctorID") != null ? rs.getInt("DoctorID") : null;
                    Integer nurseID = rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null;
                    room.setDoctorID(doctorID);
                    room.setNurseID(nurseID);
                    room.setStatus(rs.getString("Status"));
                    roomList.add(room);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in searchRooms: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return roomList;
    }

    public List<Rooms> getAllRooms() throws SQLException {
        List<Rooms> roomList = new ArrayList<>();
        String sql = "SELECT RoomID, RoomName, [Description], DoctorID, NurseID, [Status] " +
                     "FROM Rooms";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomName(rs.getString("RoomName"));
                room.setDescription(rs.getString("Description"));
                Integer doctorID = rs.getObject("DoctorID") != null ? rs.getInt("DoctorID") : null;
                Integer nurseID = rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null;
                room.setDoctorID(doctorID);
                room.setNurseID(nurseID);
                room.setStatus(rs.getString("Status"));
                roomList.add(room);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllRooms: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return roomList;
    }

    public boolean updateRoom(Rooms room) throws SQLException {
        String sql = "UPDATE Rooms SET RoomName = ?, [Description] = ?, DoctorID = ?, NurseID = ?, [Status] = ?, UpdatedAt = GETDATE() WHERE RoomID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomName());
            ps.setString(2, room.getDescription());
            Integer doctorID = room.getDoctorID();
            if (doctorID != null) {
                ps.setInt(3, doctorID);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            Integer nurseID = room.getNurseID();
            if (nurseID != null) {
                ps.setInt(4, nurseID);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setString(5, room.getStatus());
            ps.setInt(6, room.getRoomID());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in updateRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public Rooms getRoomByID(int roomID) throws SQLException {
        String sql = "SELECT * FROM Rooms WHERE RoomID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomID(rs.getInt("RoomID"));
                    room.setRoomName(rs.getString("RoomName"));
                    room.setDescription(rs.getString("Description"));
                    Integer doctorID = rs.getObject("DoctorID") != null ? rs.getInt("DoctorID") : null;
                    Integer nurseID = rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null;
                    room.setDoctorID(doctorID);
                    room.setNurseID(nurseID);
                    room.setStatus(rs.getString("Status"));
                    room.setCreatedBy(rs.getInt("CreatedBy"));
                    room.setCreatedAt(rs.getDate("CreatedAt"));
                    room.setUpdatedAt(rs.getDate("UpdatedAt"));
                    return room;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getRoomByID: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    public void deleteRoom(int roomID) throws SQLException {
        String sql = "DELETE FROM Rooms WHERE RoomID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomID);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Room with ID " + roomID + " not found.");
            }
        } catch (SQLException e) {
            System.err.println("SQLException in deleteRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }
    public boolean isDoctorAssigned(Integer doctorID) throws SQLException {
        if (doctorID == null) return false;
        String sql = "SELECT 1 FROM Rooms WHERE DoctorID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorID);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // Returns true if a row is found
            }
        }
    }

    public boolean isNurseAssigned(Integer nurseID) throws SQLException {
        if (nurseID == null) return false;
        String sql = "SELECT 1 FROM Rooms WHERE NurseID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, nurseID);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); // Returns true if a row is found
            }
        }
    }
}