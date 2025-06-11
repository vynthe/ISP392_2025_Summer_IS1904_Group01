package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.Users;
import model.service.SchedulesService;
import model.service.UserService;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.entity.Schedules;

@WebServlet(name = "ViewSchedulesServlet", urlPatterns = {"/ViewSchedulesServlet"})
public class ViewSchedulesServlet extends HttpServlet {
    private SchedulesService scheduleService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        scheduleService = new SchedulesService();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        System.out.println("Session check at " + new java.util.Date() + ": Session = " + (session != null ? "exists, ID: " + session.getId() : "null"));
        if (session == null || (session.getAttribute("admin") == null && session.getAttribute("user") == null)) {
            System.out.println("No active session or user/admin found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Lấy message và error từ session (nếu có) và xóa sau khi lấy
        String message = (String) session.getAttribute("message");
        String error = (String) session.getAttribute("error");
        if (message != null) {
            request.setAttribute("message", message);
            session.removeAttribute("message");
        }
        if (error != null) {
            request.setAttribute("error", error);
            session.removeAttribute("error");
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");

        try {
            List<Map<String, Object>> schedules = null;
            Integer entityId = null;
            String role = null;

            if (admin != null) {
                entityId = admin.getAdminID();
                role = "admin";
            } else if (user != null) {
                entityId = user.getUserID();
                role = user.getRole().toLowerCase();
            } else {
                System.out.println("User or admin object is null after session check. Redirecting to login.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            System.out.println("Entity ID: " + entityId + ", Role: " + role);
            Map<Integer, String> employeeMap = userService.getEmployeeNameMap();
            System.out.println("Employee Map Size: " + (employeeMap != null ? employeeMap.size() : 0));

            // Lấy tham số tìm kiếm từ request
            String employeeName = request.getParameter("employeeName");
            String searchRole = request.getParameter("role"); // Thêm tham số role
            String employeeID = request.getParameter("employeeID"); // Thêm tham số employeeID
            String searchDateStr = request.getParameter("searchDate");
            LocalDate searchDate = searchDateStr != null && !searchDateStr.isEmpty() ? LocalDate.parse(searchDateStr) : null;

            if ("admin".equalsIgnoreCase(role) || "receptionist".equalsIgnoreCase(role)) {
                if (employeeName != null || searchRole != null || employeeID != null || searchDate != null) {
                    schedules = scheduleService.searchSchedule(employeeName, searchRole, employeeID, searchDate); // Cập nhật phương thức searchSchedule
                } else {
                    schedules = scheduleService.getAllSchedules();
                }
                request.setAttribute("schedules", schedules);
                request.setAttribute("employeeMap", employeeMap);
                request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
            } else if ("doctor".equalsIgnoreCase(role) || "nurse".equalsIgnoreCase(role)) {
                List<Schedules> tempSchedules = scheduleService.getSchedulesByRoleAndUserId(role, entityId);
                schedules = convertSchedulesToMap(tempSchedules, employeeMap);
                request.setAttribute("schedules", schedules);
                request.setAttribute("employeeMap", employeeMap);
                request.getRequestDispatcher("/views/user/DoctorNurse/ViewScheduleEmployee.jsp").forward(request, response);
            } else if ("patient".equalsIgnoreCase(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Patients are not allowed to view schedules.");
                return;
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or undefined role.");
                return;
            }
        } catch (SQLException e) {
            System.out.println("SQL Error in ViewSchedulesServlet at " + new java.util.Date() + ": " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        } catch (ClassNotFoundException e) {
            System.out.println("ClassNotFoundException in ViewSchedulesServlet at " + new java.util.Date() + ": " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Application configuration error: Database driver not found. " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    private List<Map<String, Object>> convertSchedulesToMap(List<Schedules> schedules, Map<Integer, String> employeeMap) {
        List<Map<String, Object>> result = new ArrayList<>();
        for (Schedules schedule : schedules) {
            Map<String, Object> scheduleMap = new HashMap<>();
            scheduleMap.put("scheduleID", schedule.getScheduleID());
            scheduleMap.put("employeeID", schedule.getEmployeeID());
            scheduleMap.put("role", schedule.getRole());
            scheduleMap.put("startTime", schedule.getStartTime());
            scheduleMap.put("endTime", schedule.getEndTime());
            scheduleMap.put("dayOfWeek", schedule.getDayOfWeek());
            scheduleMap.put("roomID", schedule.getRoomID());
            scheduleMap.put("shiftStart", schedule.getShiftStart());
            scheduleMap.put("shiftEnd", schedule.getShiftEnd());
            scheduleMap.put("status", schedule.getStatus());
            scheduleMap.put("createdBy", schedule.getCreatedBy());
            scheduleMap.put("createdAt", schedule.getCreatedAt());
            scheduleMap.put("updatedAt", schedule.getUpdatedAt());
            scheduleMap.put("fullName", employeeMap.getOrDefault(schedule.getEmployeeID(), "Unknown"));
            result.add(scheduleMap);
        }
        return result;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}