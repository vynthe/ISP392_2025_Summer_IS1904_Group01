package model.dao;

import model.entity.Prescriptions;
import model.entity.Medication;
import model.service.MedicationService;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PrescriptionDAO {
    private final DBContext dbContext;
    private final MedicationService medicationService;

    public PrescriptionDAO() {
        this.dbContext = DBContext.getInstance();
        this.medicationService = new MedicationService();
    }

    private boolean validateForeignKeys(Connection conn, Prescriptions prescription) throws SQLException {
        String checkPatient = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Patient'";
        String checkDoctor = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Doctor'";

        try (PreparedStatement pstmt1 = conn.prepareStatement(checkPatient);
             PreparedStatement pstmt2 = conn.prepareStatement(checkDoctor)) {
            pstmt1.setInt(1, prescription.getPatientId());
            pstmt2.setInt(1, prescription.getDoctorId());

            if (!pstmt1.executeQuery().next()) {
                throw new SQLException("Invalid PatientID: " + prescription.getPatientId());
            }
            if (!pstmt2.executeQuery().next()) {
                throw new SQLException("Invalid DoctorID: " + prescription.getDoctorId());
            }
            return true;
        }
    }

    public boolean addPrescription(Prescriptions prescription, List<Integer> medicationIds, List<String> dosageInstructions) throws SQLException {
        if (prescription == null) {
            throw new SQLException("Prescription object cannot be null.");
        }

        String sqlPrescription = "INSERT INTO Prescriptions (PatientID, DoctorID, PrescriptionDetails, Status) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);
            validateForeignKeys(conn, prescription);

            // Insert prescription
            int prescriptionId;
            try (PreparedStatement pstmt = conn.prepareStatement(sqlPrescription, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setInt(1, prescription.getPatientId());
                pstmt.setInt(2, prescription.getDoctorId());
                pstmt.setString(3, prescription.getPrescriptionDetails());
                pstmt.setString(4, prescription.getStatus());

                int affectedRows = pstmt.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Failed to insert prescription.");
                }
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        prescriptionId = generatedKeys.getInt(1);
                        prescription.setPrescriptionId(prescriptionId);
                    } else {
                        throw new SQLException("Failed to retrieve generated prescription ID.");
                    }
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Rollback failed: " + rollbackEx.getMessage());
                }
            }
            e.printStackTrace();
            System.err.println("SQLException in addPrescription: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    System.err.println("Failed to close connection: " + closeEx.getMessage());
                }
            }
        }
    }

    public List<Medication> getAllMedications() throws SQLException {
        try {
            return medicationService.getAllMedications();
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getAllMedications: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
    }

    public List<Prescriptions> getAllPrescriptions() throws SQLException {
        List<Prescriptions> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM Prescriptions WHERE Status != 'CANCELLED'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getAllPrescriptions: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return prescriptions;
    }

    public Prescriptions getPrescriptionById(int prescriptionId) throws SQLException {
        String sql = "SELECT * FROM Prescriptions WHERE PrescriptionID = ? AND Status != 'CANCELLED'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, prescriptionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPrescription(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getPrescriptionById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    public List<Prescriptions> getPrescriptionsByPage(int page, int pageSize) throws SQLException {
        List<Prescriptions> prescriptions = new ArrayList<>();
        String sql = "SELECT p.* FROM Prescriptions p WHERE p.Status != 'CANCELLED' " +
                     "ORDER BY p.PrescriptionID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    prescriptions.add(mapResultSetToPrescription(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getPrescriptionsByPage: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return prescriptions;
    }

    public int getTotalPrescriptionCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Prescriptions WHERE Status != 'CANCELLED'";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getTotalPrescriptionCount: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return 0;
    }

    public List<Prescriptions> searchPrescriptionsByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword, int page, int pageSize) throws SQLException {
        List<Prescriptions> prescriptions = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.* FROM Prescriptions p " +
            "JOIN Users u ON p.PatientID = u.UserID " +
            "WHERE p.Status != 'CANCELLED'"
        );
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        if (patientNameKeyword != null && !patientNameKeyword.trim().isEmpty()) {
            conditions.add("u.FullName LIKE ?");
            parameters.add("%" + patientNameKeyword.trim() + "%");
        }
        if (medicationNameKeyword != null && !medicationNameKeyword.trim().isEmpty()) {
            conditions.add("p.PrescriptionDetails LIKE ?");
            parameters.add("%" + medicationNameKeyword.trim() + "%");
        }

        if (!conditions.isEmpty()) {
            sql.append(" AND ").append(String.join(" AND ", conditions));
        }
        sql.append(" ORDER BY p.PrescriptionID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : parameters) {
                pstmt.setObject(paramIndex++, param);
            }
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);
            pstmt.setInt(paramIndex, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    prescriptions.add(mapResultSetToPrescription(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in searchPrescriptionsByPatientAndMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return prescriptions;
    }

    public int getTotalCountByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM Prescriptions p " +
            "JOIN Users u ON p.PatientID = u.UserID " +
            "WHERE p.Status != 'CANCELLED'"
        );
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        if (patientNameKeyword != null && !patientNameKeyword.trim().isEmpty()) {
            conditions.add("u.FullName LIKE ?");
            parameters.add("%" + patientNameKeyword.trim() + "%");
        }
        if (medicationNameKeyword != null && !medicationNameKeyword.trim().isEmpty()) {
            conditions.add("p.PrescriptionDetails LIKE ?");
            parameters.add("%" + medicationNameKeyword.trim() + "%");
        }

        if (!conditions.isEmpty()) {
            sql.append(" AND ").append(String.join(" AND ", conditions));
        }

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : parameters) {
                pstmt.setObject(paramIndex++, param);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getTotalCountByPatientAndMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return 0;
    }

    private Prescriptions mapResultSetToPrescription(ResultSet rs) throws SQLException {
        Prescriptions prescription = new Prescriptions();
        prescription.setPrescriptionId(rs.getInt("PrescriptionID"));
        prescription.setPatientId(rs.getInt("PatientID"));
        prescription.setDoctorId(rs.getInt("DoctorID"));
        prescription.setPrescriptionDetails(rs.getString("PrescriptionDetails"));
        prescription.setStatus(rs.getString("Status"));
        return prescription;
    }
}