package controller.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.ScheduleEmployee;
import model.service.SchedulesService;
import model.service.UserService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "ViewScheduleUserServlet", urlPatterns = {"/ViewScheduleUserServlet"})
public class ViewScheduleUserServlet extends HttpServlet {

    private SchedulesService scheduleService;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        scheduleService = new SchedulesService();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String destinationPage = "/views/login.jsp"; // Default page

        // Simulate user from request parameters for testing
        String roleParam = request.getParameter("role");
        String userIdParam = request.getParameter("userId");
        String role = (roleParam != null && !roleParam.isEmpty()) ? roleParam.toLowerCase() : "doctor";
        int userId = (userIdParam != null && !userIdParam.isEmpty()) ? Integer.parseInt(userIdParam) : 1;

        System.out.println("Role: " + role + ", UserID: " + userId); // Debug output

        List<ScheduleEmployee> schedules = null;

        try {
            // Fetch schedules based on simulated role
            if ("doctor".equals(role) || "nurse".equals(role)) {
                System.out.println("Fetching schedules with details for userId: " + userId);
                schedules = userService.getUserSchedulesWithDetails(userId);
            } else if ("receptionist".equals(role)) {
                System.out.println("Fetching schedules for receptionist userId: " + userId);
                schedules = userService.getUserSchedulesForReceptionist(userId);
            } else {
                System.out.println("Invalid role detected: " + role);
                request.setAttribute("error", "Vai trò người dùng không hợp lệ.");
                destinationPage = "/views/error.jsp";
            }

            // Debug: Check if schedules are retrieved
            System.out.println("Schedules retrieved: " + (schedules != null ? schedules.size() : "null"));

            // Set schedules as request attribute
            request.setAttribute("schedules", schedules);
            request.setAttribute("scheduleDetails", schedules); // For compatibility with JSP

            // Determine the destination JSP based on role
            switch (role) {
                case "doctor":
                case "nurse":
                    destinationPage = "/views/DoctorNurse/ViewScheduleEmployee.jsp";
                    break;
                case "receptionist":
                    destinationPage = "/views/receptionist/ViewScheduleReceptionist.jsp";
                    break;
                default:
                    destinationPage = "/views/error.jsp";
                    break;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("SQLException: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi tải lịch làm việc: " + e.getMessage());
            destinationPage = "/views/error.jsp";
        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.out.println("NumberFormatException: " + e.getMessage());
            request.setAttribute("error", "ID người dùng không hợp lệ.");
            destinationPage = "/views/error.jsp";
        }

        // Forward to the appropriate JSP
        System.out.println("Forwarding to: " + destinationPage);
        request.getRequestDispatcher(destinationPage).forward(request, response);
    }
}