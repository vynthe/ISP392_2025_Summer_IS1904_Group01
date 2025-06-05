package controller.admin;

import model.service.SchedulesService;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author exorc
 */
@WebServlet(name = "AddSchedulesServlet", urlPatterns = {"/AddSchedulesServlet"})
public class AddSchedulesServlet extends HttpServlet {

    private final SchedulesService schedulesService = new SchedulesService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = (String) request.getSession().getAttribute("role");
        Integer userId = (Integer) request.getSession().getAttribute("userId");

        if (role == null || userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }

        if (!"admin".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admin can add schedule");
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String dayOfWeek = request.getParameter("dayOfWeek");
            String roomIdStr = request.getParameter("roomId");

            if (startTimeStr == null || startTimeStr.trim().isEmpty() || 
                endTimeStr == null || endTimeStr.trim().isEmpty() || 
                dayOfWeek == null || dayOfWeek.trim().isEmpty() || 
                roomIdStr == null || roomIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or empty required parameters");
                return;
            }

            // Safely parse dates
            Date startTime = parseDate(startTimeStr);
            Date endTime = parseDate(endTimeStr);
            Integer roomId = Integer.parseInt(roomIdStr);

            Map<String, Object> scheduleData = new HashMap<>();
            scheduleData.put("startTime", startTime);
            scheduleData.put("endTime", endTime);
            scheduleData.put("dayOfWeek", dayOfWeek);
            scheduleData.put("roomId", roomId);
            scheduleData.put("createdBy", userId);

            boolean success = schedulesService.addSchedule(scheduleData);
            out.write("{\"success\": " + success + "}");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input format: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format (yyyy-MM-dd required): " + e.getMessage());
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Use POST method to add schedule");
    }

    @Override
    public String getServletInfo() {
        return "Add Schedule Servlet";
    }

    // Helper method to parse and validate date strings
    private Date parseDate(String dateStr) throws IllegalArgumentException {
        // First, try parsing directly with Date.valueOf (expects yyyy-MM-dd)
        try {
            return Date.valueOf(dateStr);
        } catch (IllegalArgumentException e) {
            // If direct parsing fails, try parsing with a different format (e.g., dd-MM-yyyy)
            try {
                SimpleDateFormat inputFormat = new SimpleDateFormat("dd-MM-yyyy");
                inputFormat.setLenient(false); // Strict parsing
                java.util.Date parsedDate = inputFormat.parse(dateStr);
                SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
                String reformattedDate = outputFormat.format(parsedDate);
                return Date.valueOf(reformattedDate);
            } catch (ParseException ex) {
                throw new IllegalArgumentException("Invalid date format (yyyy-MM-dd required), got: " + dateStr);
            }
        }
    }
}