package controller.admin;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.SchedulesService;

@WebServlet(name = "UpdateSchedulesServlet", urlPatterns = {"/UpdateSchedulesServlet"})
public class UpdateSchedulesServlet extends HttpServlet {

    private final SchedulesService schedulesService = new SchedulesService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = (String) request.getSession().getAttribute("role");

        if (!"admin".equalsIgnoreCase(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admin can update schedule");
            return;
        }

        response.setContentType("application/json;charset=UTF-8");
        try {
            Map<String, Object> scheduleData = new HashMap<>();
            scheduleData.put("scheduleId", Integer.parseInt(request.getParameter("scheduleId")));
            scheduleData.put("startTime", Date.valueOf(request.getParameter("startTime")));
            scheduleData.put("endTime", Date.valueOf(request.getParameter("endTime")));
            scheduleData.put("dayOfWeek", request.getParameter("dayOfWeek"));
            scheduleData.put("roomId", Integer.parseInt(request.getParameter("roomId")));
            scheduleData.put("createdBy", Integer.parseInt(request.getParameter("createdBy")));
            scheduleData.put("status", request.getParameter("status"));
            boolean success = schedulesService.updateSchedule(scheduleData);
            response.getWriter().write("{\"success\": " + success + "}");
        } catch (NumberFormatException | IllegalArgumentException | SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error updating schedule: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Use POST method to update schedule");
    }

    public String getServletInfo() {
        return "Update Schedule Servlet";
    }
}