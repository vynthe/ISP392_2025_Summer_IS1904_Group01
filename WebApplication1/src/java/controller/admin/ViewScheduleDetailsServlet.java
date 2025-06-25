package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.SchedulesService;

@WebServlet(name = "ViewScheduleDetailsServlet", urlPatterns = {"/ViewScheduleDetailsServlet"})
public class ViewScheduleDetailsServlet extends HttpServlet {
    private final SchedulesService scheduleService;

    public ViewScheduleDetailsServlet() {
        this.scheduleService = new SchedulesService();
    }

   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Lấy scheduleID từ request parameter và kiểm tra
        String scheduleIdParam = request.getParameter("scheduleID");
        if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
            request.setAttribute("error", "ID lịch không được để trống.");
            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
            return;
        }

        int scheduleID;
        try {
            scheduleID = Integer.parseInt(scheduleIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID lịch không hợp lệ: " + scheduleIdParam);
            request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
            return;
        }

        // Gọi service để lấy chi tiết lịch
        Map<String, Object> scheduleDetails = scheduleService.viewDetailSchedule(scheduleID);

        // Đặt dữ liệu vào request attribute để gửi đến JSP
        request.setAttribute("scheduleDetails", scheduleDetails);

        // Chuyển hướng đến JSP để hiển thị
        request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
    } catch (SQLException | ClassNotFoundException e) {
        request.setAttribute("error", "Lỗi khi lấy chi tiết lịch: " + e.getMessage());
        request.getRequestDispatcher("/views/admin/ViewScheduleDetails.jsp").forward(request, response);
    }
}
}