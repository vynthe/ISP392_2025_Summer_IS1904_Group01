package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.InvoiceService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class ViewInvoiceServlet extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ✅ BỔ SUNG: Xử lý message từ ConfirmPaymentServlet
            String message = request.getParameter("message");
            String added = request.getParameter("added");
            
            if (message != null) {
                request.setAttribute("message", message);
                request.setAttribute("added", "true".equals(added));
            }
            
            // ✅ BỔ SUNG: Xử lý tìm kiếm với 2 từ khóa
            String keyword1 = request.getParameter("keyword1");
            String keyword2 = request.getParameter("keyword2");
            
            List<Map<String, Object>> results;
            int totalRecords;
            int currentPage = 1;
            int pageSize = 10;
            
            // ✅ KIỂM TRA: Nếu có từ khóa tìm kiếm thì dùng hàm search, không thì dùng hàm get tất cả
            if ((keyword1 != null && !keyword1.trim().isEmpty()) || 
                (keyword2 != null && !keyword2.trim().isEmpty())) {
                
                // ✅ SỬ DỤNG HÀM SEARCH MỚI VỚI 2 TỪ KHÓA
                results = invoiceService.searchExaminationResultsByPatientAndService(
                    keyword1 != null ? keyword1.trim() : "", 
                    keyword2 != null ? keyword2.trim() : "",
                    currentPage, pageSize
                );
                
                totalRecords = invoiceService.getTotalCountExaminationResultsByPatientAndService(
                    keyword1 != null ? keyword1.trim() : "", 
                    keyword2 != null ? keyword2.trim() : ""
                );
                
                // ✅ TRUYỀN TỪ KHÓA TÌM KIẾM VỀ JSP
                request.setAttribute("keyword1", keyword1);
                request.setAttribute("keyword2", keyword2);
                
            } else {
                // ✅ SỬ DỤNG HÀM GET TẤT CẢ (LOGIC CŨ)
                results = invoiceService.getExaminationResultsWithInvoice();
                totalRecords = results.size();
            }
            
            // ✅ TÍNH TOÁN PHÂN TRANG
            int totalPages = invoiceService.getTotalPages(totalRecords, pageSize);
            
            // ✅ TRUYỀN DỮ LIỆU SANG JSP
            request.setAttribute("results", results);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            // Forward sang trang JSP hiển thị danh sách hóa đơn
            request.getRequestDispatcher("/views/user/Receptionist/ViewInvoice.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("message", "Database error: " + e.getMessage());
            request.setAttribute("results", List.of());
            request.getRequestDispatcher("/views/user/Receptionist/ViewInvoice.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}