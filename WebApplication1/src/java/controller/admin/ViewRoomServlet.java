package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.entity.Admins;
import model.entity.Rooms;
import model.entity.Users;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ViewRoomServlet", urlPatterns = {"/ViewRoomServlet"})
public class ViewRoomServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ViewRoomServlet.class.getName());
    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        roomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        LOGGER.info("Session check at " + new java.util.Date() + ": Session = " + 
                   (session != null ? "exists, ID: " + session.getId() : "null"));

        if (session == null || (session.getAttribute("admin") == null && session.getAttribute("user") == null)) {
            LOGGER.info("No active session or user/admin found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");

        try {
            String keyword = request.getParameter("keyword");
            String statusFilter = request.getParameter("statusFilter");

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            boolean hasStatus = statusFilter != null && !statusFilter.trim().isEmpty() && !"all".equalsIgnoreCase(statusFilter.trim());

            List<Rooms> roomList;
            String role;
            int userId = -1;

            if (admin != null) {
                role = "admin";
                LOGGER.info("Admin user accessing rooms");
            } else if (user != null) {
                role = user.getRole().toLowerCase();
                userId = user.getUserID();
                LOGGER.info("User accessing rooms - Role: " + role + ", UserID: " + userId);
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            // Handle different user roles
            if ("admin".equals(role) || "receptionist".equals(role)) {
                // Admin and receptionist can see all rooms with search/filter capabilities
                if (hasKeyword && hasStatus) {
                    // Both keyword and status filter
                    roomList = roomService.searchRoomsByKeywordAndStatus(keyword.trim(), statusFilter.trim());
                } else if (hasKeyword && !hasStatus) {
                    // Only keyword search
                    roomList = roomService.searchRooms(keyword.trim());
                } else if (!hasKeyword && hasStatus) {
                    // Only status filter - we need to search by status only
                    roomList = roomService.searchRoomsByKeywordAndStatus("", statusFilter.trim());
                } else {
                    // No filters - get all rooms
                    roomList = roomService.getAllRooms();
                }

                // Set attributes for admin/receptionist view
                request.setAttribute("roomList", roomList);
                request.setAttribute("keyword", keyword);
                request.setAttribute("statusFilter", statusFilter);
                request.setAttribute("isAdmin", "admin".equals(role));
                request.setAttribute("totalRooms", roomList.size());
                
                // Count available rooms
                try {
                    int availableRooms = roomService.countAvailableRooms();
                    request.setAttribute("availableRooms", availableRooms);
                } catch (SQLException e) {
                    LOGGER.log(Level.WARNING, "Could not get available rooms count", e);
                    request.setAttribute("availableRooms", 0);
                }

                request.getRequestDispatcher("/views/admin/ViewRoom.jsp").forward(request, response);

            } else if ("doctor".equals(role) || "nurse".equals(role)) {
                // For doctors and nurses, show all rooms (they might need to see room availability)
                // In a real system, you might want to filter based on their assignments
                roomList = roomService.getAllRooms();
                
                // You could add additional filtering here based on business logic
                // For example, only show rooms where they are assigned or available rooms
                
                request.setAttribute("roomList", roomList);
                request.setAttribute("isAdmin", false);
                request.setAttribute("userRole", role);
                request.setAttribute("userId", userId);
                
                request.getRequestDispatcher("/views/user/DoctorNurse/viewRooms.jsp").forward(request, response);

            } else if ("patient".equals(role)) {
                // Patients should not view room management pages
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Patients are not allowed to view room management.");
                
            } else {
                // Unknown or invalid role
                LOGGER.warning("User with invalid role attempted to access rooms: " + role);
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or undefined role: " + role);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in ViewRoomServlet", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: Không thể tải danh sách phòng.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid argument in ViewRoomServlet", e);
            request.setAttribute("error", "Lỗi tham số: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in ViewRoomServlet", e);
            request.setAttribute("error", "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}