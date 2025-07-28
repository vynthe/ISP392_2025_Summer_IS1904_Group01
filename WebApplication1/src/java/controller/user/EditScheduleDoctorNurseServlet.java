package controller.user;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.dao.ScheduleDAO;
import model.service.UserService;
import model.entity.Users;

@WebServlet("/EditScheduleDoctorNurseServlet")
public class EditScheduleDoctorNurseServlet extends HttpServlet {
    private ScheduleDAO scheduleDAO;
    private UserService userService;
    
    @Override
    public void init() throws ServletException {
        scheduleDAO = new ScheduleDAO();
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // ✅ Lấy cả slotId và userID
            String slotIdParam = request.getParameter("slotId");
            String userIdParam = request.getParameter("userID");
            
            if (slotIdParam == null || slotIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu Slot ID.");
                request.getRequestDispatcher("/ViewScheduleDoctorNurse?userID=" + userIdParam).forward(request, response);
                return;
            }
            
            if (userIdParam == null || userIdParam.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu User ID.");
                request.getRequestDispatcher("/ViewScheduleDoctorNurse").forward(request, response);
                return;
            }
            
            int slotId;
            int userId;
            
            try {
                slotId = Integer.parseInt(slotIdParam);
                userId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Slot ID hoặc User ID không hợp lệ.");
                request.getRequestDispatcher("/ViewScheduleDoctorNurse?userID=" + userIdParam).forward(request, response);
                return;
            }
            
            // Lấy thông tin lịch từ ScheduleDAO
            Map<String, String> schedule = scheduleDAO.getScheduleBySlotId(slotId);
            if (schedule.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy lịch với Slot ID: " + slotId);
                request.getRequestDispatcher("/ViewScheduleDoctorNurse?userID=" + userIdParam).forward(request, response);
                return;
            }
            
            // ✅ Lấy danh sách tất cả employees với xử lý null an toàn
            List<Users> allEmployees = userService.getAllEmployee();
            
            // ✅ Xử lý trường hợp null và lọc bỏ các phần tử null
            if (allEmployees == null) {
                allEmployees = new ArrayList<>();
                System.out.println("⚠️ Warning: getAllEmployee() returned null, using empty list");
            } else {
                // Lọc bỏ các phần tử null và các user không có đủ thông tin
                allEmployees = allEmployees.stream()
                    .filter(emp -> emp != null && 
                                  emp.getFullName() != null && 
                                  emp.getRole() != null)
                    .collect(Collectors.toList());
            }
            
            // Debug: In ra thông tin để kiểm tra
            System.out.println("=== DEBUG INFO ===");
            System.out.println("SlotId: " + slotId);
            System.out.println("UserId: " + userId);
            System.out.println("Current schedule role: " + schedule.get("Role"));
            System.out.println("Number of employees: " + allEmployees.size());
            
            // Debug từng employee
            for (int i = 0; i < allEmployees.size(); i++) {
                Users emp = allEmployees.get(i);
                System.out.println("Employee " + i + ":");
                System.out.println("  - UserId: " + emp.getUserID());
                System.out.println("  - FullName: " + emp.getFullName());
                System.out.println("  - Role: " + emp.getRole());
            }
            
            // ✅ Lưu thông tin lịch và danh sách bác sĩ/y tá vào request
            request.setAttribute("currentSchedule", schedule);
            request.setAttribute("slotId", slotId);
            request.setAttribute("userId", userId); // ✅ Thêm userId
            request.setAttribute("employees", allEmployees);
            
            // Forward đến JSP
            request.getRequestDispatcher("/views/user/Receptionist/EditScheduleDoctorNurse.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("SQLException trong EditScheduleDoctorNurseServlet: " + e.getMessage() +
                              " tại " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            request.setAttribute("error", "Lỗi server khi lấy thông tin lịch: " + e.getMessage());
            String userIdParam = request.getParameter("userID");
            request.getRequestDispatcher("/ViewScheduleDoctorNurse?userID=" + userIdParam).forward(request, response);
        } catch (Exception e) {
            System.err.println("Lỗi bất ngờ trong EditScheduleDoctorNurseServlet: " + e.getMessage() +
                              " tại " + LocalDateTime.now() + " +07");
            e.printStackTrace();
            request.setAttribute("error", "Lỗi bất ngờ: " + e.getMessage());
            String userIdParam = request.getParameter("userID");
            request.getRequestDispatcher("/ViewScheduleDoctorNurse?userID=" + userIdParam).forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST request nếu cần
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        scheduleDAO = null;
        userService = null;
    }
}