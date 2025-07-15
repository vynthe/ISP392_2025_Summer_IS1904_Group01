package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.service.RoomService;

import java.io.IOException;
import java.sql.SQLException;
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

        // Lấy các tham số từ request
        String roomName = request.getParameter("roomName");
        String description = request.getParameter("description");
        String doctorIDStr = request.getParameter("doctorID");
        String nurseIDStr = request.getParameter("nurseID");
        String createdByStr = request.getParameter("createdBy");

        // Lưu giá trị vào request để hiển thị lại trên form nếu có lỗi
        request.setAttribute("roomName", roomName);
        request.setAttribute("description", description);
        request.setAttribute("doctorID", doctorIDStr);
        request.setAttribute("nurseID", nurseIDStr);
        request.setAttribute("createdBy", createdByStr);

        try {
            // Kiểm tra và chuyển đổi doctorID, nurseID
            Integer doctorID = (doctorIDStr != null && !doctorIDStr.trim().isEmpty()) 
                ? Integer.parseInt(doctorIDStr) 
                : null;
            Integer nurseID = (nurseIDStr != null && !nurseIDStr.trim().isEmpty()) 
                ? Integer.parseInt(nurseIDStr) 
                : null;
            Integer createdBy = (createdByStr != null && !createdByStr.trim().isEmpty()) 
                ? Integer.parseInt(createdByStr) 
                : 1; // Mặc định createdBy = 1 nếu không có giá trị

            // Kiểm tra cơ bản đầu vào
            if (roomName == null || roomName.trim().isEmpty()) {
                request.setAttribute("error", "Tên phòng không được để trống.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                return;
            }
            if (doctorID != null && doctorID <= 0) {
                request.setAttribute("error", "Doctor ID phải là số nguyên dương.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                return;
            }
            if (nurseID != null && nurseID <= 0) {
                request.setAttribute("error", "Nurse ID phải là số nguyên dương.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                return;
            }
            if (createdBy <= 0) {
                request.setAttribute("error", "ID người tạo không hợp lệ.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
                return;
            }

            // Gọi phương thức addRoom từ RoomService
            boolean success = roomService.addRoom(roomName, description, doctorID, nurseID, "Available", createdBy);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/ViewRoomServlet?success=Thêm phòng thành công!");
            } else {
                request.setAttribute("error", "Không thể thêm phòng. Vui lòng thử lại.");
                request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Doctor ID, Nurse ID hoặc ID người tạo phải là số nguyên hợp lệ.");
            request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/AddRoom.jsp").forward(request, response);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(AddRoomServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}