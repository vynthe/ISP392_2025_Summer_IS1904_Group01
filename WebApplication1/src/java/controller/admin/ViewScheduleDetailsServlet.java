package controller.admin;

import model.entity.ScheduleEmployee;
import model.service.SchedulesService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewScheduleDetailsServlet", urlPatterns = {"/ViewScheduleDetailsServlet"})
public class ViewScheduleDetailsServlet extends HttpServlet {
    private SchedulesService schedulesService;

    @Override
    public void init() throws ServletException {
        super.init();
        schedulesService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String userIdParam = request.getParameter("userID");
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "User ID is required.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(userIdParam);

            // Fetch all schedules for the specific user without date restriction
            List<ScheduleEmployee> schedules = schedulesService.getAllSchedulesByUserId(userId);

            if (schedules == null || schedules.isEmpty()) {
                request.setAttribute("errorMessage", "No schedules found for user ID: " + userId);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Set schedules data as request attribute
            request.setAttribute("schedules", schedules);

            // Forward to JSP
            request.getRequestDispatcher("/views/admin/ViewScheduleDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid User ID format.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error retrieving schedules: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}