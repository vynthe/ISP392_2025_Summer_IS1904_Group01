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

    public List<Map<String, Object>> getExaminationResultsWithInvoice() throws SQLException {
        return invoiceDAO.getExaminationResultsWithInvoice();
    }

    public List<Map<String, Object>> getExaminationResultsByPatientId(int patientId) throws SQLException {
        return invoiceDAO.getExaminationResultsByPatientId(patientId);
    }

    public List<Map<String, Object>> getAllExaminationResults() throws SQLException {
        return invoiceDAO.getAllExaminationResults();
    }

    public boolean addInvoice(Invoices invoice) throws SQLException {
//        // Kiểm tra đã tồn tại hóa đơn cho cặp patientId, serviceId chưa
//        if (existsInvoice(invoice.getPatientID(), invoice.getServiceID())) {
//            // Đã tồn tại, không cho phép thêm mới
//            return false;
//        }
        // Nếu chưa có, cho phép thêm mới
        return invoiceDAO.addInvoice(invoice);
    }

    public List<Invoices> getAllInvoices() throws SQLException {
        return invoiceDAO.getAllInvoices();
    }

    public Invoices getInvoiceById(int invoiceId) throws SQLException {
        return invoiceDAO.getInvoiceById(invoiceId);
    }

    public List<Invoices> getInvoicesByPage(int page, int pageSize) throws SQLException {
        return invoiceDAO.getInvoicesByPage(page, pageSize);
    }

    public int getTotalInvoiceCount() throws SQLException {
        return invoiceDAO.getTotalInvoiceCount();
    }

    public List<Invoices> searchInvoicesByPatientAndService(String patientNameKeyword, String serviceNameKeyword, int page, int pageSize) throws SQLException {
        return invoiceDAO.searchInvoicesByPatientAndService(patientNameKeyword, serviceNameKeyword, page, pageSize);
    }

    public int getTotalCountByPatientAndService(String patientNameKeyword, String serviceNameKeyword) throws SQLException {
        return invoiceDAO.getTotalCountByPatientAndService(patientNameKeyword, serviceNameKeyword);
    }

    public boolean deleteInvoice(int invoiceId) throws SQLException {
        return invoiceDAO.deleteInvoice(invoiceId);
    }

//    public boolean existsInvoice(int patientId, int serviceId) throws SQLException {
//        return invoiceDAO.existsInvoice(patientId, serviceId);
//    }
}
