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
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "UpdateRoomServlet", urlPatterns = {"/UpdateRoomServlet"})
public class UpdateRoomServlet extends HttpServlet {

    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        roomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIDParam = request.getParameter("id");
        if (roomIDParam != null && !roomIDParam.isEmpty()) {
            try {
                int roomID = Integer.parseInt(roomIDParam);
                Rooms room = roomService.getRoomByID(roomID);
                if (room != null) {
                    request.setAttribute("room", room);
                    request.getRequestDispatcher("/views/admin/UpdateRoom.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Không tìm thấy phòng để chỉnh sửa.");
                    request.getRequestDispatcher("/views/admin/UpdateRoom.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID phòng không hợp lệ: " + e.getMessage());
                request.getRequestDispatcher("/views/admin/UpdateRoom.jsp").forward(request, response);
            } catch (SQLException e) {
                Logger.getLogger(UpdateRoomServlet.class.getName()).log(Level.SEVERE, "Database error", e);
                request.setAttribute("error", "Lỗi cơ sở dữ liệu khi tải thông tin phòng.");
                request.getRequestDispatcher("/views/admin/UpdateRoom.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Lỗi: " + e.getMessage());
                request.getRequestDispatcher("/views/admin/UpdateRoom.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "ID phòng không hợp lệ.");
            request.getRequestDispatcher("/views/admin/UpdateRoom.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIDParam = request.getParameter("roomID");
        String roomName = request.getParameter("roomName");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        // Validate roomID first
        if (roomIDParam == null || roomIDParam.trim().isEmpty()) {
            handleError(request, response, "ID phòng không hợp lệ.", null,
                    roomName, description, status);
            return;
        }

        int roomID;
        Rooms existingRoom;

        try {
            roomID = Integer.parseInt(roomIDParam);
            existingRoom = roomService.getRoomByID(roomID);
            if (existingRoom == null) {
                handleError(request, response, "Không tìm thấy phòng với ID: " + roomID, null,
                        roomName, description, status);
                return;
            }
        } catch (NumberFormatException e) {
            handleError(request, response, "ID phòng phải là số nguyên hợp lệ.", null,
                    roomName, description, status);
            return;
        } catch (SQLException e) {
            Logger.getLogger(UpdateRoomServlet.class.getName()).log(Level.SEVERE, "Database error", e);
            handleError(request, response, "Lỗi cơ sở dữ liệu khi tải thông tin phòng.", null,
                    roomName, description, status);
            return;
        } catch (IllegalArgumentException e) {
            handleError(request, response, "Lỗi: " + e.getMessage(), null,
                    roomName, description, status);
            return;
        }

        try {
            // Validate input data
            if (roomName == null || roomName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên phòng không được để trống.");
            }

            // Validate và chuẩn hóa status theo constraint DB
            String[] validStatuses = {"Completed", "In Progress", "Not Available", "Available"};
            if (status == null || status.trim().isEmpty()) {
                status = "Available"; // mặc định nếu không nhập
            } else {
                status = status.trim();
                boolean valid = false;
                for (String s : validStatuses) {
                    if (s.equalsIgnoreCase(status)) {
                        status = s; // chuẩn hóa case đúng
                        valid = true;
                        break;
                    }
                }
                if (!valid) {
                    throw new IllegalArgumentException("Trạng thái không hợp lệ. Vui lòng chọn: Available, In Progress, Completed, hoặc Not Available.");
                }
            }

            // Create updated room object
            Rooms room = new Rooms();
            room.setRoomID(roomID);
            room.setRoomName(roomName.trim());
            room.setDescription(description != null ? description.trim() : "");
            room.setStatus(status);
            // Note: CreatedBy, CreatedAt, UpdatedAt will be handled by DAO

            // Update room using service layer
            boolean updated = roomService.updateRoom(room);
            if (updated) {
                // Success - redirect to view rooms page
                response.sendRedirect(request.getContextPath() + "/ViewRoomServlet");
            } else {
                handleError(request, response, "Không thể cập nhật thông tin phòng. Vui lòng thử lại.", existingRoom,
                        roomName, description, status);
            }

        } catch (IllegalArgumentException e) {
            // Handle validation errors from service layer
            handleError(request, response, "Lỗi: " + e.getMessage(), existingRoom,
                    roomName, description, status);
        } catch (SQLException e) {
            // Handle database errors
            Logger.getLogger(UpdateRoomServlet.class.getName()).log(Level.SEVERE, "Database error during update", e);
            handleError(request, response, "Lỗi cơ sở dữ liệu khi cập nhật phòng.", existingRoom,
                    roomName, description, status);
        }
    }

    /**
     * Helper method to handle errors by setting appropriate request attributes
     * and forwarding to the update page.
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage, Rooms room,
                             String roomName, String description, String status)
            throws ServletException, IOException {
        request.setAttribute("room", room);
        request.setAttribute("error", errorMessage);
        request.setAttribute("formRoomName", roomName);
        request.setAttribute("formDescription", description);
        request.setAttribute("formStatus", status != null ? status : "Available");
        request.getRequestDispatcher("/views/admin/UpdateRoom.jsp").forward(request, response);
    }
}