package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.entity.Rooms;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "AddRoomServlet", urlPatterns = {"/AddRoomServlet", "/admin/addRoom"})
public class AddRoomServlet extends HttpServlet {

    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        roomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");

        String roomName = request.getParameter("roomName");
        String description = request.getParameter("description");
        String createdByStr = request.getParameter("createdBy");

        // Store input values to repopulate form on error
        request.setAttribute("roomName", roomName);
        request.setAttribute("description", description);
        request.setAttribute("createdBy", createdByStr);

        try {
            // Validate createdBy
            int createdBy;
            if (createdByStr == null || createdByStr.trim().isEmpty()) {
                createdBy = 1; // Default value
                System.out.println("createdBy not found in request, using default: " + createdBy + " at " + LocalDateTime.now() + " +07");
            } else {
                try {
                    createdBy = Integer.parseInt(createdByStr);
                    if (createdBy <= 0) {
                        throw new NumberFormatException("CreatedBy must be a positive integer");
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Invalid createdBy format: " + createdByStr + " at " + LocalDateTime.now() + " +07");
                    request.setAttribute("error", "ID người tạo không hợp lệ.");
                    request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                    return;
                }
            }

            // Validate roomName and description
            roomName = roomName != null ? roomName.trim() : "";
            description = description != null ? description.trim() : "";
            if (roomName.isEmpty()) {
                request.setAttribute("error", "Tên phòng không được để trống.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                return;
            }

            // Create Rooms object
            Rooms room = new Rooms();
            room.setRoomName(roomName);
            room.setDescription(description);
            room.setStatus("Available"); // Default status

            // Add room using RoomsService
            boolean success = roomService.addRoom(room, createdBy);
            if (success) {
                System.out.println("Room added successfully: RoomName=" + roomName + ", Status=Available at " + LocalDateTime.now() + " +07");
                response.sendRedirect(request.getContextPath() + "/ViewRoomServlet?success=Thêm phòng thành công!");
            } else {
                System.out.println("Failed to add room: RoomName=" + roomName + " at " + LocalDateTime.now() + " +07");
                request.setAttribute("error", "Không thể thêm phòng. Vui lòng thử lại.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            System.out.println("Validation error: " + e.getMessage() + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode() + " at " + LocalDateTime.now() + " +07");
            Logger.getLogger(AddRoomServlet.class.getName()).log(Level.SEVERE, "Database error", e);
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
        }
    }
}