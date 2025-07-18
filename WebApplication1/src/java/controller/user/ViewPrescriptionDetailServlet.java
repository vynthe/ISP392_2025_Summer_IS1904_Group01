package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Prescriptions;
import model.service.PrescriptionService;

import java.io.IOException;
import java.time.format.DateTimeFormatter;

public class ViewPrescriptionDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            int prescriptionId = Integer.parseInt(request.getParameter("id"));

            PrescriptionService prescriptionService = new PrescriptionService();
            Prescriptions prescription = prescriptionService.getPrescriptionById(prescriptionId);

            if (prescription != null) {
                // Format thời gian
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                String createdAtFormatted = prescription.getCreatedAt() != null
                        ? prescription.getCreatedAt().format(formatter) : "N/A";
                String updatedAtFormatted = prescription.getUpdatedAt() != null
                        ? prescription.getUpdatedAt().format(formatter) : "N/A";

                request.setAttribute("prescription", prescription);
                request.setAttribute("createdAtFormatted", createdAtFormatted);
                request.setAttribute("updatedAtFormatted", updatedAtFormatted);

                request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescriptionDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn thuốc.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải đơn thuốc: " + e.getMessage());
        }
    }
}
