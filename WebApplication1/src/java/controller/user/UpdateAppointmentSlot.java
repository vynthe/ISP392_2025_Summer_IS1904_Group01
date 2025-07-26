package controller.user;

import model.entity.ScheduleEmployee;
import model.entity.Users;
import model.service.SchedulesService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

@WebServlet(name = "UpdateAppointmentSlot", urlPatterns = {"/UpdateAppointmentSlot"})
public class UpdateAppointmentSlot extends HttpServlet {
    private SchedulesService schedulesService;

    @Override
    public void init() throws ServletException {
        super.init();
        schedulesService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to avoid unintended access
        response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the session without creating a new one
        HttpSession session = request.getSession(false);

        // Check if user is logged in and is a Receptionist
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || !"receptionist".equalsIgnoreCase(user.getRole())) {
            request.setAttribute("error", "You must be logged in as a receptionist to access this page.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }

        try {
            // Get and validate parameters
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            String userIdParam = request.getParameter("userId");
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                throw new IllegalArgumentException("User ID is required.");
            }
            int userId = Integer.parseInt(userIdParam);

            String newSlotDateStr = request.getParameter("newSlotDate");
            String newStartTimeStr = request.getParameter("newStartTime");
            String newEndTimeStr = request.getParameter("newEndTime");
            int updatedBy = user.getUserID(); // Use logged-in user's ID as updatedBy

            // Validate and parse date and time with explicit format
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            LocalDate newSlotDate = LocalDate.parse(newSlotDateStr, dateFormatter);
            LocalTime newStartTime = LocalTime.parse(newStartTimeStr, timeFormatter);
            LocalTime newEndTime = LocalTime.parse(newEndTimeStr, timeFormatter);

            // Ensure start time is before end time
            if (newStartTime.isAfter(newEndTime)) {
                throw new IllegalArgumentException("Start time must be before end time.");
            }

            // Call service to update schedule
            boolean success = schedulesService.updateScheduleForDoctorNurse(slotId, userId, newSlotDate, newStartTime, newEndTime, updatedBy);

            if (success) {
                // Redirect with success message
                response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse?userID=" + userId + 
                                     "&success=Schedule updated successfully for Slot ID " + slotId);
            } else {
                // Redirect with error message
                response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse?userID=" + userId + 
                                     "&error=Failed to update schedule for Slot ID " + slotId);
            }

        } catch (NumberFormatException e) {
            System.err.println("❌ NumberFormatException in UpdateAppointmentSlot: " + e.getMessage());
            String userIdParam = request.getParameter("userId");
            String errorMsg = "Invalid input format. ";
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                errorMsg += "User ID is required.";
            } else {
                errorMsg += "User ID '" + userIdParam + "' is not a valid number.";
            }
            response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse?userID=" + (userIdParam != null ? userIdParam : "") + 
                                 "&error=" + errorMsg);
        } catch (DateTimeParseException e) {
            System.err.println("❌ DateTimeParseException in UpdateAppointmentSlot: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse?userID=" + request.getParameter("userId") + 
                                 "&error=Invalid date or time format: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            System.err.println("❌ IllegalArgumentException in UpdateAppointmentSlot: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse?userID=" + request.getParameter("userId") + 
                                 "&error=" + e.getMessage());
        } catch (SQLException e) {
            System.err.println("❌ SQLException in UpdateAppointmentSlot: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse?userID=" + request.getParameter("userId") + 
                                 "&error=Database error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("❌ Unexpected error in UpdateAppointmentSlot: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse?userID=" + request.getParameter("userId") + 
                                 "&error=An unexpected error occurred: " + e.getMessage());
        }
    }
}