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
        log.info("Loading AddPrescription form at " + java.time.LocalDateTime.now() + " +07");
        
        // Set UTF-8 encoding for Vietnamese support
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Fetch medications
        List<model.entity.Medication> medications = prescriptionService.getAllMedications();
        request.setAttribute("medications", medications);
        
        // Get parameters
        String patientIdStr = request.getParameter("patientId");
        String doctorIdStr = request.getParameter("doctorId");
        String resultIdStr = request.getParameter("resultId");
        String appointmentIdStr = request.getParameter("appointmentId");
        String patientName = request.getParameter("patientName");
        String doctorName = request.getParameter("doctorName");
        String resultName = request.getParameter("resultName");
        
        // Log parameters
        log.info("Received GET parameters - patientId: " + patientIdStr + ", doctorId: " + doctorIdStr + 
                 ", resultId: " + resultIdStr + ", appointmentId: " + appointmentIdStr + 
                 ", patientName: " + patientName + ", doctorName: " + doctorName + 
                 ", resultName: " + resultName);
        
        // Decode and set patient name
        if (patientName != null && !patientName.trim().isEmpty()) {
            patientName = java.net.URLDecoder.decode(patientName, "UTF-8");
            request.setAttribute("patientName", patientName);
        } else {
            request.setAttribute("patientName", "Không xác định");
            log.warn("No patient name provided");
        }
        
        // Decode and set doctor name
        if (doctorName != null && !doctorName.trim().isEmpty()) {
            doctorName = java.net.URLDecoder.decode(doctorName, "UTF-8");
            request.setAttribute("doctorName", doctorName);
        } else {
            request.setAttribute("doctorName", "Không xác định");
            log.warn("No doctor name provided");
        }
        
        // Set result name
        if (resultName != null && !resultName.trim().isEmpty()) {
            resultName = java.net.URLDecoder.decode(resultName, "UTF-8");
            request.setAttribute("resultName", resultName);
        } else if (resultIdStr != null && !resultIdStr.trim().isEmpty()) {
            request.setAttribute("resultName", "Kết quả #" + resultIdStr);
        } else {
            request.setAttribute("resultName", "Không xác định");
            log.warn("No result name provided");
        }
        
        // Set IDs
        request.setAttribute("patientId", patientIdStr);
        request.setAttribute("doctorId", doctorIdStr);
        request.setAttribute("resultId", resultIdStr);
        
        // FIXED: Xử lý appointmentId tốt hơn
        if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty() && !"null".equals(appointmentIdStr)) {
            request.setAttribute("appointmentId", appointmentIdStr);
            log.info("AppointmentId set to: " + appointmentIdStr);
        } else {
            // Nếu không có appointmentId, cố gắng lấy từ database dựa trên resultId
            if (resultIdStr != null && !resultIdStr.trim().isEmpty()) {
                try {
                    int resultId = Integer.parseInt(resultIdStr);
                    // Có thể thêm method để get appointmentId từ resultId
                    // String appointmentIdFromDB = prescriptionService.getAppointmentIdByResultId(resultId);
                    // if (appointmentIdFromDB != null) {
                    //     request.setAttribute("appointmentId", appointmentIdFromDB);
                    //     log.info("AppointmentId retrieved from DB: " + appointmentIdFromDB);
                    // } else {
                        request.setAttribute("appointmentId", "N/A");
                        log.warn("No appointment ID found for resultId: " + resultId);
                    // }
                } catch (NumberFormatException e) {
                    request.setAttribute("appointmentId", "N/A");
                    log.warn("Invalid resultId format: " + resultIdStr);
                }
            } else {
                request.setAttribute("appointmentId", "N/A");
                log.warn("No appointment ID or result ID provided");
            }
        }
        
        // Forward to JSP
        request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
        
    } catch (SQLException e) {
        log.error("SQLException fetching medications: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07", e);
        request.setAttribute("errorMessage", "Lỗi khi lấy danh sách thuốc: " + e.getMessage());
        request.setAttribute("medications", java.util.Collections.emptyList());
        request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
    } catch (Exception e) {
        log.error("Unexpected error in doGet: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07", e);
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
    }
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Set UTF-8 encoding
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            // Get parameters
            String patientIdStr = request.getParameter("patientId");
            String doctorIdStr = request.getParameter("doctorId");
            String resultIdStr = request.getParameter("resultId");
            String appointmentIdStr = request.getParameter("appointmentId");
            String[] medicationIdStrs = request.getParameterValues("medicationIds");
            String[] quantities = request.getParameterValues("quantities");
            String[] instructions = request.getParameterValues("instructions");
            String saveToDB = request.getParameter("save");
            
            // Get display names for showing in form
            String patientName = request.getParameter("patientName");
            String doctorName = request.getParameter("doctorName");
            String resultName = request.getParameter("resultName");

            // Log parameters
            log.info("Received POST parameters - patientId: " + patientIdStr + ", doctorId: " + doctorIdStr + 
                     ", resultId: " + resultIdStr + ", appointmentId: " + appointmentIdStr + 
                     ", medicationIds: " + Arrays.toString(medicationIdStrs) + 
                     ", quantities: " + Arrays.toString(quantities) + 
                     ", instructions: " + Arrays.toString(instructions) + 
                     ", saveToDB: " + saveToDB);

            // Validate parameters
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

            // Parse IDs
            int patientId = parsePositiveInt(patientIdStr, "Mã bệnh nhân");
            int doctorId = parsePositiveInt(doctorIdStr, "Mã bác sĩ");
            int resultId = parsePositiveInt(resultIdStr, "Mã kết quả khám");
            
            // FIXED: Xử lý appointmentId có thể null hoặc không hợp lệ
            Integer appointmentId = null;
            if (appointmentIdStr != null && !appointmentIdStr.trim().isEmpty() && 
                !"N/A".equals(appointmentIdStr) && !"null".equals(appointmentIdStr)) {
                try {
                    appointmentId = parsePositiveInt(appointmentIdStr, "Mã cuộc hẹn");
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

            // CHANGED: Lấy thông tin chi tiết thuốc từ database thay vì chỉ dùng ID
            List<Medication> allMedications = prescriptionService.getAllMedications();
            StringBuilder prescriptionDetails = new StringBuilder();
            
            for (int i = 0; i < medicationIds.size(); i++) {
                int medicationId = medicationIds.get(i);
                
                // Tìm thông tin thuốc từ danh sách
                Medication medication = allMedications.stream()
                    .filter(med -> med.getMedicationID() == medicationId)
                    .findFirst()
                    .orElse(null);
                
                if (medication != null) {
                    prescriptionDetails.append("Name: ").append(medication.getName())
                                     .append(", Dosage: ").append(medication.getDosage());
                    
                    // Thêm số lượng nếu có
                    if (quantities != null && i < quantities.length && 
                        quantities[i] != null && !quantities[i].trim().isEmpty()) {
                        prescriptionDetails.append(", Quantity: ").append(quantities[i].trim());
                    }
                    
                    // Thêm hướng dẫn sử dụng nếu có
                    if (instructions != null && i < instructions.length && 
                        instructions[i] != null && !instructions[i].trim().isEmpty()) {
                        prescriptionDetails.append(", Instructions: ").append(instructions[i].trim());
                    }
                    
                    prescriptionDetails.append("; ");
                    
                    log.info("Added medication to prescription: " + medication.getName() + 
                             " - " + medication.getDosage());
                } else {
                    log.warn("Medication with ID " + medicationId + " not found");
                    prescriptionDetails.append("MedicationID: ").append(medicationId)
                                     .append(" (Not found); ");
                }
            }

            // Create prescription object
            Prescriptions prescription = new Prescriptions();
            prescription.setPatientId(patientId);
            prescription.setDoctorId(doctorId);
            prescription.setPrescriptionDetails(prescriptionDetails.toString());

            if ("true".equals(saveToDB)) {
                // CHANGED: Thay vì redirect, hiển thị thông báo tại trang hiện tại
                boolean added = prescriptionService.addPrescription(prescription, resultId, appointmentId, medicationIds);
                
                // Set display attributes for form
                setDisplayAttributes(request, patientIdStr, doctorIdStr, resultIdStr, appointmentIdStr, 
                                   patientName, doctorName, resultName);
                
                // Get medications for form
                request.setAttribute("medications", prescriptionService.getAllMedications());
                
                if (added) {
                    log.info("Prescription added successfully for patientId: " + patientId + 
                             ", resultId: " + resultId + ", appointmentId: " + appointmentId + 
                             ", medicationIds: " + medicationIds + 
                             ", details: " + prescriptionDetails + 
                             " at " + java.time.LocalDateTime.now() + " +07");
                    
                    // Set success message
                    request.setAttribute("successMessage", "Tạo đơn thuốc thành công! Đơn thuốc đã được lưu vào hệ thống.");
                } else {
                    log.warn("Failed to add prescription for patientId: " + patientId + 
                             ", resultId: " + resultId + ", appointmentId: " + appointmentId + 
                             ", medicationIds: " + medicationIds + 
                             " at " + java.time.LocalDateTime.now() + " +07");
                    
                    // Set error message
                    request.setAttribute("errorMessage", "Tạo đơn thuốc thất bại: Không thể lưu vào cơ sở dữ liệu.");
                }
                
                // Forward back to the same page with message
                request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
                
            } else {
                log.info("Preview mode, returning to form for patientId: " + patientId + 
                         " at " + java.time.LocalDateTime.now() + " +07");
                setFormAttributes(request, patientIdStr, doctorIdStr, resultIdStr, appointmentIdStr, medicationIdStrs, quantities, instructions);
                setDisplayAttributes(request, patientIdStr, doctorIdStr, resultIdStr, appointmentIdStr, 
                                   patientName, doctorName, resultName);
                request.setAttribute("medications", prescriptionService.getAllMedications());
                request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            log.error("Validation error: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07", e);
            
            // Set display attributes and error message
            setDisplayAttributes(request, 
                               request.getParameter("patientId"), 
                               request.getParameter("doctorId"), 
                               request.getParameter("resultId"), 
                               request.getParameter("appointmentId"),
                               request.getParameter("patientName"),
                               request.getParameter("doctorName"),
                               request.getParameter("resultName"));
            try {
                request.setAttribute("medications", prescriptionService.getAllMedications());
            } catch (SQLException ex) {
                request.setAttribute("medications", java.util.Collections.emptyList());
            }
            request.setAttribute("errorMessage", "Tạo đơn thuốc thất bại: " + e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            
        } catch (SQLException e) {
            log.error("SQLException adding prescription: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07", e);
            
            // Set display attributes and error message
            setDisplayAttributes(request, 
                               request.getParameter("patientId"), 
                               request.getParameter("doctorId"), 
                               request.getParameter("resultId"), 
                               request.getParameter("appointmentId"),
                               request.getParameter("patientName"),
                               request.getParameter("doctorName"),
                               request.getParameter("resultName"));
            try {
                request.setAttribute("medications", prescriptionService.getAllMedications());
            } catch (SQLException ex) {
                request.setAttribute("medications", java.util.Collections.emptyList());
            }
            request.setAttribute("errorMessage", "Tạo đơn thuốc thất bại: Lỗi cơ sở dữ liệu - " + e.getMessage());
            request.getRequestDispatcher("/views/user/DoctorNurse/AddPrescription.jsp").forward(request, response);
            
        } catch (Exception e) {
            log.error("Unexpected error processing request: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07", e);
            
            // Set display attributes and error message
            setDisplayAttributes(request, 
                               request.getParameter("patientId"), 
                               request.getParameter("doctorId"), 
                               request.getParameter("resultId"), 
                               request.getParameter("appointmentId"),
                               request.getParameter("patientName"),
                               request.getParameter("doctorName"),
                               request.getParameter("resultName"));
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
                                 String[] quantities, String[] instructions) {
        request.setAttribute("formPatientId", patientId);
        request.setAttribute("formDoctorId", doctorId);
        request.setAttribute("formResultId", resultId);
        request.setAttribute("formAppointmentId", appointmentId);
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
    
    // NEW METHOD: Set display attributes for showing patient/doctor/result info
    private void setDisplayAttributes(HttpServletRequest request, String patientId, String doctorId, 
                                    String resultId, String appointmentId, String patientName, 
                                    String doctorName, String resultName) {
        // Set IDs
        request.setAttribute("patientId", patientId);
        request.setAttribute("doctorId", doctorId);
        request.setAttribute("resultId", resultId);
        
        // Handle appointmentId
        if (appointmentId != null && !appointmentId.trim().isEmpty() && !"null".equals(appointmentId)) {
            request.setAttribute("appointmentId", appointmentId);
        } else {
            request.setAttribute("appointmentId", "N/A");
        }
        
        // Set display names
        try {
            if (patientName != null && !patientName.trim().isEmpty()) {
                request.setAttribute("patientName", java.net.URLDecoder.decode(patientName, "UTF-8"));
            } else {
                request.setAttribute("patientName", "Không xác định");
            }
            
            if (doctorName != null && !doctorName.trim().isEmpty()) {
                request.setAttribute("doctorName", java.net.URLDecoder.decode(doctorName, "UTF-8"));
            } else {
                request.setAttribute("doctorName", "Không xác định");
            }
            
            if (resultName != null && !resultName.trim().isEmpty()) {
                request.setAttribute("resultName", java.net.URLDecoder.decode(resultName, "UTF-8"));
            } else if (resultId != null && !resultId.trim().isEmpty()) {
                request.setAttribute("resultName", "Kết quả #" + resultId);
            } else {
                request.setAttribute("resultName", "Không xác định");
            }
        } catch (Exception e) {
            log.warn("Error decoding display names: " + e.getMessage());
            request.setAttribute("patientName", patientName != null ? patientName : "Không xác định");
            request.setAttribute("doctorName", doctorName != null ? doctorName : "Không xác định");
            request.setAttribute("resultName", resultName != null ? resultName : "Không xác định");
        }
    }
}