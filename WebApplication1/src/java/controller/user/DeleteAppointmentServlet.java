package controller.user;

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
import java.time.LocalDateTime;

@WebServlet(name = "DeleteAppointmentServlet", urlPatterns = {"/DeleteAppointmentServlet"})
public class DeleteAppointmentServlet extends HttpServlet {
    
    private SchedulesService scheduleService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        scheduleService = new SchedulesService();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🔍 DeleteAppointmentServlet called at " + LocalDateTime.now() + " +07");
        
        // Get the session without creating a new one
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in and is a Receptionist
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null || !"receptionist".equalsIgnoreCase(user.getRole())) {
            System.err.println("❌ Unauthorized access attempt. User: " + 
                             (user != null ? user.getRole() : "null"));
            request.setAttribute("errorMessage", "You must be logged in as a receptionist to delete schedules.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // ✅ Log all parameters để debug
            System.out.println("📋 All request parameters:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println("  " + key + " = " + String.join(", ", values));
            });
            
            // Retrieve slotId from request parameters
            String slotIdParam = request.getParameter("slotId");
            
            // ✅ Fallback: nếu không có slotId, thử tìm index (compatibility)
            if (slotIdParam == null || slotIdParam.trim().isEmpty()) {
                slotIdParam = request.getParameter("index");
                System.out.println("⚠️ slotId not found, trying index parameter: " + slotIdParam);
            }
            
            if (slotIdParam == null || slotIdParam.trim().isEmpty()) {
                System.err.println("❌ Missing slotId parameter at " + LocalDateTime.now() + " +07");
                request.setAttribute("errorMessage", "Slot ID is required to delete schedule.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            int slotId;
            try {
                slotId = Integer.parseInt(slotIdParam.trim());
                if (slotId <= 0) {
                    throw new NumberFormatException("Slot ID must be a positive integer.");
                }
                System.out.println("✅ Valid slotId parsed: " + slotId);
            } catch (NumberFormatException e) {
                System.err.println("❌ Invalid slotId format: " + slotIdParam + " at " + LocalDateTime.now() + " +07");
                request.setAttribute("errorMessage", "Invalid Slot ID format: " + slotIdParam);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // ✅ Kiểm tra slot có tồn tại không trước khi xóa
            try {
                var scheduleToDelete = scheduleService.getScheduleById(slotId);
                if (scheduleToDelete == null) {
                    System.err.println("❌ Schedule not found for slotId: " + slotId + " at " + LocalDateTime.now() + " +07");
                    request.setAttribute("errorMessage", "Schedule slot not found with ID: " + slotId);
                    request.getRequestDispatcher("/error.jsp").forward(request, response);
                    return;
                }
                System.out.println("✅ Schedule found for deletion: " + scheduleToDelete.getSlotId() + 
                                 " - User: " + scheduleToDelete.getUserId() + 
                                 " - Date: " + scheduleToDelete.getSlotDate());
            } catch (SQLException e) {
                System.err.println("❌ Error checking schedule existence: " + e.getMessage());
                request.setAttribute("errorMessage", "Error verifying schedule: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Call service to delete the schedule
            boolean deleted = scheduleService.deleteScheduleEmployee(slotId);
            
            if (deleted) {
                System.out.println("✅ Schedule slot " + slotId + " deleted successfully at " + LocalDateTime.now() + " +07");
                
                // ✅ Redirect về trang view schedule với success message
                response.sendRedirect(request.getContextPath() + 
                    "/ViewScheduleDoctorNurse?success=Schedule deleted successfully");
            } else {
                System.err.println("❌ Failed to delete schedule slot " + slotId + " at " + LocalDateTime.now() + " +07");
                request.setAttribute("errorMessage", 
                    "Failed to delete schedule slot. It may have active appointments or constraints.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
            
        } catch (SQLException | ClassNotFoundException e) {
            // Log the exception and set error message
            System.err.println("❌ Exception in DeleteAppointmentServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while deleting the schedule slot: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to prevent accidental deletions
        System.out.println("⚠️ GET request to DeleteAppointmentServlet redirected at " + LocalDateTime.now() + " +07");
        response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse");
    }
}