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
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String serviceIdStr = request.getParameter("serviceId");
            String resultIdStr = request.getParameter("resultId");

            System.out.println("[DEBUG] patientIdStr = " + patientIdStr);
            System.out.println("[DEBUG] doctorIdStr = " + doctorIdStr);
            System.out.println("[DEBUG] serviceIdStr = " + serviceIdStr);
            System.out.println("[DEBUG] resultIdStr = " + resultIdStr);

            int patientId = Integer.parseInt(patientIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            int serviceId = Integer.parseInt(serviceIdStr);
            int resultId = resultIdStr != null && !resultIdStr.isEmpty() ? Integer.parseInt(resultIdStr) : 0;

            // Láº¥y thĂ´ng tin dá»‹ch vá»¥
            Services_Service servicesService = new Services_Service();
            Services service = servicesService.getServiceById(serviceId);
            System.out.println("[DEBUG] service = " + (service != null ? service.getServiceName() : "null"));

            if (service == null) {
                request.setAttribute("error", "KhĂ´ng tĂ¬m tháº¥y dá»‹ch vá»¥ vá»›i ID: " + serviceId);
                request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);
                return;
            }

            // Truyá»�n thĂ´ng tin sang JSP xĂ¡c nháº­n
            request.setAttribute("patientId", patientId);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("serviceId", serviceId);
            request.setAttribute("resultId", resultId);
            request.setAttribute("serviceName", service.getServiceName());
            request.setAttribute("servicePrice", service.getPrice());

            // CĂ³ thá»ƒ láº¥y thĂªm tĂªn bá»‡nh nhĂ¢n, bĂ¡c sÄ© náº¿u cáº§n

            request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "CĂ³ lá»—i khi xĂ¡c nháº­n thanh toĂ¡n: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Receptionist/AddInvoice.jsp").forward(request, response);
        }
    }
} 