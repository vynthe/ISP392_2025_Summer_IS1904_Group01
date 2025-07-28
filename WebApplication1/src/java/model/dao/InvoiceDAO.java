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

    // ---------------------- Các hàm liên quan ExaminationResults ----------------------
    /**
     * ✅ SỬA: Lấy danh sách kết quả khám kèm thông tin hóa đơn
     * JOIN với bảng Invoices để biết kết quả khám nào đã có hóa đơn
     */
    public List<Map<String, Object>> getExaminationResultsWithInvoice() throws SQLException {
        String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.NurseID, r.ServiceID, "
                + "r.Status, r.CreatedBy, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes, "
                + "d.FullName AS doctorName, p.FullName AS patientName, "
                + "n.FullName AS nurseName, s.ServiceName, s.Price, "
                + "i.InvoiceID, i.TotalAmount, i.Status AS invoiceStatus "
                + "FROM ExaminationResults r "
                + "LEFT JOIN Users d ON r.DoctorID = d.UserID "
                + "LEFT JOIN Users p ON r.PatientID = p.UserID "
                + "LEFT JOIN Users n ON r.NurseID = n.UserID "
                + "LEFT JOIN Services s ON r.ServiceID = s.ServiceID "
                + "LEFT JOIN Invoices i ON r.ResultID = i.ResultID";  // ✅ SỬA: JOIN đúng theo ResultID
        
        System.out.println("DEBUG - Đang lấy danh sách kết quả khám kèm hóa đơn:");
        
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
                row.put("nurseId", rs.getObject("NurseID")); // Có thể null
                row.put("serviceId", rs.getInt("ServiceID"));
                row.put("status", rs.getString("Status"));
                row.put("createdBy", rs.getInt("CreatedBy"));
                row.put("createdAt", rs.getTimestamp("CreatedAt"));
                row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                row.put("diagnosis", rs.getString("Diagnosis"));
                row.put("notes", rs.getString("Notes"));
                row.put("doctorName", rs.getString("doctorName"));
                row.put("patientName", rs.getString("patientName"));
                row.put("nurseName", rs.getString("nurseName"));
                row.put("serviceName", rs.getString("ServiceName"));
                // ✅ THÊM: Map Price từ bảng Services để hiển thị phí dịch vụ
                row.put("servicePrice", rs.getDouble("Price"));
                
                // ✅ THÔNG TIN HÓA ĐƠN: Có thể null nếu chưa có hóa đơn
                row.put("invoiceId", rs.getObject("InvoiceID"));
                row.put("totalAmount", rs.getObject("TotalAmount"));
                row.put("invoiceStatus", rs.getString("invoiceStatus"));
                
                results.add(row);
            }
            System.out.println("DEBUG - Tìm thấy " + results.size() + " kết quả.");
            return results;
        }
    }

    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId) throws SQLException {
        String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.NurseID, r.ServiceID, "
                + "r.Status, r.CreatedBy, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes, "
                + "d.FullName as doctorName, p.FullName as patientName, "
                + "n.FullName as nurseName, s.ServiceName "
                + "FROM ExaminationResults r "
                + "LEFT JOIN Users d ON r.DoctorID = d.UserID "
                + "LEFT JOIN Users p ON r.PatientID = p.UserID "
                + "LEFT JOIN Users n ON r.NurseID = n.UserID "
                + "LEFT JOIN Services s ON r.ServiceID = s.ServiceID "
                + "WHERE r.PatientID = ?";
        
        System.out.println("DEBUG - Đang chạy truy vấn lấy kết quả khám cho bệnh nhân ID: " + patientId);
        
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
                    row.put("nurseId", rs.getObject("NurseID"));
                    row.put("serviceId", rs.getInt("ServiceID"));
                    row.put("status", rs.getString("Status"));
                    row.put("createdBy", rs.getInt("CreatedBy"));
                    row.put("createdAt", rs.getTimestamp("CreatedAt"));
                    row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                    row.put("diagnosis", rs.getString("Diagnosis"));
                    row.put("notes", rs.getString("Notes"));
                    row.put("doctorName", rs.getString("doctorName"));
                    row.put("patientName", rs.getString("patientName"));
                    row.put("nurseName", rs.getString("nurseName"));
                    row.put("serviceName", rs.getString("ServiceName"));
                    results.add(row);
                }
                System.out.println("DEBUG - Số kết quả tìm thấy: " + results.size());
                return results;
            }
        } catch (SQLException e) {
            System.err.println("DEBUG - Lỗi SQL: " + e.getMessage());
            throw e;
        }
    }

    /**
     * ✅ SỬA: Lấy tất cả kết quả khám kèm thông tin phí dịch vụ từ bảng Services
     * JOIN với bảng Services để lấy Price (phí dịch vụ)
     */
    public List<Map<String, Object>> getAllExaminationResults() throws SQLException {
        String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, r.PatientID, r.NurseID, r.ServiceID, "
                + "r.Status, r.CreatedBy, r.CreatedAt, r.UpdatedAt, r.Diagnosis, r.Notes, "
                + "d.FullName as doctorName, p.FullName as patientName, "
                + "n.FullName as nurseName, s.ServiceName, s.Price "  // ✅ THÊM: s.Price để lấy phí dịch vụ
                + "FROM ExaminationResults r "
                + "LEFT JOIN Users d ON r.DoctorID = d.UserID "
                + "LEFT JOIN Users p ON r.PatientID = p.UserID "
                + "LEFT JOIN Users n ON r.NurseID = n.UserID "
                + "LEFT JOIN Services s ON r.ServiceID = s.ServiceID";  // ✅ JOIN: Với bảng Services để lấy Price
        

        
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
                row.put("nurseId", rs.getObject("NurseID"));
                row.put("serviceId", rs.getInt("ServiceID"));
                row.put("status", rs.getString("Status"));
                row.put("createdBy", rs.getInt("CreatedBy"));
                row.put("createdAt", rs.getTimestamp("CreatedAt"));
                row.put("updatedAt", rs.getTimestamp("UpdatedAt"));
                row.put("diagnosis", rs.getString("Diagnosis"));
                row.put("notes", rs.getString("Notes"));
                row.put("doctorName", rs.getString("doctorName"));
                row.put("patientName", rs.getString("patientName"));
                row.put("nurseName", rs.getString("nurseName"));
                row.put("serviceName", rs.getString("ServiceName"));
                // ✅ THÊM: Map Price từ bảng Services vào result
                row.put("servicePrice", rs.getDouble("Price"));
                results.add(row);
            }

            return results;
        } catch (SQLException e) {
            throw e;
        }
    }

    // ---------------------- Các hàm liên quan Invoices ----------------------
    
    private boolean validateForeignKeys(Connection conn, Invoices invoice) throws SQLException {
        String checkPatient = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Patient'";
        String checkDoctor = "SELECT 1 FROM Users WHERE UserID = ? AND Role = 'Doctor'";
        String checkService = "SELECT 1 FROM Services WHERE ServiceID = ?";
        // ✅ THÊM: Validate ResultID
        String checkResult = "SELECT 1 FROM ExaminationResults WHERE ResultID = ?";
        
        try (PreparedStatement pstmt1 = conn.prepareStatement(checkPatient); 
             PreparedStatement pstmt2 = conn.prepareStatement(checkDoctor); 
             PreparedStatement pstmt3 = conn.prepareStatement(checkService);
             PreparedStatement pstmt4 = conn.prepareStatement(checkResult)) {
            
            pstmt1.setInt(1, invoice.getPatientID());
            pstmt2.setInt(1, invoice.getDoctorID());
            pstmt3.setInt(1, invoice.getServiceID());
            pstmt4.setInt(1, invoice.getResultID());
            
            if (!pstmt1.executeQuery().next()) {
                throw new SQLException("PatientID không hợp lệ: " + invoice.getPatientID());
            }
            if (!pstmt2.executeQuery().next()) {
                throw new SQLException("DoctorID không hợp lệ: " + invoice.getDoctorID());
            }
            if (!pstmt3.executeQuery().next()) {
                throw new SQLException("ServiceID không hợp lệ: " + invoice.getServiceID());
            }
            // ✅ THÊM: Validate ResultID
            if (!pstmt4.executeQuery().next()) {
                throw new SQLException("ResultID không hợp lệ: " + invoice.getResultID());
            }
            return true;
        }
    }

    public boolean addInvoice(Invoices invoice) throws SQLException {
        if (invoice == null) {
            throw new SQLException("Đối tượng hóa đơn không được null.");
        }
        
        // ✅ SỬA: Thêm ResultID vào SQL INSERT
        String sqlInvoice = "INSERT INTO Invoices (PatientID, DoctorID, TotalAmount, Status, ServiceID, CreatedBy, CreatedAt, UpdatedAt, ResultID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sqlInvoice, Statement.RETURN_GENERATED_KEYS)) {
            
            conn.setAutoCommit(false);
            validateForeignKeys(conn, invoice);
            
            pstmt.setInt(1, invoice.getPatientID());
            pstmt.setInt(2, invoice.getDoctorID());
            pstmt.setDouble(3, invoice.getTotalAmount());
            pstmt.setString(4, invoice.getStatus());
            pstmt.setInt(5, invoice.getServiceID());
            pstmt.setInt(6, invoice.getCreatedBy());
            
            // Sử dụng Timestamp thay vì Date
            if (invoice.getCreatedAt() != null) {
                pstmt.setTimestamp(7, new Timestamp(invoice.getCreatedAt().getTime()));
            } else {
                pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
            }
            
            if (invoice.getUpdatedAt() != null) {
                pstmt.setTimestamp(8, new Timestamp(invoice.getUpdatedAt().getTime()));
            } else {
                pstmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            }
            
            // ✅ THÊM: Set ResultID
            pstmt.setInt(9, invoice.getResultID());
            
            int affectedRows = pstmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Không thêm được hóa đơn.");
            }
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    invoice.setInvoiceID(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Không lấy được ID hóa đơn mới.");
                }
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            throw e;
        }
    }

    public List<Invoices> getAllInvoices() throws SQLException {
        List<Invoices> list = new ArrayList<>();
        String sql = "SELECT * FROM Invoices WHERE Status != 'CANCELLED'";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql); 
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                list.add(mapResultSetToInvoice(rs));
            }
        }
        System.out.println("DEBUG - Tổng số hóa đơn tìm thấy: " + list.size());
        return list;
    }

    public Invoices getInvoiceById(int invoiceId) throws SQLException {
        String sql = "SELECT * FROM Invoices WHERE InvoiceID=? AND Status != 'CANCELLED'";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, invoiceId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("DEBUG - Đã tìm thấy hóa đơn ID: " + invoiceId);
                    return mapResultSetToInvoice(rs);
                }
            }
        }
        System.out.println("DEBUG - Không tìm thấy hóa đơn ID: " + invoiceId);
        return null;
    }

    public List<Invoices> getInvoicesByPage(int page, int pageSize) throws SQLException {
        List<Invoices> list = new ArrayList<>();
        String sql = "SELECT * FROM Invoices WHERE Status != 'CANCELLED' "
                + "ORDER BY InvoiceID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToInvoice(rs));
                }
            }
        }
        System.out.println("DEBUG - Trang " + page + " có " + list.size() + " hóa đơn.");
        return list;
    }

    public int getTotalInvoiceCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Invoices WHERE Status != 'CANCELLED'";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql); 
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
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

    public int getTotalCountByPatientAndService(String patientKeyword, String serviceKeyword) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Invoices i "
                + "JOIN Users u ON i.PatientID = u.UserID "
                + "LEFT JOIN Services s ON i.ServiceID = s.ServiceID "
                + "WHERE i.Status != 'CANCELLED'");
        
        List<Object> params = new ArrayList<>();
        
        if (patientKeyword != null && !patientKeyword.isEmpty()) {
            sql.append(" AND u.FullName LIKE ?");
            params.add("%" + patientKeyword + "%");
        }
        
        if (serviceKeyword != null && !serviceKeyword.isEmpty()) {
            sql.append(" AND s.ServiceName LIKE ?");
            params.add("%" + serviceKeyword + "%");
        }
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            int idx = 1;
            for (Object param : params) {
                pstmt.setObject(idx++, param);
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // Xóa hóa đơn (hard delete)
    public boolean deleteInvoice(int invoiceId) throws SQLException {
        String sql = "DELETE FROM Invoices WHERE InvoiceID=?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, invoiceId);
            return pstmt.executeUpdate() > 0;
        }
    }

    // Cập nhật hóa đơn
    public boolean updateInvoice(Invoices invoice) throws SQLException {
        // ✅ SỬA: Thêm ResultID vào UPDATE
        String sql = "UPDATE Invoices SET PatientID=?, DoctorID=?, TotalAmount=?, Status=?, ServiceID=?, UpdatedAt=?, ResultID=? WHERE InvoiceID=?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            validateForeignKeys(conn, invoice);
            
            pstmt.setInt(1, invoice.getPatientID());
            pstmt.setInt(2, invoice.getDoctorID());
            pstmt.setDouble(3, invoice.getTotalAmount());
            pstmt.setString(4, invoice.getStatus());
            pstmt.setInt(5, invoice.getServiceID());
            pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            pstmt.setInt(7, invoice.getResultID());
            pstmt.setInt(8, invoice.getInvoiceID());
            
            boolean result = pstmt.executeUpdate() > 0;
            conn.commit();
            
            System.out.println("DEBUG - Cập nhật hóa đơn ID: " + invoice.getInvoiceID() + " với ResultID: " + invoice.getResultID() + " - " + (result ? "Thành công" : "Thất bại"));
            return result;
            
        } catch (SQLException e) {
            System.err.println("DEBUG - Lỗi khi cập nhật hóa đơn: " + e.getMessage());
            throw e;
        }
    }

    // Lấy hóa đơn theo PatientID
    public List<Invoices> getInvoicesByPatientId(int patientId) throws SQLException {
        List<Invoices> invoices = new ArrayList<>();
        String sql = "SELECT * FROM Invoices WHERE PatientID = ? AND Status != 'CANCELLED' ORDER BY CreatedAt DESC";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, patientId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapResultSetToInvoice(rs));
                }
            }
        }
        return invoices;
    }

    // Lấy hóa đơn theo DoctorID
    public List<Invoices> getInvoicesByDoctorId(int doctorId) throws SQLException {
        List<Invoices> invoices = new ArrayList<>();
        String sql = "SELECT * FROM Invoices WHERE DoctorID = ? AND Status != 'CANCELLED' ORDER BY CreatedAt DESC";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, doctorId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    invoices.add(mapResultSetToInvoice(rs));
                }
            }
        }
        return invoices;
    }

    /**
     * ✅ Lấy chi tiết kết quả khám + hóa đơn theo resultId (JOIN 2 bảng)
     * @param resultId ID của kết quả khám
     * @return Map chứa thông tin chi tiết của cả ExaminationResults và Invoices (hoặc null nếu không có)
     */
    public Map<String, Object> getExaminationResultWithInvoiceByResultId(int resultId) throws SQLException {
        String sql = "SELECT r.ResultID, r.AppointmentID, r.DoctorID, d.FullName AS doctorName, " +
                "r.PatientID, p.FullName AS patientName, r.NurseID, n.FullName AS nurseName, " +
                "r.ServiceID, s.ServiceName, s.Price, r.Status AS resultStatus, r.Diagnosis, r.Notes, r.CreatedAt AS resultCreatedAt, r.UpdatedAt AS resultUpdatedAt, " +
                "i.InvoiceID, i.TotalAmount, i.Status AS invoiceStatus, i.CreatedAt AS invoiceCreatedAt, i.UpdatedAt AS invoiceUpdatedAt " +
                "FROM ExaminationResults r " +
                "LEFT JOIN Users d ON r.DoctorID = d.UserID " +
                "LEFT JOIN Users p ON r.PatientID = p.UserID " +
                "LEFT JOIN Users n ON r.NurseID = n.UserID " +
                "LEFT JOIN Services s ON r.ServiceID = s.ServiceID " +
                "LEFT JOIN Invoices i ON r.ResultID = i.ResultID " +
                "WHERE r.ResultID = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, resultId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> detail = new HashMap<>();
                    // Thông tin kết quả khám
                    detail.put("resultId", rs.getInt("ResultID"));
                    detail.put("appointmentId", rs.getInt("AppointmentID"));
                    detail.put("doctorId", rs.getInt("DoctorID"));
                    detail.put("doctorName", rs.getString("doctorName"));
                    detail.put("patientId", rs.getInt("PatientID"));
                    detail.put("patientName", rs.getString("patientName"));
                    detail.put("nurseId", rs.getObject("NurseID"));
                    detail.put("nurseName", rs.getString("nurseName"));
                    detail.put("serviceId", rs.getInt("ServiceID"));
                    detail.put("serviceName", rs.getString("ServiceName"));
                    detail.put("servicePrice", rs.getDouble("Price"));
                    detail.put("resultStatus", rs.getString("resultStatus"));
                    detail.put("diagnosis", rs.getString("Diagnosis"));
                    detail.put("notes", rs.getString("Notes"));
                    detail.put("resultCreatedAt", rs.getTimestamp("resultCreatedAt"));
                    detail.put("resultUpdatedAt", rs.getTimestamp("resultUpdatedAt"));
                    // Thông tin hóa đơn (có thể null)
                    detail.put("invoiceId", rs.getObject("InvoiceID"));
                    detail.put("totalAmount", rs.getObject("TotalAmount"));
                    detail.put("invoiceStatus", rs.getString("invoiceStatus"));
                    detail.put("invoiceCreatedAt", rs.getTimestamp("invoiceCreatedAt"));
                    detail.put("invoiceUpdatedAt", rs.getTimestamp("invoiceUpdatedAt"));
                    return detail;
                }
            }
        }
        return null;
    }

