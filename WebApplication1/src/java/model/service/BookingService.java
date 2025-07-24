package model.service;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.dao.BookingDAO;
import model.entity.Booking;

/**
 * Service class for managing appointment bookings
 * Provides business logic layer between controllers and DAO
 */
public class BookingService {
    
    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 5; // Đặt mặc định là 5 để nhất quán với yêu cầu
    private static final int MAX_PAGE_SIZE = 100;
    
    private final BookingDAO bookingDAO;

    public BookingService() {
        this.bookingDAO = new BookingDAO();
    }

    /**
     * Constructor for dependency injection (useful for testing)
     * 
     * @param bookingDAO the BookingDAO instance to use
     */
    public BookingService(BookingDAO bookingDAO) {
        this.bookingDAO = bookingDAO;
    }

    /**
     * Retrieves all bookings (without pagination)
     * Note: Use with caution for large datasets
     *
     * @return a list of all Booking objects
     * @throws SQLException if a database error occurs
     */
    public List<Booking> getAllBookings() throws SQLException {
        try {
            List<Booking> bookings = bookingDAO.getAllBookings();
            LOGGER.info("Retrieved " + bookings.size() + " bookings");
            return bookings;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all bookings", e);
            throw e;
        }
    }

    /**
     * Retrieves bookings with pagination
     *
     * @param page     the page number (starting from 1)
     * @param pageSize the number of bookings per page (max 100)
     * @return a list of Booking objects for the specified page
     * @throws SQLException if a database error occurs
     * @throws IllegalArgumentException if pageSize is invalid
     */
    public List<Booking> getBookingsWithPagination(int page, int pageSize) throws SQLException {
        // Validate and normalize parameters
        page = Math.max(1, page);
        pageSize = validatePageSize(pageSize);
        
        int offset = (page - 1) * pageSize;
        
        try {
            LOGGER.info(String.format("Fetching bookings for page=%d, pageSize=%d, offset=%d", 
                       page, pageSize, offset));
            List<Booking> bookings = bookingDAO.getBookingsWithPagination(offset, pageSize);
            LOGGER.info(String.format("Retrieved %d bookings for page %d (pageSize: %d, offset: %d)", 
                       bookings.size(), page, pageSize, offset));
            if (bookings.isEmpty() && page > 1) {
                LOGGER.warning(String.format("No bookings found for page %d with offset=%d, limit=%d", 
                           page, offset, pageSize));
            }
            return bookings;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, 
                      String.format("Error retrieving bookings for page %d with pageSize %d, offset %d: %s", 
                                  page, pageSize, offset, e.getMessage()), e);
            throw e;
        }
    }

    /**
     * Counts the total number of bookings
     *
     * @return the total number of bookings
     * @throws SQLException if a database error occurs
     */
    public int countAllBookings() throws SQLException {
        try {
            int count = bookingDAO.countAllBookings();
            LOGGER.info("Total bookings count: " + count);
            return count;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting all bookings", e);
            throw e;
        }
    }

    /**
     * Searches bookings by keyword and status with pagination
     *
     * @param keyword  the search term for patient name, phone, or email (can be null/empty)
     * @param status   the booking status to filter (can be null/empty)
     * @param page     the page number (starting from 1)
     * @param pageSize the number of bookings per page (max 100)
     * @return a list of Booking objects matching the criteria
     * @throws SQLException if a database error occurs
     * @throws IllegalArgumentException if pageSize is invalid
     */
    public List<Booking> searchBookings(String keyword, String status, int page, int pageSize) throws SQLException {
        // Validate and normalize parameters
        page = Math.max(1, page);
        pageSize = validatePageSize(pageSize);
        keyword = normalizeSearchKeyword(keyword);
        status = normalizeStatus(status);
        
        int offset = (page - 1) * pageSize;
        
        try {
            LOGGER.info(String.format("Searching bookings with keyword='%s', status='%s', page=%d, pageSize=%d, offset=%d", 
                       keyword, status, page, pageSize, offset));
            List<Booking> bookings = bookingDAO.searchBookings(keyword, status, offset, pageSize);
            LOGGER.info(String.format("Search returned %d bookings for keyword='%s', status='%s', page=%d", 
                       bookings.size(), keyword, status, page));
            if (bookings.isEmpty() && page > 1) {
                LOGGER.warning(String.format("No search results found for page %d with offset=%d, limit=%d", 
                           page, offset, pageSize));
            }
            return bookings;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, 
                      String.format("Error searching bookings with keyword='%s', status='%s', page=%d, offset=%d: %s", 
                                  keyword, status, page, offset, e.getMessage()), e);
            throw e;
        }
    }

    /**
     * Counts bookings matching the search criteria
     *
     * @param keyword the search term for patient name, phone, or email (can be null/empty)
     * @param status  the booking status to filter (can be null/empty)
     * @return the number of matching bookings
     * @throws SQLException if a database error occurs
     */
    public int countSearchBookings(String keyword, String status) throws SQLException {
        keyword = normalizeSearchKeyword(keyword);
        status = normalizeStatus(status);
        
        try {
            int count = bookingDAO.countSearchBookings(keyword, status);
            LOGGER.info(String.format("Search count for keyword='%s', status='%s': %d", 
                       keyword, status, count));
            return count;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, 
                      String.format("Error counting search results for keyword='%s', status='%s': %s", 
                                  keyword, status, e.getMessage()), e);
            throw e;
        }
    }

    /**
     * Calculates the total number of pages for pagination
     *
     * @param totalItems the total number of items
     * @param pageSize   the number of items per page
     * @return the total number of pages
     */
    public int calculateTotalPages(int totalItems, int pageSize) {
        if (totalItems <= 0 || pageSize <= 0) {
            return 0;
        }
        return (int) Math.ceil((double) totalItems / pageSize);
    }

    /**
     * Gets pagination info for search results
     *
     * @param keyword  the search keyword
     * @param status   the status filter
     * @param page     current page
     * @param pageSize page size
     * @return PaginationInfo object
     * @throws SQLException if database error occurs
     */
    public PaginationInfo getSearchPaginationInfo(String keyword, String status, int page, int pageSize) 
            throws SQLException {
        int totalItems = countSearchBookings(keyword, status);
        int totalPages = calculateTotalPages(totalItems, pageSize);
        
        LOGGER.info(String.format("Search pagination info: totalItems=%d, totalPages=%d, page=%d, pageSize=%d", 
                   totalItems, totalPages, page, pageSize));
        return new PaginationInfo(page, pageSize, totalItems, totalPages);
    }

    /**
     * Gets pagination info for all bookings
     *
     * @param page     current page
     * @param pageSize page size
     * @return PaginationInfo object
     * @throws SQLException if database error occurs
     */
    public PaginationInfo getAllBookingsPaginationInfo(int page, int pageSize) throws SQLException {
        int totalItems = countAllBookings();
        int totalPages = calculateTotalPages(totalItems, pageSize);
        
        LOGGER.info(String.format("All bookings pagination info: totalItems=%d, totalPages=%d, page=%d, pageSize=%d", 
                   totalItems, totalPages, page, pageSize));
        return new PaginationInfo(page, pageSize, totalItems, totalPages);
    }

    // Private helper methods

    /**
     * Validates and normalizes page size
     */
    private int validatePageSize(int pageSize) {
        if (pageSize <= 0) {
            LOGGER.warning("Invalid pageSize: " + pageSize + ". Using default: " + DEFAULT_PAGE_SIZE);
            return DEFAULT_PAGE_SIZE;
        }
        if (pageSize > MAX_PAGE_SIZE) {
            LOGGER.warning("PageSize too large: " + pageSize + ". Using max: " + MAX_PAGE_SIZE);
            return MAX_PAGE_SIZE;
        }
        return pageSize;
    }

    /**
     * Normalizes search keyword
     */
    private String normalizeSearchKeyword(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return null;
        }
        
        String normalized = keyword.trim();
        if (normalized.length() > 100) {
            LOGGER.warning("Search keyword too long, truncating: " + normalized.substring(0, 20) + "...");
            normalized = normalized.substring(0, 100);
        }
        
        return normalized;
    }

    /**
     * Normalizes status filter
     */
    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return null;
        }
        
        String normalized = status.trim();
        switch (normalized.toLowerCase()) {
            case "pending":
                return "Pending";
            case "confirmed":
                return "Confirmed";
            case "completed":
                return "Completed";
            case "cancelled":
                return "Cancelled";
            default:
                LOGGER.warning("Unknown status filter: " + normalized);
                return normalized;
        }
    }

    /**
     * Inner class to hold pagination information
     */
    public static class PaginationInfo {
        private final int currentPage;
        private final int pageSize;
        private final int totalItems;
        private final int totalPages;

        public PaginationInfo(int currentPage, int pageSize, int totalItems, int totalPages) {
            this.currentPage = currentPage;
            this.pageSize = pageSize;
            this.totalItems = totalItems;
            this.totalPages = totalPages;
        }

        // Getters
        public int getCurrentPage() { return currentPage; }
        public int getPageSize() { return pageSize; }
        public int getTotalItems() { return totalItems; }
        public int getTotalPages() { return totalPages; }
        
        public boolean hasNextPage() { return currentPage < totalPages; }
        public boolean hasPreviousPage() { return currentPage > 1; }
        public int getStartItem() { return totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1; }
        public int getEndItem() { return Math.min(currentPage * pageSize, totalItems); }

        @Override
        public String toString() {
            return String.format("Page %d of %d (showing %d-%d of %d items)", 
                               currentPage, totalPages, getStartItem(), getEndItem(), totalItems);
        }
    }
}