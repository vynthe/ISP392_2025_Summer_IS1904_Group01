package controller.user;

import model.entity.Users;
import model.service.AppointmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import com.google.gson.Gson;
import java.time.LocalDateTime;
import java.util.Objects;

@WebServlet("/CancelAppointmentServlet")
public class CancelAppointmentServlet extends HttpServlet {

    private AppointmentService appointmentService;

    @Override
    public void init() throws ServletException {
        appointmentService = new AppointmentService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> responseMap = new HashMap<>();
        Gson gson = new Gson();

        // Get the session without creating a new one
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a Patient
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || !"Patient".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            responseMap.put("status", "error");
            responseMap.put("message", "You must be logged in as a patient to cancel appointments.");
            System.err.println("❌ Unauthorized access attempt. User: " + 
                             (user != null ? user.getRole() : "null") + " at " + LocalDateTime.now() + " +07");
            out.write(gson.toJson(responseMap));
            out.flush();
            return;
        }

        try {
            // Get parameters
            String appointmentIdParam = request.getParameter("appointmentId");
            String appointmentIdsParam = request.getParameter("appointmentIds");

            // Verify that the user can only cancel their own appointments
            int patientId = user.getUserID();

            if (appointmentIdParam != null && !appointmentIdParam.isEmpty()) {
                // Handle single appointment cancellation
                int appointmentId;
                try {
                    appointmentId = Integer.parseInt(appointmentIdParam);
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    responseMap.put("status", "error");
                    responseMap.put("message", "Invalid appointment ID format");
                    System.err.println("❌ Invalid appointment ID format: " + appointmentIdParam + 
                                     " at " + LocalDateTime.now() + " +07");
                    out.write(gson.toJson(responseMap));
                    return;
                }

                try {
                    // Verify that the appointment belongs to the patient
                    Map<String, Object> appointment = appointmentService.getAppointmentById(appointmentId);
                   if (appointment == null || !Objects.equals(patientId, (Integer) appointment.get("patientId"))) {
                        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                        responseMap.put("status", "error");
                        responseMap.put("message", "You can only cancel your own appointments.");
                        System.err.println("❌ Patient " + patientId + " attempted to cancel appointment " + 
                                         appointmentId + " which they do not own at " + LocalDateTime.now() + " +07");
                        out.write(gson.toJson(responseMap));
                        return;
                    }

                    boolean success = appointmentService.cancelAppointment(appointmentId);
                    if (success) {
                        responseMap.put("status", "success");
                        responseMap.put("message", "Appointment " + appointmentId + " cancelled successfully");
                        System.out.println("✅ CancelAppointmentServlet: Appointment " + appointmentId + 
                                         " cancelled successfully by patient " + patientId + 
                                         " at " + LocalDateTime.now() + " +07");
                    } else {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        responseMap.put("status", "error");
                        responseMap.put("message", "Failed to cancel appointment " + appointmentId + 
                                                  ". It may not exist or already be cancelled");
                        System.err.println("❌ CancelAppointmentServlet: Failed to cancel appointment " + 
                                         appointmentId + " by patient " + patientId + 
                                         " at " + LocalDateTime.now() + " +07");
                    }
                } catch (SQLException e) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    responseMap.put("status", "error");
                    responseMap.put("message", "Database error: " + e.getMessage());
                    System.err.println("SQLException in CancelAppointmentServlet (single cancel, appointmentId=" + 
                                     appointmentId + ", patientId=" + patientId + "): " + e.getMessage() + 
                                     ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
                }

            } else if (appointmentIdsParam != null && !appointmentIdsParam.isEmpty()) {
                // Handle multiple appointment cancellations
                List<Integer> appointmentIds;
                try {
                    appointmentIds = Arrays.stream(appointmentIdsParam.split(","))
                            .map(String::trim)
                            .map(Integer::parseInt)
                            .collect(Collectors.toList());
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    responseMap.put("status", "error");
                    responseMap.put("message", "Invalid appointment IDs format");
                    System.err.println("❌ Invalid appointment IDs format: " + appointmentIdsParam + 
                                     " at " + LocalDateTime.now() + " +07");
                    out.write(gson.toJson(responseMap));
                    return;
                }

                try {
                    // Verify that all appointments belong to the patient
                    for (Integer appointmentId : appointmentIds) {
                        Map<String, Object> appointment = appointmentService.getAppointmentById(appointmentId);
                        if (appointment == null || !Objects.equals(patientId, (Integer) appointment.get("patientId"))) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            responseMap.put("status", "error");
                            responseMap.put("message", "You can only cancel your own appointments.");
                            System.err.println("❌ Patient " + patientId + " attempted to cancel appointment " + 
                                             appointmentId + " which they do not own at " + LocalDateTime.now() + " +07");
                            out.write(gson.toJson(responseMap));
                            return;
                        }
                    }

                    int cancelledCount = appointmentService.cancelMultipleAppointments(appointmentIds);
                    if (cancelledCount > 0) {
                        responseMap.put("status", "success");
                        responseMap.put("message", "Successfully cancelled " + cancelledCount + 
                                                 " out of " + appointmentIds.size() + " appointments");
                        responseMap.put("cancelledCount", cancelledCount);
                        System.out.println("✅ CancelAppointmentServlet: Cancelled " + cancelledCount + 
                                         " appointments for patient " + patientId + 
                                         " at " + LocalDateTime.now() + " +07");
                    } else {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        responseMap.put("status", "error");
                        responseMap.put("message", "No appointments were cancelled. They may not exist or already be cancelled");
                        System.err.println("❌ CancelAppointmentServlet: No appointments cancelled for IDs " + 
                                         appointmentIds + " by patient " + patientId + 
                                         " at " + LocalDateTime.now() + " +07");
                    }
                    responseMap.put("cancelledCount", cancelledCount);
                } catch (SQLException e) {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    responseMap.put("status", "error");
                    responseMap.put("message", "Database error: " + e.getMessage());
                    System.err.println("SQLException in CancelAppointmentServlet (multiple cancel, appointmentIds=" + 
                                     appointmentIds + ", patientId=" + patientId + "): " + e.getMessage() + 
                                     ", SQLState: " + e.getSQLState() + " at " + LocalDateTime.now() + " +07");
                }

            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseMap.put("status", "error");
                responseMap.put("message", "Missing required parameters: appointmentId or appointmentIds");
                System.err.println("❌ CancelAppointmentServlet: Missing parameters at " + LocalDateTime.now() + " +07");
            }

        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseMap.put("status", "error");
            responseMap.put("message", e.getMessage());
            System.err.println("IllegalArgumentException in CancelAppointmentServlet: " + e.getMessage() + 
                             " at " + LocalDateTime.now() + " +07");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseMap.put("status", "error");
            responseMap.put("message", "Unexpected error: " + e.getMessage());
            System.err.println("Unexpected error in CancelAppointmentServlet: " + e.getMessage() + 
                             " at " + LocalDateTime.now() + " +07");
        }

        out.write(gson.toJson(responseMap));
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("status", "error");
        responseMap.put("message", "GET method is not supported for this endpoint");
        response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        System.err.println("⚠️ GET request to CancelAppointmentServlet rejected at " + LocalDateTime.now() + " +07");
        out.write(new Gson().toJson(responseMap));
        out.flush();
    }
}