//    // ✅ THÊM: Lấy thông tin chi tiết hóa đơn kèm thông tin kết quả khám
//    public Map<String, Object> getInvoiceDetailWithExaminationResult(int invoiceId) throws SQLException {
//        String sql = "SELECT i.*, r.AppointmentID, r.NurseID, r.Diagnosis, r.Notes, r.Status as resultStatus, "
//                + "d.FullName as doctorName, p.FullName as patientName, "
//                + "n.FullName as nurseName, s.ServiceName, s.Price "
//                + "FROM Invoices i "
//                + "LEFT JOIN ExaminationResults r ON i.ResultID = r.ResultID "
//                + "LEFT JOIN Users d ON i.DoctorID = d.UserID "
//                + "LEFT JOIN Users p ON i.PatientID = p.UserID "
//                + "LEFT JOIN Users n ON r.NurseID = n.UserID "
//                + "LEFT JOIN Services s ON i.ServiceID = s.ServiceID "
//                + "WHERE i.InvoiceID = ?";
//        
//        try (Connection conn = dbContext.getConnection(); 
//             PreparedStatement pstmt = conn.prepareStatement(sql)) {
//            
//            pstmt.setInt(1, invoiceId);
//            
//            try (ResultSet rs = pstmt.executeQuery()) {
//                if (rs.next()) {
//                    Map<String, Object> detail = new HashMap<>();
//                    
//                    // Thông tin hóa đơn
//                    detail.put("invoiceId", rs.getInt("InvoiceID"));
//                    detail.put("totalAmount", rs.getDouble("TotalAmount"));
//                    detail.put("status", rs.getString("Status"));
//                    detail.put("createdAt", rs.getTimestamp("CreatedAt"));
//                    detail.put("updatedAt", rs.getTimestamp("UpdatedAt"));
//                    
//                    // Thông tin kết quả khám
//                    detail.put("resultId", rs.getInt("ResultID"));
//                    detail.put("appointmentId", rs.getInt("AppointmentID"));
//                    detail.put("diagnosis", rs.getString("Diagnosis"));
//                    detail.put("notes", rs.getString("Notes"));
//                    detail.put("resultStatus", rs.getString("resultStatus"));
//                    
//                    // Thông tin người dùng
//                    detail.put("doctorName", rs.getString("doctorName"));
//                    detail.put("patientName", rs.getString("patientName"));
//                    detail.put("nurseName", rs.getString("nurseName"));
//                    detail.put("serviceName", rs.getString("ServiceName"));
//                    detail.put("servicePrice", rs.getDouble("Price"));
//                    
//                    return detail;
//                }
//            }
//        }
//        return null;
//    }



    private Invoices mapResultSetToInvoice(ResultSet rs) throws SQLException {
        Invoices invoice = new Invoices();
        invoice.setInvoiceID(rs.getInt("InvoiceID"));
        invoice.setPatientID(rs.getInt("PatientID"));
        invoice.setDoctorID(rs.getInt("DoctorID"));
        invoice.setTotalAmount(rs.getDouble("TotalAmount"));
        invoice.setStatus(rs.getString("Status"));
        invoice.setServiceID(rs.getInt("ServiceID"));
        invoice.setCreatedBy(rs.getInt("CreatedBy"));
        
        // ✅ THÊM: Map ResultID
        invoice.setResultID(rs.getInt("ResultID"));

        // Xử lý CreatedAt và UpdatedAt từ Timestamp
        Timestamp created = rs.getTimestamp("CreatedAt");
        if (created != null) {
            invoice.setCreatedAt(new java.sql.Date(created.getTime()));
        }

        Timestamp updated = rs.getTimestamp("UpdatedAt");
        if (updated != null) {
            invoice.setUpdatedAt(new java.sql.Date(updated.getTime()));
        }

        return invoice;
    }
}