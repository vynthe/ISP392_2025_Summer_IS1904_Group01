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
import model.entity.Services;

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

    String sql = "SELECT r.RoomID, r.RoomName, r.[Description], r.DoctorID, r.NurseID, r.[Status], " +
                 "d.fullName AS doctorName, " +
                 "n.fullName AS nurseName " +
                 "FROM Rooms r " +
                 "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                 "LEFT JOIN Users n ON r.NurseID = n.UserID";

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

            room.setDoctorName(rs.getString("doctorName")); // cần getter/setter trong Rooms.java
            room.setNurseName(rs.getString("nurseName"));

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
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, roomID);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomName(rs.getString("RoomName"));
                room.setDescription(rs.getString("Description"));
                room.setDoctorID(rs.getObject("DoctorID") != null ? rs.getInt("DoctorID") : null);
                room.setNurseID(rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                room.setStatus(rs.getString("Status"));
                room.setCreatedBy(rs.getInt("CreatedBy"));
                room.setCreatedAt(rs.getDate("CreatedAt"));
                room.setUpdatedAt(rs.getDate("UpdatedAt"));
                return room;
            }
        }
    } catch (SQLException e) {
        System.err.println("SQLException in getRoomByID: " + e.getMessage());
        throw e;
    }
    return null;
}
public List<Rooms> getRoomByID(int userId, String role) throws SQLException {
    List<Rooms> roomList = new ArrayList<>();
    String sql;

    if ("doctor".equalsIgnoreCase(role)) {
        sql = "SELECT * FROM Rooms WHERE DoctorID = ?";
    } else if ("nurse".equalsIgnoreCase(role)) {
        sql = "SELECT * FROM Rooms WHERE NurseID = ?";
    } else {
        return roomList; // không hỗ trợ vai trò khác
    }

    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, userId);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomName(rs.getString("RoomName"));
                room.setDescription(rs.getString("Description"));
                room.setDoctorID(rs.getObject("DoctorID") != null ? rs.getInt("DoctorID") : null);
                room.setNurseID(rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                room.setStatus(rs.getString("Status"));
                room.setCreatedBy(rs.getInt("CreatedBy"));
                room.setCreatedAt(rs.getDate("CreatedAt"));
                room.setUpdatedAt(rs.getDate("UpdatedAt"));
                roomList.add(room);
            }
        }
    }

    return roomList;
}




 public void deleteRoom(int roomID) throws SQLException {
    String deleteSchedules = "DELETE FROM Schedules WHERE RoomID = ?";
    String deleteRoomServices = "DELETE FROM RoomServices WHERE RoomID = ?";
    String deleteAppointments = "DELETE FROM Appointments WHERE RoomID = ?";
    String deleteRoom = "DELETE FROM Rooms WHERE RoomID = ?";

    try (Connection conn = dbContext.getConnection()) {
        conn.setAutoCommit(false); // Bắt đầu transaction

        try (PreparedStatement ps1 = conn.prepareStatement(deleteSchedules);
             PreparedStatement ps2 = conn.prepareStatement(deleteRoomServices);
             PreparedStatement ps3 = conn.prepareStatement(deleteAppointments);
             PreparedStatement ps4 = conn.prepareStatement(deleteRoom)) {

            ps1.setInt(1, roomID);
            ps1.executeUpdate();

            ps2.setInt(1, roomID);
            ps2.executeUpdate();

            ps3.setInt(1, roomID);
            ps3.executeUpdate();

            ps4.setInt(1, roomID);
            int rows = ps4.executeUpdate();

            if (rows == 0) {
                conn.rollback();
                throw new SQLException("❌ Không tìm thấy phòng có ID = " + roomID);
            }

            conn.commit();
            System.out.println("✅ Đã xóa phòng và dữ liệu liên quan.");
        } catch (SQLException ex) {
            conn.rollback(); // Lỗi thì rollback lại toàn bộ
            throw ex;
        }
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
     public List<Integer> getAllRoomIds() throws SQLException {
        List<Integer> roomIds = new ArrayList<>();
        String sql = "SELECT RoomID FROM Rooms"; 
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                roomIds.add(rs.getInt("RoomID"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting all room IDs from DB: " + e.getMessage());
            throw e;
        }
        return roomIds;
    }
     public int countAvailableRooms() throws SQLException {
    String sql = "SELECT COUNT(*) FROM Rooms WHERE Status = 'Available'";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
        return 0;
    } catch (SQLException e) {
        System.err.println("SQLException in countAvailableRooms: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
        throw e;
    }
     }
     public boolean assignServiceToRoom(int roomId, int serviceId, int createdBy) {
    String sql = "INSERT INTO RoomServices (RoomID, ServiceID, CreatedBy) VALUES (?, ?, ?)";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, roomId);
        stmt.setInt(2, serviceId);
        stmt.setInt(3, createdBy);
        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}
 public List<Services> getAllActiveServices() {
        List<Services> services = new ArrayList<>();
        String sql = "SELECT * FROM Services WHERE Status = 'Active'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Services s = new Services();
                s.setServiceID(rs.getInt("ServiceID"));
                s.setServiceName(rs.getString("ServiceName"));
                s.setDescription(rs.getString("Description"));
                s.setPrice(rs.getDouble("Price"));
                s.setStatus(rs.getString("Status"));
                s.setCreatedBy(rs.getInt("CreatedBy"));
                s.setCreatedAt(rs.getDate("CreatedAt"));
                s.setUpdatedAt(rs.getDate("UpdatedAt"));
                services.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace(); // log lỗi
        }

        return services;
    }

public boolean isDoctorOrNurseAssignedToAnotherRoom(Integer doctorID, Integer nurseID, int excludeRoomID) throws SQLException {
    String sql = "SELECT 1 FROM Rooms WHERE (DoctorID = ? OR NurseID = ?) AND RoomID != ?";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setObject(1, doctorID, java.sql.Types.INTEGER);
        stmt.setObject(2, nurseID, java.sql.Types.INTEGER);
        stmt.setInt(3, excludeRoomID);
        try (ResultSet rs = stmt.executeQuery()) {
            return rs.next();
        }
    } catch (SQLException e) {
        System.err.println("SQLException in isDoctorOrNurseAssignedToAnotherRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
        throw e;
    }
}
     public String getUserFullNameById(int userId) throws SQLException {
        String sql = "SELECT FullName FROM Users WHERE UserID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("FullName");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getUserFullNameById: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }
     public boolean isRoomNameExists(String roomName, int excludeRoomID) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE roomName = ? AND roomID != ?";
         try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, roomName);
            stmt.setInt(2, excludeRoomID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Lấy danh sách bệnh nhân đã đặt lịch trong phòng
    public List<String> getPatientsByRoomId(int roomId) throws SQLException {
        List<String> patients = new ArrayList<>();
        String sql = "SELECT DISTINCT u.FullName " +
                     "FROM Appointments a " +
                     "JOIN Users u ON a.PatientID = u.UserID " +
                     "WHERE a.RoomID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    patients.add(rs.getString("FullName"));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getPatientsByRoomId: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return patients;
    }

    // Lấy danh sách dịch vụ liên quan đến phòng
 public List<String> getServicesByRoomId(int roomId) throws SQLException {
        List<String> services = new ArrayList<>();
        String sql = "SELECT DISTINCT s.ServiceName " +
                     "FROM RoomServices rs " +
                     "JOIN Services s ON rs.ServiceID = s.ServiceID " +
                     "WHERE rs.RoomID = ? AND s.Status = 'Active'";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    services.add(rs.getString("ServiceName"));
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getServicesByRoomId: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return services.isEmpty() ? List.of("Không có dịch vụ") : services;
    }
 public boolean addServiceToRoom(int roomId, int serviceId) {
    String sql = "INSERT INTO Room_Service (room_id, service_id) VALUES (?, ?)";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, roomId);
        ps.setInt(2, serviceId);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}
 public List<Services> getServicesByRoom(int roomId) throws SQLException {
    List<Services> services = new ArrayList<>();
    String sql = "SELECT s.* " +
                 "FROM RoomServices rs " +
                 "JOIN Services s ON rs.ServiceID = s.ServiceID " +
                 "WHERE rs.RoomID = ? AND s.Status = 'Active'";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, roomId);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Services s = new Services();
                s.setServiceID(rs.getInt("ServiceID"));
                s.setServiceName(rs.getString("ServiceName"));
                s.setDescription(rs.getString("Description"));
                s.setPrice(rs.getDouble("Price"));
                s.setStatus(rs.getString("Status"));
                s.setCreatedBy(rs.getInt("CreatedBy"));
                s.setCreatedAt(rs.getDate("CreatedAt"));
                s.setUpdatedAt(rs.getDate("UpdatedAt"));
                services.add(s);
            }
        }
    } catch (SQLException e) {
        System.err.println("SQLException in getServicesByRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
        throw e;
    }
    return services;
}

}