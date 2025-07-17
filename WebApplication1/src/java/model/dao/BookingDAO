package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.entity.Booking;

/**
 * DAO class to manage appointment bookings
 */
public class BookingDAO {

    private final DBContext dbContext;

    public BookingDAO() {
        this.dbContext = DBContext.getInstance();
    }

    /**
     * Get all bookings from the Appointments table (with joins to related users and room)
     * 
     * @return list of Booking objects
     * @throws SQLException if any DB error occurs
     */
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();

        String sql = """
            SELECT 
                a.AppointmentID,
                u_patient.FullName AS PatientName,
                u_doctor.FullName AS DoctorName,
                u_nurse.FullName AS NurseName,
                u_recep.FullName AS ReceptionistName,
                r.RoomName,
                a.AppointmentTime,
                a.Status,
                a.ServiceInfo,
                a.CreatedAt,
                a.UpdatedAt
            FROM Appointments a
            LEFT JOIN Users u_patient ON a.PatientID = u_patient.UserID
            LEFT JOIN Users u_doctor ON a.DoctorID = u_doctor.UserID
            LEFT JOIN Users u_nurse ON a.NurseID = u_nurse.UserID
            LEFT JOIN Users u_recep ON a.ReceptionistID = u_recep.UserID
            LEFT JOIN Rooms r ON a.RoomID = r.RoomID
            ORDER BY a.AppointmentTime DESC
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setAppointmentID(rs.getInt("AppointmentID"));
                b.setPatientName(rs.getString("PatientName"));
                b.setDoctorName(rs.getString("DoctorName"));
                b.setNurseName(rs.getString("NurseName"));
                b.setReceptionistName(rs.getString("ReceptionistName"));
                b.setRoomName(rs.getString("RoomName"));
                b.setAppointmentTime(rs.getTimestamp("AppointmentTime"));
                b.setStatus(rs.getString("Status"));
                b.setServiceInfo(rs.getString("ServiceInfo"));
                b.setCreatedAt(rs.getTimestamp("CreatedAt"));
                b.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                bookings.add(b);
            }

        } catch (SQLException e) {
            System.err.println("SQLException in getAllBookings: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            throw e;
        }

        return bookings;
    }
}
