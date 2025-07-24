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
import java.util.List;

@WebServlet(name = "ViewScheduleDoctorNurse", urlPatterns = {"/ViewScheduleDoctorNurse"})
public class ViewScheduleDoctorNurse extends HttpServlet {
    private SchedulesService schedulesService;

    @Override
    public void init() throws ServletException {
        super.init();
        schedulesService = new SchedulesService(); // Replace with your actual service initialization (e.g., dependency injection)
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            String userIdParam = request.getParameter("userID");
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "User ID is required.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            int userId;
            try {
                userId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid User ID format.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Fetch all schedules for the specific user (Doctors and Nurses only)
            List<ScheduleEmployee> schedules = schedulesService.getAllSchedulesByDoctorNurseId(userId);

            if (schedules == null || schedules.isEmpty()) {
                request.setAttribute("errorMessage", "No schedules found for user ID: " + userId);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            // Set schedules data as request attribute
            request.setAttribute("schedules", schedules);

            // Forward to JSP for Receptionists
            request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error retrieving schedules: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}