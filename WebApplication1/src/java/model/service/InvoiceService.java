// ==================== BƯỚC 2: SỬA SERVICE - InvoiceService.java ====================

package model.service;

import model.dao.InvoiceDAO;
import model.entity.Invoices;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class InvoiceService {
    private final InvoiceDAO invoiceDAO;

    public InvoiceService() {
        this.invoiceDAO = new InvoiceDAO();
    }

    

    
    /**
     * Lấy danh sách kết quả khám kèm thông tin hóa đơn
     */
    public List<Map<String, Object>> getExaminationResultsWithInvoice() throws SQLException {
        return invoiceDAO.getExaminationResultsWithInvoice();
    }

    /**
     * Lấy kết quả khám theo PatientID
     */
    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            throw new IllegalArgumentException("PatientID không hợp lệ: " + patientId);
        }
        return invoiceDAO.getExaminationResultsByPatientId(patientId);
    }

    /**
     * Lấy tất cả kết quả khám
     */
    public List<Map<String, Object>> getAllExaminationResults() throws SQLException {
        return invoiceDAO.getAllExaminationResults();
    }

    // ---------------------- Các hàm liên quan Invoices ----------------------
    
    /**
     * Thêm hóa đơn mới
     */
    public boolean addInvoice(Invoices invoice) throws SQLException {
        // Validate đầu vào
        validateInvoiceInput(invoice);
        
        return invoiceDAO.addInvoice(invoice);
    }

    /**
     * Lấy hóa đơn theo ID
     */
    public Invoices getInvoiceById(int invoiceId) throws SQLException {
        if (invoiceId <= 0) {
            throw new IllegalArgumentException("InvoiceID không hợp lệ: " + invoiceId);
        }
        return invoiceDAO.getInvoiceById(invoiceId);
    }

    /**
     * Lấy tất cả hóa đơn
     */
    public List<Invoices> getAllInvoices() throws SQLException {
        return invoiceDAO.getAllInvoices();
    }

    /**
     * Lấy hóa đơn theo trang
     */
    public List<Invoices> getInvoicesByPage(int page, int pageSize) throws SQLException {
        if (page <= 0) {
            throw new IllegalArgumentException("Số trang phải >= 1. Giá trị nhận được: " + page);
        }
        if (pageSize <= 0) {
            throw new IllegalArgumentException("Page size phải >= 1. Giá trị nhận được: " + pageSize);
        }
        if (pageSize > 1000) {
            throw new IllegalArgumentException("Page size không được vượt quá 1000. Giá trị nhận được: " + pageSize);
        }
        
        return invoiceDAO.getInvoicesByPage(page, pageSize);
    }

    /**
     * Tìm kiếm kết quả khám với 2 từ khóa
     * @param keyword1 Tên bệnh nhân hoặc dịch vụ
     * @param keyword2 Mã kết quả, tên bác sĩ hoặc chẩn đoán
     */
    public List<Map<String, Object>> searchExaminationResultsByPatientAndService(String keyword1, String keyword2, int page, int pageSize) throws SQLException {
        if (page <= 0) {
            throw new IllegalArgumentException("Số trang phải >= 1. Giá trị nhận được: " + page);
        }
        if (pageSize <= 0) {
            throw new IllegalArgumentException("Page size phải >= 1. Giá trị nhận được: " + pageSize);
        }
        if (pageSize > 1000) {
            throw new IllegalArgumentException("Page size không được vượt quá 1000. Giá trị nhận được: " + pageSize);
        }
        
        return invoiceDAO.searchExaminationResultsByPatientAndService(keyword1, keyword2, page, pageSize);
    }

    /**
     * Đếm tổng số hóa đơn
     */
    public int getTotalInvoiceCount() throws SQLException {
        return invoiceDAO.getTotalInvoiceCount();
    }

    /**
     * Đếm tổng số kết quả khám theo điều kiện tìm kiếm
     * @param keyword1 Tên bệnh nhân hoặc dịch vụ
     * @param keyword2 Mã kết quả, tên bác sĩ hoặc chẩn đoán
     */
    public int getTotalCountExaminationResultsByPatientAndService(String keyword1, String keyword2) throws SQLException {
        return invoiceDAO.getTotalCountExaminationResultsByPatientAndService(keyword1, keyword2);
    }

    /**
     * Xóa hóa đơn
     */
    public boolean deleteInvoice(int invoiceId) throws SQLException {
        if (invoiceId <= 0) {
            throw new IllegalArgumentException("InvoiceID không hợp lệ: " + invoiceId);
        }
        return invoiceDAO.deleteInvoice(invoiceId);
    }

    /**
     * Cập nhật hóa đơn
     */
    public boolean updateInvoice(Invoices invoice) throws SQLException {
        validateInvoiceInput(invoice);
        
        if (invoice.getInvoiceID() <= 0) {
            throw new IllegalArgumentException("InvoiceID không hợp lệ: " + invoice.getInvoiceID());
        }
        
        return invoiceDAO.updateInvoice(invoice);
    }

    /**
     * Lấy hóa đơn theo PatientID (sửa lại trả về List<Map<String, Object>>)
     */
    public List<Map<String, Object>> getInvoicesByPatientId(int patientId) throws SQLException {
        if (patientId <= 0) {
            throw new IllegalArgumentException("PatientID không hợp lệ: " + patientId);
        }
        return invoiceDAO.getInvoicesByPatientId(patientId);
    }

    /**
     * Lấy hóa đơn theo DoctorID
     */
    public List<Invoices> getInvoicesByDoctorId(int doctorId) throws SQLException {
        if (doctorId <= 0) {
            throw new IllegalArgumentException("DoctorID không hợp lệ: " + doctorId);
        }
        return invoiceDAO.getInvoicesByDoctorId(doctorId);
    }

    /**
     * ✅ BỔ SUNG: Đánh dấu hóa đơn đã được bệnh nhân yêu cầu thanh toán
     */
    public boolean markInvoicePaymentRequested(int invoiceId) throws SQLException {
        if (invoiceId <= 0) {
            throw new IllegalArgumentException("InvoiceID không hợp lệ: " + invoiceId);
        }
        return invoiceDAO.markInvoicePaymentRequested(invoiceId);
    }

    /**
     * ✅ BỔ SUNG: Lấy danh sách hóa đơn PENDING đã được bệnh nhân yêu cầu thanh toán
     */
    public List<Invoices> getRequestedPendingInvoices() throws SQLException {
        return invoiceDAO.getRequestedPendingInvoices();
    }

    /**
     * ✅ BỔ SUNG: Xác nhận thanh toán hóa đơn (cập nhật Status = 'PAID')
     */
    public boolean confirmInvoicePaid(int invoiceId) throws SQLException {
        if (invoiceId <= 0) {
            throw new IllegalArgumentException("InvoiceID không hợp lệ: " + invoiceId);
        }
        return invoiceDAO.confirmInvoicePaid(invoiceId);
    }



    /**
     * ✅ Lấy chi tiết kết quả khám + hóa đơn theo resultId (JOIN 2 bảng)
     * @param resultId ID của kết quả khám
     * @return Map chứa thông tin chi tiết của cả ExaminationResults và Invoices (hoặc null nếu không có)
     */
    public Map<String, Object> getExaminationResultWithInvoiceByResultId(int resultId) throws SQLException {
        if (resultId <= 0) {
            throw new IllegalArgumentException("ResultID không hợp lệ: " + resultId);
        }
        return invoiceDAO.getExaminationResultWithInvoiceByResultId(resultId);
    }

    


  


    // ---------------------- Phương thức hỗ trợ ----------------------
    
    /**
     * ✅ SỬA: Validate dữ liệu đầu vào cho Invoice - THÊM validation cho ResultID
     */
    private void validateInvoiceInput(Invoices invoice) throws IllegalArgumentException {
        if (invoice == null) {
            throw new IllegalArgumentException("Hóa đơn không được null.");
        }
        
        if (invoice.getPatientID() <= 0) {
            throw new IllegalArgumentException("PatientID không hợp lệ: " + invoice.getPatientID());
        }
        
        if (invoice.getDoctorID() <= 0) {
            throw new IllegalArgumentException("DoctorID không hợp lệ: " + invoice.getDoctorID());
        }
        
        if (invoice.getServiceID() <= 0) {
            throw new IllegalArgumentException("ServiceID không hợp lệ: " + invoice.getServiceID());
        }
        
        // ✅ THÊM: Validation cho ResultID
        if (invoice.getResultID() <= 0) {
            throw new IllegalArgumentException("ResultID không hợp lệ: " + invoice.getResultID());
        }
        
        if (invoice.getTotalAmount() < 0) {
            throw new IllegalArgumentException("Tổng tiền phải >= 0. Giá trị nhận được: " + invoice.getTotalAmount());
        }
        
        if (invoice.getStatus() == null || invoice.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Trạng thái không được để trống.");
        }
        
        // Validate trạng thái hợp lệ
        String status = invoice.getStatus().toUpperCase();
        if (!status.equals("PENDING") && !status.equals("PAID") && !status.equals("CANCELLED")) {
            throw new IllegalArgumentException("Trạng thái không hợp lệ: " + invoice.getStatus() + ". Chỉ chấp nhận: PENDING, PAID, CANCELLED");
        }
        
        if (invoice.getCreatedBy() <= 0) {
            throw new IllegalArgumentException("CreatedBy không hợp lệ: " + invoice.getCreatedBy());
        }
    }

    /**
     * Tính tổng số trang
     */
    public int getTotalPages(int totalRecords, int pageSize) {
        if (pageSize <= 0) {
            throw new IllegalArgumentException("Page size phải > 0");
        }
        return (int) Math.ceil((double) totalRecords / pageSize);
    }

    /**
     * Validate số trang
     */
    public boolean isValidPage(int page, int totalPages) {
        return page > 0 && page <= totalPages;
    }

 
}