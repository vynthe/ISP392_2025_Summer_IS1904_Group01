package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.ScheduleEmployee;
import model.entity.Users;
import model.service.SchedulesService;
import model.dao.RoomsDAO;
import model.entity.Rooms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "ViewScheduleDetailsServlet", urlPatterns = {"/ViewScheduleDetailsServlet"})
public class ViewScheduleDetailsServlet extends HttpServlet {
    private SchedulesService schedulesService;
    private RoomsDAO roomsDAO;

    @Override
    public void init() throws ServletException {
        roomsDAO = new RoomsDAO();
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

            // Sử dụng ngày hiện tại
            LocalDate currentDate = LocalDate.now(); // 18/07/2025

            List<ScheduleEmployee> schedules = schedulesService.getScheduleByDate(userId, currentDate);
            if (schedules.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy lịch nào cho ngày " + currentDate + " với ID: " + userId);
            } else {
                // Lấy thông tin phòng và dịch vụ cho từng lịch
                for (ScheduleEmployee schedule : schedules) {
                    if (schedule.getRoomId() != null) {
                        Rooms room = roomsDAO.getRoomByID(schedule.getRoomId());
                        request.setAttribute("room_" + schedule.getSlotId(), room);
                        List<String> services = roomsDAO.getServicesByRoomId(schedule.getRoomId());
                        request.setAttribute("services_" + schedule.getSlotId(), services != null && !services.isEmpty() ? services.get(0) : "Chưa gán dịch vụ");
                    }
                }
                request.setAttribute("message", "Đã tải lịch cho ngày " + currentDate);
            }
            request.setAttribute("schedules", schedules);
            request.setAttribute("userId", userId);
            request.setAttribute("viewDate", currentDate);

            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ.");
            request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewSchedules.jsp").forward(request, response);
        }
    }
}