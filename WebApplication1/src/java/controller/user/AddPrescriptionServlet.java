package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Prescriptions;
import model.entity.Medication;
import model.service.PrescriptionService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

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
            log.info("Loading AddPrescription form at " + LocalDateTime.now() + " +07");
            
            // Set UTF-8 encoding for Vietnamese support
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            // Fetch medications
            List<Medication> medications = prescriptionService.getAllMedications();
            request.setAttribute("medications", medications);
            
            // Get parameters from ViewPatientResult
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String resultIdStr = request.getParameter("resultId");
            String appointmentIdStr = request.getParameter("appointmentId");
            String patientName = request.getParameter("patientName");
            String doctorName = request.getParameter("doctorName");
            String diagnosis = request.getParameter("diagnosis");
            String notes = request.getParameter("notes");
            
            // Log parameters for debugging
            System.out.println("DEBUG - AddPrescription GET parameters at " + LocalDateTime.now() + " +07:");
            System.out.println("  - patientId: " + patientIdStr);
            System.out.println("  - doctorId: " + doctorIdStr);
            System.out.println("  - resultId: " + resultIdStr);
            System.out.println("  - appointmentId: " + appointmentIdStr);
            System.out.println("  - patientName: " + patientName);
            System.out.println("  - doctorName: " + doctorName);
            System.out.println("  - diagnosis: " + diagnosis);
            System.out.println("  - notes: " + notes);
            
            // Set patient information
            if (patientName != null && !patientName.trim().isEmpty() && !"null".equals(patientName)) {
                try {
                    patientName = java.net.URLDecoder.decode(patientName, "UTF-8");
                    request.setAttribute("patientName", patientName);
                } catch (Exception e) {
                    request.setAttribute("patientName", patientName);
                }
            } else {
                request.setAttribute("patientName", "Không xác định");
                log.warn("No patient name provided");
            }
            
            // Set doctor information
            if (doctorName != null && !doctorName.trim().isEmpty() && !"null".equals(doctorName)) {
                try {
                    doctorName = java.net.URLDecoder.decode(doctorName, "UTF-8");
                    request.setAttribute("doctorName", doctorName);
                } catch (Exception e) {
                    request.setAttribute("doctorName", doctorName);
                }
            } else {
                request.setAttribute("doctorName", "Không xác định");
                log.warn("No doctor name provided");
            }
            
            // Set diagnosis and notes for display
            if (diagnosis != null && !diagnosis.trim().isEmpty() && !"null".equals(diagnosis)) {
                try {
                    diagnosis = java.net.URLDecoder.decode(diagnosis, "UTF-8");
                    request.setAttribute("diagnosis", diagnosis);
                } catch (Exception e) {
                    request.setAttribute("diagnosis", diagnosis);
                }
            } else {
                request.setAttribute("diagnosis", "Chưa có chẩn đoán");
            }
            
            if (notes != null && !notes.trim().isEmpty() && !"null".equals(notes)) {
                try {
                    notes = java.net.URLDecoder.decode(notes, "UTF-8");
                    request.setAttribute("notes", notes);
                } catch (Exception e) {
                    request.setAttribute("notes", notes);
                }
            } else {
                request.setAttribute("notes", "Chưa có ghi chú");
            }
            
            // Create result name from diagnosis and notes
            String resultName = "Kết quả khám";
            if (diagnosis != null && !diagnosis.trim().isEmpty() && !"Chưa có chẩn đoán".equals(diagnosis)) {
                resultName = diagnosis;
            } else if (resultIdStr != null && !resultIdStr.trim().isEmpty()) {
                resultName = "Kết quả #" + resultIdStr;
            }
            request.setAttribute("resultName", resultName);
            
            // Set IDs
            request.setAttribute("patientId", patientIdStr != null ? patientIdStr : "");
            request.setAttribute("doctorId", doctorIdStr != null ? doctorIdStr : "0");
            request.setAttribute("resultId", resultIdStr != null ? resultIdStr : "");
            
            // Handle appointmentId properly
            if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty() && 
                !"null".equals(appointmentIdStr) && !"N/A".equals(appointmentIdStr)) {
                request.setAttribute("appointmentId", appointmentIdStr);
                log.info("AppointmentId set to: " + appointmentIdStr);
            } else {
                request.setAttribute("appointmentId", "");
                log.warn("No valid appointment ID provided, setting empty");
            }
            
            System.out.println("DEBUG - Final attributes set at " + LocalDateTime.now() + " +07:");
            System.out.println("  - patientName: " + request.getAttribute("patientName"));
            System.out.println("  - doctorName: " + request.getAttribute("doctorName"));
            System.out.println("  - resultName: " + request.getAttribute("resultName"));
            System.out.println("  - diagnosis: " + request.getAttribute("diagnosis"));
            System.out.println("  - notes: " + request.getAttribute("notes"));
            System.out.println("  - appointmentId: " + request.getAttribute("appointmentId"));
            System.out.println("  - medications count: " + (medications != null ? medications.size() : "null"));
            
            // Forward to JSP
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            
        } catch (SQLException e) {
            log.error("SQLException fetching medications: " + e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            request.setAttribute("errorMessage", "Lỗi khi lấy danh sách thuốc: " + e.getMessage());
            request.setAttribute("medications", java.util.Collections.emptyList());
            setDefaultAttributes(request);
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
        } catch (Exception e) {
            log.error("Unexpected error in doGet: " + e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            System.out.println("DEBUG - AddPrescription POST started at " + LocalDateTime.now() + " +07");
            
            // Set UTF-8 encoding
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            // Get form parameters
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String resultIdStr = request.getParameter("resultId");
            String appointmentIdStr = request.getParameter("appointmentId");
            String[] medicationIdStrs = request.getParameterValues("medicationIds");
            String[] quantities = request.getParameterValues("quantities");
            String[] instructions = request.getParameterValues("instructions");
            String signature = request.getParameter("signature");
            String saveToDB = request.getParameter("save");
            
            // Get display names for showing in form
            String patientName = request.getParameter("patientName");
            String doctorName = request.getParameter("doctorName");
            String resultName = request.getParameter("resultName");
            String diagnosis = request.getParameter("diagnosis");
            String notes = request.getParameter("notes");

            // Log parameters for debugging
            System.out.println("DEBUG - POST parameters at " + LocalDateTime.now() + " +07:");
            System.out.println("  - patientId: " + patientIdStr);
            System.out.println("  - doctorId: " + doctorIdStr);
            System.out.println("  - resultId: " + resultIdStr);
            System.out.println("  - appointmentId: " + appointmentIdStr);
            System.out.println("  - medicationIds: " + Arrays.toString(medicationIdStrs));
            System.out.println("  - quantities: " + Arrays.toString(quantities));
            System.out.println("  - instructions: " + Arrays.toString(instructions));
            System.out.println("  - signature: " + signature);
            System.out.println("  - saveToDB: " + saveToDB);
            System.out.println("  - patientName: " + patientName);
            System.out.println("  - doctorName: " + doctorName);
            System.out.println("  - diagnosis: " + diagnosis);
            System.out.println("  - notes: " + notes);

            // Validate required parameters
            if (patientIdStr == null || patientIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã bệnh nhân là bắt buộc.");
            }
            if (doctorIdStr == null || doctorIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã bác sĩ là bắt buộc.");
            }
            if (resultIdStr == null || resultIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Mã kết quả khám là bắt buộc.");
            }
            if (medicationIdStrs == null || medicationIdStrs.length == 0) {
                throw new IllegalArgumentException("Phải chọn ít nhất một loại thuốc.");
            }
            if (quantities == null || quantities.length == 0) {
                throw new IllegalArgumentException("Phải nhập số lượng cho từng thuốc.");
            }
            if (quantities.length != medicationIdStrs.length) {
                throw new IllegalArgumentException("Số lượng thuốc và số lượng nhập không khớp.");
            }
            if ("true".equals(saveToDB) && (signature == null || signature.trim().isEmpty())) {
                throw new IllegalArgumentException("Chữ ký bác sĩ là bắt buộc khi lưu đơn thuốc.");
            }

            // Parse IDs
            int patientId = parsePositiveInt(patientIdStr, "Mã bệnh nhân");
            int doctorId = parsePositiveInt(doctorIdStr, "Mã bác sĩ");
            int resultId = parsePositiveInt(resultIdStr, "Mã kết quả khám");
            
            // Handle appointmentId - can be null or empty
            Integer appointmentId = null;
            if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty() && 
                !"N/A".equals(appointmentIdStr) && !"null".equals(appointmentIdStr)) {
                try {
                    appointmentId = parsePositiveInt(appointmentIdStr, "Mã cuộc hẹn");
                    System.out.println("DEBUG - Parsed appointmentId: " + appointmentId);
                } catch (IllegalArgumentException e) {
                    log.warn("Invalid appointmentId: " + appointmentIdStr + ", setting to null");
                    appointmentId = null;
                }
            }

            // Parse and validate medication IDs
            List<Integer> medicationIds = Arrays.stream(medicationIdStrs)
                    .filter(id -> id != null && !id.trim().isEmpty())
                    .map(id -> parsePositiveInt(id, "Mã thuốc"))
                    .distinct()
                    .collect(Collectors.toList());

            if (medicationIds.isEmpty()) {
                throw new IllegalArgumentException("Phải chọn ít nhất một loại thuốc hợp lệ.");
            }

            // Parse and validate quantities
            List<String> quantityList = Arrays.stream(quantities)
                    .map(q -> q != null ? q.trim() : "")
                    .collect(Collectors.toList());
            for (String q : quantityList) {
                if (q.isEmpty() || !q.matches("\\d+")) {
                    throw new IllegalArgumentException("Số lượng phải là số và không được để trống.");
                }
            }
            // Ghép quantity thành chuỗi, ví dụ: "2; 1; 3"
            String quantityStr = String.join("; ", quantityList);

            System.out.println("DEBUG - Parsed medication IDs: " + medicationIds);

            // Get medication details from database
            List<Medication> allMedications = prescriptionService.getAllMedications();
            StringBuilder prescriptionDosage = new StringBuilder();
            StringBuilder instruct = new StringBuilder();
            
            for (int i = 0; i < medicationIds.size(); i++) {
                int medicationId = medicationIds.get(i);
                
                // Find medication info from list
                Medication medication = allMedications.stream()
                    .filter(med -> med.getMedicationID() == medicationId)
                    .findFirst()
                    .orElse(null);
                
                if (medication != null) {
                    // Build prescriptionDosage (KHÔNG có số lượng)
                    prescriptionDosage.append(medication.getName()).append(" - ").append(medication.getDosage());
                    prescriptionDosage.append("; ");
                    
                    // Build instruct
                    if (instructions != null && i < instructions.length && 
                        instructions[i] != null && !instructions[i].trim().isEmpty()) {
                        instruct.append(instructions[i].trim()).append("; ");
                    } else {
                        instruct.append("Không có hướng dẫn cụ thể cho ").append(medication.getName()).append("; ");
                    }
                    
                    System.out.println("DEBUG - Added medication: " + medication.getName() + " - Dosage: " + medication.getDosage() + 
                                       ", Quantity: " + (quantities != null && i < quantities.length ? quantities[i] : "N/A") +
                                       ", Instruction: " + (instructions != null && i < instructions.length ? instructions[i] : "N/A"));
                } else {
                    log.warn("Medication with ID " + medicationId + " not found");
                    prescriptionDosage.append("Thuốc ID: ").append(medicationId).append(" (Không tìm thấy); ");
                    instruct.append("Không có hướng dẫn cho thuốc ID: ").append(medicationId).append("; ");
                }
            }

            System.out.println("DEBUG - Final prescriptionDosage: " + prescriptionDosage.toString());
            System.out.println("DEBUG - Final instruct: " + instruct.toString());

            // Create prescription object
            Prescriptions prescription = new Prescriptions();
            prescription.setPatientId(patientId);
            prescription.setDoctorId(doctorId);

            if ("true".equals(saveToDB)) {
                System.out.println("DEBUG - Saving prescription to database at " + LocalDateTime.now() + " +07");
                
                // Call addPrescription with prescriptionDosage, instruct, quantity
                boolean added = prescriptionService.addPrescription(prescription, resultId, appointmentId, medicationIds, 
                                                                  signature, prescriptionDosage.toString(), instruct.toString(), quantityStr);
                
                // Set display attributes for form
                setDisplayAttributes(request, patientIdStr, doctorIdStr, resultIdStr, appointmentIdStr, 
                                   patientName, doctorName, resultName, diagnosis, notes);
                
                // Get medications for form
                request.setAttribute("medications", prescriptionService.getAllMedications());
                
                if (added) {
                    System.out.println("DEBUG - Prescription added successfully at " + LocalDateTime.now() + " +07");
                    log.info("Prescription added successfully for patientId: " + patientId + 
                             ", resultId: " + resultId + ", appointmentId: " + appointmentId + 
                             ", medicationIds: " + medicationIds + ", signature: " + signature +
                             ", dosage: " + prescriptionDosage + ", instruct: " + instruct);
                    
                    // Set success message and redirect back to ViewPatientResult
                    request.getSession().setAttribute("statusMessage", 
                        "Tạo đơn thuốc thành công cho bệnh nhân " + patientName + "!");
                    
                    String redirectUrl = request.getContextPath() + "/ViewPatientResultServlet";
                    response.sendRedirect(redirectUrl);
                    return;
                    
                } else {
                    System.out.println("DEBUG - Failed to add prescription at " + LocalDateTime.now() + " +07");
                    log.warn("Failed to add prescription for patientId: " + patientId);
                    
                    // Set error message
                    request.setAttribute("errorMessage", "Tạo đơn thuốc thất bại: Không thể lưu vào cơ sở dữ liệu.");
                }
                
                // Forward back to the same page with message
                request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
                
            } else {
                System.out.println("DEBUG - Preview mode, returning to form at " + LocalDateTime.now() + " +07");
                setFormAttributes(request, patientIdStr, doctorIdStr, resultIdStr, appointmentIdStr, 
                                medicationIdStrs, quantities, instructions, signature);
                setDisplayAttributes(request, patientIdStr, doctorIdStr, resultIdStr, appointmentIdStr, 
                                   patientName, doctorName, resultName, diagnosis, notes);
                request.setAttribute("medications", prescriptionService.getAllMedications());
                request.setAttribute("formPrescriptionDosage", prescriptionDosage.toString());
                request.setAttribute("formInstruct", instruct.toString());
                request.setAttribute("formQuantity", quantityStr);
                request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            log.error("Validation error: " + e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            
            // Set display attributes and error message
            setDisplayAttributes(request, 
                               request.getParameter("patientId"), 
                               request.getParameter("doctorId"), 
                               request.getParameter("resultId"), 
                               request.getParameter("appointmentId"),
                               request.getParameter("patientName"),
                               request.getParameter("doctorName"),
                               request.getParameter("resultName"),
                               request.getParameter("diagnosis"),
                               request.getParameter("notes"));
            
            // Preserve form data
            request.setAttribute("formSignature", request.getParameter("signature"));
            request.setAttribute("formMedicationIds", request.getParameterValues("medicationIds") != null 
                                                    ? Arrays.asList(request.getParameterValues("medicationIds")) 
                                                    : null);
            request.setAttribute("formQuantities", request.getParameterValues("quantities") != null 
                                                 ? Arrays.asList(request.getParameterValues("quantities")) 
                                                 : null);
            request.setAttribute("formInstructions", request.getParameterValues("instructions") != null 
                                                   ? Arrays.asList(request.getParameterValues("instructions")) 
                                                   : null);
            
            try {
                request.setAttribute("medications", prescriptionService.getAllMedications());
            } catch (SQLException ex) {
                request.setAttribute("medications", java.util.Collections.emptyList());
            }
            request.setAttribute("errorMessage", "Tạo đơn thuốc thất bại: " + e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            
        } catch (SQLException e) {
            log.error("SQLException adding prescription: " + e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            
            // Set display attributes and error message
            setDisplayAttributes(request, 
                               request.getParameter("patientId"), 
                               request.getParameter("doctorId"), 
                               request.getParameter("resultId"), 
                               request.getParameter("appointmentId"),
                               request.getParameter("patientName"),
                               request.getParameter("doctorName"),
                               request.getParameter("resultName"),
                               request.getParameter("diagnosis"),
                               request.getParameter("notes"));
            
            // Preserve form data
            request.setAttribute("formSignature", request.getParameter("signature"));
            request.setAttribute("formMedicationIds", request.getParameterValues("medicationIds") != null 
                                                    ? Arrays.asList(request.getParameterValues("medicationIds")) 
                                                    : null);
            request.setAttribute("formQuantities", request.getParameterValues("quantities") != null 
                                                 ? Arrays.asList(request.getParameterValues("quantities")) 
                                                 : null);
            request.setAttribute("formInstructions", request.getParameterValues("instructions") != null 
                                                   ? Arrays.asList(request.getParameterValues("instructions")) 
                                                   : null);
            
            try {
                request.setAttribute("medications", prescriptionService.getAllMedications());
            } catch (SQLException ex) {
                request.setAttribute("medications", java.util.Collections.emptyList());
            }
            request.setAttribute("errorMessage", "Tạo đơn thuốc thất bại: Lỗi cơ sở dữ liệu - " + e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            
        } catch (Exception e) {
            log.error("Unexpected error processing request: " + e.getMessage() + " at " + LocalDateTime.now() + " +07", e);
            
            // Set display attributes and error message
            setDisplayAttributes(request, 
                               request.getParameter("patientId"), 
                               request.getParameter("doctorId"), 
                               request.getParameter("resultId"), 
                               request.getParameter("appointmentId"),
                               request.getParameter("patientName"),
                               request.getParameter("doctorName"),
                               request.getParameter("resultName"),
                               request.getParameter("diagnosis"),
                               request.getParameter("notes"));
            
            // Preserve form data
            request.setAttribute("formSignature", request.getParameter("signature"));
            request.setAttribute("formMedicationIds", request.getParameterValues("medicationIds") != null 
                                                    ? Arrays.asList(request.getParameterValues("medicationIds")) 
                                                    : null);
            request.setAttribute("formQuantities", request.getParameterValues("quantities") != null 
                                                 ? Arrays.asList(request.getParameterValues("quantities")) 
                                                 : null);
            request.setAttribute("formInstructions", request.getParameterValues("instructions") != null 
                                                   ? Arrays.asList(request.getParameterValues("instructions")) 
                                                   : null);
            
            try {
                request.setAttribute("medications", prescriptionService.getAllMedications());
            } catch (SQLException ex) {
                request.setAttribute("medications", java.util.Collections.emptyList());
            }
            request.setAttribute("errorMessage", "Tạo đơn thuốc thất bại: Lỗi hệ thống - " + e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
        }
    }

    private int parsePositiveInt(String value, String fieldName) {
        try {
            int parsed = Integer.parseInt(value.trim());
            if (parsed <= 0) {
                throw new IllegalArgumentException(fieldName + " phải là số dương.");
            }
            return parsed;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Định dạng " + fieldName + " không hợp lệ.");
        }
    }

    private void setFormAttributes(HttpServletRequest request, String patientId, String doctorId, 
                                 String resultId, String appointmentId, String[] medicationIds, 
                                 String[] quantities, String[] instructions, String signature) {
        request.setAttribute("formPatientId", patientId);
        request.setAttribute("formDoctorId", doctorId);
        request.setAttribute("formResultId", resultId);
        request.setAttribute("formAppointmentId", appointmentId);
        request.setAttribute("formSignature", signature);
        if (medicationIds != null) {
            request.setAttribute("formMedicationIds", Arrays.asList(medicationIds));
        }
        if (quantities != null) {
            request.setAttribute("formQuantities", Arrays.asList(quantities));
        }
        if (instructions != null) {
            request.setAttribute("formInstructions", Arrays.asList(instructions));
        }
    }
    
    private void setDisplayAttributes(HttpServletRequest request, String patientId, String doctorId, 
                                    String resultId, String appointmentId, String patientName, 
                                    String doctorName, String resultName, String diagnosis, String notes) {
        // Set IDs
        request.setAttribute("patientId", patientId != null ? patientId : "");
        request.setAttribute("doctorId", doctorId != null ? doctorId : "0");
        request.setAttribute("resultId", resultId != null ? resultId : "");
        
        // Handle appointmentId
        if (appointmentId != null && !appointmentId.trim().isEmpty() && 
            !"null".equals(appointmentId) && !"N/A".equals(appointmentId)) {
            request.setAttribute("appointmentId", appointmentId);
        } else {
            request.setAttribute("appointmentId", "");
        }
        
        // Set display names with URL decoding
        try {
            if (patientName != null && !patientName.trim().isEmpty() && !"null".equals(patientName)) {
                request.setAttribute("patientName", java.net.URLDecoder.decode(patientName, "UTF-8"));
            } else {
                request.setAttribute("patientName", "Không xác định");
            }
            
            if (doctorName != null && !doctorName.trim().isEmpty() && !"null".equals(doctorName)) {
                request.setAttribute("doctorName", java.net.URLDecoder.decode(doctorName, "UTF-8"));
            } else {
                request.setAttribute("doctorName", "Không xác định");
            }
            
            if (resultName != null && !resultName.trim().isEmpty() && !"null".equals(resultName)) {
                request.setAttribute("resultName", java.net.URLDecoder.decode(resultName, "UTF-8"));
            } else if (resultId != null && !resultId.trim().isEmpty()) {
                request.setAttribute("resultName", "Kết quả #" + resultId);
            } else {
                request.setAttribute("resultName", "Không xác định");
            }
            
            // Set diagnosis and notes
            if (diagnosis != null && !diagnosis.trim().isEmpty() && !"null".equals(diagnosis)) {
                request.setAttribute("diagnosis", java.net.URLDecoder.decode(diagnosis, "UTF-8"));
            } else {
                request.setAttribute("diagnosis", "Chưa có chẩn đoán");
            }
            
            if (notes != null && !notes.trim().isEmpty() && !"null".equals(notes)) {
                request.setAttribute("notes", java.net.URLDecoder.decode(notes, "UTF-8"));
            } else {
                request.setAttribute("notes", "Chưa có ghi chú");
            }
            
        } catch (Exception e) {
            log.warn("Error decoding display names: " + e.getMessage());
            request.setAttribute("patientName", patientName != null ? patientName : "Không xác định");
            request.setAttribute("doctorName", doctorName != null ? doctorName : "Không xác định");
            request.setAttribute("resultName", resultName != null ? resultName : "Không xác định");
            request.setAttribute("diagnosis", diagnosis != null ? diagnosis : "Chưa có chẩn đoán");
            request.setAttribute("notes", notes != null ? notes : "Chưa có ghi chú");
        }
    }
    
    private void setDefaultAttributes(HttpServletRequest request) {
        request.setAttribute("patientName", "Không xác định");
        request.setAttribute("doctorName", "Không xác định");
        request.setAttribute("resultName", "Không xác định");
        request.setAttribute("diagnosis", "Chưa có chẩn đoán");
        request.setAttribute("notes", "Chưa có ghi chú");
        request.setAttribute("patientId", "");
        request.setAttribute("doctorId", "0");
        request.setAttribute("resultId", "");
        request.setAttribute("appointmentId", "");
    }
}