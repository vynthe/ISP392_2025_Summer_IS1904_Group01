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
            // Lấy danh sách kết quả khám đã JOIN với hóa đơn
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
        try {
            String invoiceIdStr = request.getParameter("invoiceId");
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String totalAmountStr = request.getParameter("totalAmount");
            String serviceIdStr = request.getParameter("serviceId");

            System.out.println("DEBUG POST - invoiceId: " + invoiceIdStr);
            System.out.println("DEBUG POST - patientId: " + patientIdStr);
            System.out.println("DEBUG POST - doctorId: " + doctorIdStr);
            System.out.println("DEBUG POST - totalAmount: " + totalAmountStr);
            System.out.println("DEBUG POST - serviceId: " + serviceIdStr);

            if (patientIdStr == null || doctorIdStr == null || totalAmountStr == null || serviceIdStr == null
                    || patientIdStr.trim().isEmpty() || doctorIdStr.trim().isEmpty() || totalAmountStr.trim().isEmpty() || serviceIdStr.trim().isEmpty()) {

                System.out.println("DEBUG POST - Missing required form data");
                request.setAttribute("message", "Missing required form data.");

                int patientId = 0;
                try {
                    if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
                        patientId = Integer.parseInt(patientIdStr.trim());
                    }
                } catch (NumberFormatException e) {
                    System.out.println("DEBUG POST - Invalid patientId: " + patientIdStr);
                }

                String redirectUrl = request.getContextPath() + "/ViewInvoiceServlet";
                if (patientId > 0) {
                    redirectUrl += "?patientId=" + patientId;
                }
                response.sendRedirect(redirectUrl);
                return;
            }

            int patientId = Integer.parseInt(patientIdStr.trim());
            int doctorId = Integer.parseInt(doctorIdStr.trim());
            double totalAmount = Double.parseDouble(totalAmountStr.trim());
            int serviceId = Integer.parseInt(serviceIdStr.trim());
            // invoiceId có thể là null nếu là hóa đơn mới
            int invoiceId = (invoiceIdStr != null && !invoiceIdStr.trim().isEmpty()) ? Integer.parseInt(invoiceIdStr.trim()) : 0;

            System.out.println("DEBUG POST - Parsed values: patientId=" + patientId + ", doctorId=" + doctorId
                    + ", totalAmount=" + totalAmount + ", serviceId=" + serviceId + ", invoiceId=" + invoiceId);

            // Invoices invoice = new Invoices(); // This line is removed as per the new_code
            // invoice.setPatientID(patientId); // This line is removed as per the new_code
            // invoice.setDoctorID(doctorId); // This line is removed as per the new_code
            // invoice.setTotalAmount(totalAmount); // This line is removed as per the new_code
            // invoice.setStatus("PENDING"); // This line is removed as per the new_code
            // invoice.setServiceID(serviceId); // This line is removed as per the new_code
            // invoice.setCreatedBy(doctorId); // This line is removed as per the new_code
            // invoice.setCreatedAt(new java.sql.Date(System.currentTimeMillis())); // This line is removed as per the new_code
            // invoice.setUpdatedAt(new java.sql.Date(System.currentTimeMillis())); // This line is removed as per the new_code

            // boolean added = invoiceService.addInvoice(invoice); // This line is removed as per the new_code
            // System.out.println("DEBUG POST - Invoice added: " + added); // This line is removed as per the new_code

            // String message = added ? "Invoice added successfully!" : "Failed to add invoice."; // This line is removed as per the new_code

            // String redirectUrl = request.getContextPath() + "/ViewInvoiceServlet?patientId=" + patientId + "&message=" + java.net.URLEncoder.encode(message, "UTF-8"); // This line is removed as per the new_code
            // response.sendRedirect(redirectUrl); // This line is removed as per the new_code

        } catch (NumberFormatException e) {
            System.err.println("DEBUG POST - NumberFormatException: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input data: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("DEBUG POST - Unexpected exception: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }
}
