package controller.admin;

import model.service.SchedulesService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ViewSchedulesServlet", urlPatterns = {"/ViewSchedulesServlet"})
public class ViewSchedulesServlet extends HttpServlet {
    private final SchedulesService schedulesService = new SchedulesService();

    @Override
    public void init() throws ServletException {
        // No specific initialization needed
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String role = request.getParameter("role"); // Get role from request parameter
        Integer userId = request.getParameter("userId") != null ? Integer.parseInt(request.getParameter("userId")) : null;

        if (role == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Role parameter is required");
            return;
        }

        try {
            List<Map<String, Object>> schedules = schedulesService.getSchedulesByRoleAndUserId(role, userId);

            if (schedules != null) {
                request.setAttribute("schedules", schedules);
                request.getRequestDispatcher("/views/admin/ViewSchedule.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "No schedules found");
            }
        } catch (SQLException e) {
            System.err.println("ViewSchedulesServlet - Database error: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi tải danh sách lịch: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewSchedule.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Reuse doGet for simplicity
    }
}