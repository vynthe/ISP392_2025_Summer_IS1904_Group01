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
        response.setContentType("text/html; charset=UTF-8");

        String keyword = request.getParameter("keyword"); // lấy từ form tìm kiếm

        try {
            List<Rooms> roomList;

            if (keyword != null && !keyword.trim().isEmpty()) {
                // Nếu có từ khóa thì tìm kiếm
                roomList = roomService.searchRooms(keyword.trim());
            } else {
                // Nếu không thì lấy tất cả phòng
                roomList = roomService.getAllRooms();
            }

            request.setAttribute("roomList", roomList);
            request.setAttribute("keyword", keyword); // để giữ lại giá trị trong ô tìm kiếm

        } catch (SQLException e) {
            System.err.println("Lỗi SQL khi lấy danh sách phòng: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi tải danh sách phòng: " + e.getMessage());
        }

        // Luôn chuyển tiếp đến ViewRoom.jsp
        request.getRequestDispatcher("/views/admin/ViewRoom.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
