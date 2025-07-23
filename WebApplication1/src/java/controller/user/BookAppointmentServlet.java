package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Users;
import model.service.AppointmentService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet(name = "BookAppointmentServlet", urlPatterns = {"/BookAppointmentServlet"})
public class BookAppointmentServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookAppointmentServlet.class.getName());
    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // ✅ Handle GET request to load initial data
        handleInitialLoad(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // ✅ Validate session
        HttpSession session = request.getSession(false);
        Users currentUser = validateSession(session);
        if (currentUser == null) {
            LOGGER.warning("Invalid session at " + LocalDateTime.now() + " +07");
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=session_expired");
            return;
        }

        // ✅ Validate user role
        if (!"patient".equalsIgnoreCase(currentUser.getRole())) {
            LOGGER.warning("Unauthorized role: " + currentUser.getRole() + " at " + LocalDateTime.now() + " +07");
            setErrorAndForward(request, response, "Bạn không có quyền đặt lịch. Chỉ dành cho bệnh nhân.");
            return;
        }

        // ✅ Get and validate parameters
        AppointmentParams params = extractAndValidateParams(request);
        if (!params.isValid()) {
            LOGGER.warning("Invalid parameters: " + params.getErrorMessage() + " at " + LocalDateTime.now() + " +07");
            setErrorAndForward(request, response, params.getErrorMessage());
            return;
        }

        // ✅ Verify patient ID matches session
        if (params.patientId != currentUser.getUserID()) {
            LOGGER.warning("PatientId " + params.patientId + " does not match session user ID "
                    + currentUser.getUserID() + " at " + LocalDateTime.now() + " +07");
            setErrorAndForward(request, response, "ID bệnh nhân không khớp với phiên đăng nhập.");
            return;
        }

        LOGGER.info("Processing appointment: " + params.toString() + " at " + LocalDateTime.now() + " +07");

        try {
            // ✅ Pre-validation checks
            if (!performPreValidation(params, request, response)) {
                return; // Error already set and forwarded
            }

            // ✅ Create appointment
            boolean success = appointmentService.createAppointment(
                    params.patientId, params.doctorId, params.serviceId, params.slotId, params.roomId);

            if (success) {
                handleSuccessfulBooking(request, response, params, currentUser);
            } else {
                LOGGER.warning("Appointment creation failed for " + params.toString() + " at " + LocalDateTime.now() + " +07");
                setErrorAndForward(request, response, "Đặt lịch thất bại. Có thể slot đã được đặt hoặc thông tin không hợp lệ.");
            }

        } catch (SQLException e) {
            LOGGER.severe("SQLException at " + LocalDateTime.now() + " +07: " + e.getMessage()
                    + ", SQLState: " + e.getSQLState());
            setErrorAndForward(request, response, "Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error at " + LocalDateTime.now() + " +07: " + e.getMessage());
            setErrorAndForward(request, response, "Lỗi hệ thống. Vui lòng thử lại sau.");
        }
    }

    // Thêm debug chi tiết vào method handleInitialLoad trong BookAppointmentServlet

