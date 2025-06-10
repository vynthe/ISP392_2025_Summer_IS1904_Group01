package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.PrescriptionsService;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@WebServlet(name = "AddPrescriptionServlet", urlPatterns = {"/AddPrescriptionServlet" })
public class AddPrescriptionServlet extends HttpServlet {

    private PrescriptionsService prescriptionsService;

    @Override
    public void init() throws ServletException {
        prescriptionsService = new PrescriptionsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String prescriptionDetails = request.getParameter("prescriptionDetails");
        String status = request.getParameter("status");
        String resultIdStr = request.getParameter("resultID");
        String appointmentIdStr = request.getParameter("appointmentID");

        request.setAttribute("prescriptionDetails", prescriptionDetails);
        request.setAttribute("status", status);
        request.setAttribute("resultID", resultIdStr);
        request.setAttribute("appointmentID", appointmentIdStr);

        Integer resultId = null;
        Integer appointmentId = null;
        try {
            if (resultIdStr != null && !resultIdStr.trim().isEmpty()) {
                resultId = Integer.parseInt(resultIdStr);
                if (resultId <= 0) throw new NumberFormatException("Result ID phải là số nguyên dương.");
            }
            if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty()) {
                appointmentId = Integer.parseInt(appointmentIdStr);
                if (appointmentId <= 0) throw new NumberFormatException("Appointment ID phải là số nguyên dương.");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: ResultID=" + resultIdStr + ", AppointmentID=" + appointmentIdStr + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("error", "Result ID và Appointment ID phải là số nguyên dương.");
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            return;
        }

        status = (status != null && !status.trim().isEmpty()) ? status.trim() : "Pending";
        if (!status.equals("Pending") && !status.equals("In Progress") && !status.equals("Completed") && !status.equals("Dispensed") && !status.equals("Cancelled")) {
            throw new IllegalArgumentException("Trạng thái phải là 'Pending', 'In Progress', 'Completed', 'Dispensed', hoặc 'Cancelled'.");
        }

        try {
            String createdByStr = request.getParameter("createdBy");
            Integer createdBy = null;
            if (createdByStr == null || createdByStr.trim().isEmpty()) {
                createdBy = 1; // Default fallback
                System.out.println("createdBy not found in request, using default: " + createdBy + " at " + LocalDateTime.now() + " +07");
            } else {
                try {
                    createdBy = Integer.parseInt(createdByStr);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid createdBy format: " + createdByStr + " at " + LocalDateTime.now() + " +07");
                    request.setAttribute("error", "ID người tạo không hợp lệ.");
                    request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
                    return;
                }
            }

            // Lấy thêm doctorId và patientId từ request
            String doctorIdStr = request.getParameter("doctorId");
            String patientIdStr = request.getParameter("patientId");
            
            Integer doctorId = 1; // Default value nếu không có
            Integer patientId = 1; // Default value nếu không có
            
            if (doctorIdStr != null && !doctorIdStr.trim().isEmpty()) {
                try {
                    doctorId = Integer.parseInt(doctorIdStr);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid doctorId format: " + doctorIdStr + " at " + LocalDateTime.now() + " +07");
                }
            }
            
            if (patientIdStr != null && !patientIdStr.trim().isEmpty()) {
                try {
                    patientId = Integer.parseInt(patientIdStr);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid patientId format: " + patientIdStr + " at " + LocalDateTime.now() + " +07");
                }
            }

            prescriptionDetails = prescriptionDetails != null ? prescriptionDetails.trim() : "";

            Timestamp createdAt = new Timestamp(System.currentTimeMillis());
            
            // Gọi method với đúng số tham số: doctorId, patientId, prescriptionDetails, status, createdAt, createdBy
            boolean success = prescriptionsService.addPrescription(doctorId, patientId, prescriptionDetails, status, createdAt, createdBy);

            if (success) {
                System.out.println("Prescription added successfully at " + LocalDateTime.now() + " +07");
                response.sendRedirect(request.getContextPath() + "/ViewPrescriptionServlet?success=Thêm toa thuốc thành công!");
            } else {
                System.out.println("Failed to add prescription at " + LocalDateTime.now() + " +07");
                request.setAttribute("error", "Không thể thêm toa thuốc. Vui lòng thử lại.");
                request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            System.out.println("Validation error: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
        }
    }
}