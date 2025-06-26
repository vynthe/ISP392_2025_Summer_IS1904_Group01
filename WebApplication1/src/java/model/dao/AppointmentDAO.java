package model.dao;


import model.entity.Appointments;
import model.entity.Rooms;
import model.entity.Users;
import model.entity.Schedules;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    private Connection conn;

    public AppointmentDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Services> getServices() throws SQLException {
        List<Services> services = new ArrayList<>();
        String query = "SELECT ServiceID, ServiceName FROM Services WHERE Status = 'Active'";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Services service = new Services();
                service.setServiceID(rs.getInt("ServiceID"));
                service.setServiceName(rs.getString("ServiceName"));
                services.add(service);
            }
        }
        return services;
    }

    public List<Rooms> getRoomsByService(int serviceID) throws SQLException {
        List<Rooms> rooms = new ArrayList<>();
        String query = "SELECT * FROM Rooms WHERE Status = 'Available'";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomID(rs.getInt("RoomID"));
                room.setRoomName(rs.getString("RoomName"));
                room.setDescription(rs.getString("Description"));
                room.setDoctorID(rs.getInt("DoctorID"));
                room.setNurseID(rs.getInt("NurseID"));
                room.setStatus(rs.getString("Status"));
                room.setCreatedBy(rs.getInt("CreatedBy"));
                room.setCreatedAt(rs.getDate("CreatedAt"));
                room.setUpdatedAt(rs.getDate("UpdatedAt"));
                rooms.add(room);
            }
        }
        return rooms;
    }

    public List<Users> getDoctorsByService(int serviceID) throws SQLException {
        List<Users> doctors = new ArrayList<>();
        String query = "SELECT u.* FROM Users u JOIN Rooms r ON u.UserID = r.DoctorID WHERE u.Role = 'Doctor' AND u.Status = 'Active'";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Users doctor = new Users();
                doctor.setUserID(rs.getInt("UserID"));
                doctor.setFullName(rs.getString("FullName"));
                doctor.setRole(rs.getString("Role"));
                doctor.setStatus(rs.getString("Status"));
                doctors.add(doctor);
            }
        }
        return doctors;
    }

    public List<Schedules> getSchedulesByDoctor(int doctorID) throws SQLException {
        List<Schedules> schedules = new ArrayList<>();
        String query = "SELECT * FROM Schedules WHERE employeeID = ? AND role = 'Doctor' AND status = 'Available'";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, doctorID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Schedules schedule = new Schedules();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setEmployeeID(rs.getInt("employeeID"));
                schedule.setRole(rs.getString("role"));
                schedule.setStartTime(rs.getDate("startTime"));
                schedule.setEndTime(rs.getDate("endTime"));
                schedule.setDayOfWeek(rs.getString("dayOfWeek"));
                schedule.setRoomID(rs.getInt("roomID"));
                schedule.setStatus(rs.getString("status"));
                schedule.setCreatedBy(rs.getInt("createdBy"));
                schedule.setCreatedAt(rs.getDate("createdAt"));
                schedule.setUpdatedAt(rs.getDate("updatedAt"));
                schedule.setShiftStart(rs.getTime("shiftStart"));
                schedule.setShiftEnd(rs.getTime("shiftEnd"));
                schedules.add(schedule);
            }
        }
        return schedules;
    }

    public boolean bookAppointment(Appointments appointment) throws SQLException {
        String query = "INSERT INTO Appointments (PatientID, DoctorID, NurseID, RoomID, AppointmentTime, Status, CreatedBy) " +
                      "VALUES (?, ?, ?, ?, ?, 'Pending', ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setObject(1, appointment.getPatientID(), Types.INTEGER);
            stmt.setInt(2, appointment.getDoctorID());
            stmt.setInt(3, appointment.getNurseID());
            stmt.setInt(4, appointment.getRoomID());
            stmt.setTimestamp(5, new Timestamp(appointment.getAppointmentTime().getTime()));
            stmt.setInt(6, appointment.getCreatedBy());
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public boolean bookSimpleAppointment(String fullName, String phoneNumber, String email, String service, Timestamp appointmentTime) throws SQLException {
        String query = "INSERT INTO appointments2 (fullName, phoneNumber, email, service, appointmentDate, status) VALUES (?, ?, ?, ?, ?, 'Pending')";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, fullName);
            stmt.setString(2, phoneNumber);
            stmt.setString(3, email);
            stmt.setString(4, service);
            stmt.setTimestamp(5, appointmentTime);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public static class Services {
        private int serviceID;
        private String serviceName;

        public int getServiceID() { return serviceID; }
        public void setServiceID(int serviceID) { this.serviceID = serviceID; }
        public String getServiceName() { return serviceName; }
        public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    }
}