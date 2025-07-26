package model.dao;

import model.entity.Prescriptions;
import model.entity.Medication;
import model.service.MedicationService;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PrescriptionDAO {

    public final DBContext dbContext;
    private final MedicationService medicationService;

    public PrescriptionDAO() {
        this.dbContext = DBContext.getInstance();
        this.medicationService = new MedicationService();
    }

  public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId) throws SQLException {
    String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.NurseID, " +
                 "d.FullName as doctorName, p.FullName as patientName, " +
                 "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes " +
                 "FROM ExaminationResults r " +
                 "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                 "LEFT JOIN Users p ON r.PatientID = p.UserID " +
                 "LEFT JOIN Users n ON r.NurseID = n.UserID " +
                 "LEFT JOIN Services s ON r.ServiceID = s.ServiceID " +
                 "WHERE r.PatientID = ?";
    
    System.out.println("DEBUG - SQL Query: " + sql);
    System.out.println("DEBUG - PatientID parameter: " + patientId);
    
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, patientId);
        try (ResultSet rs = pstmt.executeQuery()) {
            List<Map<String, Object>> results = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("resultId", rs.getInt("ResultID"));
                row.put("appointmentId", rs.getInt("AppointmentID"));
                row.put("doctorId", rs.getInt("DoctorID"));
                row.put("patientId", rs.getInt("PatientID"));
                
                // Thêm NurseID với null check
                int nurseId = rs.getInt("NurseID");
                if (!rs.wasNull()) {
                    row.put("nurseId", nurseId);
                } else {
                    row.put("nurseId", null);
                }
                
                row.put("doctorName", rs.getString("doctorName"));
                row.put("patientName", rs.getString("patientName"));
                row.put("nurseName", rs.getString("nurseName"));
                row.put("serviceName", rs.getString("ServiceName"));
                row.put("diagnosis", rs.getString("Diagnosis"));
                row.put("notes", rs.getString("Notes"));
                row.put("createdAt", rs.getTimestamp("CreatedAt"));
                row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                
                System.out.println("DEBUG - Row added: " + row);
                results.add(row);
            }
            System.out.println("DEBUG - Total results found: " + results.size());
            return results;
        }
    } catch (SQLException e) {
        System.err.println("DEBUG - SQL Exception: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}

public List<Map<String, Object>> getAllExaminationResults() throws SQLException {
    String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.NurseID, " +
                 "d.FullName as doctorName, p.FullName as patientName, " +
                 "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes " +
                 "FROM ExaminationResults r " +
                 "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                 "LEFT JOIN Users p ON r.PatientID = p.UserID " +
                 "LEFT JOIN Users n ON r.NurseID = n.UserID " +
                 "LEFT JOIN Services s ON r.ServiceID = s.ServiceID";
    
    System.out.println("DEBUG - SQL Query for all results: " + sql);
    
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {
        List<Map<String, Object>> results = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("resultId", rs.getInt("ResultID"));
            row.put("appointmentId", rs.getInt("AppointmentID"));
            row.put("doctorId", rs.getInt("DoctorID"));
            row.put("patientId", rs.getInt("PatientID"));
            
            // Thêm NurseID với null check
            int nurseId = rs.getInt("NurseID");
            if (!rs.wasNull()) {
                row.put("nurseId", nurseId);
            } else {
                row.put("nurseId", null);
            }
            
            row.put("doctorName", rs.getString("doctorName"));
            row.put("patientName", rs.getString("patientName"));
            row.put("nurseName", rs.getString("nurseName"));
            row.put("serviceName", rs.getString("ServiceName"));
            row.put("diagnosis", rs.getString("Diagnosis"));
            row.put("notes", rs.getString("Notes"));
            row.put("createdAt", rs.getTimestamp("CreatedAt"));
            row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
            
            System.out.println("DEBUG - Row added: " + row);
            results.add(row);
        }
        System.out.println("DEBUG - Total results found: " + results.size());
        return results;
    } catch (SQLException e) {
        System.err.println("DEBUG - SQL Exception: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}

public List<Map<String, Object>> getExaminationResultsByPatientName(String patientName) throws SQLException {
    String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.NurseID, " +
                 "d.FullName as doctorName, p.FullName as patientName, " +
                 "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes " +
                 "FROM ExaminationResults r " +
                 "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                 "LEFT JOIN Users p ON r.PatientID = p.UserID " +
                 "LEFT JOIN Users n ON r.NurseID = n.UserID " +
                 "LEFT JOIN Services s ON r.ServiceID = s.ServiceID " +
                 "WHERE p.FullName LIKE ?";
    
    System.out.println("DEBUG - SQL Query: " + sql);
    System.out.println("DEBUG - Patient Name parameter: " + patientName);
    
    try (Connection conn = dbContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setString(1, "%" + patientName + "%");
        try (ResultSet rs = pstmt.executeQuery()) {
            List<Map<String, Object>> results = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("resultId", rs.getInt("ResultID"));
                row.put("appointmentId", rs.getInt("AppointmentID"));
                row.put("doctorId", rs.getInt("DoctorID"));
                row.put("patientId", rs.getInt("PatientID"));
                
                // Thêm NurseID với null check
                int nurseId = rs.getInt("NurseID");
                if (!rs.wasNull()) {
                    row.put("nurseId", nurseId);
                } else {
                    row.put("nurseId", null);
                }
                
                row.put("doctorName", rs.getString("doctorName"));
                row.put("patientName", rs.getString("patientName"));
                row.put("nurseName", rs.getString("nurseName"));
                row.put("serviceName", rs.getString("ServiceName"));
                row.put("diagnosis", rs.getString("Diagnosis"));
                row.put("notes", rs.getString("Notes"));
                row.put("createdAt", rs.getTimestamp("CreatedAt"));
                row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                
                System.out.println("DEBUG - Row added: " + row);
                results.add(row);
            }
            System.out.println("DEBUG - Total results found: " + results.size());
            return results;
        }
    } catch (SQLException e) {
        System.err.println("DEBUG - SQL Exception: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}
// Updated addPrescription method
public boolean addPrescription(Prescriptions prescription, int resultId, int appointmentId, List<Integer> medicationId, String signature) throws SQLException {
    if (prescription == null) {
        throw new IllegalArgumentException("Prescription object cannot be null.");
    }
    if (medicationId == null || medicationId.isEmpty()) {
        throw new IllegalArgumentException("Medication IDs list cannot be null or empty.");
    }
    if (appointmentId <= 0) {
        throw new IllegalArgumentException("Appointment ID must be a positive integer.");
    }

    String sqlPrescription = "INSERT INTO Prescriptions (ResultID, PatientID, AppointmentID, DoctorID, NurseID, PrescriptionDetails, CreatedAt, UpdatedAt, Signature) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    Connection conn = null;
    PreparedStatement pstmtPrescription = null;

    try {
        conn = dbContext.getConnection();
        conn.setAutoCommit(false);

        validateForeignKeys(conn, prescription, resultId, appointmentId);
        validateMedicationIds(conn, medicationId);

        // Lấy NurseID từ ExaminationResults
        Integer nurseId = getNurseIdFromExaminationResult(conn, resultId);
        System.out.println("DEBUG - NurseID retrieved: " + nurseId);

        // Fetch medication Name and Dosage
        List<String> medDetails = new ArrayList<>();
        String sqlMedication = "SELECT Name, Dosage FROM Medications WHERE MedicationID = ?";
        try (PreparedStatement pstmtMedication = conn.prepareStatement(sqlMedication)) {
            for (Integer medId : medicationId) {
                pstmtMedication.setInt(1, medId);
                try (ResultSet rs = pstmtMedication.executeQuery()) {
                    if (rs.next()) {
                        String name = rs.getString("Name");
                        String dosage = rs.getString("Dosage");
                        medDetails.add("Name: " + name + ", Dosage: " + dosage);
                    } else {
                        throw new SQLException("Medication not found for ID: " + medId);
                    }
                }
            }
        }

        // Construct PrescriptionDetails if not provided
        String prescriptionDetails = prescription.getPrescriptionDetails();
        if (prescriptionDetails == null || prescriptionDetails.trim().isEmpty()) {
            prescriptionDetails = String.join("; ", medDetails);
            prescription.setPrescriptionDetails(prescriptionDetails);
        }

        // Insert into Prescriptions table
        pstmtPrescription = conn.prepareStatement(sqlPrescription, Statement.RETURN_GENERATED_KEYS);
        pstmtPrescription.setInt(1, resultId);
        pstmtPrescription.setInt(2, prescription.getPatientId());
        pstmtPrescription.setInt(3, appointmentId);
        pstmtPrescription.setInt(4, prescription.getDoctorId());
        
        // Set NurseID (có thể null nếu không có nurse)
        if (nurseId != null) {
            pstmtPrescription.setInt(5, nurseId);
        } else {
            pstmtPrescription.setNull(5, Types.INTEGER);
        }
        
        pstmtPrescription.setString(6, prescriptionDetails);
        LocalDateTime now = LocalDateTime.now();
        pstmtPrescription.setTimestamp(7, Timestamp.valueOf(now));
        pstmtPrescription.setTimestamp(8, Timestamp.valueOf(now));
        pstmtPrescription.setString(9, signature);

        int affectedRows = pstmtPrescription.executeUpdate();
        if (affectedRows == 0) {
            throw new SQLException("Failed to insert prescription - no rows affected.");
        }

        int prescriptionId;
        try (ResultSet generatedKeys = pstmtPrescription.getGeneratedKeys()) {
            if (generatedKeys.next()) {
                prescriptionId = generatedKeys.getInt(1);
                prescription.setPrescriptionId(prescriptionId);
            } else {
                throw new SQLException("Failed to retrieve generated prescription ID.");
            }
        }

        conn.commit();

        System.out.println("Prescription added successfully with ID: " + prescriptionId + 
                         " (NurseID: " + nurseId + ") at " + LocalDateTime.now() + " +07");
        return true;

    } catch (SQLException e) {
        if (conn != null) {
            try {
                conn.rollback();
                System.err.println("Transaction rolled back due to error in addPrescription: " + e.getMessage() + 
                                 " at " + LocalDateTime.now() + " +07");
            } catch (SQLException rollbackEx) {
                System.err.println("Rollback failed: " + rollbackEx.getMessage() + 
                                 " at " + LocalDateTime.now() + " +07");
            }
        }
        throw new SQLException("Failed to add prescription: " + e.getMessage(), e);
    } finally {
        try {
            if (pstmtPrescription != null) pstmtPrescription.close();
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        } catch (SQLException closeEx) {
            System.err.println("Failed to close resources: " + closeEx.getMessage() + 
                             " at " + LocalDateTime.now() + " +07");
        }
    }
}

// Phương thức helper để lấy NurseID từ ExaminationResults
private Integer getNurseIdFromExaminationResult(Connection conn, int resultId) throws SQLException {
    String sql = "SELECT NurseID FROM ExaminationResults WHERE ResultID = ?";
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        pstmt.setInt(1, resultId);
        try (ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) {
                int nurseId = rs.getInt("NurseID");
                // Kiểm tra nếu giá trị là null trong database
                if (rs.wasNull()) {
                    return null;
                }
                return nurseId;
            } else {
                throw new SQLException("ExaminationResult not found for ResultID: " + resultId);
            }
        }
    }
}

// Updated validateForeignKeys method để bao gồm NurseID validation
private void validateForeignKeys(Connection conn, Prescriptions prescription, int resultId, int appointmentId) throws SQLException {
    String checkPatient = "SELECT 1 FROM ExaminationResults WHERE PatientID = ?";
    String checkDoctor = "SELECT 1 FROM ExaminationResults WHERE DoctorID = ?";
    String checkResult = "SELECT 1 FROM ExaminationResults WHERE ResultID = ?";
    String checkAppointment = "SELECT 1 FROM ExaminationResults WHERE AppointmentID = ?";

    try (PreparedStatement pstmtPatient = conn.prepareStatement(checkPatient);
         PreparedStatement pstmtDoctor = conn.prepareStatement(checkDoctor);
         PreparedStatement pstmtResult = conn.prepareStatement(checkResult);
         PreparedStatement pstmtAppointment = conn.prepareStatement(checkAppointment))
    {
        pstmtPatient.setInt(1, prescription.getPatientId());
        pstmtDoctor.setInt(1, prescription.getDoctorId());
        pstmtResult.setInt(1, resultId);
        pstmtAppointment.setInt(1, appointmentId);

        if (!pstmtPatient.executeQuery().next()) {
            throw new SQLException("Invalid PatientID: " + prescription.getPatientId());
        }
        if (!pstmtDoctor.executeQuery().next()) {
            throw new SQLException("Invalid DoctorID: " + prescription.getDoctorId());
        }
        if (!pstmtResult.executeQuery().next()) {
            throw new SQLException("Invalid ResultID: " + resultId);
        }
        if (!pstmtAppointment.executeQuery().next()) {
            throw new SQLException("Invalid AppointmentID: " + appointmentId);
        }

        // Validate NurseID if it exists in the ExaminationResult
        Integer nurseId = getNurseIdFromExaminationResult(conn, resultId);
        if (nurseId != null) {
            String checkNurse = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Nurse'";
            try (PreparedStatement pstmtNurse = conn.prepareStatement(checkNurse)) {
                pstmtNurse.setInt(1, nurseId);
                if (!pstmtNurse.executeQuery().next()) {
                    throw new SQLException("Invalid NurseID or user is not a nurse: " + nurseId);
                }
            }
        }
    }
}

// Updated mapResultSetToPrescription method để bao gồm NurseID
private Prescriptions mapResultSetToPrescription(ResultSet rs) throws SQLException {
    Prescriptions prescription = new Prescriptions();
    prescription.setPrescriptionId(rs.getInt("PrescriptionID"));
    prescription.setPatientId(rs.getInt("PatientID"));
    prescription.setDoctorId(rs.getInt("DoctorID"));
    
    // Thêm NurseID
    int nurseId = rs.getInt("NurseID");
    if (!rs.wasNull()) {
        prescription.setNurseId(nurseId);
    }
    
    prescription.setPrescriptionDetails(rs.getString("PrescriptionDetails"));
    prescription.setSignature(rs.getString("Signature"));

    Timestamp created = rs.getTimestamp("CreatedAt");
    if (created != null) {
        prescription.setCreatedAt(created.toLocalDateTime());
    }

    Timestamp updated = rs.getTimestamp("UpdatedAt");
    if (updated != null) {
        prescription.setUpdatedAt(updated.toLocalDateTime());
    }

    return prescription;
}

    public void validateMedicationIds(Connection conn, List<Integer> medicationIds) throws SQLException {
        String checkMedication = "SELECT 1 FROM Medications WHERE MedicationID = ?";
        try (PreparedStatement pstmtMedication = conn.prepareStatement(checkMedication)) {
            for (Integer medId : medicationIds) {
                pstmtMedication.setInt(1, medId);
                if (!pstmtMedication.executeQuery().next()) {
                    throw new SQLException("Invalid MedicationID: " + medId);
                }
            }
        }
    }
    
    private boolean validateMedicationExists(Connection conn, Integer medicationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Medications WHERE MedicationID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, medicationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public List<Medication> getAllMedications() throws SQLException {
        try {
            return medicationService.getAllMedications();
        } catch (SQLException e) {
            System.err.println("SQLException in getAllMedications: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
    }

    public List<Prescriptions> getAllPrescriptions() throws SQLException {
        List<Prescriptions> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM Prescriptions";

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql); 
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                prescriptions.add(mapResultSetToPrescription(rs));
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllPrescriptions: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        return prescriptions;
    }

   
    public Prescriptions getPrescriptionById(int prescriptionId) throws SQLException {
        String sql = "SELECT * FROM Prescriptions WHERE PrescriptionID = ?";

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, prescriptionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPrescription(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getPrescriptionById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        return null;
    }

    public List<Prescriptions> getPrescriptionsByPage(int page, int pageSize) throws SQLException {
        List<Prescriptions> prescriptions = new ArrayList<>();
        String sql = "SELECT * FROM Prescriptions " +
                     "ORDER BY PrescriptionID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
            System.err.println("SQLException in getPrescriptionsByPage: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        return prescriptions;
    }

    public int getTotalPrescriptionCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Prescriptions";

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql); 
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalPrescriptionCount: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        return 0;
    }

    public List<Prescriptions> searchPrescriptionsByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword, int page, int pageSize) throws SQLException {
        List<Prescriptions> prescriptions = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.* FROM Prescriptions p " +
                "JOIN Users u ON p.PatientID = u.UserID "
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
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
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
            System.err.println("SQLException in searchPrescriptionsByPatientAndMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        return prescriptions;
    }

    public int getTotalCountByPatientAndMedication(String patientNameKeyword, String medicationNameKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Prescriptions p " +
                "JOIN Users u ON p.PatientID = u.UserID "
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
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : parameters) {
                pstmt.setObject(paramIndex++, param);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getTotalCountByPatientAndMedication: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        return 0;
    }

    public boolean updateNoteForPrescription(int prescriptionId, String note) throws SQLException {
        String sql = "UPDATE Prescriptions SET Note = ?, UpdatedAt = CURRENT_TIMESTAMP WHERE PrescriptionID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, note);
            pstmt.setInt(2, prescriptionId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
 /**
     * Check if a prescription exists for a given examination result ID
     * @param resultId The examination result ID to check
     * @return true if a prescription exists, false otherwise
     * @throws SQLException if database operation fails
     */
    public boolean hasPrescription(int resultId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Prescriptions WHERE ResultID = ?";
        
        System.out.println("DEBUG - SQL Query for hasPrescription: " + sql);
        System.out.println("DEBUG - ResultID parameter: " + resultId);
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, resultId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    boolean exists = rs.getInt(1) > 0;
                    System.out.println("DEBUG - Prescription exists for ResultID " + resultId + ": " + exists + 
                                     " at " + LocalDateTime.now() + " +07");
                    return exists;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in hasPrescription for ResultID " + resultId + ": " + 
                              e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        return false;
    }

    
    
}