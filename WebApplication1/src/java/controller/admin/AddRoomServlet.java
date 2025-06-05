package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;

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
        String doctorIDStr = request.getParameter("doctorID");
        String nurseIDStr = request.getParameter("nurseID");

        request.setAttribute("roomName", roomName);
        request.setAttribute("description", description);
        request.setAttribute("doctorID", doctorIDStr);
        request.setAttribute("nurseID", nurseIDStr);

        Integer doctorID;
        Integer nurseID;
        try {
            doctorID = (doctorIDStr != null && !doctorIDStr.trim().isEmpty()) ? Integer.parseInt(doctorIDStr) : null;
            nurseID = (nurseIDStr != null && !nurseIDStr.trim().isEmpty()) ? Integer.parseInt(nurseIDStr) : null;
            if (doctorID != null && doctorID <= 0) {
                throw new NumberFormatException("Doctor ID must be a positive integer");
            }
            if (nurseID != null && nurseID <= 0) {
                throw new NumberFormatException("Nurse ID must be a positive integer");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid ID format: DoctorID=" + doctorIDStr + ", NurseID=" + nurseIDStr + " at " + LocalDateTime.now() + " +07");
            request.setAttribute("error", "Doctor ID và Nurse ID phải là số nguyên dương.");
            request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
            return;
        }

        // Set default status to "Available" instead of taking it from request
        String status = "Available";

        try {
            String createdByStr = request.getParameter("createdBy");
            Integer createdBy = null;
            if (createdByStr == null || createdByStr.trim().isEmpty()) {
                createdBy = 1;
                System.out.println("createdBy not found in request, using default: " + createdBy + " at " + LocalDateTime.now() + " +07");
            } else {
                try {
                    createdBy = Integer.parseInt(createdByStr);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid createdBy format: " + createdByStr + " at " + LocalDateTime.now() + " +07");
                    request.setAttribute("error", "ID người tạo không hợp lệ.");
                    request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                    return;
                }
            }

            roomName = roomName != null ? roomName.trim() : "";
            description = description != null ? description.trim() : "";

            // Check if doctorID or nurseID is already assigned to another room
            if (doctorID != null && roomService.isDoctorAssigned(doctorID)) {
                request.setAttribute("error", "Bác sĩ với ID " + doctorID + " đã được gán cho một phòng khác.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                return;
            }
            if (nurseID != null && roomService.isNurseAssigned(nurseID)) {
                request.setAttribute("error", "Y tá với ID " + nurseID + " đã được gán cho một phòng khác.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                return;
            }

            boolean success = roomService.addRoom(roomName, description, doctorID, nurseID, status, createdBy);
            if (success) {
                System.out.println("Room added successfully: RoomName=" + roomName + ", Status=" + status + " at " + LocalDateTime.now() + " +07");
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
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
        }
    }
}