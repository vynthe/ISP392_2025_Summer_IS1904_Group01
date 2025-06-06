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
import org.json.JSONArray;
import org.json.JSONObject;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AddSchedulesServlet", urlPatterns = {"/AddSchedulesServlet"})
public class AddSchedulesServlet extends HttpServlet {

    private SchedulesService scheduleService;

    @Override
    public void init() throws ServletException {
        scheduleService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No active session.");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");
        if (admin == null && (user == null || !"admin".equalsIgnoreCase(user.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admins can access this.");
            return;
        }

        try {
            List<Schedules> schedules = scheduleService.getAllSchedules();
            JSONArray jsonArray = new JSONArray();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            for (Schedules schedule : schedules) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("scheduleId", schedule.getScheduleID());
                jsonObject.put("startTime", sdf.format(schedule.getStartTime()));
                jsonObject.put("endTime", sdf.format(schedule.getEndTime()));
                jsonObject.put("dayOfWeek", schedule.getDayOfWeek());
                jsonObject.put("roomId", schedule.getRoomID());
                jsonObject.put("doctorName", schedule.getDoctorName());
                jsonObject.put("nurseName", schedule.getNurseName());
                jsonObject.put("status", schedule.getStatus());
                jsonArray.put(jsonObject);
            }
            response.getWriter().write(jsonArray.toString());
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "No active session.");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");
        if (admin == null && (user == null || !"admin".equalsIgnoreCase(user.getRole()))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only admins can access this.");
            return;
        }

        Integer userId = admin != null ? admin.getAdminID() : user.getUserID();

        try {
            String jsonData = request.getReader().lines().reduce("", (a, b) -> a + b);
            JSONObject jsonObject = new JSONObject(jsonData);
            JSONArray events = jsonObject.getJSONArray("events");
            boolean recurring = jsonObject.getBoolean("recurring");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            List<Schedules> schedulesToAdd = new ArrayList<>();
            JSONObject responseJson = new JSONObject();

            for (int i = 0; i < events.length(); i++) {
                JSONObject event = events.getJSONObject(i);
                Schedules schedule = new Schedules();
                schedule.setStartTime(new java.sql.Date(sdf.parse(event.getString("startTime")).getTime()));
                schedule.setEndTime(new java.sql.Date(sdf.parse(event.getString("endTime")).getTime()));
                schedule.setDayOfWeek(event.getString("dayOfWeek"));
                schedule.setRoomID(event.getInt("roomId"));
                schedule.setCreatedBy(userId);
                schedule.setCreatedAt(new java.sql.Date(System.currentTimeMillis()));
                schedule.setUpdatedAt(new java.sql.Date(System.currentTimeMillis()));
                schedulesToAdd.add(schedule);
            }

            boolean success = true;
            List<JSONObject> addedEvents = new ArrayList<>();
            for (Schedules schedule : schedulesToAdd) {
                if (scheduleService.addSchedule(schedule)) {
                    JSONObject addedEvent = new JSONObject();
                    addedEvent.put("startTime", sdf.format(schedule.getStartTime()));
                    addedEvent.put("endTime", sdf.format(schedule.getEndTime()));
                    addedEvent.put("dayOfWeek", schedule.getDayOfWeek());
                    addedEvent.put("roomId", schedule.getRoomID());
                    addedEvents.add(addedEvent);
                } else {
                    success = false;
                    break;
                }
            }

            responseJson.put("success", success);
            responseJson.put("message", success ? "Schedules added successfully" : "Failed to add one or more schedules");
            responseJson.put("events", new JSONArray(addedEvents));
            response.getWriter().write(responseJson.toString());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request: " + e.getMessage());
        }
    }
}