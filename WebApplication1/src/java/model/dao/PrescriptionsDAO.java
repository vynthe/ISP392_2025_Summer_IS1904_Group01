package model.dao;

import model.entity.Prescriptions;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrescriptionsDAO {
    private final DBContext dbContext;

    public PrescriptionsDAO() {
        this.dbContext = DBContext.getInstance();
    }

    // Thêm toa thuốc mới
    public boolean addPrescription(Prescriptions p) throws SQLException {
        String sql = "INSERT INTO Prescriptions (ResultID, AppointmentID, DoctorID, PatientID, PrescriptionDetails, Status, CreatedBy, CreatedAt, UpdatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, p.getResultID());
            stmt.setInt(2, p.getAppointmentID());
            stmt.setInt(3, p.getDoctorID());
            stmt.setInt(4, p.getPatientID());
            stmt.setString(5, p.getPrescriptionDetails());
            stmt.setString(6, p.getStatus());
            stmt.setInt(7, p.getCreatedBy());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in addPrescription: " + e.getMessage());
            throw e;
        }
    }

    // Lấy toa thuốc theo ID
    public Prescriptions getPrescriptionByID(int id) throws SQLException {
        String sql = "SELECT * FROM Prescriptions WHERE PrescriptionID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Prescriptions p = new Prescriptions();
                    p.setPrescriptionID(rs.getInt("PrescriptionID"));
                    p.setResultID(rs.getInt("ResultID"));
                    p.setAppointmentID(rs.getInt("AppointmentID"));
                    p.setDoctorID(rs.getInt("DoctorID"));
                    p.setPatientID(rs.getInt("PatientID"));
                    p.setPrescriptionDetails(rs.getString("PrescriptionDetails"));
                    p.setStatus(rs.getString("Status"));
                    p.setCreatedBy(rs.getInt("CreatedBy"));
                    p.setCreatedAt(rs.getDate("CreatedAt"));
                    p.setUpdatedAt(rs.getDate("UpdatedAt"));
                    return p;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getPrescriptionByID: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // Lấy danh sách tất cả toa thuốc
    public List<Prescriptions> getAllPrescriptions() throws SQLException {
        List<Prescriptions> list = new ArrayList<>();
        String sql = "SELECT * FROM Prescriptions";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Prescriptions p = new Prescriptions();
                p.setPrescriptionID(rs.getInt("PrescriptionID"));
                p.setResultID(rs.getInt("ResultID"));
                p.setAppointmentID(rs.getInt("AppointmentID"));
                p.setDoctorID(rs.getInt("DoctorID"));
                p.setPatientID(rs.getInt("PatientID"));
                p.setPrescriptionDetails(rs.getString("PrescriptionDetails"));
                p.setStatus(rs.getString("Status"));
                p.setCreatedBy(rs.getInt("CreatedBy"));
                p.setCreatedAt(rs.getDate("CreatedAt"));
                p.setUpdatedAt(rs.getDate("UpdatedAt"));
                list.add(p);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllPrescriptions: " + e.getMessage());
            throw e;
        }
        return list;
    }
}
