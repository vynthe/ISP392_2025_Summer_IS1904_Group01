package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.dao.BookingDAO;
import model.entity.Booking;

@WebServlet(name = "BookingServlet", urlPatterns = {"/BookingServlet"})
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Booking> bookings = bookingDAO.getAllBookings();
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/views/user/Receptionist/bookingList.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace(); // hoặc dùng Logger
            request.setAttribute("error", "Lỗi khi tải danh sách lịch hẹn.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
