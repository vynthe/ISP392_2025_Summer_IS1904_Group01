package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.Schedules;
import model.entity.Users;
import model.service.UserService;
import model.service.RoomService;
import model.service.SchedulesService;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "AddScheduleServlet", urlPatterns = {"/AddScheduleServlet"})
public class AddScheduleServlet extends HttpServlet {

    private SchedulesService schedulesService;
    private UserService userService;
    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        schedulesService = new SchedulesService();
        userService = new UserService();
        roomService = new RoomService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            System.out.println("No session or admin found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Integer createdBy = admin != null ? admin.getAdminID() : null;

        if (createdBy == null) {
            System.out.println("createdBy is null. Admin ID not found in session.");
            request.setAttribute("error", "Lỗi: Không tìm thấy ID người tạo lịch trong phiên. Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
            return;
        }

        try {
            handleAutoScheduleCreation(request, response, createdBy);
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database Error in AddScheduleServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu khi tạo lịch: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Unexpected error in AddScheduleServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tạo lịch: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
        }
    }

    private void handleAutoScheduleCreation(HttpServletRequest request, HttpServletResponse response, Integer createdBy)
            throws ServletException, IOException, SQLException, ClassNotFoundException {

        StringBuilder messages = new StringBuilder();
        StringBuilder errors = new StringBuilder();
        boolean overallSuccess = true;

        try {
            String startDateStr = request.getParameter("startDate");
            int weeksToCreate = Integer.parseInt(request.getParameter("weeks"));
            String roleForAutoSchedule = request.getParameter("role");

            if (weeksToCreate < 1) weeksToCreate = 1;

            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = startDate.plusWeeks(weeksToCreate).minusDays(1); // Calculate end date for the period

            // --- KIỂM TRA TRÙNG LẶP CHO LỊCH TỰ ĐỘNG CHUNG TRƯỚC KHI TẠO ---
            // Kiểm tra xem đã có lịch chung cho vai trò này trong khoảng thời gian đã chọn chưa
            if (schedulesService.hasGeneralScheduleForRoleInPeriod(roleForAutoSchedule, startDate, endDate)) {
                errors.append("Lỗi: Lịch tự động cho vai trò ").append(roleForAutoSchedule)
                      .append(" đã được tạo trong khoảng thời gian từ ")
                      .append(startDate.toString()).append(" đến ").append(endDate.toString()).append(".<br>");
                overallSuccess = false;
            } else {
                Map<Integer, SpecialScheduleInfo> specialSchedules = parseSpecialSchedules(request);

                // Nếu không có lỗi trùng lặp lịch chung, tiến hành tạo lịch
                boolean autoScheduleCreationSuccess = createAutoSchedules(startDate, weeksToCreate, createdBy, specialSchedules, roleForAutoSchedule, errors);
                if (autoScheduleCreationSuccess) {
                    messages.append("Tạo lịch tự động thành công cho ").append(weeksToCreate).append(" tuần.<br>");
                } else {
                    overallSuccess = false; // Một phần hoặc toàn bộ lịch tự động có vấn đề
                }
            }

        } catch (NumberFormatException e) {
            errors.append("Lỗi: Dữ liệu nhập vào không hợp lệ (số tuần, ID nhân viên).<br>");
            overallSuccess = false;
        } catch (IllegalArgumentException e) {
            System.err.println("Validation Error during auto schedule creation: " + e.getMessage());
            errors.append("Lỗi validation: ").append(e.getMessage()).append(".<br>");
            overallSuccess = false;
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Database Error during auto schedule creation: " + e.getMessage());
            e.printStackTrace();
            errors.append("Lỗi cơ sở dữ liệu khi tạo lịch: ").append(e.getMessage()).append(".<br>");
            overallSuccess = false;
        } catch (Exception e) {
            e.printStackTrace();
            errors.append("Lỗi không mong muốn khi tạo lịch tự động: ").append(e.getMessage()).append(".<br>");
            overallSuccess = false;
        }

        // Đặt thông báo cuối cùng
        if (messages.length() > 0) {
            request.setAttribute("message", messages.toString());
        }
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
        } else if (overallSuccess && messages.length() == 0) {
             // Trường hợp không có lỗi và cũng không có lịch nào được tạo (ví dụ: không tìm thấy người dùng)
            request.setAttribute("message", "Không có lịch nào được tạo. Vui lòng kiểm tra lại thông tin hoặc số lượng nhân viên.");
        }

        request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
    }

