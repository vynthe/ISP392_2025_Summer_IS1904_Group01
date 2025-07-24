package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.BookingService;
import model.entity.Booking;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "BookingServlet", urlPatterns = {"/BookingServlet"})
public class BookingServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(BookingServlet.class.getName());
    private static final int PAGE_SIZE = 5; // Đặt mặc định là 5 để nhất quán với BookingService
    private static final int MAX_PAGE_SIZE = 50;
    
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy và validate parameters
            String keyword = sanitizeInput(request.getParameter("keyword"));
            String statusFilter = sanitizeInput(request.getParameter("statusFilter"));
            int page = parseIntParam(request.getParameter("page"), 1);
            int pageSize = Math.min(parseIntParam(request.getParameter("pageSize"), PAGE_SIZE), MAX_PAGE_SIZE);
            
            // Validate page number
            if (page < 1) page = 1;

            LOGGER.info(String.format("Processing request: page=%d, pageSize=%d, keyword='%s', statusFilter='%s'", 
                       page, pageSize, keyword, statusFilter));

            // Fetch bookings
            List<Booking> bookings;
            int totalBookings;
            
            boolean hasSearchCriteria = (keyword != null && !keyword.isEmpty()) || 
                                       (statusFilter != null && !statusFilter.isEmpty());
            
            if (hasSearchCriteria) {
                bookings = bookingService.searchBookings(keyword, statusFilter, page, pageSize);
                totalBookings = bookingService.countSearchBookings(keyword, statusFilter);
                LOGGER.info(String.format("Search returned %d bookings, total=%d", bookings.size(), totalBookings));
            } else {
                bookings = bookingService.getBookingsWithPagination(page, pageSize);
                totalBookings = bookingService.countAllBookings();
                LOGGER.info(String.format("Pagination returned %d bookings, total=%d", bookings.size(), totalBookings));
            }

            // Null safety
            if (bookings == null) {
                bookings = new ArrayList<>();
                LOGGER.warning("Bookings list was null, initialized empty list");
            }

            // Calculate pagination
            int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
            if (page > totalPages) {
                page = totalPages > 0 ? totalPages : 1;
                LOGGER.info(String.format("Adjusted page from %d to %d due to exceeding totalPages=%d", 
                           page, page, totalPages));
            }

            // Set attributes
            request.setAttribute("bookings", bookings);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("keyword", keyword);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("hasSearchCriteria", hasSearchCriteria);
            
            // Pagination info
            request.setAttribute("hasNextPage", page < totalPages);
            request.setAttribute("hasPreviousPage", page > 1);
            request.setAttribute("startItem", totalBookings == 0 ? 0 : (page - 1) * pageSize + 1);
            request.setAttribute("endItem", Math.min(page * pageSize, totalBookings));

            LOGGER.info(String.format("Forwarding to JSP with bookings.size=%d, totalPages=%d, currentPage=%d", 
                       bookings.size(), totalPages, page));

            request.getRequestDispatcher("/views/user/Receptionist/bookingList.jsp").forward(request, response);
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi hệ thống khi tải danh sách lịch hẹn. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error: " + e.getMessage(), e);
            request.setAttribute("error", "Đã xảy ra lỗi không mong muốn. Vui lòng liên hệ quản trị viên.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Sanitize input string
     */
    private String sanitizeInput(String input) {
        if (input == null || input.trim().isEmpty()) {
            return null;
        }
        
        String sanitized = input.trim()
            .replaceAll("[<>\"'&]", "")  // Remove dangerous chars
            .replaceAll("\\s+", " ");    // Normalize whitespace
            
        // Length limit
        if (sanitized.length() > 100) {
            sanitized = sanitized.substring(0, 100);
        }
        
        return sanitized.isEmpty() ? null : sanitized;
    }

    /**
     * Parse integer parameter with default
     */
    private int parseIntParam(String param, int defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid integer parameter: " + param);
            return defaultValue;
        }
    }
}