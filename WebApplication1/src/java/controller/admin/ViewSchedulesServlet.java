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
import java.util.List;

@WebServlet(name = "ViewSchedulesServlet", urlPatterns = {"/ViewSchedulesServlet"})
public class ViewSchedulesServlet extends HttpServlet {

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
        // Debug: Log session details
        System.out.println("Session check at " + new java.util.Date() + ": Session = " + (session != null ? "exists, ID: " + session.getId() : "null"));
        if (session != null) {
            System.out.println("Session admin: " + session.getAttribute("admin"));
            System.out.println("Session user: " + session.getAttribute("user"));
            System.out.println("Session creation time: " + new java.util.Date(session.getCreationTime()));
            System.out.println("Session last accessed: " + new java.util.Date(session.getLastAccessedTime()));
        }

        if (session == null) {
            System.out.println("No session found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check for admin or user in session
        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");

        if (admin == null && user == null) {
            System.out.println("No admin or user in session. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Schedules> schedules = null;
            Integer userId = null;
            String role = null;

            // Determine userId and role based on session
            if (admin != null) {
                userId = admin.getAdminID();
                role = "admin";
            } else { // user != null
                userId = user.getUserID();
                role = user.getRole().toLowerCase();
            }

            System.out.println("UserId: " + userId + ", Role: " + role);

            // Role-based logic for fetching schedules
            if ("admin".equalsIgnoreCase(role) || "receptionist".equalsIgnoreCase(role)) {
                // Admins and receptionists can view all schedules
                schedules = scheduleService.getAllSchedules();
                request.setAttribute("schedules", schedules);
                request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
            } else if ("doctor".equalsIgnoreCase(role) || "nurse".equalsIgnoreCase(role)) {
                // Doctors and nurses can only view their own schedules
                schedules = scheduleService.getSchedulesByRoleAndUserId(role, userId);
                request.setAttribute("schedules", schedules);
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewScheduleEmployee.jsp").forward(request, response);
            } else if ("patient".equalsIgnoreCase(role)) {
                // Patients are not allowed to view schedules
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Patients are not allowed to view schedules.");
                return;
            } else {
                // Invalid role
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid role.");
                return;
            }

        } catch (SQLException e) {
            System.out.println("SQL Error in ViewSchedulesServlet at " + new java.util.Date() + ": " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Redirect POST to GET
    }
}