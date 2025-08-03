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
import java.util.List;
import java.util.Map;
import model.entity.ScheduleEmployee;

@WebServlet("/UpdateScheduleDoctorNurseServlet")
public class UpdateScheduleDoctorNurseServlet extends HttpServlet {
    private SchedulesService schedulesService;

    @Override
    public void init() throws ServletException {
        schedulesService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // ✅ Kiểm tra quyền truy cập - chỉ lễ tân mới được phép
        HttpSession session = request.getSession(false);
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
        
        System.out.println("✅ ACCESS GRANTED: User " + currentUser.getFullName() + " (receptionist) accessing UpdateSchedule");

        // 🔍 DEBUG: In ra tất cả parameters để kiểm tra
        System.out.println("=== DEBUG UpdateScheduleDoctorNurseServlet ===");
        request.getParameterMap().forEach((key, values) -> {
            System.out.println("Parameter: " + key + " = " + String.join(", ", values));
        });
        
        // Lấy các tham số từ request - TÌM KIẾM THEO THỜI GIAN
        String userIdStr = request.getParameter("userId");
        String slotDateStr = request.getParameter("slotDate");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String role = request.getParameter("role");
        String fullName = request.getParameter("fullName");
        String patientName = request.getParameter("patientName");

        // 🔍 DEBUG: In ra từng tham số cụ thể
        System.out.println("userId: '" + userIdStr + "'");
        System.out.println("slotDate: '" + slotDateStr + "'");
        System.out.println("startTime: '" + startTimeStr + "'");
        System.out.println("endTime: '" + endTimeStr + "'");
        System.out.println("role: '" + role + "'");
        System.out.println("fullName: '" + fullName + "'");

        try {
            // ✅ Validate tham số đầu vào với thông báo cụ thể
            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                System.err.println("❌ ERROR: userId is null or empty");
                request.setAttribute("error", "User ID is required. Thiếu thông tin ID nhân viên.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }
            
            if (slotDateStr == null || slotDateStr.trim().isEmpty()) {
                System.err.println("❌ ERROR: slotDate is null or empty");
                request.setAttribute("error", "Slot Date is required. Thiếu thông tin ngày làm việc.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }
            
            if (startTimeStr == null || startTimeStr.trim().isEmpty()) {
                System.err.println("❌ ERROR: startTime is null or empty");
                request.setAttribute("error", "Start Time is required. Thiếu thông tin giờ bắt đầu.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }
            
            if (endTimeStr == null || endTimeStr.trim().isEmpty()) {
                System.err.println("❌ ERROR: endTime is null or empty");
                request.setAttribute("error", "End Time is required. Thiếu thông tin giờ kết thúc.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(userIdStr);
            LocalDate slotDate = LocalDate.parse(slotDateStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);

            System.out.println("✅ PARSED: userId=" + userId + ", date=" + slotDate + ", time=" + startTime + "-" + endTime);

            // 🔍 DEBUG: In ra format thời gian để kiểm tra
            System.out.println("🔍 DEBUG: slotDateStr='" + slotDateStr + "', startTimeStr='" + startTimeStr + "', endTimeStr='" + endTimeStr + "'");
            System.out.println("🔍 DEBUG: Parsed - slotDate=" + slotDate + ", startTime=" + startTime + ", endTime=" + endTime);

            // Lấy thông tin lịch dựa trên userId và thời gian
            Map<String, String> currentSchedule = schedulesService.getScheduleByUserAndTime(
                    userId, slotDateStr, startTimeStr, endTimeStr);

            if (currentSchedule == null || currentSchedule.isEmpty()) {
                System.err.println("❌ ERROR: Schedule not found for user " + userId + " at " + slotDate + " " + startTime + "-" + endTime);
                
                // 🔍 DEBUG: Thử tìm kiếm theo cách khác
                System.out.println("🔍 DEBUG: Trying alternative search...");
                try {
                    List<ScheduleEmployee> allSchedules = schedulesService.getAllSchedulesByDoctorNurseId(userId);
                    System.out.println("🔍 DEBUG: Found " + (allSchedules != null ? allSchedules.size() : 0) + " total schedules for user " + userId);
                    
                    if (allSchedules != null) {
                        for (ScheduleEmployee schedule : allSchedules) {
                            System.out.println("🔍 DEBUG: Schedule - Date: " + schedule.getSlotDate() + 
                                             ", Start: " + schedule.getStartTime() + 
                                             ", End: " + schedule.getEndTime() + 
                                             ", SlotID: " + schedule.getSlotId());
                            
                            // So sánh với thời gian được truyền
                            if (schedule.getSlotDate() != null && schedule.getSlotDate().equals(slotDate)) {
                                System.out.println("🔍 DEBUG: ✅ Date matches!");
                                if (schedule.getStartTime() != null && schedule.getStartTime().equals(startTime)) {
                                    System.out.println("🔍 DEBUG: ✅ Start time matches!");
                                } else {
                                    System.out.println("🔍 DEBUG: ❌ Start time mismatch - DB: " + schedule.getStartTime() + " vs Input: " + startTime);
                                }
                                if (schedule.getEndTime() != null && schedule.getEndTime().equals(endTime)) {
                                    System.out.println("🔍 DEBUG: ✅ End time matches!");
                                } else {
                                    System.out.println("🔍 DEBUG: ❌ End time mismatch - DB: " + schedule.getEndTime() + " vs Input: " + endTime);
                                }
                            }
                        }
                        
                        // 🔍 DEBUG: Thử tìm kiếm theo slotId nếu có
                        System.out.println("🔍 DEBUG: Trying to find schedule by slotId from URL...");
                        String slotIdFromUrl = request.getParameter("slotId");
                        if (slotIdFromUrl != null && !slotIdFromUrl.trim().isEmpty()) {
                            try {
                                int slotId = Integer.parseInt(slotIdFromUrl);
                                Map<String, String> scheduleBySlotId = schedulesService.getScheduleBySlotId(slotId);
                                if (scheduleBySlotId != null && !scheduleBySlotId.isEmpty()) {
                                    System.out.println("🔍 DEBUG: ✅ Found schedule by slotId: " + scheduleBySlotId);
                                    currentSchedule = scheduleBySlotId;
                                } else {
                                    System.out.println("🔍 DEBUG: ❌ No schedule found by slotId: " + slotId);
                                }
                            } catch (NumberFormatException e) {
                                System.err.println("🔍 DEBUG: Invalid slotId format: " + slotIdFromUrl);
                            }
                        }
                    }
                } catch (Exception e) {
                    System.err.println("🔍 DEBUG: Error getting all schedules: " + e.getMessage());
                    e.printStackTrace();
                }
                
                // Nếu vẫn không tìm thấy, báo lỗi
                if (currentSchedule == null || currentSchedule.isEmpty()) {
                    request.setAttribute("error", "Không tìm thấy lịch làm việc cho thời gian này.");
                    request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                    return;
                }
            }

            System.out.println("✅ FOUND SCHEDULE: " + currentSchedule);

            // Kiểm tra xem có bệnh nhân đặt lịch không
            String patientId = currentSchedule.get("PatientID");
            if (patientId == null || patientId.trim().isEmpty()) {
                System.err.println("❌ ERROR: No patient found in schedule");
                request.setAttribute("error", "Lịch này chưa có bệnh nhân đặt, không cần đổi bác sĩ.");
                request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
                return;
            }

            System.out.println("✅ PATIENT FOUND: PatientID=" + patientId);

            // Lấy danh sách bác sĩ/y tá khả dụng cùng khung giờ nhưng chưa có bệnh nhân
            List<Users> availableEmployees = schedulesService.getAvailableEmployeesForReassignment(
                    role, slotDate, startTime, endTime, userId);

            System.out.println("✅ AVAILABLE EMPLOYEES: " + (availableEmployees != null ? availableEmployees.size() : 0));

            // Đặt các thuộc tính để truyền sang JSP
            request.setAttribute("userId", userId);
            request.setAttribute("slotDate", slotDate); // LocalDate object
            request.setAttribute("slotDateStr", slotDateStr); // String format
            request.setAttribute("startTime", startTime);
            request.setAttribute("endTime", endTime);
            request.setAttribute("role", role);
            request.setAttribute("fullName", fullName != null ? fullName : currentSchedule.get("FullName"));
            request.setAttribute("patientName", patientName != null ? patientName : "Có bệnh nhân đặt lịch");
            request.setAttribute("patientId", Integer.parseInt(patientId));
            request.setAttribute("availableEmployees", availableEmployees);

            // ✅ Load dữ liệu schedules để JSP có thể hiển thị
            try {
                List<ScheduleEmployee> schedules = schedulesService.getAllSchedulesByDoctorNurseId(userId);
                request.setAttribute("schedules", schedules);
                System.out.println("✅ Loaded " + (schedules != null ? schedules.size() : 0) + " schedules for user " + userId);
            } catch (SQLException e) {
                System.err.println("❌ Error loading schedules: " + e.getMessage());
                request.setAttribute("schedules", null);
            }

            System.out.println("✅ FORWARDING TO: /views/user/Receptionist/EditScheduleDoctorNurse.jsp");

            // Chuyển hướng đến JSP mới
            request.getRequestDispatcher("/views/user/Receptionist/EditScheduleDoctorNurse.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("❌ NumberFormatException: " + e.getMessage());
            request.setAttribute("error", "ID lịch không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("❌ SQLException: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy danh sách nhân viên khả dụng: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            System.err.println("❌ IllegalArgumentException: " + e.getMessage());
            request.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("❌ Unexpected Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/user/Receptionist/ViewScheduleDoctorNurse.jsp").forward(request, response);
        }
    }
}