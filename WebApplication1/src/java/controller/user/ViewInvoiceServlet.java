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
            // ✅ SỬA: Sử dụng getExaminationResultsWithInvoice() - có join với Invoices để biết kết quả nào đã có hóa đơn
            List<Map<String, Object>> results = invoiceService.getExaminationResultsWithInvoice();

            // Truyền sang JSP
            request.setAttribute("results", results);

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