package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Invoices;
import model.service.InvoiceService;

import java.io.IOException;
import java.sql.Date;

public class AddInvoiceServlet extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy dữ liệu từ query string
            String resultIdStr = request.getParameter("resultId");
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String serviceIdStr = request.getParameter("serviceId");
            String totalAmountStr = request.getParameter("totalAmount");

            // Kiểm tra đủ dữ liệu chưa
            if (resultIdStr == null || patientIdStr == null || doctorIdStr == null
                    || serviceIdStr == null || totalAmountStr == null
                    || resultIdStr.trim().isEmpty() || patientIdStr.trim().isEmpty()
                    || doctorIdStr.trim().isEmpty() || serviceIdStr.trim().isEmpty()
                    || totalAmountStr.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu thông tin cần thiết để hiển thị form xác nhận!");
            } else {
                // Truyền dữ liệu sang JSP để hiển thị
                request.setAttribute("resultId", resultIdStr);
                request.setAttribute("patientId", patientIdStr);
                request.setAttribute("doctorId", doctorIdStr);
                request.setAttribute("serviceId", serviceIdStr);
                request.setAttribute("totalAmount", totalAmountStr);
            }

            request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String serviceIdStr = request.getParameter("serviceId");
            String totalAmountStr = request.getParameter("totalAmount");

            // Parse dữ liệu
            int patientId = Integer.parseInt(patientIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            double totalAmount = Double.parseDouble(totalAmountStr);

            // Tạo đối tượng hóa đơn
            Invoices invoice = new Invoices();
            invoice.setPatientID(patientId);
            invoice.setDoctorID(doctorId);
            invoice.setServiceID(serviceId);
            invoice.setTotalAmount(totalAmount);
            invoice.setStatus("PENDING"); // hoặc "CHƯA THANH TOÁN"
            invoice.setCreatedBy(doctorId); // tạm lấy bác sĩ làm người tạo
            invoice.setCreatedAt(new Date(System.currentTimeMillis()));
            invoice.setUpdatedAt(new Date(System.currentTimeMillis()));

            boolean added = invoiceService.addInvoice(invoice);

            String message = added ? "Thêm hóa đơn thành công!" : "Đã tồn tại hóa đơn, không thể thêm mới!";
            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=" + java.net.URLEncoder.encode(message, "UTF-8"));

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }
}
