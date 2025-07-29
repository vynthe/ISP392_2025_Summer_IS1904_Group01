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
                     "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes, " +
                     "pr.PrescriptionID " +
                     "FROM ExaminationResults r " +
                     "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                     "LEFT JOIN Users p ON r.PatientID = p.UserID " +
                     "LEFT JOIN Users n ON r.NurseID = n.UserID " +
                     "LEFT JOIN Services s ON r.ServiceID = s.ServiceID " +
                     "LEFT JOIN Prescriptions pr ON r.ResultID = pr.ResultID " +
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
                    
                    // Thêm PrescriptionID với null check
                    int prescriptionId = rs.getInt("PrescriptionID");
                    if (!rs.wasNull()) {
                        row.put("prescriptionId", prescriptionId);
                    } else {
                        row.put("prescriptionId", null);
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
    public List<Map<String, Object>> getAllExaminationResultsByDoctorId(int doctorId) throws SQLException {
        List<Map<String, Object>> results = new ArrayList<>();
        String sql = "SELECT er.resultId, er.appointmentId, er.diagnosis, er.notes, a.patientId, u.fullName AS patientName " +
                     "FROM examination_results er " +
                     "JOIN appointments a ON er.appointmentId = a.appointmentId " +
                     "JOIN users u ON a.patientId = u.userID " +
                     "WHERE a.doctorId = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("resultId", rs.getInt("resultId"));
                    result.put("appointmentId", rs.getInt("appointmentId"));
                    result.put("diagnosis", rs.getString("diagnosis"));
                    result.put("notes", rs.getString("notes"));
                    result.put("patientId", rs.getInt("patientId"));
                    result.put("patientName", rs.getString("patientName"));
                    results.add(result);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getAllExaminationResultsByDoctorId for doctorId " + doctorId + " at " + java.time.LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }
        return results;
    }
    public List<Map<String, Object>> getExaminationResultsByPatientNameAndDoctorId(String patientName, int doctorId) throws SQLException {
        List<Map<String, Object>> results = new ArrayList<>();
        String sql = "SELECT er.resultId, er.appointmentId, er.diagnosis, er.notes, a.patientId, u.fullName AS patientName " +
                     "FROM examination_results er " +
                     "JOIN appointments a ON er.appointmentId = a.appointmentId " +
                     "JOIN users u ON a.patientId = u.userID " +
                     "WHERE a.doctorId = ? AND u.fullName LIKE ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, doctorId);
            stmt.setString(2, "%" + patientName + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("resultId", rs.getInt("resultId"));
                    result.put("appointmentId", rs.getInt("appointmentId"));
                    result.put("diagnosis", rs.getString("diagnosis"));
                    result.put("notes", rs.getString("notes"));
                    result.put("patientId", rs.getInt("patientId"));
                    result.put("patientName", rs.getString("patientName"));
                    results.add(result);
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getExaminationResultsByPatientNameAndDoctorId for doctorId " + doctorId + 
                              " and patientName '" + patientName + "' at " + LocalDateTime.now() + " +07: " + e.getMessage());
            throw e;
        }
        return results;
    }

    public List<Map<String, Object>> getAllExaminationResults() throws SQLException {
        String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.NurseID, " +
                     "d.FullName as doctorName, p.FullName as patientName, " +
                     "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes, " +
                     "pr.PrescriptionID " +
                     "FROM ExaminationResults r " +
                     "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                     "LEFT JOIN Users p ON r.PatientID = p.UserID " +
                     "LEFT JOIN Users n ON r.NurseID = n.UserID " +
                     "LEFT JOIN Services s ON r.ServiceID = s.ServiceID " +
                     "LEFT JOIN Prescriptions pr ON r.ResultID = pr.ResultID";
        
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
                
                // Thêm PrescriptionID với null check
                int prescriptionId = rs.getInt("PrescriptionID");
                if (!rs.wasNull()) {
                    row.put("prescriptionId", prescriptionId);
                } else {
                    row.put("prescriptionId", null);
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
                     "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes, " +
                     "pr.PrescriptionID " +
                     "FROM ExaminationResults r " +
                     "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                     "LEFT JOIN Users p ON r.PatientID = p.UserID " +
                     "LEFT JOIN Users n ON r.NurseID = n.UserID " +
                     "LEFT JOIN Services s ON r.ServiceID = s.ServiceID " +
                     "LEFT JOIN Prescriptions pr ON r.ResultID = pr.ResultID " +
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
                    
                    // Thêm PrescriptionID với null check
                    int prescriptionId = rs.getInt("PrescriptionID");
                    if (!rs.wasNull()) {
                        row.put("prescriptionId", prescriptionId);
                    } else {
                        row.put("prescriptionId", null);
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

    public boolean addPrescription(Prescriptions prescription, int resultId, Integer appointmentId, List<Integer> medicationId, String signature, String prescriptionDosage, String instruct, String quantity) throws SQLException {
        if (prescription == null) {
            throw new IllegalArgumentException("Prescription object cannot be null.");
        }
        if (medicationId == null || medicationId.isEmpty()) {
            throw new IllegalArgumentException("Medication IDs list cannot be null or empty.");
        }
        if (appointmentId != null && appointmentId <= 0) {
            throw new IllegalArgumentException("Appointment ID must be a positive integer or null.");
        }

        String sqlPrescription = "INSERT INTO Prescriptions (ResultID, PatientID, AppointmentID, DoctorID, NurseID, PrescriptionDosage, Instruct, Quantity, CreatedAt, UpdatedAt, Signature) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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

            // Insert into Prescriptions table
            pstmtPrescription = conn.prepareStatement(sqlPrescription, Statement.RETURN_GENERATED_KEYS);
            pstmtPrescription.setInt(1, resultId);
            pstmtPrescription.setInt(2, prescription.getPatientId());
            
            // Set AppointmentID (có thể null)
            if (appointmentId != null) {
                pstmtPrescription.setInt(3, appointmentId);
            } else {
                pstmtPrescription.setNull(3, Types.INTEGER);
            }
            
            pstmtPrescription.setInt(4, prescription.getDoctorId());
            
            // Set NurseID (có thể null)
            if (nurseId != null) {
                pstmtPrescription.setInt(5, nurseId);
            } else {
                pstmtPrescription.setNull(5, Types.INTEGER);
            }
            
            pstmtPrescription.setString(6, prescriptionDosage);
            pstmtPrescription.setString(7, instruct);
            pstmtPrescription.setString(8, quantity);
            LocalDateTime now = LocalDateTime.now();
            pstmtPrescription.setTimestamp(9, Timestamp.valueOf(now));
            pstmtPrescription.setTimestamp(10, Timestamp.valueOf(now));
            pstmtPrescription.setString(11, signature);

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
                             " (NurseID: " + nurseId + ", Quantity: " + quantity + ") at " + LocalDateTime.now() + " +07");
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

    private Integer getNurseIdFromExaminationResult(Connection conn, int resultId) throws SQLException {
        String sql = "SELECT NurseID FROM ExaminationResults WHERE ResultID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, resultId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int nurseId = rs.getInt("NurseID");
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

    private void validateForeignKeys(Connection conn, Prescriptions prescription, int resultId, Integer appointmentId) throws SQLException {
        String checkPatient = "SELECT 1 FROM ExaminationResults WHERE PatientID = ?";
        String checkDoctor = "SELECT 1 FROM ExaminationResults WHERE DoctorID = ?";
        String checkResult = "SELECT 1 FROM ExaminationResults WHERE ResultID = ?";
        String checkAppointment = "SELECT 1 FROM ExaminationResults WHERE AppointmentID = ?";

        try (PreparedStatement pstmtPatient = conn.prepareStatement(checkPatient);
             PreparedStatement pstmtDoctor = conn.prepareStatement(checkDoctor);
             PreparedStatement pstmtResult = conn.prepareStatement(checkResult)) {
            pstmtPatient.setInt(1, prescription.getPatientId());
            pstmtDoctor.setInt(1, prescription.getDoctorId());
            pstmtResult.setInt(1, resultId);

            if (!pstmtPatient.executeQuery().next()) {
                throw new SQLException("Invalid PatientID: " + prescription.getPatientId());
            }
            if (!pstmtDoctor.executeQuery().next()) {
                throw new SQLException("Invalid DoctorID: " + prescription.getDoctorId());
            }
            if (!pstmtResult.executeQuery().next()) {
                throw new SQLException("Invalid ResultID: " + resultId);
            }
            if (appointmentId != null) {
                try (PreparedStatement pstmtAppointment = conn.prepareStatement(checkAppointment)) {
                    pstmtAppointment.setInt(1, appointmentId);
                    if (!pstmtAppointment.executeQuery().next()) {
                        throw new SQLException("Invalid AppointmentID: " + appointmentId);
                    }
                }
            }

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
        
        prescription.setPrescriptionDosage(rs.getString("PrescriptionDosage"));
        prescription.setInstruct(rs.getString("Instruct"));
        prescription.setQuantity(rs.getString("Quantity"));
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
            conditions.add("p.PrescriptionDosage LIKE ?");
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
            conditions.add("p.PrescriptionDosage LIKE ?");
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
public Map<String, Object> getPrescriptionDetailById(int prescriptionId) throws SQLException {
        String sql = "SELECT p.PrescriptionID, p.ResultID, p.PatientID, p.AppointmentID, p.DoctorID, p.NurseID, " +
                     "p.PrescriptionDosage, p.Instruct, p.Quantity, p.CreatedAt, p.UpdatedAt, p.Signature, " +
                     "u.FullName AS patientName, d.FullName AS doctorName, n.FullName AS nurseName, " +
                     "r.Diagnosis, r.Notes " +
                     "FROM Prescriptions p " +
                     "LEFT JOIN Users u ON p.PatientID = u.UserID " +
                     "LEFT JOIN Users d ON p.DoctorID = d.UserID " +
                     "LEFT JOIN Users n ON p.NurseID = n.UserID " +
                     "LEFT JOIN ExaminationResults r ON p.ResultID = r.ResultID " +
                     "WHERE p.PrescriptionID = ?";

        System.out.println("DEBUG - SQL Query for getPrescriptionDetailById: " + sql);
        System.out.println("DEBUG - PrescriptionID parameter: " + prescriptionId);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, prescriptionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> detail = new HashMap<>();
                    detail.put("prescriptionId", rs.getInt("PrescriptionID"));
                    detail.put("resultId", rs.getInt("ResultID"));
                    detail.put("patientId", rs.getInt("PatientID"));
                    
                    // Handle AppointmentID with null check
                    int appointmentId = rs.getInt("AppointmentID");
                    detail.put("appointmentId", rs.wasNull() ? null : appointmentId);
                    
                    detail.put("doctorId", rs.getInt("DoctorID"));
                    
                    // Handle NurseID with null check
                    int nurseId = rs.getInt("NurseID");
                    detail.put("nurseId", rs.wasNull() ? null : nurseId);
                    
                    detail.put("prescriptionDosage", rs.getString("PrescriptionDosage"));
                    detail.put("instruct", rs.getString("Instruct"));
                    detail.put("quantity", rs.getString("Quantity"));
                    detail.put("signature", rs.getString("Signature"));
                    
                    // Handle timestamps
                    Timestamp created = rs.getTimestamp("CreatedAt");
                    detail.put("createdAt", created != null ? created.toLocalDateTime() : null);
                    
                    Timestamp updated = rs.getTimestamp("UpdatedAt");
                    detail.put("updatedAt", updated != null ? updated.toLocalDateTime() : null);
                    
                    // Add user names
                    detail.put("patientName", rs.getString("patientName"));
                    detail.put("doctorName", rs.getString("doctorName"));
                    detail.put("nurseName", rs.getString("nurseName"));
                    
                    // Add examination result details
                    detail.put("diagnosis", rs.getString("Diagnosis"));
                    detail.put("notes", rs.getString("Notes"));

                    System.out.println("DEBUG - Prescription details retrieved: " + detail);
                    return detail;
                }
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getPrescriptionDetailById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;
        }
        System.out.println("DEBUG - No prescription found for PrescriptionID: " + prescriptionId);
        return null;
    }
 public List<Map<String, Object>> getResultWithPatientByDoctorId(int doctorId, String patientName, int page, int pageSize) throws SQLException {
    if (doctorId <= 0) {
        throw new IllegalArgumentException("Doctor ID must be positive");
    }
    if (page <= 0 || pageSize <= 0) {
        throw new IllegalArgumentException("Page and pageSize must be positive");
    }

    StringBuilder sql = new StringBuilder(
        "SELECT er.ResultID, er.AppointmentID, p.PrescriptionID, er.Diagnosis, er.Notes, " +
        "a.PatientID, a.DoctorID, er.NurseID, " +
        "up.FullName AS patientName, ud.FullName AS doctorName, un.FullName AS nurseName " +
        "FROM ExaminationResults er " +
        "JOIN Appointments a ON er.AppointmentID = a.AppointmentID " +
        "JOIN Users up ON a.PatientID = up.UserID " +
        "LEFT JOIN Users ud ON a.DoctorID = ud.UserID " +
        "LEFT JOIN Users un ON er.NurseID = un.UserID " +
        "LEFT JOIN Prescriptions p ON er.ResultID = p.ResultID " +
        "WHERE a.DoctorID = ?"
    );

    if (patientName != null && !patientName.trim().isEmpty()) {
        sql.append(" AND up.FullName LIKE ?");
    }

    sql.append(" ORDER BY er.ResultID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

    System.out.println("DEBUG - SQL Query for getResultWithPatientByDoctorId: " + sql);
    System.out.println("DEBUG - Parameters: doctorId=" + doctorId + ", patientName=" + patientName + ", page=" + page + ", pageSize=" + pageSize);

    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        int paramIndex = 1;
        stmt.setInt(paramIndex++, doctorId);
        if (patientName != null && !patientName.trim().isEmpty()) {
            stmt.setString(paramIndex++, "%" + patientName.trim() + "%");
        }
        stmt.setInt(paramIndex++, (page - 1) * pageSize);
        stmt.setInt(paramIndex, pageSize);

        try (ResultSet rs = stmt.executeQuery()) {
            List<Map<String, Object>> results = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> result = new HashMap<>();
                result.put("resultId", rs.getInt("ResultID"));
                result.put("appointmentId", rs.getObject("AppointmentID") != null ? rs.getInt("AppointmentID") : null);
                result.put("prescriptionId", rs.getObject("PrescriptionID") != null ? rs.getInt("PrescriptionID") : null);
                result.put("diagnosis", rs.getString("Diagnosis"));
                result.put("notes", rs.getString("Notes"));
                result.put("patientId", rs.getInt("PatientID"));
                result.put("doctorId", rs.getInt("DoctorID"));
                result.put("nurseId", rs.getObject("NurseID") != null ? rs.getInt("NurseID") : null);
                result.put("patientName", rs.getString("patientName"));
                result.put("doctorName", rs.getString("doctorName"));
                result.put("nurseName", rs.getString("nurseName"));
                System.out.println("DEBUG - Row added: " + result);
                results.add(result);
            }
            System.out.println("DEBUG - Total results found: " + results.size());
            return results;
        }
    } catch (SQLException e) {
        System.err.println("SQLException in getResultWithPatientByDoctorId for doctorId " + doctorId + 
                           ", patientName '" + patientName + "' at " + LocalDateTime.now() + " +07: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}

public int getTotalResultByDoctorId(int doctorId, String patientName) throws SQLException {
    if (doctorId <= 0) {
        throw new IllegalArgumentException("Doctor ID must be positive");
    }

    StringBuilder sql = new StringBuilder(
        "SELECT COUNT(*) " +
        "FROM ExaminationResults er " +
        "JOIN Appointments a ON er.AppointmentID = a.AppointmentID " +
        "JOIN Users up ON a.PatientID = up.UserID " +
        "WHERE a.DoctorID = ?"
    );

    if (patientName != null && !patientName.trim().isEmpty()) {
        sql.append(" AND up.FullName LIKE ?");
    }

    System.out.println("DEBUG - SQL Query for getTotalResultByDoctorId: " + sql);
    System.out.println("DEBUG - Parameters: doctorId=" + doctorId + ", patientName=" + patientName);

    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
        int paramIndex = 1;
        stmt.setInt(paramIndex++, doctorId);
        if (patientName != null && !patientName.trim().isEmpty()) {
            stmt.setString(paramIndex, "%" + patientName.trim() + "%");
        }

        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                int total = rs.getInt(1);
                System.out.println("DEBUG - Total count: " + total);
                return total;
            }
            System.out.println("DEBUG - No results found");
            return 0;
        }
    } catch (SQLException e) {
        System.err.println("SQLException in getTotalResultByDoctorId for doctorId " + doctorId + 
                           ", patientName '" + patientName + "' at " + LocalDateTime.now() + " +07: " + e.getMessage());
        e.printStackTrace();
        throw e;
    }
}
public List<Map<String, Object>> getPrescriptionsByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            throw new IllegalArgumentException("Patient ID must be positive");
        }

        String sql = "SELECT p.PrescriptionID, p.ResultID, p.PatientID, p.AppointmentID, p.DoctorID, p.NurseID, " +
                     "p.PrescriptionDosage, p.Instruct, p.Quantity, p.CreatedAt, p.UpdatedAt, p.Signature, " +
                     "u.FullName AS patientName, d.FullName AS doctorName, n.FullName AS nurseName, " +
                     "r.Diagnosis, r.Notes " +
                     "FROM Prescriptions p " +
                     "LEFT JOIN Users u ON p.PatientID = u.UserID " +
                     "LEFT JOIN Users d ON p.DoctorID = d.UserID " +
                     "LEFT JOIN Users n ON p.NurseID = n.UserID " +
                     "LEFT JOIN ExaminationResults r ON p.ResultID = r.ResultID " +
                     "WHERE p.PatientID = ?";

        System.out.println("DEBUG - SQL Query for getPrescriptionsByPatientId: " + sql);
        System.out.println("DEBUG - PatientID parameter: " + patientId);

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, patientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                List<Map<String, Object>> prescriptions = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> prescription = new HashMap<>();
                    prescription.put("prescriptionId", rs.getInt("PrescriptionID"));
                    prescription.put("resultId", rs.getInt("ResultID"));
                    prescription.put("patientId", rs.getInt("PatientID"));
                    
                    // Handle AppointmentID with null check
                    int appointmentId = rs.getInt("AppointmentID");
                    prescription.put("appointmentId", rs.wasNull() ? null : appointmentId);
                    
                    prescription.put("doctorId", rs.getInt("DoctorID"));
                    
                    // Handle NurseID with null check
                    int nurseId = rs.getInt("NurseID");
                    prescription.put("nurseId", rs.wasNull() ? null : nurseId);
                    
                    prescription.put("prescriptionDosage", rs.getString("PrescriptionDosage"));
                    prescription.put("instruct", rs.getString("Instruct"));
                    prescription.put("quantity", rs.getString("Quantity"));
                    prescription.put("signature", rs.getString("Signature"));
                    
                    // Handle timestamps
                    Timestamp created = rs.getTimestamp("CreatedAt");
                    prescription.put("createdAt", created != null ? created.toLocalDateTime() : null);
                    
                    Timestamp updated = rs.getTimestamp("UpdatedAt");
                    prescription.put("updatedAt", updated != null ? updated.toLocalDateTime() : null);
                    
                    // Add user names
                    prescription.put("patientName", rs.getString("patientName"));
                    prescription.put("doctorName", rs.getString("doctorName"));
                    prescription.put("nurseName", rs.getString("nurseName"));
                    
                    // Add examination result details
                    prescription.put("diagnosis", rs.getString("Diagnosis"));
                    prescription.put("notes", rs.getString("Notes"));

                    System.out.println("DEBUG - Prescription added: " + prescription);
                    prescriptions.add(prescription);
                }
                System.out.println("DEBUG - Total prescriptions found: " + prescriptions.size());
                return prescriptions;
            }
        } catch (SQLException e) {
            System.err.println("SQLException in getPrescriptionsByPatientId for patientId " + patientId + 
                               " at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}