    private Map<Integer, SpecialScheduleInfo> parseSpecialSchedules(HttpServletRequest request) {
        Map<Integer, SpecialScheduleInfo> specialSchedules = new HashMap<>();
        int i = 0;
        while (request.getParameter("specialSchedules[" + i + "].employeeId") != null) {
            try {
                int employeeId = Integer.parseInt(request.getParameter("specialSchedules[" + i + "].employeeId"));
                String role = request.getParameter("specialSchedules[" + i + "].role");
                LocalTime shiftStart = LocalTime.parse(request.getParameter("specialSchedules[" + i + "].shiftStart"));
                LocalTime shiftEnd = LocalTime.parse(request.getParameter("specialSchedules[" + i + "].shiftEnd"));
                String[] days = request.getParameterValues("specialSchedules[" + i + "].days");

                // Kiểm tra shiftEnd phải lớn hơn shiftStart
                if (shiftEnd.isBefore(shiftStart)) {
                    System.err.println("Invalid special schedule for employee " + employeeId + ": Shift end (" + shiftEnd + ") is before shift start (" + shiftStart + "). Skipping this entry.");
                    i++;
                    continue; // Bỏ qua lịch trình không hợp lệ này
                }

                if (days != null && days.length > 0) {
                    List<DayOfWeek> workingDays = Arrays.stream(days)
                            .map(DayOfWeek::valueOf)
                            .collect(Collectors.toList());
                    specialSchedules.put(employeeId, new SpecialScheduleInfo(employeeId, role, workingDays, shiftStart, shiftEnd));
                } else {
                     System.err.println("Invalid special schedule for employee " + employeeId + ": No days selected. Skipping this entry.");
                }
            } catch (NumberFormatException | NullPointerException e) {
                System.err.println("Error parsing special schedule item at index " + i + ": " + e.getMessage());
            }
            i++;
        }
        return specialSchedules;
    }

