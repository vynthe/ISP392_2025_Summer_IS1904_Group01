package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import model.entity.Booking;

/**
 * DAO class to manage appointment bookings
 */
public class BookingDAO {

    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());
    private final DBContext dbContext;

    public BookingDAO() {
        this.dbContext = DBContext.getInstance();
    }

    /**
     * Get all bookings from both Appointments tables with pagination
     * 
     * @param offset starting index for pagination (0-based)
     * @param limit  number of records to retrieve
     * @return list of Booking objects
     * @throws SQLException if any DB error occurs
     */
    public List<Booking> getBookingsWithPagination(int offset, int limit) throws SQLException {
        List<Booking> bookings = new ArrayList<>();

        String sql = """
            SELECT 
                AppointmentID,
                PatientName,
                PatientPhone,
                PatientEmail,
                DoctorName,
                NurseName,
                ReceptionistName,
                RoomName,
                AppointmentTime,
                Status,
                ServiceInfo,
                CreatedAt,
                UpdatedAt
            FROM (
                SELECT 
                    a.AppointmentID,
                    u_patient.FullName AS PatientName,
                    u_patient.Phone AS PatientPhone,
                    u_patient.Email AS PatientEmail,
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
                UNION ALL
                SELECT 
                    ap2.id AS AppointmentID,
                    ap2.fullName AS PatientName,
                    ap2.phoneNumber AS PatientPhone,
                    ap2.email AS PatientEmail,
                    NULL AS DoctorName,
                    NULL AS NurseName,
                    NULL AS ReceptionistName,
                    NULL AS RoomName,
                    ap2.appointmentDate AS AppointmentTime,
                    ap2.status AS Status,
                    ap2.service AS ServiceInfo,
                    NULL AS CreatedAt,
                    NULL AS UpdatedAt
                FROM Appointments2 ap2
            ) AS combined_results
            ORDER BY COALESCE(AppointmentTime, '1970-01-01 00:00:00') DESC
            OFFSET ? ROWS
            FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, offset);
            stmt.setInt(2, limit);

            LOGGER.info("Executing SQL in getBookingsWithPagination: " + sql.replace("\n", " ") + 
                        ", OFFSET: " + offset + ", LIMIT: " + limit);

            try (ResultSet rs = stmt.executeQuery()) {
                int recordCount = 0;
                while (rs.next()) {
                    Booking booking = createBookingFromResultSet(rs);
                    bookings.add(booking);
                    recordCount++;
                    LOGGER.fine("Added Booking: ID=" + booking.getAppointmentID() + 
                                ", PatientName=" + booking.getPatientName() + 
                                ", AppointmentTime=" + booking.getAppointmentTime());
                }
                LOGGER.info("Fetched " + recordCount + " bookings for offset=" + offset + ", limit=" + limit);
                if (recordCount == 0 && offset > 0) {
                    LOGGER.warning("No bookings fetched for offset=" + offset + ", limit=" + limit + 
                                   ". Possible data issue or pagination error.");
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("SQLException in getBookingsWithPagination: " + e.getMessage() + 
                          " at " + java.time.LocalDateTime.now());
            throw e;
        }

        return bookings;
    }

    /**
     * Count the total number of bookings from both tables
     * 
     * @return total number of bookings
     * @throws SQLException if any DB error occurs
     */
    public int countAllBookings() throws SQLException {
        String sql = """
            SELECT 
                (SELECT COUNT(*) FROM Appointments) +
                (SELECT COUNT(*) FROM Appointments2) AS total
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                int count = rs.getInt("total");
                LOGGER.info("Total bookings count: " + count);
                return count;
            }
        } catch (SQLException e) {
            LOGGER.severe("SQLException in countAllBookings: " + e.getMessage() + 
                          " at " + java.time.LocalDateTime.now());
            throw e;
        }
        LOGGER.warning("No count returned from countAllBookings, returning 0");
        return 0;
    }

    public List<Booking> searchBookings(String keyword, String status, int offset, int limit) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT 
                AppointmentID,
                PatientName,
                PatientPhone,
                PatientEmail,
                DoctorName,
                NurseName,
                ReceptionistName,
                RoomName,
                AppointmentTime,
                Status,
                ServiceInfo,
                CreatedAt,
                UpdatedAt
            FROM (
                SELECT 
                    a.AppointmentID,
                    u_patient.FullName AS PatientName,
                    u_patient.Phone AS PatientPhone,
                    u_patient.Email AS PatientEmail,
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
                WHERE 1=1
        """);

        StringBuilder sql2Builder = new StringBuilder("""
                SELECT 
                    ap2.id AS AppointmentID,
                    ap2.fullName AS PatientName,
                    ap2.phoneNumber AS PatientPhone,
                    ap2.email AS PatientEmail,
                    NULL AS DoctorName,
                    NULL AS NurseName,
                    NULL AS ReceptionistName,
                    NULL AS RoomName,
                    ap2.appointmentDate AS AppointmentTime,
                    ap2.status AS Status,
                    ap2.service AS ServiceInfo,
                    NULL AS CreatedAt,
                    NULL AS UpdatedAt
                FROM Appointments2 ap2
                WHERE 1=1
        """);

        List<Object> parameters = new ArrayList<>();

        // Add keyword filter
        if (keyword != null && !keyword.trim().isEmpty()) {
            String likePattern = "%" + keyword.trim() + "%";
            sqlBuilder.append(" AND (u_patient.FullName LIKE ? OR u_patient.Phone LIKE ? OR u_patient.Email LIKE ?)");
            sql2Builder.append(" AND (ap2.fullName LIKE ? OR ap2.phoneNumber LIKE ? OR ap2.email LIKE ?)");
            parameters.add(likePattern);
            parameters.add(likePattern);
            parameters.add(likePattern);
        }

        // Add status filter
        if (status != null && !status.trim().isEmpty()) {
            sqlBuilder.append(" AND a.Status = ?");
            sql2Builder.append(" AND ap2.status = ?");
            parameters.add(status.trim());
        }

        // Combine the queries
        String finalSql = sqlBuilder.toString() + 
                         "\n                UNION ALL\n" + 
                         sql2Builder.toString() + 
                         "\n            ) AS combined_results" +
                         "\n            ORDER BY COALESCE(AppointmentTime, '1970-01-01 00:00:00') DESC" +
                         "\n            OFFSET ? ROWS" +
                         "\n            FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(finalSql)) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                for (int i = 0; i < 6; i++) {
                    stmt.setString(paramIndex++, (String) parameters.get(i % 3));
                }
            }
            if (status != null && !status.trim().isEmpty()) {
                stmt.setString(paramIndex++, status.trim());
                stmt.setString(paramIndex++, status.trim());
            }
            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex, limit);

            LOGGER.info("Executing SQL in searchBookings: " + finalSql.replace("\n", " ") + 
                        ", OFFSET: " + offset + ", LIMIT: " + limit);

            try (ResultSet rs = stmt.executeQuery()) {
                int recordCount = 0;
                while (rs.next()) {
                    Booking booking = createBookingFromResultSet(rs);
                    bookings.add(booking);
                    recordCount++;
                    LOGGER.fine("Added Booking: ID=" + booking.getAppointmentID() + 
                                ", PatientName=" + booking.getPatientName() + 
                                ", AppointmentTime=" + booking.getAppointmentTime());
                }
                LOGGER.info("Fetched " + recordCount + " bookings for offset=" + offset + ", limit=" + limit);
            }
        } catch (SQLException e) {
            LOGGER.severe("SQLException in searchBookings: " + e.getMessage() + 
                          " at " + java.time.LocalDateTime.now());
            throw e;
        }

        return bookings;
    }

    public int countSearchBookings(String keyword, String status) throws SQLException {
        StringBuilder sqlBuilder = new StringBuilder("""
            SELECT 
                (SELECT COUNT(*) 
                 FROM Appointments a
                 LEFT JOIN Users u_patient ON a.PatientID = u_patient.UserID
                 WHERE 1=1
        """);

        StringBuilder sql2Builder = new StringBuilder("""
                 SELECT COUNT(*) 
                 FROM Appointments2 ap2
                 WHERE 1=1
        """);

        List<Object> parameters = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            String likePattern = "%" + keyword.trim() + "%";
            sqlBuilder.append(" AND (u_patient.FullName LIKE ? OR u_patient.Phone LIKE ? OR u_patient.Email LIKE ?)");
            sql2Builder.append(" AND (ap2.fullName LIKE ? OR ap2.phoneNumber LIKE ? OR ap2.email LIKE ?)");
            parameters.add(likePattern);
            parameters.add(likePattern);
            parameters.add(likePattern);
        }

        if (status != null && !status.trim().isEmpty()) {
            sqlBuilder.append(" AND a.Status = ?");
            sql2Builder.append(" AND ap2.status = ?");
            parameters.add(status.trim());
        }

        String finalSql = sqlBuilder.toString() + ") + (" + sql2Builder.toString() + ") AS total";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(finalSql)) {
            
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                for (int i = 0; i < 6; i++) {
                    stmt.setString(paramIndex++, (String) parameters.get(i % 3));
                }
            }
            if (status != null && !status.trim().isEmpty()) {
                stmt.setString(paramIndex++, status.trim());
                stmt.setString(paramIndex, status.trim());
            }

            LOGGER.info("Executing SQL in countSearchBookings: " + finalSql.replace("\n", " "));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt("total");
                    LOGGER.info("Total search bookings count: " + count);
                    return count;
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("SQLException in countSearchBookings: " + e.getMessage() + 
                          " at " + java.time.LocalDateTime.now());
            throw e;
        }
        LOGGER.warning("No count returned from countSearchBookings, returning 0");
        return 0;
    }

    public List<Booking> getAllBookings() throws SQLException {
        return getBookingsWithPagination(0, Integer.MAX_VALUE);
    }

    private Booking createBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setAppointmentID(rs.getInt("AppointmentID"));
        booking.setPatientName(rs.getString("PatientName"));
        booking.setPatientPhone(rs.getString("PatientPhone"));
        booking.setPatientEmail(rs.getString("PatientEmail"));
        booking.setDoctorName(rs.getString("DoctorName"));
        booking.setNurseName(rs.getString("NurseName"));
        booking.setReceptionistName(rs.getString("ReceptionistName"));
        booking.setRoomName(rs.getString("RoomName"));
        booking.setAppointmentTime(rs.getTimestamp("AppointmentTime"));
        booking.setStatus(rs.getString("Status"));
        booking.setServiceInfo(rs.getString("ServiceInfo"));
        booking.setCreatedAt(rs.getTimestamp("CreatedAt"));
        booking.setUpdatedAt(rs.getTimestamp("UpdatedAt"));

        return booking;
    }
}