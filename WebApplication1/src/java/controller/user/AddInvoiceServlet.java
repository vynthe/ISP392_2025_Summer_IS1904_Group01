package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Services;
import model.service.Services_Service;
import java.io.IOException;
import java.sql.SQLException;

public class AddInvoiceServlet extends HttpServlet {
    @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy các tham số từ request
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String serviceIdStr = request.getParameter("serviceId");
            String resultIdStr = request.getParameter("resultId");

            System.out.println("[DEBUG] patientIdStr = " + patientIdStr);
            System.out.println("[DEBUG] doctorIdStr = " + doctorIdStr);
            System.out.println("[DEBUG] serviceIdStr = " + serviceIdStr);
            System.out.println("[DEBUG] resultIdStr = " + resultIdStr);

            // Ép kiểu các giá trị ID
            int patientId = Integer.parseInt(patientIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            int resultId = (resultIdStr != null && !resultIdStr.isEmpty()) ? Integer.parseInt(resultIdStr) : 0;

            // Lấy thông tin dịch vụ từ Service
            Services_Service servicesService = new Services_Service();
            Services service = servicesService.getServiceById(serviceId);

            System.out.println("[DEBUG] service = " + (service != null ? service.getServiceName() : "null"));

            if (service == null) {
                request.setAttribute("error", "Không tìm thấy dịch vụ với ID: " + serviceId);
                request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);
                return;
            }

            // Truyền dữ liệu cần thiết sang JSP để xác nhận
            request.setAttribute("patientId", patientId);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("serviceId", serviceId);
            request.setAttribute("resultId", resultId);
            request.setAttribute("serviceName", service.getServiceName());
            request.setAttribute("servicePrice", service.getPrice());

            request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi khi xác nhận thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);
        }
    }
} 