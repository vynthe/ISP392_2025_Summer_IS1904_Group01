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
import java.util.ArrayList;
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
            // Get patient's invoices using user ID
            List<Map<String, Object>> invoices = invoiceService.getInvoicesByPatientId(user.getUserID());
            System.out.println("Số lượng hóa đơn lấy được cho user ID " + user.getUserID() + ": " 
                    + (invoices != null ? invoices.size() : 0));
            if (invoices != null && !invoices.isEmpty()) {
                request.setAttribute("invoices", invoices);
            } else {
                request.setAttribute("invoices", new ArrayList<>());
                System.out.println("Không tìm thấy hóa đơn cho user ID: " + user.getUserID());
            }
            
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
        String action = request.getParameter("action");
        if ("requestPayment".equals(action)) {
            String invoiceIdStr = request.getParameter("invoiceId");
            try {
                int invoiceId = Integer.parseInt(invoiceIdStr);
                invoiceService.markInvoicePaymentRequested(invoiceId);
                System.out.println("Yêu cầu thanh toán thành công cho hóa đơn ID: " + invoiceId);
                response.sendRedirect(request.getContextPath() + "/PatientInvoiceServlet?status=success");
            } catch (NumberFormatException e) {
                System.err.println("Lỗi: invoiceId không hợp lệ - " + invoiceIdStr);
                response.sendRedirect(request.getContextPath() + "/PatientInvoiceServlet?status=error&message=Invalid invoice ID");
            } catch (Exception e) {
                System.err.println("Lỗi xử lý thanh toán: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/PatientInvoiceServlet?status=error&message=" + e.getMessage());
            }
            return;
        }
        // Redirect POST requests to GET to prevent duplicate form submissions
        response.sendRedirect(request.getContextPath() + "/PatientInvoiceServlet");
    }
    
    @Override
    public String getServletInfo() {
        return "Displays invoices for patient view";
    }
}