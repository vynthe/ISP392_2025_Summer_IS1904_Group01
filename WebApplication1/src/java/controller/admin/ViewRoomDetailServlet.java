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

@WebServlet(name = "ViewRoomDetailServlet", urlPatterns = {"/ViewRoomDetailServlet"})
public class ViewRoomDetailServlet extends HttpServlet {

    private RoomService userService;

    @Override
    public void init() throws ServletException {
        userService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomIDParam = request.getParameter("id");
        if (roomIDParam == null || roomIDParam.trim().isEmpty()) {
            request.setAttribute("error", "ID phòng không hợp lệ.");
            request.getRequestDispatcher("/views/admin/ViewRoomDetail.jsp").forward(request, response);
            return;
        }

        try {
            int roomID = Integer.parseInt(roomIDParam);
            Rooms room = userService.getRoomByID(roomID);
            if (room != null) {
                request.setAttribute("room", room);
            } else {
                request.setAttribute("error", "Không tìm thấy phòng với ID: " + roomID);
            }
        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Lỗi khi tải thông tin phòng: " + e.getMessage());
        }
        request.getRequestDispatcher("/views/admin/ViewRoomDetail.jsp").forward(request, response);
    }
}
