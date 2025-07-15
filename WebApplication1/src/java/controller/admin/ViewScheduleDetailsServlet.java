package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Users;
import model.service.UserService;
import model.entity.ScheduleEmployee;
import model.service.SchedulesService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.temporal.TemporalAdjusters;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@WebServlet(name = "ViewScheduleDetailsServlet", urlPatterns = {"/ViewScheduleDetailsServlet"})
public class ViewScheduleDetailsServlet extends HttpServlet {

    private UserService userService;
    private SchedulesService schedulesService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        schedulesService = new SchedulesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy userID từ request
            String userIdStr = request.getParameter("userID");
            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu ID nhân viên.");
                request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
                return;
            }
            int userID;
            try {
                userID = Integer.parseInt(userIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID nhân viên không hợp lệ: " + e.getMessage());
                request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin nhân viên từ UserService
            Users employee = userService.getEmployeeByID(userID);
            if (employee == null) {
                request.setAttribute("error", "Không tìm thấy nhân viên với ID: " + userID);
                request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
                return;
            }

            // Lấy năm và tuần từ request, mặc định là năm và tuần hiện tại (08:25 AM +07, 15/07/2025, tuần 29)
            String yearStr = request.getParameter("year");
            String weekStr = request.getParameter("week");
            int year = (yearStr != null && !yearStr.isEmpty()) ? Integer.parseInt(yearStr) : LocalDate.now().getYear(); // 2025
            int week = (weekStr != null && !weekStr.isEmpty()) ? Integer.parseInt(weekStr) : 
                      LocalDate.now().get(WeekFields.of(Locale.getDefault()).weekOfWeekBasedYear()); // Tuần 29

            // Tính ngày bắt đầu của tuần
            LocalDate firstDayOfYear = LocalDate.of(year, 1, 1);
            LocalDate weekStart = firstDayOfYear.with(WeekFields.of(Locale.getDefault()).weekOfWeekBasedYear(), week)
                    .with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
            LocalDate weekEnd = weekStart.plusDays(6);

            // Debug: In thông tin tuần để kiểm tra
            System.out.println("Year: " + year + ", Week: " + week + ", WeekStart: " + weekStart + ", WeekEnd: " + weekEnd);

            // Lấy danh sách lịch làm việc trong tuần
            List<ScheduleEmployee> allSchedules = schedulesService.getScheduleEmployeesByDateRange(weekStart, weekEnd);
            if (allSchedules == null) {
                allSchedules = new ArrayList<>(); // Tránh NullPointerException
            }

            // Lọc danh sách lịch theo userId
            List<ScheduleEmployee> schedules = allSchedules.stream()
                    .filter(schedule -> schedule != null && schedule.getUserId() == userID)
                    .collect(Collectors.toList());

            // Debug: In danh sách lịch
            System.out.println("All Schedules: " + allSchedules.size() + " records");
            System.out.println("Filtered Schedules for userID " + userID + ": " + schedules.size() + " records");

            // Tạo danh sách ca làm việc
            List<TimeSlot> timeSlots = new ArrayList<>();
            timeSlots.add(new TimeSlot("Sáng", LocalTime.of(7, 30), LocalTime.of(12, 30)));
            timeSlots.add(new TimeSlot("Chiều", LocalTime.of(13, 30), LocalTime.of(17, 30)));

            // Gửi dữ liệu đến JSP
            request.setAttribute("employee", employee);
            request.setAttribute("schedules", schedules);
            request.setAttribute("weekStart", java.sql.Date.valueOf(weekStart));
            request.setAttribute("year", year);
            request.setAttribute("week", week);
            request.setAttribute("timeSlots", timeSlots);

            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải lịch làm việc: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
        }
    }

    // Cập nhật lớp TimeSlot
    public static class TimeSlot {
        private String display;
        private LocalTime startTime;
        private LocalTime endTime;

        public TimeSlot(String display, LocalTime startTime, LocalTime endTime) {
            this.display = display;
            this.startTime = startTime;
            this.endTime = endTime;
        }

        public String getDisplay() { return display; }
        public LocalTime getStartTime() { return startTime; }
        public LocalTime getEndTime() { return endTime; }
    }
}