    private boolean createAutoSchedules(LocalDate startDate, int weeksToCreate, Integer createdBy,
            Map<Integer, SpecialScheduleInfo> specialSchedules, String roleForAutoSchedule, StringBuilder errors) 
            throws SQLException, ClassNotFoundException {
        boolean allSuccess = true;

        LocalTime defaultMorningShiftStart = LocalTime.of(7, 30);
        LocalTime defaultMorningShiftEnd = LocalTime.of(12, 0);
        LocalTime defaultAfternoonShiftStart = LocalTime.of(13, 30);
        LocalTime defaultAfternoonShiftEnd = LocalTime.of(17, 30);

        List<Users> usersToSchedule;
        try {
            usersToSchedule = userService.getUsersByRole(roleForAutoSchedule);
        } catch (ClassNotFoundException e) {
            System.err.println("ClassNotFoundException in getUsersByRole: " + e.getMessage());
            throw e; // Re-throw to be handled by caller
        }

        if (usersToSchedule == null || usersToSchedule.isEmpty()) {
            System.out.println("No users found for role: " + roleForAutoSchedule + ". Cannot create general schedules.");
            errors.append("Cảnh báo: Không tìm thấy nhân viên cho vai trò ").append(roleForAutoSchedule).append(". Không thể tạo lịch chung.<br>");
            return false; // Cannot proceed if no users
        }

        List<Integer> roomIds;
        try {
            roomIds = roomService.getAllRoomIds();
        } catch (ClassNotFoundException e) {
            System.err.println("ClassNotFoundException in getAllRoomIds: " + e.getMessage());
            throw e; // Re-throw to be handled by caller
        }

        if (roomIds == null || roomIds.isEmpty()) {
            System.out.println("No rooms available for scheduling.");
            errors.append("Lỗi: Không có phòng trống để tạo lịch.<br>");
            return false; // Cannot proceed if no rooms
        }

        int currentRoomIndex = 0; // Reset room index for each creation attempt

        for (int week = 0; week < weeksToCreate; week++) {
            for (int day = 0; day < 7; day++) {
                LocalDate currentScheduleDate = startDate.plusWeeks(week).plusDays(day);
                DayOfWeek dayOfWeekEnum = currentScheduleDate.getDayOfWeek();
                String dayOfWeekName = dayOfWeekEnum.toString().substring(0, 1).toUpperCase() + dayOfWeekEnum.toString().substring(1).toLowerCase();

                for (Users user : usersToSchedule) {
                    // This check is redundant if getUsersByRole already filters, but harmless.
                    // if (!user.getRole().equalsIgnoreCase(roleForAutoSchedule)) continue;

                    SpecialScheduleInfo specialInfo = specialSchedules.get(user.getUserID());

                    if (specialInfo != null && specialInfo.workingDays.contains(dayOfWeekEnum)) {
                        // Handle special schedule for this user on this day
                        int assignedRoomId = roomIds.get(currentRoomIndex % roomIds.size());
                        Schedules schedule = new Schedules();
                        schedule.setEmployeeID(user.getUserID());
                        schedule.setRole(user.getRole());
                        schedule.setStartTime(Date.valueOf(currentScheduleDate));
                        schedule.setEndTime(Date.valueOf(currentScheduleDate));
                        schedule.setShiftStart(Time.valueOf(specialInfo.shiftStart));
                        schedule.setShiftEnd(Time.valueOf(specialInfo.shiftEnd));
                        schedule.setDayOfWeek(dayOfWeekName);
                        schedule.setRoomID(assignedRoomId);
                        schedule.setStatus("Available");
                        schedule.setCreatedBy(createdBy);

                        try {
                            if (!schedulesService.isScheduleConflict(schedule)) {
                                if (!schedulesService.addSchedule(schedule)) {
                                    allSuccess = false;
                                    errors.append("Lỗi: Không thể tạo lịch đặc biệt cho nhân viên ID ").append(user.getUserID())
                                          .append(" vào ngày ").append(currentScheduleDate).append(".<br>");
                                }
                            } else {
                                System.out.println("Conflict detected for special schedule for user " + user.getUserID() + " on " + currentScheduleDate);
                                errors.append("Cảnh báo: Lịch trình đặc biệt cho nhân viên ID ").append(user.getUserID())
                                      .append(" vào ngày ").append(currentScheduleDate).append(" bị trùng lặp và đã bị bỏ qua.<br>");
                                allSuccess = false; // Mark as not entirely successful because of conflict
                            }
                        } catch (IllegalStateException e) {
                            System.err.println("Schedule conflict for special schedule: " + e.getMessage());
                            errors.append("Cảnh báo: ").append(e.getMessage()).append(" cho nhân viên ID ").append(user.getUserID())
                                  .append(" vào ngày ").append(currentScheduleDate).append(".<br>");
                            allSuccess = false;
                        }
                        currentRoomIndex++;
                    } else if (dayOfWeekEnum != DayOfWeek.SUNDAY) {
                        // Handle general morning shift
                        int assignedRoomIdMorning = roomIds.get(currentRoomIndex % roomIds.size());
                        Schedules scheduleMorning = new Schedules();
                        scheduleMorning.setEmployeeID(user.getUserID());
                        scheduleMorning.setRole(user.getRole());
                        scheduleMorning.setStartTime(Date.valueOf(currentScheduleDate));
                        scheduleMorning.setEndTime(Date.valueOf(currentScheduleDate));
                        scheduleMorning.setShiftStart(Time.valueOf(defaultMorningShiftStart));
                        scheduleMorning.setShiftEnd(Time.valueOf(defaultMorningShiftEnd));
                        scheduleMorning.setDayOfWeek(dayOfWeekName);
                        scheduleMorning.setRoomID(assignedRoomIdMorning);
                        scheduleMorning.setStatus("Available");
                        scheduleMorning.setCreatedBy(createdBy);

                        try {
                            if (!schedulesService.isScheduleConflict(scheduleMorning)) {
                                if (!schedulesService.addSchedule(scheduleMorning)) {
                                    allSuccess = false;
                                    errors.append("Lỗi: Không thể tạo lịch chung ca sáng cho nhân viên ID ").append(user.getUserID())
                                          .append(" vào ngày ").append(currentScheduleDate).append(".<br>");
                                }
                            } else {
                                System.out.println("Conflict detected for morning schedule for user " + user.getUserID() + " on " + currentScheduleDate);
                                 errors.append("Cảnh báo: Lịch trình chung ca sáng cho nhân viên ID ").append(user.getUserID())
                                      .append(" vào ngày ").append(currentScheduleDate).append(" bị trùng lặp và đã bị bỏ qua.<br>");
                                allSuccess = false;
                            }
                        } catch (IllegalStateException e) {
                            System.err.println("Schedule conflict for morning shift: " + e.getMessage());
                            errors.append("Cảnh báo: ").append(e.getMessage()).append(" cho ca sáng nhân viên ID ").append(user.getUserID())
                                  .append(" vào ngày ").append(currentScheduleDate).append(".<br>");
                            allSuccess = false;
                        }
                        currentRoomIndex++;

                        // Handle general afternoon shift
                        int assignedRoomIdAfternoon = roomIds.get(currentRoomIndex % roomIds.size());
                        Schedules scheduleAfternoon = new Schedules();
                        scheduleAfternoon.setEmployeeID(user.getUserID());
                        scheduleAfternoon.setRole(user.getRole());
                        scheduleAfternoon.setStartTime(Date.valueOf(currentScheduleDate));
                        scheduleAfternoon.setEndTime(Date.valueOf(currentScheduleDate));
                        scheduleAfternoon.setShiftStart(Time.valueOf(defaultAfternoonShiftStart));
                        scheduleAfternoon.setShiftEnd(Time.valueOf(defaultAfternoonShiftEnd));
                        scheduleAfternoon.setDayOfWeek(dayOfWeekName);
                        scheduleAfternoon.setRoomID(assignedRoomIdAfternoon);
                        scheduleAfternoon.setStatus("Available");
                        scheduleAfternoon.setCreatedBy(createdBy);

                        try {
                            if (!schedulesService.isScheduleConflict(scheduleAfternoon)) {
                                if (!schedulesService.addSchedule(scheduleAfternoon)) {
                                    allSuccess = false;
                                    errors.append("Lỗi: Không thể tạo lịch chung ca chiều cho nhân viên ID ").append(user.getUserID())
                                          .append(" vào ngày ").append(currentScheduleDate).append(".<br>");
                                }
                            } else {
                                System.out.println("Conflict detected for afternoon schedule for user " + user.getUserID() + " on " + currentScheduleDate);
                                 errors.append("Cảnh báo: Lịch trình chung ca chiều cho nhân viên ID ").append(user.getUserID())
                                      .append(" vào ngày ").append(currentScheduleDate).append(" bị trùng lặp và đã bị bỏ qua.<br>");
                                allSuccess = false;
                            }
                        } catch (IllegalStateException e) {
                            System.err.println("Schedule conflict for afternoon shift: " + e.getMessage());
                            errors.append("Cảnh báo: ").append(e.getMessage()).append(" cho ca chiều nhân viên ID ").append(user.getUserID())
                                  .append(" vào ngày ").append(currentScheduleDate).append(".<br>");
                            allSuccess = false;
                        }
                        currentRoomIndex++;
                    }
                }
            }
        }
        return allSuccess;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This is important: clear previous messages/errors when loading the page
        request.removeAttribute("message");
        request.removeAttribute("error");
        request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
    }

    private static class SpecialScheduleInfo {
        int employeeId;
        String role;
        List<DayOfWeek> workingDays;
        LocalTime shiftStart;
        LocalTime shiftEnd;

        SpecialScheduleInfo(int employeeId, String role, List<DayOfWeek> workingDays, LocalTime shiftStart, LocalTime shiftEnd) {
            this.employeeId = employeeId;
            this.role = role;
            this.workingDays = workingDays;
            this.shiftStart = shiftStart;
            this.shiftEnd = shiftEnd;
        }
    }
}