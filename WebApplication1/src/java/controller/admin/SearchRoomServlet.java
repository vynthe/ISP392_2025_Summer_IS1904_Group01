package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.entity.Rooms;
import model.service.RoomService;

import java.io.IOException;
import java.util.List;

@WebServlet("/SearchRoomServlet")
public class SearchRoomServlet extends HttpServlet {
    private RoomService RoomService;

    @Override
    public void init() {
        RoomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        try {
            List<Rooms> result = RoomService.searchRooms(keyword);
            request.setAttribute("roomList", result);
            request.getRequestDispatcher("/views/admin/ViewRoom.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/admin/ViewRoomL.jsp").forward(request, response);
        }
    }
}
