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

@WebServlet(name = "ViewRoomServlet", urlPatterns = {"/ViewRoomServlet"})
public class ViewRoomServlet extends HttpServlet {
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
        System.out.println("Session check at " + new java.util.Date() + ": Session = " + (session != null ? "exists, ID: " + session.getId() : "null"));

        if (session == null || (session.getAttribute("admin") == null && session.getAttribute("user") == null)) {
            System.out.println("No active session or user/admin found. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Admins admin = (Admins) session.getAttribute("admin");
        Users user = (Users) session.getAttribute("user");

        try {
            String keyword = request.getParameter("keyword");
            boolean isSearching = keyword != null && !keyword.trim().isEmpty();
            List<Rooms> roomList;
            String role;
            int userId = -1;

            if (admin != null) {
                role = "admin";
            } else if (user != null) {
                role = user.getRole().toLowerCase();
                userId = user.getUserID();
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            System.out.println("Role: " + role + ", UserID: " + userId);

            // Xử lý điều hướng tuần
            String action = request.getParameter("action");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            java.util.Map<String, Object> scheduleFull;
            if (startDate != null && endDate != null && ("prev".equals(action) || "next".equals(action))) {
                // Tính tuần mới
                java.time.LocalDate start = java.time.LocalDate.parse(startDate);
                java.time.LocalDate end = java.time.LocalDate.parse(endDate);
                int days = (int) java.time.temporal.ChronoUnit.DAYS.between(start, end);
                if ("prev".equals(action)) {
                    start = start.minusDays(days + 1);
                    end = end.minusDays(days + 1);
                } else if ("next".equals(action)) {
                    start = start.plusDays(days + 1);
                    end = end.plusDays(days + 1);
                }
                scheduleFull = roomService.getWeeklyScheduleByRange(start.toString(), end.toString());
            } else if (startDate != null && endDate != null) {
                scheduleFull = roomService.getWeeklyScheduleByRange(startDate, endDate);
            } else {
                scheduleFull = roomService.getWeeklyScheduleFull();
            }
            request.setAttribute("scheduleData", scheduleFull.get("scheduleData"));
            request.setAttribute("days", scheduleFull.get("days"));
            request.setAttribute("dayNameMap", scheduleFull.get("dayNameMap"));
            request.setAttribute("startDate", scheduleFull.get("startDate"));
            request.setAttribute("endDate", scheduleFull.get("endDate"));

            int pageSize = 3;
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                }
            } catch (Exception e) { page = 1; }

            if ("admin".equals(role) || "receptionist".equals(role)) {
                roomList = isSearching ? roomService.searchRooms(keyword) : roomService.getAllRooms();
                int totalRooms = roomList.size();
                int totalPages = (int) Math.ceil((double) totalRooms / pageSize);
                if (page > totalPages) page = totalPages > 0 ? totalPages : 1;
                if (page < 1) page = 1;
                int fromIndex = (page - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, totalRooms);
                List<model.entity.Rooms> pagedRooms = (fromIndex < toIndex) ? roomList.subList(fromIndex, toIndex) : new java.util.ArrayList<>();
                request.setAttribute("roomList", pagedRooms);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("keyword", keyword);
                request.setAttribute("isAdmin", "admin".equals(role));
                request.getRequestDispatcher("/views/admin/ViewRoom.jsp").forward(request, response);

            } else if ("doctor".equals(role) || "nurse".equals(role)) {
                roomList = roomService.getRoomsByUserIdAndRole(userId, role);
                request.setAttribute("roomList", roomList);
                request.setAttribute("isAdmin", false);
                request.getRequestDispatcher("/views/user/DoctorNurse/viewRooms.jsp").forward(request, response);

            } else if ("patient".equals(role)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Patients are not allowed to view rooms.");
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid or undefined role.");
            }

        } catch (SQLException e) {
            System.err.println("SQL Error in ViewRoomServlet at " + new java.util.Date() + ": " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
