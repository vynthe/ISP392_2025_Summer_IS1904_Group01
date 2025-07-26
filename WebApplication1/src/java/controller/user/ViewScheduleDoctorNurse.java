package controller.user;
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
        schedulesService = new SchedulesService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
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
            
            // ✅ Handle success and error messages từ redirect
            String successMessage = request.getParameter("success");
            String errorMessage = request.getParameter("error");
            
            if (successMessage != null && !successMessage.trim().isEmpty()) {
                request.setAttribute("successMessage", successMessage);
                System.out.println("✅ Success message set: " + successMessage);
            }
            
            if (errorMessage != null && !errorMessage.trim().isEmpty()) {
                request.setAttribute("error", errorMessage);
                System.out.println("❌ Error message set: " + errorMessage);
            }
            
            // Fetch all schedules for the specific user (Doctors and Nurses only)
            List<ScheduleEmployee> schedules = schedulesService.getAllSchedulesByDoctorNurseId(userId);
            
            // ✅ Không redirect khi không có schedules, chỉ set message
            if (schedules == null || schedules.isEmpty()) {
                request.setAttribute("noSchedulesMessage", "No schedules found for user ID: " + userId);
                System.out.println("⚠️ No schedules found for user ID: " + userId);
                // Vẫn forward để hiển thị trang với message
            }
            
            // Set schedules data as request attribute
            request.setAttribute("schedules", schedules);
            request.setAttribute("userID", userId); // ✅ Thêm userID để JSP có thể sử dụng
            
            // Forward to JSP for Receptionists
            request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("❌ SQLException in ViewScheduleDoctorNurse: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error retrieving schedules: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("❌ Unexpected error in ViewScheduleDoctorNurse: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // ✅ Redirect POST requests to GET để tránh lỗi 405
        System.out.println("⚠️ POST request to ViewScheduleDoctorNurse redirected to GET");
        doGet(request, response);
    }
}