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
        
        // ✅ Lấy userID từ request để redirect về đúng trang
        String userIdParam = request.getParameter("userId");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            userIdParam = request.getParameter("userID"); // fallback
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
                String redirectUrl = buildRedirectUrl(request, userIdParam, "Slot ID is required to delete schedule.");
                response.sendRedirect(redirectUrl);
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
                String redirectUrl = buildRedirectUrl(request, userIdParam, "Invalid Slot ID format: " + slotIdParam);
                response.sendRedirect(redirectUrl);
                return;
            }
            
            // ✅ Kiểm tra slot có tồn tại không trước khi xóa
            try {
                var scheduleToDelete = scheduleService.getScheduleById(slotId);
                if (scheduleToDelete == null) {
                    System.err.println("❌ Schedule not found for slotId: " + slotId + " at " + LocalDateTime.now() + " +07");
                    String redirectUrl = buildRedirectUrl(request, userIdParam, "Schedule slot not found with ID: " + slotId);
                    response.sendRedirect(redirectUrl);
                    return;
                }
                System.out.println("✅ Schedule found for deletion: " + scheduleToDelete.getSlotId() + 
                                 " - User: " + scheduleToDelete.getUserId() + 
                                 " - Date: " + scheduleToDelete.getSlotDate());
                                 
                // ✅ Lấy userId từ schedule nếu không có trong request
                if (userIdParam == null || userIdParam.trim().isEmpty()) {
                    userIdParam = String.valueOf(scheduleToDelete.getUserId());
                    System.out.println("🔧 Retrieved userId from schedule: " + userIdParam);
                }
            } catch (SQLException e) {
                System.err.println("❌ Error checking schedule existence: " + e.getMessage());
                String redirectUrl = buildRedirectUrl(request, userIdParam, "Error verifying schedule: " + e.getMessage());
                response.sendRedirect(redirectUrl);
                return;
            }
            
            // Call service to delete the schedule
            boolean deleted = scheduleService.deleteScheduleEmployee(slotId);
            
            if (deleted) {
                System.out.println("✅ Schedule slot " + slotId + " deleted successfully at " + LocalDateTime.now() + " +07");
                
                // ✅ Redirect về trang view schedule với success message và userID
                String redirectUrl = buildRedirectUrl(request, userIdParam, "Xóa lịch làm việc thành công!");
                response.sendRedirect(redirectUrl);
            } else {
                System.err.println("❌ Failed to delete schedule slot " + slotId + " at " + LocalDateTime.now() + " +07");
                String redirectUrl = buildRedirectUrl(request, userIdParam, "Không thể xóa lịch làm việc. Vui lòng thử lại sau.");
                response.sendRedirect(redirectUrl);
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
                errorMessage = "Không thể xóa lịch này vì đã có bệnh nhân đặt lịch hẹn.";
            } else if (sqlMessage.contains("deadlock")) {
                errorMessage = "Hệ thống đang bận, vui lòng thử lại sau.";
            } else {
                errorMessage = "Có lỗi xảy ra khi xóa lịch làm việc. Vui lòng thử lại sau.";
            }
            
            String redirectUrl = buildRedirectUrl(request, userIdParam, errorMessage);
            response.sendRedirect(redirectUrl);
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ ClassNotFoundException in DeleteAppointmentServlet at " + LocalDateTime.now() + " +07: " + e.getMessage());
            e.printStackTrace();
            String redirectUrl = buildRedirectUrl(request, userIdParam, "Lỗi hệ thống. Vui lòng liên hệ quản trị viên.");
            response.sendRedirect(redirectUrl);
        }
    }
    
    /**
     * ✅ Helper method để build redirect URL với parameters
     */
    private String buildRedirectUrl(HttpServletRequest request, String userIdParam, String message) {
        StringBuilder url = new StringBuilder(request.getContextPath() + "/ViewScheduleDoctorNurse");
        
        boolean hasParams = false;
        
        // Thêm userID parameter
        if (userIdParam != null && !userIdParam.trim().isEmpty()) {
            url.append("?userID=").append(userIdParam);
            hasParams = true;
        }
        
        // Thêm message parameter
        if (message != null && !message.trim().isEmpty()) {
            if (hasParams) {
                url.append("&");
            } else {
                url.append("?");
            }
            
            try {
                // ✅ URL encode message để tránh lỗi với ký tự đặc biệt
                String encodedMessage = java.net.URLEncoder.encode(message, "UTF-8");
                
                // Phân biệt success và error message
                if (message.contains("thành công") || message.contains("successfully")) {
                    url.append("success=").append(encodedMessage);
                } else {
                    url.append("error=").append(encodedMessage);
                }
            } catch (Exception e) {
                System.err.println("❌ Error encoding message: " + e.getMessage());
                url.append("error=").append("Message encoding error");
            }
        }
        
        String finalUrl = url.toString();
        System.out.println("🔗 Redirecting to: " + finalUrl);
        return finalUrl;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to prevent accidental deletions
        System.out.println("⚠️ GET request to DeleteAppointmentServlet redirected at " + LocalDateTime.now() + " +07");
        response.sendRedirect(request.getContextPath() + "/ViewScheduleDoctorNurse");
    }
}