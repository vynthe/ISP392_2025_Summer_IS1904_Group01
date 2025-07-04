package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Prescriptions;
import model.service.PrescriptionService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AddPrescriptionServlet", urlPatterns = {"/AddPrescriptionServlet"})
public class AddPrescriptionServlet extends HttpServlet {
    private static final Log log = LogFactory.getLog(AddPrescriptionServlet.class);
    private PrescriptionService prescriptionService;

    @Override
    public void init() throws ServletException {
        prescriptionService = new PrescriptionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("medications", prescriptionService.getAllMedications());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
        } catch (SQLException e) {
            log.error("SQLException fetching medications: " + e.getMessage(), e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy danh sách thuốc: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String prescriptionDetails = request.getParameter("prescriptionDetails");
            String status = request.getParameter("status");
            String[] medicationIdStrs = request.getParameterValues("medicationIds");
            String[] dosageInstructions = request.getParameterValues("dosageInstructions");
            String saveToDB = request.getParameter("save");

            // Validation
            if (patientIdStr == null || patientIdStr.trim().isEmpty() || !patientIdStr.matches("\\d+")) {
                throw new IllegalArgumentException("Invalid or missing Patient ID.");
            }
            if (doctorIdStr == null || doctorIdStr.trim().isEmpty() || !doctorIdStr.matches("\\d+")) {
                throw new IllegalArgumentException("Invalid or missing Doctor ID.");
            }
            if (status == null || status.trim().isEmpty()) {
                throw new IllegalArgumentException("Status is required.");
            }
            // Validate status against allowed values
            List<String> validStatuses = Arrays.asList("Pending", "In Progress", "Completed", "Dispensed", "Cancelled");
            String trimmedStatus = status.trim();
            if (!validStatuses.contains(trimmedStatus)) {
                throw new IllegalArgumentException("Trạng thái không hợp lệ. Chỉ chấp nhận: " + String.join(", ", validStatuses) + ".");
            }
            if (medicationIdStrs == null || medicationIdStrs.length == 0 || Arrays.stream(medicationIdStrs).anyMatch(id -> !id.matches("\\d+"))) {
                throw new IllegalArgumentException("At least one valid medication ID is required.");
            }
            if (dosageInstructions == null || dosageInstructions.length == 0 || Arrays.stream(dosageInstructions).anyMatch(di -> di == null || di.trim().isEmpty())) {
                throw new IllegalArgumentException("Dosage instructions are required for each medication.");
            }
            if (medicationIdStrs.length != dosageInstructions.length) {
                throw new IllegalArgumentException("Number of medications and dosage instructions must match.");
            }

            int patientId = Integer.parseInt(patientIdStr);
            int doctorId = Integer.parseInt(doctorIdStr);
            List<Integer> medicationIds = Arrays.stream(medicationIdStrs)
                    .map(Integer::parseInt)
                    .toList();

            if (patientId <= 0 || doctorId <= 0 || medicationIds.stream().anyMatch(id -> id <= 0)) {
                throw new IllegalArgumentException("All IDs must be positive integers.");
            }

            log.info("Processing add request - patientId: " + patientId + ", doctorId: " + doctorId +
                     ", status: " + trimmedStatus + ", medicationIds: " + Arrays.toString(medicationIdStrs));

            Prescriptions prescription = new Prescriptions();
            prescription.setPatientId(patientId);
            prescription.setDoctorId(doctorId);
            prescription.setPrescriptionDetails(prescriptionDetails);
            prescription.setStatus(trimmedStatus);

            if ("true".equals(saveToDB)) {
                boolean added = prescriptionService.addPrescription(prescription, medicationIds, Arrays.asList(dosageInstructions));
                if (added) {
                    log.info("Prescription added successfully for patientId: " + patientId + ", medicationIds: " + Arrays.toString(medicationIdStrs));
                    request.getSession().setAttribute("statusMessage", "Tạo thành công");
                } else {
                    log.warn("Failed to add prescription for patientId: " + patientId + ", medicationIds: " + Arrays.toString(medicationIdStrs));
                    request.getSession().setAttribute("statusMessage", "Tạo thất bại");
                }
                response.sendRedirect(request.getContextPath() + "/ViewPrescriptionServlet");
            } else {
                log.info("Save not requested, returning to form for patientId: " + patientId);
                setFormAttributes(request, patientIdStr, doctorIdStr, prescriptionDetails, trimmedStatus, medicationIdStrs, dosageInstructions);
                request.setAttribute("medications", prescriptionService.getAllMedications());
                request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            log.error("Invalid number format in form input: " + e.getMessage(), e);
            request.getSession().setAttribute("statusMessage", "Tạo thất bại: Vui lòng nhập số hợp lệ cho các trường ID.");
            response.sendRedirect(request.getContextPath() + "/ViewPrescriptionServlet");
        } catch (IllegalArgumentException e) {
            log.error("Validation error: " + e.getMessage(), e);
            request.getSession().setAttribute("statusMessage", "Tạo thất bại: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewPrescriptionServlet");
        } catch (SQLException e) {
            log.error("SQLException adding prescription: " + e.getMessage(), e);
            request.getSession().setAttribute("statusMessage", "Tạo thất bại: Lỗi cơ sở dữ liệu - " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewPrescriptionServlet");
        } catch (Exception e) {
            log.error("Unexpected error processing request: " + e.getMessage(), e);
            request.getSession().setAttribute("statusMessage", "Tạo thất bại: Lỗi hệ thống - " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewPrescriptionServlet");
        }
    }

    private void setFormAttributes(HttpServletRequest request, String patientId, String doctorId,
                                  String prescriptionDetails, String status,
                                  String[] medicationIds, String[] dosageInstructions) {
        request.setAttribute("formPatientId", patientId);
        request.setAttribute("formDoctorId", doctorId);
        request.setAttribute("formPrescriptionDetails", prescriptionDetails);
        request.setAttribute("formStatus", status);
        request.setAttribute("formMedicationIds", medicationIds);
        request.setAttribute("formDosageInstructions", dosageInstructions);
    }
}