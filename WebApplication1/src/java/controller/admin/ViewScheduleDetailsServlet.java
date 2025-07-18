package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.ScheduleEmployee;
import model.service.SchedulesService;
import model.dao.RoomsDAO;
import model.entity.Rooms;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.List;
import java.util.Locale;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "ViewScheduleDetailsServlet", urlPatterns = {"/ViewScheduleDetailsServlet"})
public class ViewScheduleDetailsServlet extends HttpServlet {
    
    private SchedulesService schedulesService;
    private RoomsDAO roomsDAO;
    
    @Override
    public void init() throws ServletException {
        roomsDAO = new RoomsDAO();
        schedulesService = new SchedulesService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Lấy userID từ request parameter
            String userIDStr = request.getParameter("userID");
            if (userIDStr == null || userIDStr.trim().isEmpty()) {
                request.setAttribute("error", "Không tìm thấy ID người dùng.");
                request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
                return;
            }
            
            int userId = Integer.parseInt(userIDStr.trim());
            
            // Xử lý tham số năm và tuần
            String yearParam = request.getParameter("year");
            String weekParam = request.getParameter("week");
            
            // Sử dụng năm hiện tại nếu không có tham số
            int year = (yearParam != null && !yearParam.trim().isEmpty()) ? 
                       Integer.parseInt(yearParam) : LocalDate.now().getYear();
            
            // Xử lý tuần - mặc định là tuần hiện tại
            LocalDate currentDate = LocalDate.now();
            LocalDate startOfWeek = currentDate;
            
            if (weekParam != null && !weekParam.trim().isEmpty()) {
                // Parse week parameter (format: "22/09 to 28/09")
                try {
                    String[] weekParts = weekParam.split(" to ");
                    if (weekParts.length == 2) {
                        String startDateStr = weekParts[0].trim() + "/" + year;
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                        startOfWeek = LocalDate.parse(startDateStr, formatter);
                    }
                } catch (Exception e) {
                    // Nếu parse lỗi, sử dụng tuần hiện tại
                    startOfWeek = currentDate.with(WeekFields.of(Locale.getDefault()).dayOfWeek(), 1);
                }
            } else {
                // Sử dụng tuần hiện tại
                startOfWeek = currentDate.with(WeekFields.of(Locale.getDefault()).dayOfWeek(), 1);
            }
            
            // Tạo mảng ngày trong tuần
            Map<String, LocalDate> weekDates = new HashMap<>();
            String[] daysOfWeek = {"monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"};
            
            for (int i = 0; i < 7; i++) {
                LocalDate dayDate = startOfWeek.plusDays(i);
                weekDates.put(daysOfWeek[i], dayDate);
            }
            
            // Lấy lịch cho cả tuần
            Map<String, List<ScheduleEmployee>> weekSchedules = new HashMap<>();
            Map<String, Map<Integer, Rooms>> weekRooms = new HashMap<>();
            Map<String, Map<Integer, String>> weekServices = new HashMap<>();
            
            for (String day : daysOfWeek) {
                LocalDate dayDate = weekDates.get(day);
                List<ScheduleEmployee> dailySchedules = schedulesService.getScheduleByDate(userId, dayDate);
                
                Map<Integer, Rooms> dailyRooms = new HashMap<>();
                Map<Integer, String> dailyServices = new HashMap<>();
                
                // Lấy thông tin phòng và dịch vụ cho từng lịch
                for (ScheduleEmployee schedule : dailySchedules) {
                    if (schedule.getRoomId() != null) {
                        Rooms room = roomsDAO.getRoomByID(schedule.getRoomId());
                        dailyRooms.put(schedule.getSlotId(), room);
                        
                        List<String> services = roomsDAO.getServicesByRoomId(schedule.getRoomId());
                        String serviceStr = (services != null && !services.isEmpty()) ? 
                                          services.get(0) : "Chưa gán dịch vụ";
                        dailyServices.put(schedule.getSlotId(), serviceStr);
                    }
                }
                
                weekSchedules.put(day, dailySchedules);
                weekRooms.put(day, dailyRooms);
                weekServices.put(day, dailyServices);
            }
            
            // Tạo thông tin tuần để hiển thị
            DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");
            String weekDisplay = startOfWeek.format(dayFormatter) + " to " + 
                               startOfWeek.plusDays(6).format(dayFormatter);
            
            // Set attributes cho JSP
            request.setAttribute("weekSchedules", weekSchedules);
            request.setAttribute("weekRooms", weekRooms);
            request.setAttribute("weekServices", weekServices);
            request.setAttribute("weekDates", weekDates);
            request.setAttribute("userId", userId);
            request.setAttribute("currentYear", year);
            request.setAttribute("currentWeek", weekDisplay);
            request.setAttribute("selectedYear", yearParam);
            request.setAttribute("selectedWeek", weekParam);
            
            // Tạo danh sách các tuần có sẵn
            String[] availableWeeks = {
                "15/09 to 21/09",
                "22/09 to 28/09", 
                "29/09 to 05/10",
                "06/10 to 12/10",
                "13/10 to 19/10",
                "20/10 to 26/10"
            };
            request.setAttribute("availableWeeks", availableWeeks);
            
            // Tạo danh sách các năm
            Integer[] availableYears = {2023, 2024, 2025, 2026};
            request.setAttribute("availableYears", availableYears);
            
            // Thông báo thành công
            request.setAttribute("message", "Đã tải lịch tuần " + weekDisplay + " năm " + year);
            
            // Forward đến JSP
            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng hoặc tham số năm không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST request (nếu cần)
        doGet(request, response);
    }
}