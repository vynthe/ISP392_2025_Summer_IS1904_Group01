package model.dao;

import model.entity.Invoices;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class InvoiceDAO {

    public final DBContext dbContext;

    public InvoiceDAO() {
        this.dbContext = DBContext.getInstance();
    }

    public List<Map<String, Object>> getExaminationResultsWithInvoice() throws SQLException {
        String sql = "SELECT "
                + "r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.ServiceID, "
                + "d.FullName as doctorName, p.FullName as patientName, "
                + "s.ServiceName, r.ResultName, "
                + "i.TotalAmount, i.Status "
                + "FROM ExaminationResults r "
                + "LEFT JOIN Users d ON r.DoctorID = d.UserID "
                + "LEFT JOIN Users p ON r.PatientID = p.UserID "
                + "LEFT JOIN Services s ON r.ServiceID = s.ServiceID "
                + "LEFT JOIN Invoices i ON r.PatientID = i.PatientID AND r.ServiceID = i.ServiceID";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
            List<Map<String, Object>> results = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("resultId", rs.getInt("ResultID"));
                row.put("appointmentId", rs.getInt("AppointmentID"));
                row.put("doctorId", rs.getInt("DoctorID"));
                row.put("patientId", rs.getInt("PatientID"));
                row.put("doctorName", rs.getString("doctorName"));
                row.put("patientName", rs.getString("patientName"));
                row.put("serviceName", rs.getString("ServiceName"));
                row.put("resultName", rs.getString("ResultName"));
                row.put("serviceId", rs.getInt("ServiceID"));
                row.put("totalAmount", rs.getObject("TotalAmount")); // Có thể là null nếu chưa có hóa đơn
                row.put("status", rs.getString("Status")); // Có thể là null nếu chưa có hóa đơn
                results.add(row);
            }
            return results;
        }
    }

    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId) throws SQLException {
        String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.ServiceID, "
                + "d.FullName as doctorName, p.FullName as patientName, "
                + "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.ResultName "
                + "FROM ExaminationResults r "
                + "LEFT JOIN Users d ON r.DoctorID = d.UserID "
                + "LEFT JOIN Users p ON r.PatientID = p.UserID "
                + "LEFT JOIN Users n ON r.NurseID = n.UserID "
                + "LEFT JOIN Services s ON r.ServiceID = s.ServiceID "
                + "WHERE r.PatientID = ?";

        System.out.println("DEBUG - SQL Query: " + sql);
        System.out.println("DEBUG - PatientID parameter: " + patientId);

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, patientId);
            try (ResultSet rs = pstmt.executeQuery()) {
                List<Map<String, Object>> results = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("resultId", rs.getInt("ResultID"));
                    row.put("appointmentId", rs.getInt("AppointmentID"));
                    row.put("doctorId", rs.getInt("DoctorID"));
                    row.put("patientId", rs.getInt("PatientID"));
                    row.put("doctorName", rs.getString("doctorName"));
                    row.put("patientName", rs.getString("patientName"));
                    row.put("nurseName", rs.getString("nurseName"));
                    row.put("serviceName", rs.getString("ServiceName"));
                    row.put("resultName", rs.getString("ResultName"));
                    row.put("createdAt", rs.getTimestamp("CreatedAt"));
                    row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                    row.put("serviceId", rs.getInt("ServiceID"));

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
        String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.ServiceID, "
                + "d.FullName as doctorName, p.FullName as patientName, "
                + "n.FullName as nurseName, s.ServiceName, r.CreatedAt, r.UpdatedAt, r.ResultName "
                + "FROM ExaminationResults r "
                + "LEFT JOIN Users d ON r.DoctorID = d.UserID "
                + "LEFT JOIN Users p ON r.PatientID = p.UserID "
                + "LEFT JOIN Users n ON r.NurseID = n.UserID "
                + "LEFT JOIN Services s ON r.ServiceID = s.ServiceID";

        System.out.println("DEBUG - SQL Query for all results: " + sql);

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
            List<Map<String, Object>> results = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("resultId", rs.getInt("ResultID"));
                row.put("appointmentId", rs.getInt("AppointmentID"));
                row.put("doctorId", rs.getInt("DoctorID"));
                row.put("patientId", rs.getInt("PatientID"));
                row.put("doctorName", rs.getString("doctorName"));
                row.put("patientName", rs.getString("patientName"));
                row.put("nurseName", rs.getString("nurseName"));
                row.put("serviceName", rs.getString("ServiceName"));
                row.put("resultName", rs.getString("ResultName"));
                row.put("createdAt", rs.getTimestamp("CreatedAt"));
                row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                // ✅ SỬA: Đổi từ "serviceID" thành "ServiceID"
                row.put("serviceId", rs.getInt("ServiceID"));

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

    private boolean validateForeignKeys(Connection conn, Invoices invoice) throws SQLException {
        String checkPatient = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Patient'";
        String checkDoctor = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Doctor'";
        String checkService = "SELECT 1 FROM Services WHERE ServiceID = ?";

        try (PreparedStatement pstmt1 = conn.prepareStatement(checkPatient); PreparedStatement pstmt2 = conn.prepareStatement(checkDoctor); PreparedStatement pstmt3 = conn.prepareStatement(checkService)) {
            pstmt1.setInt(1, invoice.getPatientID());
            pstmt2.setInt(1, invoice.getDoctorID());
            pstmt3.setInt(1, invoice.getServiceID());

            if (!pstmt1.executeQuery().next()) {
                throw new SQLException("Invalid PatientID: " + invoice.getPatientID());
            }
            if (!pstmt2.executeQuery().next()) {
                throw new SQLException("Invalid DoctorID: " + invoice.getDoctorID());
            }
            if (!pstmt3.executeQuery().next()) {
                throw new SQLException("Invalid ServiceID: " + invoice.getServiceID());
            }
            return true;
        }
    }

    public boolean addInvoice(Invoices invoice) throws SQLException {
        if (invoice == null) {
            throw new SQLException("Invoice object cannot be null.");
        }

        String sqlInvoice = "INSERT INTO Invoices (PatientID, DoctorID, TotalAmount, Status, ServiceID, CreatedBy, CreatedAt, UpdatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement pstmtInvoice = null;

        try {
            conn = dbContext.getConnection();
            conn.setAutoCommit(false);

            validateForeignKeys(conn, invoice);

            int invoiceId;
            pstmtInvoice = conn.prepareStatement(sqlInvoice, Statement.RETURN_GENERATED_KEYS);
            pstmtInvoice.setInt(1, invoice.getPatientID());
            pstmtInvoice.setInt(2, invoice.getDoctorID());
            pstmtInvoice.setDouble(3, invoice.getTotalAmount());
            pstmtInvoice.setString(4, invoice.getStatus());
            pstmtInvoice.setInt(5, invoice.getServiceID());
            pstmtInvoice.setInt(6, invoice.getCreatedBy());
            pstmtInvoice.setDate(7, invoice.getCreatedAt());
            pstmtInvoice.setDate(8, invoice.getUpdatedAt());

            int affectedRows = pstmtInvoice.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Failed to insert invoice - no rows affected.");
            }

            try (ResultSet generatedKeys = pstmtInvoice.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    invoiceId = generatedKeys.getInt(1);
                    invoice.setInvoiceID(invoiceId);
                } else {
                    throw new SQLException("Failed to retrieve generated invoice ID.");
                }
            }

            conn.commit();

            System.out.println("Invoice added successfully with ID: " + invoiceId
                    + " at " + LocalDateTime.now() + " +07");

            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    System.err.println("Transaction rolled back due to error in addInvoice");
                } catch (SQLException rollbackEx) {
                    System.err.println("Rollback failed: " + rollbackEx.getMessage());
                }
            }

            System.err.println("SQLException in addInvoice: " + e.getMessage()
                    + " at " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            throw e;

        } finally {
            try {
                if (pstmtInvoice != null) {
                    pstmtInvoice.close();
                }
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException closeEx) {
                System.err.println("Failed to close resources: " + closeEx.getMessage());
            }
        }
    }

    public List<Invoices> getAllInvoices() throws SQLException {
        List<Invoices> invoices = new ArrayList<>();
        String sql = "SELECT * FROM Invoices WHERE Status != 'CANCELLED'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                invoices.add(mapResultSetToInvoice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getAllInvoices: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return invoices;
    }

    public Invoices getInvoiceById(int invoiceId) throws SQLException {
        String sql = "SELECT * FROM Invoices WHERE InvoiceID = ? AND Status != 'CANCELLED'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, invoiceId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInvoice(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getInvoiceById: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return null;
    }

    public List<Invoices> getInvoicesByPage(int page, int pageSize) throws SQLException {
        List<Invoices> invoices = new ArrayList<>();
        String sql = "SELECT i.* FROM Invoices i WHERE i.Status != 'CANCELLED' "
                + "ORDER BY i.InvoiceID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapResultSetToInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getInvoicesByPage: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return invoices;
    }

    public int getTotalInvoiceCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Invoices WHERE Status != 'CANCELLED'";

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in getTotalInvoiceCount: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return 0;
    }

    public List<Invoices> searchInvoicesByPatientAndService(String patientNameKeyword, String serviceNameKeyword, int page, int pageSize) throws SQLException {
        List<Invoices> invoices = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.* FROM Invoices i "
                + "JOIN Users u ON i.PatientID = u.UserID "
                + "LEFT JOIN Services s ON i.ServiceID = s.ServiceID "
                + "WHERE i.Status != 'CANCELLED'"
        );
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        if (patientNameKeyword != null && !patientNameKeyword.trim().isEmpty()) {
            conditions.add("u.FullName LIKE ?");
            parameters.add("%" + patientNameKeyword.trim() + "%");
        }
        if (serviceNameKeyword != null && !serviceNameKeyword.trim().isEmpty()) {
            conditions.add("s.ServiceName LIKE ?");
            parameters.add("%" + serviceNameKeyword.trim() + "%");
        }

        if (!conditions.isEmpty()) {
            sql.append(" AND ").append(String.join(" AND ", conditions));
        }
        sql.append(" ORDER BY i.InvoiceID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            for (Object param : parameters) {
                pstmt.setObject(paramIndex++, param);
            }
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);
            pstmt.setInt(paramIndex, pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapResultSetToInvoice(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQLException in searchInvoicesByPatientAndService: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return invoices;
    }

    public int getTotalCountByPatientAndService(String patientNameKeyword, String serviceNameKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Invoices i "
                + "JOIN Users u ON i.PatientID = u.UserID "
                + "LEFT JOIN Services s ON i.ServiceID = s.ServiceID "
                + "WHERE i.Status != 'CANCELLED'"
        );
        List<String> conditions = new ArrayList<>();
        List<Object> parameters = new ArrayList<>();

        if (patientNameKeyword != null && !patientNameKeyword.trim().isEmpty()) {
            conditions.add("u.FullName LIKE ?");
            parameters.add("%" + patientNameKeyword.trim() + "%");
        }
        if (serviceNameKeyword != null && !serviceNameKeyword.trim().isEmpty()) {
            conditions.add("s.ServiceName LIKE ?");
            parameters.add("%" + serviceNameKeyword.trim() + "%");
        }

        if (!conditions.isEmpty()) {
            sql.append(" AND ").append(String.join(" AND ", conditions));
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
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
            e.printStackTrace();
            System.err.println("SQLException in getTotalCountByPatientAndService: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            throw e;
        }
        return 0;
    }

    // Xóa hóa đơn
    public boolean deleteInvoice(int invoiceId) throws SQLException {
        String sql = "DELETE FROM Invoices WHERE InvoiceID=?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, invoiceId);
            return pstmt.executeUpdate() > 0;
        }
    }

    private Invoices mapResultSetToInvoice(ResultSet rs) throws SQLException {
        Invoices invoice = new Invoices();
        invoice.setInvoiceID(rs.getInt("InvoiceID"));
        invoice.setPatientID(rs.getInt("PatientID"));
        invoice.setDoctorID(rs.getInt("DoctorID"));
        invoice.setTotalAmount(rs.getDouble("TotalAmount"));
        invoice.setStatus(rs.getString("Status"));
        invoice.setServiceID(rs.getInt("ServiceID"));
        invoice.setCreatedBy(rs.getInt("CreatedBy"));

        Date created = rs.getDate("CreatedAt");
        if (created != null) {
            invoice.setCreatedAt(created);
        }

        Date updated = rs.getDate("UpdatedAt");
        if (updated != null) {
            invoice.setUpdatedAt(updated);
        }

        return invoice;
    }

//    public boolean existsInvoice(int patientId, int serviceId) throws SQLException {
//        String sql = "SELECT 1 FROM Invoices WHERE PatientID = ? AND ServiceID = ? AND Status != 'CANCELLED' LIMIT 1";
//        try (Connection conn = dbContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
//            pstmt.setInt(1, patientId);
//            pstmt.setInt(2, serviceId);
//            try (ResultSet rs = pstmt.executeQuery()) {
//                return rs.next();
//            }
//        }
//    }
}
