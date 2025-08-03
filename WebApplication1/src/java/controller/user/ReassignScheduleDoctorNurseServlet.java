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
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Map;

@WebServlet("/ReassignScheduleDoctorNurseServlet")
public class ReassignScheduleDoctorNurseServlet extends HttpServlet {
    private SchedulesService schedulesService;

    @Override
    public void init() throws ServletException {
        schedulesService = new SchedulesService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // ✅ Kiểm tra quyền truy cập - chỉ lễ tân mới được phép
        Users currentUser = (session != null) ? (Users) session.getAttribute("user") : null;
        
        if (currentUser == null) {
            System.err.println("❌ ACCESS DENIED: User not logged in");
            request.setAttribute("error", "Bạn cần đăng nhập để truy cập chức năng này.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
            return;
        }
        
        if (!"receptionist".equalsIgnoreCase(currentUser.getRole())) {
            System.err.println("❌ ACCESS DENIED: User role = " + currentUser.getRole() + " (required: receptionist)");
            request.setAttribute("error", "Chỉ lễ tân mới được phép thực hiện chức năng này.");
            request.getRequestDispatcher("/views/user/Receptionist/ReceptionistDashBoard.jsp").forward(request, response);
            return;
        }
        
        System.out.println("✅ ACCESS GRANTED: User " + currentUser.getFullName() + " (receptionist) performing reassignment");
        
        // Lấy các tham số từ form
        String newUserIdStr = request.getParameter("newUserId");
        String currentUserIdStr = request.getParameter("currentUserId");
        String slotDateStr = request.getParameter("slotDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String role = request.getParameter("role");
        String patientIdStr = request.getParameter("patientId");
        String currentFullName = request.getParameter("currentFullName");
        String patientName = request.getParameter("patientName");

        // 🔍 DEBUG: In ra tất cả parameters
        System.out.println("=== DEBUG ReassignScheduleDoctorNurseServlet ===");
        System.out.println("newUserId: '" + newUserIdStr + "'");
        System.out.println("currentUserId: '" + currentUserIdStr + "'");
        System.out.println("slotDate: '" + slotDateStr + "'");
        System.out.println("startTime: '" + startTimeStr + "'");
        System.out.println("endTime: '" + endTimeStr + "'");
        System.out.println("role: '" + role + "'");
        System.out.println("patientId: '" + patientIdStr + "'");
        System.out.println("currentFullName: '" + currentFullName + "'");
        System.out.println("patientName: '" + patientName + "'");

        try {
            // Validate tham số đầu vào
            if (newUserIdStr == null || newUserIdStr.trim().isEmpty() || 
                currentUserIdStr == null || currentUserIdStr.trim().isEmpty() || 
                slotDateStr == null || slotDateStr.trim().isEmpty() || 
                startTimeStr == null || startTimeStr.trim().isEmpty() || 
                endTimeStr == null || endTimeStr.trim().isEmpty()) {
                
                System.err.println("❌ ERROR: Missing required parameters");
                request.setAttribute("error", "Thiếu thông tin bắt buộc để thực hiện đổi lịch.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }

            int newUserId = Integer.parseInt(newUserIdStr);
            int currentUserId = Integer.parseInt(currentUserIdStr);
            LocalDate slotDate = LocalDate.parse(slotDateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);

            System.out.println("✅ PARSED: currentUserId=" + currentUserId + " -> newUserId=" + newUserId + 
                             ", date=" + slotDate + ", time=" + startTime + "-" + endTime);

            // 🔍 DEBUG: In ra thông tin tìm kiếm
            System.out.println("🔍 DEBUG: Searching for schedule with:");
            System.out.println("  - currentUserId: " + currentUserId);
            System.out.println("  - slotDateStr: '" + slotDateStr + "'");
            System.out.println("  - startTimeStr: '" + startTimeStr + "'");
            System.out.println("  - endTimeStr: '" + endTimeStr + "'");

            // Lấy SlotID của bác sĩ hiện tại dựa trên thời gian
            Map<String, String> currentSchedule = schedulesService.getScheduleByUserAndTime(
                    currentUserId, slotDateStr, startTimeStr, endTimeStr);

            if (currentSchedule == null || currentSchedule.isEmpty()) {
                System.err.println("❌ ERROR: Current schedule not found");
                request.setAttribute("error", "Không tìm thấy lịch của bác sĩ/y tá hiện tại.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }

            int currentSlotId = Integer.parseInt(currentSchedule.get("SlotID"));
            System.out.println("✅ FOUND CURRENT SCHEDULE: SlotID=" + currentSlotId);

            // Kiểm tra bác sĩ mới có khả dụng không
            boolean isAvailable = schedulesService.isUserAvailableForReassignment(
                    newUserId, slotDateStr, startTimeStr, endTimeStr);

            if (!isAvailable) {
                System.err.println("❌ ERROR: New user not available");
                request.setAttribute("error", "Bác sĩ/Y tá được chọn không khả dụng trong khung giờ này hoặc đã có bệnh nhân đặt lịch.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }

            System.out.println("✅ NEW USER IS AVAILABLE");

            // Thực hiện đổi lịch - sử dụng SlotID của bác sĩ hiện tại
            boolean success = schedulesService.reassignScheduleToUser(currentSlotId, newUserId);

            if (success) {
                // Lấy thông tin bác sĩ mới để hiển thị thông báo
                Map<String, String> newDoctorSchedule = schedulesService.getScheduleByUserAndTime(
                        newUserId, slotDateStr, startTimeStr, endTimeStr);
                
                String newDoctorName = "Bác sĩ/Y tá mới";
                if (newDoctorSchedule != null && !newDoctorSchedule.isEmpty()) {
                    newDoctorName = newDoctorSchedule.get("FullName");
                }

                session.setAttribute("successMessage", 
                    "✅ Đổi lịch thành công!\n" +
                    "👨‍⚕️ Từ: " + currentFullName + "\n" +
                    "➡️ Sang: " + newDoctorName + "\n" +
                    "📅 Ngày: " + slotDate + "\n" +
                    "⏰ Giờ: " + startTime + " - " + endTime + "\n" +
                    "👤 Bệnh nhân: " + (patientName != null ? patientName : "Đã có bệnh nhân đặt lịch"));
                
                // Log thành công
                System.out.println("🔄 REASSIGN SUCCESS: " + 
                    "CurrentUser=" + currentUserId + "(" + currentFullName + ") -> " +
                    "NewUser=" + newUserId + "(" + newDoctorName + ") " +
                    "Date=" + slotDate + " Time=" + startTime + "-" + endTime +
                    " by Receptionist=" + currentUser.getFullName());
                
            } else {
                request.setAttribute("error", "❌ Không thể đổi lịch. Vui lòng thử lại hoặc liên hệ admin.");
                System.err.println("🚫 REASSIGN FAILED: CurrentUser=" + currentUserId + 
                    " -> NewUser=" + newUserId + " Date=" + slotDate + " Time=" + startTime + "-" + endTime);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID nhân viên không hợp lệ: " + e.getMessage());
            System.err.println("❌ NumberFormatException in ReassignScheduleDoctorNurseServlet: " + e.getMessage());
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu khi đổi lịch: " + e.getMessage());
            System.err.println("❌ SQLException in ReassignScheduleDoctorNurseServlet: " + e.getMessage());
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            System.err.println("❌ IllegalArgumentException in ReassignScheduleDoctorNurseServlet: " + e.getMessage());
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            System.err.println("❌ Unexpected error in ReassignScheduleDoctorNurseServlet: " + e.getMessage());
            e.printStackTrace();
        }

        // Chuyển hướng về trang lịch với thông báo
       response.sendRedirect(request.getContextPath() + "/views/user/Receptionist/ReceptionistDashBoard.jsp");
    }
}