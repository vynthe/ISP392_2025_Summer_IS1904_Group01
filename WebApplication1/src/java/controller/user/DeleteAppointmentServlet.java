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
                request.setAttribute("error", "Slot ID is required to delete schedule.");
                request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
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
                request.setAttribute("error", "Invalid Slot ID format: " + slotIdParam);
                request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
                return;
            }
            
            // ✅ Kiểm tra slot có tồn tại không trước khi xóa
            try {
                var scheduleToDelete = scheduleService.getScheduleById(slotId);
                if (scheduleToDelete == null) {
                    System.err.println("❌ Schedule not found for slotId: " + slotId + " at " + LocalDateTime.now() + " +07");
                    request.setAttribute("error", "Schedule slot not found with ID: " + slotId);
                    request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
                    return;
                }
                System.out.println("✅ Schedule found for deletion: " + scheduleToDelete.getSlotId() + 
                                 " - User: " + scheduleToDelete.getUserId() + 
                                 " - Date: " + scheduleToDelete.getSlotDate());
            } catch (SQLException e) {
                System.err.println("❌ Error checking schedule existence: " + e.getMessage());
                request.setAttribute("error", "Error verifying schedule: " + e.getMessage());
                request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
                return;
            }
            

            
            // Call service to delete the schedule
            boolean deleted = scheduleService.deleteScheduleEmployee(slotId);
            
            if (deleted) {
                System.out.println("✅ Schedule slot " + slotId + " deleted successfully at " + LocalDateTime.now() + " +07");
                
                // ✅ Redirect về trang view schedule với success message
                response.sendRedirect(request.getContextPath() + 
                    "/ViewScheduleDoctorNurse?success=Xóa lịch làm việc thành công");
            } else {
                System.err.println("❌ Failed to delete schedule slot " + slotId + " at " + LocalDateTime.now() + " +07");
                request.setAttribute("error", 
                    "Không thể xóa lịch làm việc. Vui lòng thử lại sau.");
                request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
            }
            
        } catch (SQLException e) {
            // ✅ Bắt tất cả lỗi SQL và kiểm tra message cụ thể
            System.err.println("❌ SQLException in DeleteAppointmentServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            
            String errorMessage;
            String sqlMessage = e.getMessage().toLowerCase();
            
            // Kiểm tra các loại lỗi SQL phổ biến
            if (sqlMessage.contains("foreign key") || sqlMessage.contains("constraint") || 
                sqlMessage.contains("references") || sqlMessage.contains("violates") ||
                sqlMessage.contains("cannot delete") || sqlMessage.contains("integrity")) {
                errorMessage = "Không thể xóa lịch này vì đã có bệnh nhân đặt lịch hẹn. "  ;
            } else if (sqlMessage.contains("deadlock")) {
                errorMessage = "Hệ thống đang bận, vui lòng thử lại sau.";
            } else {
                errorMessage = "Có lỗi xảy ra khi xóa lịch làm việc. Vui lòng thử lại sau.";
            }
            
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ ClassNotFoundException in DeleteAppointmentServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng liên hệ quản trị viên.");
            request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
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