private void handleInitialLoad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // ✅ Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=session_expired");
            return;
        }

        // ✅ Lấy user từ session và kiểm tra role
        Users user = (Users) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            LOGGER.warning("⚠️ WARNING: User not found or role is not patient");
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=unauthorized");
            return;
        }

        // ✅ DEBUG: In tất cả parameters
        LOGGER.info("🔍 === DEBUG ALL REQUEST PARAMETERS ===");
        LOGGER.info("Request URL: " + request.getRequestURL());
        LOGGER.info("Query String: " + request.getQueryString());
        LOGGER.info("Request Method: " + request.getMethod());
        
        java.util.Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();
            String[] paramValues = request.getParameterValues(paramName);
            LOGGER.info("Parameter [" + paramName + "] = " + java.util.Arrays.toString(paramValues));
        }
        LOGGER.info("=====================================");

        // ✅ Lấy patientId từ user
        int patientIdInt = user.getUserID();
        String patientId = String.valueOf(patientIdInt);
        if (patientId == null || patientId.isEmpty()) {
            LOGGER.severe("❌ ERROR: patientId is null or empty");
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=invalid_user");
            return;
        }
        request.setAttribute("patientId", patientId);
        LOGGER.info("✅ Found patientId (userID): " + patientId);

        try {
            // ✅ Extract parameters với logging chi tiết
            String doctorIdParam = request.getParameter("doctorId");
            String appointmentDate = request.getParameter("appointmentDate");
            String slotIdParam = request.getParameter("slotId");
            
            LOGGER.info("🔍 EXTRACTED PARAMETERS:");
            LOGGER.info("  doctorIdParam: [" + doctorIdParam + "]");
            LOGGER.info("  appointmentDate: [" + appointmentDate + "]");
            LOGGER.info("  slotIdParam: [" + slotIdParam + "]");

            // ✅ Validate doctorId
            if (doctorIdParam == null || doctorIdParam.trim().isEmpty()) {
                LOGGER.severe("❌ ERROR: doctorIdParam is null or empty");
                setErrorAndForward(request, response, "Vui lòng cung cấp ID bác sĩ hợp lệ");
                return;
            }

            int doctorId;
            try {
                doctorId = Integer.parseInt(doctorIdParam.trim());
                if (doctorId <= 0) {
                    throw new NumberFormatException("Doctor ID must be positive");
                }
                LOGGER.info("✅ Parsed doctorId: " + doctorId);
            } catch (NumberFormatException e) {
                LOGGER.severe("❌ ERROR: Invalid doctorId: " + doctorIdParam);
                setErrorAndForward(request, response, "ID bác sĩ không hợp lệ: " + doctorIdParam);
                return;
            }

            // ✅ Process slotId với logging chi tiết, aligned with ViewDetailBookServlet
            Integer slotId = null;
            LOGGER.info("🔍 PROCESSING SLOTID:");
            LOGGER.info("  slotIdParam raw: [" + slotIdParam + "]");
            LOGGER.info("  slotIdParam == null: " + (slotIdParam == null));
            LOGGER.info("  slotIdParam.isEmpty(): " + (slotIdParam != null ? slotIdParam.isEmpty() : "N/A"));
            LOGGER.info("  slotIdParam.trim().isEmpty(): " + (slotIdParam != null ? slotIdParam.trim().isEmpty() : "N/A"));
            
            if (slotIdParam != null && !slotIdParam.trim().isEmpty()) {
                try {
                    slotId = Integer.parseInt(slotIdParam.trim());
                    if (slotId <= 0) {
                        LOGGER.severe("❌ ERROR: SlotId must be positive, got: " + slotId);
                        throw new NumberFormatException("Slot ID must be positive");
                    }
                    request.setAttribute("slotId", slotId);
                    LOGGER.info("✅ SUCCESS: Parsed and set slotId: " + slotId);
                } catch (NumberFormatException e) {
                    LOGGER.severe("❌ ERROR: Invalid slotId parameter: " + slotIdParam + ", error: " + e.getMessage());
                    setErrorAndForward(request, response, "ID slot không hợp lệ: " + slotIdParam);
                    return;
                }
            } else {
                LOGGER.warning("⚠️ WARNING: No slotId parameter provided or empty");
                LOGGER.warning("  Setting slotId to null in request attributes");
                request.setAttribute("slotId", null);
            }

            // ✅ Validate ngày hẹn
            LocalDate parsedDate = null;
            if (appointmentDate != null && !appointmentDate.trim().isEmpty()) {
                try {
                    parsedDate = LocalDate.parse(appointmentDate.trim(), DateTimeFormatter.ISO_LOCAL_DATE);
                    request.setAttribute("appointmentDate", parsedDate);
                    LOGGER.info("✅ Parsed appointmentDate: " + parsedDate);
                } catch (DateTimeParseException e) {
                    LOGGER.severe("❌ ERROR: Invalid appointment date: " + appointmentDate);
                    setErrorAndForward(request, response, "Ngày hẹn không hợp lệ: " + appointmentDate);
                    return;
                }
            } else {
                parsedDate = LocalDate.now();
                request.setAttribute("appointmentDate", parsedDate);
                LOGGER.info("✅ Using default date: " + parsedDate);
            }

            // ✅ Load doctor details
            Map<String, Object> doctorDetails = appointmentService.viewDetailBook(doctorId);
            
            if (doctorDetails == null || doctorDetails.isEmpty()) {
                LOGGER.severe("❌ ERROR: No doctor details found for doctorId: " + doctorId);
                setErrorAndForward(request, response, "Không tìm thấy thông tin bác sĩ với ID: " + doctorId);
                return;
            }

            // ✅ Get roomID from doctor details
            String roomID = (doctorDetails.get("roomID") != null) ? doctorDetails.get("roomID").toString() : null;
            
            // Set attributes for JSP
            request.setAttribute("doctorDetails", doctorDetails);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("currentDate", parsedDate);
            
            if (roomID != null && !roomID.equals("null")) {
                request.setAttribute("roomId", roomID);
                LOGGER.info("✅ Set roomId: " + roomID);
            }
            
            // ✅ Final debug info
            LOGGER.info("🔧 === FINAL REQUEST ATTRIBUTES ===");
            LOGGER.info("  doctorId: " + request.getAttribute("doctorId"));
            LOGGER.info("  patientId: " + request.getAttribute("patientId"));
            LOGGER.info("  slotId: " + request.getAttribute("slotId"));
            LOGGER.info("  roomId: " + request.getAttribute("roomId"));
            LOGGER.info("  appointmentDate: " + request.getAttribute("appointmentDate"));
            LOGGER.info("=====================================");
            
            // Forward to JSP
            request.getRequestDispatcher("/views/user/Patient/BookAppointment.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.severe("SQLException in BookAppointmentServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            setErrorAndForward(request, response, "Lỗi hệ thống: Không thể tải thông tin bác sĩ. Vui lòng thử lại sau.");
        } catch (Exception e) {
            LOGGER.severe("Unexpected error in BookAppointmentServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            setErrorAndForward(request, response, "Lỗi không xác định: " + e.getMessage());
        }
    }

    private Users validateSession(HttpSession session) {
        if (session == null || session.getAttribute("user") == null) {
            return null;
        }
        return (Users) session.getAttribute("user");
    }

    private AppointmentParams extractAndValidateParams(HttpServletRequest request) {
        AppointmentParams params = new AppointmentParams();

        try {
            // ✅ Extract parameters
            String doctorIdStr = request.getParameter("doctorId");
            String slotIdStr = request.getParameter("slotId");
            String roomIdStr = request.getParameter("roomId");
            String patientIdStr = request.getParameter("patientId");
            String serviceIdStr = request.getParameter("serviceIdTemp");

            LOGGER.info("Received parameters: doctorId=" + doctorIdStr + ", slotId=" + slotIdStr
                    + ", roomId=" + roomIdStr + ", patientId=" + patientIdStr + ", serviceId=" + serviceIdStr);

            // ✅ Check for null/empty parameters
            if (isInvalidParameter(doctorIdStr, slotIdStr, roomIdStr, patientIdStr, serviceIdStr)) {
                params.setError("Vui lòng cung cấp đầy đủ thông tin (Slot ID và Room ID đang trống).");
                return params;
            }

            // ✅ Parse and validate IDs
            params.doctorId = parseAndValidateId(doctorIdStr, "Mã bác sĩ");
            params.slotId = parseAndValidateId(slotIdStr, "Mã slot");
            params.roomId = parseAndValidateId(roomIdStr, "Mã phòng");
            params.patientId = parseAndValidateId(patientIdStr, "Mã bệnh nhân");
            params.serviceId = parseAndValidateId(serviceIdStr, "Mã dịch vụ");

            params.valid = true;

        } catch (NumberFormatException e) {
            params.setError("ID không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            params.setError("Lỗi xử lý tham số: " + e.getMessage());
        }

        return params;
    }

    private boolean performPreValidation(AppointmentParams params, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        try {
            // ✅ Check if slot is fully booked
            if (appointmentService.isSlotFullyBooked(params.slotId)) {
                LOGGER.warning("Slot " + params.slotId + " is fully booked at " + LocalDateTime.now() + " +07");
                setErrorAndForward(request, response,
                        "Slot đã đầy (đạt 5 lịch hẹn). Vui lòng chọn slot khác.");
                return false;
            }

            // ✅ Additional validation could be added here
            // - Check if patient already has appointment in same slot
            // - Validate doctor-room-service relationship
            // - Check appointment time conflicts
            return true;

        } catch (SQLException e) {
            LOGGER.severe("Pre-validation failed: " + e.getMessage());
            setErrorAndForward(request, response, "Lỗi kiểm tra dữ liệu. Vui lòng thử lại.");
            return false;
        }
    }

    private void handleSuccessfulBooking(HttpServletRequest request, HttpServletResponse response,
            AppointmentParams params, Users currentUser)
            throws ServletException, IOException {
        try {
            // ✅ Set success message
            request.setAttribute("success", "🎉 Đặt lịch hẹn thành công!");

            // ✅ Load updated doctor details
            Map<String, Object> doctorDetails = appointmentService.viewDetailBook(params.doctorId);
            request.setAttribute("doctorDetails", doctorDetails);

            // ✅ Set current booking info
            setAppointmentAttributes(request, params);

            // ✅ Add user info
            request.setAttribute("currentUser", currentUser);

            LOGGER.info("✅ Appointment created successfully for " + params.toString());

            // ✅ Forward back to booking page to show success
            request.getRequestDispatcher("/views/user/Patient/BookAppointment.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.severe("Error handling successful booking: " + e.getMessage());
            setErrorAndForward(request, response, "Đặt lịch thành công nhưng không thể tải lại trang.");
        }
    }

    private boolean isInvalidParameter(String... params) {
        for (String param : params) {
            if (param == null || param.trim().isEmpty()) {
                return true;
            }
        }
        return false;
    }

    private int parseAndValidateId(String idStr, String fieldName) throws NumberFormatException {
        int id = Integer.parseInt(idStr.trim());
        if (id <= 0) {
            throw new NumberFormatException(fieldName + " phải là số dương");
        }
        return id;
    }

    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response,
            String errorMessage) throws ServletException, IOException {
        request.setAttribute("error", "❌ " + errorMessage);

        // ✅ Try to reload doctor details if doctorId is available
        try {
            String doctorIdParam = request.getParameter("doctorId");
            if (doctorIdParam != null && !doctorIdParam.trim().isEmpty()) {
                int doctorId = Integer.parseInt(doctorIdParam);
                Map<String, Object> doctorDetails = appointmentService.viewDetailBook(doctorId);
                request.setAttribute("doctorDetails", doctorDetails);
                request.setAttribute("doctorId", doctorId);
            }

            // ✅ Preserve slotId if available
            String slotIdParam = request.getParameter("slotId");
            if (slotIdParam != null && !slotIdParam.trim().isEmpty()) {
                try {
                    Integer slotId = Integer.parseInt(slotIdParam);
                    if (slotId > 0) {
                        request.setAttribute("slotId", slotId);
                        LOGGER.info("✅ Preserved slotId on error: " + slotId);
                    }
                } catch (NumberFormatException e) {
                    // Set null nếu slotId không hợp lệ
                    request.setAttribute("slotId", null);
                    LOGGER.warning("❌ Invalid slotId on error, set to null");
                }
            } else {
                // Set null nếu không có slotId
                request.setAttribute("slotId", null);
                LOGGER.info("❌ No slotId on error, set to null");
            }

            // ✅ Preserve roomId nếu có
            String roomIdParam = request.getParameter("roomId");
            if (roomIdParam != null && !roomIdParam.trim().isEmpty()) {
                try {
                    Integer roomId = Integer.parseInt(roomIdParam);
                    if (roomId > 0) {
                        request.setAttribute("roomId", roomId);
                    }
                } catch (NumberFormatException e) {
                    // Ignore invalid roomId
                }
            }

        } catch (Exception e) {
            LOGGER.warning("Could not reload doctor details on error: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/user/Patient/BookAppointment.jsp").forward(request, response);
    }

    private void setAppointmentAttributes(HttpServletRequest request, AppointmentParams params) {
        request.setAttribute("doctorId", params.doctorId);
        request.setAttribute("slotId", params.slotId);
        request.setAttribute("roomId", params.roomId);
        request.setAttribute("patientId", params.patientId);
        request.setAttribute("serviceIdTemp", params.serviceId);
    }

    // ✅ Helper class to encapsulate appointment parameters
    private static class AppointmentParams {

        int doctorId, slotId, roomId, patientId, serviceId;
        boolean valid = false;
        String errorMessage = "";

        boolean isValid() {
            return valid;
        }

        String getErrorMessage() {
            return errorMessage;
        }

        void setError(String message) {
            this.errorMessage = message;
            this.valid = false;
        }

        @Override
        public String toString() {
            return String.format("AppointmentParams{patientId=%d, doctorId=%d, slotId=%d, roomId=%d, serviceId=%d}",
                    patientId, doctorId, slotId, roomId, serviceId);
        }
    }
}
