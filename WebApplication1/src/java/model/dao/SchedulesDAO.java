package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.entity.Schedules;
import model.entity.Rooms;

public class SchedulesDAO {
    private final DBContext dbContext;
    private final RoomsDAO roomsDAO;

    public SchedulesDAO() {
        this.dbContext = DBContext.getInstance();
        this.roomsDAO = new RoomsDAO();
    }

    private boolean isValidTimeSlot(Date startTime, Date endTime) {
        if (startTime == null || endTime == null) return false;
        if (startTime.after(endTime)) {
            return false;
        }
        return true;
    }

    private boolean isValidDayOfWeek(String dayOfWeek) {
        if (dayOfWeek == null) return false;
        String[] validDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
        for (String day : validDays) {
            if (day.equalsIgnoreCase(dayOfWeek)) {
                return true;
            }
        }
        return false;
    }

    public boolean createSchedule(Schedules schedule) throws SQLException {
        if (schedule == null) {
            throw new SQLException("Schedule object cannot be null.");
        }

        if (!isValidTimeSlot(schedule.getStartTime(), schedule.getEndTime())) {
            return false;
        }

        if (!isValidDayOfWeek(schedule.getDayOfWeek())) {
            return false;
        }

        Rooms room = roomsDAO.getRoomByID(schedule.getRoomID());
        if (room == null || !room.getStatus().equals("Available")) {
            return false;
        }

        schedule.setDoctorID(room.getDoctorID());
        schedule.setNurseID(room.getNurseID());

        String query = "INSERT INTO Schedules (DoctorID, NurseID, StartTime, EndTime, DayOfWeek, RoomID, [Status], CreatedBy, CreatedAt, UpdatedAt) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, schedule.getDoctorID());
            stmt.setInt(2, schedule.getNurseID());
            stmt.setDate(3, schedule.getStartTime());
            stmt.setDate(4, schedule.getEndTime());
            stmt.setString(5, schedule.getDayOfWeek());
            stmt.setInt(6, schedule.getRoomID());
            stmt.setString(7, "Available");
            stmt.setInt(8, schedule.getCreatedBy());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in createSchedule: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public boolean updateSchedule(Schedules schedule) throws SQLException {
        if (schedule == null) {
            throw new SQLException("Schedule object cannot be null.");
        }

        if (!isValidTimeSlot(schedule.getStartTime(), schedule.getEndTime())) {
            return false;
        }

        if (!isValidDayOfWeek(schedule.getDayOfWeek())) {
            return false;
        }

        Rooms room = roomsDAO.getRoomByID(schedule.getRoomID());
        if (room == null || !room.getStatus().equals("Available")) {
            return false;
        }

        schedule.setDoctorID(room.getDoctorID());
        schedule.setNurseID(room.getNurseID());

        String query = "UPDATE Schedules SET DoctorID = ?, NurseID = ?, StartTime = ?, EndTime = ?, DayOfWeek = ?, " +
                      "RoomID = ?, [Status] = ?, CreatedBy = ?, UpdatedAt = GETDATE() WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, schedule.getDoctorID());
            stmt.setInt(2, schedule.getNurseID());
            stmt.setDate(3, schedule.getStartTime());
            stmt.setDate(4, schedule.getEndTime());
            stmt.setString(5, schedule.getDayOfWeek());
            stmt.setInt(6, schedule.getRoomID());
            stmt.setString(7, schedule.getStatus());
            stmt.setInt(8, schedule.getCreatedBy());
            stmt.setInt(9, schedule.getScheduleID());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("SQLException in updateSchedule: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public List<Map<String, Object>> getSchedulesByDoctorId(Integer doctorID) throws SQLException {
        List<Map<String, Object>> schedulesList = new ArrayList<>();
        String scheduleQuery = "SELECT ScheduleID, DoctorID, NurseID, StartTime, EndTime, DayOfWeek, RoomID, [Status] FROM Schedules";
        if (doctorID != null) {
            scheduleQuery += " WHERE DoctorID = ? AND [Status] = 'Available'";
        } else {
            scheduleQuery += " WHERE [Status] = 'Available'";
        }

        try (Connection conn = dbContext.getConnection();
             PreparedStatement scheduleStmt = conn.prepareStatement(scheduleQuery)) {
            if (doctorID != null) {
                scheduleStmt.setInt(1, doctorID);
            }
            try (ResultSet scheduleRs = scheduleStmt.executeQuery()) {
                while (scheduleRs.next()) {
                    Map<String, Object> scheduleData = new HashMap<>();
                    scheduleData.put("ScheduleID", scheduleRs.getInt("ScheduleID"));
                    scheduleData.put("DoctorID", scheduleRs.getInt("DoctorID"));
                    scheduleData.put("NurseID", scheduleRs.getInt("NurseID"));
                    scheduleData.put("StartTime", scheduleRs.getDate("StartTime"));
                    scheduleData.put("EndTime", scheduleRs.getDate("EndTime"));
                    scheduleData.put("DayOfWeek", scheduleRs.getString("DayOfWeek"));
                    scheduleData.put("RoomID", scheduleRs.getInt("RoomID"));
                    scheduleData.put("Status", scheduleRs.getString("Status"));

                    String roomQuery = "SELECT RoomID, RoomName, [Description] FROM Rooms WHERE RoomID = ?";
                    try (PreparedStatement roomStmt = conn.prepareStatement(roomQuery)) {
                        roomStmt.setInt(1, scheduleRs.getInt("RoomID"));
                        try (ResultSet roomRs = roomStmt.executeQuery()) {
                            if (roomRs.next()) {
                                scheduleData.put("RoomName", roomRs.getString("RoomName"));
                                scheduleData.put("RoomDescription", roomRs.getString("Description"));
                            }
                        }
                    }

                    schedulesList.add(scheduleData);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByDoctorId: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return schedulesList;
    }

    public List<Map<String, Object>> getAllSchedules() throws SQLException {
        List<Map<String, Object>> schedulesList = new ArrayList<>();
        String scheduleQuery = "SELECT ScheduleID, DoctorID, NurseID, StartTime, EndTime, DayOfWeek, RoomID, [Status] FROM Schedules WHERE [Status] = 'Available'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement scheduleStmt = conn.prepareStatement(scheduleQuery)) {
            try (ResultSet scheduleRs = scheduleStmt.executeQuery()) {
                while (scheduleRs.next()) {
                    Map<String, Object> scheduleData = new HashMap<>();
                    scheduleData.put("ScheduleID", scheduleRs.getInt("ScheduleID"));
                    scheduleData.put("DoctorID", scheduleRs.getInt("DoctorID"));
                    scheduleData.put("NurseID", scheduleRs.getInt("NurseID"));
                    scheduleData.put("StartTime", scheduleRs.getDate("StartTime"));
                    scheduleData.put("EndTime", scheduleRs.getDate("EndTime"));
                    scheduleData.put("DayOfWeek", scheduleRs.getString("DayOfWeek"));
                    scheduleData.put("RoomID", scheduleRs.getInt("RoomID"));
                    scheduleData.put("Status", scheduleRs.getString("Status"));

                    String roomQuery = "SELECT RoomID, RoomName, [Description] FROM Rooms WHERE RoomID = ?";
                    try (PreparedStatement roomStmt = conn.prepareStatement(roomQuery)) {
                        roomStmt.setInt(1, scheduleRs.getInt("RoomID"));
                        try (ResultSet roomRs = roomStmt.executeQuery()) {
                            if (roomRs.next()) {
                                scheduleData.put("RoomName", roomRs.getString("RoomName"));
                                scheduleData.put("RoomDescription", roomRs.getString("Description"));
                            }
                        }
                    }

                    // Add Doctor and Nurse names for admin view
                    String doctorQuery = "SELECT UserID, FullName FROM Users WHERE UserID = ?";
                    try (PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery)) {
                        doctorStmt.setInt(1, scheduleRs.getInt("DoctorID"));
                        try (ResultSet doctorRs = doctorStmt.executeQuery()) {
                            if (doctorRs.next()) {
                                scheduleData.put("DoctorName", doctorRs.getString("FullName"));
                            }
                        }
                    }

                    String nurseQuery = "SELECT UserID, FullName FROM Users WHERE UserID = ?";
                    try (PreparedStatement nurseStmt = conn.prepareStatement(nurseQuery)) {
                        nurseStmt.setInt(1, scheduleRs.getInt("NurseID"));
                        try (ResultSet nurseRs = nurseStmt.executeQuery()) {
                            if (nurseRs.next()) {
                                scheduleData.put("NurseName", nurseRs.getString("FullName"));
                            }
                        }
                    }

                    schedulesList.add(scheduleData);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllSchedules: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return schedulesList;
    }

    public List<Map<String, Object>> getSchedulesByRoleAndUserId(String role, Integer userId) throws SQLException {
        List<Map<String, Object>> schedulesList = new ArrayList<>();
        String scheduleQuery = "SELECT ScheduleID, DoctorID, NurseID, StartTime, EndTime, DayOfWeek, RoomID, [Status] FROM Schedules WHERE [Status] = 'Available'";

        if ("doctor".equalsIgnoreCase(role) || "nurse".equalsIgnoreCase(role)) {
            // Doctors and nurses can only see their own schedules
            String roomQuery = "SELECT RoomID FROM Rooms WHERE " + 
                             (role.equalsIgnoreCase("doctor") ? "DoctorID" : "NurseID") + " = ?";
            try (Connection conn = dbContext.getConnection();
                 PreparedStatement roomStmt = conn.prepareStatement(roomQuery)) {
                roomStmt.setInt(1, userId);
                try (ResultSet roomRs = roomStmt.executeQuery()) {
                    List<Integer> roomIds = new ArrayList<>();
                    while (roomRs.next()) {
                        roomIds.add(roomRs.getInt("RoomID"));
                    }
                    if (!roomIds.isEmpty()) {
                        scheduleQuery += " AND RoomID IN (" + String.join(",", roomIds.stream().map(String::valueOf).toArray(String[]::new)) + ")";
                    } else {
                        return schedulesList; // Return empty list if no rooms found
                    }
                }
            }
        } // Admin and receptionist see all schedules (no additional filter)

        try (Connection conn = dbContext.getConnection();
             PreparedStatement scheduleStmt = conn.prepareStatement(scheduleQuery)) {
            try (ResultSet scheduleRs = scheduleStmt.executeQuery()) {
                while (scheduleRs.next()) {
                    Map<String, Object> scheduleData = new HashMap<>();
                    scheduleData.put("ScheduleID", scheduleRs.getInt("ScheduleID"));
                    scheduleData.put("DoctorID", scheduleRs.getInt("DoctorID"));
                    scheduleData.put("NurseID", scheduleRs.getInt("NurseID"));
                    scheduleData.put("StartTime", scheduleRs.getDate("StartTime"));
                    scheduleData.put("EndTime", scheduleRs.getDate("EndTime"));
                    scheduleData.put("DayOfWeek", scheduleRs.getString("DayOfWeek"));
                    scheduleData.put("RoomID", scheduleRs.getInt("RoomID"));
                    scheduleData.put("Status", scheduleRs.getString("Status"));

                    String roomQuery = "SELECT RoomID, RoomName, [Description] FROM Rooms WHERE RoomID = ?";
                    try (PreparedStatement roomStmt = conn.prepareStatement(roomQuery)) {
                        roomStmt.setInt(1, scheduleRs.getInt("RoomID"));
                        try (ResultSet roomRs = roomStmt.executeQuery()) {
                            if (roomRs.next()) {
                                scheduleData.put("RoomName", roomRs.getString("RoomName"));
                                scheduleData.put("RoomDescription", roomRs.getString("Description"));
                            }
                        }
                    }

                    // Add Doctor and Nurse names for all views
                    String doctorQuery = "SELECT UserID, FullName FROM Users WHERE UserID = ?";
                    try (PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery)) {
                        doctorStmt.setInt(1, scheduleRs.getInt("DoctorID"));
                        try (ResultSet doctorRs = doctorStmt.executeQuery()) {
                            if (doctorRs.next()) {
                                scheduleData.put("DoctorName", doctorRs.getString("FullName"));
                            }
                        }
                    }

                    String nurseQuery = "SELECT UserID, FullName FROM Users WHERE UserID = ?";
                    try (PreparedStatement nurseStmt = conn.prepareStatement(nurseQuery)) {
                        nurseStmt.setInt(1, scheduleRs.getInt("NurseID"));
                        try (ResultSet nurseRs = nurseStmt.executeQuery()) {
                            if (nurseRs.next()) {
                                scheduleData.put("NurseName", nurseRs.getString("FullName"));
                            }
                        }
                    }

                    schedulesList.add(scheduleData);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getSchedulesByRoleAndUserId: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return schedulesList;
    }

    public Map<String, Object> getRoomDetailsByScheduleId(int scheduleID) throws SQLException {
        Map<String, Object> roomDetails = new HashMap<>();

        String scheduleQuery = "SELECT ScheduleID, RoomID FROM Schedules WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement scheduleStmt = conn.prepareStatement(scheduleQuery)) {
            scheduleStmt.setInt(1, scheduleID);
            try (ResultSet scheduleRs = scheduleStmt.executeQuery()) {
                if (scheduleRs.next()) {
                    roomDetails.put("ScheduleID", scheduleRs.getInt("ScheduleID"));
                    int roomID = scheduleRs.getInt("RoomID");
                    roomDetails.put("RoomID", roomID);

                    String roomQuery = "SELECT RoomID, RoomName, [Description], DoctorID, NurseID FROM Rooms WHERE RoomID = ?";
                    try (PreparedStatement roomStmt = conn.prepareStatement(roomQuery)) {
                        roomStmt.setInt(1, roomID);
                        try (ResultSet roomRs = roomStmt.executeQuery()) {
                            if (roomRs.next()) {
                                roomDetails.put("RoomName", roomRs.getString("RoomName"));
                                roomDetails.put("RoomDescription", roomRs.getString("Description"));
                                int doctorID = roomRs.getInt("DoctorID");
                                int nurseID = roomRs.getInt("NurseID");
                                roomDetails.put("DoctorID", doctorID);
                                roomDetails.put("NurseID", nurseID);

                                String doctorQuery = "SELECT UserID, FullName FROM Users WHERE UserID = ?";
                                try (PreparedStatement doctorStmt = conn.prepareStatement(doctorQuery)) {
                                    doctorStmt.setInt(1, doctorID);
                                    try (ResultSet doctorRs = doctorStmt.executeQuery()) {
                                        if (doctorRs.next()) {
                                            roomDetails.put("DoctorName", doctorRs.getString("FullName"));
                                        }
                                    }
                                }

                                String nurseQuery = "SELECT UserID, FullName FROM Users WHERE UserID = ?";
                                try (PreparedStatement nurseStmt = conn.prepareStatement(nurseQuery)) {
                                    nurseStmt.setInt(1, nurseID);
                                    try (ResultSet nurseRs = nurseStmt.executeQuery()) {
                                        if (nurseRs.next()) {
                                            roomDetails.put("NurseName", nurseRs.getString("FullName"));
                                        }
                                    }
                                }

                                List<Map<String, Object>> services = new ArrayList<>();
                                String serviceQuery = "SELECT rs.ServiceID, sv.ServiceName, sv.[Description] " +
                                                     "FROM RoomServices rs " +
                                                     "INNER JOIN Services sv ON rs.ServiceID = sv.ServiceID " +
                                                     "WHERE rs.RoomID = ?";
                                try (PreparedStatement serviceStmt = conn.prepareStatement(serviceQuery)) {
                                    serviceStmt.setInt(1, roomID);
                                    try (ResultSet serviceRs = serviceStmt.executeQuery()) {
                                        while (serviceRs.next()) {
                                            Map<String, Object> serviceData = new HashMap<>();
                                            serviceData.put("ServiceID", serviceRs.getInt("ServiceID"));
                                            serviceData.put("ServiceName", serviceRs.getString("ServiceName"));
                                            serviceData.put("ServiceDescription", serviceRs.getString("Description"));
                                            services.add(serviceData);
                                        }
                                    }
                                }
                                roomDetails.put("Services", services);

                                List<Map<String, Object>> patientHistory = new ArrayList<>();
                                String patientQuery = "SELECT er.ResultID, er.PatientID, er.ResultDetails, u.FullName AS PatientName " +
                                                     "FROM Appointments a " +
                                                     "INNER JOIN ExaminationResults er ON a.AppointmentID = er.AppointmentID " +
                                                     "INNER JOIN Users u ON er.PatientID = u.UserID " +
                                                     "WHERE a.RoomID = ? AND a.[Status] IN ('Pending', 'Approved')";
                                try (PreparedStatement patientStmt = conn.prepareStatement(patientQuery)) {
                                    patientStmt.setInt(1, roomID);
                                    try (ResultSet patientRs = patientStmt.executeQuery()) {
                                        while (patientRs.next()) {
                                            Map<String, Object> patientData = new HashMap<>();
                                            patientData.put("ResultID", patientRs.getInt("ResultID"));
                                            patientData.put("PatientID", patientRs.getInt("PatientID"));
                                            patientData.put("PatientName", patientRs.getString("PatientName"));
                                            patientData.put("ResultDetails", patientRs.getString("ResultDetails"));
                                            patientHistory.add(patientData);
                                        }
                                    }
                                }
                                roomDetails.put("PatientHistory", patientHistory);
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getRoomDetailsByScheduleId: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return roomDetails;
    }

    // Phương thức getScheduleById cần thiết cho SchedulesService
    public Schedules getScheduleById(int scheduleID) throws SQLException {
        String query = "SELECT ScheduleID, DoctorID, NurseID, StartTime, EndTime, DayOfWeek, RoomID, [Status], CreatedBy, CreatedAt, UpdatedAt FROM Schedules WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Schedules schedule = new Schedules();
                    schedule.setScheduleID(rs.getInt("ScheduleID"));
                    schedule.setDoctorID(rs.getInt("DoctorID"));
                    schedule.setNurseID(rs.getInt("NurseID"));
                    schedule.setStartTime(rs.getDate("StartTime"));
                    schedule.setEndTime(rs.getDate("EndTime"));
                    schedule.setDayOfWeek(rs.getString("DayOfWeek"));
                    schedule.setRoomID(rs.getInt("RoomID"));
                    schedule.setStatus(rs.getString("Status"));
                    schedule.setCreatedBy(rs.getInt("CreatedBy"));
                    schedule.setCreatedAt(rs.getDate("CreatedAt"));
                    schedule.setUpdatedAt(rs.getDate("UpdatedAt"));
                    return schedule;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getScheduleById: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    // Phương thức deleteSchedule cần thiết cho SchedulesService
    public boolean deleteSchedule(int scheduleID) throws SQLException {
        String query = "DELETE FROM Schedules WHERE ScheduleID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, scheduleID);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Schedule with ID " + scheduleID + " not found.");
            }
            return true;
        } catch (SQLException e) {
            System.err.println("SQLException in deleteSchedule: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }
    }
}