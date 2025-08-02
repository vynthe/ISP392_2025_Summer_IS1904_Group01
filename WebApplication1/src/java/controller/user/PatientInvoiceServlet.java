package controller.user;

import model.entity.Users;
import model.service.InvoiceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/PatientInvoiceServlet")
public class PatientInvoiceServlet extends HttpServlet {
    private InvoiceService invoiceService;
    
    @Override
    public void init() throws ServletException {
        invoiceService = new InvoiceService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a patient
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || !"patient".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "You must be logged in as a patient to access this page.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Get patient's invoices using user ID (sửa lại nhận List<Map<String, Object>>)
            List<Map<String, Object>> invoices = invoiceService.getInvoicesByPatientId(user.getUserID());
            
            // Set invoice list to request for JSP usage
            request.setAttribute("invoices", invoices);
            
            // Forward to JSP
            request.getRequestDispatcher("/views/user/Patient/PatientInvoice.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("PatientInvoiceServlet: SQL Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving invoices: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/PatientInvoice.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ✅ XỬ LÝ MỚI: Bệnh nhân bấm nút "Thanh toán" hóa đơn
        String action = request.getParameter("action");
        if ("requestPayment".equals(action)) {
            String invoiceIdStr = request.getParameter("invoiceId");
            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                invoiceService.markInvoicePaymentRequested(invoiceId); 
            } catch (Exception e) {
                // Có thể log lỗi hoặc set thông báo lỗi nếu cần
            }
            // Sau khi xử lý xong, redirect lại trang hóa đơn để tránh submit lại form
            response.sendRedirect(request.getContextPath() + "/PatientInvoiceServlet");
            return;
        }
        // Redirect POST requests to GET to prevent duplicate form submissions (logic cũ)
        response.sendRedirect(request.getContextPath() + "/PatientInvoiceServlet");
    }
    
    @Override
    public String getServletInfo() {
        return "Displays invoices for patient view";
    }
}