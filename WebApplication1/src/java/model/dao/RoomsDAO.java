/*
 * Click nbfs://netbeans/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://netbeans/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Collections;
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

        String sql = "INSERT INTO Rooms (RoomName, [Description], [Status], CreatedBy, CreatedAt, UpdatedAt) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), GETDATE())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getRoomName());
            stmt.setString(2, room.getDescription());
            stmt.setString(3, room.getStatus());
            stmt.setInt(4, createdBy);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in addRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public List<Rooms> searchRooms(String keyword) throws SQLException {
        List<Rooms> roomList = new ArrayList<>();
        String sql = "SELECT RoomID, RoomName, [Description], [Status] " +
                     "FROM Rooms " +
                     "WHERE RoomName LIKE ? OR CAST(RoomID AS NVARCHAR) LIKE ? OR [Status] LIKE ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + (keyword != null ? keyword.trim() : "") + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomID(rs.getInt("RoomID"));
                    room.setRoomName(rs.getString("RoomName"));
                    room.setDescription(rs.getString("Description"));
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

    public List<Rooms> searchRoomsByKeywordAndStatus(String keyword, String status) throws SQLException {
        List<Rooms> roomList = new ArrayList<>();

        String sql = """
            SELECT RoomID, RoomName, [Description], [Status], CreatedBy
            FROM Rooms
            WHERE (RoomName LIKE ? OR CAST(RoomID AS VARCHAR) LIKE ?)
              AND [Status] = ?
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + (keyword != null ? keyword.trim() : "") + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, status != null ? status : "");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomID(rs.getInt("RoomID"));
                    room.setRoomName(rs.getString("RoomName"));
                    room.setDescription(rs.getString("Description"));
                    room.setStatus(rs.getString("Status"));
                    room.setCreatedBy(rs.getInt("CreatedBy"));
                    roomList.add(room);
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ SQLException in searchRoomsByKeywordAndStatus at "
                    + java.time.LocalDateTime.now() + ": " + e.getMessage());
            throw e;
        }

        return roomList;
    }

    public List<Rooms> getAllRooms() throws SQLException {
        List<Rooms> roomList = new ArrayList<>();

        String sql = "SELECT r.RoomID, r.RoomName, r.[Description], r.[Status], r.CreatedBy, " +
                     "r.CreatedAt, r.UpdatedAt " +
                     "FROM Rooms r ";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomName(rs.getString("RoomName"));
                room.setDescription(rs.getString("Description"));
                room.setStatus(rs.getString("Status"));
                room.setCreatedBy(rs.getInt("CreatedBy"));
                room.setCreatedAt(rs.getDate("CreatedAt"));
                room.setUpdatedAt(rs.getDate("UpdatedAt"));
                roomList.add(room);
            }

        } catch (SQLException e) {
            System.err.println("SQLException in getAllRooms: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }

        return roomList;
    }

    public boolean updateRoom(Rooms room) throws SQLException {
        String sql = "UPDATE Rooms SET RoomName = ?, [Description] = ?, [Status] = ?, UpdatedAt = GETDATE() WHERE RoomID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getRoomName());
            ps.setString(2, room.getDescription());
            ps.setString(3, room.getStatus());
            ps.setInt(4, room.getRoomID());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in updateRoom: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public Rooms getRoomByID(int roomID) throws SQLException {
        String sql = "SELECT RoomID, RoomName, [Description], [Status], CreatedBy, CreatedAt, UpdatedAt " +
                     "FROM Rooms WHERE RoomID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Rooms room = new Rooms();
                    room.setRoomID(rs.getInt("RoomID"));
                    room.setRoomName(rs.getString("RoomName"));
                    room.setDescription(rs.getString("Description"));
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

    public void deleteRoom(int roomID) throws SQLException, ClassNotFoundException {
        String checkFutureSchedules = """
            SELECT COUNT(*) FROM ScheduleEmployee
            WHERE RoomID = ?
              AND SlotDate BETWEEN CAST(GETDATE() AS DATE) AND DATEADD(DAY, 7, CAST(GETDATE() AS DATE))
        """;

        String deleteSchedules = "DELETE FROM ScheduleEmployee WHERE RoomID = ?";
        String deleteRoomServices = "DELETE FROM RoomServices WHERE RoomID = ?";
        String deleteAppointments = "DELETE FROM Appointments WHERE RoomID = ?";
        String deleteRoom = "DELETE FROM Rooms WHERE RoomID = ?";

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement checkStmt = conn.prepareStatement(checkFutureSchedules)) {
                checkStmt.setInt(1, roomID);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        conn.rollback();
                        throw new SQLException("❌ Không thể xóa phòng vì phòng đã được gán lịch cho nhân viên trong tuần tới.");
                    }
                }
            }

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
                conn.rollback();
                throw ex;
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

    public int getFirstAvailableRoomId() throws SQLException {
        String sql = "SELECT TOP 1 RoomID FROM Rooms WHERE Status = 'Available' ORDER BY RoomID";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("RoomID");
            }
            return -1;
        } catch (SQLException e) {
            System.err.println("SQLException in getFirstAvailableRoomId: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
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
            e.printStackTrace();
        }

        return services;
    }

    public boolean isRoomNameExists(String roomName, int excludeRoomID) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Rooms WHERE RoomName = ? AND RoomID != ?";
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
        return services.isEmpty() ? Collections.singletonList("Không có dịch vụ") : services;
    }

    public boolean addServiceToRoom(int roomId, int serviceId) {
        String sql = "INSERT INTO RoomServices (RoomID, ServiceID, CreatedBy) VALUES (?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, serviceId);
            ps.setInt(3, 1); // Giả định CreatedBy = 1, cần điều chỉnh theo logic thực tế
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

    public Map<String, Object> getWeeklyScheduleFull() throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Map<String, Map<String, Map<String, Map<String, String>>>> scheduleData = new LinkedHashMap<>();
        List<String> days = new ArrayList<>();
        Map<String, String> dayNameMap = new LinkedHashMap<>();
        String startDate = null, endDate = null;

        String sqlDays = "SELECT CONVERT(varchar, DATEADD(DAY, v.number, weekStart), 23) as Day, DATENAME(weekday, DATEADD(DAY, v.number, weekStart)) as WeekDay " +
                        "FROM (SELECT DATEADD(DAY, 1 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE)) as weekStart) d " +
                        "CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6)) v(number)";
        try (Connection con = dbContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlDays);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String day = rs.getString("Day");
                String weekDay = rs.getString("WeekDay");
                days.add(day);
                dayNameMap.put(day, weekDay);
            }
            if (!days.isEmpty()) {
                startDate = days.get(0);
                endDate = days.get(days.size() - 1);
            }
        }

        List<String> allRooms = new ArrayList<>();
        String sqlRooms = "SELECT RoomName FROM Rooms";
        try (Connection con = dbContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlRooms);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                allRooms.add(rs.getString("RoomName"));
            }
        }

        String sql = "SELECT r.RoomName, " +
                     "CASE WHEN FORMAT(se.StartTime, 'HH:mm') < '12:00' THEN 'Ca sáng' ELSE 'Ca chiều' END AS Shift, " +
                     "CONVERT(varchar, se.SlotDate, 23) as Day, se.Role, u.FullName " +
                     "FROM Rooms r " +
                     "LEFT JOIN ScheduleEmployee se ON r.RoomID = se.RoomID AND se.SlotDate BETWEEN ? AND ? " +
                     "LEFT JOIN Users u ON se.UserID = u.UserID";
        try (Connection con = dbContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String room = rs.getString("RoomName");
                    String shift = rs.getString("Shift") != null ? rs.getString("Shift") : "Ca sáng";
                    String day = rs.getString("Day");
                    String role = rs.getString("Role");
                    String name = rs.getString("FullName");
                    if (day == null) continue;
                    scheduleData.putIfAbsent(room, new LinkedHashMap<>());
                    scheduleData.get(room).putIfAbsent(shift, new LinkedHashMap<>());
                    scheduleData.get(room).get(shift).putIfAbsent(day, new HashMap<>());
                    if (role != null && name != null) {
                        scheduleData.get(room).get(shift).get(day).put(role, name);
                    }
                }
            }
        }

        for (String room : allRooms) {
            scheduleData.putIfAbsent(room, new LinkedHashMap<>());
            for (String shift : new String[]{"Ca sáng", "Ca chiều"}) {
                scheduleData.get(room).putIfAbsent(shift, new LinkedHashMap<>());
                for (String day : days) {
                    scheduleData.get(room).get(shift).putIfAbsent(day, new HashMap<>());
                }
            }
        }
        result.put("scheduleData", scheduleData);
        result.put("days", days);
        result.put("dayNameMap", dayNameMap);
        result.put("startDate", startDate);
        result.put("endDate", endDate);
        return result;
    }

    public Map<String, Object> getWeeklyScheduleByRange(String startDate, String endDate) throws SQLException {
        Map<String, Object> result = new HashMap<>();
        Map<String, Map<String, Map<String, Map<String, String>>>> scheduleData = new LinkedHashMap<>();
        List<String> days = new ArrayList<>();
        Map<String, String> dayNameMap = new LinkedHashMap<>();

        String sqlDays = "SELECT CONVERT(varchar, d, 23) as Day, DATENAME(weekday, d) as WeekDay " +
                        "FROM (SELECT TOP (DATEDIFF(DAY, ?, ?) + 1) DATEADD(DAY, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1, ?) as d " +
                        "FROM sys.all_objects) AS x";
        try (Connection con = dbContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlDays)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ps.setString(3, startDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String day = rs.getString("Day");
                    String weekDay = rs.getString("WeekDay");
                    days.add(day);
                    dayNameMap.put(day, weekDay);
                }
            }
        }

        List<String> allRooms = new ArrayList<>();
        String sqlRooms = "SELECT RoomName FROM Rooms";
        try (Connection con = dbContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlRooms);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                allRooms.add(rs.getString("RoomName"));
            }
        }

        String sql = "SELECT r.RoomName, " +
                     "CASE WHEN FORMAT(se.StartTime, 'HH:mm') < '12:00' THEN 'Ca sáng' ELSE 'Ca chiều' END AS Shift, " +
                     "CONVERT(varchar, se.SlotDate, 23) as Day, se.Role, u.FullName " +
                     "FROM Rooms r " +
                     "LEFT JOIN ScheduleEmployee se ON r.RoomID = se.RoomID AND se.SlotDate BETWEEN ? AND ? " +
                     "LEFT JOIN Users u ON se.UserID = u.UserID";
        try (Connection con = dbContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String room = rs.getString("RoomName");
                    String shift = rs.getString("Shift") != null ? rs.getString("Shift") : "Ca sáng";
                    String day = rs.getString("Day");
                    String role = rs.getString("Role");
                    String name = rs.getString("FullName");
                    if (day == null) continue;
                    scheduleData.putIfAbsent(room, new LinkedHashMap<>());
                    scheduleData.get(room).putIfAbsent(shift, new LinkedHashMap<>());
                    scheduleData.get(room).get(shift).putIfAbsent(day, new HashMap<>());
                    if (role != null && name != null) {
                        scheduleData.get(room).get(shift).get(day).put(role, name);
                    }
                }
            }
        }

        for (String room : allRooms) {
            scheduleData.putIfAbsent(room, new LinkedHashMap<>());
            for (String shift : new String[]{"Ca sáng", "Ca chiều"}) {
                scheduleData.get(room).putIfAbsent(shift, new LinkedHashMap<>());
                for (String day : days) {
                    scheduleData.get(room).get(shift).putIfAbsent(day, new HashMap<>());
                }
            }
        }
        result.put("scheduleData", scheduleData);
        result.put("days", days);
        result.put("dayNameMap", dayNameMap);
        result.put("startDate", days.isEmpty() ? startDate : days.get(0));
        result.put("endDate", days.isEmpty() ? endDate : days.get(days.size() - 1));
        return result;
    }
}