package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.Rooms;
import model.entity.ScheduleEmployee;
import model.entity.Users;
import model.service.SchedulesService;
import model.dao.RoomsDAO;
import model.dao.UserDAO;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@WebServlet(name = "AssignDoctorNurseToRoom", urlPatterns = {"/AssignDoctorNurseToRoom"})
public class AssignDoctorNurseToRoom extends HttpServlet {

    private SchedulesService schedulesService;
    private RoomsDAO roomsDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        schedulesService = new SchedulesService();
        roomsDAO = new RoomsDAO();
        userDAO = new UserDAO();
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
            String userIDStr = request.getParameter("userID");

            if (userIDStr == null || userIDStr.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng cung cấp ID người dùng.");
                request.getRequestDispatcher("/views/admin/AssignRoom.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(userIDStr.trim());
            List<ScheduleEmployee> schedules = schedulesService.getSchedulesWithoutRoomByUserId(userId);

            if (schedules.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy lịch trình nào chưa gán phòng cho người dùng ID: " + userId);
                request.getRequestDispatcher("/views/admin/AssignRoom.jsp").forward(request, response);
                return;
            }

            // Lấy thông tin người dùng
            Users user = userDAO.getUserByID(userId);
            if (user == null) {
                request.setAttribute("error", "Không tìm thấy thông tin người dùng với ID: " + userId);
                request.getRequestDispatcher("/views/admin/AssignRoom.jsp").forward(request, response);
                return;
            }

            // Tự động lấy ngày bắt đầu và ngày kết thúc từ các lịch
            LocalDate startDate = schedules.stream()
                    .map(ScheduleEmployee::getSlotDate)
                    .filter(Objects::nonNull)
                    .min(LocalDate::compareTo)
                    .orElse(null);
            LocalDate endDate = schedules.stream()
                    .map(ScheduleEmployee::getSlotDate)
                    .filter(Objects::nonNull)
                    .max(LocalDate::compareTo)
                    .orElse(null);

            if (startDate == null || endDate == null) {
                request.setAttribute("error", "Không xác định được khoảng thời gian từ các lịch trình.");
                request.getRequestDispatcher("/views/admin/AssignRoom.jsp").forward(request, response);
                return;
            }

            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("selectedUserId", userId);
            request.setAttribute("userName", user.getFullName());
            request.setAttribute("userRole", user.getRole());

            List<Rooms> availableRooms = roomsDAO.getAllRooms();
            request.setAttribute("availableRooms", availableRooms);
            request.getRequestDispatcher("/views/admin/AssignRoom.jsp").forward(request, response);

        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AssignRoom.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ.");
            request.getRequestDispatcher("/views/admin/AssignRoom.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Integer createdBy = admin != null ? admin.getAdminID() : null;

        if (createdBy == null) {
            request.getSession().setAttribute("error", "Lỗi: Không tìm thấy ID admin. Vui lòng đăng nhập lại.");
            response.sendRedirect(request.getContextPath() + "/AssignDoctorNurseToRoom");
            return;
        }

        String userIDStr = request.getParameter("userID");
        String morningRoomIdStr = request.getParameter("morningRoomId");
        String afternoonRoomIdStr = request.getParameter("afternoonRoomId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        if (userIDStr == null || userIDStr.trim().isEmpty() ||
            startDateStr == null || startDateStr.trim().isEmpty() ||
            endDateStr == null || endDateStr.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Vui lòng cung cấp đầy đủ người dùng, ngày bắt đầu và ngày kết thúc.");
            response.sendRedirect(request.getContextPath() + "/AssignDoctorNurseToRoom?userID=" + userIDStr);
            return;
        }

        try {
            int userId = Integer.parseInt(userIDStr.trim());
            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = LocalDate.parse(endDateStr);

            if (endDate.isBefore(startDate)) {
                request.getSession().setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu.");
                response.sendRedirect(request.getContextPath() + "/AssignDoctorNurseToRoom?userID=" + userIDStr);
                return;
            }

            int morningRoomId = (morningRoomIdStr != null && !morningRoomIdStr.trim().isEmpty()) ? Integer.parseInt(morningRoomIdStr.trim()) : 0;
            int afternoonRoomId = (afternoonRoomIdStr != null && !afternoonRoomIdStr.trim().isEmpty()) ? Integer.parseInt(afternoonRoomIdStr.trim()) : 0;

            if (morningRoomId <= 0 && afternoonRoomId <= 0) {
                request.getSession().setAttribute("error", "Vui lòng cung cấp ít nhất một ID phòng hợp lệ cho slot sáng hoặc chiều.");
                response.sendRedirect(request.getContextPath() + "/AssignDoctorNurseToRoom?userID=" + userIDStr);
                return;
            }

            List<ScheduleEmployee> schedules = schedulesService.getSchedulesWithoutRoomByUserId(userId).stream()
                    .filter(s -> s.getSlotDate() != null && !s.getSlotDate().isBefore(startDate) && !s.getSlotDate().isAfter(endDate))
                    .collect(Collectors.toList());

            if (schedules.isEmpty()) {
                request.getSession().setAttribute("error", "Không tìm thấy lịch trình nào trong khoảng thời gian từ " + startDate + " đến " + endDate);
                response.sendRedirect(request.getContextPath() + "/AssignDoctorNurseToRoom?userID=" + userIDStr);
                return;
            }

            ScheduleEmployee sampleSchedule = schedules.get(0);
            int assignedCount = 0;
            String message;

            if (morningRoomId > 0 && afternoonRoomId > 0) {
                // Gán phòng riêng biệt cho sáng và chiều cho bất kỳ vai trò nào (Doctor hoặc Nurse)
                assignedCount = schedulesService.assignRoomToDoctorSchedulesInDateRange(sampleSchedule.getSlotId(), morningRoomId, afternoonRoomId, userId, startDate, endDate);
                message = "Đã gán phòng thành công cho " + assignedCount + " lịch trình (sáng: phòng " + morningRoomId + ", chiều: phòng " + afternoonRoomId + ") từ ngày " + startDate + " đến ngày " + endDate;
            } else {
                // Gán chung một phòng cho cả sáng và chiều
                int roomIdToAssign = morningRoomId > 0 ? morningRoomId : afternoonRoomId;
                assignedCount = schedulesService.assignRoomToSchedulesInDateRange(sampleSchedule.getSlotId(), roomIdToAssign, userId, startDate, endDate);
                message = "Đã gán phòng " + roomIdToAssign + " thành công cho " + assignedCount + " lịch trình từ ngày " + startDate + " đến ngày " + endDate;
            }

            if (assignedCount > 0) {
                request.getSession().setAttribute("message", message);
                System.out.println(message + " tại " + LocalDateTime.now() + " +07");
            } else {
                request.getSession().setAttribute("error", "Không thể gán phòng. Có thể tất cả lịch trình trong khoảng thời gian đã được gán hoặc không tồn tại.");
                System.err.println("Không gán được phòng cho người dùng " + userId + " tại " + LocalDateTime.now() + " +07");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID phòng hoặc người dùng không hợp lệ.");
            System.err.println("NumberFormatException trong AssignDoctorNurseToRoom: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
        } catch (SQLException e) {
            request.getSession().setAttribute("error", "Lỗi cơ sở dữ liệu khi gán phòng: " + e.getMessage());
            System.err.println("SQLException trong AssignDoctorNurseToRoom: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("error", e.getMessage());
            System.err.println("IllegalArgumentException trong AssignDoctorNurseToRoom: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi không xác định khi gán phòng: " + e.getMessage());
            System.err.println("Lỗi không xác định trong AssignDoctorNurseToRoom: " + e.getMessage() + " tại " + LocalDateTime.now() + " +07");
            e.printStackTrace();
        }

        String redirectUrl = request.getContextPath() + "/AssignDoctorNurseToRoom?userID=" + userIDStr;
        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
            redirectUrl += "&startDate=" + startDateStr;
        }
        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
            redirectUrl += "&endDate=" + endDateStr;
        }
        response.sendRedirect(redirectUrl);
    }
}