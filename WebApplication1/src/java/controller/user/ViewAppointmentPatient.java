package controller.user;

import model.service.AppointmentService;
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
import model.entity.Users;

@WebServlet("/ViewAppointmentPatient")
public class ViewAppointmentPatient extends HttpServlet {
    private final AppointmentService appointmentService;

    public ViewAppointmentPatient() {
        this.appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the session without creating a new one
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            request.setAttribute("error", "Please log in to view your appointments.");
            response.sendRedirect(request.getContextPath() + "/views/common/login.jsp");
            return;
        }

        // Check if the user has the "Patient" role
        Users user = (Users) session.getAttribute("user");
        if (!"Patient".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "Access denied. This page is for patients only.");
            response.sendRedirect(request.getContextPath() + "/accessDenied");
            return;
        }

        try {
            // Get patient ID from the user object in session
            int patientId = user.getUserID();
            List<Map<String, Object>> appointments = appointmentService.getDetailedAppointmentsByPatientId(patientId);

            if (appointments == null || appointments.isEmpty()) {
                request.setAttribute("errorMessage", "No appointments found for your account.");
            }

            // Set appointments data as request attribute
            request.setAttribute("appointments", appointments);

            // Forward to JSP for Patients
            request.getRequestDispatcher("/views/user/Patient/ViewAppointment.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error retrieving appointments: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Patient/ViewAppointment.jsp").forward(request, response);
        }
    }
}