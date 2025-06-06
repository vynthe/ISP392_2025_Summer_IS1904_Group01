package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.Users;
import model.entity.Schedules;
import model.service.SchedulesService;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "ViewScheduleDetailsServlet", urlPatterns = {"/ViewScheduleDetailsServlet"})
public class ViewScheduleDetailsServlet extends HttpServlet {

    private SchedulesService scheduleService;

    @Override
    public void init() throws ServletException {
        scheduleService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");

        // Check if the user is logged in
        HttpSession session = request.getSession(false);
        System.out.println("Session check at " + new java.util.Date() + ": Session = " + (session != null ? "exists, ID: " + session.getId() : "null"));
        if (session != null) {
            System.out.println("Session admin: " + session.getAttribute("admin"));
            System.out.println("Session user: " + session.getAttribute("user"));
        }

        if (session == null) {
            System.out.println("No session found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");

        if (admin == null && user == null) {
            System.out.println("No admin or user in session. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Determine role for access control
        String role = admin != null ? "admin" : user.getRole().toLowerCase();
        Integer userId = admin != null ? admin.getAdminID() : user.getUserID();

        try {
            // Get scheduleId from request
            String scheduleIdParam = request.getParameter("scheduleId");
            if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Schedule ID is required.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }
            int scheduleId = Integer.parseInt(scheduleIdParam);

            // Fetch schedule details
            Schedules schedule = scheduleService.getScheduleById(scheduleId);
            if (schedule == null) {
                request.setAttribute("error", "Schedule not found.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }

            // Access control: Doctors/Nurses can only view their own schedules
            if ("doctor".equalsIgnoreCase(role) && schedule.getDoctorID() != userId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only view your own schedules.");
                return;
            }
            if ("nurse".equalsIgnoreCase(role) && schedule.getNurseID() != userId) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only view your own schedules.");
                return;
            }
            if ("patient".equalsIgnoreCase(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Patients are not allowed to view schedules.");
                return;
            }

            // Set schedule for display
            request.setAttribute("schedule", schedule);
            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid Schedule ID format.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("SQL Error in ViewScheduleDetailsServlet at " + new java.util.Date() + ": " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}