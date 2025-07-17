package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Booking;
import model.service.BookingService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet để xử lý hiển thị danh sách các cuộc hẹn khám bệnh (booking)
 * 
 * URL: /admin/bookings
 * 
 * @author exorc
 */
@WebServlet(name = "BookingServlet", urlPatterns = {"/BookingServlet","/admin/bookings"})
public class ViewBookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Booking> bookings = bookingService.getAllBookings();
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/views/user/Receptionist/bookingList.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("SQLException in BookingServlet: " + e.getMessage() + " at " + java.time.LocalDateTime.now() + " +07");
            request.setAttribute("errorMessage", "Lỗi khi truy vấn dữ liệu lịch hẹn.");
            request.getRequestDispatcher("/WEB-INF/views/error.jsp").forward(request, response);
        }
    }
}
