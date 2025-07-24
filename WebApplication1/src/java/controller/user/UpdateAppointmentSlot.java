package controller.user;

import model.service.AppointmentService;
import model.entity.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import model.entity.ScheduleEmployee;

@WebServlet("/UpdateAppointmentSlot")
public class UpdateAppointmentSlot extends HttpServlet {
    private final AppointmentService appointmentService;

    public UpdateAppointmentSlot() {
        this.appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in to update your appointment.");
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("user");
        if (!"Patient".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Access denied. This page is for patients only.");
            response.sendRedirect(request.getContextPath() + "/accessDenied");
            return;
        }

        String appointmentIdParam = request.getParameter("appointmentId");
        if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Appointment ID is required.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        int appointmentId;
        try {
            appointmentId = Integer.parseInt(appointmentIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Appointment ID format.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        try {
            // Fetch appointment details
            Map<String, Object> appointment = appointmentService.getAppointmentById(appointmentId);
            if (appointment == null) {
                request.setAttribute("errorMessage", "Appointment not found.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Verify the appointment belongs to the logged-in patient
            int patientId = user.getUserID();
            if (!appointment.get("patientId").equals(patientId)) {
                request.setAttribute("errorMessage", "You can only update your own appointments.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Fetch available slots for the same doctor
            int doctorId = (int) appointment.get("doctorId");
            List<ScheduleEmployee> availableSlots = appointmentService.getSchedulesByRoleAndUserId("Doctor", doctorId);

            request.setAttribute("appointment", appointment);
            request.setAttribute("availableSlots", availableSlots);
            request.getRequestDispatcher("/views/user/Patient/UpdateAppointment.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error retrieving appointment or slots: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // FIX 1: Cải thiện validation trong doPost method
@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        request.setAttribute("error", "Please log in to update your appointment.");
        response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
        return;
    }

    Users user = (Users) session.getAttribute("user");
    if (!"Patient".equalsIgnoreCase(user.getRole())) {
        request.setAttribute("error", "Access denied. This page is for patients only.");
        response.sendRedirect(request.getContextPath() + "/accessDenied");
        return;
    }

    String appointmentIdParam = request.getParameter("appointmentId");
    String newSlotIdParam = request.getParameter("newSlotId");
    String doctorIdParam = request.getParameter("doctorId");
    String roomIdParam = request.getParameter("roomId");

    // ENHANCED VALIDATION
    if (appointmentIdParam == null || appointmentIdParam.trim().isEmpty() ||
        newSlotIdParam == null || newSlotIdParam.trim().isEmpty() ||
        doctorIdParam == null || doctorIdParam.trim().isEmpty() ||
        roomIdParam == null || roomIdParam.trim().isEmpty()) {
        
        System.err.println("❌ Missing parameters - appointmentId: " + appointmentIdParam + 
                          ", newSlotId: " + newSlotIdParam + 
                          ", doctorId: " + doctorIdParam + 
                          ", roomId: " + roomIdParam);
        session.setAttribute("errorMessage", "All fields are required.");
        response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
        return;
    }

    int appointmentId, newSlotId, doctorId, roomId;
    try {
        appointmentId = Integer.parseInt(appointmentIdParam.trim());
        newSlotId = Integer.parseInt(newSlotIdParam.trim());
        doctorId = Integer.parseInt(doctorIdParam.trim());
        roomId = Integer.parseInt(roomIdParam.trim());
        
        System.out.println("✅ Parsed parameters - appointmentId: " + appointmentId + 
                          ", newSlotId: " + newSlotId + 
                          ", doctorId: " + doctorId + 
                          ", roomId: " + roomId);
    } catch (NumberFormatException e) {
        System.err.println("❌ NumberFormatException: " + e.getMessage());
        session.setAttribute("errorMessage", "Invalid input format.");
        response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
        return;
    }

    try {
        // Verify the appointment belongs to the logged-in patient
        Map<String, Object> appointment = appointmentService.getAppointmentById(appointmentId);
        if (appointment == null) {
            System.err.println("❌ Appointment not found: " + appointmentId);
            session.setAttribute("errorMessage", "Appointment not found.");
            response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
            return;
        }

        // ENHANCED PATIENT VERIFICATION
        Integer appointmentPatientId = (Integer) appointment.get("patientId");
        if (appointmentPatientId == null || appointmentPatientId != user.getUserID()) {
            System.err.println("❌ Patient ID mismatch - Expected: " + user.getUserID() + 
                              ", Found: " + appointmentPatientId);
            session.setAttribute("errorMessage", "You can only update your own appointments.");
            response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
            return;
        }

        // ENHANCED DOCTOR VERIFICATION
        Integer appointmentDoctorId = (Integer) appointment.get("doctorId");
        if (appointmentDoctorId == null || appointmentDoctorId != doctorId) {
            System.err.println("❌ Doctor ID mismatch - Expected: " + appointmentDoctorId + 
                              ", Provided: " + doctorId);
            session.setAttribute("errorMessage", "New slot must belong to the same doctor.");
            response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
            return;
        }

        // Check if appointment status allows update
        String appointmentStatus = (String) appointment.get("status");
        if (!"Approved".equalsIgnoreCase(appointmentStatus)) {
            System.err.println("❌ Cannot update appointment with status: " + appointmentStatus);
            session.setAttribute("errorMessage", "Only approved appointments can be updated.");
            response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
            return;
        }

        // Update the appointment slot
        boolean updated = appointmentService.updateAppointmentSlot(appointmentId, newSlotId, doctorId, roomId);
        if (updated) {
            System.out.println("✅ Appointment updated successfully: " + appointmentId + " -> slot: " + newSlotId);
            session.setAttribute("successMessage", "Appointment slot updated successfully.");
        } else {
            System.err.println("❌ Failed to update appointment: " + appointmentId);
            session.setAttribute("errorMessage", "Failed to update appointment slot. The selected slot may be full or unavailable.");
        }
        response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");

    } catch (SQLException e) {
        System.err.println("❌ SQLException in updateAppointmentSlot: " + e.getMessage() + 
                          ", SQLState: " + e.getSQLState());
        session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
    } catch (Exception e) {
        System.err.println("❌ Unexpected error in updateAppointmentSlot: " + e.getMessage());
        e.printStackTrace();
        session.setAttribute("errorMessage", "An unexpected error occurred.");
        response.sendRedirect(request.getContextPath() + "/ViewAppointmentPatient");
    }
}
}