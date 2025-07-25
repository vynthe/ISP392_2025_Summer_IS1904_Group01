package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Prescriptions;
import model.service.PrescriptionService;
import model.service.AppointmentService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@WebServlet(name = "ViewPrescriptionDetailServlet", urlPatterns = {"/ViewPrescriptionDetailServlet"})
public class ViewPrescriptionDetailServlet extends HttpServlet {
    private final PrescriptionService prescriptionService = new PrescriptionService();
    private final AppointmentService appointmentService = new AppointmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Lấy prescriptionId nếu có
            String prescriptionIdStr = request.getParameter("id");
            Prescriptions prescription = null;
            Integer prescriptionId = null;
            if (prescriptionIdStr != null && !prescriptionIdStr.trim().isEmpty()) {
                try {
                    prescriptionId = Integer.parseInt(prescriptionIdStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            // Lấy các tham số khác nếu không có prescriptionId
            String resultIdStr = request.getParameter("resultId");
            String appointmentIdStr = request.getParameter("appointmentId");
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String patientName = request.getParameter("patientName");
            String doctorName = request.getParameter("doctorName");
            String resultName = request.getParameter("resultName");

            Integer resultId = null, appointmentId = null, patientId = null, doctorId = null;
            try { if (resultIdStr != null && !resultIdStr.isEmpty()) resultId = Integer.parseInt(resultIdStr); } catch (Exception ignored) {}
            try { if (appointmentIdStr != null && !appointmentIdStr.isEmpty()) appointmentId = Integer.parseInt(appointmentIdStr); } catch (Exception ignored) {}
            try { if (patientIdStr != null && !patientIdStr.isEmpty()) patientId = Integer.parseInt(patientIdStr); } catch (Exception ignored) {}
            try { if (doctorIdStr != null && !doctorIdStr.isEmpty()) doctorId = Integer.parseInt(doctorIdStr); } catch (Exception ignored) {}

            // Lấy prescription nếu có prescriptionId
            if (prescriptionId != null) {
                prescription = prescriptionService.getPrescriptionById(prescriptionId);
            } else if (resultId != null) {
                // Nếu không có prescriptionId, có thể lấy prescription theo resultId (nếu có logic này)
                // TODO: Nếu có method prescriptionService.getPrescriptionByResultId(resultId) thì dùng ở đây
            }

            // Lấy thông tin lịch hẹn nếu có appointmentId
            Map<String, Object> appointmentInfo = null;
            if (appointmentId != null) {
                try {
                    appointmentInfo = appointmentService.getAppointmentById(appointmentId);
                } catch (SQLException ignored) {}
            }

            // Định dạng thời gian
            String createdAtFormatted = "N/A", updatedAtFormatted = "N/A";
            if (prescription != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                if (prescription.getCreatedAt() != null)
                    createdAtFormatted = prescription.getCreatedAt().format(formatter);
                if (prescription.getUpdatedAt() != null)
                    updatedAtFormatted = prescription.getUpdatedAt().format(formatter);
            }

            // Lấy message từ session (nếu có)
            HttpSession session = request.getSession();
            String message = (String) session.getAttribute("message");
            if (message != null) {
                request.setAttribute("message", message);
                session.removeAttribute("message");
            }

            // Truyền các trường cần thiết sang JSP
            request.setAttribute("prescription", prescription);
            request.setAttribute("createdAtFormatted", createdAtFormatted);
            request.setAttribute("updatedAtFormatted", updatedAtFormatted);
            request.setAttribute("appointmentId", appointmentId);
            request.setAttribute("patientName", patientName);
            request.setAttribute("doctorName", doctorName);
            request.setAttribute("resultName", resultName);
            request.setAttribute("appointmentInfo", appointmentInfo);
            request.setAttribute("resultId", resultId);
            request.setAttribute("patientId", patientId);
            request.setAttribute("doctorId", doctorId);

            // Chuyển tiếp đến JSP để hiển thị chi tiết
            request.getRequestDispatcher("/views/user/DoctorNurse/ViewPrescriptionDetail.jsp")
                   .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải đơn thuốc: " + e.getMessage());
        }
    }
}
