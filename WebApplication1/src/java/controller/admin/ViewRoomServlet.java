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

            if ("admin".equals(role) || "receptionist".equals(role)) {
                roomList = isSearching ? roomService.searchRooms(keyword) : roomService.getAllRooms();
                request.setAttribute("roomList", roomList);
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
