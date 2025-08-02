package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.InvoiceService;
import java.io.IOException;
import java.sql.SQLException;

/**
 * ✅ SERVLET MỚI: Xử lý khi lễ tân ấn nút "Xác nhận thanh toán"
 * Cập nhật trạng thái hóa đơn từ PENDING thành PAID
 */
@WebServlet(name="ConfirmPaymentServlet", urlPatterns={"/ConfirmPaymentServlet"})
public class ConfirmPaymentServlet extends HttpServlet {
    
    private final InvoiceService invoiceService = new InvoiceService();
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ✅ Lấy InvoiceID từ form
        String invoiceIdStr = request.getParameter("invoiceId");
        
        try {
            // ✅ Validate và parse InvoiceID
            if (invoiceIdStr == null || invoiceIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("InvoiceID không được để trống");
            }
            
            int invoiceId = Integer.parseInt(invoiceIdStr);
            
            // ✅ Gọi service để xác nhận thanh toán
            boolean success = invoiceService.confirmInvoicePaid(invoiceId);
            
            if (success) {
                // ✅ Thành công: Redirect với thông báo thành công
                response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=success&added=true");
            } else {
                // ✅ Thất bại: Redirect với thông báo lỗi
                response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=error&added=false");
            }
            
        } catch (NumberFormatException e) {
            // ✅ Lỗi: InvoiceID không phải số
            System.err.println("ConfirmPaymentServlet: InvoiceID không hợp lệ: " + invoiceIdStr);
            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=error&added=false");
            
        } catch (IllegalArgumentException e) {
            // ✅ Lỗi: Tham số không hợp lệ
            System.err.println("ConfirmPaymentServlet: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=error&added=false");
            
        } catch (SQLException e) {
            // ✅ Lỗi: Database
            System.err.println("ConfirmPaymentServlet: SQL Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=error&added=false");
            
        } catch (Exception e) {
            // ✅ Lỗi: Khác
            System.err.println("ConfirmPaymentServlet: Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=error&added=false");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // ✅ Redirect GET request về ViewInvoiceServlet
        response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet");
    }
} 