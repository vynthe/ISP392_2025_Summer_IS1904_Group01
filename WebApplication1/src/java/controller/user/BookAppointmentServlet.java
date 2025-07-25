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
        handleInitialLoad(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        Users currentUser = validateSession(session);
        if (currentUser == null) {
            LOGGER.warning("Invalid session at " + LocalDateTime.now() + " +07");
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=session_expired");
            return;
        }

        if (!"patient".equalsIgnoreCase(currentUser.getRole())) {
            LOGGER.warning("Unauthorized role: " + currentUser.getRole() + " at " + LocalDateTime.now() + " +07");
            setErrorAndForward(request, response, "Bạn không có quyền đặt lịch. Chỉ dành cho bệnh nhân.");
            return;
        }

        AppointmentParams params = extractAndValidateParams(request);
        if (!params.isValid()) {
            LOGGER.warning("Invalid parameters: " + params.getErrorMessage() + " at " + LocalDateTime.now() + " +07");
            setErrorAndForward(request, response, params.getErrorMessage());
            return;
        }

        if (params.patientId != currentUser.getUserID()) {
            LOGGER.warning("PatientId " + params.patientId + " does not match session user ID "
                    + currentUser.getUserID() + " at " + LocalDateTime.now() + " +07");
            setErrorAndForward(request, response, "ID bệnh nhân không khớp với phiên đăng nhập.");
            return;
        }

        LOGGER.info("Processing appointment: " + params.toString() + " at " + LocalDateTime.now() + " +07");

        try {
            // Fetch and cache slot details before booking
            Map<String, Object> slotDetails = appointmentService.getSlotDetails(params.slotId);
            if (slotDetails == null || slotDetails.get("slotTime") == null || slotDetails.get("roomName") == null || slotDetails.get("roomId") == null ||
                slotDetails.get("slotTime").equals("Không tìm thấy khung giờ") || slotDetails.get("roomName").equals("Chưa có phòng")) {
                LOGGER.warning("Invalid slot details for slotId: " + params.slotId + 
                               ", slotTime: " + (slotDetails != null ? slotDetails.get("slotTime") : null) + 
                               ", roomName: " + (slotDetails != null ? slotDetails.get("roomName") : null) + 
                               ", roomId: " + (slotDetails != null ? slotDetails.get("roomId") : null) +
                               " at " + LocalDateTime.now() + " +07");
                setErrorAndForward(request, response, "Khung giờ hoặc phòng không hợp lệ. Vui lòng chọn lại.");
                return;
            }

            if (!performPreValidation(params, request, response)) {
                return;
            }

            boolean success = appointmentService.createAppointment(
                    params.patientId, params.doctorId, params.serviceId, params.slotId, params.roomId);

            if (success) {
                handleSuccessfulBooking(request, response, params, currentUser, slotDetails);
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

    private void handleInitialLoad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=session_expired");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (user == null || !"patient".equals(user.getRole())) {
            LOGGER.warning("⚠️ WARNING: User not found or role is not patient");
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=unauthorized");
            return;
        }

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

        int patientIdInt = user.getUserID();
        String patientId = String.valueOf(patientIdInt);
        String patientName = user.getFullName();
        if (patientId == null || patientId.isEmpty()) {
            LOGGER.severe("❌ ERROR: patientId is null or empty");
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=invalid_user");
            return;
        }
        request.setAttribute("patientId", patientId);
        request.setAttribute("patientName", patientName != null ? patientName : "Không xác định");
        LOGGER.info("✅ Found patientId (userID): " + patientId + ", patientName: " + patientName);

        try {
            String doctorIdParam = request.getParameter("doctorId");
            String appointmentDate = request.getParameter("appointmentDate");
            String slotIdParam = request.getParameter("slotId");
            String roomIdParam = request.getParameter("roomId");

            LOGGER.info("🔍 EXTRACTED PARAMETERS:");
            LOGGER.info("  doctorIdParam: [" + doctorIdParam + "]");
            LOGGER.info("  appointmentDate: [" + appointmentDate + "]");
            LOGGER.info("  slotIdParam: [" + slotIdParam + "]");
            LOGGER.info("  roomIdParam: [" + roomIdParam + "]");

            if (doctorIdParam == null || doctorIdParam.trim().isEmpty()) {
                LOGGER.severe("❌ ERROR: doctorIdParam is null or empty");
                setErrorAndForward(request, response, "Vui lòng cung cấp ID bác sĩ hợp lệ");
                return;
            }

            int doctorId = Integer.parseInt(doctorIdParam.trim());
            if (doctorId <= 0) {
                throw new NumberFormatException("Doctor ID must be positive");
            }
            LOGGER.info("✅ Parsed doctorId: " + doctorId);

            Integer slotId = null;
            String slotTime = null;
            String roomName = null;
            Integer roomId = null;
            LOGGER.info("🔍 PROCESSING SLOTID:");
            LOGGER.info("  slotIdParam raw: [" + slotIdParam + "]");
            if (slotIdParam != null && !slotIdParam.trim().isEmpty()) {
                try {
                    slotId = Integer.parseInt(slotIdParam.trim());
                    if (slotId <= 0) {
                        throw new NumberFormatException("Slot ID must be positive");
                    }
                    Map<String, Object> slotDetails = appointmentService.getSlotDetails(slotId);
                    slotTime = slotDetails != null ? (String) slotDetails.get("slotTime") : "Không tìm thấy khung giờ";
                    roomName = slotDetails != null ? (String) slotDetails.get("roomName") : "Chưa có phòng";
                    roomId = slotDetails != null ? (Integer) slotDetails.get("roomId") : null;
                    if (slotTime == null || roomName == null || roomId == null) {
                        LOGGER.warning("⚠️ Slot details incomplete for slotId: " + slotId + 
                                       ", slotTime: " + slotTime + 
                                       ", roomName: " + roomName + 
                                       ", roomId: " + roomId);
                    }
                    request.setAttribute("slotId", slotId);
                    request.setAttribute("slotTime", slotTime != null ? slotTime : "Không tìm thấy khung giờ");
                    request.setAttribute("roomName", roomName != null ? roomName : "Chưa có phòng");
                    request.setAttribute("roomId", roomId != null ? String.valueOf(roomId) : "");
                    LOGGER.info("✅ SUCCESS: Parsed and set slotId: " + slotId + 
                                ", slotTime: " + slotTime + 
                                ", roomName: " + roomName + 
                                ", roomId: " + roomId);
                } catch (NumberFormatException e) {
                    LOGGER.severe("❌ ERROR: Invalid slotId parameter: " + slotIdParam + ", error: " + e.getMessage());
                    setErrorAndForward(request, response, "ID slot không hợp lệ: " + slotIdParam);
                    return;
                } catch (SQLException e) {
                    LOGGER.severe("❌ ERROR: Failed to fetch slot details for slotId: " + slotId);
                    setErrorAndForward(request, response, "Lỗi khi lấy thông tin khung giờ");
                    return;
                }
            } else {
                LOGGER.warning("⚠️ WARNING: No slotId parameter provided or empty");
                request.setAttribute("slotId", "");
                request.setAttribute("slotTime", "Không tìm thấy khung giờ");
                request.setAttribute("roomName", "Chưa có phòng");
                request.setAttribute("roomId", "");
            }

            if (roomIdParam != null && !roomIdParam.trim().isEmpty()) {
                try {
                    roomId = Integer.parseInt(roomIdParam.trim());
                    if (roomId <= 0) {
                        throw new NumberFormatException("Room ID must be positive");
                    }
                    Map<String, Object> slotDetails = appointmentService.getSlotDetails(slotId);
                    roomName = slotDetails != null ? (String) slotDetails.get("roomName") : "Chưa có phòng";
                    request.setAttribute("roomId", String.valueOf(roomId));
                    request.setAttribute("roomName", roomName);
                    LOGGER.info("✅ SUCCESS: Parsed and set roomId: " + roomId + ", roomName: " + roomName);
                } catch (NumberFormatException e) {
                    LOGGER.severe("❌ ERROR: Invalid roomId parameter: " + roomIdParam);
                    request.setAttribute("roomId", "");
                    request.setAttribute("roomName", "Chưa có phòng");
                } catch (SQLException e) {
                    LOGGER.severe("❌ ERROR: Failed to fetch room details for roomId: " + roomIdParam);
                    request.setAttribute("roomId", "");
                    request.setAttribute("roomName", "Chưa có phòng");
                }
            }

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

            Map<String, Object> doctorDetails = appointmentService.viewDetailBook(doctorId);
            if (doctorDetails == null || doctorDetails.isEmpty()) {
                LOGGER.severe("❌ ERROR: No doctor details found for doctorId: " + doctorId);
                setErrorAndForward(request, response, "Không tìm thấy thông tin bác sĩ với ID: " + doctorId);
                return;
            }

            request.setAttribute("doctorDetails", doctorDetails);
            request.setAttribute("doctorId", doctorId);
            request.setAttribute("doctorName", doctorDetails.get("doctorName") != null ? doctorDetails.get("doctorName") : "Không xác định");
            request.setAttribute("currentDate", parsedDate);

            LOGGER.info("🔧 === FINAL REQUEST ATTRIBUTES ===");
            LOGGER.info("  doctorId: " + request.getAttribute("doctorId"));
            LOGGER.info("  doctorName: " + request.getAttribute("doctorName"));
            LOGGER.info("  patientId: " + request.getAttribute("patientId"));
            LOGGER.info("  patientName: " + request.getAttribute("patientName"));
            LOGGER.info("  slotId: " + request.getAttribute("slotId"));
            LOGGER.info("  slotTime: " + request.getAttribute("slotTime"));
            LOGGER.info("  roomId: " + request.getAttribute("roomId"));
            LOGGER.info("  roomName: " + request.getAttribute("roomName"));
            LOGGER.info("=====================================");

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
            String doctorIdStr = request.getParameter("doctorId");
            String slotIdStr = request.getParameter("slotId");
            String roomIdStr = request.getParameter("roomId");
            String patientIdStr = request.getParameter("patientId");
            String serviceIdStr = request.getParameter("serviceIdTemp");

            LOGGER.info("Received parameters: doctorId=" + doctorIdStr + ", slotId=" + slotIdStr
                    + ", roomId=" + roomIdStr + ", patientId=" + patientIdStr + ", serviceId=" + serviceIdStr);

            if (isInvalidParameter(doctorIdStr, slotIdStr, roomIdStr, patientIdStr, serviceIdStr)) {
                params.setError("Vui lòng cung cấp đầy đủ thông tin (Slot ID và Room ID đang trống).");
                return params;
            }

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
            if (appointmentService.isSlotFullyBooked(params.slotId)) {
                LOGGER.warning("Slot " + params.slotId + " is fully booked at " + LocalDateTime.now() + " +07");
                setErrorAndForward(request, response,
                        "Slot đã đầy (đạt 5 lịch hẹn). Vui lòng chọn slot khác.");
                return false;
            }

            return true;

        } catch (SQLException e) {
            LOGGER.severe("Pre-validation failed: " + e.getMessage());
            setErrorAndForward(request, response, "Lỗi kiểm tra dữ liệu. Vui lòng thử lại.");
            return false;
        }
    }

    private void handleSuccessfulBooking(HttpServletRequest request, HttpServletResponse response,
            AppointmentParams params, Users currentUser, Map<String, Object> slotDetails)
            throws ServletException, IOException {
        try {
            request.setAttribute("success", "🎉 Đặt lịch hẹn thành công!");

            // Fetch doctor details
            Map<String, Object> doctorDetails = appointmentService.viewDetailBook(params.doctorId);
            request.setAttribute("doctorDetails", doctorDetails);
            request.setAttribute("doctorName", doctorDetails.get("doctorName") != null ? doctorDetails.get("doctorName") : "Không xác định");
            LOGGER.info("✅ Set doctorName: " + request.getAttribute("doctorName"));

            // Use cached slot details
            String slotTime = (String) slotDetails.get("slotTime");
            String roomName = (String) slotDetails.get("roomName");
            Integer roomId = (Integer) slotDetails.get("roomId");

            // Validate slot details
            if (slotTime == null || roomName == null || roomId == null) {
                LOGGER.warning("⚠️ Cached slot details incomplete for slotId: " + params.slotId + 
                               ", slotTime: " + slotTime + 
                               ", roomName: " + roomName + 
                               ", roomId: " + roomId);
                slotTime = "Không tìm thấy khung giờ";
                roomName = "Chưa có phòng";
                roomId = 0;
            }

            request.setAttribute("slotTime", slotTime);
            request.setAttribute("roomName", roomName);
            request.setAttribute("roomId", roomId != null ? String.valueOf(roomId) : "");
            request.setAttribute("slotId", params.slotId);
            LOGGER.info("✅ Set slotTime: " + slotTime + ", roomName: " + roomName + ", roomId: " + roomId);

            // Set patient details
            request.setAttribute("patientName", currentUser.getFullName() != null ? currentUser.getFullName() : "Không xác định");
            LOGGER.info("✅ Set patientName: " + request.getAttribute("patientName"));

            // Set service details
            request.setAttribute("serviceIdTemp", params.serviceId);
            LOGGER.info("✅ Set serviceIdTemp: " + params.serviceId);

            // Set other attributes
            setAppointmentAttributes(request, params);
            request.setAttribute("currentUser", currentUser);

            LOGGER.info("✅ Appointment created successfully for " + params.toString());
            LOGGER.info("🔧 === FINAL REQUEST ATTRIBUTES AFTER BOOKING ===");
            LOGGER.info("  doctorId: " + request.getAttribute("doctorId"));
            LOGGER.info("  doctorName: " + request.getAttribute("doctorName"));
            LOGGER.info("  patientId: " + request.getAttribute("patientId"));
            LOGGER.info("  patientName: " + request.getAttribute("patientName"));
            LOGGER.info("  slotId: " + request.getAttribute("slotId"));
            LOGGER.info("  slotTime: " + request.getAttribute("slotTime"));
            LOGGER.info("  roomId: " + request.getAttribute("roomId"));
            LOGGER.info("  roomName: " + request.getAttribute("roomName"));
            LOGGER.info("  serviceIdTemp: " + request.getAttribute("serviceIdTemp"));
            LOGGER.info("=====================================");

            request.getRequestDispatcher("/views/user/Patient/BookAppointment.jsp").forward(request, response);

        } catch (SQLException e) {
            LOGGER.severe("Error handling successful booking: SQLException - " + e.getMessage());
            setErrorAndForward(request, response, "Đặt lịch thành công nhưng không thể tải lại trang: Lỗi cơ sở dữ liệu.");
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

        try {
            String doctorIdParam = request.getParameter("doctorId");
            if (doctorIdParam != null && !doctorIdParam.trim().isEmpty()) {
                int doctorId = Integer.parseInt(doctorIdParam);
                Map<String, Object> doctorDetails = appointmentService.viewDetailBook(doctorId);
                request.setAttribute("doctorDetails", doctorDetails);
                request.setAttribute("doctorId", doctorId);
                request.setAttribute("doctorName", doctorDetails.get("doctorName") != null ? doctorDetails.get("doctorName") : "Không xác định");
            }

            String slotIdParam = request.getParameter("slotId");
            String roomIdParam = request.getParameter("roomId");
            if (slotIdParam != null && !slotIdParam.trim().isEmpty()) {
                try {
                    Integer slotId = Integer.parseInt(slotIdParam);
                    if (slotId > 0) {
                        request.setAttribute("slotId", slotId);
                        Map<String, Object> slotDetails = appointmentService.getSlotDetails(slotId);
                        String slotTime = slotDetails != null ? (String) slotDetails.get("slotTime") : "Không tìm thấy khung giờ";
                        String roomName = slotDetails != null ? (String) slotDetails.get("roomName") : "Chưa có phòng";
                        Integer roomId = slotDetails != null ? (Integer) slotDetails.get("roomId") : null;
                        request.setAttribute("slotTime", slotTime);
                        request.setAttribute("roomName", roomName);
                        request.setAttribute("roomId", roomId != null ? String.valueOf(roomId) : "");
                        LOGGER.info("✅ Preserved slotId on error: " + slotId + ", slotTime: " + slotTime + ", roomName: " + roomName + ", roomId: " + roomId);
                    }
                } catch (NumberFormatException | SQLException e) {
                    Integer existingSlotId = (Integer) request.getAttribute("slotId");
                    request.setAttribute("slotId", existingSlotId != null ? existingSlotId : "");
                    request.setAttribute("slotTime", "Không tìm thấy khung giờ");
                    request.setAttribute("roomName", "Chưa có phòng");
                    request.setAttribute("roomId", "");
                    LOGGER.warning("❌ Invalid slotId on error, using existing or set to null: " + existingSlotId);
                }
            } else {
                Integer existingSlotId = (Integer) request.getAttribute("slotId");
                request.setAttribute("slotId", existingSlotId != null ? existingSlotId : "");
                request.setAttribute("slotTime", "Không tìm thấy khung giờ");
                request.setAttribute("roomName", "Chưa có phòng");
                request.setAttribute("roomId", "");
                LOGGER.info("❌ No slotId in request, using existing or set to null: " + existingSlotId);
            }

            if (roomIdParam != null && !roomIdParam.trim().isEmpty()) {
                try {
                    Integer roomId = Integer.parseInt(roomIdParam);
                    if (roomId > 0) {
                        request.setAttribute("roomId", String.valueOf(roomId));
                        Map<String, Object> slotDetails = appointmentService.getSlotDetails(Integer.parseInt(slotIdParam));
                        String roomName = slotDetails != null ? (String) slotDetails.get("roomName") : "Chưa có phòng";
                        request.setAttribute("roomName", roomName);
                        LOGGER.info("✅ Preserved roomId on error: " + roomId + ", roomName: " + roomName);
                    }
                } catch (NumberFormatException | SQLException e) {
                    Integer existingRoomId = (Integer) request.getAttribute("roomId");
                    request.setAttribute("roomId", existingRoomId != null ? String.valueOf(existingRoomId) : "");
                    request.setAttribute("roomName", "Chưa có phòng");
                    LOGGER.warning("❌ Invalid roomId on error, using existing or set to null: " + existingRoomId);
                }
            }

            Users user = (Users) request.getSession().getAttribute("user");
            if (user != null) {
                request.setAttribute("patientName", user.getFullName() != null ? user.getFullName() : "Không xác định");
            }

        } catch (Exception e) {
            LOGGER.warning("Could not reload doctor details on error: " + e.getMessage());
        }

        request.getRequestDispatcher("/views/user/Patient/BookAppointment.jsp").forward(request, response);
    }

    private void setAppointmentAttributes(HttpServletRequest request, AppointmentParams params) {
        request.setAttribute("doctorId", params.doctorId);
        request.setAttribute("slotId", params.slotId);
        request.setAttribute("roomId", params.roomId != 0 ? String.valueOf(params.roomId) : "");
        request.setAttribute("patientId", params.patientId);
        request.setAttribute("serviceIdTemp", params.serviceId);
    }

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
