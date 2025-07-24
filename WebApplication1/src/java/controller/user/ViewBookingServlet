
package controller.user;

import controller.admin.*;
import model.service.AppointmentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@WebServlet("/ViewBookingServlet")
public class ViewBookingServlet extends HttpServlet {

    private final AppointmentService appointmentService;

    public ViewBookingServlet() {
        this.appointmentService = new AppointmentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tham số phân trang và từ khóa tìm kiếm
        int page = 1;
        int pageSize = 10;
        String keyword = request.getParameter("keyword");

        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Tham số page hoặc pageSize không hợp lệ.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
            return;
        }

        try {
            // Gọi service để lấy danh sách lịch hẹn với tìm kiếm
            AppointmentService.AppointmentSearchResult result = appointmentService.searchAppointments(page, pageSize, keyword);

            // Đặt các thuộc tính cho JSP
            request.setAttribute("appointments", result.getAppointments());
            request.setAttribute("currentPage", result.getCurrentPage());
            request.setAttribute("pageSize", result.getPageSize());
            request.setAttribute("totalPages", result.getTotalPages());

            // Chuyển hướng tới JSP
            request.getRequestDispatcher("/views/user/Receptionist/bookingList.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi khi truy xuất danh sách lịch hẹn: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Dữ liệu đầu vào không hợp lệ: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
