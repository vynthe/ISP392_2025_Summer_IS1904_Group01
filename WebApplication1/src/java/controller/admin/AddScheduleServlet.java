package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.ScheduleEmployee;
import model.entity.Users;
import model.entity.Rooms;
import model.service.SchedulesService;
import model.service.UserService;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "AddScheduleServlet", urlPatterns = {"/AddScheduleServlet"})
public class AddScheduleServlet extends HttpServlet {
    private SchedulesService scheduleService;
    private UserService userService;
    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        scheduleService = new SchedulesService();
        userService = new UserService();
        roomService = new RoomService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

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

            if (weeksToCreate < 1) {
                weeksToCreate = 1;
            }

            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate today = LocalDate.now();

            // Validate ngày bắt đầu
            if (startDate.isBefore(today)) {
                errors.append("Lỗi: Không thể tạo lịch trong quá khứ. Ngày bắt đầu phải từ hiện tại trở đi.<br>");
                overallSuccess = false;
            }

            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
                return;
            }

            // Lấy danh sách nhân viên theo role
            List<Users> users = userService.getUsersByRole(roleForAutoSchedule);
            if (users == null || users.isEmpty()) {
                errors.append("Lỗi: Không tìm thấy nhân viên nào cho vai trò " + roleForAutoSchedule + ".<br>");
                overallSuccess = false;
            } else {
                List<Integer> userIds = users.stream().map(Users::getUserID).collect(Collectors.toList());
                List<String> roles = users.stream().map(Users::getRole).collect(Collectors.toList());

                // Lấy roomId hợp lệ
                int roomId = getValidRoomId(roleForAutoSchedule);
                if (roomId == -1) {
                    errors.append("Lỗi: Không tìm thấy phòng hợp lệ cho vai trò " + roleForAutoSchedule + ".<br>");
                    overallSuccess = false;
                } else {
                    // Kiểm tra lịch đã tồn tại
                    List<ScheduleEmployee> existingSchedules = scheduleService.getScheduleEmployeesByDateRange(startDate, startDate.plusWeeks(weeksToCreate));
                    boolean scheduleExists = existingSchedules.stream()
                            .anyMatch(s -> userIds.contains(s.getUserId()) && s.getRole().equals(roleForAutoSchedule));
                    if (scheduleExists) {
                        errors.append("Lịch đã tồn tại cho vai trò " + roleForAutoSchedule + " từ ngày " + startDate + " đến " + startDate.plusWeeks(weeksToCreate) + ".<br>");
                        overallSuccess = false;
                    } else {
                        // Tạo lịch chung
                        scheduleService.generateSchedule(userIds, roles, roomId, createdBy, startDate, weeksToCreate > 52);

                        // Xử lý lịch đặc biệt
                        Map<Integer, SpecialScheduleInfo> specialSchedules = parseSpecialSchedules(request);
                        for (Map.Entry<Integer, SpecialScheduleInfo> entry : specialSchedules.entrySet()) {
                            int employeeId = entry.getKey();
                            SpecialScheduleInfo specialInfo = entry.getValue();
                            int specialRoomId = getValidRoomId(specialInfo.role);
                            if (specialRoomId == -1) {
                                errors.append("Lỗi: Không tìm thấy phòng hợp lệ cho nhân viên ID " + employeeId + " với vai trò " + specialInfo.role + ".<br>");
                                overallSuccess = false;
                                continue;
                            }

                            for (LocalDate date = startDate; date.isBefore(startDate.plusWeeks(weeksToCreate)); date = date.plusDays(1)) {
                                if (specialInfo.workingDays.contains(date.getDayOfWeek())) {
                                    ScheduleEmployee specialSlot = new ScheduleEmployee();
                                    specialSlot.setUserId(employeeId);
                                    specialSlot.setRole(specialInfo.role);
                                    specialSlot.setRoomId(specialRoomId);
                                    specialSlot.setSlotDate(date);
                                    specialSlot.setStartTime(specialInfo.shiftStart);
                                    specialSlot.setEndTime(specialInfo.shiftEnd);
                                    specialSlot.setStatus("Available");
                                    specialSlot.setCreatedBy(createdBy);
                                    scheduleService.addScheduleEmployee(specialSlot);
                                }
                            }
                        }

                        messages.append("Tạo lịch tự động thành công cho " + weeksToCreate + " tuần cho vai trò " + roleForAutoSchedule + ".<br>");
                    }
                }
            }
        } catch (NumberFormatException e) {
            errors.append("Lỗi: Dữ liệu nhập vào không hợp lệ (số tuần, ID nhân viên).<br>");
            overallSuccess = false;
        } catch (IllegalArgumentException e) {
            System.err.println("Validation Error: " + e.getMessage());
            errors.append("Lỗi validation: " + e.getMessage() + ".<br>");
            overallSuccess = false;
        }

        if (messages.length() > 0) {
            request.setAttribute("message", messages.toString());
        }
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
        } else if (overallSuccess && messages.length() == 0) {
            request.setAttribute("message", "Không có lịch nào được tạo. Vui lòng kiểm tra lại thông tin hoặc số lượng nhân viên.");
        }

        request.getRequestDispatcher("/views/admin/AddSchedule.jsp").forward(request, response);
    }

    private int getValidRoomId(String role) throws SQLException, ClassNotFoundException {
        int roomId = 0;
        try {
            if ("Receptionist".equalsIgnoreCase(role)) {
                Rooms room = roomService.getRoomByID(1); // Phòng cố định cho Receptionist
                if (room != null) {
                    roomId = 19;
                }
            } else {
                roomId = roomService.getFirstAvailableRoomId();
                if (roomId == -1) {
                    Rooms room = roomService.getRoomByID(1); // Fallback to RoomID 1 nếu không có phòng khác
                    if (room != null) {
                        roomId = 1;
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            System.err.println("Error fetching room ID: " + e.getMessage());
            throw e;
        }
        return roomId;
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

                if (shiftEnd.isBefore(shiftStart)) {
                    System.err.println("Invalid special schedule for employee " + employeeId + ": Shift end (" + shiftEnd + ") is before shift start (" + shiftStart + ").");
                    i++;
                    continue;
                }

                if (days != null && days.length > 0) {
                    List<DayOfWeek> workingDays = Arrays.stream(days)
                            .map(DayOfWeek::valueOf)
                            .collect(Collectors.toList());
                    specialSchedules.put(employeeId, new SpecialScheduleInfo(employeeId, role, workingDays, shiftStart, shiftEnd));
                }
            } catch (NumberFormatException | NullPointerException e) {
                System.err.println("Error parsing special schedule item at index " + i + ": " + e.getMessage());
            }
            i++;
        }
        return specialSchedules;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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