package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.PrescriptionsService;
import java.sql.SQLException;
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

        String doctorIdStr = request.getParameter("doctorID");
        String patientIdStr = request.getParameter("patientID");
        String prescriptionDetails = request.getParameter("prescriptionDetails");
        String status = request.getParameter("status");
        String resultIdStr = request.getParameter("resultID");
        String appointmentIdStr = request.getParameter("appointmentID");

        request.setAttribute("doctorID", doctorIdStr);
        request.setAttribute("patientID", patientIdStr);
        request.setAttribute("prescriptionDetails", prescriptionDetails);
        request.setAttribute("status", status);
        request.setAttribute("resultID", resultIdStr);
        request.setAttribute("appointmentID", appointmentIdStr);

        Integer doctorId;
        Integer patientId;
        Integer resultId = null;
        Integer appointmentId = null;
        try {
            doctorId = (doctorIdStr != null && !doctorIdStr.trim().isEmpty()) ? Integer.parseInt(doctorIdStr) : null;
            patientId = (patientIdStr != null && !patientIdStr.trim().isEmpty()) ? Integer.parseInt(patientIdStr) : null;
            if (doctorId != null && doctorId <= 0) {
                throw new NumberFormatException("Doctor ID must be a positive integer");
            }
            if (patientId != null && patientId <= 0) {
                throw new NumberFormatException("Patient ID must be a positive integer");
            }
            if (resultIdStr != null && !resultIdStr.trim().isEmpty()) {
                resultId = Integer.parseInt(resultIdStr);
                if (resultId <= 0) throw new NumberFormatException("Result ID must be a positive integer");
            }
            if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty()) {
                appointmentId = Integer.parseInt(appointmentIdStr);
                if (appointmentId <= 0) throw new NumberFormatException("Appointment ID must be a positive integer");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: DoctorID=" + doctorIdStr + ", PatientID=" + patientIdStr + ", ResultID=" + resultIdStr + ", AppointmentID=" + appointmentIdStr + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("error", "Doctor ID, Patient ID, Result ID, và Appointment ID phải là số nguyên dương.");
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            return;
        }

        if (doctorId == null || patientId == null) {
            request.setAttribute("error", "Doctor ID và Patient ID là bắt buộc.");
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
                createdBy =1; // Default fallback
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

            prescriptionDetails = prescriptionDetails != null ? prescriptionDetails.trim() : "";

            Timestamp createdAt = new Timestamp(System.currentTimeMillis());
            boolean success = prescriptionsService.addPrescription(doctorId, patientId, prescriptionDetails, status, createdAt, createdBy, resultId, appointmentId);

            if (success) {
                System.out.println("Prescription added successfully: DoctorID=" + doctorId + ", PatientID=" + patientId + " at " + LocalDateTime.now() + " +07");
                response.sendRedirect(request.getContextPath() + "/ViewPrescriptionServlet?success=Thêm toa thuốc thành công!");
            } else {
                System.out.println("Failed to add prescription: DoctorID=" + doctorId + ", PatientID=" + patientId + " at " + LocalDateTime.now() + " +07");
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