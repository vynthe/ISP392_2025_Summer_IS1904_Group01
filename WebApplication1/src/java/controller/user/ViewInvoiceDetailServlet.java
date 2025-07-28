package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.InvoiceService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;


public class ViewInvoiceDetailServlet extends HttpServlet {
    private final InvoiceService invoiceService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ✅ 1. Nhận resultId từ request parameter
            String resultIdStr = request.getParameter("resultId");
            if (resultIdStr == null || resultIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu resultId");
                return;
            }
            int resultId = Integer.parseInt(resultIdStr);

            // ✅ 2. Lấy chi tiết kết quả khám + hóa đơn (JOIN 2 bảng)
            Map<String, Object> detail = invoiceService.getExaminationResultWithInvoiceByResultId(resultId);
            if (detail == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy kết quả khám");
                return;
            }
            request.setAttribute("detail", detail);

            // ✅ 3. Forward sang JSP hiển thị chi tiết
            request.getRequestDispatcher("/views/user/Receptionist/ViewInvoiceDetail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "resultId không hợp lệ");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi truy vấn dữ liệu: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
    }
}
