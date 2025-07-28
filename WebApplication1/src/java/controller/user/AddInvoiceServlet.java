package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.service.InvoiceService;
import model.entity.Invoices;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Date;
import java.util.Map;

/**
 * Servlet xử lý chức năng thêm hóa đơn - doGet: Hiển thị form thêm hóa đơn với
 * thông tin từ kết quả khám - doPost: Xử lý thêm hóa đơn vào database
 */
public class AddInvoiceServlet extends HttpServlet {

    private final InvoiceService invoiceService = new InvoiceService();

    /**
     * Hiển thị form thêm hóa đơn với thông tin tự động điền từ kết quả khám
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ✅ VALIDATION: Kiểm tra các tham số bắt buộc
            String resultIdStr = request.getParameter("resultId");
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String serviceIdStr = request.getParameter("serviceId");
            String servicePriceStr = request.getParameter("servicePrice");

            // Kiểm tra null hoặc empty (servicePrice có thể empty)
            if (resultIdStr == null || resultIdStr.trim().isEmpty()
                    || patientIdStr == null || patientIdStr.trim().isEmpty()
                    || doctorIdStr == null || doctorIdStr.trim().isEmpty()
                    || serviceIdStr == null || serviceIdStr.trim().isEmpty()) {

                response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=Thiếu thông tin cần thiết&added=false");
                return;
            }

            // ✅ PARSE PARAMETERS: Chuyển đổi string sang các kiểu dữ liệu tương ứng
            int resultId = Integer.parseInt(resultIdStr);
            int patientId = Integer.parseInt(patientIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);

            // ✅ PARSE SERVICE PRICE: Xử lý phí dịch vụ từ database
            double servicePrice = 0.0;
            if (servicePriceStr != null && !servicePriceStr.trim().isEmpty()) {
                try {
                    servicePrice = Double.parseDouble(servicePriceStr);
                } catch (NumberFormatException e) {
                    servicePrice = 0.0; // Default value nếu parse fail
                }
            }

            // ✅ VALIDATION: Kiểm tra giá trị hợp lệ
            if (resultId <= 0 || patientId <= 0 || doctorId <= 0 || serviceId <= 0) {
                response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=Thông tin không hợp lệ&added=false");
                return;
            }

            // ✅ TRUYỀN THÔNG TIN SANG JSP: Để hiển thị form với dữ liệu tự động điền
            request.setAttribute("resultId", resultId);
            request.setAttribute("patientId", patientId);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("serviceId", serviceId);
            request.setAttribute("servicePrice", servicePrice);
            request.setAttribute("patientName", request.getParameter("patientName"));
            request.setAttribute("doctorName", request.getParameter("doctorName"));
            request.setAttribute("serviceName", request.getParameter("serviceName"));
            request.setAttribute("diagnosis", request.getParameter("diagnosis"));

            // ✅ FORWARD SANG JSP: Hiển thị form thêm hóa đơn
            request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // ✅ XỬ LÝ LỖI: Khi parse số thất bại
            System.err.println("Lỗi parse số: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=Định dạng dữ liệu không hợp lệ&added=false");
        } catch (Exception e) {
            // ✅ XỬ LÝ LỖI: Các lỗi khác
            System.err.println("Lỗi trong doGet AddInvoiceServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    /**
     * Xử lý thêm hóa đơn vào database
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ✅ VALIDATION: Kiểm tra các tham số bắt buộc
            String resultIdStr = request.getParameter("resultId");
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String serviceIdStr = request.getParameter("serviceId");
            String totalAmountStr = request.getParameter("totalAmount");

            if (resultIdStr == null || resultIdStr.trim().isEmpty()
                    || patientIdStr == null || patientIdStr.trim().isEmpty()
                    || doctorIdStr == null || doctorIdStr.trim().isEmpty()
                    || serviceIdStr == null || serviceIdStr.trim().isEmpty()
                    || totalAmountStr == null || totalAmountStr.trim().isEmpty()) {

                response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=Thiếu thông tin cần thiết&added=false");
                return;
            }

            // ✅ PARSE PARAMETERS: Chuyển đổi string sang các kiểu dữ liệu
            int resultId = Integer.parseInt(resultIdStr);
            int patientId = Integer.parseInt(patientIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            double totalAmount = Double.parseDouble(totalAmountStr);

            // ✅ VALIDATION: Kiểm tra giá trị hợp lệ
            if (resultId <= 0 || patientId <= 0 || doctorId <= 0 || serviceId <= 0 || totalAmount <= 0) {
                response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet?message=Thông tin không hợp lệ&added=false");
                return;
            }

            // ✅ LẤY THÔNG TIN USER TỪ SESSION: Thay vì hardcode
            HttpSession session = request.getSession();
            Integer createdBy = (Integer) session.getAttribute("userID");
            if (createdBy == null || createdBy <= 0) {
                // Fallback nếu không có session
                createdBy = 1; // Admin default
                System.out.println("WARNING: Không tìm thấy userID trong session, sử dụng default = 1");
            }

            // ✅ TẠO ĐỐI TƯỢNG INVOICES: Với đầy đủ thông tin
            Invoices invoice = new Invoices();
            invoice.setResultID(resultId);
            invoice.setPatientID(patientId);
            invoice.setDoctorID(doctorId);
            invoice.setServiceID(serviceId);
            invoice.setTotalAmount(totalAmount);
            invoice.setStatus("PENDING"); // Trạng thái mặc định khi tạo mới
            invoice.setCreatedBy(createdBy);
            invoice.setCreatedAt(new Date(System.currentTimeMillis()));
            invoice.setUpdatedAt(new Date(System.currentTimeMillis()));

            // ✅ THÊM HÓA ĐƠN VÀO DATABASE: Thông qua service
           boolean success = invoiceService.addInvoice(invoice);

            // ✅ Truyền thông báo qua session (để JSP đọc)
            session.setAttribute("message", success ? "Thêm hóa đơn thành công!" : "Thêm hóa đơn thất bại!");
            session.setAttribute("added", success);

            // ✅ Redirect về trang danh sách hóa đơn
            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet");

        } catch (Exception e) {
            e.printStackTrace();

            // Dùng session để truyền lỗi
            HttpSession session = request.getSession();
            session.setAttribute("message", "Thêm hóa đơn thất bại: " + e.getMessage());
            session.setAttribute("added", false);

            response.sendRedirect(request.getContextPath() + "/ViewInvoiceServlet");
        }
    }
}
