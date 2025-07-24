package controller.admin;

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
        // Lấy tham số phân trang
        int page = 1;
        int pageSize = 10;
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
            if (request.getParameter("pageSize") != null) {
                pageSize = Integer.parseInt(request.getParameter("pageSize"));
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid page or pageSize parameter.");
        }

        try {
            // Gọi service để lấy danh sách lịch hẹn
            List<Map<String, Object>> appointments = appointmentService.getAllAppointments(page, pageSize);
            request.setAttribute("appointments", appointments);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);

            // Chuyển hướng tới JSP
            request.getRequestDispatcher("/views/user/Receptionist/bookingList.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Error retrieving appointments: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid input: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}