package model.service;

import java.sql.SQLException;
import java.util.List;
import model.dao.BookingDAO;
import model.entity.Booking;

public class BookingService {

    private final BookingDAO bookingDAO;

    public BookingService() {
        this.bookingDAO = new BookingDAO();
    }


    public List<Booking> getAllBookings() throws SQLException {
        return bookingDAO.getAllBookings();
    }
}
